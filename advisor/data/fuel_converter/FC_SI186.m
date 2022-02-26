% ADVISOR Data file:  FC_SI186.M
%
% Data source:  Fuel consumption data was provided by Keith Vertin (NREL).
% Performance data from John Deere spec sheet.
%
% Data confidence level:  no comparison has been performed
%
% Notes: Turbocharged spark ignited compressed natural gas engine.
% Max torque - 1085 Nm @ 1300 rpm
% Max power - 186 kW @ 2200 rpm
% Idle speed - 650 rpm
% Bore X Stroke - 116 mm X 129 mm
%
% Created on:  05/20/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='John Deere 8.1L (186kW) CNG SI Engine'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='CNG';
fc_disp=8.1; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI186.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[600 800 1000 1200 1400 1600 1800 2000 2200]*2*pi/60; 

% (N*m), torque range of the engine
fc_map_trq=[1 50 100 200 300 400 500 600 700 800]*1055/778.16; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_map_bte = [
8	13 21	28.5	29.5	35.5	35.5	36	36.5	36.5
10	15 20	30	35	37.3	37.6	37.8	37.6	37.3
13	17 22	31	36	38	38.2	38.5	38.5	38.5
14	20 26.5	30.5	35.6	37.1	37.5	37.8	38.2	39.1
16	20 23.5	33.2	35.5	37	37.8	38.5	39.2	39.5
18	20.5 23	32.4	35.1	37.2	37.9	38.5	39.2	39.5
18.5 21	23.9	31.7	34.9	36.6	37.6	38.2	38.9	39.3
19	21.2 24	31	34.5	35.8	37.3	37.9	38.3 38.3
19	20.5 21	30	33.6	36.1	37	36.9	37.5	37.5]./100; 
% brake thermal efficiency in decimal percent

% convert map from bte to gps
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_lhv=47.0*1000; % (J/g), lower heating value of CNG
fc_fuel_map=1/fc_fuel_lhv./fc_map_bte.*fc_map_kW*1000;
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;


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
fc_max_trq=[400 500 687.5 785 790 762.5 715 665 597]*1055/778.16;
% unknown

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
%fc_mass=667;                            % (kg), mass of the engine
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine

fc_inertia=fc_mass*(1/3+1/3*2/3)*(0.15^2) ;
% assumes 1/3 purely rotating mass, 1/3 purely oscillating, and 1/3 stationary
% and crank radius of 0.15m, 2/3 of oscilatting mass included in rotational inertia calc
% correlation from Bosch handbook p.379

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.217*1000; % (g/l), density of the fuel 
fc_fuel_lhv=47.0*1000; % (J/g), lower heating value of the fuel

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
fc_exflow_map=fc_fuel_map*(1+17);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
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
clear fc_map_kW fc_map_bte;
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
% 7/9/99:tm cosmetic changes
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

