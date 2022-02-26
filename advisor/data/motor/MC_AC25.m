%%%%% ADVISOR data file:  MC_AC25
%
% Data source:
% Solectria specification sheet for the ACgtx20/AC300
% motor/controller combination at 144 V, dated 1994
%
% Data confidence level:
%
% Notes:
% Efficiency/loss data appropriate to a 144-V system.
% Efficiency/loss grid is very coarse.
%
% Created on:  6/30/98
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='Solectria ACgtx20/AC300 AC induction motor/controller';
mc_version=2003;
mc_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_AC25 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TORQUE AND SPEED ranges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N-m, torque vector corresponding to columns of efficiency & loss maps
mc_map_trq=[-55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 ...
	0 5 10 15 20 25 30 35 40 45 50 55];

% rad/s, speed vector corresponding to rows of efficiency & loss maps
mc_map_spd=[0 1500 3000 4500 6000 7500]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_eff_map =[...
0.72	0.65	0.674	0.691	0.705	0.716	0.722	0.732	0.742	0.737	0.66	0.1	0.66	0.737	0.742	0.732	0.722	0.716	0.705	0.691	0.674	0.65	0.72
0.72	0.738	0.755	0.768	0.78	0.79	0.796	0.802	0.807	0.8	0.74	0.1	0.74	0.8	0.807	0.802	0.796	0.79	0.78	0.768	0.755	0.738	0.72
0.72	0.826	0.836	0.845	0.855	0.864	0.87	0.872	0.872	0.863	0.82	0.1	0.82	0.863	0.872	0.872	0.87	0.864	0.855	0.845	0.836	0.826	0.72
0.72	0.826	0.836	0.845	0.855	0.886	0.899	0.9	0.898	0.89	0.85	0.1	0.85	0.89	0.898	0.9	0.899	0.886	0.855	0.845	0.836	0.826	0.72
0.72	0.826	0.836	0.845	0.855	0.886	0.899	0.885	0.9	0.899	0.88	0.1	0.88	0.899	0.9	0.885	0.899	0.886	0.855	0.845	0.836	0.826	0.72
0.72	0.826	0.836	0.845	0.855	0.886	0.899	0.885	0.9	0.897	0.89	0.1	0.89	0.897	0.9	0.885	0.899	0.886	0.855	0.845	0.836	0.826	0.72];
																				
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max torque curve of the motor indexed by mc_map_spd
mc_max_trq=[55 55 55 39.5 35.9 32.3]; % (N*m)
mc_max_gen_trq=-1*[55 55 55 39.5 35.9 32.3]; % (N*m), estimate

% maximum overtorque capability (not continuous, because the motor would overheat) 
mc_overtrq_factor=1.5; % (--), estimated

mc_max_crrnt=210; % (A), maximum current allowed by the controller and motor
mc_min_volts=70; % (V), minimum voltage allowed by the controller and motor


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
mc_inertia=0;		% rotor's rotational inertia, kg-m^2, unknown

% kW/kg, rated continuous motor power/sum of motor and controller mass																		
mc_mass=66+20/2.205;

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
% % 11/1/00:tm added max gen trq placeholder data
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001