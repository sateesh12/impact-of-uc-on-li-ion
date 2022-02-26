% ADVISOR Data file:  FC_CI246.M
%
% Data source:  Cummins Engine Company published spec sheets
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Data provided included, mass, max torque vs. spd, and fuel consumption @ full load vs. spd.
% All other information has been estimated!!
%
% Created on:  05/28/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Cummins M11-330 (246 kW) Diesel Engine'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Deisel';
fc_disp=10.8; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_CI246.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[1100 1200 1300 1500 1600 1700 1800 1900 2000]*pi/30; 

% (N*m), torque range of the engine
fc_map_trq=[100:100:1700]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map =[
    0.8217    1.6147    2.2913    2.9249    3.5293    4.1545    4.7784    5.4100    6.0445    6.6849    7.3210    7.9525    8.5871    9.2203    9.8495   10.4748   11.1073
    0.8682    1.6922    2.4014    3.0653    3.6988    4.3540    5.0078    5.6698    6.3348    7.0059    7.6726    8.3344    8.9995    9.6631   10.3225   10.9779   11.6407
    0.9725    1.8825    2.6169    3.3085    3.9904    4.6830    5.3743    6.0649    6.7573    7.4590    8.1597    8.8569    9.5583   10.2656   10.9786   11.6936   12.3996
    1.1994    2.2627    3.0435    3.8037    4.5760    5.3435    6.1087    6.8920    7.6756    8.4642    9.2569   10.0493   10.8515   11.6684   12.5009   13.3077   14.1112
    1.3109    2.4309    3.2392    4.0423    4.8394    5.6425    6.4613    7.3038    8.1490    8.9930    9.8430   10.6981   11.5609   12.4454   13.3077   14.1665   15.0219
    1.4364    2.6075    3.4461    4.2856    5.1291    5.9892    6.8758    7.7681    8.6647    9.5646   10.4698   11.4009   12.3430   13.2659   14.1851   15.1006   16.0123
    1.5788    2.7987    3.6624    4.5513    5.4572    6.3780    7.3237    8.2751    9.2323   10.1864   11.1736   12.1894   13.2052   14.1926   15.1760   16.1554   17.1308
    1.6798    2.9564    3.8890    4.8687    5.8526    6.8441    7.8618    8.8833    9.9033   10.9321   11.9968   13.0613   14.1215   15.1774   16.2290   17.2764   18.3195
    1.7906    3.1484    4.2029    5.2504    6.3087    7.3879    8.4880    9.5770   10.6792   11.7933   12.9468   14.0956   15.2397   16.3793   17.5142   18.6445   19.7702];
% The above map was generate using the lines of code encased in an 
% if exist('fc_fuel_map') statement provided at the end of this file.
% The map takes on the shape of the DDC 12.7L engine while maintaining 
% absolute fuel consumption data along its max trq curve.

% generate the BSFC map
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;

% pad maps with idle conditions
fc_idle_spd=650;
fc_map_spd=[fc_idle_spd*pi/30 fc_map_spd];
fc_fuel_map=[fc_fuel_map(1,:)/1.15; fc_fuel_map];
fc_fuel_map_gpkWh=[fc_fuel_map_gpkWh(1,:)*1.5; fc_fuel_map_gpkWh];

% pad maps with overspd condition
%fc_max_overspd=2300;
%fc_map_spd=[fc_map_spd fc_max_overspd*pi/30];
%fc_fuel_map=[fc_fuel_map; fc_fuel_map(end,:)*1.15];
%fc_fuel_map_gpkWh=[fc_fuel_map_gpkWh; fc_fuel_map_gpkWh(end,:)*1.5];

% pad maps with a zero spd and zero torque column
%fc_map_spd=[eps fc_map_spd];
%fc_map_trq=[eps fc_map_trq];
%fc_fuel_map=[fc_fuel_map(:,1)/2 fc_fuel_map];
%fc_fuel_map=[fc_fuel_map(1,:)/2; fc_fuel_map];
%fc_fuel_map_gpkWh=[fc_fuel_map_gpkWh(:,1)*1.5 fc_fuel_map_gpkWh];
%fc_fuel_map_gpkWh=[fc_fuel_map_gpkWh(1,:)*1.5; fc_fuel_map_gpkWh];

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
names={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map'};
for i=1:length(names)
    %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
    eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
fc_max_trq=[1695 1695 1695 1566 1469 1383 1306 1195 1096]; 
% pad for idle and overspd conditions
%fc_max_trq=[fc_max_trq(1)*0.95 fc_max_trq fc_max_trq(end)*0.95]; 
fc_max_trq=[fc_max_trq(1)*0.95 fc_max_trq]; 

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd 
%fc_ct_trq=zeros(size(fc_map_spd)); % no Jake Brake installed 
% fc_ct_trq=[80 105 140 185 240 285]; % with Jake Brake Model 404D installed 
fc_friction_trq=[-127 -155 -191]; % friction torque at 1200, 1600, and 2000 rpm
fc_ct_trq=interp1([1200 1600 2000]*pi/30,fc_friction_trq,fc_map_spd);
if sum(isnan(fc_ct_trq))>0
   i=1;
   while isnan(fc_ct_trq(i))
      i=i+1;
   end
   m=diff(fc_ct_trq(i:i+1))./diff(fc_map_spd(i:i+1));
   b=fc_ct_trq(i)-m*fc_map_spd(i);
   for i=1:length(fc_ct_trq)
      if isnan(fc_ct_trq(i))
         fc_ct_trq(i)=m*fc_map_spd(i)+b;
      end
   end
end

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
%fc_inertia=0.1*fc_pwr_scale;   % (kg*m^2),  rotational inertia of the engine (unknown)
% inertia must be greater than 5 with the specified accessory loads (tm:5/27/99)
%fc_inertia=10*fc_pwr_scale;   % (kg*m^2),  rotational inertia of the engine (unknown)
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power

fc_base_mass=2.8*fc_max_pwr;            % (kg), mass of the engine block and head (base engine)
                                        %       assuming a mass penalty of 1.8 kg/kW from S. Sluder (ORNL) estimate of 300 lb 
fc_acc_mass=0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from 1994 OTA report, Table 3)
fc_fuel_mass=0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from 1994 OTA report, Table 3)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
%fc_mass=985; % (kg), mass of the engine (reported mass)
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine

fc_inertia=fc_mass*(1/3+1/3*2/3)*(0.075^2); 
% assumes 1/3 purely rotating mass, 1/3 purely oscillating, and 1/3 stationary
% and crank radius of 0.075m, 2/3 of oscilatting mass included in rotational inertia calc
% correlation from Bosch handbook p.379

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.850*1000; % (g/l), density of the fuel 
fc_fuel_lhv=43.0*1000; % (J/g), lower heating value of the fuel

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
fc_ex_pwr_frac=[0.50 0.40];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+20);                  % g/s  ex gas flow map:  for CI engines, exflow=(fuel use)*[1 + (ave A/F ratio)]
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
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
clear m b i fc_friction_trq
clear T w fc_waste_pwr_map fc_ex_pwr_map spd

% Routine to build the fuel map provided above
if ~exist('fc_fuel_map')
   %%%% DDC Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd_ddc=[1200 1400 1600 1800 2000 2100]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq_ddc=[100 200 400 600 800 1000 1200 1400 1600 1800 2000]; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_fuel_map_gpkWh_ddc=[
   256 242	220	207	201.5	198.5	197	195.5	194.5	193.5 192.5
   290 261	220	207	200	195	192.5	190.5	189.5	189.5 189.5
   302 273	224	207	198	194.5	192	190.5	189.5	189.5 189.5
   326 288	228	209	200.5	196	193.5	191.5	191.5	191.5 191.5
   316 288	238	217	207.5	203	199.5	197.5	196.5	195.5 194.5
   312 290	244	222	210.5	204.5	202.5	199.5	198.5	198   197.5]; % (g/kW*hr)
   % fc_fuel_map elements  (1-6,1), (1,2), (5-6,9), (4-6,10), (1-6,11) 
   % have been estimated in order to complete the table.
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq_ddc=[1959 1883 1825 1761 1585 1510];
   fc_fuel_lhv_ddc=43.0*1000; % (J/g), lower heating value of the fuel
   
   
   %%%% Cummins Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd=[1100 1200 1300 1500 1600 1700 1800 1900 2000]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq=[100:100:1700]; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_fuel_map_gpkWh_at_max_trq=[202 196 193 191 191 192 194 197 202];
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq=[1695 1695 1695 1566 1469 1383 1306 1195 1096]; 
   fc_fuel_lhv=43.0*1000; % (J/g), lower heating value of the fuel
   
   
   %%%%% Build new efficiency and fuel consumptions maps
   
   % find ddc max trqs corresponding to cummins spds
   fc_max_trq_ddc_new=interp1(fc_map_spd_ddc,fc_max_trq_ddc,fc_map_spd);
   fc_max_trq_ddc_new(1)=fc_max_trq_ddc_new(2)*0.99;
   
   % build ddc efficiency and fuel consumption maps
   [T,w]=meshgrid(fc_map_trq_ddc,fc_map_spd_ddc);
   fc_map_kW_ddc=T.*w/1000;
   fc_fuel_map_ddc=fc_fuel_map_gpkWh_ddc.*fc_map_kW_ddc/3600;
   fc_eff_map_ddc=fc_map_kW_ddc./(fc_fuel_map_ddc*fc_fuel_lhv_ddc/1000);
   
   % find ddc efficiency along the max trq curve corresponding to the cummins spds
   fc_eff_at_max_trq_ddc=[];
   for x=1:length(fc_map_spd)
      fc_eff_at_max_trq_ddc=[fc_eff_at_max_trq_ddc ...
            interp2(fc_map_spd_ddc,fc_map_trq_ddc,fc_eff_map_ddc',fc_map_spd(x),fc_max_trq_ddc_new(x))];
   end;
   fc_eff_at_max_trq_ddc(1)=fc_eff_at_max_trq_ddc(2)*0.9999;
   
   % calculate the efficiency along the max trq curve for the cummins data
   fc_eff_at_max_trq=(fc_max_trq.*fc_map_spd/1000)./...
      ((fc_fuel_map_gpkWh_at_max_trq.*(fc_max_trq.*fc_map_spd/1000)/3600)*fc_fuel_lhv/1000);
   
   % build a matrix of efficiencies for the ddc data indexed by cummins spds and 
   % fraction of max trq at the current speed
   fc_max_trq_frac=[0.05:0.05:1.0];
   fc_eff_map_ddc_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_ddc_new=[fc_eff_map_ddc_new ...
            interp2(fc_map_spd_ddc,fc_map_trq_ddc,fc_eff_map_ddc',fc_map_spd(x),(fc_max_trq_frac*fc_max_trq_ddc_new(x)))];
   end;
   fc_eff_map_ddc_new=fc_eff_map_ddc_new';
   fc_eff_map_ddc_new(:,1)=fc_eff_map_ddc_new(:,2)*0.99;
   fc_eff_map_ddc_new(1,:)=fc_eff_map_ddc_new(2,:)*0.99;
   fc_eff_map_ddc_new(1,1)=fc_eff_map_ddc_new(2,2)*0.99;
   
   % generate new cummins efficiency map indexed by fc_max_trq_frac and cummins spds 
   % by scaling the ddc data by, (cummins eff at max trq/ddc eff at max trq)
   fc_eff_map_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new=[fc_eff_map_new; fc_eff_map_ddc_new(x,:)*(fc_eff_at_max_trq(x)/fc_eff_at_max_trq_ddc(x))];
   end;
   
   % generate new cummins efficiency map indexed by cummins trq and cummins spd vectors
   fc_eff_map_new_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new_new=[fc_eff_map_new_new ...
            interp2(fc_map_spd,(fc_max_trq_frac*fc_max_trq(x)),fc_eff_map_new',fc_map_spd(x),fc_map_trq)];
   end;
   fc_eff_map_new_new=fc_eff_map_new_new';
   
   % fill in gaps in the map
   for x=1:length(fc_map_spd)
      for y=1:length(fc_map_trq)
         if isnan(fc_eff_map_new_new(x,y))
            fc_eff_map_new_new(x,y)=fc_eff_map_new_new(x,y-1)*1.002;
         end;
      end;
   end;
   
   % generate the new fuel consumption and efficiency maps for the cummins data
   [T,w]=meshgrid(fc_map_trq,fc_map_spd);
   fc_map_kW=T.*w/1000;
   fc_fuel_map=1/fc_fuel_lhv./fc_eff_map_new_new.*fc_map_kW*1000;
   fc_eff_map=fc_eff_map_new_new;
   
   % check results
   if 1
      figure
      plot(fc_map_spd*30/pi,fc_max_trq)
      hold
      plot(fc_map_spd*30/pi,fc_max_trq,'rx')
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_eff_map'*100);
      clabel(c)
      
      [T,w]=meshgrid(fc_map_trq,fc_map_spd);
      fc_map_kW=T.*w/1000;
	   fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;

      figure
      plot(fc_map_spd*30/pi,fc_max_trq)
      hold
      plot(fc_map_spd*30/pi,fc_max_trq,'rx')
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_fuel_map_gpkWh',[191 192 193 194 196 197 202]);
      clabel(c)
      
      fc_eff_at_max_trq_new=[];
      for x=1:length(fc_map_spd)
         fc_eff_at_max_trq_new=[fc_eff_at_max_trq_new ...
               interp2(fc_map_spd,fc_map_trq,fc_eff_map',fc_map_spd(x),fc_max_trq(x))];
      end;
      eff_diff=fc_eff_at_max_trq-fc_eff_at_max_trq_new
      
      bsfc=[];
      for x=1:length(fc_map_spd) 
         bsfc=[bsfc interp2(fc_map_spd,fc_map_trq,...
               (fc_fuel_map./fc_map_kW*3600)',fc_map_spd(x),fc_max_trq(x))]; 
      end;
      bsfc_diff=fc_fuel_map_gpkWh_at_max_trq-bsfc
   end;
   
   % clean-up workspace
   clear *ddc *new *gpkWh T w x bsfc eff_diff  fc_eff_at_max_trq fc_max_trq_frac fc_map_kW
   
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 05/28/98 (tm): file created  
% 10/26/98:tm file updated with data from cummins
% 1/20/99:tm added assignments for new thermal modeling parameters
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 5/27/99:tm added inertia value and closed throttle torque values
% 7/9/99:ss added semicolon to end of inertia so it wouldn't display in workspace
% 7/9/99:tm cosmetic changes 
% 11/03/99:ss updated version from 2.2 to 2.21
% 8/18/00:tm revised fc_inertia calculation, reduced equiv. radius from 0.15m to 0.075m
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)

