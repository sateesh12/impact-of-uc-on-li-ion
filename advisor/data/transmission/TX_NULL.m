% ADVISOR data file:  TX_NULL.m
%
% Data source:
%
% Notes:
%
% Created on: 7/24/00
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('gb_ratio')
  % The tested transmission had four gears, with the gear ratios listed
  % as the first four entries in 'gb_ratio,' below.

  gb_ratio=[13.45 7.57 5.01 3.77 3.77*3.77/5.01];
  gb_gears_num=5;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_version=2003;
gb_description=['Null gearbox loss file'];
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validated=1;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
disp(['Data loaded: TX_NULL - ',gb_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% torque loss, measured at the input shaft, is represented as a function:
% P_loss = (gb_loss_input_spd_coeff * gear_ratio + gb_loss_output_spd_coeff)...
%		* output_shaft_speed...
%	 + (gb_loss_input_trq_coeff / gear_ratio + gb_loss_output_trq_coeff)...
%		* output_shaft_torque...
%	 + gb_loss_output_pwr_coeff * output_shaft_power +...
%	 + gb_loss_const
%
% Note that  output_shaft_speed * gear_ratio = input_shaft_speed,
% and 	   output_shaft_torque / gear_ratio = input_shaft_torque * efficiency
% So with efficiency ~ 1, the above regression equation is against input and
% output torque and speed.
%
% Also note that the gear ratio in the equation above is the overall ratio,
% including the gearbox and the final drive.
%gb_loss_input_spd_coeff=0;
%gb_loss_output_spd_coeff=0;
%gb_loss_input_trq_coeff=0;
%gb_loss_output_trq_coeff=0;
%gb_loss_output_pwr_coeff=0;
%gb_loss_const=0;

% 100% efficient-- 6-July-2001 mpo, 
tx_map_spd=[0 10000]; % speed of transmission shaft output (wheel-side of transmission) in rad/s
tx_map_trq=[-10000 10000]; % torque of transmission shaft output (wheel-side of transmission) in Nm
tx_eff_map=[1 1;1 1]; % transmission efficiency; row index is tx_map_spd, col index is tx_map_trq

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear gb_description1 gb_description2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/24/00:tm file created from TX_VW
% 6 July 2001:mpo change from equation to lookup form of transmission efficiency determination
%