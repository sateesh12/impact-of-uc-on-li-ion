% ADVISOR data file:  ESS_AnnexVII_SerHyb_NIMH28_OVONIC.m 
%
% Data source:
% Dennis Corrigan, Vice President of EV Battery Systems, Ovonic
%
% Data confirmation:
% Data provided by manufacturer.
%
% Notes: These are designed to be a high power, intermediate energy battery.
% Cell type = M70
% Nominal Voltage = 6V
% Nominal Capacity (C/3) = 28Ah
% Dimensions (L * W * H) = 195mm X 102mm X 81mm
% Weight = 3.6kg
% Volume (modules only) = 1.6L
% Nominal Energy (C/3) = 175 Wh
% Peak Power (10s pulse @ 50%DOD @ 35 deg. C) = 1.6kW
% 
% Created on: 4/7/00
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Ovonic 28Ah NiMH HEV battery';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_AnnexVII_SerHyb_NIMH28_OVONIC.m - ',ess_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOC RANGE over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_soc=[0:.1:1];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature range over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tmp=[0 22 40];  % (C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS AND EFFICIENCY parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters vary by SOC horizontally, and temperature vertically

ess_max_ah_cap=[
   28
   28
   28
];	% (A*h), max. capacity at C/5 rate, indexed by ess_tmp

% average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
ess_coulombic_eff=[
   1
   1
   1
]*0.99;  % (--); 

% module's resistance to being discharged, indexed by ess_soc and ess_tmp
ess_r_dis=[0.01266 0.00685	0.00644	0.00599	0.00587	0.00575	0.00568	0.00581	0.00623	0.00667  0.00635
   		  0.01266 0.00685	0.00644	0.00599	0.00587	0.00575	0.00568	0.00581	0.00623	0.00667  0.00635
           0.01266 0.00685	0.00644	0.00599	0.00587	0.00575	0.00568	0.00581	0.00623	0.00667  0.00635
        ]; % (ohm)
        
% module's resistance to being charged, indexed by ess_soc and ess_tmp
ess_r_chg=ess_r_dis;% (ohm), no other data available

% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
%ess_voc=[11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7;
%   11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7;
%   11.9 12.3 12.6 12.8 12.9 12.9 13 13.1 13.2 13.4 13.7]/10*5; % (V), Source: Ovonic Charge-decreasing
ess_voc=[12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2;
   12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2;
   12.5 12.8 13.1 13.3 13.4 13.4 13.5 13.6 13.7 13.9 14.2]/10*5; % (V), Source: Ovonic Charge-sustaining
%ess_voc=[12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6;
%   12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6;
%   12.8 13.2 13.5 13.7 13.8 13.8 13.9 14 14.1 14.3 14.6]/10*5; % (V), Source: Ovonic Charge-increasing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_min_volts=0.87*1.05*5; % (V), 0.87*105% safety factor volts time 5 cells
ess_max_volts=1.65*0.95*5;% (V), 1.65*95% safety factor volts times 5 cells



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_module_mass=3.6;  % (kg), mass of a single ~6 V module 
ess_module_volume=0.195*0.102*0.81; % (m^3), length X width X height
ess_module_num=65;  %a default value for number of modules

% battery thermal model
ess_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=830;                            % J/kgK  ave heat capacity of module (estimated for NiMH)
ess_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess_area_scale=1.6*(ess_module_mass/11)^0.7;   % --     if module dimensions are unknown, assume rectang shape and scale vs PB25
%tm:3/24/00 ess_mod_sarea=0.2*ess_area_scale;          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess_mod_sarea=2*(0.195*0.081+0.102*0.081);          % m^2    total module surface area exposed to cooling air (typ rectang module)
ess_mod_airflow=0.01;                      % kg/s   cooling air mass flow rate across module (20 cfm=0.01 kg/s at 20 C)
%tm:3/24/00 ess_mod_flow_area=0.005*ess_area_scale;    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess_mod_flow_area=0.005*2*(0.195+0.102);    % m^2    cross-sec flow area for cooling air per module (assumes 10-mm gap btwn mods)
ess_mod_case_thk=2/1000;                   % m      thickness of module case (typ from Optima)
ess_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material (typ polyprop plastic - Optima)
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001);
ess_th_res_on=min(ess_th_res_on,ess_th_res_off);
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef ess_area_scale


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4/7/00:tm file created
% 9/7/00:tm updated OCV data and removed fliplr from charge resistance definition
% Begin added by ADVISOR 2002 converter: 17-Apr-2002
ess_cap_scale=1;

ess_mass_scale_coef=[1 0 1 0];


ess_res_scale_coef=[1 0 1 0];


ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_res_scale_fun=inline('(x(1)*ess_module_num+x(2))/(x(3)*ess_cap_scale+x(4))','x','ess_module_num','ess_cap_scale');
% End added by ADVISOR 2002 converter: 17-Apr-2002