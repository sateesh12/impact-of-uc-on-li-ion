% ADVISOR Data file:  FC_ANL50H2.m
%
% Data source:  Romesh Kumar, Argonne National Lab
%
% Data confidence level:  
%
% Notes: Modeling results for a 50kW net fuel cell system operating on hydrogen.
%
% Created on:  08/28/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='ANL Model - 50kW (net) Ambient Pressure Hydrogen Fuel Cell System'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: FC_ANL50H2.m - ',fc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel consumption indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pwr_map=[0 2 5	7.5	10	20	30	40	50]*1000; % kW (net) including parasitic losses
fc_eff_map=[10 33 49.2	53.3	55.9	59.6	59.1	56.2	50.8]/100; % efficiency indexed by fc_pwr
 % two low power points are estimated
 
% create fuel use map (g/s)
fc_fuel_map=[0.012 0.05 0.085 0.117 0.149 0.280 0.423 0.594 0.821]; % used in block diagram

% create fuel consumption map (g/kWh)
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
fc_fuel_map_gpkWh=(1./fc_eff_map)/fc_fuel_lhv*3600*1000; % used in gui_inpchk plots

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map=zeros(size(fc_fuel_map));

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map=zeros(size(fc_fuel_map));

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map=zeros(size(fc_fuel_map));

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_o2_map=zeros(size(fc_fuel_map));

fc_emis=0;      % boolean 0=no emis data; 1=emis data

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
fc_fuel_cell_model=2; % 1--> polarization curves, 2--> pwr vs. eff, 3--> gctool model
fc_fuel_type='Hydrogen';
fc_fuel_den=0.018*1000; % (g/l), density of the fuel 
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
fc_max_pwr=(max(fc_pwr_map)/1000)*fc_pwr_scale; % kW     peak engine power
%fc_base_mass=5.0*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 5 kg/kW (DOE 2000 status)
fc_base_mass=2.5*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 2.5 kg/kW (DOE 2004 target)
fc_acc_mass=0.5*fc_max_pwr;         % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 0.5 kg/kW ESTIMATE
target_range=350; % mi
target_fe=80; % mpgge
gas_lhv=42.6*1000; % J/g
gas_dens=0.749*1000; % g/l
target_fuel_storage_spec_energy=2000; % Wh/kg from DOE targets
fc_fuel_mass=target_range/target_fe*3.785*gas_lhv*gas_dens/3600/target_fuel_storage_spec_energy; 
% (kg), fuel storage mass assuming specified range and specified fuel economy
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
%fc_mass=max(fc_map_spd.*fc_max_trq)/132; % (kg), mass of the engine, assuming specific power of 132 W/kg
clear gas_lhv gas_dens target_range target_fe target_fuel_storage_spec_energy 

% variables not applicable to a fuel cell but needed for use of engine block diagram
fc_tstat=80;                  % C      engine coolant thermostat set temperature (typically 80 +/- 5 C)
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
%fc_ex_pwr_frac=[0.40 0.30];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_ex_pwr_frac=[0.20 0.10];                        % --   frac of waste heat that goes to exhaust as func of power level, (SAE 2000-01-0373)
%fc_exflow_map=fc_fuel_map*(1+14.5);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
fc_exflow_map=fc_fuel_map*(1+91);                % g/s  ex gas flow map:  for fuel cell  exflow=(fuel use)*[1 + (A/F ratio)], where 1.5*H2+2.0*(O2+3.774*N2)==>H20+0.5H2+0.5O2+2.0*3.774*N2, where 1.5=anode stoich, and 2.0=cathode stoich
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - fc_pwr_map;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(fc_pwr_map)
 fc_ex_pwr_map(i)=fc_waste_pwr_map(i)*interp1([min(fc_pwr_map) max(fc_pwr_map)],fc_ex_pwr_frac,fc_pwr_map(i)); % W  pwr map of waste heat to exh 
end
%fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) 
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1145/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C) (cp based on exhaust composition listed above)

% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98 (tm): file created 
% 9/5/98:sam added fc_eff_scale
% 09/15/98:MC set fc_inertia to zero
% 10/9/98 (vh,sb,ss): added pm and removed init conditions and added new exhaust variables
% 12/17/98 ss,sb: added 12 new variables for engine thermal modelling.
% 03/15/99:MC corrected hydroden typo in fc_description
% 3/15/99:ss updated fc_version to 2.1 (was 2.0)
% 7/6/99:tm cosmetic changes and added fc_fuel_gpkWh variable for ploting
% 7/9/99:ss moved clear command from middle of file and joined it with the clear command at end of file.
% 7/9/99:tm updated trq definition to avoid divide by zero errors
% 11/03/99:ss updated version from 2.2 to 2.21
% 4/10/00:tm updated parameters in thermal section
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)

% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
% 4/3/02: kh updated version from 3.2 to 2002, removed a second fc_fuel_lhv, added Opcon Autorotor Compressor data
% 4/18/02:tm updated cp of exhaust composition from that of gasoline combustion exhaust
% 4/26/02:tm removed low power estimate point from efficiency and power vectors - caused interpolation errors
% 4/26/02:tm removed fuel cell system auxilary system information - not applicable to this model type with intro of config systems
% 4/29/02:tm updated mass relationships with current target data
% 4/29/02:tm replaced fc_fuel_map calculation with actual data