% ADVISOR data file:  ESS_IDEAL.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% These parameters describe a IDEAL battery system.  
% It's purpose is to allow the user to evaluate the 
% performance of a vehicle with a 100% efficient battery system.
% All ess parameters in this file are based on the ESS_PB25 data file.
%
% Created on: 12/20/00
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Ideal 100% Efficient Battery';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_Ideal - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0:.1:1];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[
   25
   25
   25
];	% (A*h), max. capacity at C/5 rate, indexed by ess2_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess2_tmp
%ess2_coulombic_eff=[
%   .9
%   .9
%   .9
%];  % (--);
% added 12/20/00:tm
ess2_coulombic_eff=[
   1
   1
   1
];  % (--);
% end added 12/20/00:tm
% module's resistance to being discharged, indexed by ess2_soc and ess2_tmp
ess2_r_dis=[
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
   40.7 37.0 33.8 26.9 19.3 15.1 13.1 12.3 11.7 11.8 12.2
]/1000*10e-10; % (ohm)
% added *10e-10 12/20/00:tm
% module's resistance to being charged, indexed by ess2_soc and ess2_tmp
ess2_r_chg=[
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
   31.6 29.8 29.5 28.7 28.0 26.9 23.1 25.0 26.1 28.8 47.2
]/1000*10e-10; % (ohm)
% added *10e-10 12/20/00:tm
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess2_soc and ess2_tmp
ess2_voc=[
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
   11.70 11.85 11.96 12.11 12.26 12.37 12.48 12.59 12.67 12.78 12.89
]; % (V)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=9.5;
ess2_max_volts=16.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_module_mass=11;  % (kg), mass of a single ~12 V module

ess2_module_num=25;  %a default value for number of modules

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess2_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess2_res_scale_fun


% battery thermal model
ess2_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=660;                            % J/kgK  ave heat capacity of module
ess2_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess2_mod_sarea=0.2;                         % m^2    total module surface area exposed to cooling air
ess2_mod_airflow=0.07/5;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess2_mod_flow_area=0.0025;                  % m^2    cross-sec flow area for cooling air per module (10-mm gap btwn mods)
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
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12/20/00:tm file created based on ess2_pb25
%
% 7/30/01:tm added user defineable scaling functions for mass=f(ess2_module_num,ess2_cap_scale,ess2_module_mass) 
%            and resistance=f(ess2_module_num,ess2_cap_scale)*base_resistance