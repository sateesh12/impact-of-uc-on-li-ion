% ADVISOR data file:  ESS2_PB54_saber.m
%
% Data source:
% 
%
% Data confirmation:
%
% Notes:
% These parameters are used in the Saber lead acid battery 
% 
% Created on: 08-March-2002
% By:  AB, NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Saber lead acid battery';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=1; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS2_PB54_14V_saber - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_vehicletype=5;
% ess2_ah_nom=54;	% A*hr: Nominal amp·hour capacity at tnom and inom. Must be specified consistent with inom and tend
ess2_rnom=0; % W	Nominal internal electrical resistance at tnom and "full charge"
ess2_sg_full=1.320; % Specific gravity at full charge at 25°C
ess2_sg_disc=1.010; % Specific gravity full discharge at 25°C
ess2_fah_thi=1.2; % Multiple of ah_nom at "high temperature" and inom (neglecting self discharge). Must be > 1 and < fah_max
ess2_fc=0.45; % Fraction of capacity "near plate". Must be 0 < fc < 1
ess2_fah_max=1.4; % Multiple of ah_nom capacity available at "slow" (i.e. < 0.01·inom) discharge and tnom. (neglecting self discharge). Must be > fah_thi
ess2_self_disc=0.25; % Percent/day:  Percentage of ah_nom lost per day from self discharge at 25°C

ess2_module_num=5; % Number of battery cells. Must be a positive integer
ess2_voc=2.3;    %ess2_v_flt=2.3; % V/cell:	Voltage per cell, where i_flt is specified.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SOC to sg coorelation for setting initial sg in Saber
ess2_SOC2sg=[0	1.098576
    .10002	1.1207184
    .20002	1.1428608
    .30001	1.1650032
    .40001	1.1871456
    .50001	1.209288
    .60000	1.2314304
    .70000	1.2535728
    .80000	1.2757152
    .90000	1.2978576
    1.0000	1.32];;



ess2_cap_scale=1; % scale factor for module max ah capacity

ess2_module_mass=((54/6)*(11.8/28)); % (kg), mass of a single cell (approximation based on ESS_PB28 capacity/mass ratio)

ess2_ah_nom_fun=inline('54*ess_cap_scale');

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/8/02:  ab created
