% ADVISOR Data file:  FC_IFC50.m
%
% Data source:  Presentation slide from Jim Ohi(NREL) on DOE Success Stories.
%
% Data confidence level:  Good. Reported as a DOE Success Story.
%
% Notes: IFC 50kW net hydrogen fuel cell stack.
%
% Created on:  07/17/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='International Fuel Cells 50kW(net) Ambient Pressure Hydroden Fuel Cell Stack'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_IFC50.m - ',fc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel consumption indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pwr_map=[0.5 2.5 5 10 15 20 25 30 35 40 45 50]*1000; % W (net) including parasitic losses
fc_eff_map=[33 52.5 57.5 60 59 58 57 56 55 53 51 48]/100; % efficiency indexed by fc_pwr_map
% low power point is estimated

% create fuel use map (g/s)
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
fc_fuel_map=fc_pwr_map./fc_eff_map./fc_fuel_lhv; % used in block diagram

% create fuel consumption map (g/kWh)
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

% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_cell_model=2; % 1--> polarization curves, 2--> pwr vs. eff, 3--> gctool model
fc_fuel_type='Hydrogen';
fc_fuel_den=0.018*1000; % (g/l), density of the fuel 
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel
fc_max_pwr=max(fc_pwr_map)/1000; % kW     peak engine power
% fc_base_mass=2.0*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 2 kg/kW
% fc_acc_mass=1.0*fc_max_pwr;         % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 1 kg/kW 
% fc_fuel_mass=0.6*fc_max_pwr;  % kg   mass of fuel and fuel tank 
fc_base_mass=5.0*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 5 kg/kW (DOE 2000 status)
%fc_base_mass=2.5*fc_max_pwr;        % kg   mass of the fuel cell stack, assuming mass penalty of 2.5 kg/kW (DOE 2004 target)
fc_acc_mass=0.5*fc_max_pwr;         % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 0.5 kg/kW ESTIMATE
target_range=350; % mi
target_fe=80; % mpgge
gas_lhv=42.6*1000; % J/g
gas_dens=0.749*1000; % g/l
target_fuel_storage_spec_energy=1500; % Wh/kg estimated 2000 status
%target_fuel_storage_spec_energy=2000; % Wh/kg from DOE targets
fc_fuel_mass=target_range/target_fe*3.785*gas_lhv*gas_dens/3600/target_fuel_storage_spec_energy; 
% (kg), fuel storage mass assuming specified range and specified fuel economy
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
clear gas_lhv gas_dens target_range target_fe target_fuel_storage_spec_energy 
%fc_mass=300/2.205; % (kg), mass of the engine

% variables not applicable to a fuel cell but needed for use of engine block diagram
%fc_tstat=94;                  % C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_tstat=80;  % tm:6/30/00                % C      engine coolant thermostat set temperature (typically 80 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
%fc_ext_sarea=0.3;             % m^2    exterior surface area of engine
fc_ext_sarea=2*(0.3*0.3)+4*(0.3*0.6); % tm:6/30/00            % m^2    exterior surface area of engine
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment
%fc_ex_pwr_frac=[0.40 0.30];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_ex_pwr_frac=[0.20 0.10];   % tm:6/30/00                     % --   frac of waste heat that goes to exhaust as func of power level, (SAE 2000-01-0373)
%fc_exflow_map=fc_fuel_map*(1+14.5);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
fc_exflow_map=fc_fuel_map*(1+91);  % tm:6/30/00              % g/s  ex gas flow map:  for fuel cell  exflow=(fuel use)*[1 + (A/F ratio)], where 1.5*H2+2.0*(O2+3.774*N2)==>H20+0.5H2+0.5O2+2.0*3.774*N2, where 1.5=anode stoich, and 2.0=cathode stoich
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - fc_pwr_map;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(fc_pwr_map)
 fc_ex_pwr_map(i)=fc_waste_pwr_map(i)*interp1([min(fc_pwr_map) max(fc_pwr_map)],fc_ex_pwr_frac,fc_pwr_map(i)); % W  pwr map of waste heat to exh 
end
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98 (tm): file created 
% 9/5/98:sam added fc_eff_scale
% 09/15/98:MC set fc_inertia to zero
% 10/9/98 (vh,sb,ss): added pm and removed init conditions and added new exhaust variables
% 12/17/98 ss,sb: added 12 new variables for engine thermal modelling.
% 01/25/99 (SB): modified thermal section to work with new BD, revised FC mass calc's
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/6/99:tm cosmetic changes and added fc_fuel_gpkWh variable for ploting
% 7/9/99:tm updated to avoid divide by sero errors
% 9/14/99:tm removed all references to spd and trq
% 6/30/00:tm modified thermal parameters to more appropriatly represent a fuel cell system
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
% 4/4/02: kh changed ADVISOR version from 3.2. to 2002, added Opcon Autorotor screw compressor data
% 4/26/02:tm removed fuel cell system auxilary system information - not applicable to this model type with intro of config systems
% 4/29/02:tm updated mass breakdown to be based on 2000 status points - no available data