% ADVISOR data file:  TX_MT643.m
%
% Data source:
%
%
% Data confirmation:
%
% Notes:
% This file defines the Allison MT-643 4-speed automatic transmission 
% including hydraulic torque converter, gearbox, and final drive.  No data
% was available for the torque converter so a constant 85% efficiency for 
% the system is assumed.
%
% Created on: 5/5/99
% By:  tm, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 5 speed'; % actually an auto 4 spd but this is reqired so correct block diagram (BD_CONV is selected)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_ratio=[3.58	2.09	1.39	1.00]; % (--), ratios in gearbox
gb_gears_num=4; % (--), number of discrete gear choices in gearbox


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx_description='Allison MT-643 4-speed automatic trans. (School Bus/Transit Bus)'; 
tx_version=2003; % version of ADVISOR for which the file was generated
tx_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tx_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_MT643_MT - ',tx_description]);

gb_version=2003;
gb_description1=['Generic ',num2str(gb_gears_num),'-spd '];
gb_description2=' constant efficiency gearbox ';
gb_description=[gb_description1 gb_description2];
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validated=0;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
%disp(['Data loaded: TX_HEAVY - ',gb_description])
clear gb_description1 gb_description2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% 85% efficienct gearbox
% 6-July-2001 mpo: changing to lookup method for transmission efficiency from equation form
tx_map_spd=[0 10000]; % speed of transmission shaft output (wheel-side of transmission) in rad/s
tx_map_trq=[-10000 10000]; % torque of transmission shaft output (wheel-side of transmission) in Nm
tx_eff_map=[0.85 0.85;0.85 0.85]; % transmission efficiency; row index is tx_map_spd, col index is tx_map_trq
% note: the way the algorithm works, since only one map is specified, it will be used for all gears
% ... i.e., 85% efficient over all torque, speed, and gears. Also note that the below mentioned problem
% ... has been solved--85% efficiency is obtained for both powered and regen.

%gb_loss_input_spd_coeff=0;
%gb_loss_output_spd_coeff=0;
%gb_loss_input_trq_coeff=0;
%gb_loss_output_trq_coeff=0;
%eta = 0.85; % constant efficiency of the gearbox
%gb_loss_output_pwr_coeff=1-0.85; % assumes constant ~85% efficiency; 
% above is 2 Feb 2001, mpo Old Way of doing constant efficiency
%gb_loss_output_pwr_coeff = (1-eta)/eta; % 2 Feb 2001: new efficiency method
%gb_loss_const=0;
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

gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the following variable is not used directly in modelling and should always 
%be equal to one; it's used for initialization purposes
gb_eff_scale=1;
gb_spd_scale=1;
gb_trq_scale=1;


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
fd_ratio=5.38;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=200/2.205;
gb_mass=625/2.205;
tx_mass=(gb_mass+fd_mass)/2.205; % (kg), mass of the gearbox + final drive=(transmission) estimated


% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship



% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5/5/99:tm file created from TX_AUTO4
% 2-Feb-2001:mpo updated the way in which constant efficiency is input into model; changed version to 3.1
% 6-July-2001:mpo changing from equation form to lookup form of transmission efficiency determination
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)
% 7/31/01:mpo changed a ':' to ';' on 'fd_mass=200/2.205:' which was causing an error