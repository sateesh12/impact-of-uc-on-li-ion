function  autosize(display_flag, grade_input, accel_input, dv_bounds)

%function  autosize(display_flag, grade_goals, accel_goals, grade_tols, accel_tols, dv_bounds)

%function  autosize(grade_mph,grade_grade,accel_0_18,accel_0_30,accel_0_60,accel_40_60,accel_0_85,grade_mph_tol,grade_grade_tol,accel_0_18_tol,accel_0_30_tol,accel_0_60_tol,accel_40_60_tol,accel_0_85_tol,optimize_cs,optimze_mc)

% This function will automatically optimize the power output 
% and adjust the mass of specific components accordingly in conventional, series, and 
% parallel vehicles with the criteria that the vehicle satisfies 
% all of the input performance targets. If no arguments are provided the 
% function will use the PNGV targets as the default performance targets.
%
% Input arguments: default values in []
%  display_flag - boolean, 1 provide graphical display, 0 no display
% grade_input - structure containing all parameters necessary to run grade_test
% accel_input - structure containing all parameters necessary to run accel_test
%  dv_bounds - 2x3 matrix containing the upper and lower bounds for the fc, ess, and mc
% 
% For a series hybrid vehicle,
% 1) Scale fuel converter to meet the grade test goals. While ensuring 
% that the motor/controller can handle peak power of the fuel converter. (only grade is a constraint)
% 2) Scale the number of energy storage modules to meet the acceleration 
% test goals while ensuring that the motor/controller can handle the peak 
% power of the energy storage system and the fuel converter. (only acceleration is a constraint)
% 2a) Reduce the motor size if possible (only if motor was selected as a design variable)
% 2b) Reduce the number of energy storage modules if possible (only if cs_hi_soc was selected as a design variable)
% 2c) Adjust the cs_lo_soc setting such that it is equal to the average of the best 
% discharge and the best charge SOC given the current battery pack characteristics. (only if cs_lo_soc is a design variable)
% 2d) Reduce the cs_hi_soc setting if possible (only if cs_hi_soc was selected as a design variable)   
% 3) If the number of energy storage modules or the motor size was changed in (2) then 
% verify that the vehicle can still meet the grade test goals.  Adjust 
% per (1) if necessary.
% 4) If the fuel converter or the motor size was changed in (3) then verify that the 
% acceleration test goals can be meet.  Adjust per (2) if necessary.
% 5) Repeat steps 3 and 4 until the system stabilizes.
%
% For a conventional vehicle, do the following:
% 1) Scale the fuel converter to meet the acceleration test goals. (only if acceleration is a constraint)
% 2) Scale the fuel converter to meet the grade test goals. (only if grade is a constraint)
% 3) If fuel converter size was increased in (2) then verify that 
%    the acceleration test goals can be meet. Increase if necessary.
% 4) If the fuel converter was increased in (3), verify that the 
%    vehicle still meets the grade test goals. Increase fuel converter 
%    size if necessary.
%
% For a parallel hybrid vehicle, do the following:
% 1) Minimize the energy storage system and motor/controller systems.
% 2) Scale fuel converter to meet the grade test goals. (only if grade is a constraint)
% 3) Scale fuel converter to meet the acceleration test goals. (only if acceleration is a constraint)
% 4) Set fuel converter size to a value somewhere between that required for the
% grade and that required for the acceleration based on the level of hybridization parameter (default=0.5).
% 5) Scale the energy storage system and motor/contoller to meet the acceleration test goals. (only if acceleration is a constraint)
% 6) Verify the grade test results if the energy storage system size was increased in (5).
% 7) Verify the acceleration test results of the fuel converter size was increased in (6).
%
% Created on:  07/27/98  
% By:  Tony Markel, NREL, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%
% GUI FUNCTIONALITY
%%%%%%%%%%%%%%%%%%%%%%%%
% define vinf as a global variable 
global vinf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE PERFORMANCE TARGETS AND TOLERANCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Targets
if 0 % 1/25/00:tm disabled %~nargin % no arguments provided
   display_flag=1;
   
   % use PNGV performance targets if no arguments provided
   grade_mph=55; % (mph)
   grade_grade=6; % (%)
   accel_0_18=-1; % (s)
   accel_0_30=-1; % (s)
   accel_0_60=12; % (s)
   accel_40_60=5.3; % (s)
   accel_0_85=23.4; % (s)
   
   % default Tolerances
   grade_mph_tol=0.001; % (mph)
   grade_grade_tol=0.05; % (%) 
   accel_0_18_tol=0.02; % (s)
   accel_0_30_tol=0.02; % (s)
   accel_0_60_tol=0.02; % (s)
   accel_0_85_tol=0.05; % (s) 
   accel_40_60_tol=0.02; % (s)
   
elseif 0%nargin==1 % only display flag defined
   % use PNGV performance targets if no arguments provided
   grade_mph=55; % (mph)
   grade_grade=6; % (%)
   accel_0_18=-1; % (s)
   accel_0_30=-1; % (s)
   accel_0_60=12; % (s)
   accel_40_60=5.3; % (s)
   accel_0_85=23.4; % (s)
   
   % default Tolerances
   grade_mph_tol=0.001; % (mph)
   grade_grade_tol=0.05; % (%) 
   accel_0_18_tol=0.02; % (s)
   accel_0_30_tol=0.02; % (s)
   accel_0_60_tol=0.02; % (s)
   accel_0_85_tol=0.05; % (s) 
   accel_40_60_tol=0.02; % (s)
   
elseif 0%nargin==3 % display flag and goals provided
   % default Tolerances
   grade_mph_tol=0.001; % (mph)
   grade_grade_tol=0.05; % (%) 
   accel_0_18_tol=0.02; % (s)
   accel_0_30_tol=0.02; % (s)
   accel_0_60_tol=0.02; % (s)
   accel_0_85_tol=0.05; % (s) 
   accel_40_60_tol=0.02; % (s)
   
elseif 0%nargin<5
   disp('Not enough arguments provided!')
   help autosize % provide the proper format to the user
   return
else
   if 0 % 1/25/01:tm disabled % use user-defined performance targets
      grade_mph=grade_goals(1); % (mph)
      grade_grade=grade_goals(2); % (%)
      accel_0_18=accel_goals(1); % (s)
      accel_0_30=accel_goals(2); % (s)
      accel_0_60=accel_goals(3); % (s)
      accel_0_85=accel_goals(4); % (s)
      accel_40_60=accel_goals(5); % (s)
      % user-defined tolerances
      grade_mph_tol=grade_tols(1); % (mph)
      grade_grade_tol=grade_tols(2); % (%) 
      accel_0_18_tol=accel_tols(1); % (s)
      accel_0_30_tol=accel_tols(2); % (s)
      accel_0_60_tol=accel_tols(3); % (s)
      accel_0_85_tol=accel_tols(4); % (s) 
      accel_40_60_tol=accel_tols(5); % (s)
   end
   
   if ~isempty(grade_input)
      % setup function calls to grade test
      checkbox_tags={'grade',...
            'speed',...
            'duration',...
            'gear_num',...
            'ess_init_soc',...
            'ess_min_soc',...
            'grade_lb',...
            'grade_ub',...
            'grade_init_step',...
            'speed_tol',...
            'grade_tol',...
            'max_iter',...
            'disp_status'};
      i=1;
      for c=1:length(checkbox_tags)
         if grade_input.param.active(c)
            input.grade.param{i}=checkbox_tags{c};
            input.grade.value{i}=eval(['grade_input.param.',checkbox_tags{c}]);
            i=i+1;
         end
      end
      c=c+1;
      c=c+1;
      if grade_input.param.active(c)
         input.grade.param{i}='disable_systems';
         input.grade.value{i}=grade_input.param.disable_systems;
         i=i+1;
      end
      c=c+1;
      if grade_input.param.active(c)
         input.grade.param{i}='disable_systems';
         input.grade.value{i}=grade_input.param.disable_systems;
         i=i+1;
      end
      c=c+1;
      c=c+1;
      if grade_input.param.active(c)
         input.grade.param{i}='override_mass';
         input.grade.value{i}=grade_input.param.override_mass;
         i=i+1;
      end
      c=c+1;
      if grade_input.param.active(c)
         input.grade.param{i}='add_mass';
         input.grade.value{i}=grade_input.param.add_mass;
         i=i+1;
      end
      
      grade_mph=grade_input.param.speed;
      grade_grade=grade_input.param.grade;
      grade_mph_tol=grade_input.param.speed_tol;
      grade_grade_tol=grade_input.param.grade_tol;
   end
   if ~isempty(accel_input)
      % setup acceleration test function calls
      i=1;
      if accel_input.param.active(1)
         input.accel.param{i}='gb_shift_delay';
         input.accel.value{i}=accel_input.param.gb_shift_delay;
         i=i+1;
      end
      if accel_input.param.active(2)
         input.accel.param{i}='ess_init_soc';
         input.accel.value{i}=accel_input.param.ess_init_soc;
         i=i+1;
      end
      mat=[];
      if accel_input.param.active(3)
         mat=[mat; accel_input.param.spds1];
      end
      if accel_input.param.active(4)
         mat=[mat; accel_input.param.spds2];
      end
      if accel_input.param.active(5)
         
         mat=[mat; accel_input.param.spds3];
      end
      if ~isempty(mat)
         input.accel.param{i}='spds';
         input.accel.value{i}=mat;
         i=i+1;
      end
      if accel_input.param.active(6)
         input.accel.param{i}='dist_in_time';
         input.accel.value{i}=accel_input.param.dist_in_time;
         i=i+1;
      end
      if accel_input.param.active(7)
         input.accel.param{i}='time_in_dist';
         input.accel.value{i}=accel_input.param.time_in_dist;
         i=i+1;
      end
      if accel_input.param.active(8)
         input.accel.param{i}='max_rate_bool';
         input.accel.value{i}=1;
         i=i+1;
      end
      if accel_input.param.active(9)
         input.accel.param{i}='max_speed_bool';
         input.accel.value{i}=1;
         i=i+1;
      end
      if accel_input.param.active(11)
         input.accel.param{i}='disable_systems';
         input.accel.value{i}=1;
         i=i+1;
      end
      if accel_input.param.active(12)
         input.accel.param{i}='disable_systems';
         input.accel.value{i}=2;
         i=i+1;
      end
      if accel_input.param.active(14)
         input.accel.param{i}='override_mass';
         input.accel.value{i}=accel_input.param.override_mass;
         i=i+1;
      end
      if accel_input.param.active(15)
         input.accel.param{i}='add_mass';
         input.accel.value{i}=accel_input.param.add_mass;
         i=i+1;
      end
      
      %build the accel_targets vector
      accel_targets=[];
      accel_equality=[];
      accel_target_tols=[];
      
      if accel_input.param.active(3)
         accel_targets=[accel_targets, accel_input.param.accel_time1_con];
         accel_target_tols=[accel_target_tols, accel_input.param.accel_time1_tol];
         accel_equality=[accel_equality,1];
      end
      if accel_input.param.active(4)
         accel_targets=[accel_targets, accel_input.param.accel_time2_con];
         accel_target_tols=[accel_target_tols, accel_input.param.accel_time2_tol];
         accel_equality=[accel_equality,1];
      end
      if accel_input.param.active(5)
         accel_targets=[accel_targets, accel_input.param.accel_time3_con];
         accel_target_tols=[accel_target_tols, accel_input.param.accel_time3_tol];
         accel_equality=[accel_equality,1];
      end
      if accel_input.param.active(6)
         accel_targets=[accel_targets, accel_input.param.dist_in_time_con];
         accel_target_tols=[accel_target_tols, accel_input.param.dist_in_time_tol];
         accel_equality=[accel_equality,-1];
      end
      if accel_input.param.active(7)
         accel_targets=[accel_targets, accel_input.param.time_in_dist_con];
         accel_target_tols=[accel_target_tols, accel_input.param.time_in_dist_tol];
         accel_equality=[accel_equality,1];
      end
      if accel_input.param.active(8)
         accel_targets=[accel_targets, accel_input.param.max_accel_con];
         accel_target_tols=[accel_target_tols, accel_input.param.max_accel_tol];
         accel_equality=[accel_equality,-1];
      end
      if accel_input.param.active(9)
         accel_targets=[accel_targets, accel_input.param.max_spd_con];
         accel_target_tols=[accel_target_tols, accel_input.param.max_spd_tol];
         accel_equality=[accel_equality,-1];
      end
      
      % temporarily define the tolerances here
      %accel_target_tols=accel_targets*0.005;
   end
end

% setup constraint data
eval('h=vinf.autosize.constraints; test4exist=1;','test4exist=0;')
if ~test4exist
   constraints_bool=[1 1]; % grade and accel constraints on
else
   constraints_bool=vinf.autosize.constraints;   
end

