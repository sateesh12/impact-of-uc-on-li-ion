% ADVISOR Data file:  FC_CI321.M
%
% Data source:  Max Torque curve and Fuel Efficiency at Max Torque from Caterpillar published spec sheet DM6006 02 all 
% remaining data has been estimated! All other efficiency points are estimated by scaling
% with FC_CI303.m as the base engine case.
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Data provided included, mass, max torque vs. spd, and fuel consumption @ full load vs. spd.
% All other information has been estimated!!
%
% Created on:  29 November 2001
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Engine Based on Max Torque data for Caterpillar C-12 430 hp (321 kW) Diesel Engine--Speed governed to 2100 rpm'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=12.0; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI321.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd = [ 68.068  125.664  136.136  146.608  157.080  167.552  178.024  188.496  198.968  209.440  219.911 ]; % Map Speed in Radps
% (N*m), torque range of the engine
fc_map_trq = [ 200.000  400.000  600.000  800.000  1000.000  1200.000  1400.000  1458.000  1558.000  1660.000  1760.000  1863.000  1978.000  2095.000  2125.150  2173.000  2224.000  2237.000 ]; % Map Torque in Nm


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map = [  1.369   2.525   3.563   4.598   5.648   6.711   7.775   8.080   8.609   9.150   9.678  10.219  10.831  11.468  11.633  11.895  12.174  12.245 
  1.685   3.135   4.422   5.688   6.976   8.279   9.593   9.971  10.619  11.284  11.936  12.606  13.349  14.118  14.317  14.639  14.983  15.071 
  1.913   3.470   4.849   6.221   7.598   8.980  10.382  10.787  11.482  12.193  12.898  13.626  14.446  15.284  15.502  15.851  16.223  16.318 
  2.163   3.806   5.271   6.751   8.217   9.670  11.160  11.590  12.331  13.089  13.846  14.628  15.531  16.449  16.686  17.062  17.462  17.564 
  2.369   4.100   5.645   7.195   8.753  10.333  11.927  12.392  13.189  14.013  14.822  15.675  16.640  17.624  17.878  18.280  18.709  18.819 
  2.589   4.383   6.008   7.628   9.302  11.010  12.722  13.221  14.085  14.969  15.846  16.769  17.804  18.858  19.129  19.560  20.019  20.136 
  2.812   4.694   6.408   8.149   9.951  11.778  13.610  14.148  15.090  16.059  17.024  18.020  19.132  20.264  20.556  21.019  21.512  21.638 
  3.074   5.044   6.865   8.763  10.712  12.681  14.644  15.245  16.291  17.357  18.403  19.480  20.682  21.906  22.221  22.721  23.255  23.391 
  3.261   5.427   7.421   9.474  11.563  13.674  15.799  16.447  17.575  18.725  19.853  21.015  22.313  23.632  23.972  24.512  25.088  25.234 
  3.458   5.832   7.997  10.181  12.445  14.684  16.975  17.677  18.890  20.126  21.339  22.587  23.982  25.400  25.766  26.346  26.964  27.122 
  3.686   6.295   8.572  10.857  13.220  15.679  18.079  18.828  20.120  21.437  22.728  24.058  25.543  27.054  27.444  28.061  28.720  28.888 ]; % fuel consumption by spd and torque in grams per sec
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
fc_max_trq = [ 2125.150  2237.000  2224.000  2173.000  2095.000  1978.000  1863.000  1760.000  1660.000  1558.000  1458.000 ]; % Maximum Torque of the Engine Map in Nm

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

fc_base_mass=940.0;            % (kg), mass of the engine block and head (base engine)
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
% 24-Jan-2002: [mpo] file created using eng_map class and fc_ci330.m plus cat c-12 eng data (DM6006 02)