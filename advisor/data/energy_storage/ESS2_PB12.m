% ADVISOR data file:  ESS_PB12.m
%
% Data source: Tests done at NREL
%
% Data confirmation: Model validated over US06 power profile
%
% Notes:
% Number of cells per module: 6x2V=12V/module
% Capacity (C/20): 12Ah/3.5kWh
% Peak power, 10s at 50% SOC: 30kW
% 
% Created on: 12/15/98
% By: DJR, NREL, (contact valerie_johnson@nrel.gov with questions)
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Hawker Genesis Lead Acid Battery; tested at NREL';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_PB12 - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0:.2:1];  % (--)								% from tests at NREL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[
   12
   12
   12
];	% (A*h), max. capacity at C/3 rate, indexed by ess2_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess2_tmp
ess2_coulombic_eff=[
   .9
   .9
   .9
];  % (--);
% module's resistance to being discharged, indexed by ess2_soc and ess2_tmp
ess2_r_dis=[
   100 38 23 26 28 28
   100 38 23 26 28 28
   100 38 23 26 28 28
]/1000; % (ohm)
% module's resistance to being charged, indexed by ess2_soc and ess2_tmp
%Note: last Rchg number (150 mohm) is an extrapolation since test data limited
ess2_r_chg=[
   55 56 57 62 130 150
   55 56 57 62 130 150
   55 56 57 62 130 150
]/1000; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess2_soc and ess2_tmp
ess2_voc=[
   11.419 11.889 12.161 12.434 12.706 13.159
   11.419 11.889 12.161 12.434 12.706 13.159
   11.419 11.889 12.161 12.434 12.706 13.159
   ]; % (V)
   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=9.5;
ess2_max_volts=16.5;

ess2_module_num=25;  %a default value for number of modules

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess2_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess2_res_scale_fun

% battery thermal model
ess2_th_calc=0;                             % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=660;                            % J/kgK  ave heat capacity of module
ess2_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess2_mod_sarea=0.2;                         % m^2    total module surface area exposed to cooling air
ess2_mod_airflow=0.07/12;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess2_mod_flow_area=0.004;                   % m^2    cross-sec flow area for cooling air per module
ess2_mod_case_thk=2/1000;                   % m      thickness of module case
ess2_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material
ess2_air_vel=ess2_mod_airflow/(1.16*ess2_mod_flow_area); % m/s  ave velocity of cooling air
ess2_air_htcoef=30*(ess2_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess2_th_res_on=((1/ess2_air_htcoef)+(ess2_mod_case_thk/ess2_mod_case_th_cond))/ess2_mod_sarea; % K/W  tot thermal res key on
ess2_th_res_off=((1/4)+(ess2_mod_case_thk/ess2_mod_case_th_cond))/ess2_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess2_mod_airflow=max(ess2_mod_airflow,0.001);
ess2_th_res_on=min(ess2_th_res_on,ess2_th_res_off);
clear ess2_mod_sarea ess2_mod_flow_area ess2_mod_case_thk ess2_mod_case_th_cond ess2_air_vel ess2_air_htcoef

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_module_mass=4.785;  % (kg), mass of a single ~12 V module

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 12/15/98  file created by DJR
% 3/15/99: vhj adjusted numbers due to additional test data (peukert, Voc, and Rchg,Rdis)
% 3/15/99: vhj added thermal model variables
% 8/5/99:ss deleted all peukert coefficient and data(no longer needed in advisor model) 
%           added limits 'ess2_max_volt' and 'ess2_min_volt'
%9/9/99: vhj changed variables to include thermal modeling (matrices, not vector), added ess2_tmp

% 11/03/99:ss updated version from 2.2 to 2.21
% 7/30/01:tm added user defineable scaling functions for mass=f(ess2_module_num,ess2_cap_scale,ess2_module_mass) 
%            and resistance=f(ess2_module_num,ess2_cap_scale)*base_resistance