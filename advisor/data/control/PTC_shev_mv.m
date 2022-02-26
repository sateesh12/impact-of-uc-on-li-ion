% ADVISOR data file:  PTC_shev_mv.m (PTC_AnnexVII_SER_1.m)
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
% Created on: 06-Mar-2001
% By:  JE, Jacob Eelkema TNO Automotive, eelkema@wt.tno.nl
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('update_cs_flag')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Powertrain control for Annex VII series hybrid';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_shev_mv - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=0;  % (rad/s), engine's idle speed


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
%ess_init_soc=0.7;  % (--), initial battery SOC;  now this is inputed from the simulation screen
cs_hi_soc=0.8;  % (--), highest desired battery state of charge
cs_lo_soc=0.4;  % (--), lowest desired battery state of charge
cs_fc_init_state=0;  % (--), initial FC state; 1=> on, 0=> off
% (W), minimum operating power for genset
% pure thermostat:set it to operating power
[Y I]=min(fc_fuel_map_gpkWh);
[Y I2]=min(Y);
cs_min_pwr= fc_map_spd(I(I2))*fc_map_trq(I2);
% (W), maximum operating power for genset (exceeded only if SOC<cs_lo_soc)
% pure thermostat:set it to operating power
[Y3 I3]=max(fc_max_trq.*fc_map_spd);

cs_max_pwr=fc_map_spd(I3(1))*fc_max_trq(I3(1));

% (W), extra power output by genset when (cs_lo_soc+cs_hi_soc)/2-SOC=1
% pure thermostat:set it to zero to make genset power output independent of SOC
cs_charge_pwr=0;
% (s), minimum time genset remains off, enforced unless SOC<=cs_lo_soc
% pure thermostat:set it to inf s.t. genset won't come on until SOC<=cs_lo_soc
cs_min_off_time=inf;
% (W/s), maximum rate of increase of genset power
% pure thermostat:set it to zero s.t. power is constant whenever on
cs_max_pwr_rise_rate=inf;
% (W/s), maximum rate of decrease of genset power
% pure thermostat:set it to zero s.t. power is constant whenever on
cs_max_pwr_fall_rate=-inf;

cs_charge_deplete_bool=0; % boolean 1=> use charge deplete strategy, 0=> use charge sustaining strategy

end

[Y I]=min(fc_fuel_map_gpkWh);
[Y I2]=min(Y);
[Y3 I3]=max(fc_max_trq.*fc_map_spd);
[min_pwr I4]=min(fc_map_spd.*fc_max_trq);
min_spd=fc_map_spd(I4);

% Define the operating range for the ICE manualy
ice_spd = 1500*(pi/30); % [rad/s]
%ice_trq_min = 400; % [Nm]
%ice_trq_max = 450; % [Nm]
%min_pwr = ice_spd*ice_trq_min; % [W]
%max_pwr = ice_spd*ice_trq_max; % [W]

cs_pwr= [min_pwr cs_min_pwr cs_max_pwr];
cs_spd= [ice_spd ice_spd ice_spd];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Y I I2 I3 Y2 I4 min_pwr min_spd ice_spd ice_trq_min ice_trq_max min_pwr max_pwr



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06-Mar-2001 JE: Created
% 22-Mar-2002 MV: Modified to use a constant ice speed

% Begin added by ADVISOR 2002 converter: 17-Apr-2002
tx_spd_dep_dnshift=[0 1;6.667 1;6.667 2;11.11 2;11.11 3;17.78 3;17.78 4;20.83 4;20.83 5;277.8 5];

tx_spd_dep_upshift=[0 1;6.667 1;6.667 2;11.11 2;11.11 3;17.78 3;17.78 4;20.83 4;20.83 5;277.8 5];

tx_speed_dep=0;
% End added by ADVISOR 2002 converter: 17-Apr-2002