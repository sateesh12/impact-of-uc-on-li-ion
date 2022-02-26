% ADVISOR data file:  ESS_NULL.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% These parameters describe a NULL battery system.  
% It's purpose is to allow the user to evaluate the 
% performance of a vehicle with a disabled battery system.
% As configured the mass and voltage limits have been retained
% and may impact the simulation results. To disable these items 
% also, set ess_module_mass to 0.01 (do not set to 0 - some mass 
% required for thermal models) and set ess_min_volts very low 
% and ess_max_volts very high. All ess parameters in this file
% are based on the ESS_PB25 data file.
%
% Created on: 8/21/00
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Null Battery';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_NULL - ',ess_description])

% disable battery boolean, 1==> enabled, 2==> disabled
ess_on=0;

%%%% all other parameters below this line are based on ESS_PB25 %%%%

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
   25
   25
   25
];	% (A*h), max. capacity at C/5 rate, indexed by ess_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess_coulombic_eff=[
   .9
   .9
   .9
];  % (--);
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess_r_dis=[
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
]/1000; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess_r_chg=[
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
]/1000; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
]; % (V)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=9.5;
ess_max_volts=16.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=11;  % (kg), mass of a single ~12 V module

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
ess_mod_cp=660;                            % J/kgK  ave heat capacity of module
ess_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=0.2;                         % m^2    total module surface area exposed to cooling air
ess_mod_airflow=0.07/5;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area=0.0025;                  % m^2    cross-sec flow area for cooling air per module (10-mm gap btwn mods)
ess_mod_case_thk=2/1000;                   % m      thickness of module case
ess_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001);
ess_th_res_on=min(ess_th_res_on,ess_th_res_off);
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8/21/00:tm file created based on ess_pb25
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance