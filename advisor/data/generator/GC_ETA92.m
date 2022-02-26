% ADVISOR data file:  GC_ETA92.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Speed- and torque-independent efficiency=95%.
% 
% Created on: 23-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='Sample generator/controller file, 92% efficient';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_ETA92 - ',gc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque vector corresponding to columns of efficiency & loss maps
% this is INPUT torque (>0 => running as a generator)
gc_map_trq=[0:5:200];

% (rad/s), speed vector corresponding to rows of efficiency & loss maps
gc_map_spd=[0:250:7000]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_eff_map=ones(length(gc_map_spd),length(gc_map_trq))*0.92;  % (--)

% CONVERT EFFICIENCY MAP TO OUTPUT POWER MAP
[T1,w1]=meshgrid(gc_map_trq,gc_map_spd);
gc_inpwr_map=T1.*w1;
% (W), output power map indexed vertically by gc_map_spd and horizontally
% by gc_map_trq
gc_outpwr_map=gc_inpwr_map.*gc_eff_map;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_max_crrnt=480;	% maximum current draw for motor/controller set, A
gc_min_volts=120;	% minimum voltage for motor/controller set, V
% maximum continuous torque corresponding to speeds in mc_map_spd
gc_max_trq=200*ones(size(gc_map_spd));  % (N*m)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
gc_spd_scale=1.0;
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
gc_trq_scale=1.0;

% user definable mass scaling relationship
gc_mass_scale_fun=inline('(x(1)*gc_trq_scale+x(2))*(x(3)*gc_spd_scale+x(4))*gc_mass','x','gc_spd_scale','gc_trq_scale','gc_mass');
gc_mass_scale_coef=[1 0 1 0]; % mass scaling coefficiencts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
gc_inertia=0.01;  % (kg*m^2), rotor's rotational inertia	
% mass of generator and controller based on the specific mass of GC_PM32 (0.8663 kW/kg)
gc_mass=max(gc_map_spd.*gc_max_trq)*gc_trq_scale*gc_spd_scale/1000/0.8663;  % (kg)
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
% 09/14/98:MC adjusted map torques to extend all the way up to max torques
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 7/30/01:tm updated version from 3.1 to 3.2
% 7/30/01:tm added mass scaling relationship mass=f(gc_spd_scale,gc_trq_scale, gc_mass)
% 30-Jul-2001: automatically updated to version 3.2