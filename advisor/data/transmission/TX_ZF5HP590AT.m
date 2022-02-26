% ADVISOR data file:  TX_ZF5HP590AT.m
%
% Data source:
% 
%
% Data confirmation: none
%
% Notes:
% This file defines a 5-speed heavy-duty automatic-transmission for a transit bus application.
% Gear ratios are based on the ZF5HP590. Torque converter extrapolated from information on the
% TC-419 torque converter used on Allison's B400 transmission.
%
% Note that this is a *first pass* analysis to simulate a 5-speed transmission for a transit bus
% application. This transmission has not been validated.
%
%
% Created on: 03 April 2001
% By:  mpo, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='auto 4 speed'; % really an auto 5 speed but use this to select correct simulink model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx_description='Heavy-Duty Automatic Transmission especially for use in Bus Applications (gear ratios based on ZF5HP590)'; 
tx_version=2003; % version of ADVISOR for which the file was generated
tx_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tx_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_ZF5HP590AT - ',tx_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYDRAULIC TORQUE CONVERTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS/SR/TR PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% speed ratio index, SR=wout/win
htc_sr=[0:0.01:0.1 0.15:0.05:1]; % (--)
% torque ratio, indexed by SR, TR=Tout/Tin
htc_tr=[2.02 1.99 1.98 1.96 1.95 1.94 1.93 1.92 1.91 1.89 1.88 1.83 1.77 1.72 1.66 1.60 ,...
      1.55 1.49 1.43 1.38 1.32 1.26 1.21 1.15 1.10 1.04 1 1 1]; % (--), mpo 10 Jan 2001: first entry changed
%... from 2 to 2.02 to reflect the stall TR for TC-419 available from Allison Transmission (for use with
%... B400(P)(R) amoung other transmissions.
% Note: temp files used for processing and not in the model. temp variables are deleted at end of file
% k factor, K=wi/(Ti)^.5, can be indexed by SR
temp_input_spd=[1444 1443 1446 1448 1450 1453 1456 1459 1461 1464 1466 1480 1494 1509 1525 1549 ,...
      1574 1604 1637 1678 1722 1775 1833 1899 1973 2107 2272 3044 3045]*(pi/30)*0.38095238095238;
% mpo 10 Jan 2001: the factor of 0.381 is used to adjust the K at stall down to 5.76 rad/s/(Nm)^0.5 which is the 
% ... stall Kp factor for TC-419 available through Allison Transmission for use with the B400 transmission
% ... amoung others
temp_trq=100;
htc_k=temp_input_spd./(temp_trq)^.5; % (rad/s/(Nm)^.5)
% New K factor, K_adv=wout/(Tout)^.5=K*SR/(TR^0.5), can be indexed by SR
htc_k_adv=htc_k.*htc_sr./(htc_tr).^0.5;

%Coasting behavior
htc_sr_coast=1./[1:-.025:.9 .85:-.05:.7 .6:-.1:.1 .05];
temp_output_spd=[4000 3750 3370 3000 2670 2280 2130 1990 1890 1780 1710 1660 1640 1635 1630 1626]*pi/30;
temp_input_spd=temp_output_spd./htc_sr_coast;
htc_tr_coast=1/0.987*ones(size(htc_sr_coast));
temp_trq=-80;
htc_k_coast=temp_input_spd./(abs(temp_trq))^.5; % (rad/s/(Nm)^.5)
% New K factor, K_adv=wout/(Tout)^.5=K*SR/(TR^0.5)
htc_k_adv_coast=htc_k_coast.*htc_sr_coast./(htc_tr_coast).^0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
htc_max_coast_tr=1;       % (--), maximum torque ratio while coasting
htc_min_coast_tr=-0.035;  % (--), minimum torque ratio while coasting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Turbine inertia plus 1/2 fluid inertia = htc inertia
htc_inertia=0.056; %Nm-s^2
%Impeller inertia plus 1/2 fluid inertia is added to engine inertia
if exist('fc_inertia')
   fc_inertia=fc_inertia+.109; %Nm-s^2
end
%Note: htc_lockup found in PTC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_ratio=[3.43	2.01	1.42	1.00 0.83];
% mpo 03 April 2001: source 1998 Diesel Truck Index; gear ratios do not include torque converter ratios
%gb_ratio=[3.49	1.86	1.41	1.00 0.75]; % (--), ratios in gearbox added by
gb_gears_num=5; % (--), number of discrete gear choices in gearbox

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
%gb_loss_input_spd_coeff=0.0;
%gb_loss_output_spd_coeff=0.0;
%gb_loss_input_trq_coeff=0.0;
%gb_loss_output_trq_coeff=0.0;
%gb_eta_constant = 0.85; % constant 85% efficiency gear box; 
%gb_loss_output_pwr_coeff=(1-gb_eta_constant)/gb_eta_constant; % Used so efficiency comes out correctly: (1-eta)/eta where eta is efficiency
%gb_loss_const=0.0;
gb_inertia = 0.0; % kg*m*m, unknown 

tx_eff_map=[0.85 0.85;0.85 0.85]; % 85% efficiency gearbox over all gears, torques, and speeds

tx_map_spd=[0 1000];

tx_map_trq=[-1000 1000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the following variable is not used directly in modelling and should always 
%be equal to one; it's used for initialization purposes
gb_eff_scale=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINAL DRIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=4.33;   % (--), =(final drive input speed)/(f.d. output speed); this is an available ratio for Eaton rear axles up to over 23,000 lbs. GCW
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input

gb_mass=141/2.205; % (kg)

fd_mass=110/2.205; % (kg)

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)
% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

% Begin added by ADVISOR 3.2 converter: 07-Aug-2001
tx_mass_scale_coef=[1 0 1 0];

tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
% End added by ADVISOR 3.2 converter: 07-Aug-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear temp* *temp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98:tm gb_mass added
% 09/30/98:ss added fd variables and added tx_mass
% 10/07/98:mc added htc variables
% 10/16/98: ss changed GB_VW to TX_VW because of new filename
%12/22/98:ss added variable tx_type to determine what block diagram to run.
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 05/23/00: vhj new HTC model.  Version 2.22
% 06/28/01: mpo added comments to new file based off of auto 4 transmission
% 02-Aug-2001: automatically updated to version 3.2