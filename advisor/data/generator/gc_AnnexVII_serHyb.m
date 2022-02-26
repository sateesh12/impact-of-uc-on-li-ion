% ADVISOR data file:  GC_AnnexVII_serHyb.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% 
% Created on:
% By:
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='Null Generator/Controller File eff 90%';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_AnnexVII_serHyb - ',gc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque vector corresponding to columns of efficiency & loss maps
% this is INPUT torque (>0 => running as a generator)
gc_map_trq=[200 400 600 800 1000 1200 1400 1600 1800]; % *1158/1959; %just scaled the torque vector to reduce power

% (rad/s), speed vector corresponding to rows of efficiency & loss maps
gc_map_spd=[1200 1350 1500 1650 1800 2100]*2*pi/60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_eff_map=ones(length(gc_map_spd),length(gc_map_trq))*0.9;  % (--)

% CONVERT EFFICIENCY MAP TO OUTPUT POWER MAP
[T1,w1]=meshgrid(gc_map_trq,gc_map_spd);
gc_inpwr_map=T1.*w1;
% (W), output power map indexed vertically by gc_map_spd and horizontally
% by gc_map_trq
gc_outpwr_map=gc_inpwr_map.*gc_eff_map;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gc_max_crrnt=480;	% maximum current draw for motor/controller set, A
gc_max_crrnt=1000;	% maximum current draw for motor/controller set, A
%gc_min_volts=120;	% minimum voltage for motor/controller set, V
gc_min_volts=12;	% minimum voltage for motor/controller set, V
% maximum continuous torque corresponding to speeds in mc_map_spd
gc_max_trq=max(fc_max_trq)*ones(size(gc_map_spd));  % (N*m)


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
gc_inertia=0;  % (kg*m^2), rotor's rotational inertia																	
gc_mass=0;  % (kg), mass of generator and controller (no mass when paired with fuel cell)
% factor by which motor torque can exceed maximum continuous torque for short
% periods of time
gc_overtrq_factor=1;  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear T1 w1 gc_inpwr_map


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/24/00:tm file created from GC_ETA100.M

% Begin added by ADVISOR 2002 converter: 17-Apr-2002
gc_mass_scale_coef=[1 0 1 0];

gc_mass_scale_fun=inline('(x(1)*gc_trq_scale+x(2))*(x(3)*gc_spd_scale+x(4))*gc_mass','x','gc_spd_scale','gc_trq_scale','gc_mass');
% End added by ADVISOR 2002 converter: 17-Apr-2002