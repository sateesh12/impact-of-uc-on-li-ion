% ADVISOR Data file:  FC_CI324.M
%
% Data source:  Max torque curve and speed range and fuel consumption at max torque created from
% data from Caterpillar engine spec DM4908 01. All other efficiency points are estimated by scaling
% with FC_CI303.m as the base engine case.
%
% Data confidence level:  no comparison has been performed
%
% Created on:  2002 January 23
% By:  Michael O'Keefe, National Renewable Energy Laboratory, michael_okeefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Engine Based on Max Torque Data for Caterpillar C-15 (rated power: 324kW) Diesel Engine'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=15.0;  % (L), engine displacement % unknown
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI324.m - ',fc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map Speed in Radps
fc_map_spd = [ 68.068  125.664  136.136  146.608  157.080  167.552  178.024  188.496  198.968  209.440  219.911 ]; % Map Speed in Radps
% Map Torque in Nm
fc_map_trq = [ 200.000  400.000  600.000  800.000  1000.000  1200.000  1400.000  1477.000  1584.000  1600.000  1687.000  1781.000  1800.000  1886.000  1996.900  2000.000  2004.000  2102.000 ]; % Map Torque in Nm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
% fuel consumption by spd and torque in grams per sec 
fc_fuel_map = [  1.378   2.515   3.549   4.600   5.661   6.738   7.803   8.214   8.784   8.870   9.331   9.828   9.928  10.394  11.004  11.021  11.043  11.583 
  1.696   3.123   4.406   5.691   6.993   8.312   9.628  10.131  10.833  10.938  11.509  12.123  12.247  12.805  13.544  13.565  13.592  14.256 
  1.929   3.454   4.845   6.234   7.623   9.023  10.434  10.973  11.727  11.840  12.459  13.129  13.265  13.885  14.687  14.710  14.740  15.460 
  2.195   3.826   5.322   6.825   8.309   9.794  11.302  11.881  12.684  12.808  13.476  14.196  14.346  15.031  15.915  15.940  15.971  16.752 
  2.438   4.224   5.813   7.408   9.010  10.636  12.276  12.911  13.788  13.922  14.647  15.430  15.591  16.327  17.287  17.314  17.348  18.197 
  2.738   4.643   6.358   8.070   9.832  11.635  13.441  14.142  15.118  15.264  16.060  16.931  17.108  17.924  18.978  19.008  19.046  19.977 
  3.037   5.075   6.923   8.799  10.737  12.705  14.679  15.446  16.533  16.696  17.588  18.566  18.764  19.660  20.816  20.849  20.890  21.912 
  3.342   5.491   7.466   9.517  11.630  13.766  15.896  16.751  17.964  18.146  19.133  20.199  20.414  21.389  22.647  22.682  22.728  23.839 
  3.484   5.818   7.931  10.122  12.347  14.595  16.858  17.763  19.050  19.242  20.289  21.419  21.648  22.682  24.016  24.053  24.101  25.280 
  3.565   6.023   8.260  10.496  12.831  15.131  17.486  18.432  19.767  19.967  21.052  22.225  22.462  23.536  24.920  24.958  25.008  26.231 
  3.645   6.240   8.489  10.753  13.077  15.512  17.868  18.848  20.213  20.418  21.528  22.727  22.970  24.067  25.482  25.522  25.573  26.824 ]; % fuel consumption by spd and torque in grams per sec

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
fc_fuel_map_c2h = fc_fuel_map_cold./(fc_fuel_map+eps);
fc_hc_map_c2h = fc_hc_map_cold./(fc_hc_map+eps);
fc_co_map_c2h = fc_co_map_cold./(fc_co_map+eps);
fc_nox_map_c2h = fc_nox_map_cold./(fc_nox_map+eps);
fc_pm_map_c2h = fc_pm_map_cold./(fc_pm_map+eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
fc_max_trq = [ 1996.900  2102.000  2102.000  2102.000  2102.000  2004.000  1886.000  1781.000  1687.000  1584.000  1477.000 ]; % Maximum Torque of the Engine Map in Nm

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

fc_base_mass=1225;            % (kg), mass of the engine block and head (base engine)
fc_acc_mass=1.0;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from 1994 OTA report, Table 3)
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
fc_fuel_lhv = 42780.000; % lower heating value of fuel (J/g)

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
% dd-mmm-yyyy
% 23-Jan-2002: [mpo] file created using eng_map class and fc_ci303.m plus cat c-15 eng data (DM4908-01)