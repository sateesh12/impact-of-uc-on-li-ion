% ADVISOR Data file:  FC_CI162_emis_ft_poly.m
%
% Data source: Engine datafile for the Navistar T444/ Powerstroke 7.3L engines tested on Fischer Tropes fuel
% Data from John Orban of Batelle through contract to do data collection and analysis.  
% These data were collected under the DECSE program and the engines were tested on the OICA test matrix.
%
% Useful links,
%
% DECSE program site
% http://www.ott.doe.gov//decse/
%
% APBF program site (formerly DECSE)
% http://www.ott.doe.gov/advanced_petroleum.shtml
%
% OICA test details
% http://www.dieselnet.com/standards/cycles/esc.html
%
% Data confidence level: 
%
% Notes: 
% File created by engmodel using mat file: p_stroke_ft.mat;
% Points outside of data points extrapolated based on the following algorithm: polynomial;
% Map: fc_fuel_map;
%  Average error (%): 2.2591;
%  Maximum error (g/s): 0.11131;
%  max error at speed (rpm): 1600;
%  max error at torque (Nm): 202.6;
% Map: fc_nox_map;
%  Average error (%): 3.9606;
%  Maximum error (g/s): -0.0039516;
%  max error at speed (rpm): 1600;
%  max error at torque (Nm): 202.6;
% Map: fc_pm_map;
%  Average error (%): 3.8836;
%  Maximum error (g/s): 3.6239e-005;
%  max error at speed (rpm): 1350;
%  max error at torque (Nm): 348.5
%
% Created on:  01-Aug-2000 09:11:22
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Powerstroke 7.3L Diesel Engine tested at Ricardo (Fischer Tropsche Fuel)';  
fc_version=2003;  				% version of ADVISOR for which the file was generated
fc_proprietary=1;  	% 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0;  		% 1=> no validation, 1=> data agrees with source data, 
							% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Fischer-Tropsch'; 
fc_disp=7.3;   			% (L), engine displacement
fc_emis=1;       				% boolean 0=no emis data; 1=emis data
disp(['Data loaded: FC_CI162_emis_ft_poly.m - ',fc_description]); 

% Use EGR? 1==> yes, 0==> no
fc_egr_bool=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[73.3 99.48 125.7 151.8 178 204.2 230.4 256.6 282.7]; 

% (N*m), torque range of the engine
fc_map_trq=[15 55 95 135 175 215 255 295 335 375 415 455 495 535 575 615 655]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map=[0.2894 0.4495 0.6295 0.8287 1.047 1.283 1.538 1.81 2.101;
0.376 0.6294 0.7723 0.9566 1.222 1.524 1.861 2.232 2.639;
0.5679 0.8511 0.9941 1.288 1.731 2.173 2.616 2.76 3.283;
0.8051 1.09 1.216 1.556 1.986 2.429 2.871 3.313 3.972;
1.066 1.213 1.482 1.836 2.242 2.685 3.338 3.99 4.685;
1.34 1.483 1.765 2.119 2.712 3.364 4.016 4.668 5.41;
1.619 1.759 2.057 2.411 3.17 4.043 4.695 5.347 6.141;
1.899 2.036 2.312 2.72 3.608 4.496 5.373 6.025 6.873;
2.176 2.31 2.6 3.158 4.046 4.934 5.822 6.704 7.603;
2.449 2.579 2.883 3.36 4.555 5.436 6.317 7.199 8.327;
2.714 2.841 3.159 3.666 5.113 5.995 6.876 7.757 9.044;
2.97 3.094 3.425 3.964 4.709 6.553 7.435 8.316 9.752;
3.216 3.337 3.682 4.251 5.045 7.112 7.993 8.875 10.45;
3.451 3.568 3.927 4.527 5.368 6.45 8.552 9.433 11.14;
3.673 3.787 4.16 4.791 5.68 6.827 8.231 9.992 11.81;
3.883 3.993 4.379 5.041 5.979 7.19 8.677 10.55 12.47;
4.078 4.185 4.585 5.278 6.263 7.54 9.108 10.97 13.12]'; 


% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map =[0.006567 0.00303 2.22e-016 2.22e-016 2.22e-016 0.0003815 0.005004 0.01227 0.02236;
0.005903 0.01222 0.01316 0.01415 0.0165 0.0194 0.02313 0.02791 0.03389;
0.001681 0.01718 0.01811 0.02712 0.02945 0.03179 0.03412 0.03998 0.04185;
2.22e-016 0.02352 0.02307 0.03821 0.0424 0.04474 0.04707 0.0494 0.04862;
2.22e-016 0.01554 0.03121 0.04736 0.05535 0.05767 0.05807 0.05846 0.05502;
2.22e-016 0.01698 0.04103 0.05717 0.06631 0.06671 0.06711 0.06751 0.0615;
2.22e-016 0.01877 0.05233 0.06848 0.07387 0.07575 0.07615 0.07655 0.06832;
2.22e-016 0.02108 0.05684 0.07931 0.0813 0.08328 0.08519 0.08559 0.07567;
2.22e-016 0.02407 0.06536 0.08674 0.08872 0.09071 0.09269 0.09463 0.08369;
2.22e-016 0.02782 0.07466 0.1083 0.1022 0.1036 0.105 0.1064 0.09248;
2.22e-016 0.03242 0.08481 0.1224 0.1198 0.1213 0.1227 0.1241 0.1021;
2.22e-016 0.03794 0.09587 0.1374 0.163 0.1389 0.1404 0.1418 0.1127;
2.22e-016 0.04442 0.1079 0.1533 0.1813 0.1566 0.1581 0.1595 0.1242;
2.22e-016 0.05191 0.1209 0.1703 0.2006 0.2121 0.1757 0.1772 0.1367;
2.22e-016 0.06046 0.135 0.1883 0.221 0.2332 0.2254 0.1949 0.1503;
2.22e-016 0.07008 0.1502 0.2075 0.2424 0.2554 0.2467 0.2125 0.165;
2.22e-016 0.08082 0.1665 0.2277 0.2649 0.2786 0.269 0.2363 0.1807]';  

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map=[0.0001475 0.0002926 0.0004491 0.0006005 0.0007362 0.0008484 0.0009318 0.0009819 0.0009954;
0.0004408 0.0004174 0.0006214 0.0007912 0.0009155 0.001028 0.001123 0.001196 0.001243;
0.0005735 0.0004385 0.0006424 0.000754 0.0008771 0.001 0.001123 0.001249 0.001331;
0.0006413 0.0004418 0.0006635 0.0007212 0.0008342 0.0009574 0.00108 0.001204 0.001353;
0.0006782 0.0006408 0.0006517 0.0006992 0.0007913 0.0009145 0.001047 0.001179 0.001345;
0.000702 0.000619 0.0006147 0.0006622 0.000758 0.0008905 0.001023 0.001155 0.001324;
0.0007239 0.0005952 0.0005445 0.000592 0.0007174 0.0008664 0.0009988 0.001131 0.0013;
0.0007513 0.000577 0.0004942 0.0005252 0.0006753 0.0008254 0.0009748 0.001107 0.001282;
0.0007897 0.0005698 0.0004528 0.0004831 0.0006333 0.0007834 0.0009335 0.001083 0.001275;
0.0008433 0.0005778 0.0004265 0.0003729 0.0006454 0.0007904 0.0009353 0.00108 0.001284;
0.0009153 0.0006042 0.0004187 0.0003423 0.0006961 0.0008411 0.000986 0.001131 0.001311;
0.001008 0.0006517 0.000432 0.0003328 0.0003434 0.0008917 0.001037 0.001182 0.001358;
0.001125 0.0007224 0.0004685 0.0003465 0.0003457 0.0009424 0.001087 0.001232 0.001429;
0.001266 0.0008181 0.00053 0.0003852 0.0003731 0.000486 0.001138 0.001283 0.001525;
0.001434 0.0009404 0.0006181 0.0004505 0.000427 0.00054 0.0007839 0.001334 0.001648;
0.00163 0.001091 0.0007341 0.0005438 0.0005089 0.0006219 0.0008773 0.001384 0.001799;
0.001855 0.00127 0.0008791 0.000666 0.0006198 0.0007328 0.0009997 0.001416 0.001978]'; 


