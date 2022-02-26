function [mpg, E]=evalVehAdv(cyc, aeroC, keC, peC, rrC, accPwr, ptEffFunc, accPwr, fuelVolHV)
% function [mpg, E]=evalVehAdv(cyc, aeroC, keC, peC, rrC, accPwr, ptEffFunc, accPwr, fuelVolHV)
% Estimates the fuel economy of a vehicle using the given statistics. Assumes that all of the input coefficients can vary with time
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
%          tracPwrMax: W, the maximum traction power encountered over the drive cycle
%          tracPwrMin: W, the minimum traction power encountered over the drive cycle (negative means regen energy in)
%       tracPwrOutBar: W, the average traction power expended when the vehicle is expending traction power
%        tracPwrInBar: W, the average traction power absorbed when the vehicle is absorbing traction power
%               regen: J, total available energy available at the wheels for regen (minus losses such as aero and rolling)
%             fuelPwr: W, fuel energy used per time
%                fuel: J, total energy required as fuel based on regen capture efficiency and drive train efficiency
%     travelIntensity: diminsionless figure given as (E_traction/Mass_vehicle)/(average speed)^2, determines how stop-and-go the driving is
%           totalDist: m, the total distance traveled over the drive cycle
%     
%
% The following fields can each vary with time but must be defined as is cyc.time (s)
% 
% M is vehicle mass in kg, airDensity is air density in kg/m/m/m,
% CD is coefficient of drag, FA is frontal area in m*m,
% G is gravitational acceleration (m/s/s), RRC0 is N of rolling resistance/N over tire axle
%
% regenEff is energy captured divided by that available
% regenEff should be = (regenerated energy that can be reapplied as wheel traction/total regenerated energy captured)
% ptEffFunc is a function that gives powertrain efficiency and fuel power consumped on basis of traction power required and auxiliary power required
% [eff, fuelPwr] = feval(ptEffFunc, tractPwr, accPwr
% fuelVolHV is volumetric heating value in J/gallon of fuel
% accPwr is the average fuel power consumed to power auxiliaries in W (i.e., efficiency 
%          of fuel conversion already taken into account)
%
% mpg is the vehicle miles per gallon based on the fuel volumetric heating value
% E is the total fuel energy used by the vehicle in J
%
% e.g., [mpg, E] = evalVehAdv(CycleAudit('CYC_CSHVR'),1.23*0.65*7.99, 7257, 7257*9.81, 0.00525*9.81*7257, 0.0, 1.0, 137217399.6, 0)

% calculate the coefficients--these can be time based signals or constants
% (or a mix)
[P, K, A, R, accel, dhdt, dist] = powerUse(cyc, aeroC, keC, peC, rrC);

peSpend=P.Eexpend; % J
keSpend=K.Eexpend; % J
aeroSpend=A.Eexpend; % J
rrSpend=R.Eexpend; % J
peRegen=P.Eregen; % J
keRegen=K.Eregen; % J

% these calculations are no longer valid...
E.aeroSpend = A.Eexpend;
E.peSpend   = P.Eexpend;
E.keSpend   = K.Eexpend;
E.rrSpend   = R.Eexpend;
E.aeroRegen = 0;
E.peRegen   = P.Eregen;
E.keRegen   = K.Eregen;
E.rrRegen   = 0;

tracPwr = P.P+K.P+A.P+R.P;
E.tract = sum(diff(cyc.t).*tracPwr.*(tracPwr>0));
E.regen = -sum(diff(cyc.t).*tracPwr.*(tracPwr<0));
E.tracPwr=tracPwr; % pass out the traction power array
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

% Now we attempt to get into the powertrain a little
% accPwr should be defined in the same sampling rate as tracPwr
sigTime = cyc.t(:)'+0.5*[diff(cyc.t) 0];
sigTime = sigTime(1:end-1); % shift to 'mid-point' samplings
accPwr = sigProcessor(sigTime,cyc.t,accPwr);
E.fuelPwr = feval(ptEffFunc, E.tracPwr, accPwr);
E.fuel = sum(diff(cyc.t).*E.fuelPwr);

vbar= cycStats(cyc); % trapz(cyc.t,cyc.v)/trapz(cyc.t,ones(size(cyc.t)));
if vbar==0
    E.travelIntensity=inf;
else
    %E.travelIntensity = ((E.tract-E.regen*regenEff)*(cyc.t(end)-cyc.t(1))/max(dist)/keC)/(vbar);
    E.travelIntensity = ((E.tract-E.regen*regenEff)/keC)/((vbar)^2); % equivalent to above but fits definition better
end
E.totalDist=max(dist);

mpg=(dist(end)/1609.344)/(E.fuel/fuelVolHV);

% update list
% 02/28/03: mpo changed the auxLoads portion of E.fuel calculation--> multiplied by time to go from W to J
% 03/04/03: mpo added a correct vbar calculation and enabled the figuring
% of travel intensity (dimensionless indicator of the intensity of a cycle)