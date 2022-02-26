% ADVISOR Data file:  VEH_ANNEXVII_CONV.M
%
%
% Data source:    -Mainly from DAF data obtained during DAF hybrid truck project
%						-Lastauto omnibus
%
% Data confidence level:
%
% Notes:   
%
% Created on:  01-Mar-2001
% By:  Jacob Eelkema 	// eelkema@wt.tno.nl
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Reference vehicle for Annex VII HD comparative assessment'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_ANNEXVII_CONV.M - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.23; % kg/m^3


% Vehicle data
veh_CD=0.70;
veh_FA=8;	% (m^2)
veh_1st_rrc=0.006; %
veh_2nd_rrc=0;	% unknown 
veh_cg_height=1.5; % unknown (m), estimate
veh_front_wt_frac=0.4; % 20% tractor front, 40% tractor rear(driving), 40% trailer axles  
veh_wheelbase=4.9; % (m) tractor rear axle to trailer axle for a 40 ft trailer
veh_glider_mass = 5200; % (kg) total vehicle mass empty of reference vehicle
veh_cargo_mass=12800; %kg  cargo mass only


%revision history


% Begin added by ADVISOR 2002 converter: 16-Apr-2002
veh_proprietary=0;

veh_validation=0;

veh_version=3.2;

clear veh_1st_rrc veh_2nd_rrc; % these variables now being declared in wh_* file as wh_1st_rrc etc.=[];

% End added by ADVISOR 2002 converter: 16-Apr-2002