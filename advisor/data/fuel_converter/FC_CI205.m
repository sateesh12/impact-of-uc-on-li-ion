% ADVISOR Data file:  FC_CI205.M
%
% Data source:  Max torque curve and speed range based on data presented at SAE TOPTEC 
% on the Future of Hybrid vehicles (5/99). Efficiency data based on data in FC_CI330 (DDC S60).
%
% Data confidence level:  no comparison has been performed
%
% Notes:   
%
% Created on:  06/07/99
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Detroit Diesel Corp. Series 50 8.5 (205kW) Diesel Engine'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=8.5;  % (L), engine displacement % unknown
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI205.m - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[1200 1350 1500 1650 1800 2100]*2*pi/60; 

% (N*m), torque range of the engine
fc_map_trq=[200 400 600 800 1000 1200 1400 1600 1800]*1205/1959; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map_gpkWh = [
242	220	207	201.5	198.5	197	195.5	194.5	193.5
261	220	207	200	195	192.5	190.5	189.5	189.5
273	224	207	198	194.5	192	190.5	189.5	189.5
288	228	209	200.5	196	193.5	191.5	191.5	191.5
288	238	217	207.5	203	199.5	197.5	197.5	197.5
290	244	222	210.5	204.5	202.5	199.5	199.5	199.5]; % (g/kW*hr)
% fc_fuel_map elements (1,1), (5,9), (6,8), (6,9), (7,8), (7,9) 
% have been estimated in order to complete the table.

% pad maps with idle conditions
fc_idle_spd=650;
fc_map_spd=[fc_idle_spd*pi/30 fc_map_spd];
fc_fuel_map_gpkWh=[fc_fuel_map_gpkWh(1,:)*1.05; fc_fuel_map_gpkWh];

% convert map from gpkwh to gps
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map=fc_fuel_map_gpkWh.*fc_map_kW/3600;

%fc_fuel_map=[fc_fuel_map(:,1) fc_fuel_map]; % pad with zero torque column
%fc_map_trq=[0 fc_map_trq]; % add zero torque column

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
fc_max_trq=[100 203 223 242 259 275 275]*745.7./fc_map_spd; 
% raw data provided as HP vs. spd
% first data point added to account for idle speed condition

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
%fc_mass=2500/2.2046;                   % (kg), mass of the engine
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine

fc_inertia=fc_mass*(1/3+1/3*2/3)*(0.075^2); 
% assumes 1/3 purely rotating mass, 1/3 purely oscillating, and 1/3 stationary
% and crank radius of 0.075m, 2/3 of oscilatting mass included in rotational inertia calc
% correlation from Bosch handbook p.379

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function


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
fc_ex_pwr_frac=[0.45 0.35];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+25);                  % g/s  ex gas flow map:  for CI engines, exflow=(fuel use)*[1 + (ave A/F ratio)]
[T,w]=meshgrid(fc_map_trq, fc_map_spd);           % Nm, rad/s   full map of mech out pwr (incl 0 trq)
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
clear T w fc_waste_pwr_map fc_ex_pwr_map spd fc_map_kW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06/07/99 (tm): file created from a_ci330.m 
% 11/03/99:ss updated version from 2.2 to 2.21
% 8/18/00:tm revised fc_inertia calculation, reduced equiv. radius from 0.15m to 0.075m
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

