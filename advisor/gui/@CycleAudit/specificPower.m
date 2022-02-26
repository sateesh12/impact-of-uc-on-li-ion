function [P, K, A, R, accel, dhdt, dist] = specificPower(cyc)
% [P, K, A, R, accel, dhdt, dist] = specificPower(cyc)
% Runs specific values for power and energy over the cycle
%
% P is potential energy/power, K is kinetic energy power, 
% A is aerodynamic energy/power, R is rolling resistance energy/power
% accel is the array of acceleration events, dhdt is the change in elevation versus time
% dist is the cumulatively summed total distance of the cycle in meters
% 
% % Sec-by-sec specific Power over Cycle
% P.P % potential power, W/kg/G
% K.P % kinetic power, W/kg
% A.P % aerodynamic power, W/rho/CD/FA where rho is the density of air, CD is the coefficient of drag, and FA is frontal area in m*m
% R.P % rolling resistance power, W/G/kg/RRC0 where G is the acceleration of gravity (9.81 m/s/s), RRC0 is the zeroth rolling resistance coefficient: N of rolling resistance/N of weight on the tires
% % Delta Energy over Cycle
% P.E % Potential Energy change over cycle, J/kg/G
% K.E % Kinetic Energy change over cycle, J/kg
% A.E % Aerodynamic Energy change over cycle, J/rho/CD/FA
% R.E % Rolling Resistance Energy change over cycle, J/G/kg/RRC0
% % Powered Energy
% P.Eexpend % Potential Energy used for Climbing, J/kg/G
% K.Eexpend % Kinetic Energy used for Acceleration, J/kg
% A.Eexpend % Energy used to overcome Aerodynamic Drag, J/rho/CD/FA
% R.Eexpend % Energy used to overcome Rolling Resistance, J/G/kg/RRC0
% % Regen Energy
% P.Eregen % Potential Energy received from Descending, J/kg/G
% K.Eregen % Kinetic Energy gained from Deceleration, J/kg
% A.Eregen % Energy gained from overcoming Aerodynamic Drag, J/rho/CD/FA
% R.Eregen % Energy gained from overcoming Rolling Resistance, J/G/kg/RRC0
% % Average Power During Power Expendature
% P.PaveExpend % Average Potential Power Used to Increase Elevation over the cycle, W/kg/G
% K.PaveExpend % Average Power Used During Increase in Kinetic Energy, W/kg
% A.PaveExpend % Average Power Used to Overcome Aerodynamic Drag, W/rho/CD/FA
% R.PaveExpend % Average Power Used to Overcome Rolling Resitance, W/G/kg/RRC0
% % Average Power During Regen
% P.PaveRegen % Average Potential Power Gained due to Decrease in Elevation Over the cycle, W/kg/G
% K.PaveRegen % Average Power Gained During Decrease in Kinetic Energy, W/kg
% A.PaveRegen % Average Power Gained to Overcome Aerodynamic Drag, W/rho/CD/FA
% R.PaveRegen % Average Power Gained to Overcome Rolling Resistance, W/G/kg/RRC0

diffTime=diff(cyc.t);
zeroIndex = find(diffTime==0);
diffTime(zeroIndex)=eps; % protect from divide by zero--should approximate infinity for instantaneous accelerations
diffVel =diff(cyc.v);
diffHt  =diff(cyc.h);
tMax=max(cyc.t);

accel=diffVel./diffTime;
dhdt =diffHt./diffTime;
vbar=conv(cyc.v,[0.5;0.5]);
vbar=vbar(2:end-1);
for i=1:(length(cyc.v)-1)
    vbarCubed(i)= 0.25*(cyc.v(i+1)^3)+0.25*(cyc.v(i+1)^2)*(cyc.v(i))+0.25*(cyc.v(i)^2)*(cyc.v(i+1))+0.25*(cyc.v(i)^3);
end
vbarCubed=vbarCubed(:);
dist=vbar.*diffTime;
dist(zeroIndex)=0;
dist=cumsum(dist);
dist=dist(:);
dist=[0; dist];

PP=dhdt; % potential power, W/kg/G
KP=vbar.*accel; % kinetic power, W/kg
AP=0.5*vbarCubed; % aerodynamic power, W/rho/CD/FA where rho is the density of air, CD is the coefficient of drag, and FA is frontal area in m*m
RP=vbar; % rolling resistance power, W/G/kg/RRC0 where G is the acceleration of gravity (9.81 m/s/s), RRC0 is the zeroth rolling resistance coefficient: N of rolling resistance/N of weight on the tires

% Sec-by-sec specific Power over Cycle
% make into column vector
P.P=PP(:);
K.P=KP(:);
A.P=AP(:);
R.P=RP(:);
%diffTime(zeroIndex)=0; % put this back to zero so that sums are correct
% Delta Energy over Cycle
P.E=sum(diffTime.*PP); % Potential Energy change over cycle, J/kg/G
K.E=sum(diffTime.*KP); % Kinetic Energy change over cycle, J/kg
A.E=sum(diffTime.*AP); % Aerodynamic Energy change over cycle, J/rho/CD/FA
R.E=sum(diffTime.*RP); % Rolling Resistance Energy change over cycle, J/G/kg/RRC0
% Powered Energy
P.Eexpend=sum(diffTime.*PP.*(PP>0)); % Potential Energy used for Climbing, J/kg/G
K.Eexpend=sum(diffTime.*KP.*(KP>0)); % Kinetic Energy used for Acceleration, J/kg
A.Eexpend=sum(diffTime.*AP.*(AP>0)); % Energy used to overcome Aerodynamic Drag, J/rho/CD/FA
R.Eexpend=sum(diffTime.*RP.*(RP>0)); % Energy used to overcome Rolling Resistance, J/G/kg/RRC0
% Regen Energy
P.Eregen=sum(diffTime.*PP.*(PP<0)); % Potential Energy received from Descending, J/kg/G
K.Eregen=sum(diffTime.*KP.*(KP<0)); % Kinetic Energy gained from Deceleration, J/kg
A.Eregen=sum(diffTime.*AP.*(AP<0)); % Energy gained from overcoming Aerodynamic Drag, J/rho/CD/FA
R.Eregen=sum(diffTime.*RP.*(RP<0)); % Energy gained from overcoming Rolling Resistance, J/G/kg/RRC0
% Average Power During Power Expendature
P.PaveExpend=P.Eexpend./tMax; % Average Potential Power Used to Increase Elevation over the cycle, W/kg/G
K.PaveExpend=K.Eexpend./tMax; % Average Power Used During Increase in Kinetic Energy, W/kg
A.PaveExpend=A.Eexpend./tMax; % Average Power Used to Overcome Aerodynamic Drag, W/rho/CD/FA
R.PaveExpend=R.Eexpend./tMax; % Average Power Used to Overcome Rolling Resitance, W/G/kg/RRC0
% Average Power During Regen
P.PaveRegen=P.Eregen./tMax; % Average Potential Power Gained due to Decrease in Elevation Over the cycle, W/kg/G
K.PaveRegen=K.Eregen./tMax; % Average Power Gained During Decrease in Kinetic Energy, W/kg
A.PaveRegen=A.Eregen./tMax; % Average Power Gained to Overcome Aerodynamic Drag, W/rho/CD/FA
R.PaveRegen=R.Eregen./tMax; % Average Power Gained to Overcome Rolling Resistance, W/G/kg/RRC0