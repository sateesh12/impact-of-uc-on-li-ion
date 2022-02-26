% ADVISOR data file:  ESS2_ULTCAP2.m
%
% Data source:
% Burke, A.F., and E. Blank, "Electric/Hybrid Transit Buses Using
% Ultracapacitors," Electric Transportation Systems Compatibility, September
% 1995.  
%
% Data confirmation:
%
% Notes:
% Device delivers 2.5 kW/kg and 6 Wh/kg (not including packaging)
% 
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Maxwell ultracapitor, data from Burke, 1995';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS2_ULTCAP2 - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0 1];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[
   2.1
   2.1
   2.1
];	% (A*h), max. capacity, indexed by ess_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess2_coulombic_eff=[
   .99
   .99
   .99
];  % (--);
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess2_r_dis=[
   0.000206 0.000206
   0.000206 0.000206
   0.000206 0.000206
]; % (ohm)
% module's resistance to being charged, indexed by ess_soc
ess2_r_chg=ess2_r_dis; % (ohm); no other data available
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess2_voc=[
   0.5 3
   0.5 3
   0.5 3
]; % (V)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=1;
ess2_max_volts=3.0001;%ess_voc(end)+ess_max_ah_cap/5*ess_r_chg(end);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_module_mass=0.408;  % (kg), mass of a single module
ess2_module_num=25;  %a default value for number of modules

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun

% battery thermal model
ess2_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=1000;                           % J/kgK  ave heat capacity of module (estimate)
ess2_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess2_area_scale=10*(ess2_module_mass/11)^0.7;   % --     if module dimensions are unknown, assume rectang shape and scale vs PB25
ess2_mod_sarea=0.2*ess2_area_scale;          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess2_mod_airflow=0.01;                      % kg/s   cooling air mass flow rate across module (20 cfm=0.01 kg/s at 20 C)
ess2_mod_flow_area=0.005*ess2_area_scale;    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess2_mod_case_thk=1/1000;                   % m      thickness of module case (typ from Optima)
ess2_mod_case_th_cond=10;                 % W/mK   thermal conductivity of module case material (typ polyprop plastic - Optima)
ess2_air_vel=ess2_mod_airflow/(1.16*ess2_mod_flow_area); % m/s  ave velocity of cooling air
ess2_air_htcoef=30*(ess2_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess2_th_res_on=((1/ess2_air_htcoef)+(ess2_mod_case_thk/ess2_mod_case_th_cond))/ess2_mod_sarea; % K/W  tot thermal res key on
ess2_th_res_off=((1/4)+(ess2_mod_case_thk/ess2_mod_case_th_cond))/ess2_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess2_mod_airflow=max(ess2_mod_airflow,0.001);
ess2_th_res_on=min(ess2_th_res_on,ess2_th_res_off);
clear ess2_mod_sarea ess2_mod_flow_area ess2_mod_case_thk ess2_mod_case_th_cond ess2_air_vel ess2_air_htcoef ess2_area_scale



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6/30/98 (MC): converted from E_MAXWEL.M
% 02/03/99 (SDB):  added thermal model inputs
% 2/4/99 ss: added ess_module_num=25;
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 8/5/99:ss deleted all peukert coefficient and data(no longer needed in advisor model) 
%           added limits 'ess_max_volt' and 'ess_min_volt'
%9/9/99: vhj changed variables to include thermal modeling (matrices, not vector), added ess_tmp
% 11/03/99:ss updated version from 2.2 to 2.21
% 11/18/99:tm changed the ess_min_volts setting from 0 to 1 to prevent errors when attempting to autosize vehicle
% 11/18/99:tm changed the ess_voc(:,1) for 0 to 0.5 to prevent a current limited condition during grade and accel tests

% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance
