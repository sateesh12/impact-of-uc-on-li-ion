% ADVISOR Data file:  template_name
%
% Data source:
%
% Data confidence level:  
%
% Notes: 
% template_notes
%
% Created on:  template_date
% By:  template_createdby
%
% Revision history at end of file.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='template_description';  
fc_version=template_version;  				% version of ADVISOR for which the file was generated
fc_proprietary=template_proprietary;  	% 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=template_validation;  		% 1=> no validation, 1=> data agrees with source data, 
							% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='template_fuel_type'; 
fc_disp=template_disp;   			% (L), engine displacement
fc_emis=template_emissions;       				% boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: template_name - ',fc_description]); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine
fc_map_spd=template_map_spd; 

% (N*m), torque range of the engine
fc_map_trq=template_map_trq; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map=template_fuel_map'; 


% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map=template_hc_map'; 

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_co_map=template_co_map'; 

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_nox_map =template_nox_map';  

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map=template_pm_map'; 

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_o2_map=zeros(size(fc_fuel_map));

% create BS** maps for plotting purposes
[T,w]=meshgrid(fc_map_trq,fc_map_spd); 
fc_map_kW=T.*w/1000; 
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600; 
fc_co_map_gpkWh=fc_co_map./fc_map_kW*3600; 
fc_hc_map_gpkWh=fc_hc_map./fc_map_kW*3600; 
fc_nox_map_gpkWh=fc_nox_map./fc_map_kW*3600; 
fc_pm_map_gpkWh=fc_pm_map./fc_map_kW*3600; 

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
    eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps); '])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
fc_max_trq=template_max_trq; 

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
fc_pwr_scale=fc_spd_scale*fc_trq_scale;    % --  scale fc power

% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF THAT SCALES WITH TRQ & SPD SCALES (MASS AND INERTIA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_inertia=template_inertia;            % (kg*m^2), rotational inertia of the engine
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale;  % kW     peak engine power
fc_base_mass=template_base_mass;              	% (kg), mass of the engine block and head (base engine)
                                        				% mass penalty of 1.8 kg/kW from 1994 OTA report, Table 3 
fc_acc_mass=template_acc_mass;              	% kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=template_fuel_mass;             	% kg    mass of fuel and fuel tank
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass;  		% kg  total engine/fuel system mass
fc_ext_sarea=template_ext_sarea;        		% m^2    exterior surface area of engine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=template_fuel_den;  					% (g/l), density of the fuel 
fc_fuel_lhv=template_fuel_lhv;  							% (J/g), lower heating value of the fuel

fc_tstat=template_tstat;                   			% C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=template_cp;                     		% J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=template_h_cp;                   		% J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_hood_sarea=template_hood_sarea;             		% m^2    surface area of hood/eng compt.
fc_emisv=template_emisv;                  		%        emissivity of engine ext surface/hood int surface
fc_hood_emisv=template_hood_emisv;             		%        emissivity hood ext
fc_h_air_flow=template_h_air_flow;             		% kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=template_cl2h_eff;               		% --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=template_c2i_th_cond;            		% W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=template_i2x_th_cond;            		% W/K    conductance btwn engine int & ext
fc_h2x_th_cond=template_h2x_th_cond;             		% W/K    conductance btwn engine & engine compartment

% calculate "predicted" exh gas flow rate and engine-out (EO) temp
fc_ex_pwr_frac=[0.40 0.30];                         % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+14.5);                 % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - T.*w;    % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
spd=fc_map_spd; 
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));        % W   initialize size of ex pwr map
for i=1:length(spd)
 fc_ex_pwr_map(i,:)=fc_waste_pwr_map(i,:)*interp1([min(spd) max(spd)],fc_ex_pwr_frac,spd(i));  % W  trq-spd map of waste heat to exh 
end
fc_extmp_map=template_extmp_map';    % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1; 

% clean up workspace
clear T w fc_waste_pwr_map fc_ex_pwr_map spd fc_map_kW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%template_date: file created using engmodel 

