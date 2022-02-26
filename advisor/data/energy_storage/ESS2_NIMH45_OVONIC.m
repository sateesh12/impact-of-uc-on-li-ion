% ADVISOR data file:  ESS_NIMH45_OVONIC.m 
%
% Data source:
% Ovonic sales data via UC Davis except VOC (from ESS_NIMH93).
%
% Data confirmation:
%
% Notes: These are designed to be a high power, intermediate energy battery.
% Cell type = P127
% Nominal Voltage = 12V
% Nominal Capacity (C/3) = 45Ah
% Dimensions (L * W * H) = 340mm X 74mm X 135mm
% Weight = 8.4kg
% Volume (modules only) = 3.4L
% Nominal Energy (C/3) = 598 Wh
% Peak Power (10s pulse @ 50%DOD @ 35 deg. C) = 3.3kW
% 
% Created on: 3/24/00
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Ovonic 45Ah NiMH HEV battery';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_NIMH45_OVONIC - ',ess2_description])


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
   45
   45
   45
];	% (A*h), max. capacity at C/5 rate, indexed by ess2_tmp

% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess2_tmp
ess2_coulombic_eff=[
   1
   1
   1
]*0.975;  % (--); unknown

% module's resistance to being discharged, indexed by ess2_soc and ess2_tmp
ess2_r_dis=[2.135 1.155	1.086	1.011	0.990	0.970	0.958	0.981	1.050	1.125	1.071
   		  2.135 1.155	1.086	1.011	0.990	0.970	0.958	0.981	1.050	1.125	1.071
           2.135 1.155	1.086	1.011	0.990	0.970	0.958	0.981	1.050	1.125	1.071
        ]*10/1000; % (ohm)
        
% module's resistance to being charged, indexed by ess2_soc and ess2_tmp
ess2_r_chg=ess2_r_dis;% (ohm), no other data available

% module's open-circuit (a.k.a. no-load) voltage, indexed by ess2_soc and ess2_tmp
%ess2_voc=[11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7;
%   11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7;
%   11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7]; % (V), Source: Ovonic Charge-decreasing
ess2_voc=[12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2;
   12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2;
   12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2]; % (V), Source: Ovonic Charge-sustaining
%ess2_voc=[12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6;
%   12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6;
%   12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6]; % (V), Source: Ovonic Charge-increasing


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=0.87*1.05*10; % (V), 0.87*105% safety factor volts time 10 cells
ess2_max_volts=1.65*0.95*10;% (V), 1.65*95% safety factor volts times 10 cells


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_module_mass=8.4;  % (kg), mass of a single ~12 V module
ess2_module_volume=0.340*0.074*0.135; % (m^3), length X width X height
ess2_module_num=25;  %a default value for number of modules

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
%ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess2_mass_scale_fun
ess2_mass_scale_coef=[1 0 0.9832073 0.0160194]; % coefficients in ess2_mass_scale_fun; updated tm:10/22/01 based on Ovonic family

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
%ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess2_res_scale_fun
ess2_res_scale_coef=[1 0 0.8698015 0.1226830]; % coefficients in ess2_res_scale_fun; updated tm:10/22/01 based on Ovonic family

% battery thermal model
ess2_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=830;                            % J/kgK  ave heat capacity of module (estimated for NiMH)
ess2_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess2_area_scale=1.6*(ess2_module_mass/11)^0.7;   % --     if module dimensions are unknown, assume rectang shape and scale vs PB25
%tm:3/24/00 ess2_mod_sarea=0.2*ess2_area_scale;          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess2_mod_sarea=2*(0.340*0.135+0.074*0.135);          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess2_mod_airflow=0.01;                      % kg/s   cooling air mass flow rate across module (20 cfm=0.01 kg/s at 20 C)
%tm:3/24/00 ess2_mod_flow_area=0.005*ess2_area_scale;    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess2_mod_flow_area=0.005*2*(0.340+0.074);    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess2_mod_case_thk=2/1000;                   % m      thickness of module case (typ from Optima)
ess2_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material (typ polyprop plastic - Optima)
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
% 3/24/00:tm file created
% 9/7/00:tm updated OCV data and removed fliplr from charge resistance definition
% 7/30/01:tm added user defineable scaling functions for mass=f(ess2_module_num,ess2_cap_scale,ess2_module_mass) 
%            and resistance=f(ess2_module_num,ess2_cap_scale)*base_resistance
% 10/22/01:tm updated ess2_cap_scale related coefficients in mass and resistance scaling functions based on Ovonic family of modules
