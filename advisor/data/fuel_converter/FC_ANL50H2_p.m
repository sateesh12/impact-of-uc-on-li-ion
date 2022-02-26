% ADVISOR Data file:  FC_ANL50H2_polar.m
%
% Data source:   IECEC-98-289 "Analytical Performance of Direct-Hydrogen-Fueled Polymer
%                Electrolyte Fuel Cell (PEFC) Systems for Transportation Applications."
%                Ezzat Doss, Rajesh Ahluwalia, and Romesh Kumar, Argonne National Laboratory.
%                1998.
%
% Data confidence level: Good
%
% Notes: 
%
% Created on:  4/29/02
% By:  Tony Markel, NREL, Tony_Markel@nrel.gov
%
% Revision history at end of file.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='ANL Model Results - 50kW(net) Pressurized Hydrogen Fuel Cell System' ;
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: FC_ANL50H2_polar.m - ',fc_description]);

%%%%%%%%%%%%%%%%%%
% Stack/Cell info
%%%%%%%%%%%%%%%%%%
% active area per cell (m^2)
fc_cell_area=769/100/100; % estimate
% number of cells in one stack
fc_cell_num=145; % estimate 
% number of stacks connected in series per string
fc_stack_num=1;
% number of strings connected in parallel
fc_string_num=1; 
% cell current density (amps/m^2)
fc_I_map=[7.6 55.6 76.9 97.9 183.5 277.3 389.1 538.5]/fc_cell_area; % amps/m^2
% cell voltage (V) indexed by fc_I_map
fc_V_map=[143.3 134 131.8 130 123.5 117.2 110 100]/fc_cell_num; % volts 
% system efficiency map - only used for plots
fc_eff_map=[0 49.2 53.3 55.9 59.6 59.1 56.2 50.8]/100; 
% fuel usage (g/s) indexed by fc_I_map
fc_fuel_map=[0.012 0.085 0.117 0.149 0.280 0.423 0.594 0.821]/fc_cell_num;
% fuel utilization factor indexed by fc_I_map (fuel consumed/fuel supplied)
fc_fuel_utilization_map=ones(size(fc_fuel_map))*1.0; % 
% net power out of the system
fc_pwr_map=[0 5 7.5 10 20 30 40 50]*1000; % W

% emissions info
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_co_map=zeros(size(fc_fuel_map));
fc_hc_map=zeros(size(fc_fuel_map));
fc_nox_map=zeros(size(fc_fuel_map));
fc_pm_map=zeros(size(fc_fuel_map));
fc_exflow_map=zeros(size(fc_fuel_map));
fc_extmp_map=zeros(size(fc_fuel_map));
fc_o2_map=zeros(size(fc_fuel_map));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cold Engine Maps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
fc_cold_tmp=20; %deg C
fc_fuel_map_cold=zeros(size(fc_fuel_map));
fc_hc_map_cold=zeros(size(fc_fuel_map));
fc_co_map_cold=zeros(size(fc_fuel_map));
fc_nox_map_cold=zeros(size(fc_fuel_map));
fc_pm_map_cold=zeros(size(fc_fuel_map));
%Process Cold Maps to generate Correction Factor Maps
names={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map'};
for i=1:length(names)
    %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
    eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
end

%%%%%%%%%%%%%%%%%%
% auxilary systems
%%%%%%%%%%%%%%%%%%
% air compressor/blower
% air flow rate provided by compressor (g/s)
% NOTE: this will mostlikely need to be defined as scfm and converted to g/s
fc_air_comp_map=[0.8 5.9 8.2 10.4 19.4 29.4 41.2 57.0]; % Air flow entering compressor, g/s
% air compressor power requirements indexed by fc_air_comp_map
fc_air_comp_pwr=[0.46 1.9 2.21 2.42 3.15 4.01 5.37 7.44]*1000; % air flow power, W
% ratio of fuel to air (g/s)/(g/s)
fc_fuel_air_ratio=mean((fc_fuel_map*fc_cell_num)./fc_air_comp_map); % average of ratio of two input streams 

% % Opcon Autorotor Screw Compressor 1050, pressure ratio 1.44
% %------------------------------------------------------------
% % Mass flow of air entering compressor [g/s]. Air compressor power requirements indexed by fc_air_comp_map
% fc_air_comp_map=[2 2.5 3 4.5 5 6.5 8.5 10 20 35 55 65 85 100]; 
% % Requested power input to compressor [W]
% fc_air_comp_pwr=[690 790 880 1040 1160 1320 1580 1730 2970 5000 7960 9970 13200 16700]; 
% % ratio of fuel to air (g/s)/(g/s)
% fc_fuel_air_ratio=(0.035*32)/(10*2.3); % 

% fuel pump (for liquid fuels only)
% fuel flow rate provided by fuel pump (g/s)
% NOTE: this will mostlikely need to be defined as scfm and converted to g/s
fc_fuel_pump_map=fc_fuel_map*fc_cell_num; % g/s 
% fuel pump power requirements indexed by fc_fuel_pump_map
fc_fuel_pump_pwr=[0.647 0.757 0.787 0.811 0.880 0.942 1.02 1.443]*1000; % W
% NOTE: the above auxiliary load represents the radiator fan and coolant pump load - data provided indexed by fuel usage

% coolant pump
% coolant flow rate provided by pump (g/s)
% NOTE: this will mostlikely need to be defined as scfm and converted to g/s
fc_coolant_pump_map=[0 1000]; % g/s, % not applicable
% coolant pump power requirements indexed by fc_coolant_pump_map
fc_coolant_pump_pwr=[0 0]*1000; % W, % not applicable
% fixed coolant flow rate
fc_coolant_flow_rate=0; % g/s, % not applicable
% coolant specific heat capacity
fc_coolant_cp=4.1843; % J/(g*K) water
%fc_coolant_cp=(0.5*4.1843+0.5*2.474); % J/(g*K) 50/50 water/ethylene glycol blend

% water pump (for alcohol fuels only)
% water flow rate provided by water pump (g/s)
% NOTE: this will mostlikely need to be defined as scfm and converted to g/s
fc_water_pump_map=[0 1000]; % g/s, % not applicable
% water pump power requirements indexed by fc_water_pump_map
fc_water_pump_pwr=[0 0]*1000; % W % not applicable
% supply ratio of fuel to water
fc_fuel_water_ratio=32/1000; % not applicable 

% expander
% exhaust flow rate from fuel cell to expander (g/s)
fc_exh_expand_map=[0.82 5.97 8.26 10.51 19.7 29.78 41.79 57.83]; % g/s, 
% water pump power requirements indexed by fc_water_pump_map
fc_exh_expand_pwr=[0.02 0.21 0.34 0.51 1.37 2.45 3.6 4.99]*1000; % W 
% Note: this data is currently not used in the model but will be in the future 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_pwr_scale=1.0;   % --  scale fc power
%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1.0; % -- scale the efficiency
fc_trq_scale=1.0; % -- required only for autosize and optimization routines
fc_spd_scale=1.0; % -- required only for autosize and optimization routines


% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_cell_model=1; % 1--> polarization curves, 2--> pwr vs. eff, 3--> gctool model
fc_fuel_den=0.018*1000; % (g/l) density of the fuel  
fc_fuel_lhv=120*1000; % (J/g) lower heating value of the fuel
fc_fuel_type='Hydrogen'; % fuel type used

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THERMAL MODEL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_tstat=80;                  % C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
%fc_ext_sarea=0.3;             % m^2    exterior surface area of engine
fc_ext_sarea=2*(0.3*0.3)+4*(0.3*0.6);             % m^2    exterior surface area of engine
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment
%fc_ex_pwr_frac=[0.40 0.30];   % --   frac of waste heat that goes to exhaust as func of engine speed
fc_ex_pwr_frac=[0.20 0.10];   % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=[0.82 5.97 8.26 10.51 19.7 29.78 41.79 57.83];  % g/s  ex gas flow map
fc_waste_pwr_map=fc_fuel_map*fc_cell_num*fc_fuel_lhv - fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num;   % W    tot FC waste heat = (fuel pwr) - (elec out pwr)
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(fc_pwr_map)
 fc_ex_pwr_map(i)=fc_waste_pwr_map(i)*interp1([min(fc_pwr_map) max(fc_pwr_map)],fc_ex_pwr_frac,fc_pwr_map(i)); % W  pwr map of waste heat to exh 
end
%fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) 
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1145/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) (cp based on exhaust composition h2+h2o+air)

% fuel cell mass calculation
fc_max_pwr=50; % kW     peak engine power
%fc_base_mass=5.0*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 5 kg/kW (DOE 2000 status)
fc_base_mass=2.5*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 2.5 kg/kW (DOE 2004 target)
fc_acc_mass=0.5*fc_max_pwr;         % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 2.0 kg/kW ESTIMATE
target_range=350; % mi
target_fe=80; % mpgge
gas_lhv=42.6*1000; % J/g
gas_dens=0.749*1000; % g/l
target_fuel_storage_spec_energy=2000; % Wh/kg from DOE targets
fc_fuel_mass=target_range/target_fe*3.785*gas_lhv*gas_dens/3600/target_fuel_storage_spec_energy; 
% (kg), fuel storage mass assuming specified range and specified fuel economy
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
clear gas_lhv gas_dens target_range target_fe target_fuel_storage_spec_energy 

%This data only defined as placeholder in block diagram - will not be used in simulations
% vector of powers indexed by fc_I_map - only need as a place holder in simulink block 8/13/99
fc_gross_pwr_map=fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4/29/02:tm file created 

