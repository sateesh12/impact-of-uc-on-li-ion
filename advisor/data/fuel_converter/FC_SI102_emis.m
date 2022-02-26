% ADVISOR Data file:  FC_SI102_emis.m
%
% Data source: Dill Murrell, JDM Associates, under contract to 
% Argonne National Laboratory. FTP Revision Project. 
%
% Data confidence level:  
%
% Notes: 
% This file loads the variables associated with a Dodge Caravan engine,
% a 3.0 L, 6-cyl., 136 hp, 1991 model year.
% Maximum Power 102 kW @ 4875 rpm
% Peak Torque 217 Nm @ 4143 rpm
%
% WARNING:  This data comes from transient testing on the FTP and is
% only appropriate to model transient-operation engines.
%
% Created on:  06/23/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='1991 Dodge Caravan 3.0L (102kW) SI Engine - transient data';
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Gasoline';
fc_disp=3.0; % (L), engine displacement
fc_emis=1;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI102_emis.m - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[128.8 190.7 249 310.5 338.7 366.9 433.9 471.8 510.5];

% (N*m), torque range of the engine
fc_map_trq=[27.1 40.6 54.2 67.7 81.3 94.8 108.4 122 135.5 149.1 162.6 176.2 ...
      189.7 203.3 216.9];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map_gpkWh = [
436.14	421.94	407.74	393.54	393.54	393.54	393.54	393.54	393.54	393.54	393.54	393.54	393.54	393.54	393.54
400.86	386.66	372.46	358.26	344.07	329.87	315.67	301.47	301.47	301.47	301.47	301.47	301.47	301.47	301.47
363.32	363.32	352.92	347.72	342.52	332.13	326.93	321.73	311.33	306.13	300.93	288.46	288.46	288.46	288.46
384.94	384.94	384.94	368.08	351.22	337.93	333.63	329.33	323.58	321.79	320   	319.91	319.83	401.06	401.06
395.25	395.25	395.25	370.95	346.65	325.11	319.32	313.54	311.03	314.14	317.25	328.48	339.71	412.22	412.22
405.56	405.56	405.56	373.82	342.08	312.28	305.02	297.75	298.49	306.49	314.5 	337.04	359.59	423.38	423.38
406.85	406.85	406.85	394.57	382.3	   371.68	369.71	367.74	370.48	375.2  	379.91	391.39	402.87	420.29	437.71
592.04	592.04	554.46	516.87	460.66	442.04	423.41	413.32	403.23	410.21	423.18	436.14	488.45	488.45	488.45
731.92	731.92	572.15	539.11	506.07	477.45	472.51	467.57	468.93	470.29	476.89	483.5 	483.5 	483.5 	483.5];

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map_gpkWh = [
6.12	5.92	5.72	5.52	5.52	5.52	5.52	5.52	5.52	5.52	5.52	5.52	5.52	5.52	5.52
5.68	5.48	5.27	5.07	4.87	4.67	4.47	4.27	4.27	4.27	4.27	4.27	4.27	4.27	4.27
3.76	3.76	3.76	3.76	3.76	3.76	3.76	3.76	3.76	3.76	3.76	3.44	3.44	3.44	3.44
4.07	4.07	4.07	4  	3.93	3.83	3.78	3.73	3.63	3.585	3.54	3.5	3.46	4.4	4.4
4.23	4.23	4.23	4.035	3.84	3.63	3.56	3.49	3.41	3.405	3.4	3.46	3.52	4.24	4.24
4.39	4.39	4.39	4.07	3.75	3.43	3.335	3.24	3.19	3.23	3.27	3.425	3.58	4.07	4.07
3.53	3.53	3.53	3.645	3.76	3.8	3.795	3.79	3.76	3.76	3.76	3.82	3.88	4.06	4.24
3.86	3.86	2.11	0.36	1.07	1.64	2.21	2.885	3.56	4.26	4.445	4.63	4.63	4.63	4.63
1.66	1.66	2.13	2.36	2.59	3.06	3.29	3.52	3.83	4.14	4.45	4.76	4.76	4.76	4.76];

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map_gpkWh = [
30.88	31.6	32.32	33.04	 33.04 33.04  33.04	33.04	 33.04	33.04	  33.04	33.04	 33.04  33.04   33.04
27.19	27.91	28.62	29.34  30.06 30.78  31.5	32.21	 32.21	32.21	  32.21	32.21	 32.21  32.21   32.21
49.9	49.9	48.09	46.825 45.56 42.31  40.32	38.33	 33.63	30.92	  28.21	20.76	 20.76  20.76   20.76
29.83	29.83	29.83	33.35	 36.87 34.51  30.87	27.23	 17.93	15.455  12.98	30.53	 48.08  361.62  361.62
40.07	40.07	40.07	43.235 46.4	 36.39  29.895	23.4	 16.84	22.35	  27.86	64.495 101.13 359.17  359.17
50.32	50.32	50.32	53.125 55.93 38.27  28.92	19.57	 15.75	29.245  42.74	98.46	 154.18 356.71  356.71
23.36	23.36	23.36	29.575 35.79 57.71  74.075	90.44	 133.98	161.145 188.31	232.94 277.57 331.805 386.04
42.98	42.98	34.9	26.82  23.41 28.08  32.75	48.89	 65.03	402.14  402.14	402.14 402.14 402.14  402.14
34.8	34.8	26.82	25.115 23.41 100.74 174.64	248.54 337.135	425.73  456.71	487.69 487.69 487.69  487.69];

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map_gpkWh = [
16.82	16.85	16.88	 16.91	16.91	16.91	 16.91	16.91	16.91	16.91	 16.91 16.91  16.91	16.91	16.91
18	   18.08	18.15	 18.23	18.3	18.38	 18.45	18.53	18.53	18.53	 18.53 18.53  18.53	18.53	18.53
10.66	10.66	16.54	 18.71	20.88	23.69	 24.325	24.96	24.7	23.8	 22.9	 18.71  18.71	18.71	18.71
21.61	21.61	21.61	 24.37	27.13	29.08	 29.11	29.14	27.33	25.485 23.64 19.715 15.79	5.88	5.88
22.05	22.05	22.05	 24.275	26.5	27.85	 27.67	27.49	25.44	23.565 21.69 17.86  14.03	4.56	4.56
22.48	22.48	22.48	 24.17	25.86	26.61	 26.23	25.85	23.55	21.645 19.74 16.01  12.28	3.25	3.25
26.75	26.75	26.75	 26.915	27.08	27.33	 27.44	27.55	27.73	17.27	 6.81	 4.845  2.88	2.97	3.06
27.63	27.63	27.255 26.88	26.13	25.745 25.36	24.82	24.28	6.72	 4.84	 2.96	  3.02	3.02	3.02
17.05	17.05	16.09	 15.42	14.75	13.03	 11.975	10.92	9.22	7.52	 5.485 3.45	  3.45	3.45	3.45];

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map_gpkWh=zeros(size(fc_fuel_map_gpkWh));

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_o2_map=zeros(size(fc_fuel_map_gpkWh));

