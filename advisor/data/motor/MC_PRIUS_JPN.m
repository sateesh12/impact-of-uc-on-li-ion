%%%%% ADVISOR data file:  MC_PRIUS_JPN30
%
% Data source:
% NREL's testing of PRIUS_JPN motor at Unique Mobility 4/1999
%
% Data confidence level:
%
% Notes:
% 
%
% Created on: 5/5/99
% By: SS, NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='PRIUS_JPN 30-kW permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PRIUS_JPN30 - ',mc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-305 -275 -245 -215 -185 -155 -125 -95 -65 -35 -5 0 5	35	65	95	125	155	185	215	245	275	305];
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500  6000]*(2*pi)/60;
%pushed data out from 4500 rpm to 6000 rpm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
% multiplied by 0.95 because data was for motor only, .95 accounts for inverter/controller efficiencies
mc_eff_map=0.95*[...
.905   .905   .905   .905   .905   .905   .905   .905   .905   .905   .905   .905	.905   .905   .905   .905   .905   .905   .905   .905   .905   .905   .905      
0.56	0.59	0.62	0.65	0.68	0.72	0.76	0.8	0.85	0.9	0.87	.905	0.87	0.9	0.85	0.8	0.76	0.72	0.68	0.65	0.62	0.59	0.56
0.72	0.74	0.76	0.78	0.81	0.83	0.86	0.89	0.91	0.94	0.85	.905	0.85	0.94	0.91	0.89	0.86	0.83	0.81	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.9	0.92	0.93	0.94	0.83	.905	0.83	0.94	0.93	0.92	0.9	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.93	0.95	0.95	0.82	.905	0.82	0.95	0.95	0.93	0.92	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.94	0.95	0.95	0.81	.905	0.81	0.95	0.95	0.94	0.92	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.95	0.96	0.95	0.81	.905	0.81	0.95	0.96	0.95	0.92	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.95	0.96	0.95	0.8	.905	0.8	0.95	0.96	0.95	0.92	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.95	0.95	0.95	0.8	.905	0.8	0.95	0.95	0.95	0.92	0.88	0.86	0.78	0.76	0.74	0.72
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.95	0.95	0.95	0.79	.905	0.79	0.95	0.95	0.95	0.92	0.88	0.86	0.78	0.76	0.74	0.72		
0.72	0.74	0.76	0.78	0.86	0.88	0.92	0.95	0.95	0.95	0.79	.905	0.79	0.95	0.95	0.95	0.92	0.88	0.86	0.78	0.76	0.74	0.72];		


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
%mc_max_crrnt=90;	% maximum current draw for motor/controller set, A
mc_max_crrnt=120;
% UQM's max current is 'adjustable,' above is an estimate
mc_min_volts=60;	% minimum voltage for motor/controller set, V

% maximum continuous torque corresponding to speeds in mc_map_spd
mc_max_trq_data=[305.0 305.0 305.0 305.0 305.0 244.0 203.3 174.3 152.5 135.6 122.0 110.9 101.7 93.8 87.1 81.3 76.3 71.8 67.8 47.7];
mc_spd_data=[0 235 470 705 940 1175 1410 1645 1880 2115 2350 2585 2820 3055 3290 3525 3760 3995 4230 6000]*(2*pi)/60;
%last point is "made up" for pushing to 6000 rpm

mc_max_trq=interp1(mc_spd_data,mc_max_trq_data,mc_map_spd,'linear');

mc_max_gen_trq=-mc_max_trq; % estimate

clear mc_max_trq_data mc_spd_data
% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=1.0; % (--)


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
mc_mass=56.75; % (kg), mass of motor and enclosure

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
% 5/5/99 ss: created from MC_PM32.m
% 10/1/99: ss set overtorque factor to 1 (no data to say otherwise)
% 10/19/99: ss changed mass to 125 lb or 56.75 kg
% 11/03/99:ss updated version from 2.2 to 2.21
% % 11/1/00:tm added max gen trq placeholder data
% 2/2/01: ss updated prius to prius_jpn
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001