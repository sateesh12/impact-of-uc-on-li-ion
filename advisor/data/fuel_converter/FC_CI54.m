% ADVISOR Data file:  FC_CI54.M
%
% Data source:  Data interpreted from "Internal Combustion Engine Fundamentals"
% by John B. Heywood, page 860, Figure 15-23.
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Engine performance map for a 1.987 L 5-cylinder, naturally aspirated 
% IDI swirl chamber diesel engine. 
% Data provided as g/kWh vs. RPM and BMEP.
% Engine Specs.
% Bore - 76.5 mm
% Stoke - 80.4 mm
% Compression Ratio - 23
% Maximum Power 54 kW @ 5000 rpm.
% Peak Torque 134 Nm @ 3000 rpm.
%
% Created on:  07/01/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='2.0L (54kW) Diesel Engine'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=1.987; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI54.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[1000:500:5000]*2*pi/60; 

% (N*m), torque range of the engine
fc_map_trq=[100:100:800]*1.987/6.28/2; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map_gpkWh = [
800	420	360	320	295	290	290	290
800	420	340	305	285	272	270	280
800	420	330	299	278	260	260	270
800	420	330	298	275	260	260	270
900	420	340	300	280	260	260	270
900	420	355	312	290	273	262	278
1000	470	370	330	300	290	285	290
1000	500	390	350	322	310	305	305
1000	520	420	365	345	340	340	340]; % (g/kW*hr)

% convert map from g/kWh to g/s
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map=fc_fuel_map_gpkWh.*fc_map_kW/3600;

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
fc_max_trq=[605 750 750 800 850 815 750 690 650]*1.987/6.28/2; 

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
fc_inertia=0.1*fc_pwr_scale;   % (kg*m^2),  rotational inertia of the engine (unknown)
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power

fc_base_mass=2.8*fc_max_pwr;            % (kg), mass of the engine block and head (base engine)
                                        %       assuming a mass penalty of 1.8 kg/kW from S. Sluder (ORNL) estimate of 300 lb 
fc_acc_mass=0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from 1994 OTA report, Table 3)
fc_fuel_mass=0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from 1994 OTA report, Table 3)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.85*1000; % (g/l), density of the fuel 
fc_fuel_lhv=43.0*1000; % (J/g), lower heating value of the fuel

%the following was added for the new thermal modeling of the engine 12/17/98 ss and sb
fc_tstat=99;                  % C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        eff emissivity of engine ext surface to hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment

% calc "predicted" exh gas flow rate and engine-out (EO) temp
fc_ex_pwr_frac=[0.50 0.40];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+20);                  % g/s  ex gas flow map:  for CI engines, exflow=(fuel use)*[1 + (ave A/F ratio)]
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

% cleanup workspace
clear fc_map_kW
clear T w fc_waste_pwr_map fc_ex_pwr_map spd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/01/98 (tm): file created from a_idi20l.m 
% 07/03/98 (MC): changed fc_init_coolant_temp to fc_coolant_init_temp
% 07/16/98 (SS): added variable fc_fuel_type under file id section
% 07/17/98 (tm): file renamed FC_CI54.M
% 08/17/98:tm estimated mass of the fuel converter changed from 1500lbs 
%             to 192 kg (specific power of 0.280 kW/kg)
% 08/28/98 (MC): added variable fc_disp under file id section
%                fc_ct_trq computed according to correlation from JDMA, 5/98
% 10/9/98 (vh,sb,ss): added pm and removed init conditions and added new exhaust variables
% 10/13/98 (MC): updated equation for fc_ct_trq (convert from ft-lb to Nm)
% 12/17/98 ss,sb: added 12 new variables for engine thermal modelling.
% 01/14/99 (SB): removed unneeded variables (fc_air_fuel_ratio, fc_ex_pwr_frac)
% 2/4/99: ss,sb changed fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67  it was 0.3*(fc_max_pwr/100)
%		it now takes into account that surface area increases based on mass to the 2/3 power 
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/9/99:tm cosmetic changes
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

