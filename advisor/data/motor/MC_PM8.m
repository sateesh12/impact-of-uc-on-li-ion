%%%%% ADVISOR data file:  MC_PM8
%
% Data source:
% Unique Mobility specification sheet dated 10/1/94
%
% Data confirmation:
%
% Caveats:
% Efficiency/loss data appropriate to a 100-V system.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Unique Mobility 15.8-kW permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM8 - ',mc_description]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TORQUE AND SPEED ranges at which data is available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N-m, torque vector corresponding to columns of efficiency & loss maps
mc_map_trq=[-180 -160 -140 -120 -100 -80 -60 -40 -20 ...
	0 20 40 60 80 100 120 140 160 180]*4.448/3.281/12;

% rad/s, speed vector corresponding to rows of efficiency & loss maps
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_eff_map =[...
0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1
0.18	0.28	0.41	0.52	0.42	0.36	0.38	0.3	0.2	0.1	0.2	0.3	0.38	0.36	0.42	0.52	0.41	0.28	0.18
0.46	0.57	0.63	0.71	0.7	0.69	0.71	0.6	0.34	0.1	0.34	0.6	0.71	0.69	0.7	0.71	0.63	0.57	0.46
0.63	0.71	0.74	0.79	0.8	0.82	0.85	0.76	0.48	0.1	0.48	0.76	0.85	0.82	0.8	0.79	0.74	0.71	0.63
0.74	0.8	0.82	0.835	0.85	0.855	0.865	0.855	0.61	0.1	0.61	0.855	0.865	0.855	0.85	0.835	0.82	0.8	0.74
0.81	0.835	0.85	0.855	0.865	0.87	0.875	0.86	0.72	0.1	0.72	0.86	0.875	0.87	0.865	0.855	0.85	0.835	0.81
0.84	0.855	0.87	0.875	0.885	0.89	0.885	0.87	0.8	0.1	0.8	0.87	0.885	0.89	0.885	0.875	0.87	0.855	0.84
0.86	0.87	0.88	0.89	0.9	0.905	0.9	0.88	0.85	0.1	0.85	0.88	0.9	0.905	0.9	0.89	0.88	0.87	0.86
0.88	0.885	0.9	0.91	0.915	0.92	0.91	0.885	0.85	0.1	0.85	0.885	0.91	0.92	0.915	0.91	0.9	0.885	0.88
0.895	0.9	0.91	0.92	0.925	0.925	0.92	0.9	0.86	0.1	0.86	0.9	0.92	0.925	0.925	0.92	0.91	0.9	0.895
0.91	0.92	0.925	0.93	0.93	0.93	0.92	0.905	0.875	0.1	0.875	0.905	0.92	0.93	0.93	0.93	0.925	0.92	0.91];
								

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
%% ASSUME that losses at zero torque are the same as those at the lowest positive
%% torque, and
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
% Nm, maximum continuous torque corresponding to speeds in mc_map_spd
mc_max_trq=[18.36 18.36 18.15 18.04 17.94 17.83 17.73 17.62 17.57 17.17 0];
mc_max_gen_trq=-1*[18.36 18.36 18.15 18.04 17.94 17.83 17.73 17.62 17.57 17.17 0]; % estimate

% max. overtorque (beyond continuous, intermittent operation only)
mc_overtrq_factor=225/163;

mc_max_crrnt=300; % (A), maximum current allowed by the controller and motor
mc_min_volts=30; % (V), minimum voltage allowed by the controller and motor


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
mc_inertia=0.014;  % (kg*m^2), rotor inertia
mc_mass=14.1;  % (kg), mass of motor and controller																			

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
% 2/3/99  (SB): added thermal model variables
% 3/15/99:ss updated *_version to 2.1 from 2.0






% 11/03/99:ss updated version from 2.2 to 2.21
% % 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001