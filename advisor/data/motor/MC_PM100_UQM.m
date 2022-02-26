% ADVISOR Data file:  MC_PM100_UQM.m
%
% Data source:  
% PowerPhase 100 Data sheet. Unique Mobility website: www.uqm.com
%
% Data confidence level:  Good-data from manufacturer spec sheet
%
% Notes:  This motor/contoller is designed for large EV/HEV applications
%
% Created on:  6/1/00  
% By:  tony_markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='Unique Mobility 100kW (peak) PM motor/inverter';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM100 - ',mc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500 2600 2700 2800 2900 3000 3100 3200 3300 3400 3500 3600 3700 3800 3900 4000 4100 4200 4300 4400]*(2*pi/60);

% (N*m), torque range of the motor
mc_map_trq=[0 50 100 150 200 250 300 350 400 450 500 550 600];
mc_map_trq=[-fliplr(mc_map_trq(2:end)) mc_map_trq];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=[...
78 79 80 81 81 81.3 81.7 81.9 82.1 82.4 82.6 83 83.7 85.2 86.2 86.4 87.1 87.2 88.5 88.4 89.5 87.5 85.4 84 84.5 84.4 83 83.7 83.3 83.6 83.2 82.8 82.9 83.8 82.7 83.3 82.2 82.3 82.3 82 82.3 81.8 81.8 81.6 81.6;
78 79 80 81 81 81.3 81.7 81.9 82.1 82.4 82.6 83 83.7 85.2 86.2 86.4 87.1 87.2 88.5 88.4 89.5 87.5 85.4 84 84.5 84.4 83 83.7 83.3 83.6 83.2 82.8 82.9 83.8 82.7 83.3 82.2 82.3 82.3 82 82.3 81.8 81.8 81.6 81.6;
78 79 80 81 81.7 83.5 83.8 84.1 85.9 86.2 87.6 89.1 90 90.3 91.4 91.8 91.7 92.1 91.9 93 93.1 93 90.6 89.8 89.9 90.2 89.8 90.8 90.1 93 92.5 91.3 92.5 92.2 88.4 88.4 87.1 86.2 88.4 87.5 87.1 85.8 86.6 85.8 85.8;
78 79 80 81.2 82.4 83.7 85.1 85.5 87.2 88.4 89.4 90.4 91 92 93 93 93.4 93.5 93.4 93.6 93.6 93 93 92.2 91.5 92.8 93 92.9 92.7 93 93 93 93 93 91.7 93 91.9 91.3 91.8 91.7 90.9 90.5 90 89 89;
78 79 80 81.2 82.6 84 85.9 86.9 87.6 89.1 90 90 91.9 93 93 93 93.5 94 94 94 93.8 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 92.8 93 92.4 90.3 90 90 90;
78 79 80 81.3 82.7 84 86 87 87.3 88.9 90 90 91.7 93 93 93 93.5 93.7 93.9 93.8 93.5 93 93 93 92.2 91.9 91.5 92.1 92.5 93 92.7 92.8 92.6 92.6 92.6 92.7 92.8 92.8 92.7 92.7 91.6 90 88.3 88.3 88.3;
78 79 80 81.3 82.9 84 84.7 86 87.1 87.8 89.7 90 91.1 92.3 92.8 92.8 93.1 93.3 93.5 93.3 93.1 93 93 91.7 90.8 90.5 90 90.9 91.4 91.9 92 91.9 91.9 92 92 92.1 92.2 92.3 92.3 92.2 90.8 90 90 90 90;
78 79 80 81.1 82.7 84 83.9 84.3 85.6 86.7 88.2 89.4 90 91.1 91.9 92.1 92.6 93 93.2 92.8 92.2 91.4 90.5 90 90 90 90 90 90.4 90.8 91.1 91.1 91.2 91.4 91.4 91.5 91.7 91.7 91.8 91.8 90 90 90 90 90;
78 79 80 81.1 82.3 83.3 83.1 83.7 84 86 87 88.5 89.3 90 91.1 91.7 92.1 92.6 92.3 91.9 91.1 90 90 90 90 90 90 90 90 90 90 90.2 90.5 90.8 90.8 91 91.1 91.2 91.3 91.3 90 90 90 90 90;
78 79 80 81.1 81.7 82.4 82.5 83.4 84 85.5 86.6 88.1 88.8 89.8 90.6 91.2 91.9 91.6 91.3 91.1 90.4 90 90 90 90 90 90 90 90 90 90 90 90 90 90.2 90.4 90.6 90.7 90.9 90.5 90.5 90.5 90.5 90.5 90.5;
78 79 80 81.1 81.1 81.7 82.2 83.1 83.9 84.8 86.4 87.5 88.6 89.7 90.4 91.1 90.9 90.6 90.3 90.1 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90.1 90.2 90.4 90 90 90 90 90 90;
78 79 80 81.1 81.1 81.7 82 82.8 83.7 84.6 86.3 87.5 88.5 89.6 90.4 90.2 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90;
78 79 80 81.1 81.1 81.7 82 82.8 83.7 84.5 86.2 87.6 88.7 89.7 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90]'/100;

