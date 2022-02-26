% ADVISOR data file:  PTC_PAR.m
%
% Data source:	NREL		
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a parallel hybrid using a multi-spd gearbox.
% 
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('update_cs_flag')
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % FILE ID INFO
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   ptc_description='multi-spd parallel electric-assist hybrid w/ electric launch';
   ptc_version=2003; % version of ADVISOR for which the file was generated
   ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
   ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
   % 2=> data matches source data and data collection methods have been verified
   disp(['Data loaded: PTC_PAR - ',ptc_description])
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % CLUTCH & ENGINE CONTROL
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % engine idle speed
   vc_idle_spd=0;  % (rad/s) 
   % 1=> idling allowed; 0=> engine shuts down rather than
   vc_idle_bool=0;  % (--)
   % 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
   vc_clutch_bool=1; % (--)
   % speed at which engine spins while clutch slips during launch
   vc_launch_spd=max(fc_map_spd)/6; % (rad/s) 
   % fraction of engine thermostat temperature below which the engine will stay on once it is on
   vc_fc_warm_tmp_frac=0.85; % (--) 
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % GEARBOX CONTROL
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if 1 % use new auto scaled shift maps
      % fractional engine load {=(torque)/(max torque at speed)} above which a
      % downshift is called for, indexed by gb_gearN_dnshift_spd
      gb_gear1_dnshift_load=[0 0.6 0.9 1];  % (--)
      gb_gear2_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear3_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear4_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear5_dnshift_load=gb_gear1_dnshift_load;  % (--)
      % fractional engine load {=(torque)/(max torque at speed)} below which an
      % upshift is called for, indexed by gb_gearN_upshift_spd
      gb_gear1_upshift_load=[0 0.3 1];  % (--)
      gb_gear2_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear3_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear4_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear5_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear1_dnshift_spd=min(fc_map_spd)+[0.01 0.05 0.10 0.15]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      gb_gear2_dnshift_spd=min(fc_map_spd)+[0.01 0.05 0.10 0.15]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      gb_gear3_dnshift_spd=min(fc_map_spd)+[0.01 0.05 0.10 0.15]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      gb_gear4_dnshift_spd=min(fc_map_spd)+[0.01 0.05 0.10 0.15]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale; % (rad/s)
      gb_gear5_dnshift_spd=min(fc_map_spd)+[0.01 0.05 0.10 0.15]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      
      gb_gear1_upshift_spd=min(fc_map_spd)+[0.20 0.3 0.98]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      % 0.98 rather than 1 because engine may not be able to reach the max speed 
      % under certain conditions due to speed estimation method
      % this setting allows the vehicle to shift before it gets to the max engine speed (tm:11/11/99)
      gb_gear2_upshift_spd=min(fc_map_spd)+[0.20 0.30 0.98]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;% (rad/s)
      gb_gear3_upshift_spd=min(fc_map_spd)+[0.20 0.30 0.98]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      gb_gear4_upshift_spd=min(fc_map_spd)+[0.20 0.30 0.98]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
      gb_gear5_upshift_spd=min(fc_map_spd)+[0.20 0.30 0.98]*(max(fc_map_spd)-min(fc_map_spd))*fc_spd_scale;  % (rad/s)
   else % use v3.1 shift maps
      % fractional engine load {=(torque)/(max torque at speed)} above which a
      % downshift is called for, indexed by gb_gearN_dnshift_spd
      gb_gear1_dnshift_load=[0 0.6 0.9 1];  % (--)
      gb_gear2_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear3_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear4_dnshift_load=gb_gear1_dnshift_load;  % (--)
      gb_gear5_dnshift_load=gb_gear1_dnshift_load;  % (--)
      % fractional engine load {=(torque)/(max torque at speed)} below which an
      % upshift is called for, indexed by gb_gearN_upshift_spd
      gb_gear1_upshift_load=[0 0.3 1];  % (--)
      gb_gear2_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear3_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear4_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear5_upshift_load=gb_gear1_upshift_load;  % (--)
      gb_gear1_dnshift_spd=[0.1399 0.14 0.3 0.3001]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
      gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
      gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
      gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
      gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
      gb_gear1_upshift_spd=[0.2631 0.2632 0.98]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
      % 0.98 rather than 1 because engine may not be able to reach the max speed 
      % under certain conditions due to speed estimation method
      % this setting allows the vehicle to shift before it gets to the max engine speed (tm:11/11/99)
      gb_gear2_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
      gb_gear3_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
      gb_gear4_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
      gb_gear5_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
   end
   
   % convert old shift commands to new shift commands
   gb_upshift_spd={gb_gear1_upshift_spd; ...
         gb_gear2_upshift_spd;...
         gb_gear3_upshift_spd;...
         gb_gear4_upshift_spd;...
         gb_gear5_upshift_spd};  % (rad/s)
   
   gb_upshift_load={gb_gear1_upshift_load; ...
         gb_gear2_upshift_load;...
         gb_gear3_upshift_load;...
         gb_gear4_upshift_load;...
         gb_gear5_upshift_load};  % (--)
   
   gb_dnshift_spd={gb_gear1_dnshift_spd; ...
         gb_gear2_dnshift_spd;...
         gb_gear3_dnshift_spd;...
         gb_gear4_dnshift_spd;...
         gb_gear5_dnshift_spd};  % (rad/s)
   
   gb_dnshift_load={gb_gear1_dnshift_load; ...
         gb_gear2_dnshift_load;...
         gb_gear3_dnshift_load;...
         gb_gear4_dnshift_load;...
         gb_gear5_dnshift_load};  % (--)
   
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
   gb_shift_delay=0;  % (s)
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % HYBRID CONTROL STRATEGY
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % highest desired battery state of charge
   cs_hi_soc=0.7;  % (--)
   % lowest desired battery state of charge
   cs_lo_soc=0.6;  % (--)
   % vehicle speed below which vehicle operates as ZEV
   % at low SOC
   cs_electric_launch_spd_lo=0;  % (m/s)
   % at and above high SOC
   cs_electric_launch_spd_hi=0;  % (m/s)
   % req'd torque as a fraction of max trq (at speed) 
   % below which engine shuts off, when SOC > cs_lo_soc
   cs_off_trq_frac=0;
   % torque as a fraction of max trq (at speed) that engine
   % puts out when req'd is below this value, when SOC < cs_lo_soc
   cs_min_trq_frac=0.4;
   % accessory-like torque load on engine that
   % goes to recharging the batteries whenever the engine is 
   % on cs_charge_trq*(mean(cs_lo_soc cs_hi_soc)-SOC)/(cs_hi_soc-cs_lo_soc)=additional torque
   cs_charge_trq=0.25*min(fc_max_trq); 
   % charge depleting hybrid strategy flag, 1=> use charge 
   % deplete strategy, 0=> use charge sustaining strategy
   cs_charge_deplete_bool=0; % boolean 
   % speed above which no engine shut down occurs due to low torque requests
   cs_electric_decel_spd=0;  % (m/s)
   
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

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% 8/9/00:tm updated default value of cs_charge_trq due to block diagram revision
% 8/16/00:tm removed cs_offset_soc - no longer used in block diagram
% 8/16/00:tm introduced cs_electric_launch_spd_lo and _hi to replace cs_electric_launch_spd
% 8/16/00:tm introduced vc_fc_warm_tmp_frac to control engine on state based on coolant temperature
% 11/1/00:tm introduced cs_electric_decel_spd to prevent engine shutdown at high speeds
% 7/30/01:tm updated version from 3.1 to 3.2
% 7/30/01:tm added new auto scaled shift map
% 7/31/01:mpo added variables for speed dependent shifting
