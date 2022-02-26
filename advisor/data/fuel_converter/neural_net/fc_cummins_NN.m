% ADVISOR Data file:  FC_cummins.M
%
% Data source:  Max Torque Curve by speed for a 1999 Cummins ISM 370 HP engine tested at WVU (note--max. torque by 
% speed only!). No fuel economy data present. This map uses a dummy 100% efficiency at all points.
%
% Data confidence level:  no comparison has been performed
%
% Notes:  No fuel economy information provided with this map--40% constant efficiency assumed. This map is a "dummy" map 
% used only for the performance and inertia information. Fuel economy and emissions (CO & NOx) are determined via 
% corresponding neural network emissions prediction equations (fuel determined from CO2)
%
% Created on:  05 April 2002
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_OKeefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Cummins Performance Map for use with Neural Network Post-processing Model'; % one line descriptor identifying the engine
fc_version=2002; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=10.0; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_cummins.M - ',fc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neural Network Specific Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% neural net model name (see help in lib_fuel_converter 'configurable subsystems\fuel use and EO emis Neural Network Model'
% for a list of choices)
fc_nn_model_name='1999CumminsISM370';
% conversion factor CO2-->fuel (D2)
fc_CO2_to_FUELgps=0.334; % grams of diesel fuel per gram of CO2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd = [ 52.569  57.805  63.041  68.277  73.513  78.749  83.985  89.221  94.457  99.693  104.929  110.165  115.401  120.637  125.873  131.109  136.345  141.581  146.817  152.053  157.289  162.525  167.761  172.997  178.233  183.469  188.705  193.941  199.177  204.413  209.649  214.885  220.121  225.357  230.593  235.829  241.065 ]; % Map Speed in Radps
% (N*m), torque range of the engine
fc_map_trq = [  1.000  100.000  200.000  300.000  400.000  500.000  600.000  700.000  800.000  900.000  1000.000  1100.000  1200.000  1300.000  1400.000  1500.000  1600.000  1700.000 ]; % Map Torque in Nm


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map = [  0.003   0.306   0.611   0.917   1.223   1.528   1.834   2.139   2.445   2.751   3.056   3.362   3.668   3.973   4.279   4.585   4.890   5.196 
  0.003   0.336   0.672   1.008   1.344   1.680   2.016   2.353   2.689   3.025   3.361   3.697   4.033   4.369   4.705   5.041   5.377   5.713 
  0.004   0.367   0.733   1.100   1.466   1.833   2.199   2.566   2.932   3.299   3.665   4.032   4.398   4.765   5.131   5.498   5.864   6.231 
  0.004   0.397   0.794   1.191   1.588   1.985   2.382   2.779   3.176   3.573   3.970   4.367   4.764   5.160   5.557   5.954   6.351   6.748 
  0.004   0.427   0.855   1.282   1.710   2.137   2.564   2.992   3.419   3.847   4.274   4.701   5.129   5.556   5.984   6.411   6.838   7.266 
  0.005   0.458   0.916   1.374   1.831   2.289   2.747   3.205   3.663   4.121   4.578   5.036   5.494   5.952   6.410   6.868   7.325   7.783 
  0.005   0.488   0.977   1.465   1.953   2.441   2.930   3.418   3.906   4.395   4.883   5.371   5.859   6.348   6.836   7.324   7.813   8.301 
  0.005   0.519   1.037   1.556   2.075   2.594   3.112   3.631   4.150   4.669   5.187   5.706   6.225   6.743   7.262   7.781   8.300   8.818 
  0.005   0.549   1.098   1.648   2.197   2.746   3.295   3.844   4.393   4.943   5.492   6.041   6.590   7.139   7.688   8.238   8.787   9.336 
  0.006   0.580   1.159   1.739   2.318   2.898   3.478   4.057   4.637   5.216   5.796   6.376   6.955   7.535   8.115   8.694   9.274   9.853 
  0.006   0.610   1.220   1.830   2.440   3.050   3.660   4.270   4.880   5.490   6.101   6.711   7.321   7.931   8.541   9.151   9.761  10.371 
  0.006   0.640   1.281   1.921   2.562   3.202   3.843   4.483   5.124   5.764   6.405   7.045   7.686   8.326   8.967   9.607  10.248  10.888 
  0.007   0.671   1.342   2.013   2.684   3.355   4.026   4.697   5.367   6.038   6.709   7.380   8.051   8.722   9.393  10.064  10.735  11.406 
  0.007   0.701   1.403   2.104   2.806   3.507   4.208   4.910   5.611   6.312   7.014   7.715   8.417   9.118   9.819  10.521  11.222  11.923 
  0.007   0.732   1.464   2.195   2.927   3.659   4.391   5.123   5.855   6.586   7.318   8.050   8.782   9.514  10.245  10.977  11.709  12.441 
  0.008   0.762   1.525   2.287   3.049   3.811   4.574   5.336   6.098   6.860   7.623   8.385   9.147   9.909  10.672  11.434  12.196  12.958 
  0.008   0.793   1.585   2.378   3.171   3.964   4.756   5.549   6.342   7.134   7.927   8.720   9.512  10.305  11.098  11.891  12.683  13.476 
  0.008   0.823   1.646   2.469   3.293   4.116   4.939   5.762   6.585   7.408   8.231   9.055   9.878  10.701  11.524  12.347  13.170  13.993 
  0.009   0.854   1.707   2.561   3.414   4.268   5.122   5.975   6.829   7.682   8.536   9.389  10.243  11.097  11.950  12.804  13.657  14.511 
  0.009   0.884   1.768   2.652   3.536   4.420   5.304   6.188   7.072   7.956   8.840   9.724  10.608  11.492  12.376  13.260  14.144  15.028 
  0.009   0.914   1.829   2.743   3.658   4.572   5.487   6.401   7.316   8.230   9.145  10.059  10.974  11.888  12.803  13.717  14.632  15.546 
  0.009   0.945   1.890   2.835   3.780   4.725   5.669   6.614   7.559   8.504   9.449  10.394  11.339  12.284  13.229  14.174  15.119  16.064 
  0.010   0.975   1.951   2.926   3.901   4.877   5.852   6.827   7.803   8.778   9.754  10.729  11.704  12.680  13.655  14.630  15.606  16.581 
  0.010   1.006   2.012   3.017   4.023   5.029   6.035   7.041   8.046   9.052  10.058  11.064  12.070  13.075  14.081  15.087  16.093  17.099 
  0.010   1.036   2.072   3.109   4.145   5.181   6.217   7.254   8.290   9.326  10.362  11.399  12.435  13.471  14.507  15.544  16.580  17.616 
  0.011   1.067   2.133   3.200   4.267   5.333   6.400   7.467   8.533   9.600  10.667  11.733  12.800  13.867  14.934  16.000  17.067  18.134 
  0.011   1.097   2.194   3.291   4.388   5.486   6.583   7.680   8.777   9.874  10.971  12.068  13.165  14.263  15.360  16.457  17.554  18.651 
  0.011   1.128   2.255   3.383   4.510   5.638   6.765   7.893   9.021  10.148  11.276  12.403  13.531  14.658  15.786  16.913  18.041  19.169 
  0.012   1.158   2.316   3.474   4.632   5.790   6.948   8.106   9.264  10.422  11.580  12.738  13.896  15.054  16.212  17.370  18.528  19.686 
  0.012   1.188   2.377   3.565   4.754   5.942   7.131   8.319   9.508  10.696  11.884  13.073  14.261  15.450  16.638  17.827  19.015  20.204 
  0.012   1.219   2.438   3.657   4.876   6.094   7.313   8.532   9.751  10.970  12.189  13.408  14.627  15.846  17.064  18.283  19.502  20.721 
  0.012   1.249   2.499   3.748   4.997   6.247   7.496   8.745   9.995  11.244  12.493  13.743  14.992  16.241  17.491  18.740  19.989  21.239 
  0.013   1.280   2.560   3.839   5.119   6.399   7.679   8.958  10.238  11.518  12.798  14.078  15.357  16.637  17.917  19.197  20.476  21.756 
  0.013   1.310   2.620   3.931   5.241   6.551   7.861   9.172  10.482  11.792  13.102  14.412  15.723  17.033  18.343  19.653  20.963  22.274 
  0.013   1.341   2.681   4.022   5.363   6.703   8.044   9.385  10.725  12.066  13.407  14.747  16.088  17.429  18.769  20.110  21.451  22.791 
  0.014   1.371   2.742   4.113   5.484   6.855   8.227   9.598  10.969  12.340  13.711  15.082  16.453  17.824  19.195  20.566  21.938  23.309 
  0.014   1.402   2.803   4.205   5.606   7.008   8.409   9.811  11.212  12.614  14.015  15.417  16.818  18.220  19.622  21.023  22.425  23.826 ]; % fuel consumption by spd and torque in grams per sec 
% The above map was generated using eng_map class

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
fc_max_trq = [ 889.259  889.259  889.259  889.259  889.259  1065.232  1103.655  1184.320  1264.641  1354.784  1462.877  1554.315  1622.788  1664.554  1688.313  1687.219  1684.247  1686.292  1681.155  1659.840  1639.878  1605.957  1576.492  1527.713  1468.158  1422.177  1382.751  1356.398  1336.872  1296.034  1250.356  1204.588  1146.816  1049.136  774.280  460.777  104.133 ]; % Maximum Torque of the Engine Map in Nm


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
fc_fuel_lhv = 43000.000; % lower heating value of fuel (J/g)

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
% 05-April-2002: [mpo] file created using eng_map class and max. torque and speed data from WVU
% 26-April-2002: [mpo] updated version to 2002