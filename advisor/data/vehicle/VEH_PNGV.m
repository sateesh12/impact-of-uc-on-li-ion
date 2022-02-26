% ADVISOR data file:  VEH_PNGV.m
%
% Data source: CD and A came from published PNGV documents, remainder are estimates.
%
% Data confirmation: these are estimates only, no confirmation with hardware has been performed
%
% Notes:  This file defines the road load parameters for a hypothetical PNGV vehicle 
%			 	*chassis*.  Warning: this file only defines the chassis characteristics
%				of a PNGV-type vehicle, and not the drivetrain, so using this chassis
%				does not mean that you will necessarily get an 80mpg vehicle.  80mpg is only
%				achieved with a careful combination of weight reduction, aerodynamic and rolling
%				resistance improvements, drivetrain configuration, and improved efficiency
%				of energy conversion.
% 
% Created on: 22-Oct-1998
% By:  SS of NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='PNGV-type vehicle chassis';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_PNGV - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_glider_mass=500; % (kg), rough estimate of vehicle mass w/o propulsion system (fuel converter,
                     % exhaust aftertreatment, drivetrain, motor, ESS, generator)
veh_CD=0.2;  % (--), coefficient of drag estimate
veh_FA=2.0;    % (m^2), frontal area estimate
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.007;  % (--) rolling resistance estimate
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--)
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% (m), estimated for 1995 Saturn SL
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.755;	% (m), provided by CSMI, 1995 Saturn SL (GM Impact is 2.51 m)

veh_cargo_mass=136; % (kg) default EPA cargo/passenger weight

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6/23/98 Created by MRC
%	9/10/98 Modified by KW to move vehicle mass into comments
% 10/22/98 Sam modified and named it veh_p2000 was veh_smcar
%  4/27/99 SDB modified and named it veh_PNGV2 was veh_p2000
%  9/08/99 KW modified and renamed veh_PNGV for public release, updated version to 2.2
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc