% ADVISOR data file:  GC_PM32.m
%
% Data source:
% Unique Mobility specification sheet for the SR180p/CR20-300
% motor/controller combination at 195 V, dated 10/28/94
%
% Data confirmation:
%
% Notes:
% This is the same machine/inverter combination as is in MC_PM32
% 
% Created on: 2-Sep-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='Unique Mobility 32-kW permanent magnet motor/controller';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_PM32 - ',gc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque vector corresponding to columns of efficiency & loss maps
% this is INPUT torque (>0 => running as a generator)
gc_map_trq=[0 40 80 120 160 200 240 320 400 480 520]*4.448/3.281/12;

% (rad/s), speed vector corresponding to rows of efficiency & loss maps
gc_map_spd=[0 500 1000 1500 2000 2500 3000 4000 5000 6000 7000]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_eff_map=[
0.200	0.200	0.200	0.200	0.200	0.200	0.200	0.200	0.200	0.200	0.200
0.200	0.380	0.490	0.520	0.570	0.600	0.600	0.520	0.450	0.430	0.430
0.200	0.500	0.620	0.670	0.715	0.725	0.730	0.720	0.710	0.700	0.700
0.200	0.520	0.650	0.710	0.740	0.765	0.770	0.775	0.775	0.767	0.767
0.200	0.540	0.670	0.730	0.770	0.785	0.780	0.800	0.805	0.808	0.808
0.200	0.580	0.700	0.760	0.785	0.810	0.820	0.830	0.835	0.830	0.830
0.200	0.590	0.720	0.770	0.800	0.825	0.835	0.845	0.847	0.846	0.846
0.200	0.600	0.755	0.805	0.830	0.845	0.854	0.865	0.866	0.868	0.868
0.200	0.600	0.770	0.815	0.840	0.860	0.867	0.883	0.888	0.887	0.887
0.200	0.550	0.775	0.830	0.860	0.870	0.884	0.897	0.905	0.910	0.910
0.200	0.500	0.760	0.840	0.870	0.885	0.893	0.905	0.915	0.920	0.920
];% (--), efficiency of the machine/inverter when run as a motor

%
% convert to losses, assuming losses are symmetric about zero torque
%
[T1,w1]=meshgrid(gc_map_trq,gc_map_spd);
gc_mech_pwr_map=T1.*w1; % (W), output power (when motoring) for each trq and spd
temp=gc_mech_pwr_map./gc_eff_map; % input power (when motoring)
gc_loss_map=temp-gc_mech_pwr_map; % (W) loss corresponding to each trq and spd

%
% assume that losses at zero torque and speed are the same as nearest neighbors
%
gc_loss_map(1,:)=gc_loss_map(2,:); % loss at zero spd = loss at lowest +ive spd
gc_loss_map(:,1)=gc_loss_map(:,2); % loss at zero trq = loss at lowest +ive trq

%
% convert loss map to output power map for machine running as a generator
%
gc_outpwr_map=gc_mech_pwr_map-gc_loss_map;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_max_crrnt=300;	% maximum current draw for motor/controller set, A
gc_min_volts=60;	% minimum voltage for motor/controller set, V
% maximum continuous torque corresponding to speeds in gc_map_spd
gc_max_trq=[512 508.1 504.2 500.3 496.3	492.4 488.5 480.7 472.8 465 0]...
   *4.448/3.281/12; % (N*m)
% factor by which motor torque can exceed maximum continuous torque for short
% periods of time
gc_overtrq_factor=320/220;  % (--)


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
gc_mass=23.6+14.5; % (kg), mass of machine and controller


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear T1 w1 gc_inpwr_map temp gc_loss_map gc_mech_pwr_map


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3/15/99:ss updated *_version to 2.1 from 2.0




% 11/03/99:ss updated version from 2.2 to 2.21
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
gc_mass_scale_coef=[1 0 1 0];

gc_mass_scale_fun=inline('(x(1)*gc_trq_scale+x(2))*(x(3)*gc_spd_scale+x(4))*gc_mass','x','gc_spd_scale','gc_trq_scale','gc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001