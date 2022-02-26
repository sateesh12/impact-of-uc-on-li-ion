% ADVISOR data file:  VEH_largeSUV.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a real largeSUV car.
% 
% Created on: 10/03/02
% By:  AB of NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Real large SUV';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_largeSUV - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual average vehicle mass of this large SUV is 2423 kg.
%		The glider mass below is just an estimate.
veh_glider_mass=1683; % (kg), vehicle mass w/o propulsion system (fuel converter, exhaust aftertreatment, transmission)
veh_CD=0.43;  % (--), estimated coefficient of aerodynamic drag
veh_FA=2.9;    % (m^2), frontal area
% Note: front weight fraction written as 1-FWF and cg height set to negative to simulate rear wheel drive
veh_front_wt_frac=1-0.6;  % (--), estimated.  Not based on data for this specific vehicle.  Fraction of vehicle weight on front axle when standing still.
veh_cg_height=-0.5;% (m), estimated.  Not based on data for this specific vehicle.  Estimated for 1995 Saturn SL: height of vehicle center-of-gravity above the road.
veh_wheelbase=2.99;	% (m), vehicle wheelbase, from center of front tire patch to center of rear patch.
veh_cargo_mass=136; %kg  cargo mass


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  10/03/02 Created by AB
%  01/13/02 Changed to rear-wheel drive