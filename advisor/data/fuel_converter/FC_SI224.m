% ADVISOR Data file:  FC_SI224.m
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
fc_description='Cummins L10-300G (224 kW) LNG Engine'; % one line descriptor identifying the engine
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='LNG';
fc_disp=10.0; % (L) engine displacement
fc_emis=0;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_SI224.M - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=[1100 1200 1300 1400 1500 1600 1700 1800 1900 2100]*2*pi/60; 

% (N*m), torque range of the engine
fc_map_trq=[100:100:1300]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map =[
    1.2852    1.9885    2.5767    3.0856    3.5948    4.1828    4.8270    5.4884    6.1430    6.7992    7.4484    8.1093    8.7676
    1.2877    2.0533    2.8080    3.3731    3.9572    4.6283    5.3513    6.0777    6.8001    7.5045    8.1638    8.8882    9.6096
    1.3966    2.2200    2.8613    3.5247    4.1741    4.8774    5.6139    6.3528    7.0863    7.8028    8.5033    9.1846    9.9301
    1.5686    2.4833    3.0103    3.8167    4.6021    5.3766    6.1786    6.9683    7.7448    8.5027    9.2707   10.0933   10.9126
    1.7091    2.7450    3.3556    4.2119    5.0548    5.8836    6.7574    7.6280    8.4837    9.3145   10.1599   11.0614   11.9593
    1.8879    3.0738    3.7808    4.7087    5.6232    6.5198    7.4894    8.4621    9.4181   10.3392   11.2828   12.2840   13.2811
    2.0033    3.2960    4.1255    5.1018    6.0886    7.0659    8.1080    9.1487   10.1827   11.1799   12.1891   13.2706   14.3478
    2.0802    3.4543    4.3861    5.4080    6.4462    7.5027    8.5876    9.6743   10.7684   11.8236   12.9799   14.1317   15.2788
    2.1574    3.6122    4.6014    5.6756    6.7591    7.8925    8.9959   10.1042   11.2495   12.3796   13.5904   14.7963   15.9974
    2.4188    4.2045    5.2453    6.3815    7.5129    8.7041    9.8927   11.0890   12.4006   13.7025   15.0426   16.3774   17.7067];
% The above map was generate using the lines of code encased in an 
% if exist('fc_fuel_map') statement provided at the end of this file.
% The map takes on the shape of the John Deere 8.1L NG engine while maintaining 
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
fc_max_trq=[1139 1180 1220 1191 1163 1134 1106 1077 1047 1017]; 
% pad for idle condition and overspd condition
%fc_max_trq=[fc_max_trq(1)*0.95 fc_max_trq fc_max_trq(end)*0.9]; 
% pad for idle condition
fc_max_trq=[fc_max_trq(1)*0.95 fc_max_trq]; 

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd 
%fc_ct_trq=zeros(size(fc_map_spd)); % no Jake Brake installed 
% fc_ct_trq=[80 105 140 185 240 285]; % with Jake Brake Model 404D installed 
fc_friction_trq=[-132 -182]; % friction torque at 1300 and 2100 rpm
fc_ct_trq=interp1([1300 2100]*pi/30,fc_friction_trq,fc_map_spd);
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
%fc_mass=983; % (kg), mass of the engine (reported mass)
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine

fc_inertia=fc_mass*(1/3+1/3*2/3)*(0.15^2); 
% assumes 1/3 purely rotating mass, 1/3 purely oscillating, and 1/3 stationary
% and crank radius of 0.25m, 2/3 of oscilatting mass included in rotational inertia calc
% correlation from Bosch handbook p.379

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.424*1000; % (g/l), density of the fuel 
fc_fuel_lhv=49.7*1000; % (J/g), lower heating value of the fuel

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
clear T w fc_waste_pwr_map fc_ex_pwr_map spd fc_map_kW
clear m b i fc_friction_trq

