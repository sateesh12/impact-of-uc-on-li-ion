% ADVISOR data file:  TX_AnnexVII_conv.m
%
% Data source:
%
% Data confirmation:
%
% Notes: This file was created based on TC_VW.m and results in a 
% constant efficiency transmission.  The relationships from TX_VW 
% do not easily scale up to what would be required for heavy duty vehicle.
%
% Created on: 01-Mar-2001
% By:  Jacob Eelkema, eelkema@wt.tno.nl
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('gb_ratio')
  % The tested transmission had four gears, with the gear ratios listed
  % as the first four entries in 'gb_ratio,' below.

  gb_ratio=[6.932 3.821 2.224 1.406 1.007 0.801];
  gb_gears_num=6;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_version=2003;
gb_description1=['Generic ',num2str(gb_gears_num),'-spd '];
gb_description2=' constant efficiency 92% gearbox for AnnexVII reference vehicle';
gb_description=[gb_description1 gb_description2];
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validated=1;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
disp(['Data loaded: TX_AnnexVII_conv.m - ',gb_description])


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
   gb_loss_input_spd_coeff=0;
   gb_loss_output_spd_coeff=0;
   gb_loss_input_trq_coeff=0;
   gb_loss_output_trq_coeff=0;
   gb_loss_output_pwr_coeff=0;
   gb_loss_const=0;
else
   % 96% efficienct gearbox
   gb_loss_input_spd_coeff=0;
   gb_loss_output_spd_coeff=0;
   gb_loss_input_trq_coeff=0;
   gb_loss_output_trq_coeff=0;
   eta = 0.96; 
   gb_loss_output_pwr_coeff = (1-eta)/eta; % 2 Feb 2001: mpo-- implemented this "fix" for powered efficiency
   gb_loss_const=0;
   clear eta; % 2 Feb 2001: mpo, clear the temporary variable eta
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
gb_eff_scale=1;
gb_mass=0;
tx_mass=0;
tx_type='manual 6 speed';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Final drive data		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
fd_inertia=0;
fd_loss=0;

fd_mass=0;
fd_ratio=5.13;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear gb_description1 gb_description2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 01/Mar/2001:JE file created from TX_HEAVY.m


% Begin added by ADVISOR 2002 converter: 16-Apr-2002
tx_description='manual 5 speed transmission with 100% efficiency gearbox';

tx_eff_map=[1 1;1 1]*0.96; % 96% efficient gearbox

tx_map_spd=[0 1e+004];

tx_map_trq=[-1e+004 1e+004];

tx_mass_scale_coef=[1 0 1 0];

tx_version=2003;

tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
% End added by ADVISOR 2002 converter: 16-Apr-2002