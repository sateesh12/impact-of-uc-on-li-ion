% ADVISOR data file:  TC_PTH.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines lossless belt drive with a ratio that puts motor at top speed when
% vehicle hits 95-100 mph (depending on tire slip characteristics).

%
% Created on: 5/5/99
% By:  tm, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc_description='Torque coupler for post-transmission hybrid';
tc_version=2003; % version of ADVISOR for which the file was generated
tc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TC_PTH - ',tc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc_loss=0; % N*m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constant ratio of speed at motor torque input to speed at engine torque input
% (which may in fact be provided via the gearbox)
%tc_mc_to_fc_ratio=0.99*max(mc_map_spd)/max(fc_map_spd); % (--)

% gear ratio to match mc an fc max speeds in pth hybrid
%tc_mc_to_fc_ratio=0.99*max(mc_map_spd)/max(max(fc_map_spd)./gb_ratio); % (--)
tc_mc_to_fc_ratio=max(mc_map_spd)/(100*.447/wh_radius/fd_ratio);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5/5/99:tm file created from TC_DUMMY
% 10/8/99:mc updated ratio to give about ~95 mph top speed (100 w/o slip)




% 11/03/99:ss updated version from 2.2 to 2.21