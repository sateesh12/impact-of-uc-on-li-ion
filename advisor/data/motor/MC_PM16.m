%%%%% ADVISOR data file:  MC_PM16
%
% Data source:
% Unique Mobility specification sheet for the DR156s/CR20-150
% motor/controller combination at 180 V, dated 10/1/94
%
% Data confidence level:
% Model data agreement with source data not confirmed
%
% Notes:
% Efficiency/loss data appropriate to a 180-V system.
% Efficiency/loss grid is very coarse.
%
% Created on: 6/30/98
% By: MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Unique Mobility 15.8-kW permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_PM16 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-240 -200 -160 -120 -80 -40 ...
	0 40 80 120 160 200 240]*4.448/3.281/12;

% (rad/s), speed range of the motor
mc_map_spd=[0 1000 2000 3000 4000 5000 6000 7500]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_eff_map =[...
0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1
0.5	0.67	0.78	0.69	0.77	0.5	0.1	0.5	0.77	0.69	0.78	0.67	0.5
0.82	0.86	0.87	0.88	0.88	0.83	0.1	0.83	0.88	0.88	0.87	0.86	0.82
0.88	0.89	0.9	0.9	0.9	0.88	0.1	0.88	0.9	0.9	0.9	0.89	0.88
0.9	0.9	0.91	0.91	0.9	0.87	0.1	0.87	0.9	0.91	0.91	0.9	0.9
0.9	0.9	0.91	0.91	0.9	0.87	0.1	0.87	0.9	0.91	0.91	0.9	0.9
0.91	0.91	0.92	0.91	0.9	0.88	0.1	0.88	0.9	0.91	0.92	0.91	0.91
0.91	0.91	0.91	0.9	0.9	0.88	0.1	0.88	0.9	0.9	0.91	0.91	0.91];
										
												
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
% max torque curve of the motor indexed by mc_map_spd
mc_max_trq=[18.3 18.1 17.8 17.6 17.3 17.1 16.8 0.0]*4.448/3.281; % (N*m)
mc_max_gen_trq=-1*[18.3 18.1 17.8 17.6 17.3 17.1 16.8 0.0]*4.448/3.281; % (N*m),estimate

% maximum overtorque capability (beyond continuous, intermittent only)
% below is (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor=320/220; % (--)

% UQM's max current is 'adjustable,' below is an estimate
mc_max_crrnt=300; % (A), maximum current allowed by the controller and motor
mc_min_volts=30; % (V), minimum voltage allowed by the controller and motor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale mc_map_spd to simulate a faster or slower running motor 
mc_spd_scale=1.0;

% (--), used to scale mc_map_trq to simulate a higher or lower torque motor
mc_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
mc_inertia=0.0208; % (kg*m^2), rotor inertia																	
mc_mass=8.4+12.2; % (kg), mass of motor and controller

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
clear mc_description1 mc_description2			


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2/3/99  (SB): added thermal model variables
% 3/15/99:ss updated *_version to 2.1 from 2.0
												


% 11/03/99:ss updated version from 2.2 to 2.21
% 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001