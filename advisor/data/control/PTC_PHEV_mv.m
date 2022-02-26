% ADVISOR data file:  PTC_INSIGHT_draft.m
%
% Data source:
%					copied from PTC_PAR, engine idle speed from NREL testing
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a parallel hybrid using a 5-spd gearbox.
% 
% Created on: 5-Jul-2000
% By:  KJK, NREL, ken_kelly@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('update_cs_flag')
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Control Strategy, 6-spd parallel electric-assist hybrid';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_PHEV_mv - ',ptc_description])

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=650*pi/30;  % (rad/s), engine's idle speed
% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=1;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=0; % (--)
% speed at which engine spins while clutch slips during launch
%vc_launch_spd=max(fc_map_spd)/6; % (rad/s),
vc_launch_spd=max(max(fc_map_spd)/5,1.25*vc_idle_spd); % (rad/s) 
% fraction of engine thermostat temperature below which the engine will stay on once it is on
vc_fc_warm_tmp_frac=1; % (--) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL (taken from PTC_HEAVY.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fractional engine load {=(torque)/(max torque at speed)} above which a
% downshift is called for, indexed by gb_gearN_dnshift_spd
gb_gear1_dnshift_load=[0 1];  % (--)
gb_gear2_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear3_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear4_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear5_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear6_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear7_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear8_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear9_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear10_dnshift_load=gb_gear1_dnshift_load;  % (--)

% fractional engine load {=(torque)/(max torque at speed)} below which an
% upshift is called for, indexed by gb_gearN_upshift_spd
gb_gear1_upshift_load=[0 1];  % (--)
gb_gear2_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear3_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear4_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear5_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear6_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear7_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear8_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear9_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear10_upshift_load=gb_gear1_upshift_load;  % (--)

gb_gear1_dnshift_spd=[0.325  0.45]*max(fc_map_spd)*fc_spd_scale;
gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear6_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear7_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear8_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear9_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear10_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)

gb_gear1_upshift_spd=[0.65 0.98]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
% 0.98* because engine may not be able to reach the max speed 
% under certain conditions due to speed estimation method
% this setting allows the vehicle to shift before it gets to the max engine speed (tm:11/11/99)
gb_gear2_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear3_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear4_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear5_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear6_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear7_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear8_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear9_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear10_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)

% convert old shift commands to new shift commands
gb_upshift_spd={gb_gear1_upshift_spd; ...
      gb_gear2_upshift_spd;...
      gb_gear3_upshift_spd;...
      gb_gear4_upshift_spd;...
      gb_gear5_upshift_spd;...
      gb_gear6_upshift_spd;...
      gb_gear7_upshift_spd;...
      gb_gear8_upshift_spd;...
      gb_gear9_upshift_spd;...
      gb_gear10_upshift_spd};  % (rad/s)

gb_upshift_load={gb_gear1_upshift_load; ...
      gb_gear2_upshift_load;...
      gb_gear3_upshift_load;...
      gb_gear4_upshift_load;...
      gb_gear5_upshift_load;...
      gb_gear6_upshift_load;...
      gb_gear7_upshift_load;...
      gb_gear8_upshift_load;...
      gb_gear9_upshift_load;...
      gb_gear10_upshift_load};  % (--)

gb_dnshift_spd={gb_gear1_dnshift_spd; ...
      gb_gear2_dnshift_spd;...
      gb_gear3_dnshift_spd;...
      gb_gear4_dnshift_spd;...
      gb_gear5_dnshift_spd;...
      gb_gear6_dnshift_spd;...
      gb_gear7_dnshift_spd;...
      gb_gear8_dnshift_spd;...
      gb_gear9_dnshift_spd;...
      gb_gear10_dnshift_spd};  % (rad/s)

