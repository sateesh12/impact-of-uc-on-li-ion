% ADVISOR data file:  VEH_CYCLE.m
%
% Data source: www.ecycle.com
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a lightweight sport motorcycle.
% 
% Created on: 6/19/01
% By:  NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Motorcycle';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_CYCLE - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual average vehicle mass of a 1994 Saturn SL1 5spd is 2325 pounds.
%		If you wish to accurately set your totalvehicle mass
% 	 	to this value in the A2 GUI, you should use the mass override
%		checkbox and enter in the value 1191, which is (2325+300)/2.205 = 1191 kg, which comes from
%		adding on 300 lbs of EPA test mass, and then converting pounds to kilograms.
%		The glider mass below is just an estimate that gives 2325 pounds for a 95 kW
%		scaled SI95 engine in a conventional vehicle with 5-speed transmission.
veh_glider_mass=(230-57.5-13-15)/2.2054; % (kg), vehicle mass w/o propulsion system (230=total, ess=57.5, motor=13, engine=15 from website)
veh_CD=0.6; % (--), coefficient of aerodynamic drag (Bosch handbook)
veh_FA=(30+10)*24/1550; % (m^2), frontal area (estimate diamond shape, widest point 24 inches at seat height of 30 in, seat at 3/4 total height)
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.009;  % (--) estimate
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.58;  % (--) estimate
% height of vehicle center-of-gravity above the road
veh_cg_height=-24/39.37;	% (m), estimated from website
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=1.321;	% (m), www.ecycle.com

veh_cargo_mass=136; %kg  cargo mass

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6/19/01 Created by tm

% 19-Jun-2001: automatically updated to version 3.1
% 04-Apr-2002: moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc