% ADVISOR data file:  VEH_LGCAR.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a hypothetical Large car, roughly
% based Defines vehicle and miscellaneous specifications for the Virginia Tech
% 1996 FutureCar, which is a modified Chevy Lumina.
% 
% Created on: 21-Sept-1998
% By:  ss of NREL, for PTC demo
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Hypothetical large car(lumina)';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_LGCAR - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_glider_mass=1000; % (kg), vehicle mass w/o propulsion system--
% fuel converter, exhaust aftertreatment, drivetrain, motor, ESS, generator
veh_CD=0.33;  % (--), coefficient of aerodynamic drag
veh_FA=2.04;    % (m^2), frontal area
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.009;  % (--)
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--)
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% (m), estimated for 
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.6;	% (m), 1995 Saturn SL (GM Impact is 2.51 m)

veh_cargo_mass=136; %kg  cargo mass

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  9/21/98-sam created for ptc demo%
% 01/22/99:mc removed comments on glider mass
% 2/2/99: ss added veh_cargo_mass
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc