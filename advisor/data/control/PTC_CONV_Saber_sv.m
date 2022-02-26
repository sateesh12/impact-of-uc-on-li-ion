% ADVISOR data file:  PTC_CONV.m
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
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='5-spd conventional-drivetrain control';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_CONV - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a list of components that when run, require this file (ptc) to run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_dep_comps={'energy_storage2'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REGULATOR DATA (Saber Info)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reg_vreg_adj=0;  % set point voltage sensitivity parameter; user raises or lowers setpoint by this fixed amount

reg_tempreg=25; % generator operating temperature in C
reg_vsetmax=500; % upper limit for voltage setpoint; user may need to cap voltage setpoint due to battery issues

reg_vehicletype=5;	
%	1	large car		Pre-defined typical voltages & loads
%	2	medium car		Pre-defined typical voltages & loads
%	3	small car		Pre-defined typical voltages & loads
%	4	SUV			Pre-defined typical voltages & loads
%	5	user defined	User determines voltages & loads
reg_temp1=12.8; % the lower temperature for a user defined voltage regulation curve
reg_temp2=93; % the upper temperature for a user defined voltage regulation curve


%   Define ess voltage limits
if exist('ess2_max_volts') & exist('ess2_min_volts') 
    ess2_max_volts_fun=inline('evalin(''base'',''(ess2_module_num*ess2_max_volts)'')');
    ess2_min_volts_fun=inline('evalin(''base'',''(ess2_module_num*ess2_min_volts)'')');
else
    ess2_max_volts_frac=1.3;
    ess2_min_volts_frac=.7;
    ess2_max_volts_fun=inline('evalin(''base'',''(ess2_module_num*ess2_voc*ess2_max_volts_frac)'')');
    ess2_min_volts_fun=inline('evalin(''base'',''(ess2_module_num*ess2_voc*ess2_min_volts_frac)'')');
end

clear reg_volt1_fun reg_volt2_fun
%   Define regulator setpoint
reg_volt1_frac=1.167; % fraction of the mean ess2_voc that the generator tries to run at for temperature 1
reg_volt1_fun=inline('evalin(''base'',''min(max((mean(mean(ess2_voc))*ess2_module_num*reg_volt1_frac),max(max(ess2_voc))*ess2_module_num),(ess2_max_volts_fun(0)-eps))'')');
reg_volt2_frac=1.167; % fraction of ess2_voc that the generator tries to run at for temperature 2
reg_volt2_fun=inline('evalin(''base'',''min(max((mean(mean(ess2_voc))*ess2_module_num*reg_volt2_frac),max(max(ess2_voc))*ess2_module_num),(ess2_max_volts_fun(0)-eps))'')');

%   Uncomment to specify regulator voltage setpoints
% reg_volt1_fun=inline('14');
% reg_volt2_fun=inline('14');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute idle speed such that
% fc_max_trq(vc_idle_spd) >= 2 * accessory_torque(vc_idle_spd) and
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
gb_gear1_dnshift_spd=[799.9*pi/30 800*pi/30 0.5*max(fc_map_spd)*fc_spd_scale ...
      0.501*max(fc_map_spd)*fc_spd_scale];  % (rad/s)
gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear1_upshift_spd=[1499.9*pi/30	1500*pi/30 0.98*max(fc_map_spd)*fc_spd_scale];  % (rad/s)
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
clear last_index temp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/21/98:mc calculate idle speed and torque from accessories and engine maxT
% 09/15/98:mc set gb_shift_delay=0 for reasonable trace following
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/9/99: ss updated the last_index calculation.  Updated the last index to be where
%            the difference in the power vector was <=0 not just <0  if 0 it is not 
%            monotonically increasing which causes problems with interp1 in the next couple lines of code
% 10/7/99:tm added *fc_spd_scale to shift speed definitions
% 11/03/99:ss updated version from 2.2 to 2.21
% 07/31/01:mpo added speed dependent shifting functionality