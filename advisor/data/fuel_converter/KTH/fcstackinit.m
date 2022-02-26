%------------------------------------------------------------------------
% M-file: fcindata.m (fuel cell stack input) 
%
% Created by Kristina Haraldsson
%------------------------------------------------------------------------

% Set input parameters 
%=====================
%init_conds_amb;

% Temperatures
%------------- 
fc_cell_temp_ah= 70;            % Humidifier outlet temperature, anode  [C]
fc_cell_temp_ch= 70;		    % Humidifier outlet temperature, cathode [C]
fc_cell_temp_hyd= 70;           % Temperature of hydrogen out from the tank [C]
fc_cell_temp_cell= 70;		    % Final temperature fuel cell [C]5
fc_cell_temp_amb= 15;   		% Ambient temperature, start temperature [C],
fc_cell_temp_ref= 25;           % Reference temperature, [C]
fc_cell_temp_w= 45;             % Temperature of water circuit before hex [C]
fc_cell_temp_d= 20;             % Temperature difference of cooling medium in hex
fc_cell_temp_cool= 5;           % Temperature difference of cooling medium in fc stack
fc_cell_temp_evap= 50;          % Temperature of water to be injected in the evap. cooler [C]
fc_cell_temp_cond= 60;          % Condenser outlet temperature of water [C]
fc_cell_temp_cond1= 55;         % Condensing temperature of water in the condenser [C]
fc_cell_temp_rad= 22;          % Temperature to which the radiator works, [C]

% Pressures
%----------
fc_cell_press_a= 2;		        % Anode inlet pressure  [bar]
fc_cell_press_c= 2;	            % Cathode inlet pressure [bar]
fc_cell_press_amb= 1.013;       % Ambient pressure, inlet air and fuel tank [bar]
fc_cell_press_hum= 0.01;        % Pressure drop in humidifiers and evap. cooler
fc_cell_press_blowr= 0.2;       % Pressure rise in fan recirculation [bar]
fc_cell_press_blowa= 0.2;       % Pressure rise in fan anode [bar]
fc_cell_press_blowc= 0.2;       % Pressure rise in fan cathode [bar]
fc_cell_press_hyd= 0.2;         % Pressure loss from tank into system [bar]
fc_cell_press_an= 3;            % Pressure in tank, hydrogen liquid [bar]

% Stoichiometry conditions
%-------------------------
fc_cell_stoich_vH= 1.2;		    % Stoichiometric coefficient, hydrogen [-]
fc_cell_stoich_vO=  2;	        % Stoichiometric coefficient, oxygen [-]
fc_cell_stoich_XON=  0.21;	    % Mole fraction of oxygen in air [-]
fc_cell_stoich_RHah= 85;		% Relative humidity, inlet flow anode [%]
fc_cell_stoich_RHch= 85;        % Relative humidity, inlet flow cathode [%]
fc_cell_stoich_RHo= 66;         % Relative humidity, ambient air [%]

% Dimensions
%-----------
fc_cell_dim_tm=  0.0125;	    % Membrane thickness [cm]
fc_cell_dim_A= 280;		        % Electrode area [cm2] 678

% Membrane properties
%-----------------------------------
fc_cell_membrane_Mm=   1155;	% Equivalent weight of membrane [-]
fc_cell_membrane_pdry=  2.0;	% Density of dry membrane [g/cm3]

% Physical constants and data
%----------------------------
fc_cell_const_imin= 0.05;       % Minimum current density [A/cm2]
cell_const_R1= 82.06;		% Molar gas constant [cm3*atm/(mol*K)]
cell_const_R2= 8.314;        % Molar gas constant [J/mol*K] 
cell_const_F= 96487;		    % Faraday constant [C/mol]
cell_const_jo= 0.01;	        % Exchange current density [A/cm2], Springer et al., 1991
cell_const_Voc= 1.03;        % Open circuit potential [V], Springer et al., 1991, 1.1 101402
cell_const_MH= 2.0158;		% Molecular weight, hydrogen [g/mol]
cell_const_MO= 31.998;	    % Molecular weight, oxygen [g/mol]
cell_const_MN= 28;	        % Molecular weight, nitrogen [g/mol]
cell_const_MW= 18.016;		% Molecular weight, water [g/mol]
cell_const_Mair= 28.97;      % Molecular weight, air [g/mol]
fc_cell_const_k= 1.39;          % Cp/Cv for air
fc_cell_const_U= 568;          % Total heat coeff. of hex, [W/(m2*K)]
fc_cell_const_eta1= 0.70;       % Efficiency compressor
fc_cell_const_etagen= 0.99;     % Efficiency generator
fc_cell_const_etapump= 0.70;    % Efficiency pump
fc_cell_const_etablow= 0.65;   % Efficiency blower
fc_cell_const_eta_DCDC= 0.95;   % Efficiency DC/DC converter
fc_cell_const_kw= 230;          % Thermal conductivity of aluminium, [W/m,K]
fc_cell_const_Nrad= 30;         % Number of tubes in radiator
cell_const_g= 9.81;
fc_cell_const_ex= 0.002;        % Venting percentage, 0,2%
fc_cell_const_zw= 0.85;         % Percentage of water out from the cathode
cell_const_LHV_H2= 241.3E3;  % Lower Heating Value of hydrogen, LHV [kJ/mole]

% Fuel cell stack
%----------------
fc_cell_stack_N= 0;		        % Number of cells in fuel cell stack [-] 
fc_cell_stack_Pel= 50000;       % Desired output electric power of stack [W]
fc_cell_stack_dpipe= 0.03;      % Pipe diameter, cooling circuit[m] 
fc_cell_stack_dpipefc= 0.002;   % Pipe diameter, fuel cell stack [m]
fc_cell_stack_drad= 0.05;       % Tube diameter, radiator, [m]
fc_cell_stack_Lpipe= 1;         % Pipe length, cooling ciruit [m]
fc_cell_stack_Lpipefc= 0.5;     % Pipe length, fuel cell stack [m]
fc_cell_stack_Lrad= 1;          % Tube length, radiator, [m]


% Hydrogen tank
%---------------
cell_tank_V= 0.23;           % Volume of pressure vessel [m3]		
cell_tank_Cv= 5.9;			% Specific heat of hydrogen [J/mol,K]		

%================== End fcstackinit.m ==========================================		

% Revisions history
%-------------------
% 01/22/03 KH removed unused data structures
% 04/28/03 KH removed time structure
% 05/02/03 KH changed structures into scripts