% create BS** maps for plotting purposes
[T,w]=meshgrid(fc_map_trq,fc_map_spd); 
fc_map_kW=T.*w/1000; 
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600; 
fc_co_map_gpkWh=fc_co_map./fc_map_kW*3600; 
fc_hc_map_gpkWh=fc_hc_map./fc_map_kW*3600; 
fc_nox_map_gpkWh=fc_nox_map./fc_map_kW*3600; 
fc_pm_map_gpkWh=fc_pm_map./fc_map_kW*3600; 


% 7/24/00:tm added
% build basic egr map
if fc_egr_bool
   egr_spd_percent_index=[0 50 55 60 65 70 75 80 85 90 95 100];
   egr_load_percent_index=[0 10 20 30 40 50 60 70 80 90 100];
   egr_def_map=[30 30 30 26.1 20.7 15.8 12.1 9.96 7.74 6 6.25;
      30 30 30 26.1 20.7 15.8 12.1 9.96 7.74 6 6.25;
      30 30 30 26.22 20.93 16.06 12.33 10.12 7.926 6.164 6.224;
      30 30 30 26.17 20.93 16.34 12.93 10.79 9.179 7.297 6.308;
      30 30 30 26.02 21.29 17.01 14.16 12.23 10.72 9.187 8.31;
      30 30 29.9 25.88 21.56 18.06 15.7 13.88 12.38 11.16 10.32;
      30 30 29.18 25.98 22.38 19.22 17.4 15.97 14.73 13.64 12.7;
      30 30 28.85 26.27 23.17 20.59 19 18.03 17.13 16.27 15.7;
      30 30 28.74 26.5 23.91 21.66 20.21 19.45 18.92 18.61 18.35;
      29.9 29.9 28.44 26.52 24.59 22.67 21.39 20.79 20.43 20.2 20.2;
      29.3 29.3 28.43 26.99 25.29 23.79 22.8 22.3 22.3 22.3 22.3;
      29.3 29.3 28.47 27.06 25.38 23.9 22.86 22.3 22.3 22.3 22.3];
   fc_egr_map=interp2(egr_spd_percent_index, egr_load_percent_index, egr_def_map', (fc_map_spd./max(fc_map_spd)*100)', fc_map_trq./max(fc_map_trq)*100)';
else
   fc_egr_map=zeros(size(fc_fuel_map));
end
clear egr_spd_percent_index egr_load_percent_index egr_def_map
% 7/24/00:tm end added

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
spd=[500 1000 1500 2000 2500 3000]*pi/30; % Ford Website
trq=[300 400 500 490 475 400]*1.35671; % Ford Website
fc_max_trq=interp1(spd,trq,fc_map_spd);

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd -- correlation from JDMA
fc_ct_trq=4.448/3.281*(-fc_disp)*61.02/24 * ...
   (9*(fc_map_spd/max(fc_map_spd)).^2 + 14 * (fc_map_spd/max(fc_map_spd))); 

