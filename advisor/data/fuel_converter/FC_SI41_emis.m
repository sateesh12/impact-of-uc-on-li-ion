% ADVISOR Data file:  FC_SI41_emis.M
%
% Data source: J. Dill Murrel, JDM & Associates.  
%
% Data confidence level:  
%
% Notes: 1991 Geo Metro 1.0L SI engine.
% Maximum Power 41 kW @ 5700 rpm.
% Peak Torque 81 Nm @ 3477 rpm.

% WARNING:  This data comes from transient testing on the FTP and is
% only appropriate to model transient-operation engines.
%
% Created on:  06/22/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Geo 1.0L (41kW) SI Engine - transient data'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Gasoline';
fc_disp=1.0;  % (L), engine displacement
fc_emis=1;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI41_emis.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[104.5 149.2 220.9 292.5 364.1 435.7 507.4 552.2 596.9]; 

% (N*m), torque range of the engine
fc_map_trq=[6.8 13.6 20.4 27.2 33.8 40.6 47.4 54.2 61 67.8 74.6 81.4]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map_gpkWh =[
635.7	635.7	541.4	447.2	352.9	332.2	311.4	322.4	333.5	333.5	333.5	333.5
678.4	500.1	443.8	387.4	331.1	301.8	297	283.4	269.8	358	358	358
463.4	463.4	407.6	350.1	294.3	280.8	267.3	253.9	269.8	303.2	336.7	336.7
699.1	567.9	500.3	432.7	301.4	283.9	266.3	248.7	258.8	268.8	271.9	317.9
592.9	592.9	494.6	393.4	295.1	279.4	263.6	247.9	255.2	262.5	295	322.6
667.9	524.8	381.6	351.9	322.2	304.9	287.5	270.8	290.8	310.9	330.9	330.9
630.6	630.6	522.5	411.1	303	304.4	305.8	304.2	314.5	324.8	327.7	327.7
698.4	500.5	428.6	392.7	356.8	337.9	328.4	319	328.8	338.6	333.7	333.7
751.1	637.8	521.1	407.8	393.1	378.4	363.3	348.2	318.8	340.2	340.2	340.2];
% fuel map in g/kWh 

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map_gpkWh =[
11.5	11.5	9.8	8.2	6.5	5.8	5.1	5.9	6.8	6.8	6.8	6.8
7.8	7	6.2	5.5	4.7	4.3	4.7	4.6	4.5	4.6	4.6	4.6
5.8	5.8	5.2	4.6	4	4	4	4	4.5	4.6	4.6	4.6
7.1	6	5.4	4.9	3.8	3.7	3.6	3.4	3.2	3	3.4	3.9
5.8	5.8	5	4.3	3.6	3.6	3.6	3.7	3.6	3.6	4	3.9
5.6	4.7	3.7	3.7	3.7	3.4	3.1	3	3.2	3.4	3.5	3.5
8.2	8.2	6.8	5.4	4.1	3.7	3.3	3.1	3.2	3.2	3.3	3.3
5.8	5.2	4.8	4.5	4.3	3.7	3.4	3.2	3.3	3.3	3.3	3.3
5.6	5.8	5.9	6.1	5.7	5.4	5	4.6	3.9	3.9	3.9	3.9];
% engine out HC in g/kWh

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map_gpkWh =[
71.8	71.8	58.8	45.7	32.7	27.5	22.4	82.9	143.3	143.3	143.3	143.3
104.4	68.3	56.8	45.3	33.9	23.3	25.7	24.2	22.8	268.6	268.6	268.6
48.3	48.3	42.9	37.2	31.8	28.6	25.4	22.2	22.8	152.9	283	283
103.1	82.7	72.2	61.8	41.5	36.9	32.3	27.8	31.1	34.4	178.5	279.9
88.1	88.1	74.2	59.9	46	41.9	37.8	33.7	34.8	35.8	158.8	264.6
96.1	74.5	52.9	51.2	49.5	45.9	42.4	34	117.9	201.8	285.7	285.7
114.6	114.6	92.1	69	46.5	60.7	74.8	129.6	195.5	261.4	277.8	277.8
60.1	63.8	64	64.1	64.3	108.2	130.2	152.2	216.7	281.2	278.1	278.1
51.8	75.2	99.3	122.8	134.9	147.1	159.7	172.2	196.6	286.6	286.6	286.6];
% engine out CO in g/kWh

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map_gpkWh =[
5.8	5.8	9.3	12.8	16.3	16.1	15.9	13	10.2	10.2	10.2	10.2
5.2	8.8	9.2	9.7	10.2	8	8.9	13.2	17.5	4.6	4.6	4.6
8.1	8.1	8.8	9.6	10.4	10.8	11.3	11.7	17.5	11.6	5.7	5.7
4.2	5.6	6.3	7	8.4	8.9	9.5	10.1	13.9	17.7	8.1	3.1
5.8	5.8	7.2	8.7	10.1	11	11.8	12.6	15.9	19.2	9.3	6.8
14.9	16.4	17.8	19.4	21	20.6	20.3	19.1	14.6	10.2	5.7	5.7
28.7	28.7	26.8	25	23.1	22.4	21.7	16.5	12.1	7.8	6.5	6.5
31.1	27.9	26.7	26.2	25.6	20.9	18.6	16.3	12.1	7.8	6.8	6.8
35	31.1	27.1	23.2	21.1	19.1	17	14.9	10.9	7.4	7.4	7.4];
% engine out NOx in g/kWh

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map_gpkWh=zeros(size(fc_fuel_map_gpkWh));

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_o2_map=zeros(size(fc_fuel_map_gpkWh));


% convert g/kWh maps to g/s maps
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map=fc_fuel_map_gpkWh.*fc_map_kW/3600;
fc_hc_map=fc_hc_map_gpkWh.*fc_map_kW/3600;
fc_co_map=fc_co_map_gpkWh.*fc_map_kW/3600;
fc_nox_map=fc_nox_map_gpkWh.*fc_map_kW/3600;
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
fc_max_trq=[61	67.6 73.7 78.5 80.9 77.3 76.2 73.3 68.7]; 

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
% 7/6/99:tm removed clear statement for all *gpkWh data - now used in plots
% 7/9/99:tm cosmetic changes
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
