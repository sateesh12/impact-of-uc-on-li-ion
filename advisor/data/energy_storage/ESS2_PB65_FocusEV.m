% ADVISOR data file:  ESS_PB65_FocusEV.m
%
% Data source:  Brian Andonian (bandoman@umich.edu)  
% Manufacturer: Optima Batteries, Deep Cycle, Yellow Top
%
% Data confirmation:None
%
% Notes:
% This is a draft file, based on the Advisor model of the Optima Spiral wound battery
% %
% %
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_description='Optima spiral-wound VRLA prototype battery D750S - draft file';
ess2_version=2003; % version of ADVISOR for which the file was generated
ess2_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess2_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
% note: this data requires additional verification of performance over full SOC range.
% data is shown to correlate reasonably well in SOC range of 0.6 to 0.7.
disp(['Data loaded: ESS_PB65_FocusEV - ',ess2_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_soc=[0:.2:1];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE THAT THIS INCLUDES ELECTROCHEMICAL COMPONENTS
% DATA IS TAKEN IN A ROUGHLY 25degC to 30degC range
% Parameters vary by SOC horizontally, and temperature vertically
ess2_max_ah_cap=[
   55
   55
   55
];	% (A*h), max. capacity at C/5 rate, indexed by ess2_tmp
% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess2_tmp
ess2_coulombic_eff=[
   .85
   .85
   .85
];  % (--);
% module's resistance to being discharged, indexed by ess2_soc and ess2_tmp
% NOTE: the data below is a guess, based on Internal Resistance fully charged (0.0028)
ess2_r_dis=[
   0.090 0.030 0.020 0.010 0.005 0.0028
   0.090 0.030 0.020 0.010 0.005 0.0028
   0.090 0.030 0.020 0.010 0.005 0.0028
]; % (ohm)

% module's resistance to being charged, indexed by ess2_soc and ess2_tmp
% changed the high soc charge values to match results where good data unavailable
ess2_r_chg=[
   0.018 0.025 0.044 0.050 0.100 0.250
   0.018 0.025 0.044 0.050 0.100 0.250
   0.018 0.025 0.044 0.050 0.100 0.250
]; % (ohm)
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess2_soc and ess2_tmp
ess2_voc=[
   11.8 12.2 12.5 12.8 13.05 13.2
   11.8 12.2 12.5 12.8 13.05 13.2
   11.8 12.2 12.5 12.8 13.05 13.2
]; % (V)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_min_volts=9.5;
ess2_max_volts=16.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_module_mass=19.490;                     % (kg),  mass of a single ~12 V module

ess2_module_num=28;  %a default value for number of modules

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
ess2_mod_sarea=0.4;                         % m^2    total module surface area exposed to cooling air
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
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/17/98 (DJR): file created from ess2_gnb.m
%
% 8/17/98 (DJR): the resistance data at this point is only from 10A pulse tests
%
% 9/1/98 (DJR): the resistance data is now from 50A and 100A tests
%
% 9/11/98 (DJR): high SOC charge resistance values adjusted to follow fuds data
%                coulombic efficiency set to 85% to reflect test results
% 10/19/98 (ss,kw): Renamed to match c/5 rating, included with main advisor release.  
%					ess2_max_ah_cap was 16.5 Ah C/20 rating and is now a calculation to get C/5 rating
% 02/09/99 (SDB):  added thermal model inputs
% 2/4/99 ss: added ess2_module_num=25;
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 8/5/99:ss deleted all peukert coefficient and data(no longer needed in advisor model) 
%           added limits 'ess2_max_volt' and 'ess2_min_volt'
%9/9/99: vhj changed variables to include thermal modeling (matrices, not vector), added ess2_tmp
% 11/03/99:ss updated version from 2.2 to 2.21
% 4/02/01:  bja modified for ece546 class project, changed amp-hour and Rint.
% 8/15/01: mpo updated file for ADVISOR 3.2