% Routine to build the fuel map provided above
if ~exist('fc_fuel_map')
   
   %%%% JD Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd_jd=[600 800 1000 1200 1400 1600 1800 2000 2200]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq_jd=[0 50 100 200 300 400 500 600 700 800]*1055/778.16; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_map_bte_jd = [
      8    13   21	28.5 29.5	35.5	35.5	36		36.5	36.5
      10	  15   20	30	  35		37.3	37.6	37.8	37.6	37.3
      13	  17   22	31	  36		38		38.2	38.5	38.5	38.5
      14	  20   26.5	30.5 35.6	37.1	37.5	37.8	38.2	39.1
      16	  20   23.5	33.2 35.5	37		37.8	38.5	39.2	39.5
      18	  20.5 23	32.4 35.1	37.2	37.9	38.5	39.2	39.5
      18.5 21	 23.9	31.7 34.9	36.6	37.6	38.2	38.9	39.3
      19	  21.2 24	31	  34.5	35.8	37.3	37.9	38.3 	38.3
      19	  20.5 21	30	  33.6	36.1	37		36.9	37.5	37.5]./100; 
   % brake thermal efficiency in decimal percent
   
   % convert map from bte to gps
   [T,w]=meshgrid(fc_map_trq_jd,fc_map_spd_jd);
   fc_map_kW_jd=T.*w/1000;
   fc_fuel_lhv_jd=47.0*1000; % (J/g), lower heating value of CNG
   fc_fuel_map_jd=1/fc_fuel_lhv_jd./fc_map_bte_jd.*fc_map_kW_jd*1000;
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq_jd=[400 500 687.5 785 790 762.5 715 665 597]*1055/778.16;
   
   
   %%%% Cummins Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd=[1100 1200 1300 1400 1500 1600 1700 1800 1900 2100]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq=[100:100:1300]; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_fuel_map_gpkWh_at_max_trq=[211 210 202 206 211 220 224 224 223 224];
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq=[1139 1180 1220 1191 1163 1134 1106 1077 1047 1017]; 
   
   fc_fuel_lhv=49.7*1000; % (J/g), lower heating value of the fuel
   
   
   %%%%% Build new efficiency and fuel consumptions maps
   
   % find jd max trqs corresponding to cummins spds
   fc_max_trq_jd_new=interp1(fc_map_spd_jd,fc_max_trq_jd,fc_map_spd);
   %fc_max_trq_jd_new(1)=fc_max_trq_jd_new(2)*0.99;
   
   % build jd efficiency and fuel consumption maps
   %[T,w]=meshgrid(fc_map_trq_jd,fc_map_spd_jd);
   %fc_map_kW_jd=T.*w/1000;
   %fc_fuel_map_jd=fc_fuel_map_gpkWh_jd.*fc_map_kW_jd/3600;
   %fc_eff_map_jd=fc_map_kW_jd./(fc_fuel_map_jd*fc_fuel_lhv_jd/1000);
   fc_eff_map_jd=fc_map_bte_jd;
   
   % find jd efficiency along the max trq curve corresponding to the cummins spds
   fc_eff_at_max_trq_jd=[];
   for x=1:length(fc_map_spd)
      fc_eff_at_max_trq_jd=[fc_eff_at_max_trq_jd ...
            interp2(fc_map_spd_jd,fc_map_trq_jd,fc_eff_map_jd',fc_map_spd(x),fc_max_trq_jd_new(x))];
   end;
   %fc_eff_at_max_trq_jd(1)=fc_eff_at_max_trq_jd(2)*0.9999;
   
   % calculate the efficiency along the max trq curve for the cummins data
   fc_eff_at_max_trq=(fc_max_trq.*fc_map_spd/1000)./...
      ((fc_fuel_map_gpkWh_at_max_trq.*(fc_max_trq.*fc_map_spd/1000)/3600)*fc_fuel_lhv/1000);
   
   % build a matrix of efficiencies for the jd data indexed by cummins spds and 
   % fraction of max trq at the current speed
   fc_max_trq_frac=[0.05:0.05:1.0];
   fc_eff_map_jd_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_jd_new=[fc_eff_map_jd_new ...
            interp2(fc_map_spd_jd,fc_map_trq_jd,fc_eff_map_jd',fc_map_spd(x),(fc_max_trq_frac*fc_max_trq_jd_new(x)))];
   end;
   fc_eff_map_jd_new=fc_eff_map_jd_new';
   %fc_eff_map_jd_new(:,1)=fc_eff_map_jd_new(:,2)*0.99;
   %fc_eff_map_jd_new(1,:)=fc_eff_map_jd_new(2,:)*0.99;
   %fc_eff_map_jd_new(1,1)=fc_eff_map_jd_new(2,2)*0.99;
   
   % generate new cummins efficiency map indexed by fc_max_trq_frac and cummins spds 
   % by scaling the jd data by, (cummins eff at max trq/jd eff at max trq)
   fc_eff_map_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new=[fc_eff_map_new; fc_eff_map_jd_new(x,:)*(fc_eff_at_max_trq(x)/fc_eff_at_max_trq_jd(x))];
   end;
   
   % generate new cummins efficiency map indexed by cummins trq and cummins spd vectors
   fc_eff_map_new_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new_new=[fc_eff_map_new_new ...
            interp2(fc_map_spd,(fc_max_trq_frac*fc_max_trq(x)),fc_eff_map_new',fc_map_spd(x),fc_map_trq)];
   end;
   fc_eff_map_new_new=fc_eff_map_new_new';
   
   % fill in gaps in the map
   if 1
      for x=1:length(fc_map_spd)
         for y=1:length(fc_map_trq)
            if isnan(fc_eff_map_new_new(x,y))
               fc_eff_map_new_new(x,y)=fc_eff_map_new_new(x,y-1)*1.002;
            end;
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
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_eff_map'*100,[18:2:34]);
      clabel(c)
      title('Cummins Efficiency Map')
      xlabel('Speed (rpm)')
      ylabel('Torque (Nm)')
      
      figure
      plot(fc_map_spd_jd*30/pi,fc_max_trq_jd)
      hold
      plot(fc_map_spd_jd*30/pi,fc_max_trq_jd,'rx')
      c=contour(fc_map_spd_jd*30/pi,fc_map_trq_jd,fc_eff_map_jd'*100,[10:4:38 39]);
      clabel(c)
      title('John Deere Efficiency Map')
      xlabel('Speed (rpm)')
      ylabel('Torque (Nm)')
      
      [T,w]=meshgrid(fc_map_trq,fc_map_spd);
      fc_map_kW=T.*w/1000;
      fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;
      
      figure
      plot(fc_map_spd*30/pi,fc_max_trq)
      hold
      plot(fc_map_spd*30/pi,fc_max_trq,'rx')
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_fuel_map_gpkWh',[201 205 210 215 220 235 250 275 300 350 400]);
      clabel(c)
      title('Cummins BSFC Map')
      xlabel('Speed (rpm)')
      ylabel('Torque (Nm)')
      
      [T,w]=meshgrid(fc_map_trq_jd,fc_map_spd_jd);
      fc_map_kW_jd=T.*w/1000;
      fc_fuel_map_gpkWh_jd=fc_fuel_map_jd./fc_map_kW_jd*3600;
      
      figure
      plot(fc_map_spd_jd*30/pi,fc_max_trq_jd)
      hold
      plot(fc_map_spd_jd*30/pi,fc_max_trq_jd,'rx')
      c=contour(fc_map_spd_jd*30/pi,fc_map_trq_jd,fc_fuel_map_gpkWh_jd',[193 195 200 205 210 220 235 250 300 400 500]);
      clabel(c)
      title('John Deere BSFC Map')
      xlabel('Speed (rpm)')
      ylabel('Torque (Nm)')
      
      fc_eff_at_max_trq_new=[];
      for x=1:length(fc_map_spd)
         fc_eff_at_max_trq_new=[fc_eff_at_max_trq_new ...
               interp2(fc_map_spd,fc_map_trq,fc_eff_map',fc_map_spd(x),fc_max_trq(x))];
      end;
      diff_eff=(fc_eff_at_max_trq-fc_eff_at_max_trq_new)./fc_eff_at_max_trq*100;
      
      bsfc=[];
      for x=1:length(fc_map_spd) 
         bsfc=[bsfc interp2(fc_map_spd,fc_map_trq,...
               (fc_fuel_map./fc_map_kW*3600)',fc_map_spd(x),fc_max_trq(x))]; 
      end;
      diff_bsfc=(fc_fuel_map_gpkWh_at_max_trq-bsfc)./fc_fuel_map_gpkWh_at_max_trq*100;
      
      figure
      bar(fc_map_spd*30/pi,[diff_eff' diff_bsfc'])
      title('Comparison of Original Data and Generated Data')
      legend('Efficiency', 'BSFC')
      xlabel('Speed (rpm)')
      ylabel('Percent Difference')
      
   end;
   
   % clean-up workspace
   clear *jd *new *gpkWh T w x bsfc eff_diff  fc_eff_at_max_trq fc_max_trq_frac fc_map_kW
   
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 05/28/98 (tm): file created  
% 10/21/98:tm updated with new data from Cummins
% 10/22/98:tm implemented routine to build accurate fuel consumption map 
%             based on given Cummins data and known DDC map
% 1/20/99:tm added assignments for new thermal modeling parameters
% 1/20/99:tm updated fuel consumption map so that it is based on a John Deere NG engine
% 2/23/98:tm updated to be included with March 99 release
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 5/27?99:tm added inertia value and closed throttle torque values
% 7/9/99:tm cosmetic changes
% 11/03/99:ss updated version from 2.2 to 2.21
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 7/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
