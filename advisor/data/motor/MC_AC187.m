% ADVISOR Data file:  MC_AC187.m
%
% Data source:
% Based on publicly available information on the traction motor used in 
% BAE Systems HybriDrive (Orion VI)
%
% Efficiency data scaled from motor of below paper.
% Lester, L.E., et al., "An Induction Motor Power Train for EVs--The Right
% Power at the Right Price," reprinted in Proceedings:  Advanced Components for
% Electric and Hybrid Electric Vehicles, 10/27-28/93, Gaithersburg, MD.  
% Mr. Lester was employed with Westinghouse in Maryland at that time, and may
% be still.
%
% Data confidence level:  Best guess based on limited data
%
% Created on:  13 April 2001  
% By:  Michael O'Keefe, National Renewable Energy Laboratory
%      michael_o'keefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='187-kW (continuous) 3-phase AC induction motor/inverter (based on BAE hybridrive for Orion VI)';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_AC187 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 1000 2714/1.5 3000 4000 5000 6000 7000 8000 9000 10000]*(2*pi/60)*1.5;
% Note: the above conversion from RPM to rad/s was fixed 6/16/98

% (N*m), torque range of the motor
mc_map_trq=[-200 -180 -160 -140 -120 -100 -80 -60 -40 -20 ...
	0 20 40 60 80 100 120 140 160 180 200]*(4.448/3.281)*2.4268;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=[...
0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7	0.7
0.78	0.78	0.79	0.8	0.81	0.82	0.82	0.82	0.81	0.77	0.7	0.77	0.81	0.82	0.82	0.82	0.81	0.8	0.79	0.78	0.78
0.85	0.86	0.86	0.86	0.87	0.88	0.87	0.86	0.85	0.82	0.7	0.82	0.85	0.86	0.87	0.88	0.87	0.86	0.86	0.86	0.85
0.86	0.87	0.88	0.89	0.9	0.9	0.9	0.9	0.89	0.87	0.7	0.87	0.89	0.9	0.9	0.9	0.9	0.89	0.88	0.87	0.86
0.81	0.82	0.85	0.87	0.88	0.9	0.91	0.91	0.91	0.88	0.7	0.88	0.91	0.91	0.91	0.9	0.88	0.87	0.85	0.82	0.81
0.82	0.82	0.82	0.82	0.85	0.87	0.9	0.91	0.91	0.89	0.7	0.89	0.91	0.91	0.9	0.87	0.85	0.82	0.82	0.82	0.82
0.79	0.79	0.79	0.78	0.79	0.82	0.86	0.9	0.91	0.9	0.7	0.9	0.91	0.9	0.86	0.82	0.79	0.78	0.79	0.79	0.79
0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.88	0.91	0.91	0.7	0.91	0.91	0.88	0.8	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.9	0.92	0.7	0.92	0.9	0.8	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.88	0.92	0.7	0.92	0.88	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78
0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.8	0.92	0.7	0.92	0.8	0.78	0.78	0.78	0.78	0.78	0.78	0.78	0.78];

%if ~exist('mc_inpwr_map')
 %  disp('Converting: MC_AC75 motor map efficiency data --> power loss data')
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
	mc_losspwr_map=[fliplr(mc_losspwr_map) mc_losspwr_map(:,1) mc_losspwr_map];
	mc_losspwr_map=[mc_losspwr_map(1,:);mc_losspwr_map];

	%% compute input power (power req'd at electrical side of motor/inverter set)
	[T,w]=meshgrid(mc_map_trq,mc_map_spd);
	mc_outpwr_map=T.*w;
	mc_inpwr_map=mc_outpwr_map+mc_losspwr_map;
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max torque curve of the motor indexed by mc_map_spd
%        RPM 0 1500 2714 4500                     6000                      7500                     9000                     10500                    12000                    13500                    15000
mc_max_trq=[200 200 200 397*0.95/3.28997451996343 298*0.90/3.28997451996343 238*0.9/3.28997451996343 198*0.9/3.28997451996343 170*0.9/3.28997451996343 149*0.9/3.28997451996343 132*0.9/3.28997451996343 119*0.9/3.28997451996343]*...
	(4.448/3.281)*2.4268; % (N*m) ; multiplier is 3.28997451996343

mc_max_gen_trq=-1*[200 200 200 397*0.95/3.28997451996343 298*0.90/3.28997451996343 238*0.9/3.28997451996343 198*0.9/3.28997451996343 170*0.9/3.28997451996343 149*0.9/3.28997451996343 132*0.9/3.28997451996343 119*0.9/3.28997451996343]*...
	(4.448/3.281)*2.4268;

%mc_max_gen_trq=-1*[200 200 200 175.2 131.4 105.1 87.6 75.1 65.7 58.4 52.5]*...
%	4.448/3.281; % (N*m), estimate

% maximum overtorque capability (not continuous, because the motor would overheat) 
mc_overtrq_factor=1.2; % (--), estimated

mc_max_crrnt=480; % (A), maximum current allowed by the controller and motor
mc_min_volts=120; % (V), minimum voltage allowed by the controller and motor


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
mc_mass=91;  % (kg), mass of motor and controller																			

% motor/controller thermal model 
mc_th_calc=1;                             % --     0=no mc thermal calculations, 1=do calc's
mc_cp=430;                                % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
mc_tstat=45;                              % C      thermostat temp of motor/controler when cooling pump comes on
mc_area_scale=(mc_mass/91)^0.7;           % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
mc_sarea=0.4*mc_area_scale;               % m^2    total module surface area exposed to cooling fluid (typ rectang module)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
mc_eff_scale=1;

% Begin added by ADVISOR 3.2 converter: 07-Aug-2001
mc_mass_scale_coef=[1 0 1 0];


mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');
% End added by ADVISOR 3.2 converter: 07-Aug-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear T w mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6/12/98 (KW): converted data from A1.2.1 into A2 (as MC_WESTINGHOUSE), have not yet verified
% 6/15/98 (KW): combined with MRC's MC_AC75.m and replaced both with new one 
% 6/16/98 (KW): speed vector multiplier from RPM to rad/s was correctly inverted
% 6/23/98 (MC): disabled existence check preceding computation of input power map
% 6/30/98 (MC): cosmetic changes
% 2/3/99  (SB): added thermal model variables
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 11/1/00:tm added max gen trq placeholder data
% 08/08/01:mpo file created from MC_AC75 and updated to Advisor 3.2