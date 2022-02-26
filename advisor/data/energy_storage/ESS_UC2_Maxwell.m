% ADVISOR data file:  ESS_UC2_Maxwell_temp.m
%
% Data source:
% Testing at NREL's Battery Thermal Management Testing facility.
%
% Data confirmation:
%
% Notes:
% These parameters describe the Maxwell PC2500 Ultracapacitor.
% 
% Created on: 11/01/01
% By:  Tony Markel and Matt Zolot, NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Maxwell PC2500 Ultracapacitor, tested at NREL';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_UC2_Maxwell_temp - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0:.1:1];  % (--) % not used in model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[0 25 40];  % (C) % from test data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Current range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_i=[-225 -112.5 -56.3 56.3 112.5 225];  % (C) indexes internal resistance data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp (row) and ess_i (col)
ess_coulombic_eff=[
  0.999314173  0.997716624  0.99587234  0.99587234  0.997716624  0.999314173
  0.998253057  0.996273292  0.990403543  0.990403543  0.996273292  0.998253057
  0.996265099  0.99481399  0.993372248  0.993372248  0.99481399  0.996265099];  % (--); from test data

% module's resistance, indexed by ess_i and ess_tmp
ess_r=[
1.069875807 1.087405437 1.070653345 1.182119597 1.173837037 1.112844444
0.899258511 0.905140252 0.933984606 0.951746596 0.917274074 0.889874074
0.860493585 0.867654311 0.879218769 0.866903493 0.845688889 0.831237037]/1000; % (ohm) from test data

 % module's capacitance, indexed by ess_i and ess_tmp
ess_cap=[
  2844.00  2871.00  2908.36  2896.30  2864.20  2842.00
  2885.00  2899.00  2926.08  2898.00  2887.20  2880.00
  2900.50  2906.40  2908.80  2889.50  2891.40  2889.60]; % (Farads) from test data

%ess_voc=[1.25:((2.5-1.25)/10):2.5;1.25:((2.5-1.25)/10):2.5;1.25:((2.5-1.25)/10):2.5];   %use eps instead of 1.25 so voltage range can be set by SOC range
ess_voc=[eps:((2.5-eps)/10):2.5;eps:((2.5-eps)/10):2.5;eps:((2.5-eps)/10):2.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ess_min_volts=0.01; % for comparison to test data
ess_min_volts=0.00; % common practice is 50% of max through controls, but should be set to this by setting SOC range to 0.5 to 1.0
ess_max_volts=2.5; % from manufacturer recommendations
%Vw=2.5; % working voltage from manufacturer recommendations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=0.71;  % (kg), mass of a single 2.5 V cell

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

% user definable resistance scaling relationship
ess_res_scale_fun=inline('(x(1)*ess_module_num+x(2))/(x(3)*ess_cap_scale+x(4))','x','ess_module_num','ess_cap_scale');
ess_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun

ess_module_num=1;  % a default value for number of modules
ess_parallel_mod_num=1; % a default value for number of modules placed in parallel, model treats ideally as a higher capacitance ultracap.
ess_cap_scale=1; % scale factor for module max ah capacity

% battery thermal model
ess_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=(1471.3+1614.6)/2;              % J/kgK  ave heat capacity of module (40 to 25C, and 10 to 25C)
ess_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=((61.5+61.5)*2*161)/1000000; % m^2    total module surface area exposed to cooling air ((width*depth)*2*height) from spec sheet
ess_mod_airflow=0.07/5;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area= ((12.5+61.5)^2-(61.5)^2)/1000000; % m^2    cross-sec flow area for cooling air per module (12.5-mm gap btwn mods)
ess_mod_case_thk=2/1000;                   % m      thickness of module case
ess_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material (estimate)
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001);
ess_th_res_on=min(ess_th_res_on,ess_th_res_off);
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef

% for stand-alone debugging, normally defined elsewhere
%ess_on=1;
%mc_min_volts=0;
%ess_init_soc=0.001;
%ess_mod_init_tmp=20;
%cyc_mph=[0 35; 1 35];
%air_cp=1200;
%amb_tmp=20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11/01/01:tm,mz file created from ess_pb25.m
% 02/12/02:mz changed voltage ranges to vary between ess_max_voltage (the UC's working voltage) and eps (0) to allow for use of ultracap between max possible range as opposed to max common practive (Vw to Vw/2)
%             Voltage range should be controlled by limiting SOC range, which directly correlates with SOC (set SOC from 0.5 to 1.0 for Vw/2 to Vw).
% 04/19/02:mz added 'ess_parallel_mod_num' variable for parrallel strings of UCs
% 04/23/02:mz adjusted 'ess_mass_scale_fun' functionality by adding a case for ess_parallel_mod_num in 'recompute_mass.m' inorder to appropriately scale the mass for parallel strings of UC's.