% setup design variable data
eval('h=vinf.autosize.dv; test4exist=1;','test4exist=0;')
if ~test4exist
   if strcmp(vinf.drivetrain.name,'conventional')
      design_vars_bool=[1 0 0 0 0 1]; % fuel converter on; 
      % energy storage, motor, cs_lo_soc and cs_hi_soc off as design variables
   elseif strcmp(vinf.drivetrain.name,'ev')
      design_vars_bool=[0 1 1 0 0 1]; % energy storage, and motor on; 
      % fuel converter, cs_lo_soc and cs_hi_soc off as design variables
   else % vehicle is a hybrid
      design_vars_bool=[1 1 1 0 0 1]; % fuel converter, energy storage, and motor on; 
      % cs_lo_soc and cs_hi_soc off as design variables
   end
else
   design_vars_bool=vinf.autosize.dv;  
end

% setup goal max vehicle speed
eval('h=vinf.autosize.con.max_spd; test4exist=1;','test4exist=0;')
if ~test4exist
   max_spd=90; % mph
else
   max_spd=vinf.autosize.con.max_spd;
end
if 0
   % setup accel target and tolerance vectors
   accel_targets=[
      accel_0_18,...
         accel_0_30,...
         accel_0_60,...
         accel_0_85,...
         accel_40_60];
   
   accel_target_tols=[
      accel_0_18_tol,...
         accel_0_30_tol,...
         accel_0_60_tol,...
         accel_0_85_tol,...
         accel_40_60_tol];
   
   
   % temporary overrides tm:1/23/00
   accel_targets=[
      accel_0_60,...
         accel_0_85,...
         accel_40_60];
   
   accel_target_tols=[
      accel_0_60_tol,...
         accel_0_85_tol,...
         accel_40_60_tol];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE MINIMUM CONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fuel convertor
if ~strcmp(vinf.drivetrain.name,'ev')
   if exist('dv_bounds')
      fc_min_trq_scale=dv_bounds(1,1);
   else
      fc_min_pwr=40000;	% (W) smallest allowed peak capability fuel converter
      if evalin('base','exist(''fc_fuel_cell_model'')')
         fc_min_trq_scale=round(fc_min_pwr/evalin('base','calc_max_pwr(''fuel_converter'')*1000/fc_pwr_scale')*1000)/1000;
      else
         fc_min_trq_scale=round(fc_min_pwr/(evalin('base','max(fc_map_spd.*fc_max_trq)*fc_spd_scale'))*1000)/1000;
      end
   end
end

% generator/controller
if evalin('base','exist(''gc_map_spd'')')
   gc_min_pwr=5000;	% (W) smallest allowed peak capability for the generator/controller
   gc_min_trq_scale=round(gc_min_pwr/(evalin('base','max(gc_map_spd.*gc_max_trq)*gc_spd_scale'))*1000)/1000;
end;

% motor/controller
if evalin('base','exist(''mc_map_spd'')')
   if exist('dv_bounds')
      mc_min_trq_scale=dv_bounds(3,1);
   else
      mc_min_pwr=15000;	% (W) smallest allowed peak capability for the motor controller
      mc_min_trq_scale=round(mc_min_pwr/(evalin('base','max(mc_map_spd.*mc_max_trq)*mc_spd_scale'))*1000)/1000;
   end
end;

% energy storage system
if evalin('base','exist(''ess_voc'')')
   if exist('dv_bounds')
      ess_min_module_num=dv_bounds(2,1);
   else
      ess_min_voltage=evalin('base','mc_min_volts'); % (volts) smallest allowed energy storage system voltage
      ess_min_module_num=round(ess_min_voltage/evalin('base','ess_min_volts'));
   end;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE MAXIMUM CONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fuel convertor
if ~strcmp(vinf.drivetrain.name,'ev')
   if exist('dv_bounds')
      fc_max_trq_scale=dv_bounds(1,2);
   else
      fc_max_trq_scale=4.0;
   end;
end

% generator/controller
if evalin('base','exist(''gc_trq_scale'')')
   gc_max_trq_scale=100.0;
end;

% motor/controller
if evalin('base','exist(''mc_trq_scale'')')
   if exist('dv_bounds')
      mc_max_trq_scale=dv_bounds(3,2);
   else
      mc_max_trq_scale=5.0;
   end
end;

% energy storage system
if evalin('base','exist(''ess_voc'')')
   if exist('dv_bounds')
      ess_max_module_num=dv_bounds(2,2);
   else
      ess_max_voltage=5*evalin('base','mc_min_volts'); % (volts) largest allowed system voltage
      ess_max_module_num=round(ess_max_voltage/evalin('base','ess_max_volts'));	
   end;
end


%%%%%%%%%%%%%%%%%%%%%%%%
% INTITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%

% get the current drivetrain type
drivetrain=vinf.drivetrain.name;

% size a fuel cell vehicle like a series vehicle and set fuel cell vehicle flag
if strcmp(drivetrain,'fuel_cell')
   drivetrain='series';
   fuelcell=1;
else
   fuelcell=0;
end;

% initialize final drive ratio changed flag
fd_ratio_changed=0;
fd_ratio_default=evalin('base','fd_ratio');

% define the maximum number of iterations to perform in any loop
max_iter=10;

% turn off all emissions calculations to save simulation time
if evalin('base','exist(''ex_calc'')')
   ex_calc_default=evalin('base','ex_calc');
   evalin('base','ex_calc=0;')
end

% turn off all thermal calculations to save simulation time
% if evalin('base','exist(''ess_th_calc'')')
%    ess_th_calc_default=evalin('base','ess_th_calc');
%    evalin('base','ess_th_calc=0;')
% end
if evalin('base','exist(''mc_th_calc'')')
   mc_th_calc_default=evalin('base','mc_th_calc');
   evalin('base','mc_th_calc=0;')
end

if strcmp(drivetrain,'parallel')&constraints_bool(1)&constraints_bool(2)
   % set level of hybridization
   if exist('hybridize')
      hybridize('load')
   else
      assignin('base','hybridization',0.5)
   end
   
   % override default fc min size
   %fc_min_trq_scale=fc_min_trq_scale/2; 
   % effectively makes the minimum fc size 20kW
end

init_conds

if constraints_bool(1)
   % perform grade test
   max_grade=calc_grade(input,'multi');
   
   % check results
   grade_achieved=check_grade_results('tolerance');
else
   grade_achieved=0;
end

if constraints_bool(2)
   % perform acceleration test
   accel_results=calc_accel(input);
   
   % check results
   accel_achieved=check_accel_results('tolerance');
else
   accel_achieved=0;
end

if display_flag
   % initialize plots
   assignin('base','counter',0)
   update_plot; drawnow
end

% store current values
if ~strcmp(drivetrain,'conventional')
   mc_trq_scale_grade=evalin('base','mc_trq_scale');
   ess_module_num_grade=evalin('base','ess_module_num');
   mc_trq_scale_accel=evalin('base','mc_trq_scale');
   ess_module_num_accel=evalin('base','ess_module_num');
end
if ~strcmp(drivetrain,'ev')
   fc_trq_scale_grade=evalin('base','fc_trq_scale');
   fc_trq_scale_accel=evalin('base','fc_trq_scale');
end

% motor optimization flag
if 0 %design_vars_bool(3)&~strcmp(drivetrain,'conventional') %revised 03/15/00:tm do not override mc_overtrq_factor
   mc_overtrq_factor_default=evalin('base','mc_overtrq_factor');
   assignin('base','mc_overtrq_factor',1)
end

% low SOC control strategy optimization flag
if design_vars_bool(4)&~strcmp(drivetrain,'conventional')
   cs_lo_soc_default=evalin('base','cs_lo_soc');
end

% high SOC control strategy optimization flag
if design_vars_bool(5)&~strcmp(drivetrain,'conventional')
   cs_hi_soc_default=evalin('base','cs_hi_soc');
   assignin('base','cs_hi_soc',1)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORM AUTOSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('**************************')
disp('*** AUTOSIZING VEHICLE ***')
disp('**************************')
disp(' ')

% initialize upper and lower bound info
if ~strcmp(drivetrain,'ev')
   % Store default upper and lower bounds
   default_fc_ub=fc_max_trq_scale;
   default_fc_lb=fc_min_trq_scale;
   % Set active upper and lower bounds
   fc_ub=default_fc_ub;
   fc_lb=default_fc_lb;
end
if ~strcmp(drivetrain,'conventional')
   % Store default upper and lower bounds
   default_ess_ub=ess_max_module_num;
   default_ess_lb=ess_min_module_num;
   default_mc_ub=mc_max_trq_scale;
   default_mc_lb=mc_min_trq_scale;
   % Set active upper and lower bounds
   mc_ub=default_mc_ub;
   mc_lb=default_mc_lb;
   ess_ub=default_ess_ub;
   ess_lb=default_ess_lb;
end
if strcmp(drivetrain,'series')&~fuelcell
   % Store default upper and lower bounds
   default_gc_ub=gc_max_trq_scale;
   default_gc_lb=gc_min_trq_scale;
   % Set active upper and lower bounds
   gc_ub=default_gc_ub;
   gc_lb=default_gc_lb;
end

% initialize min/max flags
fc_max_size=0;
fc_min_size=0;
mc_max_size=0;
mc_min_size=0;
ess_max_size=0;
ess_min_size=0;
gc_max_size=0;
gc_min_size=0;

% initialize grade bounds
grade_lb=0;
grade_ub=10;

if design_vars_bool(6)
   % adjust final drive ratio to allow max speed with current 
   % motor/controller and gearbox if necessary accounting for 10% wheel slip
   fd_ratio=evalin('base','fd_ratio');
   %adjust_fd(max_spd)
   if constraints_bool(1)
      assignin('base','fd_ratio',opt_fd_ratio('max_spd',max_spd,'grade_spd',grade_mph))
   else
      assignin('base','fd_ratio',opt_fd_ratio('max_spd',max_spd))
   end
   if fd_ratio~=evalin('base','fd_ratio')
      fd_ratio_changed=1;
   end
end

if strcmp(drivetrain,'series')&~fuelcell
   % match gc spd and trq range to that of the fc 
   assignin('base','gc_spd_scale',round(evalin('base','max(fc_map_spd*fc_spd_scale)/max(gc_map_spd)')*1000)/1000);
   match_gc_to_fc(gc_lb,gc_ub) 
end

if strcmp(drivetrain,'parallel')&constraints_bool(2)
   % minimize the ess
   assignin('base','ess_module_num',ess_lb);
   
   % adjust motor size if necessary
   match_mc_to_ess(mc_lb,mc_ub);
end

skip_grade=0;
if (strcmp(drivetrain,'ev')|strcmp(drivetrain,'conventional'))&(constraints_bool(1)&constraints_bool(2))
   grade_percent_diff=(grade_grade-max_grade)/grade_grade;
   for i=1:length(accel_targets)
      if accel_targets(i)>0
         if accel_results(i)>0
            accel_percent_diff(i)=(accel_results(i)-accel_targets(i))/accel_targets(i);
         else
            accel_percent_diff(i)=-1;
         end
      end
   end
   if (grade_percent_diff>0)&nnz(accel_percent_diff>0)
      if max(accel_percent_diff)>grade_percent_diff
         skip_grade=1;
      end
   elseif nnz(accel_percent_diff>0)
      skip_grade=1;
   end
end

