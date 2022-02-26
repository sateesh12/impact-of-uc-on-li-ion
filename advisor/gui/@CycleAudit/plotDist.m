function hist=plotDist(cyc, E)
% plots a distribution of velocity and acceleration for a drive cycle
v=interp1(cyc.t,cyc.v,linspace(min(cyc.t),max(cyc.t),length(cyc.t)*10),'linear');
t=linspace(min(cyc.t),max(cyc.t),length(cyc.t)*10);

newCyc=CycleAudit(t,v,[cyc.name,' --subsampled at higher resolution']);

for i=1:(ceil(max(v))+1)
    bin.spds(i,:)=[(i-1), i];
end
bin.spds(1,1)=-inf;
bin.spds=bin.spds*2.236936; % convert from m/s to m/hr

[velbar, accbar, decbar, velmax, accmax, decmax, hist] = cycStats(newCyc, bin);

figure;
subplot(2,1,1);
x=mean(hist.vel.bin,2);
x(find(x<0))=0;
x(find(x>1000))=1000;
plot(x,hist.vel.percentTime*100,'b-');
xlabel('speed (miles per hour)')
ylabel('percent time')
title(['velocity distribution for ',cyc.name])
sub1h = gca;
ylimits=get(sub1h,'YLim');
ylimits=[mean(ylimits)*0.5+ylimits(1), ylimits(2)-mean(ylimits)*0.5];
a=line([velbar velbar]*2.236936, ylimits, 'Color',[1 0 0]);

clear x;
subplot(2,1,2);
x=mean(hist.acc.bin,2);
x(find(x<-10))=-10;
x(find(x>10))=10;
plot(x,hist.acc.percentTime*100,'b-');
xlabel('acceleration (m/s/s)')
ylabel('percent time')
title(['acceleration distribution for ',cyc.name])
sub1h = gca;
ylimits=get(sub1h,'YLim');
ylimits=[mean(ylimits)*0.5+ylimits(1), ylimits(2)-mean(ylimits)*0.5];
a=line([accbar accbar], ylimits,'Color',[1 0 0]);
b=line([decbar decbar], ylimits,'Color',[1 0 0]);


