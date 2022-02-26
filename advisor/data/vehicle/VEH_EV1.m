% ADVISOR data file:  VEH_EV1.m
%
% Data source: www.gmev1.com
%
% Data confirmation: 
%
% Notes:  This file defines the road load parameters for the GM EV1
%
% Additional Information
% Motor 
%	AC Induction
%	peak power = 137HP (102kW) at 7000RPM
% 	peak torque = 150Nm from 0-7000RPM
% Gearbox
% 	double reduction, ratio = 10.946:1
% Energy Storage
% 	PbA - 26 mod., 18.7kWh rated, 60Ah, 312V, 1310lbs
% 	NiMH - 26 mod., 26.4kWh rated, 77Ah, 343V, 1147lbs
% Tires
%	Michelin Proxima P175/65R14 
%	~ radius = 14/2*2.54/100+0.175*0.65 = 0.292m -10mm(squish) = 0.282m
% Performance
% 	0-60mph in 9s
%	City = 26kWh/100mi (PbA) and 34kWh/100mi (NiMH)
%	Hwy = 26kWh/100mi (PbA) and 30kWh/100mi (NiMH)
%  Range = 55-95mi (PbA) and 75-130mi (NiMH)
%
% Created on: 8/18/00
% By:  Tony Markel of NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='EV1 vehicle chassis';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_EV1 - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle curb wt. = 3086 lbs (PbA) and 2908 lbs (NiMH)
% battery pack = 1310 lbs (PbA) and 1147 for (NiMH)
% motor mass = unknown, estimate 100kg
% gearbox mass = unknown, estimate 50kg 
% wheel mass = unknown, estimate 0kg (account for in glider)
veh_glider_mass=(3086-1310)/2.2046-100-50; % (kg), = 655kg, estimate

veh_CD=0.19;  % (--), coefficient of drag 

% vehicle width = 69.5in
% vehicle height = 50.5in
% vehicle clearance = 5 in
veh_FA=69.5*2.54/100*50.5*2.54/100*0.9;    % (m^2), frontal area, estimate assume 90% reduction for rounded corners

% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
% tires are Michellen Proxima P175/65R14
% from www.michelin-us.com/us/eng/tire/catalog/proxima.htm
% at design load rolling resistance = 6.80kg/metric ton = 0.0068 kg/kg
%veh_1st_rrc=6.8/1000;  % (--) rolling resistance = 0.0068 kg/kg
%veh_2nd_rrc=0;		% (s/m)

% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.55;  % (--), unknown

% height of vehicle center-of-gravity above the road
veh_cg_height=0.4;	% (m), unknown

% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=98.9*2.54/100;	% (m), GM website

veh_cargo_mass=136; % (kg) default EPA cargo/passenger weight


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8/18/00:tm file created
% 1/18/00:tm changed rolling resistance from 0.0075 to 0.0068 due to calculations error
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc