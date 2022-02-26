% ADVISOR data file:  ESS2_NIZN22_temp.m
%
% Data source: 
%
% Data confirmation: 
%
% Notes:
% File created by batmodel using mat files: ;
% Evercel25;
% Evercel32;
% ;
%  File notes for Evercel25;
%   peukert.batname: Evercel 22AH prismatic NiZn;
%   peukert.batnum: 2;
%   peukert.testdate: 09/14/00;
%   peukert.testdescription: Residual Capacity Test;
%   peukert.testscript: EverCelCellResidualCapacity;
%   peukert.percentage_error: 2.0711e-009;
%   VOC.batname: Evercel 22AH prismatic NiZn;
%   VOC.batnum: 2;
%   VOC.testdate: 09/20/00;
%   VOC.testdescription: VOC vs. SOC test;
%   VOC.testscript: Evercel22AHCellSocVoc;
%   VOC.percentage_error: 0.16459;
%   Rint.batname: Evercel 22AH prismatic NiZn;
%   Rint.batnum: 2;
%   Rint.testdate: 09/00;
%   Rint.testdescription: Rint;
%   Rint.testscript: ;
% ;
%  File notes for Evercel32;
%   peukert.batname: Evercel 22AH prismatic NiZn;
%   peukert.batnum: 3;
%   peukert.testdate: 09/20/00;
%   peukert.testdescription: Residual Capacity Test;
%   peukert.testscript: EverCelCellResidualCapacity;
%   peukert.percentage_error: 7.4579e-010;
%   VOC.batname: Evercel 22AH prismatic NiZn;
%   VOC.batnum: 3;
%   VOC.testdate: 09/20/00;
%   VOC.testdescription: VOC vs. SOC test;
%   VOC.testscript: Evercel22AHCellSocVoc;
%   VOC.percentage_error: 0.11414;
%   Rint.batname: Evercel 22AH prismatic NiZn;
%   Rint.batnum: 3;
%   Rint.testdate: 09/00;
%   Rint.testdescription: ;
%   Rint.testscript: 
%
% Created on: 10-Jan-2001 16:03:00
% By: Valerie Johnson, valerie_johnson@nrel.gov
%
% Testing was on 1/7 of a Module model # 7XNFG22
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='22 Ah Evercel NiZn battery, tested at NREL'; 
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS2_NIZN22_temp.m - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0 10 20 30 40 50 60 70 80 90 100]/100;  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[26 33];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
% (A*h), max. capacity, indexed by ess_tmp
ess2_max_ah_cap=[22.88 22.81];
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess2_coulombic_eff=[0.96 0.99];  % (--)
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess2_r_dis=[0.018 0.0119 0.009 0.0075 0.007 0.0068 0.0067 0.0062 0.0057 0.005 0.0035;
0.018 0.014 0.0119 0.0097 0.0076 0.0074 0.0064 0.0063 0.0054 0.005 0.0048]*7; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess2_r_chg=[0.013 0.012 0.0111 0.0107 0.0104 0.0102 0.0101 0.0099 0.0097 0.0081 0.0083;
0.014 0.0125 0.0116 0.011 0.0105 0.0104 0.01 0.0098 0.0095 0.0083 0.008]*7; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess2_voc=[1.642 1.691 1.72 1.74 1.75 1.755 1.757 1.762 1.768 1.801 1.901;
1.64 1.682 1.714 1.738 1.758 1.76 1.769 1.77 1.779 1.807 1.89]*7; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=0.95*7; %Discharge Rate dependent (=<1C, 1.2 volts / >1C to 2C, 1.05  volts / >2C to 5C, 0.95 volts / >5C to 10C, 0.93 volts )
ess2_max_volts=2.1*7; %Temperature Compensated  (2.3 volts at 0C, 2.1 volts at 25C, 2.07 volts at 32C*) *=NREL derived


ess2_module_num=25;  %a default value for number of modules

% battery thermal model
ess2_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=1175;                             % J/kgK  ave heat capacity of module
ess2_set_tmp=30;                             % C      thermostat temp of module when cooling fan comes on
ess2_mod_sarea=0.0811;                          % m^2    total module surface area exposed to cooling air
ess2_mod_airflow=.07/7;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess2_mod_flow_area=.001;                   % m^2    cross-sec flow area for cooling air per module
ess2_mod_case_thk=.002;                   % m      thickness of module case
ess2_mod_case_th_cond=.20;                 % W/mK   thermal conductivity of module case material, plastic
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
ess2_module_mass=0.9065*7;  % (kg), mass of single module

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess2_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%10-Jan-2001 16:03:00: file created using batmodel %01/17/01: vhj updated max capacity, voltage limits, thermal parameters
%02/08/01: vhj updated file name to include _temp
% 02/14/01: vhj SOC range 0-1
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance