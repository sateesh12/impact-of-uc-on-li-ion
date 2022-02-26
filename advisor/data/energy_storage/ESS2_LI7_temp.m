% ADVISOR data file:  ESS_LI7_temp.m
%
% Data source: 
%
% Data confirmation: 
%
% Notes:
% File created by batmodel using mat files: ;
% Saft0;
% Saft20;
% Saft40;
% ;
%  File notes for Saft0;
%   peukert.batname: Saft 6Ah Li-Ion;
%   peukert.batnum: 72;
%   peukert.testdate: 7/99;
%   peukert.testdescription: peukert capacity tests at 0C;
%   peukert.testscript: peukertSaft;
%   peukert.percentage_error: 1.96;
%   VOC.batname: Saft 6Ah Li-Ion;
%   VOC.batnum: 72;
%   VOC.testdate: 7/99;
%   VOC.testdescription: VOC 0C;
%   VOC.testscript: VOC0C;
%   VOC.percentage_error: 0.044666;
%   Rint.batname: Saft 6Ah Li-Ion;
%   Rint.batnum: 72;
%   Rint.testdate: 7/99;
%   Rint.testdescription: Rint tests at 0C;
%   Rint.testscript: RdischgC, etc;
% ;
%  File notes for Saft20;
%   peukert.batname: Saft 6 Ah Li-Ion cell, 20 C tests;
%   peukert.batnum: 72;
%   peukert.testdate: 5/99;
%   peukert.testdescription: peukert capacity tests;
%   peukert.testscript: peukertSaft;
%   peukert.percentage_error: 1.1574;
%   VOC.batname: Saft 6 Ah Li-Ion cell, 20 C tests;
%   VOC.batnum: 72;
%   VOC.testdate: 5/99;
%   VOC.testdescription: VOC tests, 20C;
%   VOC.testscript: VOC;
%   VOC.percentage_error: 0.069566;
%   Rint.batname: Saft 6 Ah Li-Ion cell, 20 C tests;
%   Rint.batnum: 72;
%   Rint.testdate: 5/99;
%   Rint.testdescription: Rint tests at 20 C;
%   Rint.testscript: RdisC, etc;
% ;
%  File notes for Saft40;
%   peukert.batname: Saft 6Ah Li-Ion;
%   peukert.batnum: 72;
%   peukert.testdate: 7/99;
%   peukert.testdescription: VOC tests at 40 C;
%   peukert.testscript: VOC40C;
%   peukert.percentage_error: 0.94311;
%   VOC.batname: Saft 6Ah Li-Ion;
%   VOC.batnum: 72;
%   VOC.testdate: 7/99;
%   VOC.testdescription: VOC tests at 40C;
%   VOC.testscript: VOC40C;
%   VOC.percentage_error: 0.083493;
%   Rint.batname: Saft 6Ah Li-Ion;
%   Rint.batnum: 72;
%   Rint.testdate: 7/99;
%   Rint.testdescription: Rint tests at 40C;
%   Rint.testscript: RchgdisC40, Rdischg5C40
%
% Created on: 12-Apr-2000 09:14:02
% By: Valerie Johnson, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='6 Ah Saft Lithium Ion battery'; 
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS2_LI7_temp.m - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0 10 20 40 60 80 100]/100;  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[0 25 41];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[5.943 7.035 7.405];
	% (A*h), max. capacity at C/3 rate, indexed by ess2_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess2_coulombic_eff=[0.968 0.99 0.992];  % (--)
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess2_r_dis=[0.0419 0.0288 0.0221 0.014 0.0145 0.0145 0.0162;
0.072 0.01515 0.00839 0.00493 0.00505 0.005524 0.005722;
0.0535 0.0133 0.0082 0.0059 0.0059 0.006 0.0063]*3; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess2_r_chg=[0.021 0.018 0.0177 0.0157 0.0138 0.0138 0.015;
0.0124 0.0068 0.005426 0.00442 0.00463 0.00583 0.00583;
0.0104 0.0079 0.0072 0.0064 0.0059 0.0058 0.006]*3; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess2_voc=[3.44 3.473 3.496 3.568 3.637 3.757 3.896;
3.124 3.349 3.433 3.518 3.616 3.752 3.898;
3.128 3.36 3.44 3.528 3.623 3.761 3.899]*3; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=2*3; 
ess2_max_volts=3.9*3; 

ess2_module_num=25;  %a default value for number of modules

% battery thermal model
ess2_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=795;                             % J/kgK  ave heat capacity of module
ess2_set_tmp=35;                             % C      thermostat temp of module when cooling fan comes on
ess2_mod_sarea=.032;                          % m^2    total module surface area exposed to cooling air
ess2_mod_airflow=.07/12;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess2_mod_flow_area=.0011;                   % m^2    cross-sec flow area for cooling air per module
ess2_mod_case_thk=.001;                   % m      thickness of module case
ess2_mod_case_th_cond=15;                 % W/mK   thermal conductivity of module case material
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
ess2_module_mass=.37824*3;  % (kg), mass of single module

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%12-Apr-2000 09:14:02: file created using batmodel 
%05/30/00: vhj file non-proprietary (released by Saft)%02/08/01: vhj updated file name to include _temp
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
%            and resistance=f(ess_module_num,ess_cap_scale)*base_resistance