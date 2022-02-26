% ADVISOR data file:  PTC_PRIUS_JPN.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including cvt, hybrid
% and engine controls, for a prius_jpn hybrid using a cvt
% 
% Created on: 25-Jun-1999
% By:  SS, NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='PRIUS_JPN HYBRID POWERTRAIN CONTROL';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_PRIUS_JPN - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%special to prius_jpn, needs real numbers or automatic calculation
cs_fc_pwr_opt=[7000  10000 15000 20000 40000];
cs_fc_spd_opt=[1200	1263	1843	2332	3972]*(2*pi)/60;
cs_fc_trq_opt=cs_fc_pwr_opt./cs_fc_spd_opt;

cs_fc_crank_trq=40; %torque required to crank engine in Nm, Added 9/25/00 ss

vc_idle_spd=1200*pi/30;  % (rad/s), engine's idle speed
% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=0;  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ess_init_soc=0.7;  % (--), initial battery SOC; this is inputed from the simulation screen now.
cs_hi_soc=0.75;  % (--), highest desired battery state of charge
cs_lo_soc=0.45;  % (--), lowest desired battery state of charge
cs_target_soc=0.6;% 
% vehicle speed below which vehicle operates as ZEV
%cs_electric_launch_spd=90*1000/3600;  % (m/s) 90 kph (56mph) initial guess 8/26/99 ss based on excel file 50268800
%cs_electric_launch_spd=48*1000/3600;
cs_electric_launch_spd=45*1000/3600; % 9/6/00 from recent files looks like 28 mph (45 kph) is max speed with which engine can be off.

%cs_max_fc_spd=3500*pi/30; %rad/s 3500 rpm from anl test data (highest engine rpm)

cs_eff_inertia_startup=0.19; %9/8/00 average value after looking at engine startup data during an UDDS cycle

cs_max_fc_spd=4000*pi/30;

cs_max_gc_spd=5500*pi/30; %rad/s
cs_min_gc_spd=-5500*pi/30; %rad/s
cs_min_off_time=3; %sec

%cs_min_pwr=8000; %Watts  below this power the engine is allowed to shut off.
%cs_min_pwr=1200;
cs_min_pwr=6000;
cs_eng_on_soc=.5; % below this value, the engine must be on
cs_eng_min_spd=1200*pi/30; %rad/s  below this speed the engine does not use fuel.
%fuel can be cut at speeds at least 65 mph and below.
cs_clt_tmp=75; %deg C.  If coolant temp is below this, the engine stays on until warmed up.

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
% 6/25/99 ss created from ptc_par
% 9/23/99 ss added cs variables pertaining to fc optimum operation.
% 10/5/99 ss added cs_min_pwr, cs_eng_on_soc
% 10/6/99 ss added cs_eng_min_spd
% 10/15/99 ss changed cs_min_pwr to 1200 temporarily
% 11/03/99:ss updated version from 2.2 to 2.21
% 2/2/01:ss updated prius to prius_jpn
% 7/31/01:mpo added variables for speed dependent shifting