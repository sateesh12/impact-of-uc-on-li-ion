% ADVISOR Data file:  VEH_KENT800Trailer.M
%
%
% Data source:  various
%
% Data confidence level:  {provide details as to how well the data 
% represents the source data.}
%
% Notes:  {include any other comments pertaining to the data or use 
% the data} 
%
% Created on:  05/28/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Kenworth T800 Vehicle'; % one line descriptor identifying the engine
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_KENT800.m - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.23; % kg/m^3


% Vehicle data
%veh_CD=0.79; % for a transit bus (ref. SAE 931788)
veh_CD=0.70; % typical truck and trailer (ref. Motor Truck Engineering Handook)
%veh_CD=0.77; % for doubles, triples, and loaded flat beds (ref. Motor Truck Engineering Handook)
%veh_CD=1.0; % for car haulers (ref. Motor Truck Engineering Handook)
%veh_FA=114.75/10.76;	% (m^2) (ref. manufacture literature)
veh_FA=92/10.76;	% (m^2) (ref. WVU test data)
%veh_1st_rrc=0.008; % for truck (ref. Bosch, 1993)
%veh_1st_rrc=0.00938; % for truck (ref. WVU test data)
%veh_2nd_rrc=0;	% unknown 
veh_cg_height=1.5; % unknown (m)
veh_front_wt_frac=0.4; % 20% tractor front, 40% tractor rear(driving), 40% trailer axles  
%veh_wheelbase=170/39.37; % unknown (m)
veh_wheelbase=32*12/39.37; % (m) tractor rear axle to trailer axle for a 40 ft trailer
veh_glider_mass=12800/2.2046-18*80-333-86.3372493059547-1394.67864263465; % (kg), 12800 lbs. vehicle minus other components, estimated
veh_cargo_mass=39040-veh_glider_mass-18*80-333-86.3372493059547-1394.67864263465; %kg  cargo mass from trailer
%veh_cargo_mass=28000/2.2046; % (kg) fully loaded trailer

%revision history
% 5/28/98 file created from v_t800.m: tm
% 7/10/98 tm: wheel and axle data moved to WH_HEAVY.m
% 1/20/98:tm updated with data from WVU
% 2/24/99:tm updated for march 99 release
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 11/03/99:ss updated version from 2.2 to 2.21