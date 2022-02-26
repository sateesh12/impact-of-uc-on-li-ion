% ADVISOR data file:  VEH_FIAT_SEIC.m
%
% Data source: FIAT
%
% Data confirmation:
%
% Notes:  Defines road load parameters for FIAT seicento elettra car.
% 
% Created on: 15-3-1999
% By:  G.Villosio
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='FIAT Seicento Fuel Cell car';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_FIAT_SEIC - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
veh_glider_mass=1200-58-400-13; % (kg), vehicle mass w/o electric propulsion system (motor, ESS) w/o rear seat
veh_CD=0.34;  % (--), coefficient of aerodynamic drag
veh_FA=1.79;    % (m^2), frontal area
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
% rolling resistance (ton/ton)
%veh_1st_rrc=0.01;  % (--)
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--)
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% unknown (m), 
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.2;	% (m), 
veh_cargo_mass=136; % (kg) default EPA cargo/passenger weight


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (5/6/99)  (GV) Data originally provided by G. Villosio of Fiat
% (5/28/99) (KW) Data upgraded to 2.1 format from 2.0 format
% (5/28/99) (SS) Made sure filename, first comment line and the displayed line all read VEH_FIAT_SEIC
% 11/03/99:ss updated version from 2.2 to 2.21
% 04/04/02 mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc