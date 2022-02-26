function [resp]=vdoc_as_opt(option,X)
% autosize vehicle using VisualDOC optimization software
%
% option - lets the function know who it has been called by
%		- matlab
%		- visdoc
%
% X - vector of input values (used only with option='visdoc')
%
% resp - vector of output values
% 
% objectives - minimize component sizes
% 		   		minimize vehicle mass
% 		   		maximize fuel economy
% design variables - fc_trq_scale
%			   			ess_module_num
%			   			mc_trq_scale
% constraints - 	accel_0_18
% 						accel_0_30
%						accel_0_60
%						accel_40_60
%						accel_0_85
%						max_grade
%

% default option
if nargin<1
   option='matlab'
end

switch option
   
case 'matlab' % main optimization routine
   
   disp(' ')
   disp('*********************************************')
   disp('*** Autosize Using VisualDOC Optimization ***')
   disp('*********************************************')
   disp(' ')
   
   % store the current directory and move to the optimization runs directory
   current_dir=evalin('base','pwd');
   advisor_path=strrep(which('advisor.m'),'\advisor.m','');
   opt_runs_path=[advisor_path,'\optimization'];
   evalin('base',['cd ''',opt_runs_path,'''']);
   
   % default name for optimization files
   name='VDOC_AS';
   
   % save current vehicle and optimization parameters
   vdoc_as_pre(name)
   
   % create *.dat file
   vdoc_as_dat(name)
   
   % read in the analyze_as.m file
   fid=fopen('analyze_as.m','r');
   i=0;
   while ~feof(fid)
      i=i+1;
      str{i}=fgets(fid);
   end
   fclose(fid);
   
   % write out the analyze.m file
   fid=fopen([strrep(opt_runs_path,'\optimization','\gui'),'\analyze.m'],'w');
   for i=1:length(str)
      fprintf(fid,str{i});
   end
   fclose(fid);
   
   %path_old=evalin('base',['which(''analyze_as.m'')']);
   %path_new=strrep(path_old,'analyze_as.m','analyze.m');
   %evalin('base',['!copy "',path_old,'" "',path_new,'"'])
   
   % find location of vdoc executeable
   vdoc_path=evalin('base','which(''vdoc_matlab.exe'')');
   
   % run optimization software
   eval(['[state,msg]=dos(''vdoc_matlab.exe ',name,'_OPT.DAT'');'])
   %state=execute(['vdoc_matlab.exe ',name,'_OPT.DAT'],[matlabroot,'\bin']);
   state
   msg
   if ~state&findstr(msg,'Closed')
      %if ~state
      errors=0;
   else
      errors=1;
   end
   
   if ~errors
      disp('Optimization completed.')
      % get new values and update the workspace
      vdoc_as_post(name)
   else
      disp('Optimization unsuccessful.')
   end
   
   % restore the current directory
   evalin('base',['cd ''',current_dir,'''']);
   
   resp=1; %dummy response vector
   
case 'visdoc'
   
   datalog=1; % creates a diary file for monitoring the optimization
   debug=0; % 1==> results in additional output information for debuging, 0==> debug prints off
   resp=[];
   
   % default upper and lower bounds
   gc_lb=0.2;
   mc_lb=0.2;
   gc_ub=20.0;
   mc_ub=20.0;
   
   % define and/or increment counter
   if evalin('base','~exist(''counter_as'')')
      evalin('base','counter_as=1;')
   else
      evalin('base','counter_as=counter_as+1;')
   end
   counter_as=evalin('base','counter_as');
   
   if counter_as==1 % execute these statements on first interation only
      
      % store the current directory and move to the optimization runs directory
      current_dir=evalin('base','pwd');
      advisor_path=strrep(which('advisor.m'),'\advisor.m','');
      opt_runs_path=[advisor_path,'\optimization'];
      evalin('base',['cd ''',opt_runs_path,'''']);
      
      if datalog
         % remove old *.log file
         if exist('VDOC_AS.LOG')
            fid=fopen('VDOC_AS.LOG','w');
            fprintf(fid,'\n');
            fclose(fid);
         end
         % remove old *.mat file
         if exist('VDOC_AS_OUT.MAT')
            fid=fopen('VDOC_AS_OUT.MAT','w');
            fprintf(fid,'\n');
            fclose(fid);
         end
         % start new *.log file
         diary('VDOC_AS.LOG')
         disp(' ')
         disp(['Start time: ',datestr(now)])
         disp(' ')
         disp(['Iteration #: 1'])
      end
      
      % load complete vehicle file
      evalin('base','VDOC_AS_in')
      
      % make vinf a global variable and set vehicle type identifier
      global vinf
      drivetrain=vinf.drivetrain.name;
      
      % initialization
      vinf.run_without_gui=1; % ensures no gui operations
      
      % run the components datfiles in the workspace based on type of vehicle
      gui_run_files('load'); %this is a standard advisor file(few modifications since a2.1.1)
      
      % load the default initial conditions
      init_conds
      
      % define boolean flag to indicate override mass case
      eval('vinf.variables; test4exist=1;', 'test4exist=0;') 
      if test4exist
         vinf.variables;
         i=1;
         loop=1;
         while loop
            str=vinf.variables.name{i};
            if strcmp(str,'veh_mass')
               assignin('base','veh_override_mass_bool',1)
               evalin('base',['veh_override_mass=vinf.variables.value(',num2str(i),');'])
            else
               assignin('base','veh_override_mass_bool',0)
            end
            i=i+1;
            if ~strcmp(str,'veh_mass')&i<=length(vinf.variables.name)
               loop=1;
            else
               loop=0;
            end
         end
      end
      
      % load optimization parameters
      evalin('base','load(''VDOC_AS_OPT'')')
      evalin('base','vinf=vehicle_info;')
      evalin('base','clear vehicle_info')
      %evalin('base','vinf=setfield(vinf,''autosize'',params);')
      %evalin('base','vinf=setfield(vinf,''units'',params2);')
      %evalin('base','clear params params2')
      
      % set autosize status variable
      vinf.autosize_run_status=1;
      
      if isfield(vinf,'grade_test')
         grade_input=vinf.grade_test;
      else
         grade_input=[];
      end
      if isfield(vinf,'grade_test')
         accel_input=vinf.accel_test;
      else
         accel_input=[];
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
      end
      
      assignin('base','input_struc',input)
      
      % turn off all emissions calculations to save simulation time
      if evalin('base','exist(''ex_calc'')')
         evalin('base','ex_calc=0;')
      end
      % turn off all thermal calculations to save simulation time
      if evalin('base','exist(''ess_th_calc'')')
         evalin('base','ess_th_calc=0;')
      end
      if evalin('base','exist(''mc_th_calc'')')
         evalin('base','mc_th_calc=0;')
      end
      
      % override the overtrq factor when sizing the motor
      if 0%vinf.autosize.dv(3)
         evalin('base','mc_overtrq_factor=1;')
      end
      
      assignin('base','counter_as',counter_as) % erased by gui_run_files
      
   else % execute these statements for all cases other than the first iteration
      
      % make vinf a global variable and set vehicle type identifier
      global vinf
      drivetrain=vinf.drivetrain.name;
      
      if datalog
         diary on
         disp(' ')
         disp(['Iteration #: ',num2str(counter_as)])
         disp(' ')
         disp('FROM VISUALDOC:')
         switch drivetrain
         case 'conventional'
            if vinf.autosize.dv(1)
               disp(['fc_trq_scale = ',num2str(X(1))])
            end
         case 'series'
            if vinf.autosize.dv(1)
               disp(['fc_trq_scale = ',num2str(X(1))])
            end
            if vinf.autosize.dv(2)
               disp(['ess_module_num = ',num2str(X(2))])
            end
         case 'fuel_cell'
            if vinf.autosize.dv(1)
               disp(['fc_trq_scale = ',num2str(X(1))])
            end
            if vinf.autosize.dv(2)
               disp(['ess_module_num = ',num2str(X(2))])
            end
         case 'parallel'
            if vinf.autosize.dv(1)
               disp(['fc_trq_scale = ',num2str(X(1))])
            end
            if vinf.autosize.dv(2)
               disp(['ess_module_num = ',num2str(X(2))])
            end
         case 'ev'
            if vinf.autosize.dv(2)
               disp(['ess_module_num = ',num2str(X(2))])
            end
         end % case ...
      end % if datalog ...
   end % if counter_as==1 ... else ...
   
   
   %%%%
   % execute these statements during all iterations
   %%%%%
   
   % assign optimizer variables
   if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
      assignin('base','fc_trq_scale',X(1)) 
      assignin('base','ess_module_num',X(2)) 
      assignin('base','mc_trq_scale',X(3)) 
   elseif vinf.autosize.dv(1)&vinf.autosize.dv(2)
      assignin('base','fc_trq_scale',X(1)) 
      assignin('base','ess_module_num',X(2)) 
   elseif vinf.autosize.dv(1)&vinf.autosize.dv(3)
      assignin('base','fc_trq_scale',X(1)) 
      assignin('base','mc_trq_scale',X(2)) 
   elseif vinf.autosize.dv(2)&vinf.autosize.dv(3)
      assignin('base','ess_module_num',X(1)) 
      assignin('base','mc_trq_scale',X(2)) 
   elseif vinf.autosize.dv(1)
      assignin('base','fc_trq_scale',X(1))
   elseif vinf.autosize.dv(2)
      assignin('base','ess_module_num',X(1)) 
   elseif vinf.autosize.dv(3)
      assignin('base','mc_trq_scale',X(1))
   end
   
   input_struc=evalin('base','input_struc');
   
   % recompute the fc_pwr_scale if necessary
   if ~strcmp(drivetrain,'ev')
      evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale;')
   end
   
   % set fuelcell flag
   if strcmp(drivetrain,'fuel_cell')
      fuelcell=1;
   else
      fuelcell=0;
   end
   
   if strcmp(drivetrain,'series')|strcmp(drivetrain,'fuel_cell')
      % match gc spd range to that of the fc 
      if ~fuelcell
         if counter_as==1
            assignin('base','gc_spd_scale',evalin('base','max(fc_map_spd*fc_spd_scale)/max(gc_map_spd)'))
         end
         
         % match gc trq range to that of the fc 
         match_gc_to_fc(gc_lb,gc_ub)
      end
      
      % reload PTC file to update cs_pwr and cs_spd vectors
      evalin('base','adjust_cs')
      
      if ~vinf.autosize.dv(3)
         % adjust mc_trq_scale to match fc
         match_mc_to_fc(mc_lb,mc_ub)
         
         % adjust mc_trq_scale to match ess
         match_mc_to_ess(max(evalin('base','mc_trq_scale'),mc_lb),mc_ub)
      end
   end
   
   if strcmp(drivetrain,'parallel')|strcmp(drivetrain,'ev')
      if ~vinf.autosize.dv(3)
         % adjust mc_trq_scale to match ess
         match_mc_to_ess(mc_lb,mc_ub)
      end
   end
   
   if counter_as==1 % only do this on the first iteration
      % set the fd ratio to achieve the goal max speed
      adjust_fd(vinf.autosize.con.max_spd)
   end
   
   % recalculate the vehicle and component masses
   recompute_mass
   
   if datalog
      disp(' ')
      disp('BEFORE ANALYSIS:')
      switch drivetrain
      case 'conventional'
         disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
      case 'series'
         disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
         disp(['gc_trq_scale = ',evalin('base','num2str(gc_trq_scale)')])
         disp(['gc_spd_scale = ',evalin('base','num2str(gc_spd_scale)')])
         disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
         disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
      case 'fuel_cell'
         disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
         disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
         disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
      case 'parallel'
         disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
         disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
         disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
      case 'ev'
         disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
         disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
      end
      disp(['fd_ratio = ',evalin('base','num2str(fd_ratio)')])
   end
   
   if vinf.autosize.constraints(1) % grade is a constraint??
      % run grade test
      max_grade=calc_grade(input_struc,'multi');
      if isempty(max_grade)
         max_grade=0; % if grade test is unsuccessful return a zero (worst value understood by optimizer)
      end
   else
      max_grade=0; % return place holder
   end;
   
   if vinf.autosize.constraints(2) % accel is a constraint??
      % run acceleration test
      accel_results=calc_accel(input_struc);
   end
   if 0
      if vinf.autosize.constraints(2) % accel is a constraint??
      % run acceleration test
   
      [a0_60, a0_85, a40_60]=accel_test;
      a0_18=vinf.acceleration.time_0_18;
      a0_30=vinf.acceleration.time_0_30;
      time_max=ceil(max([vinf.autosize.con.accel.goal.t0_18 vinf.autosize.con.accel.goal.t0_30...
            vinf.autosize.con.accel.goal.t0_60 vinf.autosize.con.accel.goal.t40_60 ...
            vinf.autosize.con.accel.goal.t0_85]))+10; % length of accel cycle 
      % override any unachieved accel times with length of accel cycle
      if a0_60<0
         a0_60=time_max;
      end
      if a40_60<0
         a40_60=time_max;
      end
      if a0_85<0
         a0_85=time_max;
      end
      if a0_18<0
         a0_18=time_max;
      end
      if a0_30<0
         a0_30=time_max;
      end
   else
      a0_18=0;
      a0_30=0;
      a0_60=0;
      a40_60=0;
      a0_85=0;
   end
   end
   if vinf.autosize.obj(3) % mpg is an objective??   
      % run city/hwy fuel economy test
      vinf.run_without_gui=1;
      vinf.parametric.run='off';
      vinf.acceleration.run='off';
      vinf.gradeability.run='off';
      vinf.cycle.run='off';
      vinf.cycle.SOCtol=0.5;
      vinf.cycle.number=1;
      vinf.cycle.SOCiter=15;
      vinf.test.name='TEST_CITY_HWY';
      evalin('base','TEST_CITY_HWY')
      mpgge=evalin('base','combined_mpgge');
   else
      mpgge=0;
   end
   
   veh_mass=evalin('base','veh_mass');
   
   % setup response vector
   index=1;
   if vinf.autosize.obj(1)
      if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
         resp(index)=X(1);
         index=index+1;
         resp(index)=X(2);
         index=index+1;
         resp(index)=X(3);
         index=index+1;
      elseif (vinf.autosize.dv(1)&vinf.autosize.dv(2))|(vinf.autosize.dv(1)&vinf.autosize.dv(3))|(vinf.autosize.dv(3)&vinf.autosize.dv(2))
         resp(index)=X(1);
         index=index+1;
         resp(index)=X(2);
         index=index+1;
      else
         resp(index)=X(1);
         index=index+1;
      end
   end
   if vinf.autosize.constraints(1)
      resp(index)=max_grade;
      index=index+1;
   end
   if vinf.autosize.constraints(2)
      i=1;
      if vinf.accel_test.param.active(3)
         resp(index)=accel_results(i);
         accel1=accel_results(i);
         index=index+1;
         i=i+1;
      else
         accel1=0;
      end
      if vinf.accel_test.param.active(4)
         resp(index)=accel_results(i);
                  accel2=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel2=0;
end
      if vinf.accel_test.param.active(5)
         resp(index)=accel_results(i);
                  accel3=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel3=0;
end
      if vinf.accel_test.param.active(6)
         resp(index)=accel_results(i);
                  accel4=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel4=0;
end
      if vinf.accel_test.param.active(7)
         resp(index)=accel_results(i);
                  accel5=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel5=0;
end
      if vinf.accel_test.param.active(8)
         resp(index)=accel_results(i);
                  accel6=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel6=0;
end
      if vinf.accel_test.param.active(9)
         resp(index)=accel_results(i);
                  accel7=accel_results(i);
index=index+1;
         i=i+1;
            else
         accel7=0;
end
   end
   if vinf.autosize.obj(2)
      resp(index)=veh_mass;
      index=index+1;
   end
   if vinf.autosize.obj(3)
      resp(index)=mpgge;
   end
   
   
   if datalog
      disp(' ')
      disp('SIMULATION RESULTS:')
      i=1;
      if vinf.accel_test.param.active(3)
         disp(['Accel1 = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(4)
         disp(['Accel2 = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(5)
         disp(['Accel3 = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(6)
         disp(['dist in time = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(7)
         disp(['time in dist = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(8)
         disp(['max accel = ',num2str(accel_results(i))])
         i=i+1;
      end
      if vinf.accel_test.param.active(9)
         disp(['max speed = ',num2str(accel_results(i))])
         i=i+1;
      end
      disp(['max_grade = ',num2str(max_grade)])
      disp(['vehicle mass = ',num2str(veh_mass)])
      disp(['mpgge = ',num2str(mpgge)])
      
      disp(' ')
      disp(['Simulation time: ',datestr(now)])
      disp(' ')
      
      % turn off the diary
      diary off
      
      if counter_as==1 % execute these statements only on the first iteration
         
         % initialize log vectors
         assignin('base','dv_log',[]);
         assignin('base','con_log',[]);
         assignin('base','obj_log',[]);
         assignin('base','counter_log',[]);
         
         % store initial values
         if ~strcmp(drivetrain,'ev')
            evalin('base','fc_max_pwr_init=calc_max_pwr(''fuel_converter'');')
         end
         if ~strcmp(drivetrain,'conventional')
            evalin('base','ess_module_num_init=ess_module_num;')
            evalin('base','mc_trq_scale_init=mc_trq_scale;')
         end
         evalin('base','veh_mass_init=veh_mass;')
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
         figure
         set(gcf,'NumberTitle','off','Name','VisualDOC Autosize Summary')
         
      end
      
      if counter_as>=1 % execute these statements for all iterations
         
         % update counter log vector
         evalin('base','counter_log=[counter_log; counter_as];');
         
         % update design variable log vector
         if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
            evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') ess_module_num mc_trq_scale];');
         elseif vinf.autosize.dv(1)&vinf.autosize.dv(2)
            evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') ess_module_num];');
         elseif vinf.autosize.dv(1)&vinf.autosize.dv(3)
            evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'') mc_trq_scale];');
         elseif vinf.autosize.dv(2)&vinf.autosize.dv(3)
            evalin('base','dv_log=[dv_log; ess_module_num mc_trq_scale];');
         elseif vinf.autosize.dv(1)
            evalin('base','dv_log=[dv_log; calc_max_pwr(''fuel_converter'')];');
         elseif vinf.autosize.dv(2)
            evalin('base','dv_log=[dv_log; ess_module_num];');
         elseif vinf.autosize.dv(3)
            evalin('base','dv_log=[dv_log; mc_trq_scale];');
         end
         
         % update constraint log vector
   evalin('base',['con_log=[con_log; ',num2str(max_grade),' ',num2str(accel1),' ',num2str(accel2),' ',num2str(accel3),' ',num2str(accel4),' ',num2str(accel5),' ',num2str(accel6),' ',num2str(accel7),'];']);
         
         % calculate and update the normalize objective function
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
            obj_sum=obj_sum+evalin('base','mpgge_init/combined_mpgge');
         end
         evalin('base',['obj_log=[obj_log; ',num2str(obj_sum/sum([vinf.autosize.dv*vinf.autosize.obj(1) vinf.autosize.obj(2) vinf.autosize.obj(3)])),'];']);
         
         % plot optimization summary
         as_plot
         
      end % if counter ...
      
      % save optimization results
      str='counter_log dv_log con_log obj_log constraints '; 
      %if vinf.autosize.obj(1)
      if vinf.autosize.dv(2)
         str=[str,'ess_module_num_init '];
      end
      if vinf.autosize.dv(1)
         str=[str,'fc_max_pwr_init '];
      end
      if vinf.autosize.dv(3)
         str=[str,'mc_trq_scale_init '];
      end
      %end
      if vinf.autosize.obj(3)
         str=[str,'mpgge_init '];
      end
      if vinf.autosize.obj(2)
         str=[str,'veh_mass_init '];
      end
      evalin('base',['save VDOC_AS_OUT ',str,''])
      
   end % if datalog ...
end % case ...

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

%%%% REVISION HISTORY
% 4/9/99:tm added statements to turn off emissions calculations
% 4/13/99:tm added more comment lines
% 8/31/99:tm eliminated the subfunction section - all matching routines now stand alone functions
% 8/31/99:tm replaced file run statements with gui_run_files('load')
% 8/31/99:tm updated naming format to VDOC_AS
% 8/31/99:tm included mc_trq_scale as a design variable
% 9/23/99:tm moved power scale calc to immediately after fc_trq_scale assignment
% 9/23/99:tm now saving fc_max_pwr rather than fc_trq_scale
% 10/25/99:tm added definitions for vinf.SOCtol and vinf.SOCiter so that autosize for fuel economy works
% tm:7/14/00 removed \gui from advisor path information due to updated path structure
% 01/31/01:tm major revisions to work with revised accel and grade tests
% 01/31/01:tm added vinf.cycle.number definition and changed counter to counter_as (delta soc also uses counter) so the optimization for fuel economy works
%
%
