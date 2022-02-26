% ADVISOR Data file:  FC_VT.m
%
% Data source:  
%
% Data confidence level:  
%
% Notes: 
%
% Created on:  08/12/02
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='VT Model'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: FC_VT.m - ',fc_description]);

% load default system data from file
%evalin('base','system_characteristics')
% FUEL CELL STACK CHARACTERISTICS
fc_cp_stack=0.71; % (J/g-K) specific heat of the stack (Graphite =0.71; Aluminum=0.912; Iron=0.460)
fc_stack_unit_mass=(50*1.333)*1000/(678*210); % (g/cm^2) stack unit mass (assumes 2.5 kg/kW - DOE current status 2003 50kW full system ~65 kg BOP ->> 1.33kg/kW)
%fc_lumped_capacitance = 120000;  % (J/K) m*Cp_graphite - lumped capacitance of fuel cell stacks
fc_stack_UA = 6;  % (J/K) Overall heat transfer convected to ambient      
fc_cell_area = 678; % (cm^2) active area per cell
%fc_cathode_pressure_drop_percentage = .15; % also defined below (tm:3/26/03)
fc_cell_num = 210; % number of fuel cells in series
%fc_stack_cell_area = fc_cell_area*fc_num_cells; % (cm^2) total fuel cell active area in the stack % (tm:3/26/03) removed from model
fc_min_cell_volts = 0.60; % (V) voltage
% parameters of fuel cell polarization curve
fc_polar_param_voc = 1.03; % (V)
%fc_polar_param_tafel = 0.06;
fc_polar_param_tafel = 0.089; % revised 10/2/03:tm for O2 impacts
fc_polar_param_ohmic = 1.12;
fc_polar_param_ohmic_temp = 2.49E-3;
%fc_polar_param_concentration = 0.10;
fc_polar_param_concentration = 0.0002; % revised 10/2/03:tm for O2 impacts
fc_polar_param_ref_temp = 333; % (K)
fc_polar_param_temperature = 0.00041;

%------------
fc_reference_temperature=25; % Reference temperature [C}
%------------------

% FUEL CELL SYSTEM OPERATING CONDITIONS
%fc_SRair = 2.5;
fc_stack_stoich_air_map=[2.5 2.5 2.5 2.5 2.5 2.5 2.5]; % desired cathode stoichiometry
fc_stack_stoich_i_map=[0 50 125 250 375 500 625]/fc_cell_area; % index to stoich air map
%fc_cathode_humidity = .6; % (tm:3/26/03) replaced model entry with fc_target_cathode_inlet_humidity
%fc_minimum_current_density = .005; defined below (tm:3/25/03)
%fc_m_dot_air_min = .001;
fc_target_cathode_inlet_humidity = 0.3; %Relative humidity desired at the cathode inlet, changed 08/06/03 KH
fc_target_anode_inlet_humidity = 0.3;      % Relavite humidity that you want at the inlet to the anode of the fuel cell stack
fc_target_cathode_outlet_humidity = 1;   % Relative humidity that you would like to have at the outlet of the cathode of the fuel cell stack.
fc_min_temp_for_heat_rejection = 273.15+75;  % Temperature at which you want to reject heat above.  Meaning, no heat will be rejected below this temp.  Keeps the system hot
                                             % 55 C added 07/10/03 KH                           
%fc_cell_minimum_voltage = 0.6;  % Cell voltage that you do not want to operate below % tm:3/25/03 not used in model
fc_minimum_current_density = 0.002;  % (A/cm^2) minimum current density you want to run the stack at.

%fc_allowable_temp_rise = 5; % (K)
fc_allowable_temp_rise = 8; % (K)

fc_max_cathode_inlet_pressure = inf; % (atm)
fc_min_cathode_inlet_pressure = 1.01; % (atm)
%parameter removed (tm:10/02/03) fc_cathode_pressure_drop_percentage = 0.15;  % Pressure difference, based on stack pressure in %percent that exsists across the stack on the cathode air stream.
fc_cathode_pressure_drop=0.115; % (atm) pressure drop across inlet to outlet of stack cathode

