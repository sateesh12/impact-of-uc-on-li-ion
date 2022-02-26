% ADVISOR data file:  ESS_PB28.m    where 28 is c/5-rate capacity
%
% Data source:
% Testing done by University of Illinois
%
% Data confirmation:
%
% Notes:
% These parameters describe the Johnson Controls 12-95 lead-acid battery.  This
% data was provided by the University of Illinois Urbana/Champaign under
% subcontract #XCB-5-15296-01 to NREL.
% 
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Johnson Controls lead-acid battery, tested by U of Illinois';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_PB28 - ',ess_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0:.2:1];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess_max_ah_cap=[
   28
   28
   28
];	% (A*h), max. capacity at C/5 rate, indexed by ess_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess_coulombic_eff=[
   .9
   .9
   .9
];  % (--);
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess_r_dis=[
   0.038 0.024 0.007 0.007 0.007 0.011
   0.038 0.024 0.007 0.007 0.007 0.011
   0.038 0.024 0.007 0.007 0.007 0.011
]; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess_r_chg=ess_r_dis; %no other data available

% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[
   6.0 8.9 11.8 12.0 12.3 12.6
   6.0 8.9 11.8 12.0 12.3 12.6
   6.0 8.9 11.8 12.0 12.3 12.6
]; % (V) voc at low soc seems low compared with other lead acid batteries, use with caution


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=5.5;% caution, this value may be too low(compared with other lead acid batteries, see also
%                                ess_voc note.
ess_max_volts=16.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=11.8;  % (kg), mass of a single ~12 V module

ess_module_num=25;  %a default value for number of modules

ess_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess_res_scale_fun=inline('(x(1)*ess_module_num+x(2))/(x(3)*ess_cap_scale+x(4))','x','ess_module_num','ess_cap_scale');
ess_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun

% battery thermal model
ess_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=660;                            % J/kgK  ave heat capacity of module (typical Pb bat - from Optima)
ess_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess_area_scale=(ess_module_mass/11)^0.7;   % --     if module dimensions are unknown, assume rectang shape and scale vs PB25
ess_mod_sarea=0.2*ess_area_scale;          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess_mod_airflow=0.01;                      % kg/s   cooling air mass flow rate across module (20 cfm=0.01 kg/s at 20 C)
ess_mod_flow_area=0.005*ess_area_scale;    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess_mod_case_thk=2/1000;                   % m      thickness of module case (typ from Optima)
ess_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material (typ polyprop plastic - Optima)
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001);
ess_th_res_on=min(ess_th_res_on,ess_th_res_off);
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef ess_area_scale


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/4/98 (DR): converted W-hr values to A-hr values (in E_JC1295.m)
% 10/13/98:mc recomputed ess_max_ah_cap and renamed file (from ESS_PB25)
%             for consistency with other files
% 02/09/99 (SDB):  added thermal model inputs
% 2/4/99 ss: added ess_module_num=25;
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 8/5/99:ss deleted all peukert coefficient and data(no longer needed in advisor model) 
%           added limits 'ess_max_volt' and 'ess_min_volt'
%9/9/99: vhj changed variables to include thermal modeling (matrices, not vector), added ess_tmp
% 11/03/99:ss updated version from 2.2 to 2.21
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance