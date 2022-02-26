% ADVISOR Data file:  FC_SI63_emis.M
%
% Data source: Fuel use and emissions from: Feng An 
% 
%
% Data confidence level:  
%
% Notes:
% Feng An's experimental fuel use and emissions for a 1.9L Saturn sohc
% (1996 with CA emissions equipment) are used to develop data for a
% non-enriched version of the Saturn engine.
% Maximum Power 63 kW @ 5500 rpm.
% Peak Torque 145 Nm @ 2000 rpm.
% No enrichment (for use in HEVs, not conventional vehicles).
%
% WARNING:  The fuel use and emissions data comes from transient testing 
% by Feng An is only appropriate to model transient-operation .
% This m-file will generate fuel use and emissions for an engine which has
% no enrichment (for use in HEVs, not conventional vehicles). 
% This data is only appropriate for use in hybrid vehicles (no enrichment)
% where the engine does fast following of the road load demands.
% Fuel use and emissions data from the tests does not cover the 
% entire range of possible operation of the engine.  
% Therefore, this data is most reliable and useful in the low torque/low speed
% and high torque/high speed areas where data was available.
% Fuel cons. & emissions data generated at 701 to 5500 rpm
% (701 1000 then by 500 rpm) .
%
% USE THIS DATA WITH CARE.
%
% Created on:  10/13/98
% By: John Anderson, Argonne National Laboratory, john_anderson@qmgate.anl.gov
%
% Revision history at end of file.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Saturn 1.9L (63kW) SOHC SI Engine - ("non-enriched")'; 
% one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Gasoline';
fc_disp=1.9;  % (L), engine displacement
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI63_emis.m - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine (11 values)
fc_map_spd=[701 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500]*2*pi/60; 

% (N*m), torque range of the engine (no neg. torque) (8 values)
fc_map_trq=[ 0.0  14.2  29.8  43.1  57.9  72.0  85.1  100.1 ]*1.35671;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
% 1.9L Saturn sohc with enrichment (from Feng An)
%Fuel(g/s) 0      14.2    29.8    43.1    57.9     72     85.1   100.1
fuelrich=[
         0.1935  0.343   0.430   0.503   0.585   0.664   0.736   0.750
         0.1935  0.306   0.429   0.534   0.651   0.763   0.866   1.088
         0.1935  0.406   0.591   0.749   0.925   1.092   1.247   1.650
         0.1935  0.547   0.793   1.004   1.238   1.461   1.668   2.270
         0.1935  0.695   1.003   1.266   1.559   1.837   2.334   2.852
         0.1935  0.855   1.225   1.540   1.891   2.421   3.022   3.446
         0.1935  1.029   1.460   1.828   2.249   3.132   3.564   4.039
         0.1935  1.338   2.042   2.543   3.101   3.632   4.126   4.541
         0.1935  1.576   2.369   2.933   3.561   4.158   4.714   5.036
         0.1935  1.843   2.726   3.352   4.049   4.714   5.331   5.528
         0.1935  1.843   2.726   3.352   4.049   4.714   5.331   5.528 ];

%CO (g/s)  0      14.2    29.8    43.1    57.9     72     85.1   100.1
corich=[
         0.0164  0.029   0.036   0.043   0.049   0.056   0.062   0.063
         0.0164  0.026   0.036   0.045   0.055   0.064   0.073   0.726
         0.0164  0.034   0.050   0.063   0.078   0.092   0.105   1.101
         0.0164  0.046   0.067   0.085   0.105   0.123   0.141   1.515
         0.0164  0.059   0.085   0.107   0.132   0.155   1.060   1.902
         0.0164  0.072   0.103   0.130   0.160   0.912   2.016   2.299
         0.0164  0.087   0.123   0.154   0.231   2.089   2.377   2.694
         0.0164  0.538   1.362   1.697   2.069   2.423   2.753   3.029
         0.0164  0.650   1.581   1.957   2.376   2.774   3.145   3.360
         0.0164  0.781   1.818   2.236   2.702   3.145   3.556   3.688
         0.0164  0.781   1.818   2.236   2.702   3.145   3.556   3.688 ];

%HC (g/s)  0      14.2    29.8    43.1    57.9     72     85.1   100.1
hcrich=[
         0.0016  0.0028  0.0036  0.0042  0.0049  0.0055  0.0061  0.0062
         0.0016  0.0025  0.0036  0.0044  0.0054  0.0063  0.0072  0.0090
         0.0016  0.0034  0.0049  0.0062  0.0077  0.0091  0.0104  0.0137
         0.0016  0.0045  0.0066  0.0083  0.0103  0.0121  0.0138  0.0188
         0.0016  0.0058  0.0083  0.0105  0.0129  0.0153  0.0194  0.0237
         0.0016  0.0071  0.0102  0.0128  0.0157  0.0201  0.0251  0.0286
         0.0016  0.0085  0.0121  0.0152  0.0187  0.0260  0.0296  0.0335
         0.0016  0.0111  0.0169  0.0211  0.0257  0.0301  0.0342  0.0377
         0.0016  0.0131  0.0197  0.0243  0.0296  0.0345  0.0391  0.0418
         0.0016  0.0153  0.0226  0.0278  0.0336  0.0391  0.0442  0.0459
         0.0016  0.0153  0.0226  0.0278  0.0336  0.0391  0.0442  0.0459 ];

