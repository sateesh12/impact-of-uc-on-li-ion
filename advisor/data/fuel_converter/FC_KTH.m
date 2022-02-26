%---------------------------------------------------------------------------------------------------------------------
% ADVISOR Data file:  FC_KTH.m
%
% Modeling results for a 50kW peak fuel cell system operating on pure hydrogen.
%
% Created on:  04/04/02
% By:  Kristina Haraldsson, National Renewable Energy Laboratory, kristina_haraldsson@nrel.gov
%
% Revision history at end of file.
%----------------------------------------------------------------------------------------------------------------------

% FILE ID INFO
%==============
fc_description='KTH Fuel Cell Model - 50kW (net) Pure Hydrogen Fuel Cell System'; 
fc_version=2003;                % version of ADVISOR for which the file was generated
fc_proprietary=0;               % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=0;                % 0=> no validation, 1=> data agrees with source data, 
                                % 2=> data matches source data and data collection methods have been verified
fc_cold=0;                      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_KTH.m - ',fc_description]);

format long
fcstackinit;                     % To set the fuel cell stack parameters
fc_min_cell_volts = 0.60; % (V) voltage

disp('Data loaded: fcstackinit - input data for the fuel cell system model')

%----------------------------------------------------------
% Calculation of the number of cells needed in the stack
%-----------------------------------------------------------
format long
Comp1050_2

if fc_cell_stack_N<=0
    filename='fc_KTH_lib_init';
    %t=[0:1:100];
    %Options=simset('Solver','ode23tb','ZeroCross','off','RelTol',1e-2,'AbsTol',1e-2);
    %[t,x,y]=sim(filename,t,Options);
    t=[];
    sim(filename,t)
    %disp('Number of cells')
    stack_numcells=ceil(Number(length(Number),:));
    mole_dot_H2=(NinH(length(NinH),:));
    fc_cell_stack_N=stack_numcells;
end;

% Fuel consumption indexed vertically by fc_map_spd and horizontally by fc_map_trq, [g/s]
%-------------------------------------------------------------------------------------------
%fc_pwr_map=[5	7.5	10	20	30	40	50]*1000; % kW (net) including parasitic losses 07/01/03
%fc_eff_map=[49.2	53.3	55.9	59.6	59.1	56.2	50.8]/100; % efficiency indexed by fc_pwr 07/01/03

% Hydrogen
%---------------------------
fc_fuel_lhv=120.0*1000; % (J/g), lower heating value of the fuel

%fc_fuel_map=fc_pwr_map./fc_eff_map./fc_fuel_lhv; % used in block diagram

% To create fuel consumption map [g/kWh]
%---------------------------------------
%fc_fuel_map_gpkWh=(1./fc_eff_map)/fc_fuel_lhv*3600*1000; % used in gui_inpchk plots

% Engine out HC emissions indexed vertically by fc_map_spd and horizontally by fc_map_trq, [g/s]
%------------------------------------------------------------------------------------------------
%fc_hc_map=zeros(size(fc_fuel_map));

% Engine out HC emissions indexed vertically by fc_map_spd and horizontally by fc_map_trq, [g/s]
%------------------------------------------------------------------------------------------------
%fc_co_map=zeros(size(fc_fuel_map));

% Engine out HC emissions indexed vertically by fc_map_spd and horizontally by fc_map_trq, [g/s]
%------------------------------------------------------------------------------------------------
%fc_nox_map=zeros(size(fc_fuel_map)); 

% Engine out PM emissions indexed vertically by fc_map_spd and horizontally by fc_map_trq,[g/s]
%-----------------------------------------------------------------------------------------------
%fc_pm_map=zeros(size(fc_fuel_map));

% Engine out O2 indexed vertically by fc_map_spd and horizontally by fc_map_trq, [g/s]
%--------------------------------------------------------------------------------------
%fc_o2_map=zeros(size(fc_fuel_map));

fc_emis=0;                                         % boolean 0=no emis data; 1=emis data


% COLD ENGINE MAPS
%====================
%fc_cold_tmp=20;                     %deg C
%fc_fuel_map_cold=zeros(size(fc_fuel_map));
%fc_hc_map_cold=zeros(size(fc_fuel_map));
%fc_co_map_cold=zeros(size(fc_fuel_map));
%fc_nox_map_cold=zeros(size(fc_fuel_map));
%fc_pm_map_cold=zeros(size(fc_fuel_map));

