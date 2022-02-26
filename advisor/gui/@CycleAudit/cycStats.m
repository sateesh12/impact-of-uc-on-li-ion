function [velbar, accbar, decbar, velmax, accmax, decmax, hist, driveTime, velbarDrive, nStarts, nStops, vbarDist] = cycStats(cyc, bin)
% function [velbar, accbar, decbar, velmax, accmax, decmax, hist, driveTime, velbarDrive, nStarts, nStops, vbarDist] = cycStats(cyc, bin)
% [velbar, accbar, decbar, velmax, accmax, decmax, hist] = cycStats(cyc, bins); 
%
% bins is an optional structure containing the bins of speeds in miles per hour 
% and accelerations in m/s/s to run on the histogram
% if not specified, increments of 5 mph and 0.1 m/s/s are used
%
% runs various statistics on the drive cycle, returns:
% velbar, cycle averaged velocity [m/s]
% accbar, average acceleration during periods of acceleration [m/s/s]
% decbar, average deceleration during periods of deceleration [m/s/s]
% velmax, the maximum speed during the cycle [m/s]
% accmax, the maximum acceleration during the cycle [m/s/s]
% decmax, the minimum deceleration during the cycle [m/s/s]
% hist, a structure with fields vel and acc for velocity and accel respectively. 
% --> the fields below that are "bin", "time", and "percentTime" giving the binned amounts for
%     
%           in the given speed regimes (note: speeds are in miles per hour

diffTime=diff(cyc.t);
zeroIndex=find(diffTime==0);
diffTime(zeroIndex)=eps; % protect from divide by zero--should approximating infinity for instantaneous accelerations
diffVel =diff(cyc.v);
diffHt  =diff(cyc.h);
tMax=max(cyc.t);

accel=diffVel./diffTime;
dhdt =diffHt./diffTime;
vave=conv(cyc.v,[0.5;0.5]);
vave=vave(2:end-1);
vaveDriving=vave(find(vave>0));
timeDriving=diffTime(find(vave>0));

driveTime=sum(timeDriving);
velbarDrive = sum(vaveDriving.*timeDriving)/driveTime;

% process return values
velbar=trapz(cyc.t,cyc.v)/trapz(cyc.t,ones(size(cyc.t)));
if sum(diffTime(find(accel>0)))==0
    accbar=0;
else
    accbar=sum(accel(find(accel>0)).*diffTime(find(accel>0)))/sum(diffTime(find(accel>0)));
end
if sum(diffTime(find(accel<0)))==0
    decbar=0;
else
    decbar=sum(accel(find(accel<0)).*diffTime(find(accel<0)))/sum(diffTime(find(accel<0)));
end
velmax=max(cyc.v);
accmax=max(accel(find(accel>0)));
decmax=min(accel(find(accel<0)));

if isempty(velbar) | isnan(velbar)
    velbar=0;
end
if isempty(accbar) | isnan(accbar)
    accbar=0;
end
if isempty(decbar) | isnan(decbar)
    decbar=0;
end
if isempty(velmax) | isnan(velmax)
    velmax=0;
end
if isempty(accmax) | isnan(accmax)
    accmax=0;
end
if isempty(decmax) | isnan(decmax)
    decmax=0;
end

% setup the bins for the histogram
hist.vel.bin(1,:)=[-inf 0];
% note: the 2.236936 converts m/s to mph
for i=2:(floor(max(vave*2.236936)/5)+(mod(max(vave*2.236936),5)>0)+1)
    hist.vel.bin(i,:)=[5*(i-2), 5*(i-1)];
end

maxDecel=decmax;
if maxDecel<-20 % limit in case we have a divide by eps
    maxDecel=-20;
end
numDecel=floor(abs(maxDecel)/0.1)+(mod(abs(maxDecel),0.1)>0);

maxAccel=accmax;
if maxAccel>20 % limit in case we have a divide by eps
    maxAccel=20;
end
numAccel=floor(abs(maxAccel)/0.1)+(mod(abs(maxAccel),0.1)>0);

decelArray=[];
accelArray=[];
for i=1:numDecel % the extra "+1" is for the zero bin
    decelArray(i,:)=[-0.1*(i-1), -0.1*(i)];
end
for i=1:numAccel
    accelArray(i,:)=[0.1*(i-1), 0.1*(i)];
end
%keyboard
decelArray=flipud(fliplr(decelArray));
% make sure 0 isn't included in the last decel array and make sure values equal to minimum deceleration are included
if ~isempty(decelArray)
    decelArray(end,end)=decelArray(end,end)-eps;
    decelArray(1,1)=-inf;
end
if ~isempty(accelArray)
    accelArray(end,end)=inf;
end
hist.acc.bin=[decelArray;0-eps, 0;accelArray];

% re-write the default bin if specified
if exist('bin')==1    
    if isfield(bin,'spds')
        hist.vel.bin=bin.spds;
    end
    if isfield(bin,'accs')
        hist.acc.bin=bin.accs;
    end
end

for i=1:size(hist.vel.bin,1)
    idx=find((vave*2.236936)>hist.vel.bin(i,1)&(vave*2.236936)<=hist.vel.bin(i,2));
    hist.vel.time(i)=sum(diffTime(idx));
    hist.vel.percentTime(i)=hist.vel.time(i)/tMax;
end

for i=1:size(hist.acc.bin,1)
    idx=find((accel)>hist.acc.bin(i,1)&(accel)<=hist.acc.bin(i,2));
    hist.acc.time(i)=sum(diffTime(idx));
    hist.acc.percentTime(i)=hist.acc.time(i)/tMax;
end

nStarts=sum( (accel>0)&(cyc.v(1:end-1)==0) );
nStops =sum( (accel<0)&(cyc.v(2:end)==0)   );
vbarDist = sum(vave.*(vave.*diffTime))./sum(vave.*diffTime);
return