%NOx (g/s) 0      14.2    29.8    43.1    57.9     72     85.1   100.1
noxrich=[
         0.0000  0.0014  0.0042  0.0066  0.0093  0.0119  0.0142  0.0147
         0.0000  0.0002  0.0042  0.0076  0.0115  0.0151  0.0185  0.0331
         0.0000  0.0035  0.0095  0.0146  0.0204  0.0258  0.0309  0.0502
         0.0000  0.0080  0.0161  0.0229  0.0306  0.0378  0.0446  0.0690
         0.0000  0.0129  0.0229  0.0315  0.0410  0.0501  0.0710  0.0867
         0.0000  0.0181  0.0301  0.0404  0.0519  0.0736  0.0919  0.1048
         0.0000  0.0237  0.0378  0.0498  0.0635  0.0952  0.1083  0.1228
         0.0000  0.0407  0.0621  0.0773  0.0943  0.1104  0.1254  0.1380
         0.0000  0.0479  0.0720  0.0892  0.1082  0.1264  0.1433  0.1531
         0.0000  0.0560  0.0829  0.1019  0.1231  0.1433  0.1621  0.1680
         0.0000  0.0560  0.0829  0.1019  0.1231  0.1433  0.1621  0.1680 ];

% ***********************************************************************
% 1.9L Saturn sohc (enrichment - non-enrichment) from Feng An
%Fuel(g/s) 0      14.2    29.8    43.1    57.9     72     85.1   100.1
fueldif=[
         0.0000  0.000   0.000   0.000   0.000   0.000   0.000   0.000
         0.0000  0.000   0.000   0.000   0.000   0.000   0.000   0.000
         0.0000  0.000   0.000   0.000   0.000   0.000   0.000   0.013
         0.0000  0.000   0.000   0.000   0.000   0.000   0.000   0.015
         0.0000  0.000   0.000   0.000   0.000   0.000   0.000   0.017
         0.0000  0.000   0.000   0.000   0.000   0.000   0.012   0.019
         0.0000  0.000   0.000   0.000   0.000   0.011   0.019   0.020
         0.0000  0.000   0.000   0.000   0.000   0.019   0.021   0.022
         0.0000  0.011   0.016   0.018   0.019   0.021   0.022   0.024
         0.0000  0.011   0.017   0.019   0.021   0.022   0.024   0.025
         0.0000  0.011   0.018   0.020   0.022   0.024   0.026   0.027 ];

%CO (g/s)      0    14.2    29.8    43.1    57.9      72    85.1   100.1
codif=[
               0       0 -0.0003  0.0005 -0.0005  -1E-04 -0.0002 -0.0003
               0  0.0002 -0.0003 -0.0001       0 -0.0005 -0.0002  0.6489
               0 -0.0003       0 -0.0003 -0.0001 -0.0003 -0.0004   0.984
               0 -0.0002       0  0.0002  0.0004 -0.0004   1E-04   1.354
               0  0.0003  0.0002       0  0.0003 -0.0003  0.8829  1.6998
               0 -0.0002 -0.0005  -1E-04  0.0002   0.724  1.8017  2.0546
               0   1E-04 -0.0004 -0.0005  0.0419  1.8669  2.1243  2.4076
               0  0.4349  1.2172  1.5167  1.8491  2.1654  2.4604   2.707
               0  0.5289   1.413   1.749  2.1235  2.4791  2.8108  3.0029
               0  0.6398  1.6247  1.9983  2.4149  2.8108   3.178   3.296
               0  0.6398  1.6247  1.9983  2.4149  2.8108   3.178   3.296 ];

%HC (g/s)      0    14.2    29.8    43.1    57.9      72    85.1   100.1
hcdif=[
               0       0       0       0       0       0       0       0
               0       0       0       0       0       0       0  0.0014
               0       0       0       0       0       0       0  0.0022
               0       0       0       0       0       0       0   0.003
               0       0       0       0       0       0   0.002  0.0038
               0       0       0       0       0  0.0016  0.0041  0.0046
               0       0       0       0  0.0001  0.0042  0.0048  0.0054
               0   0.001  0.0027  0.0034  0.0041  0.0048  0.0055  0.0061
               0  0.0012  0.0032  0.0039  0.0048  0.0055  0.0063  0.0067
               0  0.0014  0.0036  0.0045  0.0054  0.0063  0.0071  0.0074
               0  0.0014  0.0036  0.0045  0.0054  0.0063  0.0071  0.0074 ];