% stack operating pressure strategy
%fc_stack_i_map = [0:500]; % (A), stack operating current range
fc_stack_i_map = [0 50 125 250 375 500 625]/fc_cell_area; % (A/cm^2), stack operating current range
%fc_stack_pres_map = linspace(1,1.8,501); % (atm), operating pressure indexed by fc_stack_i_map
fc_stack_pres_map = [1    1.08    1.2    1.4    1.6    1.8   2.0]; % (atm), operating pressure indexed by fc_stack_i_map
%optimal (6/13/03)[1.0    1.001    1.0013    1.0434    1.699    1.7];
%fc_stack_temp_cor_map = [200:400]; % (K), stack operating temperature range
fc_stack_temp_cor_map = [200 400]; % (K), stack operating temperature range
%fc_stack_pres_cor_map = linspace(0,0,201); % (atm), operating pressure correction term indexed by fc_stack_temp_cor_map
fc_stack_pres_cor_map = [0 0]; % (atm), operating pressure correction term indexed by fc_stack_temp_cor_map

%fc_min_sys_pwr_req = 1000; % (W), minimum net power to be requested of the fuel cell system

%AIR COMPRESSOR CHARACTERISTICS
AA = [0,.6,1,1.4,1.7,1.9,2.05,2.2,2.35,2.5,2.6;1,1.35,1.8,2.1,2.3,2.5,2.65,2.8,2.9,3,3.05;1.8,2.15,2.4,2.65,2.8,2.95,3.1,3.25,3.4,3.55,3.65;2.6,2.8,3.05,3.25,3.4,3.55,3.7,3.85,4,4.15,4.25;3.3,3.45,3.7,3.9,4,4.2,4.35,4.45,4.6,4.75,4.85;3.95,4.1,4.3,4.5,4.6,4.75,4.9,5.05,5.2,5.35,5.45;4.55,4.7,4.9,5.05,5.2,5.3,5.45,5.6,5.75,5.85,5.95;5.2,5.3,5.45,5.6,5.7,5.85,6,6.15,6.3,6.5,6.65;5.75,5.85,6,6.2,6.3,6.5,6.65,6.8,7,7.15,7.3;6.35,6.5,6.65,6.8,6.95,7.15,7.3,7.5,7.7,7.85,8.05;7,7.15,7.3,7.5,7.65,7.85,8.05,8.2,8.45,8.6,8.9]; %speed matrix for modified opcon -- last modified 7/31/00
BB = [.115,.121,.135,.149,.157,.162,.167,.169;.172,.187,.204,.216,0.224,.232,.242,.254;.229,.254,.271,.281,.293,.3,.310,.319;.288,.314,.334,.346,.359,.359,.367,.377;.348,.372,.396,.41,.419,.416,.425,.436;.409,.432,.459,.471,.481,.478,.487,.497;.477,.494,.523,.533,.544,.539,.548,.558;.543,.556,.584,.595,.607,.599,.608,.618;.596,.618,.642,.654,.667,.658,.668,.679;.649,.681,.701,.715,.725,.721,.730,.742;.706,.741,.762,.777,.785,.783,.792,.806;.764,.803,.823,.839,.847,.843,.849,.872;.831,.872,.883,.899,.908,.902,.905,.939;.911,.942,.951,.958,.967,.971,.972,1.007;.989,1.012,1.019,1.016,1.026,1.051,1.049,1.076;1.067,1.081,1.087,1.074,1.085,1.131,1.125,1.144]; %speed matrix for Opcon 1050 -- last modified 2/16/01
CC = [.535,.715,.711,.566,.424,.321,.243,.161;.546,.769,.809,.741,.663,.618,.6,.571;.558,.824,.894,.859,.816,.779,.751,.703;.555,.849,.944,.913,.877,.839,.807,.758;.526,.867,.968,.95,.920,.881,.851,.801;.497,.87,.983,.971,.954,.909,.883,.836;.472,.860,.993,.986,.963,.936,.909,.863;.447,.844,.993,.996,.963,.945,.918,.876;.425,.814,.988,.997,.963,.954,.927,.887;.403,.78,.975,.986,.963,.946,.925,.887;.382,.729,.957,.971,.963,.936,.923,.886;.361,.679,.926,.957,.955,.926,.919,.871;.337,.644,.885,.937,.933,.917,.916,.857;.306,.608,.853,.909,.905,.904,.906,.858;.283,.569,.821,.881,.877,.886,.891,.859;.262,.531,.789,.854,.849,.868,.875,.86]; %adiabatic efficiency matrix for Opcon 1050 -- last modified 2/17/01
DD = [.688,.617,.526,.47,.437,.416,.397,.386;.756,.682,.617,.58,.558,.541,.521,.498;.823,.747,.698,.672,.647,.632,.612,.592;.877,.798,.756,.73,.705,.69,.672,.653;.905,.846,.8,.772,.754,.738,.721,.701;.931,.878,.828,.806,.791,.771,.756,.74;.944,.896,.849,.832,.815,.802,.788,.773;.957,.911,.869,.852,0.835,.824,0.81,.797;.968,.921,.888,.871,.855,.845,.833,.819;.978,.931,.905,.887,.874,.858,.846,.832;.987,.94,.915,.897,.888,.869,.86,.845;.995,.948,.925,.907,.898,.881,.874,.851;.993,.945,.933,.917,.908,.892,.889,.857;.975,.942,.933,.926,.918,.894,.893,.86;.962,.94,.933,.936,.927,.884,.887,.863;.951,.938,.933,.946,.937,.875,.88,.867]; %volumetric efficiency matrix for Opcon 1050 -- last modified 2/17/01
compressor_pressure_map = [1.1 1.3 1.6 1.8 2 2.2 2.4 2.7]; % (atm)
compressor_mass_flow_map = [.0625 .125 .1875 .25 .3125 .375 .4375 .5 .5625 .625 .6875 .75 .8125 .875 .9375 1]; % (--) normalized flowrate
compressor_temperature_rise_map = [.084 .237 .4375 .56 .6686 .77 .866 1]; % (--) normalized temperature rise

fc_comp_adeff_max = 0.675; %  (%) maximum expected adiabatic efficiency
fc_comp_voleff_max = 0.975; % (%) maximum expected volumetric efficiency
fc_comp_max_tmp = 96.15; % (K) maximum delta expected outlet temperature of compressor 
fc_comp_spd_max = 16000; % (RPM) maximum speed of compressor 
fc_comp_slpm_air_max = 132.4*60; % (slpm) maximum flowrate

% compressor_speed_min = 2000; % not used in model (tm:3/25/03)
fc_comp_elec_eff = 0.88;


%THERMAL SYSTEM CHARACTERISTICS
fc_system_coolant_capacity = 5*3.785;  % (L) cooling system capacity
fc_sys_plumbing_htx_coef = 16.66;%  (W-K) Overall Heat transfer coef from coolant to ambient, 16.66 Measured VA Tech 
%fc_radiator_frontal_area = 1;  % (m^2)
fc_radiator_frontal_area = 0.2;  % (m^2)

fc_radiator_fan_num=1; % number of radiator fans
fc_radiator_fan_flowrate = 2000; % (CFM) maximum flowrate of radiator fan
fc_radiator_no_fan_flowrate=0.02; % kg/s air flow rate with fan off
fc_radiator_bypass_delta_t=15; % temperature drop from design temp at which radiator is bypassed
fc_radiator_veh_spd_map=[30 60 100 160]*1000/3600; % (m/s)
fc_radiator_spd_ratio_fan_on=[0.3 0.2 0.175 0.16]; % (--)
fc_radiator_spd_ratio_fan_off=[0.09 0.125 0.15 0.16]; % (--)
fc_radiator_fan_pwr_map=300; % (W)

fc_condenser_fan_num=1; % number of condenser fans
fc_condenser_fan_flowrate = 500; % (CFM) maximum flowrate of condenser fan 
fc_condenser_fan_pwr_map=300; % (W)
%fc_condenser_frontal_area = .77; % (m^2)
fc_condenser_frontal_area = .3; % (m^2), added 08/06/03 KH
fc_coolant_pump_flow_map=[0,12.5,25,37.5,50,62.5,75,87.5]*6.30902E-2*1000; % (g/s)
fc_coolant_pump_pwr_map=[.7,.85,1.05,1.2,1.4,1.6,1.75,1.95]*746; % (W)
%fc_coolant_pump_max_flowrate = 87.5; % (GPM)
%fc_coolant_pump_min_flowrate = 5; % (GPM)
%fc_coolant_pump_min_power = 0; % (HP)
%fc_coolant_pump_max_power = 1.95; % (HP)

%AMBIENT CONDITIONS
%T_amb = 293; % not used in model (tm:3/25/03)
%T_amb = 300; % not used in model (tm:3/25/03)
%fc_p_amb = 101.325; % (kPa), ambient pressure
fc_p_amb = 1; % (atm), ambient pressure
fc_rh_amb = 0.75; % (--), ambient relative humidity
%dt = 1;   % Time Step in seconds that the current model operates on % not used in model (tm:3/25/03)

%CONSTANTS
% fc_fuel_lhv = 1.1968E8; % (J/kg) % removed - defined in fc_vt.m
fc_mw_h20 = 18.016;     % (kg/kmol) Molecular weight of water
fc_mw_air = 28.97;      % (kg/kmol) Molecular weight of air 
fc_mw_h2= 2.0016;       % (kg/kmol) Molecular weight of hydrogen

fc_cp_air = 1007;         % Specific Heat of Air  (J/kg-K)
%Cpwv = 1860;        % Specific heat of water vapor (J/kg-K) % not used in Model (tm:3/25/03)
fc_cp_h2o_l = 4178;       % Specific heat of water (J/(kg-K))

fc_k_air = 1.4;         % Specific heat ratio for air
% density_air = 1.19;  % assumed density of dry air entering compressor (kg/m^3) % not used in Model (tm:3/25/03)

%<<<<<<< 1.12
fc_system_init_temp = 340; % hot
%=======
%fc_system_init_temp = 340; % hot 

%fc_system_init_temp =vinf.init_conds.amb_tmp+273; % cold

fc_o2_percent=20.95; % percent O2 in inlet air
cyc_elevation_init=0;

%Revision notes
%----------------
%9/6/02:tm changed temp_max to comp_max_tmp since *temp* variables get cleared
%12/3/03: KH removed T_amb (will use the ADVISOR name in the Simulink model directly instead)
% 3/25/03:tm updated all parameter names to include the fc_ prefix so that they will appear in the editted variable pulldown menus
% 3/26/03:tm commented out the first instance of fc_cathode_pressure_drop_percentage
% 3/26/03:tm imported the coolant pump flow and power maps from the model so that they can be parametric
% 3/26/03:tm renamed fc_num_cells to fc_cell_num
% 3/26/03:tm removed fc_stack_cell_area from file and model - replaced with fc_cell_num*fc_cell_area
% 3/26/03:tm removed coolant pump min/max items
% tm:3/26/03 removed fc_cathode_humdity and replaced inside of model with fc_target_cathode_inlet_humidity
% 3/26/03:tm removed fc_lumped_capacitance and replaced with fc_cp_stack and fc_stack_unit_mass
% 3/26/03:tm removed fc_m_dot_air_min - not found in model
% 3/25/03:tm renamed fc_pressure_i_map_in and *out and fc_presure_temp_cor_map_in and *out
% 3/26/03:tm renamed fc_comp_smair_max to fc_comp_slpm_air_max 
% 3/26/03:tm changed units of fc_p_amb to be in atm
%3/27/03:tm changed units on compressor max speed
% 6/12/03:tm modified pressure and temperature operating strategy parameter values - reduced number of values necessary to define strategy
% 6/11/03: kh added fc_reference_temperature
% 7/31/03:tm removed fc_system_min_pwr_req - model revised to handle these conditions
% 7/31//03:tm change min temp for heat rejection to 333K to match the polarization curve reference temp
% 8/1/03:tm added two parameters used in the radiator model
% 8/7/03:tm defined air stoich as a vector as a function of current density
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel consumption indexed vertically by fc_map_spd and
% horizontally by fc_map_trq

%fc_pwr_map=[0 2 5	7.5	10	20	30	40	50]*1000; % kW (net) including parasitic losses
%fc_eff_map=[10 33 49.2	53.3	55.9	59.6	59.1	56.2	50.8]/100; % efficiency indexed by fc_pwr
 % two low power points are estimated
 
% create fuel use map (g/s)
%fc_fuel_map=[0.012 0.05 0.085 0.117 0.149 0.280 0.423 0.594 0.821]; % used in block diagram

% create fuel consumption map (g/kWh)
%fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
%fc_fuel_map_gpkWh=(1./fc_eff_map)/fc_fuel_lhv*3600*1000; % used in gui_inpchk plots

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
%fc_hc_map=zeros(size(fc_fuel_map));

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
%fc_co_map=zeros(size(fc_fuel_map));

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
%fc_nox_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
%fc_pm_map=zeros(size(fc_fuel_map));

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
%fc_o2_map=zeros(size(fc_fuel_map));

fc_emis=0;      % boolean 0=no emis data; 1=emis data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cold Engine Maps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
%fc_cold_tmp=20; %deg C
%fc_fuel_map_cold=zeros(size(fc_fuel_map));
%fc_hc_map_cold=zeros(size(fc_fuel_map));
%fc_co_map_cold=zeros(size(fc_fuel_map));
%fc_nox_map_cold=zeros(size(fc_fuel_map));
%fc_pm_map_cold=zeros(size(fc_fuel_map));
%Process Cold Maps to generate Correction Factor Maps
% names={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map'};
% for i=1:length(names)
%     %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
%     eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_pwr_scale=1.0;   % --  scale fc power
%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1.0; % -- scale the efficiency
fc_trq_scale=1.0; % -- required only for autosize and optimization routines
fc_spd_scale=1.0; % -- required only for autosize and optimization routines

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fc_fuel_cell_model=2; % 1--> polarization curves, 2--> pwr vs. eff, 3--> gctool model
fc_fuel_type='Hydrogen';
fc_fuel_den=0.018*1000; % (g/l), density of the fuel 
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
%fc_max_pwr=(max(fc_pwr_map)/1000)*fc_pwr_scale; % kW     peak engine power
%fc_base_mass=5.0*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 5 kg/kW (DOE 2000 status)
%fc_base_mass=2.5*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 2.5 kg/kW (DOE 2004 target)
%fc_acc_mass=0.5*fc_max_pwr;         % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 0.5 kg/kW ESTIMATE

% calculate the mass of fuel storage system
target_range=350; % mi
target_fe=80; % mpgge
gas_lhv=42.6*1000; % J/g
gas_dens=0.749*1000; % g/l
target_fuel_storage_spec_energy=2000; % Wh/kg from DOE targets
fc_fuel_mass=target_range/target_fe*3.785*gas_lhv*gas_dens/3600/target_fuel_storage_spec_energy; % (kg), fuel storage mass assuming specified range and specified fuel economy
clear gas_lhv gas_dens target_range target_fe target_fuel_storage_spec_energy 

% calculate the balance of plant mass
%--------------------------------------
fc_radiator_mass=fc_radiator_frontal_area*22.5; % (kg) estimate assumes 22.5 kg/m^2
%fc_radiator_mass=fc_radiator_heat_load-34; % (kg), heat load [kW]
fc_condenser_mass=fc_condenser_frontal_area*22.5; % (kg) estimate assumes 22.5 kg/m^2
%fc_air_comp_mass=fc_comp_slpm_air_max*0.003; % % (kg) estimate assumes 0.003 kg/slpm
fc_air_comp_mass=0.0036819*((fc_comp_slpm_air_max)/1000)^4-0.071942*((fc_comp_slpm_air_max)/1000)^3+0.41315*((fc_comp_slpm_air_max)/1000)^2+(0.0036819*((fc_comp_slpm_air_max)/1000)^4-0.071942*((fc_comp_slpm_air_max)/1000)^3+0.41315*((fc_comp_slpm_air_max)/1000)^2)/2;
% (kg) polynomial fit  based on Opcon compressors of size 1 + the motor of the compressor, normally half of the compressor mass KH 06/12/03
fc_humidifier_mass=(fc_cell_num*fc_cell_area*0.6*fc_min_cell_volts*0.2)/1000; % (kg) estimate assumes 0.2 kg/kW at 0.6 A/cm^2
fc_coolant_system_mass=fc_system_coolant_capacity*1.0*2; % (kg) estimate assumes 1 kg/L of coolant plus a 2x factor to account for plumbing

%scaling factors
fc_radiator_scale=1;
fc_condenser_scale=1;
fc_air_comp_scale=1;
fc_humidifier_scale=1;
fc_coolant_system_scale=1;

%fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
%fc_mass=max(fc_map_spd.*fc_max_trq)/132; % (kg), mass of the engine, assuming specific power of 132 W/kg

% variables not applicable to a fuel cell but needed for use of engine block diagram
%fc_tstat=80;                  % C      engine coolant thermostat set temperature (typically 80 +/- 5 C)
%fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)

%fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
%fc_ext_sarea=0.3;             % m^2    exterior surface area of engine
%fc_ext_sarea=2*(0.3*0.3)+4*(0.3*0.6);             % m^2    exterior surface area of engine
%fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
%fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
%fc_hood_emisv=0.9;            %        emissivity hood ext
%fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
%fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
% fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
% fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
% fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment
%fc_ex_pwr_frac=[0.40 0.30];                        % --   frac of waste heat that goes to exhaust as func of engine speed
%fc_ex_pwr_frac=[0.20 0.10];                        % --   frac of waste heat that goes to exhaust as func of power level, (SAE 2000-01-0373)
%fc_exflow_map=fc_fuel_map*(1+14.5);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
%fc_exflow_map=fc_fuel_map*(1+91);                % g/s  ex gas flow map:  for fuel cell  exflow=(fuel use)*[1 + (A/F ratio)], where 1.5*H2+2.0*(O2+3.774*N2)==>H20+0.5H2+0.5O2+2.0*3.774*N2, where 1.5=anode stoich, and 2.0=cathode stoich
%fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - fc_pwr_map;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
%fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
% for i=1:length(fc_pwr_map)
%  fc_ex_pwr_map(i)=fc_waste_pwr_map(i)*interp1([min(fc_pwr_map) max(fc_pwr_map)],fc_ex_pwr_frac,fc_pwr_map(i)); % W  pwr map of waste heat to exh 
% end
%fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) 
%fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1145/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) (cp based on exhaust composition listed above)

% user definable mass scaling functions
fc_bop_mass_scale_fun=inline('(fc_radiator_mass*(x(1)*fc_radiator_scale+x(2)))+(fc_air_comp_mass*(x(3)*fc_air_comp_scale+x(4)))+(fc_condenser_mass*(x(5)*fc_condenser_scale+x(6)))+(fc_coolant_system_mass*(x(7)*fc_coolant_system_scale+x(8)))+(fc_humidifier_mass*(x(9)*fc_humidifier_scale+x(10)))'...
    ,'x','fc_radiator_mass','fc_radiator_scale','fc_air_comp_mass','fc_air_comp_scale','fc_condenser_mass','fc_condenser_scale','fc_coolant_system_mass','fc_coolant_system_scale','fc_humidifier_mass','fc_humidifier_scale');
fc_bop_mass_scale_coef=[1 0 1 0 1 0 1 0 1 0]; % coefficients of bop mass scaling function

fc_mass_scale_fun=inline('(x(1)*fc_cell_num+x(2))*(x(3)*fc_cell_area+x(4))*(fc_stack_unit_mass)+fc_bop_mass+fc_fuel_mass','x','fc_cell_num','fc_cell_area','fc_stack_unit_mass','fc_fuel_mass','fc_bop_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function

fc_bop_mass=fc_bop_mass_scale_fun(fc_bop_mass_scale_coef,fc_radiator_mass,fc_radiator_scale,fc_air_comp_mass,fc_air_comp_scale,fc_condenser_mass,fc_condenser_scale,fc_coolant_system_mass,fc_coolant_system_scale,fc_humidifier_mass,fc_humidifier_scale);
fc_mass=fc_mass_scale_fun(fc_mass_scale_coef,fc_cell_num,fc_cell_area,fc_stack_unit_mass/1000,fc_fuel_mass,fc_bop_mass);

fc_plot_pwr_map=[1 2 5 10 15 20 25 35 45 55]*1000; % vector of power point at which to calc efficiency for plotting
fc_plot_tmp_map=[80]; % vector of temps at which to calculate effieicny for plotting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/12/02 (tm): file created 
% 6/6/03:tm added bop mass scale fun and bop scale factors
% 6/6/03:tm added vectors to control plot info
% 06/11/03: KH changed fc_humidifier_mass equation
% 06/12/03: KH changed fc_air_comp_mass
% 10/02/03:tm replaced fc_cathode_pressure_drop_percentage with fc_cathode_pressure_drop
% 10/2/03:tm revised polar_param_tafel and polar_param_concentration for revised concentration model impacts
% 10/2/03:Tm revised allowable temperature rise for better humidity control
% 10/2/03:tm revised stack unit mass to provide a system that corelates with the DOE current status
