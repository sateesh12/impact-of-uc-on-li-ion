% ADVISOR Data file:  MC_PM16evs.m
%
% Data source:
% Ortiz F., Buisset R., Adès C. "VEDELIC: New Technologies for Electric 
% Vehicles, Results of Tests and Demonstration", 
% Proceedings 15th Electric Vehicle Symposium, Brussels, October 1998.

% Data confidence level:  Good: data from a published paper

% Notes: Efficiency/loss data appropriate for a 250 Vdc system voltage.
%			It is a water-cooled traction drive developed in the VEDELIC program.
%			VEDELIC was a R&D project involving the French automaker PSA 
%			(Peugeot Citroen Automobiles), SAFT (Li-Ion batteries), 
%        Leroy-Somer (motors), SAGEM (controllers) and others.

% Created on:  24-Feb-2000  
% 
% By:  Marco Santoro,  Dresden University of Technology (Germany), 
%		 marco@eti.et.tu-dresden.de
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='Leroy-Somer/SAGEM 16 kW (continuous), permanent magnet motor/controller';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM16evs - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000]*(2*pi/60);
% Conversion from rpm to rad/s 

% (N*m), torque range of the motor
mc_map_trq=[0 20 40 60 80 100 120 140 160];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=0.01*[...
      40    46    42    41    40    38    35    33    30
      68    75    77    75    74    71    70    69    68	
      68    81    83.7  83.7  83    82    81    80    78 
      68    84    86    87    86.8  86    85.5  85    84.5
      68    84    88    88.5  89    88.9  88.2  87.5  87.1
      68    84    88.7  89.7  90    90.2  90.3  90.4  90.6
      68    84    89    90.3  91    90.5  90.3  90.3  90.3     
      67.5  84    89.9  91    90.5  90.3  90.3  90.3  90.3
      67.5  84    89.8  91    90.5  90.5  90.5  90.5  90.5
      67.4  84    89.5  90.8  90.5  90.5  90.5  90.5  90.5	
      67.4  84    89.2  90.5  90.5  90.5  90.5  90.5  90.5		
      67.4  83.9  89.2  90.2  90.5  90.5  90.5  90.5  90.5  	
      67.4  81    89.1  90    90.5  90.5  90.5  90.5  90.5
      67.3	80 	89		89.9	90.5	90.5	90.5	90.5	90.5
      67.3  80		89  	89.8  90    90    90    90    90
      67.3	80		88.8	89.7	90  	90 	90  	90		90
   	67.3	80 	88.7	89.5	90    90    90    90    90];
   
	%% find indices of well-defined efficiencies (where speed and torque > 0)
	pos_trqs=find(mc_map_trq>0);
	pos_spds=find(mc_map_spd>0);

	%% compute losses in well-defined efficiency area
	[T1,w1]=meshgrid(mc_map_trq(pos_trqs),mc_map_spd(pos_spds));
	mc_outpwr1_map=T1.*w1;
	mc_losspwr_map=(1./mc_eff_map(pos_spds,pos_trqs)-1).*mc_outpwr1_map; % for torque and speed > 0

	%% to compute losses in entire operating range
	%% ASSUME that losses are symmetric about zero-torque axis, and
     %% ASSUME that losses at zero torque are the same as those at the lowest
     %% positive torque, and
     %% ASSUME that losses at zero speed are the same as those at the lowest
     %% positive speed
	mc_losspwr_map=[fliplr(mc_losspwr_map) mc_losspwr_map(:,1) mc_losspwr_map];
	mc_losspwr_map=[mc_losspwr_map(1,:);mc_losspwr_map];

	%% compute input power (power req'd at electrical side of motor/inverter set)
	[T,w]=meshgrid(mc_map_trq,mc_map_spd);
	mc_outpwr_map=T.*w;   % for torque and speed >=0
   [T2,w2]=meshgrid(mc_map_trq(pos_trqs),mc_map_spd);
   temp=T2.*w2;   %  torque>0 and speed >=0
   mc_outpwr_map=[-fliplr(temp) mc_outpwr_map];
   mc_inpwr_map=mc_outpwr_map+mc_losspwr_map;  % (W)
   mc_map_trq=[-fliplr(mc_map_trq(pos_trqs)) mc_map_trq]; % negative torques are represented too
   mc_eff_map=[fliplr(mc_eff_map(:,pos_trqs)) mc_eff_map]; % the new efficiency map 
   % considers regenerative torques too
   
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max continuous torque curve of the motor indexed by mc_map_spd
mc_max_trq=0.5*[145 145 145 145 145 115 95 80 72 64 59 54 49 45 42 40 39]; % (N*m)
mc_max_gen_trq=-1*mc_max_trq; % (N*m), estimate

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=30/15; 

mc_max_crrnt=150; % (A), maximum current allowed by the controller and motor, estimated
mc_min_volts=100; % (V), minimum voltage allowed by the controller and motor, estimated


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
mc_inertia=0.02;  % (kg*m^2), rotor's rotational inertia, estimated
mc_mass=60;  % (kg), mass of Leroy-Somer motor, SAGEM controller and gear reduction																			

% motor/controller thermal model
mc_th_calc=1;      % --     0=no mc thermal calculations, 1=do calcs
mc_cp=430;         % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
mc_tstat=45;       % C      thermostat temp of motor/controler when cooling pump comes on
mc_area_scale=(mc_mass/91)^0.7;  % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
mc_sarea=0.4*mc_area_scale;      % m^2    total module surface area exposed to cooling fluid (typ rectang module)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
mc_eff_scale=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear T w mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs temp T2 w2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% 29-Aug-2000: automatically updated to version 3
% 1/3/01 ss: similar to -->% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001