% convert g/kWh to g/s
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map=fc_fuel_map_gpkWh.*fc_map_kW/3600;
fc_co_map=fc_co_map_gpkWh.*fc_map_kW/3600;
fc_nox_map=fc_nox_map_gpkWh.*fc_map_kW/3600;
fc_hc_map=fc_hc_map_gpkWh.*fc_map_kW/3600;
fc_pm_map=fc_pm_map_gpkWh.*fc_map_kW/3600;

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
fc_max_trq=[67.8 122.0 187.1 214.2 214.2 214.2 216.9 199.3 199.3];

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
fc_inertia=0.1*fc_pwr_scale;           % (kg*m^2), rotational inertia of the engine (unknown)
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power

fc_base_mass=1.8*fc_max_pwr;            % (kg), mass of the engine block and head (base engine)
                                        %       mass penalty of 1.8 kg/kW from 1994 OTA report, Table 3 
fc_acc_mass=0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from OTA report)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.749*1000; % (g/l), density of the fuel 
fc_fuel_lhv=42.6*1000; % (J/g), lower heating value of the fuel

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
fc_exflow_map=fc_fuel_map*(1+14.5);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
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
% 03/15/01: vhj,ss; fixed fc_o2_map to use fc_fuel_map_gpkwh instead of fc_fuel_map
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

