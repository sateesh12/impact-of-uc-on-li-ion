function [hist, cumdist] = distanceHist(cyc, bins, plotOn)
% function [hist, cumdist] = distanceHist(cyc, bins, plotOn)
% produces a histogram of speeds and accelerations/decelerations based on
% distance (instead of time).
%
% if bins is supplied it must be a structure with fields spds and
% accs for the velocity and acceleration bins respectively
% bins should be in the format of [lowspd_bin1, highspeed_bin1; lowspd_bin2, highspeed_bin2] etc.
% for plotting, bins can also have the fiels minBin, maxBin, binSize
%
% units for speeds: mph, accelerations: m/s/s

vave = conv(cyc.v,[0.5;0.5]);
vave = vave(2:end-1);
vave = vave(:);
dt   = diff(cyc.t);
dist = dt.*vave; % distance is at the same points as vave (mid-points)--distance traveled each time step
cumdist = [0; cumsum(dist)]; % cumulative distance traveled--@ points of t and v
dv = diff(cyc.v);

accel=dv./dt;
velmax=max(cyc.v);
accmax=max(accel(find(accel>0)));
decmax=min(accel(find(accel<0)));

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
if exist('bins')==1    
    if isfield(bins,'spds')
        hist.vel.bin=bins.spds;
    end
    if isfield(bins,'accs')
        hist.acc.bin=bins.accs;
    end
end

for i=1:size(hist.vel.bin,1)
    idx=find((vave*2.236936)>hist.vel.bin(i,1)&(vave*2.236936)<=hist.vel.bin(i,2));
    hist.vel.distance(i)=sum(dist(idx));
    hist.vel.percentDist(i)=hist.vel.distance(i)/cumdist(end);
end

for i=1:size(hist.acc.bin,1)
    idx=find((accel)>hist.acc.bin(i,1)&(accel)<=hist.acc.bin(i,2));
    hist.acc.distance(i)=sum(dist(idx));
    hist.acc.percentDist(i)=hist.acc.distance(i)/cumdist(end);
end

if exist('plotOn')==1
    if plotOn
        maxBin = 65;%(floor(max(vave*2.236936)/5)+(mod(max(vave*2.236936),5)>0)+2)*5;
        minBin = 0;
        binSize=5; %mph
        
        if exist('bins')
            if isfield(bins,'minBin')
                minBin=bins.minBin;
            end
            if isfield(bins,'maxBin')
                maxBin=bins.maxBin;
            end
            if isfield(bins,'binSize')
                binSize=bins.binSize;
            end
        end

        [h,fhandle,posMean,negMean,totMean]=histogram(vave*2.236936,dist,binSize,maxBin,minBin,plotOn);
        xlabel('velocity (mph)')
        ylabel('percent distance (meters)')
    end
end
return