% ADVISOR data file:  PTC_HEAVY.m
%
% Data source: NREL
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, 
% and engine controls, for a heavy vehicle.
% 
% Created on: 7/10/98
% By:  Tony Markel, NREL, Tony_Markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Default Heavy Vehicle Powertrain Control';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_HEAVY - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=650*pi/30;  % (rad/s), engine's idle speed
% 1=> idling allowed; 0=> engine shuts down rather than idle
vc_idle_bool=1;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=0; % (--)
% speed at which engine spins while clutch slips during launch
vc_launch_spd=max(max(fc_map_spd)/5,1.25*vc_idle_spd); % (rad/s) 

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
   10/3.6, 1
   10/3.6, 2
   15/3.6, 2
   15/3.6, 3
   20/3.6, 3
   20/3.6, 4
   25/3.6, 4
   25/3.6, 5
   30/3.6, 5
   30/3.6, 6
   35/3.6, 6
   35/3.6, 7
   40/3.6, 7
   40/3.6, 8
   45/3.6, 8
   45/3.6, 9
   50/3.6, 9
   200/3.6, 10];

% speeds to use for downshift transition (shifting while decelerating)
tx_spd_dep_dnshift = [
   0/3.6, 1
   10/3.6, 1
   10/3.6, 2
   15/3.6, 2
   15/3.6, 3
   20/3.6, 3
   20/3.6, 4
   25/3.6, 4
   25/3.6, 5
   30/3.6, 5
   30/3.6, 6
   35/3.6, 6
   35/3.6, 7
   40/3.6, 7
   40/3.6, 8
   45/3.6, 8
   45/3.6, 9
   50/3.6, 9
   200/3.6, 10];
%%%%%%%%%%%%%%% END OF SPEED DEPENDENT SHIFTING %%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/10/98 tm: file created from PTC_CONV.m
% 7/10/98 tm: data revised to handle 10 speed transmission and idle speed reduced to 650 RPM
% 10/30/98:tm upshift and dwnshift speeds defined based on fc spd vector
% 2/23/98:tm updated for March 99 release
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 10/7/99:tm added *fc_spd_scale to shift spd definitions
% 11/03/99:ss updated version from 2.2 to 2.21
% 8/9/00:tm removed reference to conventional shift strategy
% 8/9/00:tm set gb_shift_delay to 0 (1 delay is too long and anything between 
%           0 and 1 translates to 1 with a 1 second time step)
% 8/18/00:tm improved shift points
% 7/31/01:mpo added variables for speed dependent shifting
% 10/24/01:tm added conditional statements to expand the shift map in case the transmission has more gear ratios that shift lines have been defined
