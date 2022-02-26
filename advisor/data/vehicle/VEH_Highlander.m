% ADVISOR data file:  VEH_Highlander.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a Toyota Highlander.
% 
% Created on: 04/07/03
% By:  Tony Markel of NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Toyota Highlander';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_Highlander - ',veh_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%   Curb weight per Toyota website:
%   2WD (4-cyl/V6): 3485/3660 lbs
%   4WD (4-cyl/V6): 3715/3880 lbs
%	The glider mass below is an estimate.
veh_glider_mass=1276; % (kg), vehicle mass w/o propulsion system (fuel converter, exhaust aftertreatment, transmission)
veh_CD=0.34;  % (--), coefficient of aerodynamic drag
veh_FA=(71.9*2.54/100)*(66.1*2.54/100)*0.85;    % (m^2), frontal area -- assumes FA~=width*height*85%
% Note: Assumes front wheel drive.  To simulate rear wheel drive, write front weight fraction (FWF) 
% as 1-FWF and cg height as -1*cg_height.
veh_front_wt_frac=0.6;  % (--), estimated -- not based on data for this specific vehicle.  Fraction of vehicle weight on front axle when standing still.
veh_cg_height=0.5;% (m), estimate -- not based on data for this specific vehicle.  Height of vehicle center-of-gravity above the road.
veh_wheelbase=106.9*2.54/100;	% (m), vehicle wheelbase, from center of front tire patch to center of rear patch.
veh_cargo_mass=136; %kg  cargo mass


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  04/07/03 Created by TM
