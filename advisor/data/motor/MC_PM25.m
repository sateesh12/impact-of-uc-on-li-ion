% ADVISOR Data file:  MC_PM25.m
%
% Data source:
% D. Bauch-Banetzky, et al., "Permanent magneterregte Synchronmaschine mit Nd-Fe-B 
% Dauermagneten für den Einsatz in Personenkraftfahrzeugen"
% published in "VDI (Verein Deutscher Ingenieure) Berichte 1459: 
% Entwicklung Konstruktion Vertrieb HYBRIDANTRIEBE"
% VDI Verlag GmbH, Düsseldorf 1999; ISSN 0083-5560, ISBN 3-18-091459-9.

% Drive tested by Mr. Berwind (Mannesmann Sachs AG, Schweinfurt, Germany).

% Data confidence level:  Good: data from a published paper
%
% Notes: 130 V dc input. Mannesmann Sachs D260 RE L55 motor/controller. Adopting 
% higher voltages, peak efficiency greater than 93% can be achieved.
%
% Created on:  11/16/99  
% 
% By:  Marco Santoro,  Dresden University of Technology (Germany), 
%		 marco@eti.et.tu-dresden.de
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='Mannesmann Sachs 25 kW (continuous), permanent magnet motor/controller';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM25 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000]*(2*pi/60);
% Conversion from rpm to rad/s 

% (N*m), torque range of the motor
mc_map_trq=[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=0.01*[...
      50    50    50    50    50    50    50    50    50    50    50    50    50    50    50    50    50   
      68    70    71.5  71    68    71    70.05 70    70    69.7  69.5  69.5  67    67.6  67.5  67.4  67.3
      68    75    80.5  81.7  81.6  82    82    82    81.5  81    80.5  80    79    78    77    76.5  76
      68    77    82    86.1  86.5  86.5  86.5  86.3  85.9  84.8  84.7  84    83    82.6  82    80    80
      68    78    83    87    88    88.3  88.5  88.5  88.1  87.7  87    86.5  86    85.5  84    83    83
      68    78.5  83.2  88    88.7  89.2  89.4  89.5  88.9  88    87    85.9  85    84    84    84    84
      68    78    83    87.5  88.6  89.1  89    88.5  87.8  85.8  85    84    84    84    84    84    84
      68    73    82    86.2  87.8  88    87.7  86.5  85    84    84    84    84    84    84    84    84
      68    71    80.5  83    85.5  86.1  85.5  85    84    84    84    84    84    84    84    84    84
      68    69    79    82.5  84    84    84    84    84    84    84    84    84    84    84    84    84
      68    68.9  75    81    82    81    80    80    80    80    80    80    80    80    80    80    80
      68    68.7  73    80    81    79    75    75    75    75    75    75    75    75    75    75    75
      68    68.5  71    75    75    74    74    74    74    74    74    74    74    74    74    74    74];
   
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
mc_max_trq=[128 122 117 111 106 95 80 69 58.5 49 40.2 32 27]; % (N*m)

mc_max_gen_trq=-1*[128 122 117 111 106 95 80 69 58.5 49 40.2 32 27]; % (N*m), estimate

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=30/25; 

mc_max_crrnt=270; % (A), maximum current allowed by the controller and motor
mc_min_volts=130; % (V), minimum voltage allowed by the controller and motor


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
mc_mass=45;  % (kg), mass of motor and controller, estimated																			

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
% 11-22-99 : Created by Marco Santoro, Denmark
% 22-Dec-1999: automatically updated to version 2.21
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001