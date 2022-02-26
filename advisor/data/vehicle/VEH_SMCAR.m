% ADVISOR data file:  VEH_SMCAR.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a hypothetical small car, roughly
% 			    based on a 1994 Saturn SL1 vehicle.
% 
% Created on: 23-Jun-1998
% By:  MRC of NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Hypothetical small car';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_SMCAR - ',veh_description])


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
veh_glider_mass=(2325/2.205)-462; % (kg), vehicle mass w/o propulsion system (fuel converter,
                     % exhaust aftertreatment, drivetrain, motor, ESS, generator)
veh_CD=0.335;  % (--), coefficient of aerodynamic drag
veh_FA=2.0;    % (m^2), frontal area
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.009;  % (--)
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--)
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% (m), estimated for 1995 Saturn SL
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.6;	% (m), 1995 Saturn SL (GM Impact is 2.51 m)

veh_cargo_mass=136; %kg  cargo mass

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6/23/98 Created by MRC
%	9/10/98 Modified by KW to move vehicle mass into comments
% 2/2/99: ss added veh_cargo_mass
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc