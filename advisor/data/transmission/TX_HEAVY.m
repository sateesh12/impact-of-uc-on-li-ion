% ADVISOR data file:  TX_HEAVY.m
%
% Data source:
%
% Data confirmation:
%
% Notes: This file was created based on TC_VW.m and results in a 
% constant efficiency transmission.  The relationships from TX_VW 
% do not easily scale up to what would be required for heavy duty vehicle.
%
% Created on: 1-1-1999
% By:  TM, NREL, Tony_Markel@nrel.gov
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
gb_description1=['Generic ',num2str(gb_gears_num),'-spd '];
gb_description2=' constant efficiency gearbox ';
gb_description=[gb_description1 gb_description2];
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validated=1;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
disp(['Data loaded: TX_HEAVY - ',gb_description])


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
%gb_loss_input_spd_coeff=0.614307976;
%gb_loss_output_spd_coeff=5.530953616;
%gb_loss_input_trq_coeff=-0.861652506;
%gb_loss_output_trq_coeff=0.229546756;
%gb_loss_output_pwr_coeff=0.023981187;
%gb_loss_const=-92.07523029;

if 0
   % 100% efficienct gearbox
   %gb_loss_input_spd_coeff=0;
   %gb_loss_output_spd_coeff=0;
   %gb_loss_input_trq_coeff=0;
   %gb_loss_output_trq_coeff=0;
   %gb_loss_output_pwr_coeff=0;
   %gb_loss_const=0;
   tx_map_spd=[0 10000]; % speed of transmission shaft output (wheel-side of transmission) in rad/s
   tx_map_trq=[-10000 10000]; % torque of transmission shaft output (wheel-side of transmission) in Nm
   tx_eff_map=[1 1;1 1]; % transmission efficiency; row index is tx_map_spd, col index is tx_map_trq
   
else
   % 92% efficienct gearbox
   % NOTES: (6 July 2001, mpo) changing from equation form of transmission efficiency to lookup method
   tx_map_spd=[0 10000]; % speed of transmission shaft output (wheel-side of transmission) in rad/s
   tx_map_trq=[-10000 10000]; % torque of transmission shaft output (wheel-side of transmission) in Nm
   tx_eff_map=[0.92 0.92;0.92 0.92]; % transmission efficiency; row index is tx_map_spd, col index is tx_map_trq
%   gb_loss_input_spd_coeff=0;
%   gb_loss_output_spd_coeff=0;
%   gb_loss_input_trq_coeff=0;
%   gb_loss_output_trq_coeff=0;
%   eta = 0.92; % 2 Feb 2001: mpo--this is the efficiency of the gearbox--92%
   %gb_loss_output_pwr_coeff=1-0.92; % 2 Feb 2001: mpo-- this is the old way constant efficiency was handled
%   gb_loss_output_pwr_coeff = (1-eta)/eta; % 2 Feb 2001: mpo-- implemented this "fix" for powered efficiency
%   gb_loss_const=0;
%   clear eta; % 2 Feb 2001: mpo, clear the temporary variable eta
   % NOTES: (2 Feb 2001, mpo), the above specification for a constant efficiency gearbox is a 
   % ...workaround using the existing implementation. As such, it is not exactly perfect.
   % ...In previous versions of ADVISOR, powered gearbox efficiency (transmission) would not show
   % ...up correctly. To fix this, efficiency is now specified as (1-eta)/eta instead of (1-eta). Note
   % ...that transmission efficiency will be displayed as 1-(1-eta)/eta in the first screen of ADVISOR 
   % ...i.e., transmission efficiency will *not* equal eta. However, upon running the model, one will see
   % ...that the transmission efficiency is indeed eta during the powered case. Note that the regen efficiency
   % ...will be incorrect, however. We at NREL are aware of this problem and are planning a new implementation
   % ...for the gearbox/transmission efficiency in a future release of ADVISOR. If you have questions, plese
   % ...contact Michael_O'Keefe@nrel.gov.
end;


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
% 1/1/99:tm file created from TX_VW.m
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 2/23/00:tm introduced trq_scale and spd_scale parameters to work with the new block diagrams
% 2-Feb-2001:mpo updated the way in which constant efficiency is input into model; changed version from 3.0 to 3.1
% 6-Jul-2001:mpo changing from equation form of transmission efficiency to lookup table