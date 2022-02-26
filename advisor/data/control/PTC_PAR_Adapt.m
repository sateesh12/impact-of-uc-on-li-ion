% ADVISOR data file:  PTC_PAR_Adapt.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a parallel hybrid using a 5-spd gearbox.
% 
% Created on: 3-Dec-1998
% By:  VHJ
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='5-spd parallel Adaptive Control Strategy';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_PAR_Adapt - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=0;  % (rad/s), engine's idle speed
% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=0;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=1; % (--)
% speed at which engine spins while clutch slips during launch
vc_launch_spd=max(fc_map_spd)/6; % (rad/s), 


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
gb_gear1_dnshift_spd=[0.1399 0.14 0.3 0.3001]*max(fc_map_spd);  % (rad/s)
gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear1_upshift_spd=[0.2631 0.2632 1]*max(fc_map_spd);  % (rad/s)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cs_hi_soc=0.7;  % (--), highest desired battery state of charge
cs_lo_soc=0.5;  % (--), lowest desired battery state of charge

% Adaptive CS variables
dsoc=cs_hi_soc-cs_lo_soc;		%delta soc range used to find cs range
avg=(cs_hi_soc+cs_lo_soc)/2;	%average SOC desired
cs_soc_range=[0 cs_lo_soc cs_lo_soc+dsoc/10 avg cs_hi_soc-dsoc/10 cs_hi_soc 1];
clear dsoc avg;

% Scale factor to multiply electrical energy cost, indexed by cs_soc_range
% used to regulate SOC
cs_scale_factor=10*[100 2 1.3 1 .7 .1 0.0001]; %for min_energy

%Regen average time
cs_regen_avg_time=120;
%mphr average time
cs_mph_avg_time=5;

%Weighting parameters for emissions and energy usage
% Weight for energy usage
K_Energy=1; %Cannot be zero, may be >=1
% Weight for emissions [HC CO NOx PM] in picking operating point:
% 0=ignore that emission, >0(e.g. 1)=include analysis of that emission
K_Emis=[1 1 1 1]; 

% Desired fuel economy and emissions for comparison 
% (affects weighting in the performance function)
mpg_desired=80;	    %mpg
hc_desired=.125;	%g/mile
co_desired=1.7;	    %g/mile
nox_desired=.07;	%g/mile
pm_desired=.08;	    %g/mile

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
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%01/05/00: vhj convert old shift commands to new shift commands
%10/25/00: vhj updated to version 3.0, updated name to RTCS (Real-Time Control Strategy)
%01/25/01: vhj updated version to 3.1, updated name to Adapt (Adaptive control strategy)
%01/29/01: vhj added comments describing variables
% 7/31/01:mpo added variables for speed dependent shifting