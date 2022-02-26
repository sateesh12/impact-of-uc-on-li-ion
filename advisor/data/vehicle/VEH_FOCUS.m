% ADVISOR data file:  VEH_FOCUS.m
%
% Data source: Brian Andonian  (bandoman@umich.edu)
%
% Data confirmation: NONE
%
% Notes:  
% ****THIS FILE IS FOR EDUCATIONAL USE ONLY******** 
%  A Ford Focus 3-door Conversion EV designed for racing.
% Additional Information
% Motor:  AC Propulsion's AC150 AC Induction Motor and Controller 
%				http://www.acpropulsion.com
%	peak power = 150 KW
% 	peak torque = 225 N-m from 0 - 5,000RPM
% Gearbox
% 	Modified OEM manual 5-spd gearbox,only 2nd and final drive used, ratio = 7.42:1 
% Energy Storage = Optima PbA D750S (yellow top) x 28 cells
% 	
% Tires:  Yokohama 215/45 ZR17  (same as SVT Focus)
%	
% Performance 
% 	0-60mph in approx 7 sec (goal)
%	City = 
%	Hwy = 
%  Range = 75 miles at 60mph steady state
%
% Created on: 3/06/01
% 
% BY: B. ANDONIAN
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Ford Focus vehicle chassis';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_FOCUS - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS for a TOTALLY Stripped Focus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle curb wt. = 2551 lbs  (ford.com) 
% ***below are subtractions from base vehicle
% engine assembly wt.  = estimate 230lbs
% engine cooling system =  estimate 41.5 lbs
% 12v battery wt. = estimate 28lbs
% fuel system wt. = estimate 103 lbs
% exhaust system wt. = estimate 55 lbs
% trans shifter = estimate 6.5 lbs 
% transmission clutch and unused gear sets (1,3,4, and 5) = estimate 50 lbs
% rear seats = estimate 150lbs
% climate control system =  estimate 53lbs
% side glass and window mechanisms = estimate 60 lbs
% Audio system = estimate 11 lbs
% Power steering pump + lines + cooler = estimate 11 lbs 
% Brake Booster & ABS controller = estimate 15 lbs
% Carpet & Headliner & Interior Trim = estimate 90 lbs
% Airbags = estimate 15 lbs
% Spare Tire = 37 lbs
% OEM Wiring = 37 lbs
% OEM Seat Belts = 10.5 lbs
% OEM Instrument panel = 40 lbs
% OEM Exterior Trim = 31 lbs
% Misc = 65 lbs
% ****end of subtractions list
% add EV Wiring and instrumentation, gages = 50 lbs
% add battery fans and misc ducting = 40lbs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Wt estimate for a totally stripped EV Focus "Glider" = 704kg
veh_glider_mass=(2551-230-41.5-28-103-55-6.5-50-150-53-60-11-11-15-90-15-37-37-10.5-40-31-65+50+40)/2.2046; % (kg), 
veh_CD=0.312;  % (--), coefficient of drag (given on ford.com) NOTE: can be improved with EV!!

% vehicle width = 66.9 in
% vehicle height = 56.3 in
% vehicle clearance = 5 in
veh_FA=2.06;    % (m^2), frontal area, measured

% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
% tires are P215/45 ZR17
% the rolling resistance data below is not verified, only estimated BJA. 
%veh_1st_rrc=8.630/1000;  % (--) rolling resistance = 0.008630 kg/kg
%veh_2nd_rrc=0;		% (s/m)

% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.50;  % (--), unknown, assume that this can be attained with battery distribution.

% height of vehicle center-of-gravity above the road
veh_cg_height=0.53;	% (m), published data - assume that this is maintained after conversion

% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=103*25.4/1000;	% (m), Ford website

veh_cargo_mass=136; % (kg) default EPA cargo/passenger weight


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/06/01:bja file created
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc