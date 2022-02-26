% ADVISOR data file:  GC_PRIUS_JPN.m
%
% Data source:
% Unique Mobility testing
% 
%
% Data confirmation:
%
% Notes:
% 
% 
% Created on: 9-August-1999
% By:  SS, NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='PRIUS_JPN 15-kW permanent magnet motor/controller';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_PRIUS_JPN - ',gc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque vector corresponding to columns of efficiency & loss maps
% this is INPUT torque (>0 => running as a generator)
gc_map_trq=[-55 -45 -35 -25 -15 -5 0 5 15 25 35 45 55];
% data reported was from 5 to 55 Nm, map was mirrored for negative and values at 0
% were taken from nearest neighbors.

% (rad/s), speed vector corresponding to rows of efficiency & loss maps
gc_map_spd=[-5500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 5500]*(2*pi)/60; 
% data reported was from 500 rpm to 4000 rpm, values for 0 and 5500 rpm are identical
% to nearest neighbors. Map was mirrored for negative values


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%multiply everything by 0.95 for power electronics efficiency
%data in brackets is electric machine only as tested by UQM.

gc_eff_map=0.95*[...
0.88	0.89	0.9	0.91	0.9	0.79	0.79	0.79	0.9	0.91	0.9	0.89	0.88
0.88	0.89	0.9	0.91	0.9	0.79	0.79	0.79	0.9	0.91	0.9	0.89	0.88
0.87	0.88	0.9	0.9	0.9	0.8	0.8	0.8	0.9	0.9	0.9	0.88	0.87
0.85	0.87	0.89	0.9	0.9	0.81	0.81	0.81	0.9	0.9	0.89	0.87	0.85
0.83	0.85	0.87	0.89	0.89	0.82	0.82	0.82	0.89	0.89	0.87	0.85	0.83
0.8	0.83	0.85	0.87	0.89	0.82	0.82	0.82	0.89	0.87	0.85	0.83	0.8
0.76	0.79	0.82	0.85	0.87	0.82	0.82	0.82	0.87	0.85	0.82	0.79	0.76
0.68	0.72	0.76	0.8	0.84	0.81	0.8	0.81	0.84	0.8	0.76	0.72	0.68
0.52	0.57	0.63	0.69	0.77	0.8	0.8	0.8	0.77	0.69	0.63	0.57	0.52
0.52	0.57	0.63	0.69	0.77	0.8	0.8	0.8	0.77	0.69	0.63	0.57	0.52
0.52	0.57	0.63	0.69	0.77	0.8	0.8	0.8	0.77	0.69	0.63	0.57	0.52
0.68	0.72	0.76	0.8	0.84	0.81	0.8	0.81	0.84	0.8	0.76	0.72	0.68
0.76	0.79	0.82	0.85	0.87	0.82	0.82	0.82	0.87	0.85	0.82	0.79	0.76
0.8	0.83	0.85	0.87	0.89	0.82	0.82	0.82	0.89	0.87	0.85	0.83	0.8
0.83	0.85	0.87	0.89	0.89	0.82	0.82	0.82	0.89	0.89	0.87	0.85	0.83
0.85	0.87	0.89	0.9	0.9	0.81	0.81	0.81	0.9	0.9	0.89	0.87	0.85
0.87	0.88	0.9	0.9	0.9	0.8	0.8	0.8	0.9	0.9	0.9	0.88	0.87
0.88	0.89	0.9	0.91	0.9	0.79	0.79	0.79	0.9	0.91	0.9	0.89	0.88
0.88	0.89	0.9	0.91	0.9	0.79	0.79	0.79	0.9	0.91	0.9	0.89	0.88];
% efficiency of generator in all four quadrants of operation

%
% convert to losses, assuming losses are symmetric about zero torque
%
[T1,w1]=meshgrid(gc_map_trq,gc_map_spd);
gc_mech_pwr_map=T1.*w1; % (W), output power (when motoring) for each trq and spd
temp=gc_mech_pwr_map./gc_eff_map; % input power (when motoring)
gc_loss_map=temp-gc_mech_pwr_map; % (W) loss corresponding to each trq and spd

% already assumed that losses at zero torque and speed are the same as nearest neighbors

%
% convert loss map to output power map for machine running as a generator
%
gc_outpwr_map=gc_mech_pwr_map-gc_loss_map;
gc_inpwr_map=gc_outpwr_map+gc_loss_map;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_max_crrnt=300;	% maximum current draw for motor/controller set, A
gc_min_volts=60;	% minimum voltage for motor/controller set, V
% maximum continuous torque corresponding to speeds in gc_map_spd
%a guess!!
gc_max_trq=[26 36 41 48 55 55 55 55 55 55 55 55 55 55 55 48 41 36 26]; % (N*m)

% factor by which motor torque can exceed maximum continuous torque for short
% periods of time
gc_overtrq_factor=1;  % (--) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
gc_spd_scale=1.0;
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
gc_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
gc_inertia=0.0226; % (kg*m^2), rotor's rotational inertia																		
gc_mass=32.7; % (kg), mass of machine and enclosure

% gen/controller thermal model 
gc_th_calc=1;                             % --     0=no mc thermal calculations, 1=do calc's
gc_cp=430;                                % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
gc_tstat=45;                              % C      thermostat temp of motor/controler when cooling pump comes on
gc_area_scale=(gc_mass/91)^0.7;           % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
gc_sarea=0.4*gc_area_scale;               % m^2    total module surface area exposed to cooling fluid (typ rectang module)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gc_eff_scale=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear T1 w1 temp gc_loss_map gc_mech_pwr_map


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 8/9/99 :ss created
%8/23/99 :ss added thermal variables
% 10/1/99: ss set overtorque factor to 1 (no data to say otherwise)
% 10/19/99: ss changed mass to 72 lb or 32.7 kg


% 11/03/99:ss updated version from 2.2 to 2.21
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
gc_mass_scale_coef=[1 0 1 0];

gc_mass_scale_fun=inline('(x(1)*gc_trq_scale+x(2))*(x(3)*gc_spd_scale+x(4))*gc_mass','x','gc_spd_scale','gc_trq_scale','gc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001