% ADVISOR data file:  template_name
%
% Data source: 
%
% Data confirmation: 
%
% Notes:
% template_notes
%
% Created on: template_date
% By: template_createdby
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='template_description'; 
ess_version=template_version; % version of ADVISOR for which the file was generated
ess_proprietary=template_proprietary; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=template_validation; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: template_name - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=template_soc;  % (--)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=template_tmp;  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically
ess_max_ah_cap=template_max_ah_cap;	% (A*h), max. capacity at C/3 rate, indexed by ess_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess_coulombic_eff=template_coulombic_eff;  % (--)
% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess_r_dis=template_r_dis*templatenum_cells_per_mod; % (ohm)
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess_r_chg=template_r_chg*templatenum_cells_per_mod; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=template_voc*templatenum_cells_per_mod; % (V)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=template_min_volts; 
ess_max_volts=template_max_volts; 

ess_module_num=template_module_num;  %a default value for number of modules

% battery thermal model
ess_th_calc=1;                              % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=template_mod_cp;                             % J/kgK  ave heat capacity of module
ess_set_tmp=template_set_tmp;                             % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=template_mod_sarea;                          % m^2    total module surface area exposed to cooling air
ess_mod_airflow=template_mod_airflow;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area=template_mod_flow_area;                   % m^2    cross-sec flow area for cooling air per module
ess_mod_case_thk=template_mod_case_thk;                   % m      thickness of module case
ess_mod_case_th_cond=template_mod_case_th_cond;                 % W/mK   thermal conductivity of module case material
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
ess_module_mass=template_module_mass;  % (kg), mass of single module

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%template_date: file created using batmodel 
