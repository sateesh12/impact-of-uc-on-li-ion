% ADVISOR data file:  PTC_CONVATAT5spd.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, 
% and engine controls, for an advanced conventional vehicle using a 5-spd
% gearbox.
% 
% Created on: 4 April 2001
% By:  MPO, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='5-spd AT control';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_CONVAT - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute idle speed such that
% fc_max_trq(vc_idle_spd) >= 2 * accessory_torque(vc_idle_spd) AND
% vc_idle_spd >= 800 rpm
fc_max_pwr_vec=fc_map_spd.*fc_max_trq;
last_index=min(find(diff(fc_max_pwr_vec)<=0));%ss added '=' in '<=' spot on 7/9/99
if isempty(last_index)
   last_index=length(fc_max_pwr_vec);
end
temp=interp1(fc_max_pwr_vec(1:last_index),fc_map_spd(1:last_index),2*acc_mech_pwr);
if isnan(temp) % if 2*accessory power is off the map (too low)...
   vc_idle_spd=800*2*pi/60;  % (rad/s), engine's idle speed
else
   vc_idle_spd=max(temp,800*2*pi/60);
end

% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=1;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=0; % (--)
% speed at which engine spins while clutch slips during launch
vc_launch_spd=max(max(fc_map_spd)/5,1.5*vc_idle_spd); % (rad/s) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fractional engine load {=(torque)/(max torque at speed)} above which a
% downshift is called for, indexed by gb_gearN_dnshift_spd
gb_gear1_dnshift_load=[0 1];  % (--)
gb_gear2_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear3_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear4_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear5_dnshift_load=gb_gear1_dnshift_load;  % (--)
% fractional engine load {=(torque)/(max torque at speed)} below which an
% upshift is called for, indexed by gb_gearN_upshift_spd
gb_gear1_upshift_load=[0 1];  % (--)
gb_gear2_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear3_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear4_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear5_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear1_dnshift_spd=[0.325  0.45]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear1_upshift_spd=[0.65 0.98]*max(fc_map_spd)*fc_spd_scale;
% 0.98* because engine may not be able to reach the max speed 
% under certain conditions due to speed estimation method
% this setting allows the vehicle to shift before it gets to the max engine speed (tm:11/11/99)
gb_gear2_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear3_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear4_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear5_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
% duration of shift during which no torque can be transmitted
gb_shift_delay=0;  % (s)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYDRAULIC TORQUE CONVERTER CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
htc_lockup=[0 1 1 1 1]; % (--), htc_lockup(i)=='when in gear i, lock up HTC'

% Begin added by ADVISOR 3.2 converter: 07-Aug-2001
tx_spd_dep_dnshift=...
    ...%speed (m/s), gear number (e.g., 1st, 2nd, 3rd, etc.)
    [0*0.4470    1  % 0
    12*0.4470     1 % 12
    12*0.4470     2 % 12
    18*0.4470    2  % 18
    18*0.4470    3  % 18
    25*0.4470    3  % 26
    25*0.4470    4  % 26
    34*0.4470    4  % 35
    34*0.4470    5  % 35
    300*0.4470 5];% 277.8

tx_spd_dep_upshift=tx_spd_dep_dnshift;

tx_speed_dep=0;

% End added by ADVISOR 3.2 converter: 07-Aug-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/9/99:ss added calculation of idle speed
% 10/6/99:mc added fc_spd_scale to definition of shift speeds
% 11/03/99:ss updated version from 2.2 to 2.21