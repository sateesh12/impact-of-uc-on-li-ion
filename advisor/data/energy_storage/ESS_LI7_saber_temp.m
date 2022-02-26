% ADVISOR data file:  ESS_LI7_saber_temp.m
%
% Data source: 
%
% Data confirmation: 
%
% Created on: 21-Dec-2001
% By: VHJ, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='7 Ah Saft Lithium Ion battery in Saber'; 
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_LI7_saber_temp.m - ',ess_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General info on the Saber model:
% Saber model is the RC battery model
% Parameters (Cb,Cc,Re,Rt,Rc) as they vary with temperature and SOC (R's)
%           are detailed in files in the models\Saber\Battery directory: 
%           (change these to change the base values). LIB stands for Lithium Ion Battery
%           LIB_Cb.ai_dat, LIB_Cc.ai_dat,LIB_Re.ai_dat,LIB_Rc.ai_dat,LIB_Rt.ai_dat
%           LIB_Cb.ai_tlu, LIB_Cc.ai_tlu,LIB_Re.ai_tlu,LIB_Rc.ai_tlu,LIB_Rt.ai_tlu
%           Cb & Cc indexed by temperature, Re, Rc & Rt indexed by SOC and Temp
% The base schematics/sin files have 10 modules, below user can alter 
%           additional parameters for each of these 10 modules.
% To increase the voltage of the pack, the user can scale the 10 modules, using Vnom_set.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nominal voltage of the pack, used below to calculate number of '10 cell pack' modules
Vnom_set=288;
% Calculate module number, the number of '10 cell modules', found using nominal pack voltage
%   scale factor for 10 LiIon batteries is 10cell*3.6V/cell=36V
ess_module_num=Vnom_set/(10*3.6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale factors, 'k' values, indexed by module number
% Value >1 increases parameters (R's & C's), e.g. 1.1 = 10% increase
% Value <1 decreases parameters (R's & C's), e.g. 0.85 = 15% decrease
saber_k_re=[1 1 1 1 1 1 1 1 1 1];
saber_k_rc=[1 1 1 1 1 1 1 1 1 1];
saber_k_rt=[1 1 1 1 1 1 1 1 1 1];
saber_k_cb=[1 1 1 1 1 1 1 1 1 1];
saber_k_cc=[1 1 1 1 1 1 1 1 1 1];

% SOC integrator factor, k = Inverse of Energy Capacity of Battery - Units = 1/Joules for integ
saber_k_soc=[1 1 1 1 1 1 1 1 1 1]*1.2744210942e-05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open Circuit Voltage
%
% SOC RANGE over which OCV is defined
ess_soc=[0 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 1];  % (--)	

% Temperature range over which OCV is defined
ess_tmp=[1 25 45];  % (C)

% Module's open-circuit voltage, indexed by ess_soc and ess_tmp
ess_voc=[3.44 3.496 3.514 3.532 3.55 3.568 3.585 3.602 3.62 3.637 3.667 3.697 3.727 3.757 3.896;
    3.124 3.36 3.42 3.479 3.501 3.524 3.547 3.569 3.593 3.616 3.65 3.684 3.72 3.756 3.9;
    3.128 3.365 3.425 3.484 3.506 3.528 3.552 3.575 3.599 3.623 3.657 3.692 3.727 3.761 3.899]; % (V)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Values
%
% Initial SOC's, indexed by module number
saber_init_soc=[1 1 1 1 1 1 1 1 1 1]*0.7;%6226;
% Calculate the initial voltages on the capacitors at given temp, e.g. 25C
saber_init_voc=interp2(ess_soc,ess_tmp,ess_voc,saber_init_soc,25);

% Initial temps's (deg C), indexed by module number
%saber_init_temp=[1 1 1 1 1 1 1 1 1 1]*25;
saber_init_temp=[1 0.95 0.9 0.85 1.05 1.1 1.15 1.2 1.25 1.3]*30;
%saber_init_temp=25+[0:9];

% Temperature of Heat Sink (Air) - Units = C
saber_air_temp=[1 1 1 1 1 1 1 1 1 1]*20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Battery thermal model
% Heat capacity, J/kgK  ave heat capacity of module, indexed by module number
ess_mod_cp=[1 1 1 1 1 1 1 1 1 1]*795;
ess_module_mass=0.37824;  % (kg), mass of single module
% Thermal Capacity of Battery - Units = J/C
ess_mod_cpm=ess_module_mass*ess_mod_cp;
ess_module_mass=10*ess_module_mass;      % (kg), mass of 10 modules, used by ADVISOR's gui
ess_voc=10*ess_voc;                      % (V), voltage of 10 modules, used by ADV's gui

% Thermal resistance to heat sink, C/W, indexed by module number
ess_th_res=[1 1 1 1 1 1 1 1 1 1]*1.12; % 1.12 vs 0.1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limits
% Per Cell voltage limits
ess_min_volts=2; 
ess_max_volts=3.9; 

% SOC limits, used in the comparator
ess_min_soc=0.01; 
ess_max_soc=0.99; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other Data
% Next 3 vars Needed for gui
ess_cap_scale=1; % scale factor for module max ah capacity (DO NOT MODIFY FOR SABER MODEL!)
% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Names of modules and var_names
% Variables describe the following: 
% k = multiplication factor for re,rc,rt,cb,cc. 
% k = Inverse of Energy Capacity of Battery - Units = 1/Joules for integ
% ic = Initial Battery Voltage Based on SOC - Units = Volts
% init = Initial SOC
% rth = Thermal Resistance to Ground - Units = C/W
% cth = Thermal Capacity of Battery - Units = J/C
% t_init = Initial Temperature of Battery - Units = C
% dc = Temperature of Heat Sink (Air) - Units = C

% Save init outputs in separate variable, needed for initial cond feedback to advisor
ValueInit=[saber_init_voc saber_init_soc saber_init_temp];
% Input, Constant, and Output Variables used in the Saber S-Function - SaberCosimSfun2
Saber_Battery_IO_File='SaberCosimIO_LI7_Battery';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12/21/01: vhj file created using ess_li7_rc_temp as a base
% 12/28/01: vhj begin Saber details/names
% 01/03/02: vhj loop through 10 modules for names, additional control vars, 
%               add values in vinf.saber_cosim.Value
% 01/07/02: vhj added output variable definition section
% 05/13/02: mak update to for new s-function that allows communication between saber and matlab