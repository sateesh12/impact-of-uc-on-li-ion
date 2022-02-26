% ADVISOR data file:  ESS_PB75_14V_saber.m
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
ess_description='Saber lead acid battery';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=1; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_PB75_42V_saber - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_vehicletype=5;
% see below ess_ah_nom=75;	% A*hr: Nominal amp·hour capacity at tnom and inom. Must be specified consistent with inom and tend
ess_rnom=0.020; % W	Nominal internal electrical resistance at tnom and "full charge"
ess_sg_full=1.310; % Specific gravity at full charge at 25°C
ess_sg_disc=1.025; % Specific gravity full discharge at 25°C
ess_fah_thi=1.02; % Multiple of ah_nom at "high temperature" and inom (neglecting self discharge). Must be > 1 and < fah_max
ess_fc=0.6; % Fraction of capacity "near plate". Must be 0 < fc < 1
ess_fah_max=1.03; % Multiple of ah_nom capacity available at "slow" (i.e. < 0.01·inom) discharge and tnom. (neglecting self discharge). Must be > fah_thi
ess_self_disc=0.25; % Percent/day:  Percentage of ah_nom lost per day from self discharge at 25°C

ess_module_num=5; % Number of battery cells. Must be a positive integer
ess_voc=2.3;  %ess_v_flt=2.3; % V/cell:	Voltage per cell, where i_flt is specified.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SOC to sg coorelation for setting initial sg in Saber
ess_SOC2sg=[0	1.03355
    .10081	1.061195
    .20072	1.08884
    .30063	1.116485
    .40054	1.14413
    .50045	1.171775
    .60036	1.19942
    .70027	1.227065
    .80018	1.25471
    .90009	1.282355
    1.0000	1.31];




ess_cap_scale=1; % scale factor for module max ah capacity

ess_module_mass=((75/6)*(11.8/28)); % (kg), mass of a single cell (approximation based on ESS_PB28 capacity/mass ratio)

ess_ah_nom_fun=inline('75*ess_cap_scale');

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess_res_scale_fun=inline('(x(1)*ess_module_num+x(2))/(x(3)*ess_cap_scale+x(4))','x','ess_module_num','ess_cap_scale');
ess_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/8/02:  ab created
