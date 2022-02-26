% ADVISOR data file:  ESS_LI7_rc_temp.m
%
% Data source: 
%
% Data confirmation: 
%
% Notes:
% File created by batmodel using mat files: ;
% Saft0_rc_Opt_Repeat;
% Saft25_rc_NoOpt_Repeat328N2;
% Saft45_rc_Opt_Repeat;
% ;
%  File notes for Saft0_rc_Opt_Repeat;
%   VOC.batname: Saft 6Ah Li-Ion;
%   VOC.batnum: 72;
%   VOC.testdate: 7/99;
%   VOC.testdescription: VOC 0C;
%   VOC.testscript: VOC0C;
%   VOC.percentage_error: 0.044666;
%   RC.batname: Saft 6Ah Li-Ion;
%   RC.batnum: 72;
%   RC.testdate: 4/2001;
%   RC.testdescription: ;
%   RC.testscript: ;
%   RC.AvgPerror: 0.22357     0.24471    0.097553    0.044403    0.057818     0.10891     0.20309     0.39552     0.89869;
%   RC.MaxPerror: 0.73308     0.80372     0.42567     0.34318     0.55253     0.42168      1.1237      1.8402      3.7883;
% ;
%  File notes for Saft25_rc_NoOpt_Repeat328N2;
%   VOC.batname: Saft 6 Ah Li-Ion cell, 20 C tests;
%   VOC.batnum: 72;
%   VOC.testdate: 5/99;
%   VOC.testdescription: VOC tests, 20C;
%   VOC.testscript: VOC;
%   VOC.percentage_error: 0.069566;
%   RC.batname: Saft 6 Ah Li-Ion cell, 20 C tests;
%   RC.batnum: 72;
%   RC.testdate: 3/01;
%   RC.testdescription: HPPC tests;
%   RC.testscript: ;
%   RC.AvgPerror: 0.44175     0.50633     0.28388     0.21622     0.26551     0.30639     0.27164     0.45326       1.111;
%   RC.MaxPerror: 0.97588      1.0117     0.70114     0.68612     0.83928      0.9174      1.0527      2.0507      4.7604;
% ;
%  File notes for Saft45_rc_Opt_Repeat;
%   VOC.batname: Saft 6Ah Li-Ion;
%   VOC.batnum: 72;
%   VOC.testdate: 7/99;
%   VOC.testdescription: VOC tests at 40C;
%   VOC.testscript: VOC40C;
%   VOC.percentage_error: 0.083493;
%   RC.batname: Saft 6Ah Li-Ion;
%   RC.batnum: 72;
%   RC.testdate: 4/2001;
%   RC.testdescription: ;
%   RC.testscript: ;
%   RC.AvgPerror: 0.2866     0.37214     0.15618     0.13411     0.16109     0.15797    0.092631     0.20004      1.4915;
%   RC.MaxPerror: 0.77495     0.80084     0.57326     0.55536     0.62038     0.56159     0.55161     0.87251      5.4606
%
% Created on: 30-May-2001 10:01:00
% By: VHJ, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='7 Ah Saft Lithium Ion battery'; 
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_LI7_rc_temp.m - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 1];  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[1 25 45];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RC Model Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cb, indexed by ess_tmp
ess_cb=[4.736e+004 3.606e+004 2.924e+004]; 
% Cc, indexed by ess_tmp
ess_cc=[2165 5291 8004]; 
% Re, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_re=[0.018 0.01432 0.0133 0.01228 0.01146 0.01081 0.01042 0.01027 0.01027 0.01036 0.01066 0.01108 0.01158 0.01205 0.014;
0.004178 0.004178 0.004178 0.004178 0.003769 0.003517 0.003296 0.003222 0.003173 0.003197 0.0033 0.003483 0.003732 0.00398 0.00398;
0.01 0.004661 0.002906 0.002185 0.002137 0.002089 0.002023 0.001956 0.001946 0.001946 0.001981 0.002052 0.002147 0.002239 0.0025]; 
% Rc, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_rc=[0.006 0.004246 0.003938 0.003515 0.003244 0.003094 0.003001 0.002956 0.002958 0.002982 0.003021 0.003119 0.003259 0.003392 0.0045;
0.001393 0.001393 0.001393 0.001393 0.001256 0.001172 0.001099 0.001074 0.001058 0.001066 0.0011 0.001161 0.001244 0.001327 0.001327;
0.004 0.001312 0.000818 0.000723 0.000654 0.000589 0.000605 0.000621 0.000635 0.000649 0.000642 0.000637 0.000633 0.00063 0.00064]; 
% Rt, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_rt=[0.016 0.01277 0.01186 0.01095 0.01022 0.009637 0.009295 0.009155 0.00916 0.009235 0.009505 0.009881 0.01033 0.01075 0.013;
0.0038 0.0038 0.0038 0.0038 0.003427 0.003198 0.002997 0.00293 0.002886 0.002907 0.003001 0.003167 0.003394 0.00362 0.00362;
0.009 0.004156 0.002591 0.001948 0.001906 0.001863 0.001804 0.001744 0.001735 0.001735 0.001766 0.00183 0.001914 0.001997 0.0023]; 
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[3.44 3.496 3.514 3.532 3.55 3.568 3.585 3.602 3.62 3.637 3.667 3.697 3.727 3.757 3.896;
3.124 3.36 3.42 3.479 3.501 3.524 3.547 3.569 3.593 3.616 3.65 3.684 3.72 3.756 3.9;
3.128 3.365 3.425 3.484 3.506 3.528 3.552 3.575 3.599 3.623 3.657 3.692 3.727 3.761 3.899]; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=2; 
ess_max_volts=3.9; 

ess_module_num=1;  %a default value for number of modules

% battery thermal model
ess_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=795;                             % J/kgK  ave heat capacity of module
ess_set_tmp=35;                             % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=0.032;                          % m^2    total module surface area exposed to cooling air
ess_mod_airflow=0.0058333;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area=0.0011;                   % m^2    cross-sec flow area for cooling air per module
ess_mod_case_thk=0.001;                   % m      thickness of module case
ess_mod_case_th_cond=15;                 % W/mK   thermal conductivity of module case material
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001); 
ess_th_res_on=min(ess_th_res_on,ess_th_res_off); 
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=0.37824;  % (kg), mass of single module

ess_cap_scale=1; % scale factor for module max ah capacity (DO NOT MODIFY FOR RC MODEL!)

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%16-Mar-2001 17:26:12: file created using batmodel %03/28/01: vhj updated params for 25C based on new hppc test data
%30-May-2001 10:01:00: file created using batmodel, updated with most recent data 
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
