%%%%% ADVISOR data file:  MC_PM32ev
%
% Data source:
% Unique Mobility specification sheet for the SR218N/CA40-300L
% motor/controller combination (from www.uqm.com) 10/5/98
%
% Data confidence level:
%
% Notes: 300 V dc input
% Named with 'ev' suffix to indicate that its torque envelope is much better
% suited to EV applications than the other Uniq motor in the library, the SR180.
% 
%
% Created on: 10/7/98
% By: JLA, ANL, john_anderson@qmgate.anl.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Unique Mobility 32-kW continuous, 53-kW intermittent permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM32ev - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-225 -200 -175 -150 -125 -100 -75 -50 -25 -5 ...
      0 5 25 50 75 100 125 150 175 200 225] ;

% (rad/s), speed range of the motor
mc_map_spd=[0 1200 1500 2000 2500 3000 3500 4000 4500 5000 6000 7000 7500]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
mc_eff_map = 0.01*[...
79   79   80   86   85   86   88   88   85   80.5 60 80.5 85   88   88   86   85   86   80   79   79     
79   79   80   86   85   86   88   88   85   80.5 60 80.5 85   88   88   86   85   86   80   79   79
79.5 80   82   86   87   88   89   89   85   81   60 81   85   89   89   88   87   86   82   80   79.5
83   85   86   88   89   90   90.5 90   87   80   60 80   87   90   90.5 90   89   88   86   85   83
85   86   89   90   91   91   91.5 91.5 88   78   60 78   88   91.5 91.5 91   91   90   89   86   85
87   87   90   91   92   92.5 93   92.5 91   79   60 79   91   92.5 93   92.5 92   91   90   87   87
90   90   90   92   93   93   93.5 94   93   79   60 79   93   94   93.5 93   93   92   90   90   90    
92   92   92   92   92.5 93   94   94   93   86   60 86   93   94   94   93   92.5 92   92   92   92
91   91   91   91   91   92   93   92   90   79   60 79   90   92   93   92   91   91   91   91   91
92   92   92   92   92   92   92   91   86   79   60 79   86   91   92   92   92   92   92   92   92
92   92   92   92   92   92   92   91   86   77.5 60 77.5 86   91   92   92   92   92   92   92   92
90.5 90.5 90.5 90.5 90.5 90.5 90.5 90   83   77.5 60 77.5 83   90   90.5 90.5 90.5 90.5 90.5 90.5 90.5
90   90   90   90   90   90   90   90   81   77.5 60 77.5 81   90   90   90   90   90   90   90   90
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
mc_max_trq=[150 150 150 150 137 112 90 76 65 60 46 42 42 ];  % (N*m)
mc_max_gen_trq=-1*[150 150 150 150 137 112 90 76 65 60 46 42 42 ];  % (N*m), estimate

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor= 53/32;  % (--)


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
mc_inertia=0.047;           % (kg*m^2), rotor's rotational inertia                                                                                                                                        
mc_mass=(105 + 28.8)/2.2 ;  % (kg), mass of motor and controller

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
% clear T w mc_outpwr_map mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/7/98 (JA) : original version
% 10/7/98 (JA) : added 0 torque & rpm values
% 10/8/98 (MC) : updated file name and notes
% 2/3/99  (SB): added thermal model variables
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 11/03/99:ss updated version from 2.2 to 2.21
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001