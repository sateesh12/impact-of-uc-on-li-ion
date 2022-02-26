% ADVISOR data file:  TX_VW.m
%
% Data source:
% van Dongen, L. A. M., "Efficiency Characteristics of Manual and Automatic
% Passenger Car Transaxles," SAE Paper No. 820741.  Parameters for the equation
% implemented below, for torque loss at the input side as a function of output
% torque, output speed, and gear ratio, were derived by fitting the data in the
% paper.  R. Swiatek of Chrysler provided significant assistance in extracting
% the data from the SAE paper.
%
% Data confirmation:
% The consistency of this regression equation with the original source data
% has been checked at NREL, as has the reasonableness of the equation's
% dependence on gear ratio.  Note that the verification was completed
% using input torques up to and including 87.5 Nm.
%
% Notes:
% 1.  This data represents the gearbox AND final drive loss data assuming a
% vehicle of zero mass.  In order to accurately estimate drivetrain efficiency,
% a. wheel and axle bearing drag and brake drag must be included, either in the
%    coefficient of rolling resistance or elsewhere, and
% b. the externally defined final drive losses, stored in the scalar variable
%    'fd_loss,' must be zeroed out.
% ADVISOR version 2.0 uses a hard-wired bearing drag curve to account for the
% bearing and brake drags, so the appropriate coefficient of rolling resistance
% to use is the tire-only value, in the range of 0.005 to 0.007 for advanced
% tires.  
% 2.  The paper had information for a 4-speed manual, which has been
% generalized to any number of gears.
% 3.  The development of the regression equations used here are documented in
% the MS Excel worksheet "VW tranny.xls/l.pwr.reg.-low intrq, low inspd" on
% MRC's hard drive.
%
% Created on: 4-May-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
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
gb_description1=['Volkswagen ',num2str(gb_gears_num),'-spd '];
gb_description2=' gearbox 110 Nm/5500 rpm max. input';
gb_description=[gb_description1 gb_description2];
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validated=1;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
disp(['Data loaded: TX_VW - ',gb_description])


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
%
% 6-July-2001: mpo> load tx_eff_map, tx_map_spd, and tx_map_trq; data generated 
% from gb_loss_* variables and loss equation above using ../gui/tx_eff_mapper.m
load tx_vw_eff_map_26_50_5; % medium size map with decent detail and speed
%load tx_vw_eff_map_77_126_5; % larger more detailed map (slows down simulation substantially)
%load tx_vw_eff_map_15_36_5; % smaller map

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
% 23-Jun-1993 (MRC): cosmetic improvements
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 4/28/99:mc updated comments
% 11/03/99:ss updated version from 2.2 to 2.21
% 2/23/00:tm introduced trq_scale and spd_scale parameters to work with the new block diagrams
% 6 July 2001:mpo added functionality for lookup-table efficiency in the gearbox