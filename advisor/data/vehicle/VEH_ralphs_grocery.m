% ADVISOR Data file:  VEH_ralphs_grocery.M
%
%
% Data source:  best guess of data from "EC-Diesel Technology Validation Program Interim Report" SAE 2000-01-1854
%
% Data confidence level:  {provide details as to how well the data 
% represents the source data.}
%
% Notes:  {include any other comments pertaining to the data or use 
% the data} 
%
% Created on:  30 August 2001
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Ralphs Grocery 1998 Sterling L-Line Class 8 Tractor Trailor'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_ralphs_grocery.M - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.23; % kg/m^3


% Vehicle data
veh_CD=0.70; % typical truck and trailer (ref. Motor Truck Engineering Handook)
%veh_CD=0.77; % for doubles, triples, and loaded flat beds (ref. Motor Truck Engineering Handook)
%veh_CD=1.0; % for car haulers (ref. Motor Truck Engineering Handook)
%veh_FA=114.75/10.76;	% (m^2) (ref. manufacture literature)
veh_FA=92/10.76;	% (m^2) (ref. WVU test data)
%veh_1st_rrc=0.008; % for truck (ref. Bosch, 1993)
%veh_1st_rrc=0.00938; % for truck (ref. WVU test data)
%veh_2nd_rrc=0;	% unknown 
veh_cg_height=-1.5; % unknown (m)
veh_front_wt_frac=0.4; % 20% tractor front, 40% tractor rear(driving), 40% trailer axles  
%veh_wheelbase=170/39.37; % unknown (m) tractor front to reat
veh_wheelbase=32*12/39.37; % (m) tractor rear axle to trailer axle for a 40 ft trailer
veh_glider_mass = 12800/2.2046; % (kg)
veh_cargo_mass=136; %kg  cargo mass passegers only
%veh_cargo_mass=28000/2.2046; % (kg) fully loaded trailer


%revision history
% 5/28/98 file created from v_t800.m: tm
% 1/20/98:tm updated with data from WVU
% 2/24/99:tm updated for march 99 release
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc