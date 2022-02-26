% ADVISOR data file:  ESS_PB16_fund_optima_temp.m
%
% Data source:  Fundamentally based model developed by John Harb at Brigham Young University under
% subcontract with NREL. The model is a one-dimensional model of an acid-starved lead acid cell that
% employs the porous electrode theory, which assumes that the porous electrodes consist of superimposed,
% continuous phases (the electrolyte, gases, electrode active materials, and inert phases such as the
% separator).
%
% Manufacturer: Optima Lead Acid, 16.5 Ah rated capacity
%
% Data confirmation:
%
% Notes:
% The *fund_optima version runs a model with proprietary optima numbers
% hardcoded into a compiled version of the fundamental model.  The *fund_generic version allows
% the user control over all possible inputs into the fundamental battery model.
%
% Disclaimer: 	Because the fundamental battery model is a new approach to modeling batteries
%					in ADVISOR that is still undergoing testing, it does not come with guarantees of 
%					performance or explicit tech support.  For problems with the code, contact 
%					jharb@et.byu.edu or valerie_johnson@nrel.gov
%
% Created on: 20-Sept-99
% By:  VHJ, NREL, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_description='Fundamentally based Lead Acid battery with parameters for Optima 16.5 Ah battery.';
ess_version=2003; % version of ADVISOR for which the file was generated
ess_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ess_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
% note: this data requires additional verification of performance over full SOC range.
% data is shown to correlate reasonably well in SOC range of 0.6 to 0.7.
disp(['Data loaded: ESS_PB16_fund_optima_temp - ',ess_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT1: Physical Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note: most of the parameters for input1 are constants for a lead acid battery
ess_aapb=1.55;				%Anodic charge transfer coefficient for Pb electrode
ess_aapbo2=1.15;			%Anodic charge transfer coefficient for PbO2 electrode
ess_acpb=.45;				%Cathodic charge transfer coefficient for Pb electrode
ess_acpbo2=.85;				%Cathodic charge transfer coefficient for PbO2 electrode
ess_aopb=23000.0;			%Initial internal surface area for Pb electrode (cm-1)
ess_aopbo2=230000.0;		%Initial internal surface area for PbO2 electrode (cm-1)
ess_ecnref=4.96E-6;		%Reference exchange current density, Pb electrode at 25oC (A/cm2)
ess_ecpref=3.19E-7;		%Reference exchange current density, PbO2 electrode at 25oC (A/cm2)
ess_fc=96485.0;				%Faraday's constant (C/equiv)
ess_pneg=1.5;				%Exponent for area correction, Pb electrode
ess_ppos=1.5;				%Exponent for area correction, PbO2 electrode
ess_rgas=8.3144;			%Gas constant (J/mole/K)
ess_spb=4.8E4;				%Electronic conductivity of lead (S/cm)
ess_spbo2=5.0E2;			%Electronic conductivity of lead dioxide (S/cm)
ess_tpb=0.5;					%Exponent on volume fraction for tortuosity correction in negative electrode
ess_tpbo2=0.5;				%Exponent on volume fraction for tortuosity correction in positive electrode
ess_tsep=0.5;				%Exponent on volume fraction for tortuosity correction in separator
ess_tplus=0.72;				%Transference number for Hydrogen Ion
ess_vo=17.5;					%Partial Molar Volume of Water (cm3/mole)
ess_ve=45;					%Partial Molar Volume of Acid (cm3/mole)
ess_vpb=18.1746;			%Molar volume of Pb (cm3/mole)
ess_vpbo2=25.5136;			%Molar volume of PbO2 (cm3/mole)
ess_vpbso4=48.9113;		%Molar volume of PbSO4 (cm3/mole)
ess_ratio=.10;				%Ratio of gas to liquid volume fractions in the electrodes
ess_uo2=1.649;				%Equilibrium voltage for O2 vs. Pb (V)
ess_eco2rf=1.30435E-14;	%Reference exchange current density, O2 at 25oC (A/cm2)	
ess_aao2=0.657;				%Anodic charge transfer coefficient for O2 evolution at positive electrode
ess_aco2=1.343;				%Cathodic charge transfer coefficient for O2 reaction at positive electrode
ess_fo2=.99;					%Fraction of O2 that recombines at negative electrode
ess_uh2=0.356;				%Equilibrium voltage for H2 vs. Pb (V)
ess_ech2rf=6.607E-14;	%Reference exchange current density, H2 electrode at 25oC (A/cm2)
ess_ach2=0.58;				%Cathodic charge transfer coefficient for H2 evolution at negative electrode
ess_c2ref=0.00494;		%Reference acid concentration (mole/cm3)
ess_rkcsatn=2.5E-8;		%Mass transfer parameter for negative electrode
ess_rkcsatp=1.0E-7;		%Mass transfer parameter for positive electrode
ess_dUdT=2E-4;				%Temperature coefficient for cell potential

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT2: Numerical Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_n=2;					%Number of coupled equations
ess_npb=5; 				%Number of computational nodes in negative electrode(lead)
ess_npbo2=5;				%Number of computational nodes in positive electrode (lead oxide)
ess_nsep=5;				%Number of computational nodes in separator
ess_relax=1.0;			%Relaxation factor for iterative solution of coupled equations (0=no update, 1 = no relaxation)
ess_theta=0.5;			%Factor used to determine time averaging (0 = Fully Explicit, 0.5 = Crank-Nicholson, 1=Fully implicit)
ess_gexn=1.1;			%Expansion coefficient for nodes in the negative electrode (ratio of adjacent cells, number greater than 1 concentrates nodes at electrode front)
ess_gexp=1.1;			%Expansion coefficient for nodes in the positive electrode (ratio of adjacent cells, number greater than 1 concentrates nodes at electrode front)
ess_tstep=5.0;			%Initial value for time step (not needed-remove later) (s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT3: Battery Characteristics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_esep=0.08;			%Separator volume fraction
ess_egass=0.10;			%Volume fraction of gas in separator
ess_rtop=0.00024375;	%Resistance to account for current collection and tab (ohms)
ess_ncpmod=6;			%Number of cells per module
ess_nmppk=1;				%Number of modules per pack
ess_cap=16.5;			%Rated capacity of the cell (Ahr)

ess_module_num=25;	%number of batteries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT4: Motor Limits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_tcurmx=mc_max_crrnt;						% maximum motor current (A)
ess_vmax=16.5;										% maximum voltage (V)
ess_vmin=9.5;										% minimum voltage (V)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA, right now include this (gui references it)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% battery thermal model
ess_th_calc=1;                             % --     0=no ess thermal calculations, 1=do calc's
ess_mod_cp=660;                            % J/kgK  ave heat capacity of module
ess_set_tmp=35;                            % C      thermostat temp of module when cooling fan comes on
ess_mod_sarea=0.2;                         % m^2    total module surface area exposed to cooling air
ess_mod_airflow=0.07/12;                   % kg/s   cooling air mass flow rate across module (140 cfm=0.07 kg/s at 20 C)
ess_mod_flow_area=0.004;                   % m^2    cross-sec flow area for cooling air per module
ess_mod_case_thk=2/1000;                   % m      thickness of module case
ess_mod_case_th_cond=0.20;                 % W/mK   thermal conductivity of module case material
ess_air_vel=ess_mod_airflow/(1.16*ess_mod_flow_area); % m/s  ave velocity of cooling air
ess_air_htcoef=30*(ess_air_vel/5)^0.8;      % W/m^2K cooling air heat transfer coef.
ess_th_res_on=((1/ess_air_htcoef)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key on
ess_th_res_off=((1/4)+(ess_mod_case_thk/ess_mod_case_th_cond))/ess_mod_sarea; % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
ess_mod_airflow=max(ess_mod_airflow,0.001);
ess_th_res_on=min(ess_th_res_on,ess_th_res_off);
clear ess_mod_sarea ess_mod_flow_area ess_mod_case_thk ess_mod_case_th_cond ess_air_vel ess_air_htcoef


ess_module_mass=6.680;  % (kg), mass of a single ~12 V module
ess_soc=1;
ess_voc=12;  % (V)
ess_coulombic_eff=[.9];	%used for mpgge

ess_cap_scale=1; % scale factor for module max ah capacity (DO NOT MODIFY FOR FUND MODEL!)

% user definable mass scaling relationship 
ess_mass_scale_fun=inline('(x(1)*ess_module_num+x(2))*(x(3)*ess_cap_scale+x(4))*(ess_module_mass)','x','ess_module_num','ess_cap_scale','ess_module_mass');
ess_mass_scale_coef=[1 0 1 0]; % coefficients in ess_mass_scale_fun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12/29/98: vhj file created
% 1/22/99: vhj added input4 data, calculation of max power output
% 2/03/99: vhj moved writing to dat files and max power output to ess_fund_init
% 2/04/99: vhj added ess_ to variable names
% 4/12/99: vhj added variables for nrel13c version
% 4/13/99: vhj added thermal variables
% 4/14/99: vhj vo,ve edited, limits for vmin
% 9/20/99: vhj updated vmin, old advisor variables, mass, disclaimer
% 9/23/99: vhj added coulombic efficiency (used for mpgge in post processing)
% 11/03/99:ss updated version from 2.2 to 2.21
% 08/16/2000: mpo changed the units written in the comment on ess_rgas from J/mole to J/mole/K 
%02/08/01: vhj updated file name to include _temp
% 7/30/01:tm added user defineable scaling functions for mass=f(ess_module_num,ess_cap_scale,ess_module_mass) 
