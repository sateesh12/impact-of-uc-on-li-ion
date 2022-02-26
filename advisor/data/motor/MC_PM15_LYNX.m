%%%%% ADVISOR data file:  MC_PM15_LYNX
%
% Data source:
% Initial sytem requirements documen/design evaluation
% 
%
% Data confidence level: low
%
% Notes:
% Efficiency/loss data appropriate to a 275-V system.
%
% Created on: 03/22/00
% By: Craig Rutherford UTK, GRA 
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Lynx Motion 15-kW cont/45-kw peak permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM15_LYNX - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90];

% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 4000 4500 5000 5500]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
mc_eff_map = 0.95*[...
20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0	20.0
68.2	70.7	73.3	76.2	79.3	82.7	86.3	90.2	94.2	20.0	94.2	90.2	86.3	82.7	79.3	76.2	73.3	70.7	68.2
81.0	82.7	84.5	86.3	88.3	90.3	92.3	94.4	96.0	20.0	96.0	94.4	92.3	90.3	88.3	86.3	84.5	82.7	81.0
86.4	87.7	89.0	90.3	91.7	93.1	94.4	95.7	96.4	20.0	96.4	95.7	94.4	93.1	91.7	90.3	89.0	87.7	86.4
89.3	90.3	91.4	92.4	93.5	94.5	95.5	96.3	96.4	20.0	96.4	96.3	95.5	94.5	93.5	92.4	91.4	90.3	89.3
91.2	92.0	92.9	93.7	94.5	95.3	96.1	96.6	96.2	20.0	96.2	96.6	96.1	95.3	94.5	93.7	92.9	92.0	91.2
92.5	93.2	93.9	94.6	95.2	95.9	96.4	96.7	96.0	20.0	96.0	96.7	96.4	95.9	95.2	94.6	93.9	93.2	92.5
93.4	94.0	94.6	95.2	95.7	96.2	96.6	96.8	95.8	20.0	95.8	96.8	96.6	96.2	95.7	95.2	94.6	94.0	93.4
94.1	94.6	95.1	95.6	96.1	96.5	96.8	96.8	95.6	20.0	95.6	96.8	96.8	96.5	96.1	95.6	95.1	94.6	94.1
94.6	95.1	95.5	96.0	96.4	96.7	96.9	96.8	95.3	20.0	95.3	96.8	96.9	96.7	96.4	96.0	95.5	95.1	94.6
95.0	95.5	95.9	96.2	96.6	96.8	96.9	96.7	95.0	20.0	95.0	96.7	96.9	96.8	96.6	96.2	95.9	95.5	95.0];      
% This map is a model based estimate.  Model has been verified with good correlation on two similar motors.

% CONVERT EFFICIENCY MAP TO INPUT POWER MAP
%% find indices of well-defined efficiencies (where speed and torque > 0)
pos_trqs=find(mc_map_trq>0);
pos_spds=find(mc_map_spd>0);

%% compute losses in well-defined efficiency area
[T1,w1]=meshgrid(mc_map_trq(pos_trqs),mc_map_spd(pos_spds));
mc_outpwr1_map=T1.*w1;
mc_losspwr_map=(1./mc_eff_map(pos_spds,pos_trqs)-1).*mc_outpwr1_map;

%% to compute losses in entire operating range
%% ASSUME that losses are symmetric about zero-torque axis, and
%% ASSUME that losses at zero torque are the same as those at the lowest
%% positive torque, and
%% ASSUME that losses at zero speed are the same as those at the lowest positive
%% speed
mc_losspwr_map=[fliplr(mc_losspwr_map) mc_losspwr_map(:,1) mc_losspwr_map];
mc_losspwr_map=[mc_losspwr_map(1,:);mc_losspwr_map];

%% compute input power (power req'd at electrical side of motor/inverter set)
[T,w]=meshgrid(mc_map_trq,mc_map_spd);
mc_outpwr_map=T.*w;
mc_inpwr_map=mc_outpwr_map+mc_losspwr_map;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_max_crrnt=225;	% maximum current draw for motor/controller set, A
% This value is for a one PCU (controller) design
mc_min_volts=150;	% minimum voltage for motor/controller set, V
% This value is an estimate from current LZ1 tests (3/22)

% maximum continuous torque corresponding to speeds in mc_map_spd
mc_max_trq=[20 30 30 30 30 30 30 30 30 30 20]; % (N*m)

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=3; % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale mc_map_spd to simulate a faster or slower running motor 
mc_spd_scale=1.0;

% (--), used to scale mc_map_trq to simulate a higher or lower torque motor
mc_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
mc_inertia=0.09; % (kg*m^2), rotor's inertia (CR) (3/22) From Pat Kelecy (Lynx)																		
mc_mass=22+10; % (kg), mass of motor and controller

%the following variable is not used directly in modeling and should always be equal to one
%it's used for initialization purposes
mc_eff_scale=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear T w mc_outpwr_map mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

% Begin added by ADVISOR 2.1 converter
mc_th_calc=1;      % --     0=no mc thermal calculations, 1=do calcs
mc_cp=430;         % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
mc_tstat=45;       % C      thermostat temp of motor/controler when cooling pump comes on
%mc_area_scale=(mc_mass/91)^0.7;  % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
%mc_sarea=0.2*mc_area_scale;      % m^2    total module surface area exposed to cooling fluid (typ rectang module/modified)
mc_sarea=.08;
mc_version=2003;
% End added by ADVISOR 2.1 converter



% Begin added by ADVISOR 2.21 converter: 28-Mar-2000
% mc_outpwr_map=ones(length(mc_map_spd),length(mc_map_trq));
% End added by ADVISOR 2.21 converter: 28-Mar-2000



% Begin added by ADVISOR 2.2 converter: 28-Aug-2000
mc_area_scale=1;
mc_outpwr_map=ones(length(mc_map_spd),length(mc_map_trq));
% End added by ADVISOR 2.2 converter: 28-Aug-2000

% 19-Feb-2001: automatically updated to version 3
% 19-Feb-2001: automatically updated to version 3
% Begin added by ADVISOR 3.2 converter: 15-Aug-2001
mc_mass_scale_coef=[1 0 1 0];


mc_max_gen_trq=[-271.1 -271.1 -271.1 -237.5 -178.1 -142.5 -118.8 -101.8 -89.07 -79.17 -71.17];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');
% End added by ADVISOR 3.2 converter: 15-Aug-2001