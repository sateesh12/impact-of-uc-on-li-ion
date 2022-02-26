% ADVISOR data file:  VEH_smallTruck.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a real minivan.
% 
% Created on: 10/03/02
% By:  AB of NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Real small truck';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_smallTruck - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual average vehicle mass of this small truck is 1451 kg.
%		The glider mass below is just an estimate.
veh_glider_mass=971; % (kg), vehicle mass w/o propulsion system (fuel converter, exhaust aftertreatment, transmission)
veh_CD=0.36;  % (--), estimated coefficient of aerodynamic drag
veh_FA=1.9;    % (m^2), frontal area
% NOTE: Front weight fraction (FWF) set to 1-FWF and CG height set to negative to simulate rear-wheel drive
veh_front_wt_frac=1-0.58;  % (--), estimated.  Not based on data for this specific vehicle.  Fraction of vehicle weight on front axle when standing still.
veh_cg_height=-0.5;% (m), estimated.  Not based on data for this specific vehicle.  Estimated for 1995 Saturn SL: height of vehicle center-of-gravity above the road.
veh_wheelbase=3.12;	% (m), vehicle wheelbase, from center of front tire patch to center of rear patch.
veh_cargo_mass=136; %kg  cargo mass


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  10/03/02 Created by AB
%  01/13/03 Set to rear-wheel drive