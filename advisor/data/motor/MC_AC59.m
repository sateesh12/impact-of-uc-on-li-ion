% ADVISOR Data file:  MC_AC59.m
%
% Data source:
% Marcus Menne, et al., "Energy-Efficiency Evaluation of Traction Drives 
% for Electric Vehicles", Proceedings 15th Electric Vehicle Symposium, 
% Brussels 1998.
% Drive tested by Institute for Power Electronics and Electrical Drives 
% at Aachen University of Technology (Germany).
%
% Data confidence level:  Good: data from a published paper
%
% Notes:
% This is a prototype or small-production 59 kW, AC induction motor/controller. 
% Efficiency/loss data appropriate for a rated voltage system.  (Voltage was not
% given in the source paper.)
%
% Created on:  5/12/99  
% 
% By:  Marco Santoro,  Dresden University of Technology (Germany), 
%		 marco@eti.et.tu-dresden.de
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='59 kW (continuous), AC induction motor/controller';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_AC59 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000]*(2*pi/60);
% Conversion from RPM to rad/s 

% (N*m), torque range of the motor
mc_map_trq=[0 25 50 75 100 125 150 175 200];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=[...
      0.2   0.2   0.2   0.2   0.2   0.2   0.2   0.2   0.2
      0.2   0.7   0.69  0.67  0.64  0.62  0.59  0.55  0.55
      0.2   0.78  0.79  0.78  0.77  0.76  0.73  0.72  0.7
      0.2   0.82  0.837 0.835 0.83  0.82  0.79  0.78  0.77
      0.2   0.852 0.868 0.868 0.867 0.853 0.835 0.825 0.82
      0.2   0.874 0.89  0.889 0.885 0.87  0.857 0.848 0.836
      0.2   0.89  0.903 0.903 0.896 0.88  0.868 0.851 0.84
      0.2   0.9   0.91  0.908 0.897 0.88  0.86  0.84  0.84
      0.2   0.894 0.91  0.904 0.88  0.86  0.84  0.84  0.84
      0.2   0.893 0.904 0.89  0.86  0.84  0.84  0.84  0.84
      0.2   0.901 0.9   0.87  0.84  0.84  0.84  0.84  0.84
      0.2   0.902 0.887 0.85  0.84  0.84  0.84  0.84  0.84
      0.2   0.891 0.87  0.84  0.84  0.84  0.84  0.84  0.84
      0.2   0.883 0.86  0.84  0.84  0.84  0.84  0.84  0.84
      0.2   0.881 0.84  0.84  0.84  0.84  0.84  0.84  0.84
      0.2   0.878 0.84  0.84  0.84  0.84  0.84  0.84  0.84
      0.2   0.2   0.2   0.2   0.2   0.2   0.2   0.2   0.2];  
   
   %if ~exist('mc_inpwr_map')
   %  disp('Converting: MC_AC59 motor map efficiency data --> power loss data')
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
% max torque curve of the motor indexed by mc_map_spd
mc_max_trq=[190 190 190 190 190 190 180 160 128 118 99 80 70 60 50 42 0]; % (N*m)

mc_max_gen_trq=-1*[190 190 190 190 190 190 180 160 128 118 99 80 70 60 50 42 0]; % (N*m), estimate

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=59/59; % (--), estimated

mc_max_crrnt=480; % (A), maximum current allowed by the controller and motor, estimated
mc_min_volts=120; % (V), minimum voltage allowed by the controller and motor, estimated


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
mc_inertia=0.0235;  % (kg*m^2), rotor's rotational inertia
mc_mass=70;  % (kg), mass of motor and controller, estimated																			

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
% 5/12/99 (MS): created modifying MC_A75.m


% 11/03/99:ss updated version from 2.2 to 2.21
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001