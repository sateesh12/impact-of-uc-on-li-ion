% ADVISOR data file:  VEH_PRIUS_JPN.m
%
% Data source:
%
% Data confirmation:  NEEDS rrc yet.
%
% Notes:  Defines road load parameters for a '98 Toyota PRIUS(japan)
% 			    
% 
% Created on: 27-May-99
% By:  SS of NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Toyota PRIUS_JPN';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_PRIUS_JPN - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual curb weight of a 1998 Japanese PRIUS is 2783 pounds(full tank).
%		If you wish to accurately set your totalvehicle mass
% 	 	to this value in the A2 GUI, you should use the mass override
%		checkbox and enter in the value 1398, which is (2783+300)/2.205 = 1398 kg, which comes from
%		adding on 300 lbs of EPA test mass, and then converting pounds to kilograms.
veh_glider_mass=918; % (kg), vehicle mass w/o propulsion system (fuel converter,
                     % exhaust aftertreatment, drivetrain, motor, ESS, generator)
veh_CD=0.3;  % (--), coefficient of aerodynamic drag, 0.3 from toyota press release
veh_FA=1.746;    % (m^2), frontal area, 1.746 from Unique Mobility calculation
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.009;  % (--) not sure about this yet!
%veh_2nd_rrc=0;		% (s/m)  not sure about this yet!
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--) cg is 1.542 from rear axle on empty PRIUS
% height of vehicle center-of-gravity above the road
veh_cg_height=0.569;	% (m), .569 for PRIUS_JPN from Unique Mobility testing
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.55;	% (m), 2.55 m for PRIUS_JPN

veh_cargo_mass=136; %kg  cargo mass

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  5/27/99 Created by SS
% 10/19/99 ss changed veh_mass to 918 kg
% 11/03/99:ss updated version from 2.2 to 2.21
% 2/2/01: ss updated prius to prius_jpn
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc