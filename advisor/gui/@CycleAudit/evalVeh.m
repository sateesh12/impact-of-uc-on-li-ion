function [mpg, E]=evalVeh(cyc, aeroC, keC, peC, rrC, regenEff, cycEff, fuelVolHV, auxLoads)
% [mpg, E]=evalVeh(cyc, aeroC, keC, peC, rrC, regenEff, cycEff, fuelVolHV, auxLoads)
% Runs out the fuel economy of a vehicle of the given statistics
%
% mpg is miles per gallon of fuel associated with fuelVolHV
%
% E = 
%           aeroSpend: J, aero dynamic energy output over the drive cycle
%             peSpend: J, potential energy (working against gravity to elevate the vehicle) spent over the drive cycle
%             keSpend: J, kinetic energy spent to overcome inertia and accelerate vehicle over the drive cycle
%             rrSpend: J, energy spent to overcome rolling resistance over the drive cycle
%           aeroRegen: J, energy regained from aerodynamics over drive cycle (should be zero)
%             peRegen: J, energy gained from decreasing potential energy over drive cycle
%             keRegen: J, energy recovered from a decelerating inertia over drive cycle
%             rrRegen: J, energy recovered from rolling resistance (should always be zero)
%               tract: J, total traction energy required over drive cycle
%               regen: J, total traction energy available as regenerative energy
%             tracPwr: W, a signal versus time of the traction power
%             aeroPwr: W, a signal versus time of the aerodynamic power
%               rrPwr: W, a signal versus time of the aerodynamic power
%               kePwr: W, a signal versus time of the inertial (kinetic) power
%               pePwr: W, a signal versus time of the potential energy power
%          tracPwrMax: W, the maximum traction power encountered over the drive cycle
%          tracPwrMin: W, the minimum traction power encountered over the drive cycle (negative means regen energy in)
%       tracPwrOutBar: W, the average traction power expended when the vehicle is expending traction power
%        tracPwrInBar: W, the average traction power absorbed when the vehicle is absorbing traction power
%               regen: J, total available energy available at the wheels for regen (minus losses such as aero and rolling)
%                fuel: J, total energy required as fuel based on regen capture efficiency and drive train efficiency
%     travelIntensity: diminsionless figure given as (E_traction/Mass_vehicle)/(average speed)^2, determines how stop-and-go the driving is
% travelIntensityDist: as above except with a distance based speed average
%           totalDist: m, the total distance traveled over the drive cycle
%     
% aeroC=airDensity*CD*FA;
% keC=M;
% peC=M*G;
% rrC=G*M*RRC0;
%
% M is vehicle mass in kg, airDensity is air density in kg/m/m/m,
% CD is coefficient of drag, FA is frontal area in m*m,
% G is gravitational acceleration (m/s/s), RRC0 is N of rolling resistance/N over tire axle
% regenEff is energy captured divided by that available
% regenEff should be = (regenerated energy that can be reapplied as wheel traction/total regenerated energy captured)
% cycEff is the efficiency at which fuel energy is transformed into rolling energy
% fuelVolHV is volumetric heating value in J/gallon of fuel
% auxLoads is the average fuel power consumed to power auxiliaries in W (i.e., efficiency 
%          of fuel conversion already taken into account)
%
% mpg is the vehicle miles per gallon based on the fuel volumetric heating value
% E is the total fuel energy used by the vehicle in J
%
% e.g., [mpg, E] = evalVeh(CycleAudit('CYC_CSHVR'),1.23*0.65*7.99, 7257, 7257*9.81, 0.00525*9.81*7257, 0.0, 1.0, 137217399.6, 0)


[P, K, A, R, accel, dhdt, dist] = specificPower(cyc);

peSpend=P.Eexpend; % J/kg/G
keSpend=K.Eexpend; % J/kg
aeroSpend=A.Eexpend; % J/rho/CD/FA
rrSpend=R.Eexpend; % J/G/kg/RRC0
peRegen=P.Eregen; % J/kg
keRegen=K.Eregen; % J/kg

E.aeroSpend = aeroSpend*aeroC;
E.peSpend = peSpend*peC;
E.keSpend = keSpend*keC;
E.rrSpend = rrSpend*rrC;
E.aeroRegen = 0;
E.peRegen = peRegen*peC;
E.keRegen = keRegen*keC;
E.rrRegen = 0;

tracPwr = P.P*peC+K.P*keC+A.P*aeroC+R.P*rrC;
E.tract = sum(diff(cyc.t).*tracPwr.*(tracPwr>0));
E.regen = -sum(diff(cyc.t).*tracPwr.*(tracPwr<0));
E.tracPwr=tracPwr; % pass out the traction power array
E.aeroPwr=A.P*aeroC;
E.rrPwr  =R.P*rrC;
E.kePwr  =K.P*keC;
E.pePwr  =P.P*peC;
E.tracPwrMax=max(tracPwr);
E.tracPwrMin=min(tracPwr);
if sum(diff(cyc.t).*(tracPwr>0))==0
    E.tracPwrOutBar=0;
else
    E.tracPwrOutBar=sum(diff(cyc.t).*tracPwr.*(tracPwr>0))/sum(diff(cyc.t).*(tracPwr>0));
end
if sum(diff(cyc.t).*(tracPwr<0))==0
    E.tracPwrInBar=0;
else
    E.tracPwrInBar=sum(diff(cyc.t).*tracPwr.*(tracPwr<0))/sum(diff(cyc.t).*(tracPwr<0));
end

E.fuel = auxLoads*(cyc.t(end)-cyc.t(1))+(E.tract-E.regen*regenEff)/cycEff;
% E.fuel = sum(diff(cyc.t).*tracPwr.*((tracPwr>0)+(tracPwr<0)*regenEff))/cycEff;

% trapz(cyc.t,cyc.v)/trapz(cyc.t,ones(size(cyc.t)));
[vbar, accbar, decbar, velmax, accmax, decmax, hist, driveTime, velbarDrive, nStarts, nStops, vbarDist] = cycStats(cyc); 
if vbar==0
    E.travelIntensity=inf;
else
    %E.travelIntensity = ((E.tract-E.regen*regenEff)*(cyc.t(end)-cyc.t(1))/max(dist)/keC)/(vbar);
    E.travelIntensity = ((E.tract-E.regen*regenEff)/keC)/((vbar)^2); % equivalent to above but fits definition better
    E.TI_dist = ((E.tract-E.regen*regenEff)/keC)/((vbarDist)^2); % equivalent to above but with distance based velocity
end
E.totalDist=max(dist); 

mpg=(dist(end)/1609.344)/(E.fuel/fuelVolHV);

% update list
% 02/28/03: mpo changed the auxLoads portion of E.fuel calculation--> multiplied by time to go from W to J
% 03/04/03: mpo added a correct vbar calculation and enabled the figuring
% of travel intensity (dimensionless indicator of the intensity of a cycle)