% ADVISOR Data file:  MC_AC150_Focus_draft.m
%
% Data source:  
%
% Data confidence level:  
%
% Notes:  Based on spec sheet for AC-150 motor/controller, and data provided by 
% Alec Brooks from AC Propulsion Inc.
%
% Created on:  3/07/01  
% By: Brian Andonian (bandoman@umich.edu)
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_description='AC Propulsion AC-150 motor controller - draft file';
mc_version=2003; % version of ADVISOR for which the file was generated
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_AC150_Focus_draft - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the motor
mc_map_spd=[0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000]*(2*pi/60);
% Note: the above conversion from RPM to rad/s was fixed 6/16/98

% (N*m), torque range of the motor
mc_map_trq=[-220 -200 -180 -160 -140 -120 -100 -80 -60 -40 -20 ...
	0 20 40 60 80 100 120 140 160 180 200 220];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EFFICIENCY AND INPUT POWER MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map indexed vertically by mc_map_spd and 
% horizontally by mc_map_trq
mc_eff_map=[...

 70 70 70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70      70
 70 70 64      65      67      69      70      71      73      72      72      72      72      72      73      71      70      69      67      65      64      70      70
 70 70 70      79      88      88      88      88      87      86      84      84      84      86      87      88      88      88      88      79      70      70      70
 70 70 75      78      87      88      88      88      87      87      85      70      85      87      87      88      88      88      87      78      75      70      70
 70 70 80      83      86      87      87      88      88      88      86      70      86      88      88      88      87      87      86      83      80      70      70
 70 70 85      87      87      88      88      89      89      89      87      70      87      89      89      89      88      88      87      87      85      70      70
 70 70 88      88      88      89      89      90      90      89      88      70      88      89      90      90      89      89      88      88      88      70      70
 70 70 87      88      89      89      90      90      90      90      88      70      88      90      90      90      90      89      89      88      87      70      70
 70 70 86      87      89      90      91      91      91      91      89      70      89      91      91      91      91      90      89      87      86      70      70
 70 70 86      86      86      88      89      91      91      91      89      70      89      91      91      91      89      88      86      86      86      70      70
 70 70 86      84      84      86      88      90      91      91      90      70      90      91      91      90      88      86      84      84      86      70      70
 70 70 86      89      89      89      89      89      90      91      90      70      90      91      90      89      89      89      89      89      86      70      70];

mc_eff_map=mc_eff_map./100;

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
	mc_losspwr_map=[fliplr(mc_losspwr_map) mc_losspwr_map(:,1)*0.5 mc_losspwr_map];
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
mc_max_trq=[225 225 225 225 225 225 190.98 185.1 179 150 133.7 70];% (N*m)	

mc_max_gen_trq=-1*[200 200 200 175.2 131.4 105.1 87.6 75.1 65.7 58.4 52.5 50]*...
	4.448/3.281; % (N*m), estimate

% maximum overtorque capability (not continuous, because the motor would overheat) 
mc_overtrq_factor=1.8; % (--), estimated

mc_max_crrnt=520; % (A), maximum current allowed by the controller and motor
mc_min_volts=240; % (V), minimum voltage allowed by the controller and motor


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
%rotor dimensions = 6inch dia x 8inch length, rotor mass 29.85kg calculated
%rotor inertia = 0.5*m*r^2 - standard formula for rotational inertia
mc_inertia=0.5*29.85*(3*0.0254)^2;  % (kg*m^2), rotor inertia
mc_mass=82;  % (kg), mass of motor and controller per AC Propusion Corp																			

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
clear T w mc_outpwr1_map mc_losspwr_map T1 w1 pos_spds pos_trqs

% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/07/01 file created from GM_ev1 motor and AC-150 spec sheet