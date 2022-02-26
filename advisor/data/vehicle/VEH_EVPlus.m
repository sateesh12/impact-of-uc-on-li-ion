% ADVISOR data file:  VEH_EVPlus.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a real compact car.
% 
% Created on: 10/03/02
% By:  AB of NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Honda EV Plus';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_EVPlus - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
% Curb mass = 3593.5 lbs (EV Plus)
% Curb mass = 3713 lbs (FCX)
% 
%		The glider mass below is just an estimate.
veh_glider_mass=999; % (kg), vehicle mass w/o propulsion system (fuel converter, exhaust aftertreatment, transmission)
veh_CD=0.30;  % (--), coefficient of aerodynamic drag
%veh_FA=2.1;    % (m^2), frontal area
veh_FA=(68.9*2.54/100)*(64.2*2.54/100)*0.85;    % (m^2), frontal area -- assumes (width*height*85%)
veh_front_wt_frac=0.6;  % (--), estimated.  Not based on data for this specific vehicle.  Fraction of vehicle weight on front axle when standing still.
veh_cg_height=0.4;% (m), estimated.  Not based on data for this specific vehicle.  Estimated for 1995 Saturn SL: height of vehicle center-of-gravity above the road.
veh_wheelbase=99.6*2.54/100;	% (m), vehicle wheelbase, from center of front tire patch to center of rear patch.
veh_cargo_mass=136; %kg  cargo mass


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  04/07/03 Created by TM