%NO (g/s)      0    14.2    29.8    43.1    57.9      72    85.1   100.1
noxdif=[
               0       0       0       0       0       0       0       0
               0       0       0       0       0       0       0  0.0131
               0       0       0       0       0       0       0  0.0148
               0       0       0       0       0       0       0  0.0167
               0       0       0       0       0       0  0.0124  0.0185
               0       0       0       0       0  0.0108   0.019  0.0203
               0       0       0       0  0.0003  0.0193  0.0206  0.0221
               0  0.0107   0.016  0.0175  0.0192  0.0208  0.0223  0.0236
               0   0.011   0.017  0.0187  0.0206  0.0224  0.0241  0.0251
               0  0.0113  0.0181    0.02  0.0221  0.0241  0.0261  0.0266
               0  0.0113  0.0181    0.02  0.0221  0.0241  0.0261  0.0266 ];
            
% *************************************************************************
% Generate values for 1.9L Saturn sohc without enrichmnet (Feng An data)
% i.e., subtract dif values from rich values to obtain non-enriched values.

% (g/s), fuel use map indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_fuel_map = fuelrich - fueldif;

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map   = corich   - codif  ;

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
 fc_hc_map   = hcrich   - hcdif  ;
 
% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
 fc_nox_map  = noxrich  - noxdif ;

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

% create *gpkWh maps for plotting purposes
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./(fc_map_kW+eps)*3600;
fc_hc_map_gpkWh=fc_hc_map./(fc_map_kW+eps)*3600;
fc_co_map_gpkWh=fc_co_map./(fc_map_kW+eps)*3600;
fc_nox_map_gpkWh=fc_nox_map./(fc_map_kW+eps)*3600;
fc_pm_map_gpkWh=fc_pm_map./(fc_map_kW+eps)*3600;

% clean up workspace
clear T w fc_map_kW hcrich noxrich corich fuelrich hcdif noxdif codif fueldif

% ***********************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd (11 values).
fc_max_trq=[83.5 101.4 105.8 107.0 106.5 106.5 106.5 102.5 93.6 86.9 80.2]*1.35671;

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd (11 values). No negative torque.
%fc_ct_trq=(-fc_disp*61.02/24*(9*(fc_map_spd/max(fc_map_spd)).^2+14*(fc_map_spd/max(fc_map_spd))))*4.448/3.281;
fc_ct_trq=[ 0 0 0 0 0 0 0 0 0 0 0 ]*1.35671;


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
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_emis=1;  % includes emissions data:  1=TRUE, 0=FALSE
fc_fuel_den=0.749*1000; % (g/l), density of the fuel 
fc_fuel_lhv=42.6*1000; % (J/g), lower heating value of the fuel
fc_inertia=0.1; % (kg*m^2), rotational inertia of the engine; unknown

%fc_mass=max(fc_map_spd.*fc_max_trq)/(0.285*1000); % (kg), mass of the engine
% estimated assuming a specific energy of 0.285 kW/kg (including exhaust and other accessories)

%vc_idle_spd = 701*2*pi/60;    % idle speed is 701 rpm = 73.4 rad/s

fc_air_fuel_ratio=14.5;           % air/fuel ratio (stoic) on mass basis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRACTION OF WASTE HEAT TO EXHAUST GAS AS A FUNCTION OF EX GAS FLOW RATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power
fc_base_mass=1.8*fc_max_pwr;            % (kg), mass of the engine block and head (base engine)
                                        %       mass penalty of 1.8 kg/kW from 1994 OTA report, Table 3
fc_acc_mass=0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from OTA report)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine
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
fc_ex_pwr_frac=[0.45 0.35];     % frac of waste heat that goes to exhaust
fc_exflow_map=fc_fuel_map*(1+fc_air_fuel_ratio);                % g/s  ex gas flow map:  exflow=(fuel use)*[1 + (A/F ratio)]; for SI engines, A/F=14.5, for CI, A/F~20
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - T.*w;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
spd=fc_map_spd;
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(spd)
  fc_ex_pwr_map(i,:)=fc_waste_pwr_map(i,:)*interp1([min(spd) max(spd)],fc_ex_pwr_frac,spd(i)); % W  trq-spd map of waste heat to exh 
end
fc_extmp_map=fc_ex_pwr_map./((fc_exflow_map+eps)*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%clean up workspace
clear T w fc_waste_pwr_map fc_ex_pwr_map spd i


%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/13/98 (ja): created from FC_SI63x.m
% 10/14/98 (db): modified to accommodate release of yesterday, added PM map.
% 2/1/1999 (db): modified for 1/27/99 version to include thermal model
% 4/24/00 (tm): moved all ADVISOR converter data into the appropriate areas of the file
% 4/24/00 (tm): included statements to compute gpkWh matrices for ploting
% ********************************************************************
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
