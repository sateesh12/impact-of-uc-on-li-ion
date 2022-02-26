% ADVISOR data file:  ESS_NiMH7_rc_temp.m
%
% Data source: 
%  Data from Testing at NREL Battery Thermal Management Lab. March 2001
% Data confirmation: 
%   Data is consistent with test results.
% Notes:
% File created by batmodel using mat files: ;
% PanasonicPrismHPPCat0C;
% PanasonicPrismHPPCat25C;
% PanasonicPrismHPPCat40C;
% ;
%  File notes for PanasonicPrismHPPCat0C;
%   VOC.batname: Panasonic Prismatic 6.5Ah;
%   VOC.batnum: 2;
%   VOC.testdate: 02/14/01;
%   VOC.testdescription: OCV tests;
%   VOC.testscript: HPPConBitrode;
%   VOC.percentage_error: NaN;
%   RC.batname: Panasonic Prismatic 6.5Ah;
%   RC.batnum: 2;
%   RC.testdate: 02/15/01;
%   RC.testdescription: PNGV HPPC test;
%   RC.testscript: HPPC;
%   RC.AvgPerror: 1.1463     0.77611     0.69573     0.59525     0.61003     0.80419      0.9631      1.2252      1.8106     0.71828     0.82028     0.86926     0.96185      1.1323     0.75824     0.91912      1.0274;
%   RC.MaxPerror: 2.9468       2.888      2.6988      2.0424      1.3671       2.236      2.8476      3.1726      3.3388      1.6726      3.6413       3.007      3.2166      3.9544      1.8956      4.0745      3.3974;
% ;
%  File notes for PanasonicPrismHPPCat25C;
%   VOC.batname: Panasonic Prismatic 6.5Ah;
%   VOC.batnum: 2;
%   VOC.testdate: 02/01/01;
%   VOC.testdescription: OCV tests;
%   VOC.testscript: HPPConBitrode;
%   VOC.percentage_error: NaN;
%   RC.batname: Panasonic Prismatic 6.5Ah;
%   RC.batnum: 2;
%   RC.testdate: 02/08/01;
%   RC.testdescription: PNGV HPPC tests;
%   RC.testscript: HPPC;
%   RC.AvgPerror: 0.9073     0.70747     0.78274     0.95543      1.2257      1.4139     0.71087     0.74781     0.98684      1.2769     0.67592     0.83672      1.0701;
%   RC.MaxPerror: 2.4301      2.6245      1.4205      2.4342       2.732      3.4371      3.2224      2.4973      2.9873      4.0677      3.4239      3.5951      4.0284;
% ;
%  File notes for PanasonicPrismHPPCat40C;
%   VOC.batname: Panasonic Prismatic 6.5Ah;
%   VOC.batnum: 2;
%   VOC.testdate: 03/01/01;
%   VOC.testdescription: OCV tests;
%   VOC.testscript: HPPConBitrode;
%   VOC.percentage_error: NaN;
%   RC.batname: Panasonic Prismatic 6.5Ah;
%   RC.batnum: 2;
%   RC.testdate: 03/07/01;
%   RC.testdescription: PNGV HPPC test;
%   RC.testscript: HPPC;
%   RC.AvgPerror: 1.0601     0.72981     0.65068       0.742     0.84376       1.045      1.3217      1.7266      2.7032     0.35777     0.44208     0.58794     0.88644      1.3019     0.39012     0.50534     0.80572;
%   RC.MaxPerror: 2.424      2.4607      1.1611      2.4774      2.1761      2.3162      3.0848      2.3961      7.2185     0.97376      2.7902      2.4071      2.6981      4.1206      2.9646      2.3638      1.9922
%
% Created on: 27-Mar-2001 15:15:17
% By: Matthew Zolot
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='6.5 Ah Prismatic Panasonic NiMH battery'; 
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_NiMH7_rc_temp.m - ',ess_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 1];  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[1 26 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RC Model Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cb, indexed by ess_tmp
ess_cb=[1.845e+004 1.846e+004 1.975e+004]; 
% Cc, indexed by ess_tmp
ess_cc=[504.5 975 1249]; 
% Re, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_re=[0.022 0.01923 0.01908 0.01908 0.01845 0.01877 0.01905 0.01824 0.01936 0.01989 0.02002 0.02015 0.01909 0.02052 0.02118;
0.0107 0.0102 0.01002 0.009866 0.009749 0.009746 0.00964 0.009488 0.009512 0.009435 0.009459 0.009439 0.009232 0.00975 0.01025;
0.0128 0.008022 0.007799 0.007576 0.00779 0.007506 0.007664 0.007428 0.007527 0.007508 0.00742 0.007344 0.00728 0.007279 0.007579]; 
% Rc, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_rc=[0.0091 0.008117 0.008052 0.008052 0.007789 0.007923 0.008041 0.007699 0.00817 0.008398 0.008452 0.008506 0.00806 0.00871 0.0089;
0.0044 0.00428 0.00423 0.004165 0.004115 0.004114 0.004069 0.004005 0.004015 0.004005 0.004005 0.004006 0.00397 0.004129 0.0042;
0.0052 0.003386 0.003292 0.00328 0.003288 0.003168 0.003235 0.003135 0.003177 0.003169 0.003132 0.0031 0.003108 0.003085 0.0032]; 
% Rt, varies by SOC horizontally, and temperature vertically
% indexed by ess_tmp and ess_soc
ess_rt=[0.0216 0.01885 0.0187 0.0187 0.01809 0.0184 0.01868 0.01789 0.01898 0.01951 0.01963 0.01976 0.01872 0.02012 0.0208;
0.0105 0.01 0.009826 0.009674 0.009559 0.009557 0.009453 0.009304 0.009327 0.00925 0.009273 0.009253 0.009052 0.009491 0.00971;
0.0124 0.007866 0.007647 0.007429 0.007638 0.007359 0.007515 0.007283 0.007381 0.007362 0.007276 0.007201 0.007138 0.007138 0.007438]; 
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[7.33 7.72 7.765 7.811 7.842 7.874 7.89 7.907 7.918 7.928 7.934 7.939 7.97 8 8.62;
7.27 7.656 7.712 7.768 7.806 7.843 7.865 7.886 7.898 7.91 7.919 7.928 7.952 7.975 8.56;
7.25 7.68 7.725 7.77 7.802 7.834 7.857 7.88 7.891 7.902 7.911 7.92 7.935 7.95 8.45]; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=6; 
ess_max_volts=9; 

ess_module_num=1;  %a default value for number of modules

% battery thermal model
ess_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=974;                             % J/kgK  ave heat capacity of module
ess_set_tmp=40;                             % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=0.0378;                          % m^2    total module surface area exposed to cooling air
ess_mod_airflow=0.01;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area=0.0024;                   % m^2    cross-sec flow area for cooling air per module
ess_mod_case_thk=0.0001;                   % m      thickness of module case
ess_mod_case_th_cond=0.2;                 % W/mK   thermal conductivity of module case material
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
ess_module_mass=1;  % (kg), mass of single module

ess_cap_scale=1; % scale factor for module max ah capacity (DO NOT MODIFY FOR RC MODEL!)

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%27-Mar-2001 15:15:17: file created using batmodel 
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass)