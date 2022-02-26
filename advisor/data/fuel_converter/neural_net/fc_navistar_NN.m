% ADVISOR Data file:  FC_navistar_NN.M
%
% Data source:  Max Torque Curve by speed for a cummins engine
%
% Data confidence level:  no comparison has been performed
%
% Notes:  No fuel economy information provided with this map--40% constant efficiency assumed. This map is a "dummy" map 
% used mainly for the performance and inertia information. Fuel economy and emissions (CO & NOx) are determined via 
% neural network emissions prediction equations (fuel determined from CO2)
%
% Created on:  05 April 2002
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_OKeefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='175 HP Navistar T 444E Performance Map for use with Neural Network Post-processing Model'; % one line descriptor identifying the engine
fc_version=2002; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel';
fc_disp=7.3; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_navistar_NN.M - ',fc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neural Network Specific Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% neural net model name (see help in lib_fuel_converter 'configurable subsystems\fuel use and EO emis Neural Network Model'
% for a list of choices)
fc_nn_model_name='1994NavistarT444E';
% conversion factor CO2-->fuel (D2)
fc_CO2_to_FUELgps=0.334; % grams of diesel fuel per gram of CO2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd = [ 52.360  57.596  62.832  68.068  73.304  78.540  83.776  89.012  94.248  99.484  104.720  109.956  115.192  120.428  125.664  130.900  136.136  141.372  146.608  151.844  157.080  162.316  167.552  172.788  178.024  183.260  188.496  193.732  198.968  204.204  209.440  214.675  219.911  225.147  230.383  235.619  240.855  246.091  251.327  256.563  261.799  267.035  272.271  277.507  282.743 ]; % Map Speed in Radps
% (N*m), torque range of the engine
fc_map_trq = [  1 50:50:350 393.772  415.813  428.408  452.471  481.796  496.344  507.293  522.718  541.865  556.848  565.170  573.120  588.978  601.006  614.585  625.872  642.007  653.127  664.643  671.547  680.525  689.727  694.500 700.569  706.137 ]; % Map Torque in Nm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map = [  0.003   0.152   0.304   0.457   0.609   0.761   0.913   1.065   1.199   1.266   1.304   1.377   1.467   1.511   1.544   1.591   1.650   1.695   1.720   1.745   1.793   1.830   1.871   1.905   1.954   1.988   2.023   2.044   2.072   2.100   2.114   2.133   2.150 
  0.003   0.167   0.335   0.502   0.670   0.837   1.005   1.172   1.319   1.392   1.435   1.515   1.613   1.662   1.699   1.750   1.814   1.865   1.893   1.919   1.972   2.013   2.058   2.096   2.150   2.187   2.226   2.249   2.279   2.310   2.326   2.346   2.365 
  0.004   0.183   0.365   0.548   0.731   0.913   1.096   1.279   1.438   1.519   1.565   1.653   1.760   1.813   1.853   1.910   1.979   2.034   2.065   2.094   2.152   2.195   2.245   2.286   2.345   2.386   2.428   2.453   2.486   2.520   2.537   2.559   2.580 
  0.004   0.198   0.396   0.594   0.791   0.989   1.187   1.385   1.558   1.646   1.695   1.791   1.907   1.964   2.008   2.069   2.144   2.204   2.237   2.268   2.331   2.378   2.432   2.477   2.541   2.585   2.630   2.658   2.693   2.730   2.748   2.772   2.794 
  0.004   0.213   0.426   0.639   0.852   1.065   1.279   1.492   1.678   1.772   1.826   1.928   2.053   2.115   2.162   2.228   2.309   2.373   2.409   2.443   2.510   2.561   2.619   2.667   2.736   2.784   2.833   2.862   2.900   2.940   2.960   2.986   3.009 
  0.005   0.228   0.457   0.685   0.913   1.142   1.370   1.598   1.798   1.899   1.956   2.066   2.200   2.266   2.316   2.387   2.474   2.543   2.581   2.617   2.689   2.744   2.806   2.858   2.932   2.982   3.035   3.066   3.107   3.149   3.171   3.199   3.224 
  0.005   0.244   0.487   0.731   0.974   1.218   1.461   1.705   1.918   2.025   2.087   2.204   2.347   2.418   2.471   2.546   2.639   2.712   2.753   2.791   2.869   2.927   2.993   3.048   3.127   3.181   3.237   3.271   3.315   3.359   3.383   3.412   3.439 
  0.005   0.259   0.518   0.776   1.035   1.294   1.553   1.811   2.038   2.152   2.217   2.342   2.493   2.569   2.625   2.705   2.804   2.882   2.925   2.966   3.048   3.110   3.181   3.239   3.322   3.380   3.440   3.475   3.522   3.569   3.594   3.626   3.654 
  0.005   0.274   0.548   0.822   1.096   1.370   1.644   1.918   2.158   2.278   2.347   2.479   2.640   2.720   2.780   2.864   2.969   3.051   3.097   3.140   3.227   3.293   3.368   3.429   3.518   3.579   3.642   3.680   3.729   3.779   3.806   3.839   3.869 
  0.006   0.289   0.578   0.868   1.157   1.446   1.735   2.024   2.278   2.405   2.478   2.617   2.787   2.871   2.934   3.023   3.134   3.221   3.269   3.315   3.407   3.476   3.555   3.620   3.713   3.778   3.844   3.884   3.936   3.989   4.017   4.052   4.084 
  0.006   0.304   0.609   0.913   1.218   1.522   1.827   2.131   2.397   2.532   2.608   2.755   2.933   3.022   3.089   3.183   3.299   3.390   3.441   3.489   3.586   3.659   3.742   3.811   3.909   3.976   4.047   4.089   4.143   4.199   4.228   4.265   4.299 
  0.006   0.320   0.639   0.959   1.279   1.598   1.918   2.237   2.517   2.658   2.739   2.893   3.080   3.173   3.243   3.342   3.464   3.560   3.613   3.664   3.765   3.842   3.929   4.001   4.104   4.175   4.249   4.293   4.350   4.409   4.440   4.479   4.514 
  0.007   0.335   0.670   1.005   1.339   1.674   2.009   2.344   2.637   2.785   2.869   3.030   3.227   3.324   3.397   3.501   3.629   3.729   3.785   3.838   3.945   4.025   4.116   4.192   4.300   4.374   4.451   4.497   4.558   4.619   4.651   4.692   4.729 
  0.007   0.350   0.700   1.050   1.400   1.750   2.100   2.451   2.757   2.911   3.000   3.168   3.373   3.475   3.552   3.660   3.794   3.899   3.957   4.013   4.124   4.208   4.303   4.382   4.495   4.573   4.654   4.702   4.765   4.829   4.863   4.905   4.944 
  0.007   0.365   0.731   1.096   1.461   1.827   2.192   2.557   2.877   3.038   3.130   3.306   3.520   3.626   3.706   3.819   3.959   4.068   4.129   4.187   4.303   4.391   4.490   4.573   4.691   4.772   4.856   4.906   4.972   5.039   5.074   5.118   5.159 
  0.008   0.381   0.761   1.142   1.522   1.903   2.283   2.664   2.997   3.165   3.260   3.444   3.667   3.777   3.861   3.978   4.124   4.238   4.301   4.362   4.482   4.574   4.677   4.763   4.886   4.971   5.058   5.111   5.179   5.249   5.285   5.332   5.374 
  0.008   0.396   0.791   1.187   1.583   1.979   2.374   2.770   3.117   3.291   3.391   3.581   3.813   3.929   4.015   4.137   4.289   4.407   4.473   4.536   4.662   4.757   4.864   4.954   5.081   5.169   5.261   5.315   5.386   5.459   5.497   5.545   5.589 
  0.008   0.411   0.822   1.233   1.644   2.055   2.466   2.877   3.237   3.418   3.521   3.719   3.960   4.080   4.170   4.296   4.454   4.577   4.645   4.711   4.841   4.940   5.051   5.144   5.277   5.368   5.463   5.520   5.593   5.669   5.708   5.758   5.804 
  0.009   0.426   0.852   1.279   1.705   2.131   2.557   2.983   3.356   3.544   3.652   3.857   4.107   4.231   4.324   4.456   4.619   4.746   4.817   4.885   5.020   5.123   5.239   5.335   5.472   5.567   5.665   5.724   5.801   5.879   5.920   5.971   6.019 
  0.009   0.441   0.883   1.324   1.766   2.207   2.648   3.090   3.476   3.671   3.782   3.994   4.253   4.382   4.478   4.615   4.784   4.916   4.989   5.060   5.200   5.306   5.426   5.525   5.668   5.766   5.868   5.929   6.008   6.089   6.131   6.185   6.234 
  0.009   0.457   0.913   1.370   1.827   2.283   2.740   3.196   3.596   3.797   3.912   4.132   4.400   4.533   4.633   4.774   4.949   5.085   5.161   5.234   5.379   5.489   5.613   5.716   5.863   5.965   6.070   6.133   6.215   6.299   6.343   6.398   6.449 
  0.009   0.472   0.944   1.416   1.887   2.359   2.831   3.303   3.716   3.924   4.043   4.270   4.547   4.684   4.787   4.933   5.114   5.255   5.333   5.409   5.558   5.672   5.800   5.906   6.059   6.164   6.272   6.337   6.422   6.509   6.554   6.611   6.664 
  0.010   0.487   0.974   1.461   1.948   2.435   2.922   3.409   3.836   4.051   4.173   4.408   4.693   4.835   4.942   5.092   5.279   5.424   5.506   5.583   5.737   5.855   5.987   6.097   6.254   6.362   6.475   6.542   6.629   6.719   6.765   6.825   6.879 
  0.010   0.502   1.005   1.507   2.009   2.511   3.014   3.516   3.956   4.177   4.304   4.545   4.840   4.986   5.096   5.251   5.443   5.594   5.678   5.757   5.917   6.038   6.174   6.287   6.449   6.561   6.677   6.746   6.836   6.929   6.977   7.038   7.094 
  0.010   0.518   1.035   1.553   2.070   2.588   3.105   3.623   4.076   4.304   4.434   4.683   4.987   5.137   5.251   5.410   5.608   5.764   5.850   5.932   6.096   6.221   6.361   6.478   6.645   6.760   6.879   6.951   7.044   7.139   7.188   7.251   7.309 
  0.011   0.533   1.065   1.598   2.131   2.664   3.196   3.729   4.196   4.430   4.565   4.821   5.133   5.288   5.405   5.569   5.773   5.933   6.022   6.106   6.275   6.404   6.548   6.668   6.840   6.959   7.082   7.155   7.251   7.349   7.400   7.464   7.524 
  0.011   0.548   1.096   1.644   2.192   2.740   3.288   3.836   4.315   4.557   4.695   4.959   5.280   5.439   5.559   5.729   5.938   6.103   6.194   6.281   6.455   6.586   6.735   6.859   7.036   7.158   7.284   7.360   7.458   7.559   7.611   7.678   7.739 
  0.011   0.563   1.126   1.690   2.253   2.816   3.379   3.942   4.435   4.684   4.825   5.096   5.427   5.591   5.714   5.888   6.103   6.272   6.366   6.455   6.634   6.769   6.922   7.050   7.231   7.356   7.486   7.564   7.665   7.769   7.822   7.891   7.954 
  0.012   0.578   1.157   1.735   2.314   2.892   3.470   4.049   4.555   4.810   4.956   5.234   5.573   5.742   5.868   6.047   6.268   6.442   6.538   6.630   6.813   6.952   7.109   7.240   7.427   7.555   7.689   7.768   7.872   7.979   8.034   8.104   8.169 
  0.012   0.594   1.187   1.781   2.374   2.968   3.562   4.155   4.675   4.937   5.086   5.372   5.720   5.893   6.023   6.206   6.433   6.611   6.710   6.804   6.993   7.135   7.297   7.431   7.622   7.754   7.891   7.973   8.079   8.189   8.245   8.317   8.383 
  0.012   0.609   1.218   1.827   2.435   3.044   3.653   4.262   4.795   5.063   5.217   5.510   5.867   6.044   6.177   6.365   6.598   6.781   6.882   6.979   7.172   7.318   7.484   7.621   7.818   7.953   8.093   8.177   8.287   8.399   8.457   8.531   8.598 
  0.012   0.624   1.248   1.872   2.496   3.120   3.744   4.368   4.915   5.190   5.347   5.647   6.013   6.195   6.332   6.524   6.763   6.950   7.054   7.153   7.351   7.501   7.671   7.812   8.013   8.152   8.295   8.382   8.494   8.609   8.668   8.744   8.813 
  0.013   0.639   1.279   1.918   2.557   3.196   3.836   4.475   5.035   5.316   5.477   5.785   6.160   6.346   6.486   6.683   6.928   7.120   7.226   7.328   7.530   7.684   7.858   8.002   8.208   8.351   8.498   8.586   8.701   8.819   8.880   8.957   9.028 
  0.013   0.654   1.309   1.963   2.618   3.272   3.927   4.581   5.154   5.443   5.608   5.923   6.307   6.497   6.640   6.842   7.093   7.289   7.398   7.502   7.710   7.867   8.045   8.193   8.404   8.549   8.700   8.791   8.908   9.028   9.091   9.170   9.243 
  0.013   0.670   1.339   2.009   2.679   3.349   4.018   4.688   5.274   5.570   5.738   6.061   6.453   6.648   6.795   7.001   7.258   7.459   7.570   7.677   7.889   8.050   8.232   8.383   8.599   8.748   8.902   8.995   9.115   9.238   9.302   9.384   9.458 
  0.014   0.685   1.370   2.055   2.740   3.425   4.110   4.795   5.394   5.696   5.869   6.198   6.600   6.799   6.949   7.161   7.423   7.628   7.742   7.851   8.068   8.233   8.419   8.574   8.795   8.947   9.105   9.199   9.322   9.448   9.514   9.597   9.673 
  0.014   0.700   1.400   2.100   2.801   3.501   4.201   4.901   5.514   5.823   5.999   6.336   6.747   6.950   7.104   7.320   7.588   7.798   7.914   8.026   8.248   8.416   8.606   8.764   8.990   9.146   9.307   9.404   9.530   9.658   9.725   9.810   9.888 
  0.014   0.715   1.431   2.146   2.862   3.577   4.292   5.008   5.634   5.949   6.129   6.474   6.893   7.101   7.258   7.479   7.753   7.967   8.086   8.200   8.427   8.599   8.793   8.955   9.186   9.345   9.509   9.608   9.737   9.868   9.937  10.023  10.103 
  0.015   0.731   1.461   2.192   2.922   3.653   4.384   5.114   5.754   6.076   6.260   6.612   7.040   7.253   7.413   7.638   7.918   8.137   8.258   8.374   8.606   8.782   8.980   9.145   9.381   9.544   9.712   9.813   9.944  10.078  10.148  10.237  10.318 
  0.015   0.746   1.492   2.237   2.983   3.729   4.475   5.221   5.874   6.202   6.390   6.749   7.187   7.404   7.567   7.797   8.083   8.306   8.430   8.549   8.785   8.965   9.167   9.336   9.576   9.742   9.914  10.017  10.151  10.288  10.359  10.450  10.533 
  0.015   0.761   1.522   2.283   3.044   3.805   4.566   5.327   5.994   6.329   6.521   6.887   7.333   7.555   7.721   7.956   8.248   8.476   8.602   8.723   8.965   9.148   9.355   9.526   9.772   9.941  10.116  10.222  10.358  10.498  10.571  10.663  10.748 
  0.016   0.776   1.553   2.329   3.105   3.881   4.658   5.434   6.113   6.456   6.651   7.025   7.480   7.706   7.876   8.115   8.413   8.645   8.774   8.898   9.144   9.331   9.542   9.717   9.967  10.140  10.319  10.426  10.565  10.708  10.782  10.877  10.963 
  0.016   0.791   1.583   2.374   3.166   3.957   4.749   5.540   6.233   6.582   6.782   7.162   7.627   7.857   8.030   8.274   8.578   8.815   8.946   9.072   9.323   9.514   9.729   9.907  10.163  10.339  10.521  10.630  10.773  10.918  10.994  11.090  11.178 
  0.016   0.807   1.613   2.420   3.227   4.034   4.840   5.647   6.353   6.709   6.912   7.300   7.773   8.008   8.185   8.434   8.743   8.984   9.119   9.247   9.503   9.697   9.916  10.098  10.358  10.538  10.723  10.835  10.980  11.128  11.205  11.303  11.393 
  0.016   0.822   1.644   2.466   3.288   4.110   4.932   5.753   6.473   6.835   7.042   7.438   7.920   8.159   8.339   8.593   8.907   9.154   9.291   9.421   9.682   9.880  10.103  10.288  10.554  10.736  10.926  11.039  11.187  11.338  11.417  11.516  11.608 ]; % fuel consumption by spd and torque in grams per sec 
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
fc_max_trq = [ 393.772  393.772  393.772  393.772  393.772  407.130  421.101  428.007  452.938  481.562  496.344  512.057  522.441  541.865  556.848  566.398  573.120  599.392  651.225  671.663  696.033  704.101  704.291  704.332  701.154  700.612  697.750  696.643  699.336  700.182  698.053  697.991  694.777  694.540  687.834  671.636  657.764  638.677  619.972  603.280  586.135   0.000   0.000   0.000   0.000 ]; % Maximum Torque of the Engine Map in Nm


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