%Process Cold Maps to generate Correction Factor Maps
%-----------------------------------------------------
%names={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map'};
%for i=1:length(names)
                                    %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
 %   eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
 %end


% DEFAULT SCALING
%================
fc_pwr_scale=1.0;                                    % --  scale fc power

%The following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1.0;                                    % -- scale the efficiency
fc_trq_scale=1.0;                                    % -- required only for autosize and optimization routines
fc_spd_scale=1.0;                                    % -- required only for autosize and optimization routines


% OTHER DATA
%============
fc_fuel_cell_model=4;                                % 1--> polarization curves, 2--> pwr vs. eff, 3--> gctool model,4--> KTH fc system model
fc_fuel_type='Hydrogen';
fc_fuel_den=0.018*1000;                              % density of the fuel, [g/l], to be changed into a function of pressure & temperature


fc_max_pwr=(fc_cell_stack_Pel/1000)*fc_pwr_scale;          % peak engine power, [kW]
fc_base_mass=2.0*fc_max_pwr;                         % mass of the fuel cell stack, [kg], assuming mass penalty of 2 kg/kW
fc_acc_mass=1.0*fc_max_pwr;                          % kg   mass of fuel cell accy's, electrics, cntrl's - assumes mass penalty of 1 kg/kW 
fc_fuel_mass=0.6*fc_max_pwr;                         % kg   mass of fuel and fuel tank 
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass;       % kg  total engine/fuel system mass

% Variables not applicable to a fuel cell but needed for use of engine block diagram
%------------------------------------------------------------------------------------
fc_tstat=80;                  % C      engine coolant thermostat set temperature (typically 80 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_ext_sarea=2*(0.3*0.3)+4*(0.3*0.6);             % m^2    exterior surface area of engine
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment
fc_ex_pwr_frac=[0.20 0.10];                        % --   frac of waste heat that goes to exhaust as func of power level, (SAE 2000-01-0373)
%fc_exflow_map=fc_fuel_map*(1+91);                % g/s  ex gas flow map:  for fuel cell  exflow=(fuel use)*[1 + (A/F ratio)], where 1.5*H2+2.0*(O2+3.774*N2)==>H20+0.5H2+0.5O2+2.0*3.774*N2, where 1.5=anode stoich, and 2.0=cathode stoich
%fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - fc_pwr_map;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
%fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
%for i=1:length(fc_pwr_map)
% fc_ex_pwr_map(i)=fc_waste_pwr_map(i)*interp1([min(fc_pwr_map) max(fc_pwr_map)],fc_ex_pwr_frac,fc_pwr_map(i)); % W  pwr map of waste heat to exh 
%end
%fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

% Variables not used by assigned as placeholders in polarization curve model
%----------------------------------------------------------------------------
%Comp1050_2;
    
max_eff1=fc_max_pwr*1000/(mole_dot_H2*cell_const_LHV_H2);

% Number of stacks connected in series per string
%------------------------------------------------
fc_stack_num=1;

% Number of strings connected in parallel
%-----------------------------------------
fc_string_num=1; 

% Cell current density (amps/m^2), removed kh 4/12/02
%--------------------------------
%fc_I_map=[1:length(fc_fuel_map)]/fc_cell_area; % original data as stack current, amps
%fc_I_map=[1:length(fc_fuel_map)]/FC.Stack.Cell.Dim.A % 

% Cell voltage (V) indexed by fc_I_map removed kh 4/12/02
%-------------------------------------
%fc_V_map=[1:length(fc_fuel_map)]/fc_cell_num % original data as stack voltage, volts

% Fuel usage (g/s) indexed by fc_I_map removed kh 4/12/02
%-------------------------------------
%fc_fuel_map=[0.0010    0.0300    0.0600    0.1300    0.1900    0.2500    0.3400	0.4000]/fc_cell_num; % original data as stack fuel flow, g/s
% fuel utilization factor indexed by fc_I_map (fuel consumed/fuel supplied)
%fc_fuel_utilization_map=[1:length(fc_fuel_map)]; % unknown

% User definable mass scaling function
%--------------------------------------
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function

fc_plot_pwr_map=[1 2 5 10 15 20 25 35 45 55]*1000; % vector of power point at which to calc efficiency for plotting
fc_plot_tmp_map=[80]; % vector of temps at which to calculate effieicny for plotting
%--------------------------------------------------------------------------------------------------------------------
% REVISION HISTORY
% 4/09/02: kh changed fc_description (Simulink block name)
% 4/10/02: kh added comment on fuel cell model option #4
% 4/12/02: kh added FC_stackinit, added massflow, pressure, temperature and power input for OA 1050 compressor
% 05/10 02: kh changed name of file to FC_KTH
% 05/23/02: kh added iteration of number of cells
% 01/13/03: KH removed unused stuff
% 01/24/03 KH removed unused stuff and added "output" variables from fcstackinit
% 04/28/03 KH added "output" variables from fcstackinit
% 05/02/03 KH changed name of the KTH fc system model related variables (from structure type to script type)