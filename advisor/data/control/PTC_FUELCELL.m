% ADVISOR data file:  PTC_FUELCELL.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a series hybrid using a thermostat control strategy.
% To ensure proper operation, this file must be reloaded every time the FC or
% GC is rescaled.
% 
% Created on: 2-Sep-1998
% By:  MJO, VT, Mike Ogburn%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('update_cs_flag')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Powertrain control - hybrid w/thermostat cs';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_FUELCELL - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fractional engine load {=(torque)/(max torque at speed)} above which a
% downshift is called for, indexed by gb_gearN_dnshift_spd
gb_gear1_dnshift_load=[2 2];  % (--)
gb_gear2_dnshift_load=[2 2];  % (--)
% fractional engine load {=(torque)/(max torque at speed)} below which an
% upshift is called for, indexed by gb_gearN_upshift_spd
gb_gear1_upshift_load=[-1 -1];  % (--)
gb_gear2_upshift_load=[-1 -1];  % (--)
gb_gear1_dnshift_spd=[0 1000];  % (rad/s)
gb_gear2_dnshift_spd=[0 1000];  % (rad/s)
gb_gear1_upshift_spd=[0 1000];  % (rad/s)
gb_gear2_upshift_spd=[0 1000];  % (rad/s)

% convert old shift commands to new shift commands
gb_upshift_spd={gb_gear1_upshift_spd; ...
      gb_gear2_upshift_spd};  % (rad/s)
gb_upshift_load={gb_gear1_upshift_load; ...
      gb_gear2_upshift_load};  % (--)
gb_dnshift_spd={gb_gear1_dnshift_spd; ...
      gb_gear2_dnshift_spd};  % (rad/s)
gb_dnshift_load={gb_gear1_dnshift_load; ...
      gb_gear2_dnshift_load};  % (--)

clear gb_gear*shift* % remove unnecessary data

% fixes the difference between number of shift vectors and gears in gearbox
if length(gb_upshift_spd)<length(gb_ratio)
   start_pt=length(gb_upshift_spd);
   for x=1:length(gb_ratio)-length(gb_upshift_spd)
      gb_upshift_spd{x+start_pt}=gb_upshift_spd{1};
      gb_upshift_load{x+start_pt}=gb_upshift_load{1};
      gb_dnshift_spd{x+start_pt}=gb_dnshift_spd{1};
      gb_dnshift_load{x+start_pt}=gb_dnshift_load{1};
   end
end

% duration of shift during which no torque can be transmitted
gb_shift_delay=0;  % (s), no delay since no shifts; this is a 1-spd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cs_hi_soc=0.8;  % (--), highest desired battery state of charge
cs_lo_soc=0.4;  % (--), lowest desired battery state of charge
cs_fc_init_state=0;  % (--), initial FC state; 1=> on, 0=> off
% (W), minimum operating power 
cs_min_pwr=calc_max_pwr('fuel_converter')/fc_pwr_scale*1000*0.15;
% (W), maximum operating power (exceeded only if SOC<cs_lo_soc)
cs_max_pwr=calc_max_pwr('fuel_converter')/fc_pwr_scale*1000*0.95;
% (W), extra power output when (cs_lo_soc+cs_hi_soc)/2-SOC=1 
cs_charge_pwr=1000;
% (s), minimum time fc remains off, enforced unless SOC<=cs_lo_soc
cs_min_off_time=90;
% (W/s), maximum rate of increase of power
cs_max_pwr_rise_rate=2000;
% (W/s), maximum rate of decrease of power
cs_max_pwr_fall_rate=-3000;

cs_charge_deplete_bool=0; % boolean 1=> use charge deplete strategy, 0=> use charge sustaining strategy

fc_fuelcell_warmup_bool=0; % boolean 1=> enforce warmup pwr limitations, 0=> do not enforce warmup pwr limitations

cs_fc_on=0; % 1==> fuel cell always on (unless key_on=0) 0==> Use control strategy to determine if fc is on

end

%%%%%%%%%%%%%%% START OF SPEED DEPENDENT SHIFTING INFORMATION %%%%%%%%%%%%%

% Data specific for SPEED DEPENDENT SHIFTING in the (PRE_TX) GEARBOX CONTROL 
% BLOCK in VEHICLE CONTROLS <vc>
% --implemented for all powertrains except CVT versions and Toyota Prius (JPN)
%
tx_speed_dep=0;	% Value for the switch in the gearbox control
% 			If tx_speed_dep=1, the speed dependent gearbox is chosen
% 			If tx_speed_dep=0, the engine load dependent gearbox is chosen
%
% Vehicle speed (m/s) where the gearbox has to shift
%tx_1_2_spd=24/3.6;	% converting from km/hr to m/s				
%tx_2_3_spd=40/3.6;
%tx_3_4_spd=64/3.6;
%tx_4_5_spd=75/3.6;
%tx_5_4_spd=75/3.6;
%tx_4_3_spd=64/3.6;
%tx_3_2_spd=40/3.6;
%tx_2_1_spd=tx_1_2_spd;

% first column is speed in m/s, second column is gear number
% note: lookup data should be specified as a step function
% ..... this can be done by repeating values of x (first column, speed)
% ..... for differing values of y (second column, )
% note: division by 3.6 to change from km/hr to m/s

% speeds to use for upshift transition (shifting while accelerating) 
tx_spd_dep_upshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];

% speeds to use for downshift transition (shifting while decelerating)
tx_spd_dep_dnshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];
%%%%%%%%%%%%%%% END OF SPEED DEPENDENT SHIFTING %%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 01/03/99:MJO Changed for Fuel Cell....  locus code probably has problems due to other 'BD_' changes
% 01/24/99:MJO Changed more.  above statment proved true!
% 01/28/99:MJO Added "ess_init_soc=.8"
% 5/15/99:MJO updated *_version to 2.1 from 2.0
% 9/15/99:tm updated *_version to 2.2 from 2.1
% 9/15/99:tm updated cs definitions to work with bd_fuelcell
% 11/03/99:ss updated version from 2.2 to 2.21
% 1/12/00:tm introduced cs_charge_deplete_bool
% 4/27/00:tm introduced fc_fuelcell_warmup_bool
% 7/31/01:mpo added variables for speed dependent shifting