if exist('E')==1
    % this is the energy/power values from running this.evalVeh() 
    % lets look at a histogram of the traction power and specific kinetic energy
    %     E = 
    %             aeroSpend: J, aero dynamic energy output over the drive cycle
    %               peSpend: J, potential energy (working against gravity to elevate the vehicle) spent over the drive cycle
    %               keSpend: J, kinetic energy spent to overcome inertia and accelerate vehicle over the drive cycle
    %               rrSpend: J, energy spent to overcome rolling resistance over the drive cycle
    %             aeroRegen: J, energy regained from aerodynamics over drive cycle (should be zero)
    %               peRegen: J, energy gained from decreasing potential energy over drive cycle
    %               keRegen: J, energy recovered from a decelerating inertia over drive cycle
    %               rrRegen: J, energy recovered from rolling resistance (should always be zero)
    %                 tract: J, total traction energy required over drive cycle
    %               tracPwr: W, a signal versus time of the traction power
    %               aeroPwr: W, a signal versus time of the aerodynamic power
    %                 rrPwr: W, a signal versus time of the aerodynamic power
    %                 kePwr: W, a signal versus time of the inertial (kinetic) power
    %                 pePwr: W, a signal versus time of the potential energy power
    %            tracPwrMax: W, the maximum traction power encountered over the drive cycle
    %            tracPwrMin: W, the minimum traction power encountered over the drive cycle (negative means regen energy in)
    %         tracPwrOutBar: W, the average traction power expended when the vehicle is expending traction power
    %          tracPwrInBar: W, the average traction power absorbed when the vehicle is absorbing traction power
    %                 regen: J, total available energy available at the wheels for regen (minus losses such as aero and rolling)
    %                  fuel: J, total energy required as fuel based on regen capture efficiency and drive train efficiency
    %       travelIntensity: diminsionless figure given as (E_traction/Mass_vehicle)/(average speed)^2, determines how stop-and-go the driving is
    %             totalDist: m, the total distance traveled over the drive cycle
    %     
    numBins=100;
    E.tracPwr=E.tracPwr/1000; % convert to kW
    E.aeroPwr=E.aeroPwr/1000; % convert to kW
    E.rrPwr  =E.rrPwr/1000;   % convert to kW
    E.kePwr  =E.kePwr/1000;   % convert to kW
    E.pePwr  =E.pePwr/1000;   % convert to kW
    binSize = (max(E.tracPwr)-min(E.tracPwr))/numBins;
    maxBin=min( max(E.tracPwr),10*sum(E.tracPwr.*(E.tracPwr>0))./sum(E.tracPwr>0) );
    minBin=max( min(E.tracPwr),10*sum(E.tracPwr.*(E.tracPwr<0))./sum(E.tracPwr<0) );
    plotOn=1;
    [h,fhandle,posMean, negMean, totMean]=histogram(E.tracPwr,diff(cyc.t),binSize,maxBin,minBin,plotOn);
    xlabel('Traction Power (kW)')
    ylabel('Fraction of Time at Power Level')
    title('Traction Power Distribution')
    hist.E=h;
    
    axeH = gca;
    ylimits=get(axeH,'YLim');
    ylimits=[mean(ylimits)*0.5+ylimits(1), ylimits(2)-mean(ylimits)*0.5];
    a=line([posMean posMean], ylimits,'Color',[1 0 0]);
    b=line([negMean negMean], ylimits,'Color',[1 0 0]);
    c=line([totMean totMean], ylimits,'Color',[0 0.75 0.5]);
    
    
    % this next figure will plot Energy vs. Power and call out the loss
    % mechanisms explicitly (aero loss, rolling loss, inertial energy, and
    % potential energy). We'll use the same bins but just break it up
    % differently.
    %   tracPwr = pePwr+kePwr+aeroPwr+rrPwr;
    % find which power indices go to which bin
    diffTime = diff(cyc.t);
    for i=1:size(h.bin,1)
        idxByBin{i} = find( (E.tracPwr>h.bin(i,1))&(E.tracPwr<=h.bin(i,2)) );
        aeroSum(i)=sum(diffTime(idxByBin{i}).*E.aeroPwr(idxByBin{i}))/3600; % convert to kWh over the cycle per bin
        rrSum(i)  =sum(diffTime(idxByBin{i}).*E.rrPwr(idxByBin{i}))/3600;   % convert to kWh over the cycle per bin
        keSum(i)  =sum(diffTime(idxByBin{i}).*E.kePwr(idxByBin{i}))/3600;   % convert to kWh over the cycle per bin
        peSum(i)  =sum(diffTime(idxByBin{i}).*E.pePwr(idxByBin{i}))/3600;   % convert to kWh over the cycle per bin
    end
    hist.E.aeroSum = aeroSum;
    hist.E.rrSum = rrSum;
    hist.E.keSum = keSum;
    hist.E.peSum = peSum;
    
    fhandle=figure;
    for i=1:size(h.bin,1)
        x1=h.bin(i,1);
        x2=h.bin(i,2);
        
        % kinetic (inertial)
        y1=0;
        y2=y1+keSum(i);
        patch([x1;x1;x2;x2],[y1; y2; y2; y1],'b');
        % potential energy
        y1=y2;
        y2=y1+peSum(i);
        patch([x1;x1;x2;x2],[y1; y2; y2; y1],'y');
        % rolling energy
        y1=y2;
        y2=y1+rrSum(i);
        patch([x1;x1;x2;x2],[y1; y2; y2; y1],'g');
        % aerodynamic energy
        y1=y2;
        y2=y1+aeroSum(i);
        patch([x1;x1;x2;x2],[y1; y2; y2; y1],'r');
    end
    legend('Inertial Energy','Potential Energy','Rolling Energy','Aerodynamic Energy')
    
end