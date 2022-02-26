%%%%% ADVISOR data file:  MC_PM32
%
% Data source:
% Unique Mobility specification sheet for the SR180p/CR20-300
% motor/controller combination at 195 V, dated 10/28/94
%
% Data confidence level:
%
% Notes:
% Efficiency/loss data appropriate to a 195-V system.
%
% Created on: 6/30/98
% By: MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Unique Mobility 32-kW permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM32 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-520 -480 -400 -320 -240 -200 -160 -120 -80 -40 ...
   0 40 80 120 160 200 240 320 400 480 520]*4.448/3.281/12;

% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 4000 5000 6000 7000]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
mc_eff_map = 0.01*[...
20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20	20
43	43	45	52	60	60	57	52	49	38	20	38	49	52	57	60	60	52	45	43	43
70	70	71	72	73	72.5	71.5	67	62	50	20	50	62	67	71.5	72.5	73	72	71	70	70
76.7	76.7	77.5	77.5	77	76.5	74	71	65	52	20	52	65	71	74	76.5	77	77.5	77.5	76.7	76.7
80.8	80.8	80.5	80	78	78.5	77	73	67	54	20	54	67	73	77	78.5	78	80	80.5	80.8	80.8
83	83	83.5	83	82	81	78.5	76	70	58	20	58	70	76	78.5	81	82	83	83.5	83	83
84.6	84.6	84.7	84.5	83.5	82.5	80	77	72	59	20	59	72	77	80	82.5	83.5	84.5	84.7	84.6	84.6
86.8	86.8	86.6	86.5	85.4	84.5	83	80.5	75.5	60	20	60	75.5	80.5	83	84.5	85.4	86.5	86.6	86.8	86.8
88.7	88.7	88.8	88.3	86.7	86	84	81.5	77	60	20	60	77	81.5	84	86	86.7	88.3	88.8	88.7	88.7
91	91	90.5	89.7	88.4	87	86	83	77.5	55	20	55	77.5	83	86	87	88.4	89.7	90.5	91	91
92	92	91.5	90.5	89.3	88.5	87	84	76	50	20	50	76	84	87	88.5	89.3	90.5	91.5	92	92
];      

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
mc_max_crrnt=300;	% maximum current draw for motor/controller set, A
% UQM's max current is 'adjustable,' above is an estimate
mc_min_volts=60;	% minimum voltage for motor/controller set, V

% maximum continuous torque corresponding to speeds in mc_map_spd
mc_max_trq=[512 508.1 504.2 500.3 496.3	492.4 488.5 480.7 472.8 465 0]...
   *4.448/3.281/12; % (N*m)

mc_max_gen_trq=-1*[512 508.1 504.2 500.3 496.3	492.4 488.5 480.7 472.8 465 0]...
   *4.448/3.281/12; % (N*m), estimate

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=320/220; % (--)


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
mc_inertia=0.0226; % (kg*m^2), rotor's rotational inertia																		
mc_mass=23.6+14.5; % (kg), mass of motor and controller

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
clear T w mc_outpwr_map mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/3/98 (MC): corrected mc_max_trq (added elements) and mc_map_spd (conversion)
% 2/3/99  (SB): added thermal model variables
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 11/03/99:ss updated version from 2.2 to 2.21
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001