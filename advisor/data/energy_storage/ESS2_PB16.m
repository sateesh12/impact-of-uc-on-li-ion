% ADVISOR data file:  ESS_PB16.m
%
% Data source: 
%
% Data confirmation: 
%
% Notes:
% File created by batmodel using mat files: ;
% Hawker25_0900;
% ;
%  File notes for Hawker25_0900;
%   peukert.batname: Hawker Genesis 16AH spiral wound lead acid from VT;
%   peukert.batnum: Model # - G12V16AH10EP, Serial # -  0769-2007 9036W;
%   peukert.testdate: 5/00;
%   peukert.testdescription: residual & C rate capacity tests;
%   peukert.testscript: hawker16AHCharge.scr, hawker16AHcycle.scr, hawker16AHcycleAndResiduleCapacity.scr;
%   peukert.percentage_error: 9.9651;
%   VOC.batname: Hawker Genesis 16AH spiral wound lead acid from Virginia Tech;
%   VOC.batnum: ;
%   VOC.testdate: 5-6/00;
%   VOC.testdescription: OCV tests;
%   VOC.testscript: Hawker16AHVocSoc.SCR;
%   VOC.percentage_error: 0.60627;
%   Rint.batname: Hawker Genesis 16AH spiral wound lead acid from VT;
%   Rint.batnum: ;
%   Rint.testdate: 6/00;
%   Rint.testdescription: Rint tests;
%   Rint.testscript: Hawker16AHAdvisorRdchrgChrg.SCR, Hawker16AHAdvisorRdchrgChrgMultiTest.SCR,  HawkerAdvisor16AHRdchrgChrgMultiTest.SCR
%
% Created on: 10-Jan-2001 16:06:04
% By: Valerie Johnson, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%
% Model # - G12V16AH10EP
% Serial # -  0769-2007 9036W
% Dimensions (Length, Width, Height (mm)) 181.61, 76.33, 167.77
% ABC-150 Script Files:	Hawker16AHAdvisorRdchrgChrg.SCR
%			Hawker16AHAdvisorRdchrgChrgMultiTest.SCR
%			hawker16AHCharge.scr
%			hawker16AHcycle.scr
%			hawker16AHcycleAndResiduleCapacity.scr
%			Hawker16AHVocSoc.SCR
%			HawkerAdvisor16AHRdchrgChrgMultiTest.SCR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='16 Ah Hawker Genesis Lead Acid battery, tested at NREL'; 
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_PB16.m - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0 10 20 40 60 80 100]/100;  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[23 24];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[17.9 17.9];
	% (A*h), max. capacity at C/3 rate, indexed by ess2_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess2_tmp
ess2_coulombic_eff=[0.8 0.8];  % (--)
% module's resistance to being discharged, indexed by ess2_soc and ess2_tmp
ess2_r_dis=[0.065 0.0503 0.0413 0.0322 0.031 0.0332 0.05;
0.065 0.0503 0.0413 0.0322 0.031 0.0332 0.05]*1; % (ohm)
% module's resistance to being charged, indexed by ess2_soc and ess2_tmp
ess2_r_chg=[0.08 0.0659 0.0512 0.0508 0.0688 0.0838 0.12;
0.08 0.0659 0.0512 0.0508 0.0688 0.0838 0.12]*1; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess2_soc and ess2_tmp
ess2_voc=[11.57 11.77 11.93 12.26 12.57 12.81 13.35;
11.57 11.77 11.93 12.26 12.57 12.81 13.35]*1; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=10.3; 
ess2_max_volts=14.85; 


% battery thermal model
ess2_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess2_mod_cp=666;                             % J/kgK  ave heat capacity of module
ess2_set_tmp=35;                             % C      thermostat temp of module when cooling fan comes on
ess2_mod_sarea=0.0256;                          % m^2    total module surface area exposed to cooling air
ess2_mod_airflow=.07/7;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess2_mod_flow_area=.00024;                   % m^2    cross-sec flow area for cooling air per module
ess2_mod_case_thk=.002;                   % m      thickness of module case
ess2_mod_case_th_cond=.20;                 % W/mK   thermal conductivity of module case material, plastic
%calculations
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
ess2_module_mass=6.313;  % (kg), mass of single module

ess2_module_num=25;  %a default value for number of modules

ess2_cap_scale=1; % scale factor for module max ah capacity

% user definable mass scaling relationship 
ess2_mass_scale_fun=inline('(x(1)*ess2_module_num+x(2))*(x(3)*ess2_cap_scale+x(4))*(ess2_module_mass)','x','ess2_module_num','ess2_cap_scale','ess2_module_mass');
ess2_mass_scale_coef=[1 0 1 0]; % coefficients in ess2_mass_scale_fun

% user definable resistance scaling relationship
ess2_res_scale_fun=inline('(x(1)*ess2_module_num+x(2))/(x(3)*ess2_cap_scale+x(4))','x','ess2_module_num','ess2_cap_scale');
ess2_res_scale_coef=[1 0 1 0]; % coefficients in ess2_res_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%10-Jan-2001 16:06:04: file created using batmodel
% 01/10/01: vhj added model, serial #% 01/17/01: vhj updated cp, thermal parameters, mas ah, coulombic eff
% 02/14/01: vhj SOC range 0-1, ess2_tmp needs different temps
% 7/30/01:tm added user defineable scaling functions for mass=f(ess2_module_num,ess2_cap_scale,ess2_module_mass) 
%            and resistance=f(ess2_module_num,ess2_cap_scale)*base_resistance