mc_eff_map=[fliplr(mc_eff_map(:,2:end)) mc_eff_map];

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
%% ASSUME that losses at zero speed are the same as those at the lowest
%% positive speed
spin_losses=interp1([0 5000]*pi/30,[0 4300],pos_spds); % (W) % estimated
mc_losspwr_map=[fliplr(mc_losspwr_map) spin_losses' mc_losspwr_map];
mc_losspwr_map=[mc_losspwr_map(1,:);mc_losspwr_map];

%% compute input power (power req'd at electrical side of motor/inverter set)
[T,w]=meshgrid(mc_map_trq,mc_map_spd);
mc_outpwr_map=T.*w;
mc_inpwr_map=mc_outpwr_map+mc_losspwr_map;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max torque curve of the motor indexed by mc_map_spd
mc_max_trq=[550.6 550.6 550.6 550.6 550.6 550.6 550.6 550.6 550.6 550.6 550.6 550.6 550 549.4 549.8 550.6 542.6 529.4 512.4 497.1 481.9 457.5 439.1 421.4 403.9 385.3 364.1 344.1 326.3 308.9 294.7 285.8 275.7 265.1 254.3 243.3 236.2 230.9 225.4 220 211.9 203.2 201.4 194.1 190]; % (N*m)
mc_max_cont_trq=[300.1 300.1 299.8 302.2 302.2 302.2 290.5 275 259.1 248.4 237.3 232 226.7 221.6 216.7 211.8 206.7 201.6 197.5 193 187.2 181.7 176.4 172.3 169.4 166.8 164.6 162.9 162.7 162.7 160 156.8 155.1 153 149.8 147.7 145 141.6 137.4 133.3 129.4 126.2 123.2 115 110];

% maximum overtorque capability (not continuous, because the motor would overheat) 
mc_overtrq_factor=mean(mc_max_trq./mc_max_cont_trq); % (--), estimated
mc_max_trq=mc_max_trq/mc_overtrq_factor;
% tm:6/1/00 the two lines above have been included since ADVISOR at this time is unable to use a max and a continuous curve of different shape

mc_max_gen_trq=-mc_max_trq; %(Nm), estimate

mc_max_crrnt=400; % (A), maximum current allowed by the controller and motor
mc_min_volts=180; % (V), minimum voltage allowed by the controller and motor


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
mc_inertia=0;  % (kg*m^2), rotor inertia; unknown
mc_mass=86+15.9;  % (kg), mass of motor and controller																			

% motor/controller thermal model 
mc_th_calc=1;                             % --     0=no mc thermal calculations, 1=do calc's
mc_cp=430;                                % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
mc_tstat=45;                              % C      thermostat temp of motor/controler when cooling pump comes on
mc_area_scale=(mc_mass/91)^0.7;           % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
mc_sarea=0.4*mc_area_scale;               % m^2    total module surface area exposed to cooling fluid (typ rectang module)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
mc_eff_scale=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear T w mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6/1/00:tm file created
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001