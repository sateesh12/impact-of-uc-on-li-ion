% ADVISOR data file:  ESS_NIMH7_saber_temp.m
%
% Data source: 
%
% Data confirmation: 
%
% Created on: 07-Jan-2002
% By: VHJ, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='7 Ah Panasonic NiMH battery in Saber'; 
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ESS_NIMH7_saber_temp.m - ',ess_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General info on the Saber model:
% Saber model is the RC battery model
% Parameters (Cb,Cc,Re,Rt,Rc) as they vary with temperature and SOC (R's)
%           are detailed in files in the models\Saber\Battery directory: 
%           (change these to change the base values). NIMH stands for Nickel metal hydride
%           ess_nimh7_Cb.ai_dat, ess_nimh7_Cc.ai_dat,ess_nimh7_Re.ai_dat,ess_nimh7_Rc.ai_dat,ess_nimh7_Rt.ai_dat
%           ess_nimh7_Cb.ai_tlu, ess_nimh7_Cc.ai_tlu,ess_nimh7_Re.ai_tlu,ess_nimh7_Rc.ai_tlu,ess_nimh7_Rt.ai_tlu
%           Cb & Cc indexed by temperature, Re, Rc & Rt indexed by SOC and Temp
% The base schematics/sin files have 10 modules, below user can alter 
%           additional parameters for each of these 10 modules.
% To increase the voltage of the pack, the user can scale the 10 modules, using Vnom_set.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nominal voltage of the pack, used below to calculate number of '10 cell pack' modules
Vnom_set=316;
% Calculate module number, the number of '10 cell modules', found using nominal pack voltage
%   scale factor for 10 LiIon batteries is 10cell*7.9V/cell=79V
ess_module_num=Vnom_set/(10*7.9);

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
saber_k_soc=[1 1 1 1 1 1 1 1 1 1]*5.78091488759e-06;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open Circuit Voltage
%
% SOC RANGE over which OCV is defined
ess_soc=[0 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 1];  % (--)	

% Temperature range over which OCV is defined
ess_tmp=[1 26 45];  % (C)

% Module's open-circuit voltage, indexed by ess_soc and ess_tmp
ess_voc=[7.33 7.72 7.765 7.811 7.842 7.874 7.89 7.907 7.918 7.928 7.934 7.939 7.97 8 8.62;
    7.27 7.656 7.712 7.768 7.806 7.843 7.865 7.886 7.898 7.91 7.919 7.928 7.952 7.975 8.56;
    7.25 7.68 7.725 7.77 7.802 7.834 7.857 7.88 7.891 7.902 7.911 7.92 7.935 7.95 8.45]; % (V)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Values
%
% Initial SOC's, indexed by module number
saber_init_soc=[1 1 1 1 1 1 1 1 1 1]*0.7;
% Calculate the initial voltages on the capacitors at given temp, e.g. 20C
saber_init_voc=interp2(ess_soc,ess_tmp,ess_voc,saber_init_soc,20);

% Initial temps's (deg C), indexed by module number
%saber_init_temp=[1 1 1 1 1 1 1 1 1 1]*20;
saber_init_temp=[1 0.95 0.9 0.85 1.05 1.1 1.15 1.2 1.25 1.3]*20;

% Temperature of Heat Sink (Air) - Units = C
saber_air_temp=[1 1 1 1 1 1 1 1 1 1]*20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Battery thermal model
% Heat capacity, J/kgK  ave heat capacity of module, indexed by module number
ess_mod_cp=[1 1 1 1 1 1 1 1 1 1]*974;
ess_module_mass=1;  % (kg), mass of single module
% Thermal Capacity of Battery - Units = J/C
ess_mod_cpm=ess_module_mass*ess_mod_cp;
ess_module_mass=10*ess_module_mass;      % (kg), mass of 10 modules, used by ADVISOR's gui
ess_voc=10*ess_voc;                      % (V), voltage of 10 modules, used by ADV's gui

% Thermal resistance to heat sink, C/W, indexed by module number
ess_th_res=[1 1 1 1 1 1 1 1 1 1]*1.16; % 1.16 vs 0.1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limits
% Per Cell voltage limits
ess_min_volts=6; 
ess_max_volts=9; 

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
Saber_Battery_IO_File='SaberCosimIO_NIMH7_Battery';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 01/07/02: vhj file created using ess_li7_saber_temp as a base
% 01/07/02: vhj added output variable definition section
% 04/26/02: mpo update version to 2002
% 05/13/02: mak update to for new s-function that allows communication between saber and matlab