if constraints_bool(1)&~grade_achieved&~skip_grade
   
   disp(' ')
   disp('*** Sizing vehicle components for grade performance. ***')
   disp(' ')
   
   if ~strcmp(drivetrain,'ev')  %% tm PROBABLY NOT NECESSARY
      % Test the fuel converter lower bound
      assignin('base','fc_trq_scale',fc_lb);
      evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
      disp(['Fuel converter ==> ', num2str(evalin('base',...
            'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
   else
      % Test the ess lower bound
      assignin('base','ess_module_num',ess_lb);
      disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
   end
   
   if strcmp(drivetrain,'series')
      
      if ~fuelcell
         % adjust the generator size if necessary
         match_gc_to_fc(gc_lb,gc_ub)
      end
      
      % update fc operating points
      adjust_cs
      
      % adjust motor size if necessary (includes generator efficiency)
      match_mc_to_fc(mc_lb,mc_ub) 
   end
   
   if strcmp(drivetrain,'ev')
      % adjust motor size if necessary 
      match_mc_to_ess(mc_lb,mc_ub) 
   end
   
   % recalculate the component and vehicle masses and update in the GUI
   recompute_mass 
   
   check_if_override_mass   
   
   % perform one iteration of grade test
   max_grade=calc_grade(input,'single');
   
   if display_flag
      % plot current info
      update_plot; drawnow
   end
   
   % check results      
   if ~isempty(max_grade)
      grade_achieved_at_lb=1;
      disp('Vehicle better than grade test goals at lower bound!');
      if ~strcmp(drivetrain,'ev')
         disp('Using minimum fuel converter size.');
         fc_min_size=1;
      else
         disp('Using minimum number of energy storage modules.');
         ess_min_size=1;
      end
      grade_achieved=1;
   else
      grade_achieved_at_lb=0;
      
      if ~strcmp(drivetrain,'ev')
         % Test fuel converter upper bound
         assignin('base','fc_trq_scale',fc_ub);
         
         evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
         disp(['Fuel converter ==> ', num2str(evalin('base',...
               'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
      else
         % Test the ess upper bound
         assignin('base','ess_module_num',ess_ub);
         disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
      end
      
      if strcmp(drivetrain,'series')
         if ~fuelcell
            % adjust the generator size if necessary
            match_gc_to_fc(gc_lb,gc_ub)
         end
         
         % update fc operating points
         adjust_cs
         
         % adjust motor size if necessary (includes generator efficiency)
         match_mc_to_fc(mc_lb,mc_ub) 
      end
      
      if strcmp(drivetrain,'ev')
         % adjust motor size if necessary 
         match_mc_to_ess(mc_lb,mc_ub) 
      end
      
      % recalculate the component and vehicle masses and update in the GUI
      recompute_mass; 
      
      check_if_override_mass      
      
      % perform one iteration of grade test
      max_grade=calc_grade(input,'single');
      
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results      
      if isempty(max_grade)
         grade_achieved_at_ub=0;
         disp('Vehicle did not achieve grade test goals at upper bound!');
         if ~strcmp(drivetrain,'ev')
            disp('Using maximum fuel converter size.');
            fc_max_size=1;
         else
            disp('Using maximum number of energy storage modules.');
            ess_max_size=1;
         end
         grade_achieved=0;
      else
         grade_achieved_at_ub=1;
         if ~grade_achieved_at_lb
            grade_achieved=0; % initialize flag
            iter=0; % initialize counter
            converged=0; % initialize convergence flag
            while ~grade_achieved&~converged&iter<max_iter
               
               if ~strcmp(drivetrain,'ev')
                  % adjust bounds and set next test point
                  adjust_fc('grade')
               else
                  % adjust bounds and set next test point
                  adjust_ess('grade')
               end
               
               if strcmp(drivetrain,'series')
                  
                  if ~fuelcell
                     % adjust the generator size if necessary
                     match_gc_to_fc(gc_lb,gc_ub)
                  end
                  
                  % update fc operating points
                  adjust_cs
                  
                  % adjust motor size if necessary (includes generator efficiency)
                  match_mc_to_fc(mc_lb,mc_ub) 
               end
               
               if strcmp(drivetrain,'ev')
                  % adjust motor size if necessary 
                  match_mc_to_ess(mc_lb,mc_ub) 
               end
               
               % recalculate the component and vehicle masses and update in the GUI
               recompute_mass; 
               
               check_if_override_mass
               
               % find max grade
               max_grade=calc_grade(input,'multi');
               
               
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               grade_achieved=check_grade_results('tolerance');
               
               % increment counter
               iter=iter+1;
               
               % convergence flag
               if ~strcmp(drivetrain,'ev')
                  converged=(fc_ub-fc_lb<=0.001);
               else
                  converged=(ess_ub-ess_lb<=1);
               end
            end
            
            if converged|iter==max_iter
               if converged 
                  disp('Bounds have converged!')
               end;   
               if iter==max_iter
                  disp('Maximum number of iterations exceeded!');
               end;
               if ~grade_achieved
                  
                  if ~strcmp(drivetrain,'ev')
                     % set to last successful point
                     assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                     evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                     disp(['Fuel converter ==> ', num2str(evalin('base',...
                           'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
                  else
                     % set to last successful point
                     assignin('base','ess_module_num',ceil(ess_ub));
                     disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
                  end
                  
                  if strcmp(drivetrain,'series')
                     if ~fuelcell
                        % adjust the generator size if necessary
                        match_gc_to_fc(gc_lb,gc_ub)
                     end
                     
                     % update fc operating points
                     adjust_cs
                     
                     % adjust motor size if necessary (includes generator efficiency)
                     match_mc_to_fc(mc_lb,mc_ub) 
                  end
                  
                  if strcmp(drivetrain,'ev')
                     % adjust motor size if necessary 
                     match_mc_to_ess(mc_lb,mc_ub) 
                  end
                  
                  % recalculate the component and vehicle masses and update in the GUI
                  recompute_mass; 
                  
                  check_if_override_mass
                  
                  % find max grade
                  max_grade=calc_grade(input,'multi');
                  
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  grade_achieved=check_grade_results('greaterthan');
                  
               end
            end
         end
      end
   end
else
   if constraints_bool(1)&skip_grade
      grade_achieved=check_grade_results('greaterthan');      
   end
end

% store current values
if ~strcmp(drivetrain,'conventional')
   mc_trq_scale_grade=evalin('base','mc_trq_scale');
   ess_module_num_grade=evalin('base','ess_module_num');
end
if ~strcmp(drivetrain,'ev')
   fc_trq_scale_grade=evalin('base','fc_trq_scale');
end

if strcmp(drivetrain,'parallel')
   
   if constraints_bool(1)&constraints_bool(2)
      disp(' ')
      disp(' *** Sizing vehicle components for acceleration performance. *** ')
      disp(' ')
      
      % reset upper and lower bounds
      fc_lb=evalin('base','fc_trq_scale');
      fc_ub=fc_lb*3;
      
      % test the fuel converter lower bound
      assignin('base','fc_trq_scale',fc_lb);
      evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
      disp(['Fuel converter ==> ', num2str(evalin('base',...
            'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
      
      % recalculate the component and vehicle masses and update in the GUI
      recompute_mass; 
      
      check_if_override_mass
      
      % perform acceleration test
      accel_results=calc_accel(input);
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      accel_achieved_at_lb=check_accel_results('lessthan');
      
      if accel_achieved_at_lb
         disp('Vehicle better than acceleration test goals at lower bound!');
         disp('Using minimum fuel converter size.');
         fc_min_size=1;
         accel_achieved=1;
      else
         
         % Test fuel converter upper bound
         assignin('base','fc_trq_scale',fc_ub);
         evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
         disp(['Fuel converter ==> ', num2str(evalin('base',...
               'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
         
         % recalculate the component and vehicle mass and update the GUI
         recompute_mass;
         
         check_if_override_mass
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results         
         accel_achieved_at_ub=check_accel_results('lessthan');
         
         if accel_achieved_at_ub
            accel_achieved=0; % initialize flag
            iter=0;
            while ~accel_achieved&(fc_ub-fc_lb>0.001)&iter<max_iter
               
               % adjust bounds and set to next test point
               adjust_fc('accel')
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % perform acceleration test
               accel_results=calc_accel(input);
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               accel_achieved=check_accel_results('tolerance');
               
               %increment counter
               iter=iter+1;
               
            end
            
            if (fc_ub-fc_lb)<=0.001|iter==max_iter
               if (fc_ub-fc_lb)<=0.001 
                  disp('Bounds have converged!')
               end   
               if iter==max_iter
                  disp('Maximum number of iterations exceeded!');
               end
               if ~accel_achieved
                  
                  % set to last successful point
                  assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                  evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                  disp(['Fuel converter ==> ', num2str(evalin('base',...
                        'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
                  
                  % recalculate the component and vehicle masses and update in the GUI
                  recompute_mass; 
                  
                  check_if_override_mass
                  
                  % perform acceleration test
                  accel_results=calc_accel(input);
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  accel_achieved=check_accel_results('lessthan');
                  
               end
            end
         end
      end
   end
   
   % store the current vehicle parameters
   fc_trq_scale_accel=evalin('base','fc_trq_scale');
   mc_trq_scale_accel=evalin('base','mc_trq_scale');
   ess_module_num_accel=evalin('base','ess_module_num');
   
   if constraints_bool(1)&constraints_bool(2)
      % set the relationship between fc and ess
      disp(' ')
      disp('*** Implementing Hybridization ***')
      disp(' ')
      assignin('base','fc_trq_scale',round((min(fc_trq_scale_grade,fc_trq_scale_accel)+...
         min(1,max(0,(1-(evalin('base','hybridization')))))*abs(fc_trq_scale_accel-fc_trq_scale_grade))*1000)/1000)
      evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
      disp(['Fuel converter ==> ', num2str(evalin('base',...
            'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
   end
end

if strcmp(drivetrain,'conventional')
   changed=(fc_trq_scale_accel~=fc_trq_scale_grade);
elseif strcmp(drivetrain,'ev')
   changed=(ess_module_num_accel~=ess_module_num_grade|mc_trq_scale_accel~=mc_trq_scale_grade);
else
   changed=(ess_module_num_accel~=ess_module_num_grade|mc_trq_scale_accel~=mc_trq_scale_grade|fc_trq_scale_accel~=fc_trq_scale_grade);
end

if constraints_bool(2)&(~accel_achieved|strcmp(drivetrain,'parallel')|changed)
   disp(' ')
   disp('*** Sizing vehicle components for acceleration performance. ***')
   disp(' ')
   
   % reset min size flags
   if strcmp(drivetrain,'conventional')&fc_min_size
      fc_min_size=0;
   end
   %if strcmp(drivetrain,'conventional')&~skip_grade
   %   fc_ub=default_fc_ub;
   %end
   if strcmp(drivetrain,'ev')&ess_min_size
      ess_min_size=0;
   end
   
   if ~strcmp(drivetrain,'conventional')
      % Test energy storage system lower bound
      assignin('base','ess_module_num',ess_lb);
      disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
   else
      % Test fuel converter lower bound
      assignin('base','fc_trq_scale',fc_lb);
      evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
      disp(['Fuel converter ==> ', num2str(evalin('base',...
            'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
   end
   
   if ~strcmp(drivetrain,'conventional')
      % adjust motor size if necessary
      match_mc_to_ess(mc_trq_scale_grade,mc_ub)
   end
   
   % recalculate the component and vehicle masses and update in the GUI
   recompute_mass; 
   
   check_if_override_mass
   
   % perform acceleration test
   accel_results=calc_accel(input);
   
   
   if display_flag
      % plot current info
      update_plot; drawnow
   end
   
   % check results
   accel_achieved_at_lb=check_accel_results('lessthan');
   
   if accel_achieved_at_lb
      disp('Vehicle better than acceleration test goals at lower bound!');
      if ~strcmp(drivetrain,'conventional')
         disp('Using minimum number of energy storage modules.');
         ess_min_size=1;
      else
         disp('Using minimum fuel converter size.');
         fc_min_size=1;
      end
      accel_achieved=1;
   else
      accel_achieved=0;
      if ~strcmp(drivetrain,'conventional')
         % test the upper bound of the energy storage system
         assignin('base','ess_module_num',ess_ub);
         disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
      else
         % Test fuel converter upper bound
         fc_ub=default_fc_ub;
         assignin('base','fc_trq_scale',fc_ub);
         evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
         disp(['Fuel converter ==> ', num2str(evalin('base',...
               'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
      end
      
      if ~strcmp(drivetrain,'conventional')
         % adjust motor size if necessary
         match_mc_to_ess(mc_trq_scale_grade,mc_ub)
      end
      
      % recalculate the component and vehicle mass and update the GUI
      recompute_mass;
      
      check_if_override_mass
      
      % perform acceleration test
      accel_results=calc_accel(input);
      
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      accel_achieved_at_ub=check_accel_results('lessthan');
      
      if ~accel_achieved_at_ub&~strcmp(drivetrain,'conventional')
         if ((accel_targets>0).*accel_results<=0)|((accel_targets>0).*accel_results.*accel_equality>=(accel_targets>0).*(accel_targets+accel_target_tols).*accel_equality)
            disp('Vehicle did not achieve acceleration test goals at upper bound.');
            disp('Using maximum number of energy storage modules.');
            ess_max_size=1;
            accel_achieved=0;
            %  elseif ((accel_targets(4)>0)*(accel_results(4)<0|accel_results(4)>accel_targets(4)))&((accel_targets(3)>0&(accel_targets(5)>0))*(accel_results(3)<accel_targets(3)&accel_results(5)<accel_targets(5)))
         elseif 0%((accel_targets(2)>0)*(accel_results(2)<0|accel_results(2)>accel_targets(2)))&((accel_targets(1)>0&(accel_targets(3)>0))*(accel_results(1)<accel_targets(1)&accel_results(3)<accel_targets(3)))
            while ~accel_achieved_at_ub&(ess_ub-ess_lb)>1
               ess_ub=ess_ub-1;
               assignin('base','ess_module_num',ess_ub);
               disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
               
               % adjust motor size if necessary
               match_mc_to_ess(mc_trq_scale_grade,mc_ub)
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % perform acceleration test
               accel_results=calc_accel(input);
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               accel_achieved_at_ub=check_accel_results('lessthan');
               
            end
            
            if ess_ub-ess_lb<=1
               disp('Bounds have converged.');
               if ~accel_achieved
                  
                  assignin('base','ess_module_num',ceil(ess_ub));
                  disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                  
                  % adjust motor size if necessary
                  match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                  
                  % recalculate the component and vehicle mass and update the GUI
                  recompute_mass;
                  
                  check_if_override_mass
                  
                  % perform acceleration test
                  accel_results=calc_accel(input);
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  accel_achieved=check_accel_results('lessthan');
                  
               end
            end
         end
      end
      
      if accel_achieved_at_ub
         accel_achieved=0; % initialize flag       
         iter=0;
         converged=0;
         while ~accel_achieved&~converged&iter<max_iter
            
            if ~strcmp(drivetrain,'conventional')
               % adjusts bounds and set next test point
               adjust_ess('accel')
            else
               % adjusts bounds and set next test point
               adjust_fc('accel')
            end
            
            if ~strcmp(drivetrain,'conventional')
               % adjust motor size if necessary
               match_mc_to_ess(mc_trq_scale_grade,mc_ub)
            end
            
            % recalculate the component and vehicle mass and update the GUI
            recompute_mass;
            
            check_if_override_mass
            
            % perform acceleration test
            accel_results=calc_accel(input);
            
            if display_flag
               % plot current info
               update_plot; drawnow
            end
            
            % check results
            accel_achieved=check_accel_results('tolerance');
            
            % increment counter
            iter=iter+1;
            
            % convergence flag
            if ~strcmp(drivetrain,'conventional')
               converged=(ess_ub-ess_lb<=1);
            else
               converged=(fc_ub-fc_lb<=0.001);
            end
            
         end
         
         if converged|iter==max_iter
            
            if converged
               disp('Bounds have converged!');
            end;
            if iter==max_iter
               disp('Maximum number of iterations exceeded!');
            end;
            
            if ~accel_achieved
               if ~strcmp(drivetrain,'conventional')
                  assignin('base','ess_module_num',ceil(ess_ub));
                  disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
               else
                  % set to last successful point
                  assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                  evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                  disp(['Fuel converter ==> ', num2str(evalin('base',...
                        'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
               end
               
               if ~strcmp(drivetrain,'conventional')
                  % adjust motor size if necessary
                  match_mc_to_ess(mc_trq_scale_grade,mc_ub)
               end
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % perform acceleration test
               accel_results=calc_accel(input);
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               accel_achieved=check_accel_results('lessthan');
               
            end
         end
      end
   end
end

% store current values
if ~strcmp(drivetrain,'conventional')
   mc_trq_scale_accel=evalin('base','mc_trq_scale');
   ess_module_num_accel=evalin('base','ess_module_num');
end
if ~strcmp(drivetrain,'ev')
   fc_trq_scale_accel=evalin('base','fc_trq_scale');
end

if ~strcmp(drivetrain,'conventional')&(constraints_bool(2)&accel_achieved)
   
   if design_vars_bool(3)&(evalin('base','mc_trq_scale')~=mc_min_trq_scale)
      
      % minimize mc
      disp(' ')
      disp('Minimizing the motor size ...')
      
      % reset bounds
      if strcmp(drivetrain,'series')|strcmp(drivetrain,'ev')
         mc_lb=max(mc_min_trq_scale,mc_trq_scale_grade);
      else
         mc_lb=mc_min_trq_scale;
      end
      mc_ub=evalin('base','mc_trq_scale');
      
      % initialize to lower bound
      assignin('base','mc_trq_scale',mc_lb)
      disp(['Motor Controller ==> ', num2str(evalin('base',...
            'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
      
      % recalculate the component and vehicle mass and update the GUI
      recompute_mass;
      
      % perform acceleration test
      accel_results=calc_accel(input);
      
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      accel_achieved=check_accel_results('tolerance');
      
      % initialize flag
      iter=0;
      converged=0;
      while ~accel_achieved&~converged&iter<max_iter
         
         if iter==0
            if check_accel_results('lessthan')
               assignin('base','mc_trq_scale',mc_ub) % this is necessary to work with adjust function
            end
         end
         
         % adjust bounds and set next test point
         adjust_mc('accel')
         
         % recalculate the component and vehicle mass and update the GUI
         recompute_mass;
         
         check_if_override_mass
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results
         accel_achieved=check_accel_results('tolerance');
         
         % increment counter
         iter=iter+1;
         
         % convergence flag
         converged=(mc_ub-mc_lb<=0.001);
         
      end
      
      if converged|iter==max_iter
         if converged 
            disp('Bounds have converged.')
         end;   
         if iter==max_iter
            disp('Maximum number of iterations exceeded!');
         end;
         if ~accel_achieved
            
            % set to last successful point
            assignin('base','mc_trq_scale',round(mc_ub*1000)/1000);
            disp(['Motor Controller ==> ', num2str(evalin('base',...
                  'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
            
            % recalculate the component and vehicle masses and update in the GUI
            recompute_mass; 
            
            check_if_override_mass
            
            % perform acceleration test
            accel_results=calc_accel(input);
            
            
            if display_flag
               % plot current info
               update_plot; drawnow
            end
            
            % check results
            accel_achieved=check_accel_results('lessthan');
            
         end
      end
   end
   
   if (design_vars_bool(5)|mc_trq_scale_accel~=evalin('base','mc_trq_scale'))&~ess_min_size
      % reduce ess_module_num if possible
      
      disp(' ')
      disp('Minimizing the Energy Storage System ...')
      
      while accel_achieved&evalin('base','ess_module_num')>(ess_min_module_num)
         
         % try to reduce the ess #
         assignin('base','ess_module_num',evalin('base','ess_module_num')-1)
         disp(['Number of ess modules ==> ',num2str(evalin('base','ess_module_num'))])
         
         % recalculate the component and vehicle masses and update in the GUI
         recompute_mass; 
         
         check_if_override_mass
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results
         accel_achieved=check_accel_results('lessthan');
         
      end
      
      if ~accel_achieved
         assignin('base','ess_module_num',evalin('base','ess_module_num')+1)
         disp(['Number of ess modules ==> ',num2str(evalin('base','ess_module_num'))])
         
         % recalculate the component and vehicle masses and update in the GUI
         recompute_mass; 
         
         check_if_override_mass
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results
         accel_achieved=check_accel_results('lessthan');
      end
   end
   
   if design_vars_bool(4)&~strcmp(drivetrain,'ev')
      
      disp(' ')
      disp('Optimizing cs_lo_soc ...')
      
      if evalin('base','nnz(ess_tmp<20)&nnz(ess_tmp>20)')
         ess_r_dis=evalin('base','interp1(ess_tmp,ess_r_dis,20)');
         ess_r_chg=evalin('base','interp1(ess_tmp,ess_r_chg,20)');
      else
         ess_r_dis=evalin('base','ess_r_dis(1,:)');
         ess_r_chg=evalin('base','ess_r_chg(1,:)');
      end
      
      discharge_index=min(find(min(ess_r_dis)==ess_r_dis));
      charge_index=max(find(min(ess_r_chg)==ess_r_chg));
      charge_soc=evalin('base',['ess_soc(',num2str(charge_index),')']);
      discharge_soc=evalin('base',['ess_soc(',num2str(discharge_index),')']);
      
      if strcmp(drivetrain,'parallel')
         assignin('base','cs_lo_soc',max(0.3,round(mean([charge_soc discharge_soc])*1000)/1000))
      elseif strcmp(drivetrain,'series')
         assignin('base','cs_lo_soc',max(0.3,round(charge_soc*1000)/1000))
      end
      
      disp(['cs_lo_soc ==> ',num2str(evalin('base','cs_lo_soc'))])
   end
   
   if design_vars_bool(5)&~strcmp(drivetrain,'ev')
      
      % adjust cs_hi_soc
      disp(' ')
      disp('Optimizing cs_hi_soc ...')
      
      cs_hi_soc_ub=evalin('base','cs_hi_soc');
      cs_hi_soc_lb=min(evalin('base','cs_lo_soc')+0.05,cs_hi_soc_ub); % add a small fraction to prevent divide by zero errors
      assignin('base','cs_hi_soc',cs_hi_soc_lb)
      disp(['cs_hi_soc ==> ',num2str(evalin('base','cs_hi_soc'))])
      
      % perform acceleration test
      accel_results=calc_accel(input);
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      accel_achieved=check_accel_results('tolerance');
      
      iter=0;
      converged=0;
      while ~accel_achieved&~converged&iter<max_iter
         
         if iter==0&check_accel_results('lessthan')
            assignin('base','cs_hi_soc',cs_hi_soc_ub) % this is necessary to work with adjust function
         end
         
         % adjust cs_hi_soc
         adjust_cs_hi_soc('accel')
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results
         accel_achieved=check_accel_results('tolerance');
         
         % increment counter
         iter=iter+1;
         
         % convergence flag
         converged=(cs_hi_soc_ub-cs_hi_soc_lb<=0.001);
         
      end
      
      if converged|iter==max_iter
         if converged 
            disp('Bounds have converged.')
         end;   
         if iter==max_iter
            disp('Maximum number of iterations exceeded!');
         end;
         if ~accel_achieved
            
            % set to last successful point
            assignin('base','cs_hi_soc',round(cs_hi_soc_ub*1000)/1000);
            disp(['cs_hi_soc ==> ', num2str(evalin('base','cs_hi_soc'))]);
            
            % perform acceleration test
            accel_results=calc_accel(input);
            
            
            if display_flag
               % plot current info
               update_plot; drawnow
            end
            
            % check results
            accel_achieved=check_accel_results('lessthan');
            
         end
      end
   end
end

% store current values
if ~strcmp(drivetrain,'conventional')
   mc_trq_scale_accel=evalin('base','mc_trq_scale');
   ess_module_num_accel=evalin('base','ess_module_num');
end
if ~strcmp(drivetrain,'ev')
   fc_trq_scale_accel=evalin('base','fc_trq_scale');
end

if strcmp(drivetrain,'conventional')
   changed=(fc_trq_scale_accel~=fc_trq_scale_grade);
elseif strcmp(drivetrain,'ev')
   changed=(ess_module_num_accel~=ess_module_num_grade|mc_trq_scale_accel~=mc_trq_scale_grade);
else
   changed=(ess_module_num_accel~=ess_module_num_grade|mc_trq_scale_accel~=mc_trq_scale_grade|fc_trq_scale_accel~=fc_trq_scale_grade);
end

while (grade_achieved|skip_grade)&accel_achieved&changed
   
   if (grade_achieved|skip_grade)&changed
      
      % perform one iteration of grade test
      disp(' ')
      fprintf('Verifying grade test results ... ');
      max_grade=calc_grade(input,'multi');
      
      
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      if strcmp(drivetrain,'series')
         if fc_min_size
            grade_achieved=check_grade_results('greaterthan');
         else
            grade_achieved=check_grade_results('tolerance');
         end
      else
         grade_achieved=check_grade_results('greaterthan');
      end
      
      % resize components if necessary
      if grade_achieved
         fprintf('verified!\n');
      else
         
         % initialize max size flag
         if ~strcmp(drivetrain,'ev')
            max_size=fc_max_size;
         else
            max_size=ess_max_size;
         end
         
         if (isempty(max_grade)|(max_grade<(grade_grade-grade_grade_tol)))&~max_size
            
            fprintf('\n');
            
            % reset upper bound
            if ~strcmp(drivetrain,'ev')
               fc_ub=default_fc_ub; % reset upper bound
               fc_lb=evalin('base','fc_trq_scale');
            else
               ess_ub=default_ess_ub; % reset upper bound
               ess_lb=evalin('base','ess_module_num');
            end
            
            if strcmp(drivetrain,'ev')|strcmp(drivetrain,'series')
               mc_ub=default_mc_ub; % reset upper bound
            end
            
            grade_ub=10;
            if ~isempty(max_grade)
               grade_lb=max_grade;
            else
               grade_lb=0;
            end
            
            iter=0;
            converged=0;
            while ~grade_achieved&~converged&iter<max_iter
               
               if ~strcmp(drivetrain,'ev')
                  % adjust bounds and set next test point
                  adjust_fc('grade')
               else
                  % adjust bounds and set next test point
                  adjust_ess('grade')
               end
               
               if strcmp(drivetrain,'series')
                  if ~fuelcell
                     % adjust the generator size if necessary
                     match_gc_to_fc(gc_lb,gc_ub)
                  end
                  
                  % update fc operating points
                  adjust_cs
                  
                  % adjust motor size if necessary (includes generator efficiency)
                  match_mc_to_fc(mc_trq_scale_accel,mc_ub) 
               end
               
               if strcmp(drivetrain,'ev')
                  % adjust motor size if necessary 
                  match_mc_to_ess(mc_trq_scale_accel,mc_ub) 
               end
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % find max grade
               max_grade=calc_grade(input,'multi');
               
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               grade_achieved=check_grade_results('tolerance');
               
               %increment counter
               iter=iter+1;
               
               % convergence flag
               if ~strcmp(drivetrain,'ev')
                  converged=(fc_ub-fc_lb<=0.001);
               else
                  converged=(ess_ub-ess_lb<=1);
               end
               
            end
            
            if converged|iter==max_iter
               if converged 
                  disp('Bounds have converged.')
               end   
               if iter==max_iter
                  disp('Maximum number of iterations exceeded!');
               end
               if ~grade_achieved
                  if ~strcmp(drivetrain,'ev')
                     % set to last successful point
                     assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                     evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                     disp(['Fuel converter ==> ', num2str(evalin('base',...
                           'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
                  else
                     % set to last successful point
                     assignin('base','ess_module_num',ceil(ess_ub));
                     disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                  end
                  
                  if strcmp(drivetrain,'series')
                     if ~fuelcell
                        % adjust the generator size if necessary
                        match_gc_to_fc(gc_lb,gc_ub)
                     end
                     
                     % update fc operating points
                     adjust_cs
                     
                     % adjust motor size if necessary (includes generator efficiency)
                     match_mc_to_fc(mc_trq_scale_accel,mc_ub) 
                  end
                  
                  if strcmp(drivetrain,'ev')
                     % adjust motor size if necessary 
                     match_mc_to_ess(mc_trq_scale_accel,mc_ub) 
                  end
                  
                  % recalculate the component and vehicle masses and update in the GUI
                  recompute_mass; 
                  
                  check_if_override_mass
                  
                  % find max grade
                  max_grade=calc_grade(input,'multi');
                  
                  
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  grade_achieved=check_grade_results('greaterthan');
                  
               end
            end
            
         elseif strcmp(drivetrain,'series')&(max_grade>(grade_grade+grade_grade_tol))&~fc_min_size
            
            fprintf('\n');
            
            % store new upper bound
            fc_ub=evalin('base','fc_trq_scale'); 
            
            % retest the lower bound
            assignin('base','fc_trq_scale',default_fc_lb)
            evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
            disp(['Fuel converter ==> ', num2str(evalin('base',...
                  'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
            
            if ~fuelcell
               % adjust the generator size if necessary
               match_gc_to_fc(gc_lb,gc_ub)
            end
            
            % update fc operating points
            adjust_cs
            
            % adjust motor size if necessary (includes generator efficiency)
            match_mc_to_fc(mc_trq_scale_accel,mc_ub) 
            
            % recalculate the component and vehicle mass and update the GUI
            recompute_mass;
            
            check_if_override_mass
            
            % find max grade
            max_grade=calc_grade(input,'multi');
            
            
            
            if display_flag
               % plot current info
               update_plot; drawnow
            end
            
            % check results
            grade_achieved_at_lb=check_grade_results('greaterthan');
            
            if grade_achieved_at_lb
               disp('Vehicle better than grade test goals at lower bound!');
               disp('Using minimum fuel converter size.');
               fc_min_size=1;
               grade_achieved=1;
            else
               fc_lb=default_fc_lb; 
               grade_lb=max_grade;
               grade_ub=10;
               iter=0;
               converged=0;
               while ~grade_achieved&~converged&iter<max_iter
                  
                  % adjust bounds and set next test point
                  adjust_fc('grade')
                  
                  if ~fuelcell
                     % adjust the generator size if necessary
                     match_gc_to_fc(gc_lb,gc_ub)
                  end
                  
                  % update fc operating points
                  adjust_cs
                  
                  % adjust motor size if necessary (includes generator efficiency)
                  match_mc_to_fc(mc_trq_scale_accel,mc_ub) 
                  
                  % recalculate the component and vehicle mass and update the GUI
                  recompute_mass;
                  
                  check_if_override_mass
                  
                  % find max grade
                  max_grade=calc_grade(input,'multi');
                  
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  grade_achieved=check_grade_results('tolerance');
                  
                  %increment counter
                  iter=iter+1;
                  
                  % convergence flag
                  converged=(fc_ub-fc_lb<=0.001);
                  
               end
               
               if converged|iter==max_iter
                  if converged 
                     disp('Bounds have converged.')
                  end;   
                  if iter==max_iter
                     disp('Maximum number of iterations exceeded!');
                  end;
                  
                  if ~grade_achieved
                     % set to last successful point
                     assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                     evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                     disp(['Fuel converter ==> ', num2str(evalin('base',...
                           'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
                     
                     % adjust the generator size if necessary
                     match_gc_to_fc(gc_lb,gc_ub)
                     
                     % update fc operating points
                     adjust_cs
                     
                     % adjust motor size if necessary (includes generator efficiency)
                     match_mc_to_fc(mc_trq_scale_accel,mc_ub) 
                     
                     % recalculate the component and vehicle masses and update in the GUI
                     recompute_mass; 
                     
                     check_if_override_mass
                     
                     % find max grade
                     max_grade=calc_grade(input,'multi');
                     
                     
                     
                     if display_flag
                        % plot current info
                        update_plot; drawnow
                     end
                     
                     % check results
                     grade_achieved=check_grade_results('greaterthan');
                     
                  end
               end
            end
         end
      end
      
      % store current values
      if ~strcmp(drivetrain,'conventional')
         mc_trq_scale_grade=evalin('base','mc_trq_scale');
         ess_module_num_grade=evalin('base','ess_module_num');
      end
      if ~strcmp(drivetrain,'ev')
         fc_trq_scale_grade=evalin('base','fc_trq_scale');
      end
      
   end
   
   if strcmp(drivetrain,'conventional')
      changed=(fc_trq_scale_accel~=fc_trq_scale_grade);
   elseif strcmp(drivetrain,'ev')
      changed=(ess_module_num_accel~=ess_module_num_grade|...
         mc_trq_scale_accel~=mc_trq_scale_grade);
   else
      changed=(ess_module_num_accel~=ess_module_num_grade|...
         mc_trq_scale_accel~=mc_trq_scale_grade|...
         fc_trq_scale_accel~=fc_trq_scale_grade);
   end
   
   if accel_achieved&changed
      
      % perform acceleration test
      disp(' ')
      fprintf('Verifying acceleration test results ... ');
      accel_results=calc_accel(input);
      
      
      if display_flag
         % plot current info
         update_plot; drawnow
      end
      
      % check results
      accel_achieved=check_accel_results('lessthan');
      
      if accel_achieved
         fprintf('verified!\n');
      else
         fprintf('\n');
         
         if strcmp(drivetrain,'conventional')
            fc_ub=default_fc_ub; % reset upper bound
            fc_lb=evalin('base','fc_trq_scale');
            assignin('base','fc_trq_scale',fc_ub)
            evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
            disp('Adjusting fuel converter size ...')
            disp(['Fuel Converter ==> ', num2str(evalin('base',...
                  'round(calc_max_pwr(''fuel_converter''))')), ' kW'])
         else
            if design_vars_bool(5) 
               % reset the cs_hi_soc bounds
               cs_hi_soc_lb=evalin('base','cs_lo_soc')+0.05;
               cs_hi_soc_ub=1;
               assignin('base','cs_hi_soc',cs_hi_soc_ub)
               disp('Adjusting cs_hi_soc ...')
               disp(['cs_hi_soc ==> ',num2str(evalin('base','cs_hi_soc'))])
            elseif design_vars_bool(3)
               % reset the mc bounds
               mc_lb=evalin('base','mc_trq_scale');
               mc_ub=default_mc_ub;
               assignin('base','mc_trq_scale',mc_ub)
               disp('Adjusting motor size ...')
               disp(['Motor Controller ==> ', num2str(evalin('base',...
                     'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW'])
            else
               % reset the ess bounds
               ess_lb=evalin('base','ess_module_num');
               ess_ub=default_ess_ub;
               assignin('base','ess_module_num',ess_ub)
               disp('Adjusting number of energy storage modules ...')
               disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
            end
            
            if ~design_vars_bool(5)&~design_vars_bool(3)
               % adjust motor size if necessary
               match_mc_to_ess(mc_trq_scale_grade,mc_ub)
            end
         end
         
         % recalculate the component and vehicle mass and update the GUI
         recompute_mass;
         
         check_if_override_mass
         
         % perform acceleration test
         accel_results=calc_accel(input);
         
         if display_flag
            % plot current info
            update_plot; drawnow
         end
         
         % check results
         accel_achieved_at_ub=check_accel_results('lessthan');
         
         if accel_achieved_at_ub
            iter=0;
            converged=0;
            while ~accel_achieved&~converged&iter<max_iter
               
               % adjust bounds and set next test point
               if ~strcmp(drivetrain,'conventional')
                  if design_vars_bool(5)
                     adjust_cs_hi_soc('accel')
                  elseif design_vars_bool(3)
                     adjust_mc('accel')
                  else
                     adjust_ess('accel')
                     % adjust motor size if necessary
                     match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                  end
               else
                  adjust_fc('accel')
               end
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % perform acceleration test
               accel_results=calc_accel(input);
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               accel_achieved=check_accel_results('tolerance');
               
               % increment counter
               iter=iter+1;
               
               % convergence flag
               if ~strcmp(drivetrain,'conventional')
                  if design_vars_bool(5)
                     converged=(cs_hi_soc_ub-cs_hi_soc_lb<=0.001);
                  elseif design_vars_bool(3)
                     converged=(mc_ub-mc_lb<=0.001);
                  else
                     converged=(ess_ub-ess_lb<=1);
                  end
               else
                  converged=(fc_ub-fc_lb<=0.001);
               end
               
            end
            
            if converged|iter==max_iter
               if converged
                  disp('Bounds have converged.');
               end;
               if iter==max_iter
                  disp('Maximum number of iterations exceeded!');
               end;
               if ~accel_achieved
                  
                  if ~strcmp(drivetrain,'conventional')
                     if design_vars_bool(5)
                        % set to last successful point
                        assignin('base','cs_hi_soc',round(cs_hi_soc_ub*1000)/1000);
                        disp(['cs_hi_soc ==> ', num2str(evalin('base','cs_hi_soc')), '.']);
                     elseif design_vars_bool(3)
                        % set to last successful point
                        assignin('base','mc_trq_scale',round(mc_ub*1000)/1000);
                        disp(['Motor controller ==> ', num2str(evalin('base',...
                              'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
                     else
                        % set to last successful point
                        assignin('base','ess_module_num',ceil(ess_ub));
                        disp(['Number of Energy Storage Modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                        % adjust motor size if necessary
                        match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                     end
                  else
                     % set to last successful point
                     assignin('base','fc_trq_scale',round(fc_ub*1000)/1000);
                     evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
                     disp(['Fuel converter ==> ', num2str(evalin('base',...
                           'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
                  end
                  
                  % recalculate the component and vehicle mass and update the GUI
                  recompute_mass;
                  
                  check_if_override_mass
                  
                  % perform acceleration test
                  accel_results=calc_accel(input);
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  accel_achieved=check_accel_results('lessthan');
                  
               end
            end
            
         else % failed at upper bound of first variable
            
            if ~strcmp(drivetrain,'conventional')
               if design_vars_bool(5)&design_vars_bool(3)
                  % reset the mc bounds
                  mc_lb=evalin('base','mc_trq_scale');
                  mc_ub=default_mc_ub;
                  assignin('base','mc_trq_scale',mc_ub)
                  disp(['Motor Controller ==> ', num2str(evalin('base',...
                        'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
               elseif design_vars_bool(3) % resize ess and mc
                  % reset the ess bounds
                  ess_lb=evalin('base','ess_module_num');
                  ess_ub=default_ess_ub;
                  assignin('base','ess_module_num',ess_ub)
                  disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                  
                  % adjust motor size if necessary
                  match_mc_to_ess(mc_trq_scale_grade,mc_ub)
               else
                  disp('Acceleration test not achieved at upper bound.')
                  disp('Using maximum number of energy storage modules.')
                  ess_max_size=1;
               end
               
               % recalculate the component and vehicle mass and update the GUI
               recompute_mass;
               
               check_if_override_mass
               
               % perform acceleration test
               accel_results=calc_accel(input);
               
               
               if display_flag
                  % plot current info
                  update_plot; drawnow
               end
               
               % check results
               accel_achieved_at_ub=check_accel_results('lessthan');
               
               if accel_achieved_at_ub
                  if design_vars_bool(5)&design_vars_bool(3)
                     % minimize motor
                     disp(' ')
                     disp('Adjusting motor size ...')
                  elseif design_vars_bool(3)
                     % minimize ess
                     disp(' ')
                     disp('Adjusting number of energy storage system modules...')
                  end
                  
                  iter=0;
                  converged=0;
                  while ~accel_achieved&~converged&iter<max_iter
                     if design_vars_bool(5)&design_vars_bool(3)
                        % adjust bounds and set next test point
                        adjust_mc('accel')
                     elseif design_vars_bool(3)
                        % adjust bounds and set next test point
                        adjust_ess('accel')
                        % adjust motor size if necessary
                        match_mc_to_ess(mc_trq_scale_grade, mc_ub)
                     end
                     
                     % recalculate the component and vehicle mass and update the GUI
                     recompute_mass;
                     
                     check_if_override_mass
                     
                     % perform acceleration test
                     accel_results=calc_accel(input);
                     
                     
                     if display_flag
                        % plot current info
                        update_plot; drawnow
                     end
                     
                     % check results
                     accel_achieved=check_accel_results('tolerance');
                     
                     % increment counter
                     iter=iter+1;
                     
                     % convergence flag
                     if design_vars_bool(5)&design_vars_bool(3)
                        converged=(mc_ub-mc_lb<=0.001);
                     elseif design_vars_bool(3)
                        converged=(ess_ub-ess_lb<=1);
                     end
                     
                  end % while loop
                  
                  if converged|iter==max_iter
                     if converged 
                        disp('Bounds have converged.')
                     end;   
                     if iter==max_iter
                        disp('Maximum number of iterations exceeded!');
                     end;
                     if ~accel_achieved
                        if design_vars_bool(5)&design_vars_bool(3)
                           % set to last successful point
                           assignin('base','mc_trq_scale',round(mc_ub*1000)/1000);
                           disp(['Motor Controller ==> ', num2str(evalin('base',...
                                 'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
                        elseif design_vars_bool(3)
                           % set to last successful point
                           assignin('base','ess_module_num',ceil(ess_ub));
                           disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                           
                           % adjust motor size if necessary
                           match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                        end
                        
                        % recalculate the component and vehicle masses and update in the GUI
                        recompute_mass; 
                        
                        check_if_override_mass
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('lessthan');
                        
                     end
                  end
                  
               else % failed at upper bound of second variable
                  
                  % reset the ess bounds
                  ess_lb=evalin('base','ess_module_num');
                  ess_ub=default_ess_ub;
                  assignin('base','ess_module_num',ess_ub)
                  disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                  
                  % adjust motor size if necessary
                  match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                  
                  % recalculate the component and vehicle mass and update the GUI
                  recompute_mass;
                  
                  check_if_override_mass
                  
                  % perform acceleration test
                  accel_results=calc_accel(input);
                  
                  
                  if display_flag
                     % plot current info
                     update_plot; drawnow
                  end
                  
                  % check results
                  accel_achieved_at_ub=check_accel_results('lessthan');
                  
                  if accel_achieved_at_ub % minimize ess
                     
                     % update accel_achieved flag
                     accel_achieved=check_accel_results('tolerance');
                     
                     iter=0;
                     converged=0;
                     while ~accel_achieved&~converged&iter<max_iter
                        % adjust bounds and set next test point
                        adjust_ess('accel')
                        
                        % adjust motor size if necessary
                        match_mc_to_ess(mc_trq_scale_grade, mc_ub)
                        
                        % recalculate the component and vehicle mass and update the GUI
                        recompute_mass;
                        
                        check_if_override_mass
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('tolerance');
                        
                        % increment counter
                        iter=iter+1;
                        
                        % convergence flag
                        converged=((ess_ub-ess_lb)<=1);
                        
                     end % while loop
                     
                     if converged|iter==max_iter
                        if converged 
                           disp('Bounds have converged.')
                        end;   
                        if iter==max_iter
                           disp('Maximum number of iterations exceeded!');
                        end;
                        if ~accel_achieved
                           % set to last successful point
                           assignin('base','ess_module_num',ceil(ess_ub));
                           disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num')), '.']);
                           
                           % adjust motor size if necessary
                           match_mc_to_ess(mc_trq_scale_grade,mc_ub)
                           
                           % recalculate the component and vehicle masses and update in the GUI
                           recompute_mass; 
                           
                           check_if_override_mass
                           
                           % perform acceleration test
                           accel_results=calc_accel(input);
                           
                           
                           if display_flag
                              % plot current info
                              update_plot; drawnow
                           end
                           
                           % check results
                           accel_achieved=check_accel_results('lessthan');
                           
                        end
                     end
                     
                  else % failed at upper bound of third variable
                     disp('Acceleration goals not achieved at upper bound.')
                     disp('Using maximum number of energy storage modules.')
                     ess_max_size=1;
                  end
               end
               
               if ~ess_max_size&accel_achieved
                  
                  if design_vars_bool(3)&(evalin('base','mc_trq_scale')~=mc_min_trq_scale)
                     
                     % minimize mc
                     disp(' ')
                     disp('Minimizing the motor size ...')
                     
                     % reset bounds
                     if strcmp(drivetrain,'series')|strcmp(drivetrain,'ev')
                        mc_lb=max(default_mc_lb,mc_trq_scale_grade);
                     else
                        mc_lb=default_mc_lb;
                     end
                     mc_ub=evalin('base','mc_trq_scale');
                     
                     % initialize to lower bound
                     assignin('base','mc_trq_scale',mc_lb)
                     disp(['Motor Controller ==> ', num2str(evalin('base',...
                           'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
                     
                     % recalculate the component and vehicle mass and update the GUI
                     recompute_mass;
                     
                     % perform acceleration test
                     accel_results=calc_accel(input);
                     
                     
                     if display_flag
                        % plot current info
                        update_plot; drawnow
                     end
                     
                     % check results
                     accel_achieved=check_accel_results('tolerance');
                     
                     % initialize flag
                     iter=0;
                     converged=0;
                     while ~accel_achieved&~converged&iter<max_iter
                        
                        if iter==0&check_accel_results('lessthan')
                           assignin('base','mc_trq_scale',mc_ub) % this is necessary to work with adjust function
                        end
                        
                        % adjust bounds and set next test point
                        adjust_mc('accel')
                        
                        % recalculate the component and vehicle mass and update the GUI
                        recompute_mass;
                        
                        check_if_override_mass
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('tolerance');
                        
                        % increment counter
                        iter=iter+1;
                        
                        % convergence flag
                        converged=((mc_ub-mc_lb)<=0.001);
                        
                     end
                     
                     if converged|(iter==max_iter)
                        if converged 
                           disp('Bounds have converged.')
                        end   
                        if iter==max_iter
                           disp('Maximum number of iterations exceeded!');
                        end
                        if ~accel_achieved
                           
                           % set to last successful point
                           assignin('base','mc_trq_scale',round(mc_ub*1000)/1000);
                           disp(['Motor Controller ==> ', num2str(evalin('base',...
                                 'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
                           
                           % recalculate the component and vehicle masses and update in the GUI
                           recompute_mass; 
                           
                           check_if_override_mass
                           
                           % perform acceleration test
                           accel_results=calc_accel(input);
                           
                           
                           if display_flag
                              % plot current info
                              update_plot; drawnow
                           end
                           
                           % check results
                           accel_achieved=check_accel_results('lessthan');
                           
                        end
                     end
                  end
                  
                  if accel_achieved&(design_vars_bool(5)|(mc_trq_scale_accel~=evalin('base','mc_trq_scale')))&~ess_min_size
                     % reduce ess_module_num if possible
                     
                     disp(' ')
                     disp('Minimizing the Energy Storage System ...')
                     
                     while accel_achieved&evalin('base','ess_module_num')>(ess_min_module_num)
                        
                        % try to reduce the ess #
                        assignin('base','ess_module_num',evalin('base','ess_module_num')-1)
                        disp(['Number of ess modules ==> ',num2str(evalin('base','ess_module_num'))])
                        
                        % recalculate the component and vehicle masses and update in the GUI
                        recompute_mass; 
                        
                        check_if_override_mass
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('lessthan');
                        
                     end
                     
                     if ~accel_achieved
                        assignin('base','ess_module_num',evalin('base','ess_module_num')+1)
                        disp(['Number of ess modules ==> ',num2str(evalin('base','ess_module_num'))])
                        
                        % recalculate the component and vehicle masses and update in the GUI
                        recompute_mass; 
                        
                        check_if_override_mass
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('lessthan');
                     end
                  end
                  
                  if design_vars_bool(5)&accel_achieved
                     % minimize the cs_hi_soc
                     disp(' ')
                     disp('Optimizing cs_hi_soc ...')
                     
                     cs_hi_soc_ub=evalin('base','cs_hi_soc');
                     cs_hi_soc_lb=min(evalin('base','cs_lo_soc')+0.05,cs_hi_soc_ub); % add a small fraction to prevent divide by zero errors
                     assignin('base','cs_hi_soc',cs_hi_soc_lb)
                     disp(['cs_hi_soc ==> ',num2str(evalin('base','cs_hi_soc'))])
                     
                     % perform acceleration test
                     accel_results=calc_accel(input);
                     
                     
                     if display_flag
                        % plot current info
                        update_plot; drawnow
                     end
                     
                     % check results
                     accel_achieved=check_accel_results('tolerance');
                     
                     iter=0;
                     converged=0;
                     while ~accel_achieved&~converged&iter<max_iter
                        
                        if iter==0&check_accel_results('lessthan')
                           assignin('base','cs_hi_soc',cs_hi_soc_ub)
                        end
                        
                        % adjust cs_hi_soc
                        adjust_cs_hi_soc('accel')
                        
                        % perform acceleration test
                        accel_results=calc_accel(input);
                        
                        
                        if display_flag
                           % plot current info
                           update_plot; drawnow
                        end
                        
                        % check results
                        accel_achieved=check_accel_results('tolerance');
                        
                        % increment counter
                        iter=iter+1;
                        
                        % convergence flag
                        converged=(cs_hi_soc_ub-cs_hi_soc_lb<=0.001);
                        
                     end
                     
                     if converged|iter==max_iter
                        if converged 
                           disp('Bounds have converged.')
                        end;   
                        if iter==max_iter
                           disp('Maximum number of iterations exceeded!');
                        end;
                        if ~accel_achieved
                           
                           % set to last successful point
                           assignin('base','cs_hi_soc',round(cs_hi_soc_ub*1000)/1000);
                           disp(['cs_hi_soc ==> ', num2str(evalin('base','cs_hi_soc'))]);
                           
                           % perform acceleration test
                           accel_results=calc_accel(input);
                           
                           
                           if display_flag
                              % plot current info
                              update_plot; drawnow
                           end
                           
                           % check results
                           accel_achieved=check_accel_results('lessthan');
                           
                        end
                     end
                  end
               end
               
            else % failed at upper bound and conventional
               disp('Acceleration goals not achieved at upper bound.')
               disp('Using maximum fuel converter size.')
               fc_max_size=1;
            end
         end
      end
      
      % store current values
      if ~strcmp(drivetrain,'conventional')
         mc_trq_scale_accel=evalin('base','mc_trq_scale');
         ess_module_num_accel=evalin('base','ess_module_num');
      end
      if ~strcmp(drivetrain,'ev')
         fc_trq_scale_accel=evalin('base','fc_trq_scale');
      end
      
   end
   
   if strcmp(drivetrain,'conventional')
      changed=(fc_trq_scale_accel~=fc_trq_scale_grade);
   elseif strcmp(drivetrain,'ev')
      changed=(ess_module_num_accel~=ess_module_num_grade|...
         mc_trq_scale_accel~=mc_trq_scale_grade);
   else
      changed=(ess_module_num_accel~=ess_module_num_grade|...
         mc_trq_scale_accel~=mc_trq_scale_grade|...
         fc_trq_scale_accel~=fc_trq_scale_grade);
   end
   
end % end while ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('**********************************')
disp('*** Autosizing Results Summary ***')
disp('**********************************')
disp(' ')
if constraints_bool(1)
   if grade_achieved
      disp('Grade test ... SUCCESSFUL!!')
   else
      disp('Grade test ... unsuccessful!!')
   end
else
   disp('Grade test not performed!!')
end

if constraints_bool(2)
   if accel_achieved
      disp('Acceleration test ... SUCCESSFUL!!')
   else
      disp('Acceleration test ... unsuccessful!!')
   end;
else
   disp('Acceleration test not performed!!')
end;

if ~strcmp(drivetrain,'ev')
   if fc_max_size
      disp('Fuel converter set to maximum size!!');
   elseif fc_min_size
      disp('Fuel converter set to minimum size!!');
   end
   disp(['Fuel converter ==> ', num2str(evalin('base',...
         'round(calc_max_pwr(''fuel_converter''))')), ' kW']);
end

if strcmp(drivetrain,'series')
   if ~fuelcell
      if gc_max_size
         disp('Generator/controller set to maximum size!!');
      elseif gc_min_size
         disp('Generator/controller set to minimum size!!');
      end;
      disp(['Generator/controller ==> ', num2str(evalin('base',...
            'round(max(gc_map_spd.*gc_max_trq)*gc_trq_scale*gc_spd_scale/1000)')), ' kW']);
   end
end

if ~strcmp(drivetrain,'conventional')
   if mc_max_size
      disp('Motor/controller set to maximum size!!');
   elseif mc_min_size
      disp('Motor/controller set to minimum size!!');
   end
   disp(['Motor/controller ==> ', num2str(evalin('base',...
         'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW']);
end

if ~strcmp(drivetrain,'conventional')
   if ess_max_size
      disp('Energy storage system module number set to maximum number of modules!!');
   elseif ess_min_size
      disp('Energy storage system module number set to minimum number of modules!!');
   end;
   disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
end;

if ~strcmp(drivetrain,'conventional')&~strcmp(drivetrain,'ev')
   if design_vars_bool(4)
      disp(['Control strategy - cs_lo_soc ==> ', num2str(evalin('base','cs_lo_soc'))]);
   end
   if design_vars_bool(5)
      disp(['Control strategy - cs_hi_soc ==> ', num2str(evalin('base','cs_hi_soc'))]);
   end
end

if fd_ratio_changed
   disp(['Final drive ratio ==> ',num2str(evalin('base','fd_ratio')),' to allow max speed of ',num2str(max_spd),' mph.']);
end;

check_if_override_mass
disp(['Total vehicle mass ==> ', num2str(evalin('base','veh_mass')), ' kg.'])
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE VALUES IN GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(findobj('tag','input_figure'))
   %update modified variables and display
   if evalin('base','exist(''fc_trq_scale'')')
      fc_trq_scale=evalin('base','fc_trq_scale');
      fc_max_pwr=fc_trq_scale*vinf.fuel_converter.def_max_pwr;
      set(findobj('tag','fc_max_pwr'),'string',num2str((fc_max_pwr)));
      gui_edit_var('fc_max_pwr')
   end
   
   if ~fuelcell&evalin('base','exist(''gc_trq_scale'')')
      gc_trq_scale=evalin('base','gc_trq_scale');
      gc_spd_scale=evalin('base','gc_spd_scale');
      gc_max_pwr=vinf.generator.def_max_pwr*gc_spd_scale*gc_trq_scale;
      set(findobj('tag','gc_max_pwr'),'string',num2str((gc_max_pwr)));
      gui_edit_var('gc_max_pwr')
   end
   
   if evalin('base','exist(''mc_trq_scale'')')
      mc_trq_scale=evalin('base','mc_trq_scale');
      mc_max_pwr=mc_trq_scale*vinf.motor_controller.def_max_pwr;
      set(findobj('tag','mc_max_pwr'),'string',num2str((mc_max_pwr)));
      gui_edit_var('mc_max_pwr')
   end
   
   if evalin('base','exist(''ess_module_num'')')
      set(findobj('tag','ess_num_modules'),'string',num2str(evalin('base','ess_module_num')));
      gui_edit_var('ess_num_modules')
   end
   
   if 0 %design_vars_bool(3) %revised 03/15/00:tm do not override mc_overtrq_factor
      mc_overtrq_factor=evalin('base','mc_overtrq_factor');
      assignin('base','mc_overtrq_factor',mc_overtrq_factor_default)
      gui_edit_var('modify','mc_overtrq_factor',num2str(mc_overtrq_factor))
   end
   
   if design_vars_bool(4)
      cs_lo_soc=evalin('base','cs_lo_soc');
      assignin('base','cs_lo_soc',cs_lo_soc_default)
      gui_edit_var('modify','cs_lo_soc',num2str(cs_lo_soc))
   end
   
   if design_vars_bool(5)
      cs_hi_soc=evalin('base','cs_hi_soc');
      assignin('base','cs_hi_soc',cs_hi_soc_default)
      gui_edit_var('modify','cs_hi_soc',num2str(cs_hi_soc))
   end
   
   if fd_ratio_changed
      fd_ratio=evalin('base','fd_ratio');
      assignin('base','fd_ratio',fd_ratio_default)
      gui_edit_var('modify','fd_ratio',num2str(fd_ratio))
   end
   
end%~isempty

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN-UP WORKSPACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if constraints_bool(1)
   vinf=rmfield(vinf,'max_grade');
end
if constraints_bool(2)
   %      vinf=rmfield(vinf,'acceleration');%ss commented out on 3/23/99 and added following 5 lines
   %   vinf.acceleration=rmfield(vinf.acceleration,'time_0_18'); %tm:1/24/01 no longer necessary
   %  vinf.acceleration=rmfield(vinf.acceleration,'time_0_30'); %tm:1/24/01 no longer necessary
   % vinf.acceleration=rmfield(vinf.acceleration,'time_0_60'); %tm:1/24/01 no longer necessary
   % vinf.acceleration=rmfield(vinf.acceleration,'time_40_60'); %tm:1/24/01 no longer necessary
   %vinf.acceleration=rmfield(vinf.acceleration,'time_0_85'); %tm:1/24/01 no longer necessary
   
   %vinf=rmfield(vinf,'cycle');
end

% restore emissions calculations settings
if exist('ex_calc_default')
   assignin('base','ex_calc',ex_calc_default)
end
% restore thermal calculation settings
if exist('ess_th_calc_default')
   assignin('base','ess_th_calc',ess_th_calc_default)
end
if exist('mc_th_calc_default')
   assignin('base','mc_th_calc',mc_th_calc_default)
end

% remove plot info
evalin('base','clear counter counter_log dv_log obj_log con_log fc_max_pwr_init mpgge_init veh_mass_init mc_trq_scale_init ess_module_num_init constraints')

% set status variable
vinf.autosize_run_status=1;

% reset grade test grade definition to inactive so that future runs calculate max grade
vinf.grade_test.param.active(1)=0;

%%%%%%%%%%%%%%%%%%%%%%%
%SUBFUNCTION SECTION
%%%%%%%%%%%%%%%%%%%%%%%

function check_if_override_mass
%ss 9/20/98-
%use override mass if defined 
%only use override mass if input figure is open
if ~isempty(findobj('tag','input_figure'));%sam added 9/17/98
   if get(findobj('tag','override_mass_checkbox'),'value')==1
      assignin('base','veh_mass',str2num(gui_current_str('override_mass_value')));
   end
end%~isempty
return

function adjust_fc(options) 
% tm 11/2/98
% adjust bounds and assign next test point
switch options
case 'grade'
   
   if evalin('caller','isempty(max_grade)')
      assignin('caller','fc_lb',evalin('base','fc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   elseif evalin('caller','(max_grade-grade_grade<0)')
      assignin('caller','fc_lb',evalin('base','fc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   else
      assignin('caller','fc_ub',evalin('base','fc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_ub',10.0)
      else
         assignin('caller','grade_ub',evalin('caller','max_grade'));
      end
   end
   
case 'accel'
   if evalin('caller','nnz((accel_targets>0).*accel_results<0)|nnz((accel_targets>0).*((accel_results-accel_targets).*accel_equality>0))')
      assignin('caller','fc_lb',evalin('base','fc_trq_scale'));
   else
      assignin('caller','fc_ub',evalin('base','fc_trq_scale'));
   end
end
assignin('base','fc_trq_scale',evalin('caller','round(0.5*(fc_lb+fc_ub)*1000)/1000'));
evalin('base','fc_pwr_scale=fc_spd_scale*fc_trq_scale;');
disp(['Fuel converter ==> ', num2str(evalin('base',...
      'round(calc_max_pwr(''fuel_converter''))')), ' kW'])

return

function adjust_mc(options) 
% tm 11/2/98
% adjust bounds and assign next test point
switch options
case 'grade'
   
   if evalin('caller','isempty(max_grade)')
      assignin('caller','mc_lb',evalin('base','mc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   elseif evalin('caller','(max_grade-grade_grade<0)')
      assignin('caller','mc_lb',evalin('base','mc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   else
      assignin('caller','mc_ub',evalin('base','mc_trq_scale'));
      if evalin('caller','iter')==0
         assignin('caller','grade_ub',10.0)
      else
         assignin('caller','grade_ub',evalin('caller','max_grade'));
      end
   end
   
case 'accel'
   if evalin('caller','nnz((accel_targets>0).*accel_results<0)|nnz((accel_targets>0).*((accel_results-accel_targets).*accel_equality>0))')
      assignin('caller','mc_lb',evalin('base','mc_trq_scale'));
   else
      assignin('caller','mc_ub',evalin('base','mc_trq_scale'));
   end
end
assignin('base','mc_trq_scale',evalin('caller','round(0.5*(mc_lb+mc_ub)*1000)/1000'));
disp(['Motor Controller ==> ', num2str(evalin('base',...
      'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW'])

return

function adjust_cs_hi_soc(options) 
% tm 11/2/98
% adjust bounds and assign next test point
switch options
case 'grade'
   
   if evalin('caller','isempty(max_grade)')
      assignin('caller','cs_hi_soc_lb',evalin('base','cs_hi_soc'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   elseif evalin('caller','(max_grade-grade_grade<0)')
      assignin('caller','cs_hi_soc_lb',evalin('base','cs_hi_soc'));
      if evalin('caller','iter')==0
         assignin('caller','grade_lb',0)
      elseif evalin('caller','~isempty(max_grade)')
         assignin('caller','grade_lb',evalin('caller','max_grade'));
      end
   else
      assignin('caller','cs_hi_soc_ub',evalin('base','cs_hi_soc'));
      if evalin('caller','iter')==0
         assignin('caller','grade_ub',10.0)
      else
         assignin('caller','grade_ub',evalin('caller','max_grade'));
      end
   end
   
case 'accel'
   if evalin('caller','nnz((accel_targets>0).*accel_results<0)|nnz((accel_targets>0).*((accel_results-accel_targets).*accel_equality>0))')
      assignin('caller','cs_hi_soc_lb',evalin('base','cs_hi_soc'));
   else
      assignin('caller','cs_hi_soc_ub',evalin('base','cs_hi_soc'));
   end
end
assignin('base','cs_hi_soc',evalin('caller','round(0.5*(cs_hi_soc_lb+cs_hi_soc_ub)*1000)/1000'));
disp(['cs_hi_soc ==> ', num2str(evalin('base','cs_hi_soc'))])

return

function adjust_ess(options)
% tm 11/2/98
% adjust bounds and assign next test point
switch options
case 'grade'
   if evalin('caller','isempty(max_grade)')
      assignin('caller','ess_lb',evalin('base','ess_module_num'));
   elseif evalin('caller','(max_grade-grade_grade<0)')
      assignin('caller','ess_lb',evalin('base','ess_module_num'));
   else
      assignin('caller','ess_ub',evalin('base','ess_module_num'));
   end;
case 'accel'
   if evalin('caller','nnz((accel_targets>0).*accel_results<0)|nnz((accel_targets>0).*((accel_results-accel_targets).*accel_equality>0))')
      assignin('caller','ess_lb',evalin('base','ess_module_num'));
   else
      assignin('caller','ess_ub',evalin('base','ess_module_num'));
   end;
end;
assignin('base','ess_module_num',evalin('caller','round(0.5*(ess_lb+ess_ub))'));
disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))]);
return

function grade_achieved=check_grade_results(options)
% tm 11/2/98
% check results
switch options
   
case 'tolerance'
   if evalin('caller','abs(max_grade-grade_grade)<=grade_grade_tol')
      grade_achieved=1;
      %disp('Vehicle achieved grade test goals!');
   else
      grade_achieved=0;
      %disp('Grade results exceed grade test tolerance.');
   end;
   
case 'greaterthan'
   if evalin('caller','max_grade>=grade_grade-grade_grade_tol')
      grade_achieved=1;
      %disp('Vehicle achieved grade test goals!');
   else
      grade_achieved=0;
      %disp('Grade results exceed grade test tolerance.');
   end;
end;
return

function [resp]=calc_accel(inputs)

[error,results]=adv_no_gui('accel_test',inputs);
resp=[];
results.accel;
if ~error
   if isfield(results.accel,'times')
      resp=[resp, results.accel.times];
   end
   if isfield(results.accel,'dist')
      resp=[resp, results.accel.dist];
   end
   if isfield(results.accel,'time')
      resp=[resp, results.accel.time];
   end
   if isfield(results.accel,'max_rate')
      resp=[resp, results.accel.max_rate];
   end
   if isfield(results.accel,'max_speed')
      resp=[resp, results.accel.max_speed];
   end
end

function [resp]=calc_grade(inputs,option)
resp=[];
if strcmp(option,'multi')
   inputs.grade.param=inputs.grade.param(2:end);
   inputs.grade.value=inputs.grade.value(2:end);
end

[error,results]=adv_no_gui('grade_test',inputs);
if ~error
   resp=results.grade.grade;
end

function accel_achieved=check_accel_results(options)
% tm 11/2/98
% check results
switch options
case 'tolerance'
   if evalin('caller','nnz(abs(((accel_targets>0).*accel_results-accel_targets))<=accel_target_tols)&((accel_targets>0).*accel_results.*accel_equality<=(accel_targets>0).*(accel_targets+accel_target_tols).*accel_equality)')
      accel_achieved=1;
      %disp('Vehicle achieved acceleration test goals!');
   else
      accel_achieved=0;
      %disp('Acceleration test results exceed tolerance.');
   end;
   
case 'lessthan'
   if evalin('caller','((accel_targets>0).*accel_results>=0)&(((accel_targets>0).*accel_results.*accel_equality)<=((accel_targets>0).*(accel_targets+accel_target_tols).*accel_equality))')
      accel_achieved=1;
      %disp('Vehicle achieved acceleration test goals!');
   else
      accel_achieved=0;
      %disp('Acceleration test results exceed tolerance.');
   end
   
end
return

function update_plot()

global vinf

evalin('base','counter=counter+1;')

if evalin('base','counter')==1
   % initialize log vectors
   assignin('base','dv_log',[]);
   assignin('base','con_log',[]);
   assignin('base','obj_log',[]);
   assignin('base','counter_log',[]);
   
   % store initial values
   if ~strcmp(vinf.drivetrain.name,'ev')
      %evalin('base','fc_trq_scale_init=fc_trq_scale;')
      evalin('base','fc_max_pwr_init=calc_max_pwr(''fuel_converter'');')
   end;
   if ~strcmp(vinf.drivetrain.name,'conventional')
      evalin('base','ess_module_num_init=ess_module_num;')
      evalin('base','mc_trq_scale_init=mc_trq_scale;')
   end;
   evalin('base','veh_mass_init=veh_mass;')
   mpgge=0;
   assignin('base','mpgge_init',mpgge+eps)
   
   % store contraints
   %evalin('base','constraints=[vinf.autosize.con.grade.goal.grade vinf.autosize.con.accel.goal.t0_18 vinf.autosize.con.accel.goal.t0_30 vinf.autosize.con.accel.goal.t0_60 vinf.autosize.con.accel.goal.t40_60 vinf.autosize.con.accel.goal.t0_85];')
   if isfield(vinf,'grade_test')&isfield(vinf,'accel_test')
      constraints=[vinf.grade_test.param.grade*vinf.autosize.constraints(1),...
            [vinf.accel_test.param.accel_time1_con*vinf.accel_test.param.active(3),...
               vinf.accel_test.param.accel_time2_con*vinf.accel_test.param.active(4),...
               vinf.accel_test.param.accel_time3_con*vinf.accel_test.param.active(5),...
               vinf.accel_test.param.dist_in_time_con*vinf.accel_test.param.active(6),...
               vinf.accel_test.param.time_in_dist_con*vinf.accel_test.param.active(7),...
               vinf.accel_test.param.max_accel_con*vinf.accel_test.param.active(8),...
               vinf.accel_test.param.max_speed_con*vinf.accel_test.param.active(9)]*vinf.autosize.constraints(2)];
   elseif ~isfield(vinf,'accel_test')
      constraints=[vinf.grade_test.param.grade*vinf.autosize.constraints(1),...
            [0,...
               0,...
               0,...
               0,...
               0,...
               0,...
               0]*vinf.autosize.constraints(2)];
   elseif ~isfield(vinf,'grade_test')
      constraints=[0*vinf.autosize.constraints(1),...
            [vinf.accel_test.param.accel_time1_con*vinf.accel_test.param.active(3),...
               vinf.accel_test.param.accel_time2_con*vinf.accel_test.param.active(4),...
               vinf.accel_test.param.accel_time3_con*vinf.accel_test.param.active(5),...
               vinf.accel_test.param.dist_in_time_con*vinf.accel_test.param.active(6),...
               vinf.accel_test.param.time_in_dist_con*vinf.accel_test.param.active(7),...
               vinf.accel_test.param.max_accel_con*vinf.accel_test.param.active(8),...
               vinf.accel_test.param.max_speed_con*vinf.accel_test.param.active(9)]*vinf.autosize.constraints(2)];
   end
   assignin('base','constraints',constraints)
   
   % open a new figure window
   evalin('base','figure')
   set(gcf,'NumberTitle','off','Name','Autosize Summary')
end

if evalin('base','counter')>=1
   
   max_grade=0;
   if evalin('caller','exist(''max_grade'')')
      value=evalin('caller','max_grade');
   else
      value=[];
   end
   if vinf.autosize.constraints(1)&~isempty(value)
      max_grade=value;
   end
   
   accel1=0;
   accel2=0;
   accel3=0;
   accel4=0;
   accel5=0;
   accel6=0;
   accel7=0;
   if evalin('caller','exist(''accel_results'')')
      value=evalin('caller','accel_results');
   else
      value=[];
   end
   if vinf.autosize.constraints(2)
      time_max=ceil(max([vinf.accel_test.param.accel_time1_con*vinf.accel_test.param.active(3) vinf.accel_test.param.accel_time2_con*vinf.accel_test.param.active(4)...
            vinf.accel_test.param.accel_time3_con*vinf.accel_test.param.active(5)]))+10;
      i=1;
      for x=1:7
         if vinf.accel_test.param.active(x+2)
            eval(['accel',num2str(x),'=value(',num2str(i),');'])
            i=i+1;
         end
      end
   end
   
   evalin('base','counter_log=[counter_log; counter];');
   if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
      evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') ess_module_num mc_trq_scale];');
   elseif vinf.autosize.dv(1)&vinf.autosize.dv(2)
      evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') ess_module_num];');
   elseif vinf.autosize.dv(2)&vinf.autosize.dv(3)
      evalin('base','dv_log=[dv_log; ess_module_num mc_trq_scale];');
   elseif vinf.autosize.dv(1)&vinf.autosize.dv(3)
      evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') mc_trq_scale];');
   elseif vinf.autosize.dv(1)
      evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'')];');
   elseif vinf.autosize.dv(2)
      evalin('base','dv_log=[dv_log; ess_module_num];');
   elseif vinf.autosize.dv(3)
      evalin('base','dv_log=[dv_log; mc_trq_scale];');
   end
   
   evalin('base',['con_log=[con_log; ',num2str(max_grade),' ',num2str(accel1),' ',num2str(accel2),' ',num2str(accel3),' ',num2str(accel4),' ',num2str(accel5),' ',num2str(accel6),' ',num2str(accel7),'];']);
   
   obj_sum=0;
   if vinf.autosize.obj(1)
      if vinf.autosize.dv(1)
         obj_sum=obj_sum+evalin('base','calc_max_pwr(''fuel_converter'')/fc_max_pwr_init');
      end
      if vinf.autosize.dv(2)
         obj_sum=obj_sum+evalin('base','ess_module_num/ess_module_num_init');
      end
      if vinf.autosize.dv(3)
         obj_sum=obj_sum+evalin('base','mc_trq_scale/mc_trq_scale_init');
      end
   end;
   if vinf.autosize.obj(2)
      obj_sum=obj_sum+evalin('base','veh_mass/veh_mass_init');
   end
   if vinf.autosize.obj(3)
      obj_sum=obj_sum+evalin('base','mpgge/mpgge_init');
   end
   evalin('base',['obj_log=[obj_log; ',num2str(obj_sum/sum([vinf.autosize.dv(1:3)*vinf.autosize.obj(1) vinf.autosize.obj(2) vinf.autosize.obj(3)])),'];']);
   
   % plot optimization summary
   as_plot 
   % opt_plot will look for the following info in the workspace
   % 	obj_log, con_log, counter_log, dv_log
   
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision History
% 8/12/98:tm second grade test in series commented out so that 
% 				 it does not reduce component size after accel test 
% 				 has been achieved.
% 8/13/98:tm round function added to trq scale assignments to limit values to one decimal place
% 8/13/98:tm added set commands to update GUI input window information
% 8/13/98:tm added spd_scale where appropriate
% 8/13/98:tm fully commented
% 8/13/98:tm lower bound checking added to all loops
% 8/14/98:tm revised sizing procedure for conventional so that it uses less interations
% 8/14/98:tm changed the rounding statements to include a hundredths place
% 8/14/98:tm defined a fuel convertor torque scale delta to allow the use to adjust the resolution
% 8/14/98:tm added tolerance checking on acceleration results
% 8/14/98:tm added statements to add changed variables to the edit var list
% 8/17/98:tm series sizing procedure revised
% 8/20/98:tm added maximums to the definitions
% 8/20/98:tm revised the sizing strategy for parallel vehicles
% 8/21/98:tm statements to adjust the mc_spd_scale/gear ratio to ensure max speed can be achieved
% 8/21/98:tm fc_2_mc_pwr_coef introduced, defines the pwr relationship between the fc and mc in a parallel vehicle
%            1.0 -> fc and mc equivalent, 0.5 -> fc one half the size of mc, etc.
% 8/21/98:tm added maximum checking to series strategy
% 8/25/98:tm revised conventional sizing strategy to use bisection method
% 8/28/98:tm cleaned up series case
% 8/28/98:tm cleaned up conventional case
% 8/28/98:tm removed all update values in GUI input window statements since GUI is now invisible
% 9/11/98:tm revised parallel sizing strategy to use bisection method
% 9/14/98:tm motor/generator miss match - generator avg. eff. calculation fixed 
% 9/14/98:tm all trq scales rounded to three decimal places
% 9/14/98:tm exit condition added to all while loops such that ub and lb must differ by either 1 (ess) or 0.001 (fc)
% 9/15/98:tm final drive now sized to account for max wheel slip
% 9/16/98:tm added input arguments to the autosize function
% 9/16/98:tm rounded final drive ratio to three decimal places
% 9/17/98:ss updated so it could be run from the command line
% 9/20/98-ss added subfunction check_if_override_mass
% 9/28/98:tm removed rounding statements in UPDATE VALUES IN GUI section -was causing trq_scale errors in conjuction with gui_edit_var function 
% 10/13/98:tm changed the min mc size to 15kW
% 10/13/98:tm changed the min energy storage system voltage to 120 volts
% 10/13/98:tm introduced variable hybridization to define the level of hybridization for parallel vehicles
% 10/13/98:tm added call to function hybridize for user input on the level of hybridization with the default being 0.3
% 10/13/98:tm added override min fc size and set the min and max mc size based on the min and max number of ess modules
% 10/13/98:tm updated the change fd_ratio statements for parallel vehicles to be based on fc rather than mc because the mc is already matched to the fc by the control strategy
% 10/13/98:tm minimized the ess and mc prior to testing fc lower bound for grade - new sizing procedure
% 10/13/98:tm added match_mc_to_ess subfunction - replaced associated lines in main function
% 10/13/98:tm sizing of ess for accel replaced with statements to size the fc for accel performance
% 10/13/98:tm updated grade and accel verification sections for new parallel sizing method
% 11/2/98:tm created several new subfunctions and revised all configs to use new subfunctions
% 11/3/98:tm all vehicles can now be sized based on grade only, accel only, or grade and accel
% 11/3/98:tm introduced new variable vinf.autosize_run_status that is set to 1 whenever autosize has been run
%				 it is set to 0 by other functions when anything is changed after an autosize run.
% 12/14/98:tm changed grade validation for series hybrids to allow the fc size to be decreased if too big
% 12/14/98:tm motor size matching to fuel converter no longer based on max power but on matching the peak motor
%				  efficiency at a specific speed to the peak power of the fuel converter, results in better efficiency with a larger motor but smaller fc
% 12/30/98:tm allows the fc size to be reduced in a series config after meeting grade and accel requirements; fixes the hybridization value--it
%             did the opposite of the description
% 3/11/99:tm functionality added to incorporate 0_18 and 0-30 accel times
% 4/9/99:tm added statements to turn off emissions calculations and return to original settings when finished
% 5/17/99:tm added statements to the end of the series config to optimize the cs_hi_soc and cs_lo_soc variables
% 7/2/99:tm major revision - no longer seperate cases for each vehicle typ, now conditional statements used within a single routine
% 8/12/99:tm added display statements to verifying accel section
% 8/12/99:tm changed mc_trq_scale_ub from 100 to 10 - caused failed accel tests at upper bounds
% 8/12/99:tm modified objective function calc to include motor controller
% 8/12/99:tm changed mc_trq_scale_ub from 10 to 5 - more realistic displays, little impact on results
% 8/12/99:tm changed min gc and mc pwr to 15 kW - should have little impact other than not trying motors less than 15kW
% 8/12/99:tm changed iter<=max_iter to iter<max_iter on all while loops - max iteration exit condition was not enforced
% 8/12/99:tm completed verify acceleration section to handle all possible scenarios
% 9/21/99:tm added if ~fuelcell statements around calls to match_gc_to_fc
% 9/21/99:tm dv_log now stores fc_max_pwr rather than fc_trq_scale
% 3/15/00 tm removed statements for overriding mc_overtrq_factor - it seems best not to do thisreturn
% 4/4/00:tm replace clear *init with clear (specific variables) to prevent gb_num_init from being cleared
% 4/5/00:tm added conditional to bound initialization in minimizing mc section to prevent motors smaller than those 
%				used while sizing for grade
% 4/5/00:tm added statements to reinitialize the motor upper bound will sizing engine for grade in verify grade section
% 4/24/00:tm replaced all calls to adjust_fd with opt_fd_ratio - new and improved!!
% 7/16/00:tm set default design variables such that fd ratio is active by default
% 7/17/00:tm added new argument to accept dv bounds
% 7/17/00:tm added conditionals to use dv bounds if provide else default to previous implementation
% 7/17/00:tm commented out statement that automatically sets the fc min to 1/2 the default for parallels
% 1/23/01:tm updated function calls for grade performance from grade_test to adv_no_gui('grade_test'...
% 1/23/01:tm updated function calls for accel performance from accel_test to adv_no_gui('accel_test'...
% 1/23/01:tm added temporarily override of display_flag to avoid errors associated with grade and accel function mods
% 1/23/01:tm added temporarily override of accel targets and tolerances to avoid errors associated with accel function mods
% 1/29/01:tm updated update_plot section for new grade and accel test formats
% 1/29/01:tm added conditionals around setup of grade and accel input parameter structures so they are not run unless necessary
% 1/29/01:tm updated adjust* functions to account for some accel targets are greater than and not less than
% 1/29/01:tm replaced manual override of accel target tolerances with actual inputs
% 1/29/01:tm added statement to reset grade parameter to inactive so that future grade tests sample max grade


