% ADVISOR Data file:  FC_CI250.M
%
% Data source:  Max Torque Curve and Fuel Economy at Max Torque from Caterpillar published spec sheet DM4840 02. 
% Remaining efficiency estimated based on other ADVISOR maps.  Efficiency points are estimated by scaling
% with FC_CI205.m as the base engine case.
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Data provided included, mass, max torque vs. spd, and fuel consumption @ full load vs. spd.
% All other information has been estimated!!
%
% Created on:  24 January 2002
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Engine Based on Max Torque Data for Caterpillar C-10 335 hp (250 kW) Diesel Engine--Speed governed to 2100 rpm'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=10.0; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI250.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd = [ 68.068  125.664  136.136  146.608  157.080  167.552  178.024  188.496  198.968  209.440  219.911 ]; % Map Speed in Radps
% (N*m), torque range of the engine
fc_map_trq = [ 200.000  400.000  600.000  800.000  1000.000  1136.000  1220.000  1303.000  1384.000  1464.000  1548.000  1616.000  1655.000  1681.000  1695.000 ]; % Map Torque in Nm


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map = [  1.360   2.461   3.506   4.571   5.656   6.385   6.837   7.283   7.717   8.144   8.605   8.983   9.200   9.344   9.422 
  1.683   3.053   4.336   5.646   6.977   7.879   8.433   8.982   9.518  10.044  10.598  11.056  11.323  11.501  11.597 
  1.895   3.343   4.735   6.132   7.544   8.507   9.100   9.690  10.270  10.846  11.456  11.953  12.242  12.434  12.537 
  2.126   3.643   5.146   6.632   8.124   9.148   9.778  10.411  11.032  11.662  12.331  12.873  13.183  13.390  13.502 
  2.319   3.922   5.502   7.086   8.697   9.800  10.480  11.163  11.831  12.508  13.225  13.806  14.139  14.361  14.481 
  2.510   4.190   5.836   7.528   9.255  10.442  11.178  11.906  12.627  13.355  14.121  14.742  15.097  15.335  15.462 
  2.696   4.438   6.184   7.984   9.823  11.079  11.871  12.664  13.448  14.226  15.042  15.703  16.082  16.334  16.471 
  2.893   4.692   6.545   8.463  10.410  11.747  12.616  13.474  14.312  15.139  16.008  16.711  17.114  17.383  17.528 
  3.045   4.990   6.952   8.983  11.036  12.463  13.384  14.295  15.184  16.061  16.983  17.729  18.157  18.442  18.596 
  3.185   5.288   7.349   9.511  11.665  13.185  14.160  15.123  16.063  16.992  17.967  18.756  19.209  19.510  19.673 
  3.351   5.622   7.770  10.008  12.306  13.907  14.935  15.951  16.943  17.922  18.950  19.783  20.260  20.578  20.750 ]; % fuel consumption by spd and torque in grams per sec 
% The above map was generated using the eng_map class based on the DDC 12.7 L engine


% generate the BSFC map
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000;
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
fc_fuel_map_c2h = fc_fuel_map_cold./(fc_fuel_map+eps);
fc_hc_map_c2h = fc_hc_map_cold./(fc_hc_map+eps);
fc_co_map_c2h = fc_co_map_cold./(fc_co_map+eps);
fc_nox_map_c2h = fc_nox_map_cold./(fc_nox_map+eps);
fc_pm_map_c2h = fc_pm_map_cold./(fc_pm_map+eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
fc_max_trq = [ 1610.250  1695.000  1681.000  1655.000  1616.000  1548.000  1464.000  1384.000  1303.000  1220.000  1136.000 ]; % Maximum Torque of the Engine Map in Nm

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

fc_base_mass=932.0;            % (kg), mass of the engine block and head (base engine)
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
% 24-Jan-2002: [mpo] file created using eng_map class and fc_ci205.m plus cat c-10 eng data (DM4840 02)