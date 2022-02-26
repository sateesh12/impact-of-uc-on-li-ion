%%%%% ADVISOR data file:  MC_AC83
%
% Data source:
% Professor Doug Nelson of Virginia Tech, 1997, under subcontract to NREL 
%
% Data confidence level:
%
% Notes:
% Unknown system voltage for these tests.
%
% Created on:  6/30/98
% By:  MRC, NREL, matthew_cuddy@nrel.gov

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='GE 83-kW AC induction motor/inverter, tested by VA Tech';
mc_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_AC83 - ',mc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor
mc_map_trq=[-203.4 -190.0 -176.3 -162.7 -149.2 -135.6	-122.0 -108.5 -94.9 ...
      -81.4 -67.8 -54.2 -40.7	-27.1 -13.6 0.0 ... 
      13.6 27.1 40.7 54.2 67.8 81.4 94.9 108.5 122.0 135.6 149.2 162.7 176.3...
      189.8 203.4];

% (rad/s), speed range of the motor
mc_map_spd=[0 105 209 314 419 524 628 733 838 943 1047 1152 1257 1361];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inv_eta=0.01*[
80	80	80	81	81	81	82	82	82	83	83	83	83	83	83	1	83	83	83	83	83	83	82	82	82	81	81	81	80	80	80
80	80	80	81	81	81	82	82	82	83	83	83	83	83	83	1	83	83	83	83	83	83	82	82	82	81	81	81	80	80	80
84	84	85	86	86	86	86.5	86.5	86.5	87.5	87.5	87.5	87.5	87.5	87.5	1	87.5	87.5	87.5	87.5	87.5	87.5	86.5	86.5	86.5	86	86	86	85	84	84
88	89	89	89	90	90	91	91	91	92	92	92	92	92	92	1	92	92	92	92	92	92	91	91	91	90	90	89	89	89	88
88	94	94	95	95	95	95.5	95.5	95.5	96.5	96.5	96.5	96.5	96.5	96.5	1	96.5	96.5	96.5	96.5	96.5	96.5	95.5	95.5	95.5	95	95	95	94	94	88
88	94	94	94	94	94	94	95	96.6	96.9	97	97.3	98	98	97.7	1	97.7	98	98	97.3	97	96.9	96.6	95	94	94	94	94	94	94	88
88	94	94	94	94	92	93	94	96	96.6	97	97.3	97.5	98.1	97.8	1	97.8	98.1	97.5	97.3	97	96.6	96	94	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	95	96	96.6	97	97.1	98.2	97.7	1	97.7	98.2	97.1	97	96.6	96	95	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	95	96	96.7	97	96.9	97.3	1	97.3	96.9	97	96.7	96	95	94	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	94	95	96.4	97.1	98.1	97.9	1	97.9	98.1	97.1	96.4	95	94	94	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	94	94	96	97.1	97.3	98.1	1	98.1	97.3	97.1	96	94	94	94	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	94	94	95	96	97.1	97.8	1	97.8	97.1	96	95	94	94	94	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	94	94	94	96	96.7	97	1	97	96.7	96	94	94	94	94	93	93	92	94	94	94	94	88
88	94	94	94	94	92	93	93	94	94	94	94	95	96	96	1	96	96	95	94	94	94	94	93	93	92	94	94	94	94	88
];

mot_eta=0.01*[
71.1	70	71.6	72	73.5	74.3	76.8	80.1	79.3	80.4	81.2	81.5	82	82.2	81.3	1	81.3	82.2	82	81.5	81.2	80.4	79.3	80.1	76.8	74.3	73.5	72	71.6	70	71.1
71.1	70	71.6	72	73.5	74.3	76.8	80.1	79.3	80.4	81.2	81.5	82	82.2	81.3	1	81.3	82.2	82	81.5	81.2	80.4	79.3	80.1	76.8	74.3	73.5	72	71.6	70	71.1
82.2	81.5	82.4	83.2	85.8	84.9	85.7	88	87.2	87.8	87.9	87.9	87.8	88.3	87.1	1	87.1	88.3	87.8	87.9	87.9	87.8	87.2	88	85.7	84.9	85.8	83.2	82.4	81.5	82.2
85.7	86	86.8	87.4	88.2	88.7	89.3	91	90.3	90.6	90.8	90.5	90.3	90.6	89.3	1	89.3	90.6	90.3	90.5	90.8	90.6	90.3	91	89.3	88.7	88.2	87.4	86.8	86	85.7
85.7	87.8	88.3	88.8	89.3	89.7	91.3	92.5	92.1	92.4	92.5	92.3	91.9	92	90.5	1	90.5	92	91.9	92.3	92.5	92.4	92.1	92.5	91.3	89.7	89.3	88.8	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	90	90.6	91.2	91.6	91.9	91.9	91.6	90.6	93	91.4	1	91.4	93	90.6	91.6	91.9	91.9	91.6	91.2	90.6	90	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	91.1	91	91.8	92.4	92.7	92.6	92.1	92.2	1	92.2	92.1	92.6	92.7	92.4	91.8	91	91.1	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	89.9	91.7	93	94.2	95.1	95.7	94	1	94	95.7	95.1	94.2	93	91.7	89.9	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	89.4	91.5	93.2	94.6	95.6	93.7	1	93.7	95.6	94.6	93.2	91.5	89.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	86.4	89.2	91.9	93.8	95.3	94.5	1	94.5	95.3	93.8	91.9	89.2	86.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	86.4	86.5	89	92.8	94.8	94.1	1	94.1	94.8	92.8	89	86.5	86.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	86.4	86.5	87.7	91.5	94.2	94	1	94	94.2	91.5	87.7	86.5	86.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	86.4	86.5	83.5	88.8	93.4	93.9	1	93.9	93.4	88.8	83.5	86.5	86.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
85.7	87.8	88.3	88.2	89.2	87.9	89	88.4	87.2	86.4	86.5	83.5	87.3	92.4	93.8	1	93.8	92.4	87.3	83.5	86.5	86.4	87.2	88.4	89	87.9	89.2	88.2	88.3	87.8	85.7
];

mc_eff_map=inv_eta.*mot_eta;
										
												
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
mc_max_trq=[203 203 203 203 193 156 129 111 98 85 79 72 65 60]; % (N*m)

mc_max_gen_trq=-1*[203 203 203 203 193 156 129 111 98 85 79 72 65 60]; % (N*m), estimate

% maximum overtorque capability (not continuous, because the motor would overheat) 
mc_overtrq_factor=1; % (--), estimated

mc_max_crrnt=385; % (A), maximum current allowed by the controller and motor
mc_min_volts=200; % (V), minimum voltage allowed by the controller and motor


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
mc_inertia=0; % (kg*m^2), rotor's rotational inertia; unknown
mc_mass=110; % (kg), mass of motor and controller

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
clear mc_description1 mc_description2 inv_eta mot_eta


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