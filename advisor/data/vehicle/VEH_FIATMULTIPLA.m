% ADVISOR data file:  VEH_FIAT_MULTIPLA.m
%
% Data source: 	QUATTRORUOTE (Italian pubblication)
%
% Created on: 07-12-2000
% By:  Antonio De Lauretis
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='FIAT Multipla Fuel Cell car';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_FIAT_MULTIPLA - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
veh_glider_mass=900; % (kg), valued by A.De Lauretis from quattroroute data
veh_CD=0.36;  % (--), coefficient of aerodynamic drag; by: quattroruote
veh_FA=2.60;    % (m^2), frontal area; by: quattroruote
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
% rolling resistance (ton/ton)
%veh_1st_rrc=0.01;  % (--)
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--) by: quattroruote
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% unknown (m), 
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.666;	% (m), by: quattroruote
veh_cargo_mass=200; % (kg) default EPA cargo/passenger weight; unknown

%%%%%%%%%%%%%%%%%%%%
% Revision History %
%%%%%%%%%%%%%%%%%%%%
% 7/12/00 new file, FIAT uses this vehicle to introduce fuel cell
% 1/18/01 ss added this user contributed file to public version of ADVISOR
% 04/04/02 mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc
