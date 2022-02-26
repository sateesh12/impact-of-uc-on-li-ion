% ADVISOR data file:  ESS_PB85.m    where 85 is c/5-rate capacity
%
% Data source:
% File created from ESS_PB91.m
%
% Data confirmation:
% Not confirmed
%
% Notes:
% This battery model has been created in attempt to model lead acid batteries
% used in Orion VI series hybrid transit bus. ess_voc, ess_max_ah_cap, and
% ess_module_num have been changed from their values in ESS_PB91. All other
% values have been left as is.
% 
% Created on: Oct-2000
% By:  mpo, NREL, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Horizon 12N85 lead-acid battery';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_PB85 - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0:.1:1];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess_max_ah_cap=[
   85
   85
   85
];	% (A*h), max. capacity at C/5 rate, indexed by ess_tmp, changed from 91 by mpo Oct-2000
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess_coulombic_eff=[
   .9
   .9
   .9
];  % (--);
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess_r_dis=[
   4.57 2.686 2.226 1.970 1.843 1.747 1.711 1.685 1.697 1.756 1.769
   4.57 2.686 2.226 1.970 1.843 1.747 1.711 1.685 1.697 1.756 1.769
   4.57 2.686 2.226 1.970 1.843 1.747 1.711 1.685 1.697 1.756 1.769
]/1000; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
%ess_r_chg=ess_r_dis; % (ohm), no other data available
ess_r_chg=fliplr(ess_r_dis); % (ohm), no other data available tm:022800
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[
   11.406 11.73 11.904 12.096 12.216 12.384 12.492 12.636 12.75 12.918 12.99
   11.406 11.73 11.904 12.096 12.216 12.384 12.492 12.636 12.75 12.918 12.99
   11.406 11.73 11.904 12.096 12.216 12.384 12.492 12.636 12.75 12.918 12.99
]*12/12.384; % (V) Voltages changed slightly for better modeling fit mpo, oct 2000


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=9.5;
ess_max_volts=16.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=24.9;  % (kg), mass of a single ~12 V module

ess_module_num=46;  %a default value for number of modules; corresponds to default number of modules in Orion VI transit bus

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
% 6/30/98 (MC): converted from E_H12N85.M
% 10/13/98:mc recomputed ess_max_ah_cap and renamed file (from ESS_PB85)
%             for consistency with other files
% 02/09/99 (SDB):  added thermal model inputs
% 2/4/99 ss: added ess_module_num=25;
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 8/5/99:ss deleted all peukert coefficient and data(no longer needed in advisor model) 
%           added limits 'ess_max_volt' and 'ess_min_volt'
%9/9/99: vhj changed variables to include thermal modeling (matrices, not vector), added ess_tmp

% 11/03/99:ss updated version from 2.2 to 2.21
% 3/15/00 tm added fliplr to ess_r_chg to more realistically represnt the expected charge resistance trend
% 01-Oct-2000 mpo: created ESS_PB85.m file from ESS_PB91.m
% 19-Jan-2001 mpo: updated version from 3.0 to 3.1
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance