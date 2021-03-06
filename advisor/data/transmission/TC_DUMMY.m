% ADVISOR data file:  TC_DUMMY.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines lossless belt drive with a motor-to-engine speed ratio that
% ensures the motor is at top speed when the engine is at top speed.
%
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc_description='lossless belt drive';
tc_version=2003; % version of ADVISOR for which the file was generated
tc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TC_DUMMY - ',tc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc_loss=0; % N*m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constant ratio of speed at motor torque input to speed at engine torque input
% (which may in fact be provided via the gearbox)
tc_mc_to_fc_ratio=0.99*max(mc_map_spd*mc_spd_scale)/max(fc_map_spd*fc_spd_scale); % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/15/99:ss updated *_version to 2.1 from 2.0





% 11/03/99:ss updated version from 2.2 to 2.21
% 5/18/00:tm added *mc_spd_scale and *fc_spd_scale
%