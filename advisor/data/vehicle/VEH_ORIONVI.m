% ADVISOR Data file:  VEH_ORIONVI.M
%
%
% Data source:  Briefing Packet, Paul Norton (NREL) 10/29/98
%
% Data confidence level:  {provide details as to how well the data 
% represents the source data.}
%
% Notes:  {include any other comments pertaining to the data or use 
% the data} 
%
% Created on:  11/4/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Orion VI Low-Floor Transit Bus'; % one line descriptor identifying the engine
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_ORIONVI.m - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.23; % kg/m^3


% Vehicle data
veh_CD=0.79; % for a transit bus (ref. SAE 931788)
veh_FA=102*(122-12)/144/10.76;	% (m^2) width*height-clearance given in inches
%veh_FA=6.52;	% (m^2) (ref. SAE 931788)
%veh_1st_rrc=0.008; % for truck (ref. Bosch, 1993)
%veh_1st_rrc=0.00938; % for truck (ref. WVU test data)
%veh_2nd_rrc=0;	% unknown 
veh_cg_height=0.25*122/39.37; % unknown (m)
veh_front_wt_frac=0.45; % unknown  
veh_wheelbase=270/39.37; % (m)
veh_glider_mass = 12636; % (kg) (ref. SAE 931788)
veh_cargo_mass=150/2.2046*27; % (kg) 27 people at 150 lbs/person (1/2 passenger load) (ref. SAE 931788)

%revision history
% 11/4/98:tm file created from veh_kent800.m
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc