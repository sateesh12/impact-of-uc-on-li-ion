% ADVISOR Data file:  FC_SI30.M
%
% Data source:  Data provided by University of Maryland for their 
% converted 3-cylinder Subaru Justy engine.
%
% Data confidence level:  
%
% Notes:  Engine fuel injectors and cylinder heads were converted by 
% University of Maryland to use M85 fuel. Data was provided as efficiency 
% as a function of torque (ft-lb) and speed (rpm). It is converted to a 
% fuel use table, g/kWh as a function of torque (Nm) and speed (rad/s).
% This is the same engine as that modeled in a_geo1l.m  the specific power here is 
% the value for that model scaled by the ratio of the respective maximum powers.
% Maximum Power 30 kW @ 3500 rpm.
% Fuel Converter Peak Torque 81 Nm @ 3500 rpm.
%
% Created on:  06/17/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.
%

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Univ. of Maryland 30kW M85 Engine'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='M85';
fc_disp=1.0; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI30.m - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
%fc_map_spd=[0,1000:500:4500]*pi/30; 
fc_map_spd=[1000:500:4500]*pi/30; 

% (N*m), torque range of the engine
fc_map_trq=[5:5:60]*1.356; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_eff_map=[0.118	0.112	0.107	0.118	0.113	0.102	0.095	0.084
0.165	0.165	0.167	0.168	0.168	0.158	0.151	0.148
0.199	0.199	0.206	0.211	0.213	0.199	0.191	0.179
0.229	0.229	0.238	0.239	0.236	0.228	0.211	0.190
0.253	0.253	0.251	0.250	0.252	0.244	0.226	0.209
0.265	0.265	0.266	0.268	0.267	0.261	0.247	0.228
0.275	0.275	0.279	0.282	0.275	0.273	0.258	0.232
0.284	0.284	0.290	0.293	0.287	0.282	0.257	0.224
0.290	0.290	0.294	0.298	0.297	0.289	0.256	0.224
0.294	0.294	0.302	0.307	0.305	0.294	0.256	0.224
0.294	0.294	0.302	0.312	0.311	0.306	0.256	0.224
0.294	0.294	0.302	0.312	0.311	0.311	0.256	0.224];
% fuel converter efficiency map in decimal percent
fc_eff_map=fc_eff_map'; % invert map 

% convert efficiency to g/s fuel consumption
% specific calorific values in MJ/kg from Bosch handbook 3rd ed. page 232
meth_spec_cal=19.7;                                % specific calorific value for methanol, MJ/kg
gas_spec_cal=42.7;                                 % specific calorific value for gasoline, MJ/kg
M85_spec_cal=.85*meth_spec_cal+.15*gas_spec_cal;   % specific calorific value for M85, MJ/kg
fc_fuel_lhv= 1000*M85_spec_cal;                    % (J/g), lower heating value of the fuel 23150 J/g
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=(T.*w/1000);
fc_fuel_map=(fc_map_kW./fc_eff_map)*(1000/fc_fuel_lhv);
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;

% minimum speed in above data is 1000 rpm--assume BSFC at zero speed is 4*BSFC at 1000 rpm
%fc_fuel_map=[1*fc_fuel_map(1,:) ; fc_fuel_map];

% minimum torque in above data is 6.8 Nm--assume BSFC at zero torque is 4*BSFC at 6.8 Nm
%fc_fuel_map=[1*fc_fuel_map(:,1) fc_fuel_map];

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
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
%fc_max_trq=[0 5 50 50 55 55 60 45 40]*1.356; 
fc_max_trq=[5 50 50 55 55 60 45 40]*1.356; 

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd -- correlation from JDMA
fc_ct_trq=4.448/3.281*(-fc_disp)*61.02/24 * ...
   (9*(fc_map_spd/max(fc_map_spd)).^2 + 14 * (fc_map_spd/max(fc_map_spd)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
fc_spd_scale=1.0;
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
fc_trq_scale=1.0;
fc_pwr_scale=fc_spd_scale*fc_trq_scale;   % --  scale fc power

% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF THAT SCALES WITH TRQ & SPD SCALES (MASS AND INERTIA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_inertia=0.1*fc_pwr_scale;           % (kg*m^2), rotational inertia of the engine (unknown)
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power

fc_base_mass=1.38*1.8*fc_max_pwr;            % (kg), mass of the engine block and head (base engine)
                                        %       mass penalty of 1.8 kg/kW from 1994 OTA report, Table 3 
fc_acc_mass=1.38*0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=1.38*0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from OTA report)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
% estimated assuming a specific energy of 0.285 kW/kg (including exhaust and
% other accessories) and a 0.726 ratio of M85 max power to gasoline max power
%fc_mass=max(fc_map_spd.*fc_max_trq)/(0.726*0.285*1000); % (kg)
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=(790*.85)+(835*.15); % (g/l), density of the fuel
% g/L volumetric weighted sum densities from Bosch handbook 3rd ed. page 232

% note: densities are so close that 85% by volume is roughly 85% by mass
% the lines below would verify this.
% meth_mpercent=(790*.85)/fuel_mden;               % mass percent methanol
% gas_mpercent=(835*.15)/fuel_mden;                % mass percent gasoline

% specific calorific values in MJ/kg from Bosch handbook 3rd ed. page 232
meth_spec_cal=19.7;                                % specific calorific value for methanol, MJ/kg
gas_spec_cal=42.7;                                 % specific calorific value for gasoline, MJ/kg
M85_spec_cal=.85*meth_spec_cal+.15*gas_spec_cal;   % specific calorific value for M85, MJ/kg
fc_fuel_lhv= 1000*M85_spec_cal;                    % (J/g), lower heating value of the fuel
% 23150 J/g
clear meth_spec_cal gas_spec_cal M85_spec_cal

%the following was added for the new thermal modeling of the engine 12/17/98 ss and sb
fc_tstat=96;                  % C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment

% calc "predicted" exh gas flow rate and engine-out (EO) temp
fc_ex_pwr_frac=[0.40 0.30];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+7.6);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
[T,w]=meshgrid(fc_map_trq, fc_map_spd);           % Nm, rad/s   full map of mech out pwr (incl 0 spd & trq)
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - T.*w;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
spd=fc_map_spd;
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(spd)
 fc_ex_pwr_map(i,:)=fc_waste_pwr_map(i,:)*interp1([min(spd) max(spd)],fc_ex_pwr_frac,spd(i)); % W  trq-spd map of waste heat to exh 
end
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1;

% clean up workspace
clear fc_map_kW fc_eff_map; 
clear T w fc_waste_pwr_map fc_ex_pwr_map spd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06/23/98 (tm): created from a_dodg3l.m
% 07/06/98 (MC): corrected max power calc. in mass calc.
%                renamed fc_init_coolant_temp to fc_coolant_init_temp
% 07/17/98 (tm): file renamed FC_SI102.M
% 07/16/98 (SS): added variable fc_fuel_type under file id section
% 07/17/98 (tm): fc_fuel_den changed from 0.737 to 0.749 and fc_fuel_lhv changed from 42.7 to 42.6
% 07/30/98 (sb): added A/F ratio and split of waste heat variables
% 10/9/98 (vh,sb,ss): added pm and removed init conditions and added new exhaust variables
% 10/13/98 (MC): added variable fc_disp under file id section
%                fc_ct_trq computed according to correlation from JDMA, 5/98
% 10/13/98 (MC): updated equation for fc_ct_trq (convert from ft-lb to Nm)
% 12/17/98 ss,sb: added 12 new variables for engine thermal modelling.
% 01/25/99 (SB): modified thermal section to work with new BD, revised FC mass calc's
% 2/4/99: ss,sb changed fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67  it was 0.3*(fc_max_pwr/100)
%		it now takes into account that surface area increases based on mass to the 2/3 power 
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/9/99:tm cosmetic changes and removed 0 spd and 0 trq data
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