fc_ct_trq=interp1([0 100],[0.11 0.18],fc_map_spd/max(fc_map_spd)*100).*fc_max_trq*(-1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
fc_spd_scale=1.0; 
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
fc_trq_scale=1.0; 
fc_pwr_scale=fc_spd_scale*fc_trq_scale;    % --  scale fc power

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF THAT SCALES WITH TRQ & SPD SCALES (MASS AND INERTIA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fc_inertia=0.1*fc_pwr_scale;            % (kg*m^2), rotational inertia of the engine
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale;  % kW     peak engine power
fc_base_mass=2.8*fc_max_pwr;              	% (kg), mass of the engine block and head (base engine)
                                        				% mass penalty of 1.8 kg/kW from 1994 OTA report, Table 3 
fc_acc_mass=1.0*fc_max_pwr;              	% kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=0.6*fc_max_pwr;             	% kg    mass of fuel and fuel tank
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass;  		% kg  total engine/fuel system mass
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;        		% m^2    exterior surface area of engine

fc_inertia=fc_base_mass*(1/3+1/3*2/3)*(0.08^2); 
% assumes 1/3 purely rotating mass, 1/3 purely oscillating, and 1/3 stationary
% and crank radius of 0.08m, 2/3 of oscilatting mass included in rotational inertia calc
% correlation from Bosch handbook p.379

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=777;  					% (g/l), density of the fuel 
fc_fuel_lhv=43880;  							% (J/g), lower heating value of the fuel

fc_tstat=96;                   			% C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=500;                     		% J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                   		% J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_hood_sarea=1.5;             		% m^2    surface area of hood/eng compt.
fc_emisv=.8;                  		%        emissivity of engine ext surface/hood int surface
fc_hood_emisv=.9;             		%        emissivity hood ext
fc_h_air_flow=0;             		% kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=.7;               		% --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;            		% W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;            		% W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;             		% W/K    conductance btwn engine & engine compartment

% calculate "predicted" exh gas flow rate and engine-out (EO) temp
%fc_ex_pwr_frac=[0.40 0.30];                         % --   frac of waste heat that goes to exhaust as func of engine speed
fc_ex_pwr_frac=[0.50 0.40];                         % --   frac of waste heat that goes to exhaust as func of engine speed

% build basic af map
if 1
   af_spd_percent_index=[0 50 100];
   af_load_percent_index=[0 50 100];
   af_def_map=[50 34 16; 42 28 16; 34 22 16];
   fc_af_map=interp2(af_spd_percent_index, af_load_percent_index, af_def_map', (fc_map_spd./max(fc_map_spd)*100)', fc_map_trq./max(fc_map_trq)*100)';
   fc_exflow_map=fc_fuel_map.*(1+fc_af_map);
else
   %fc_exflow_map=fc_fuel_map*(1+14.5);                 % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
   fc_exflow_map=fc_fuel_map*(1+18*2);                 % g/s  ex gas flow map:  for CI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)*2]
   																	% *2 to account for generally lean operation, A/F typically ~18:1 at high load and ~50:1 at low load
end
clear af_spd_percent_index af_load_percent_index af_def_map

fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - T.*w;    % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
spd=fc_map_spd; 
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));        % W   initialize size of ex pwr map
for i=1:length(spd)
 fc_ex_pwr_map(i,:)=fc_waste_pwr_map(i,:)*interp1([min(spd) max(spd)],fc_ex_pwr_frac,spd(i));  % W  trq-spd map of waste heat to exh 
end
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;   % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1; 

% clean up workspace
clear T w fc_waste_pwr_map fc_ex_pwr_map spd fc_map_kW

% Begin added by ADVISOR 3.2 converter: 14-Dec-2001
fc_cold_tmp=21.1;

fc_exflow_map_cold=fc_exflow_map;

fc_extmp_map_cold=fc_extmp_map;

fc_fuel_map_cold=fc_fuel_map;

fc_hc_map_cold=fc_hc_map;

fc_co_map_cold=zeros(size(fc_fuel_map));

fc_pm_map_cold=fc_pm_map;

fc_nox_map_cold=fc_nox_map;

fc_o2_map=zeros(size(fc_fuel_map));

% Process cold maps
names={'fc_fuel_map', 'fc_hc_map', 'fc_co_map', 'fc_nox_map', 'fc_pm_map'};
for i=1:length(names)
    %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
    eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
end

fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0];
% End added by ADVISOR 3.2 converter: 14-Dec-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YYYY-MMM-DD [author initials]
% 2000-Aug-01 09:11:22: file created using engmodel  % 2000-Sep-22: automatically updated to version 3
% 2002-Jan-04: [mpo] updated for ADVISOR 3.2