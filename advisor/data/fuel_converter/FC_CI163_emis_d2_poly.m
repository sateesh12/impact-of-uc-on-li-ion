% ADVISOR Data file:  FC_CI163_emis_d2_poly.m
%
% Data source: Engine datafile for the Navistar T444/ Powerstroke 7.3L engines tested on  No. 2 Diesel Fuel
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
% File created by engmodel using mat file: p_stroke_d2.mat;
% Points outside of data points extrapolated based on the following algorithm: polynomial;
% Map: fc_fuel_map;
%  Average error (%): 2.5262;
%  Maximum error (g/s): 0.11076;
%  max error at speed (rpm): 1600;
%  max error at torque (Nm): 202.4;
% Map: fc_nox_map;
%  Average error (%): 3.6687;
%  Maximum error (g/s): -0.0057435;
%  max error at speed (rpm): 1350;
%  max error at torque (Nm): 348.5;
% Map: fc_pm_map;
%  Average error (%): 7.185;
%  Maximum error (g/s): 0.00013088;
%  max error at speed (rpm): 1350;
%  max error at torque (Nm): 348.5
%
% Created on:  01-Aug-2000 09:16:19
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Powerstroke 7.3L Diesel Engine tested at Ricardo (Diesel Fuel)';  
fc_version=2003;  				% version of ADVISOR for which the file was generated
fc_proprietary=1;  	% 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0;  		% 1=> no validation, 1=> data agrees with source data, 
							% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Diesel'; 
fc_disp=7.3;   			% (L), engine displacement
fc_emis=1;       				% boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI163_emis_d2_poly.m - ',fc_description]); 

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
fc_fuel_map=[0.2909 0.4727 0.6704 0.8814 1.104 1.336 1.578 1.828 2.087;
0.3674 0.6447 0.799 0.9946 1.266 1.566 1.893 2.248 2.628;
0.5643 0.872 1.026 1.329 1.766 2.203 2.64 2.787 3.29;
0.8118 1.118 1.254 1.604 2.031 2.468 2.905 3.342 4.003;
1.085 1.243 1.525 1.889 2.296 2.736 3.389 4.042 4.742;
1.372 1.523 1.814 2.178 2.785 3.438 4.091 4.744 5.494;
1.664 1.809 2.113 2.476 3.251 4.14 4.793 5.446 6.251;
1.955 2.094 2.377 2.793 3.697 4.602 5.495 6.148 7.007;
2.242 2.375 2.671 3.239 4.143 5.048 5.952 6.85 7.76;
2.522 2.649 2.956 3.759 4.657 5.555 6.453 7.351 8.504;
2.792 2.912 3.232 3.749 5.219 6.117 7.015 7.913 9.24;
3.05 3.164 3.497 4.044 4.805 6.68 7.578 8.476 9.963;
3.295 3.403 3.748 4.326 5.136 7.242 8.14 9.038 10.67;
3.526 3.628 3.984 4.593 5.452 6.56 8.702 9.6 11.37;
3.741 3.836 4.205 4.844 5.752 6.928 9.264 10.16 12.05;
3.939 4.028 4.409 5.079 6.036 7.279 8.806 10.72 12.71;
4.119 4.203 4.596 5.297 6.303 7.612 9.225 11.14 13.36]'; 


% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map=zeros(size(fc_fuel_map)); 

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map =[0.006818 0.004369 0.002369 0.00155 0.002388 0.005214 0.01028 0.01777 0.02784;
0.005126 0.0127 0.0141 0.01574 0.01879 0.02228 0.02647 0.03154 0.03766;
0.0007549 0.0176 0.01899 0.02827 0.03094 0.03361 0.03629 0.04264 0.0448;
2.22e-016 0.02417 0.02389 0.03917 0.04367 0.04635 0.04902 0.05169 0.05128;
2.22e-016 0.01564 0.03192 0.04816 0.05641 0.05906 0.06028 0.0615 0.05781;
2.22e-016 0.01793 0.04197 0.05821 0.06763 0.06886 0.07008 0.0713 0.06478;
2.22e-016 0.02089 0.05434 0.07058 0.07631 0.07865 0.07987 0.08109 0.07241;
2.22e-016 0.02466 0.05972 0.08247 0.08489 0.0873 0.08966 0.09089 0.08087;
2.22e-016 0.02938 0.06973 0.09105 0.09347 0.09588 0.0983 0.1007 0.09027;
2.22e-016 0.03513 0.08077 0.107 0.1087 0.1105 0.1123 0.1141 0.1007;
2.22e-016 0.04197 0.0929 0.1296 0.1288 0.1306 0.1324 0.1341 0.1122;
2.22e-016 0.04996 0.1062 0.1466 0.1718 0.1506 0.1524 0.1542 0.1249;
2.22e-016 0.05915 0.1207 0.1649 0.1922 0.1707 0.1724 0.1742 0.1387;
2.22e-016 0.06957 0.1364 0.1843 0.2139 0.2254 0.1925 0.1943 0.1538;
2.22e-016 0.08126 0.1534 0.2051 0.2368 0.249 0.2125 0.2143 0.1702;
2.22e-016 0.09425 0.1716 0.2271 0.2611 0.2739 0.2659 0.2343 0.1879;
0.001638 0.1086 0.1912 0.2505 0.2866 0.3002 0.2913 0.2601 0.2069]';  

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map=[0.0001543 0.000259 0.0003907 0.0005294 0.0006623 0.00078 0.000876 0.0009449 0.0009827;
0.0007622 0.0005509 0.0007765 0.000945 0.001058 0.001178 0.001299 0.001415 0.001521;
0.001067 0.0006367 0.0008622 0.0009394 0.001122 0.001304 0.001487 0.001582 0.001757;
0.001246 0.0006823 0.000948 0.0009169 0.001068 0.00125 0.001433 0.001615 0.001866;
0.001359 0.001119 0.0009758 0.0009269 0.001014 0.001197 0.001402 0.001606 0.001911;
0.001441 0.001114 0.0009465 0.0008976 0.0009836 0.001188 0.001393 0.001598 0.001923;
0.001511 0.001098 0.0008317 0.0007828 0.0009482 0.00118 0.001384 0.001589 0.001924;
0.001583 0.001084 0.0007666 0.0006775 0.0009106 0.001144 0.001375 0.00158 0.001927;
0.001667 0.001082 0.0007006 0.0006398 0.0008729 0.001106 0.001339 0.001571 0.001942;
0.001772 0.0011 0.0006544 0.0006738 0.0009007 0.001128 0.001354 0.001581 0.001977;
0.001901 0.001143 0.0006339 0.0003535 0.0009748 0.001202 0.001429 0.001655 0.002038;
0.002062 0.001218 0.0006441 0.0003217 0.0002374 0.001276 0.001503 0.00173 0.002129;
0.002257 0.001326 0.0006889 0.0003246 0.0002205 0.00135 0.001577 0.001804 0.002255;
0.00249 0.001473 0.0007716 0.0003654 0.0002415 0.000391 0.001651 0.001878 0.002419;
0.002764 0.001661 0.0008951 0.0004469 0.0003033 0.0004552 0.001725 0.001952 0.002623;
0.003081 0.001892 0.001062 0.0005716 0.0004083 0.0005626 0.001028 0.002026 0.002871;
0.003443 0.002168 0.001274 0.0007416 0.0005585 0.0007153 0.001205 0.002023 0.003164]'; 


% create BS** maps for plotting purposes
[T,w]=meshgrid(fc_map_trq,fc_map_spd); 
fc_map_kW=T.*w/1000; 
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600; 
fc_co_map_gpkWh=fc_co_map./fc_map_kW*3600; 
fc_hc_map_gpkWh=fc_hc_map./fc_map_kW*3600; 
fc_nox_map_gpkWh=fc_nox_map./fc_map_kW*3600; 
fc_pm_map_gpkWh=fc_pm_map./fc_map_kW*3600; 

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

fc_ct_trq=interp1([0 100],[0.11 0.18],fc_map_spd/max(fc_map_spd)*100).*fc_max_trq*(-1);

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
fc_fuel_den=843;  					% (g/l), density of the fuel 
fc_fuel_lhv=43000;  							% (J/g), lower heating value of the fuel

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
fc_ex_pwr_frac=[0.40 0.30];                         % --   frac of waste heat that goes to exhaust as func of engine speed
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
% YYYY-MMM-DD
% 2000-Aug-01 09:16:19: file created using engmodel 
% 2000-Sep-01: automatically updated to version 3
% 2002-Jan-02: [mpo] updated file for ADVISOR 3.2