gb_dnshift_load={gb_gear1_dnshift_load; ...
      gb_gear2_dnshift_load;...
      gb_gear3_dnshift_load;...
      gb_gear4_dnshift_load;...
      gb_gear5_dnshift_load;...
      gb_gear6_dnshift_load;...
      gb_gear7_dnshift_load;...
      gb_gear8_dnshift_load;...
      gb_gear9_dnshift_load;...
      gb_gear10_dnshift_load};  % (--)

clear gb_gear*shift* % remove unnecessary data

% duration of shift during which no torque can be transmitted
gb_shift_delay=0;  % (s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ess_init_soc=0.7;  % (--), initial battery SOC; this is inputed from the simulation screen now.
cs_hi_soc=0.8;  % (--), highest desired battery state of charge
cs_lo_soc=0.2;  % (--), lowest desired battery state of charge
% vehicle speed below which vehicle operates as ZEV
cs_electric_launch_spd=0;  % (m/s) during accel
cs_electric_decel_spd=9;  % (m/s) during decel
% vehicle speed below which vehicle operates as ZEV
% at low SOC
cs_electric_launch_spd_lo=0;  % (m/s)
% at and above high SOC
cs_electric_launch_spd_hi=0;  % (m/s)
% req'd torque as a fraction of max trq (at speed) 
% below which engine shuts off, when SOC > cs_lo_soc
cs_off_trq_frac=0;
% torque as a fraction of max trq (at speed) that engine puts out when req'd is
% below this value, when SOC < cs_lo_soc
cs_min_trq_frac=0;
% accessory-like torque/change in SOC load on engine that goes to recharging the batteries
% whenever the engine is on cs_charge_trq*(cs_lo_soc-SOC)=additional torque
cs_charge_trq=1000; 
% boolean 1=> use charge deplete strategy, 0=> use charge sustaining strategy
cs_charge_deplete_bool=0; % boolean
% 1 => allows engine to be shut off during low speed decel; 0=> keeps engine on 
% (i.e. clutch disengaged and clutch engaged, respectively)
cs_decel_fc_off=1; % boolean

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PTC_PAR revision history
%8/12/98,vh, cs_charge_trq,initialy =0, set to 20
%8/17/98,vh, changed behavior of cs_charge_trq in block diagram:  only adds this
%            additional torque when SOC < cs_lo_soc
%8/26/98,vh changed behavior of cs_charge_trq in block diagram: now, cscharge_trq*(cs_lo_soc-SOC)=additional torque
%09/15/98:MC set gb_shift_delay=0 for reasonable trace following
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 10/7/99:tm added *fc_spd_scale to shift speed definitions
%10/25/99:mc updated cs_electric_launch_spd and cs_off_trq_frac to improve FE and reduce engine cycling
% 11/03/99:ss updated version from 2.2 to 2.21
% 1/12/00:tm introduced cs_charge_deplete_bool

% PTC_INSIGHT Revision History Below

% 7/5/00,kjk, copied from PTC_PAR, modified engine idle speed
% 8/15/00:tm introduced cs_electric_decel_spd and cs_decel_fc_off
% 8/17/00:tm removed cs_off_trq_frac - not applicable
% 8/17/00:tm set min trq frac to 0 since the insight does not force a min trq that we know of at this time
% 8/18/00:tm introduced vc_fc_warm_tmp_frac to allow control of engine on based on coolant temp
% 8/22/00:kjk, modified gb_gear1_dnshift_spd and gb_gear1_upshift_spd
% Begin added by ADVISOR 2002 converter: 17-Apr-2002
tx_spd_dep_dnshift=[0 1;6.667 1;6.667 2;11.11 2;11.11 3;17.78 3;17.78 4;20.83 4;20.83 5;277.8 5];

tx_spd_dep_upshift=[0 1;6.667 1;6.667 2;11.11 2;11.11 3;17.78 3;17.78 4;20.83 4;20.83 5;277.8 5];

tx_speed_dep=0;

% End added by ADVISOR 2002 converter: 17-Apr-2002