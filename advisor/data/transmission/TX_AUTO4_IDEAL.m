% ADVISOR data file:  TX_AUTO4_IDEAL.m
%
% Data source:
% Gear ratios and torque converter characteristics taken from JDM & Associates'
% "Drive_line," dated May 1998.
%
% Mass was taken from "Automotive Technologies to Improve Fuel Economy to 2015"
% prepared for the Office of Technology Assessment by Energy and Environmental 
% Analysis, Inc. Draft report Dec. 1994.
%
% Based upon TX_AUTO4 but with a 100% efficient gearbox (i.e., the only losses 
% will come from hydraulic torque converter).
%
% Data confirmation:
%
% Notes:
% This file defines a 4-speed automatic transmission including hydraulic torque
% converter, gearbox, and final drive.
%
% Created on: 03-Aug-2001
% By:  MPO, NREL, michael_okeefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='auto 4 speed';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx_description='4-spd Automatic Transmission with 100% efficient gearbox'; 
tx_version=2003; % version of ADVISOR for which the file was generated
tx_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tx_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_AUTO4_IDEAL - ',tx_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYDRAULIC TORQUE CONVERTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS/SR/TR PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% speed ratio index, SR=wout/win
htc_sr=[0:0.01:0.1 0.15:0.05:1]; % (--)
% torque ratio, indexed by SR, TR=Tout/Tin
htc_tr=[2 1.99 1.98 1.96 1.95 1.94 1.93 1.92 1.91 1.89 1.88 1.83 1.77 1.72 1.66 1.60 ,...
   1.55 1.49 1.43 1.38 1.32 1.26 1.21 1.15 1.10 1.04 1 1 1]; % (--)
% Note: temp files used for processing and not in the model. temp variables are deleted at end of file
% k factor, K=wi/(Ti)^.5
temp_input_spd=[1444 1443 1446 1448 1450 1453 1456 1459 1461 1464 1466 1480 1494 1509 1525 1549 ,...
   1574 1604 1637 1678 1722 1775 1833 1899 1973 2107 2272 3044 3045]*pi/30;
temp_trq=100;
htc_k=temp_input_spd./(temp_trq)^.5; % (rad/s/(Nm)^.5)
% New K factor, K_adv=wout/(Tout)^.5=K*SR/(TR^0.5)
htc_k_adv=htc_k.*htc_sr./(htc_tr).^0.5;

%Coasting behavior
%htc_sr_coast=1./[1:-.025:.9 .85:-.05:.7 .6:-.1:.1 .05]; % tm 8/29/00 replaced with lines below
temp_output_spd=[4000 3750 3370 3000 2670 2280 2130 1990 1890 1780 1710 1660 1640 1635 1630 1626]*pi/30;
%temp_input_spd=temp_output_spd./htc_sr_coast; % tm 8/29/00 replaced with lines below
%htc_tr_coast=1/0.987*ones(size(htc_sr_coast)); % tm 8/29/00 replaced with lines below
temp_trq=-80;
%htc_k_coast=temp_input_spd./(abs(temp_trq))^.5; % (rad/s/(Nm)^.5) % tm 8/29/00 replaced with lines below

%%%% ADDED tm:8/29/00 to produce lower SR's during coast
htc_pwr_out_temp=temp_output_spd.*temp_trq;
htc_sr_coast=-2./(htc_pwr_out_temp/745.7+eps)+ 1; % torque converter characteristics taken from JDM & Associates' "Drive_line," dated May 1998.
htc_tr_coast=1/0.987*ones(size(htc_sr_coast));
temp_input_spd=temp_output_spd./htc_sr_coast;
htc_k_coast=temp_input_spd./(abs(temp_trq))^.5; % (rad/s/(Nm)^.5)
%%%% END ADDED tm:8/29/00

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
gb_ratio=3.08*[2.91	1.64	1.07	0.78];
gb_gears_num=4; % (--), number of discrete gear choices in gearbox
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TX_VW % FILE ID, LOSSES
%load tx_auto4_26_50_4 % load tx_eff_map, tx_map_spd, tx_map_trq variables
tx_eff_map=[1 1; 1 1];
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
fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=110/2.205;
gb_mass=141/2.205;
tx_mass=(gb_mass+fd_mass);% (kg), mass of the gearbox + final drive=(transmission)


% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear temp*

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
% 8/29/00:tm added statements to calculate the SR during coast based on that previously used in A2.2.1
%            calcs commented out produced very high SR's and limited regen capability
% 7/09/01:mpo changed the transmission gearbox efficiency to use lookup tables
% 7/18/01:mpo added an "if exist" statement around equation for fc_inertia to avoid warning messages
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)
% 8/06/01:mpo created file from tx_auto4