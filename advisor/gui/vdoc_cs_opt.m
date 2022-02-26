function [resp]=opt_autosize(option,X)
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
% objectives - minimize CO
% 		   		minimize HC
% 		   		minimize NOx
% 		   		minimize PM
% 		   		maximize fuel economy
%
% design variables - cs* (depends on vehicle type)
%			   			
% constraints - 	accel_0_60
%						accel_40_60
%						accel_0_85
%						max_grade
%

% default option
if nargin<1
   option='matlab';
end

switch option
   
case 'matlab' % main optimization routine
   
   global vinf
   
   % record start time
   start_time=clock;
   num_calls=0;

   disp(' ')
   disp('*****************************************************')
   disp('*** Control Strategy Optimization Using VisualDOC ***')
   disp('*****************************************************')
   disp(' ')
   
   % store the current directory and move to the optimization runs directory
   current_dir=evalin('base','pwd');
   advisor_path=strrep(which('advisor.m'),'\advisor.m','');
   opt_runs_path=[advisor_path,'\optimization'];
   evalin('base',['cd ''',opt_runs_path,'''']);
   
   % find location of vdoc executeable
   vdoc_path=evalin('base','which(''vdoc_matlab.exe'')');
   
   % default name for optimization files
   name='VDOC_CS';
   
   % save current vehicle and optimization parameters
   vdoc_cs_pre(name)
   
   % read in the analyze_cs.m file
   fid=fopen('analyze_cs.m','r');
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
   
   %path_old=which('analyze_cs.m');
   %   path_new=strrep(path_old,'analyze_cs.m','analyze.m');
   %   evalin('base',['!copy "',path_old,'" "',path_new,'"'])
   
   % initialize error flag
   errors=0;
   
   if X
      % create DOE *.dat file
      %vdoc_cs_doe_dat(name)
      
      % run DOE
      %str=['!',vdoc_path,' ',name,'_DOE.DAT'];
      %evalin('base',str) % calls the vdoc_matlab.exe file from DOS
      
      % get candidate values and responses
      %errors=vdoc_cs_doe_post(name);
      
      % call matlab doe routine
      [vinf.control_strategy.cv,vinf.control_strategy.cr]=doe(vinf.control_strategy.dv.lower_bound,vinf.control_strategy.dv.upper_bound,vinf.control_strategy.dv.active);
      
      if ~isempty(vinf.control_strategy.cr)
         errors=0;
      else
         errors=1;
      end
      
      % remove the vinf.run_without_gui flag
      vinf=rmfield(vinf,'run_without_gui'); % was set within the doe function above
      
   end
   
   if ~errors
      if X
         num_calls=num_calls+length(vinf.control_strategy.cv);
         
         disp('Design of Experiments completed.')
      end
      
      % remove invalid points from candidate values and responses
      vdoc_cs_validate
      
      % store optimization parameters
      evalin('base','params1=getfield(vinf,''control_strategy'');')
      evalin('base','params2=getfield(vinf,''autosize'');')
      evalin('base','params3=getfield(vinf,''units'');')
      evalin('base',['save(''',name,'_OPT'',''params1'',''params2'',''params3'');'])
      evalin('base','clear params1 params2 params3')
      
      % create optimization *.dat file
      vdoc_cs_opt_dat(name)
      
      % run optimization software
      eval(['[state,msg]=dos(''vdoc_matlab.exe ',name,'_OPT.DAT'');'])
      %state=execute(['vdoc_matlab.exe ',name,'_OPT.DAT'],[matlabroot,'\bin']);

     if ~state&findstr(msg,'Closed')
     %if ~state
         errors=0;
      else
         errors=1;
      end
      
      if ~errors      % get new values and update the workspace
         errors=vdoc_cs_opt_post(name);
         
         disp(' ')
         disp(['Elapsed Time: ',num2str(etime(clock, start_time)/60), ' minutes'])
         disp(['Number of Function Calls: ',num2str(num_calls)])
         disp(' ')
      end
      
      if ~errors
         disp('Optimization completed.')
         resp=1; % success flag
      else
         disp('Optimization unsuccessful.')
         resp=0; % success flag
      end
   else
      disp('Design of Experiments unsuccessful.')
      resp=0; % success flag
   end
   
   % restore the current directory
   evalin('base',['cd ''',current_dir,'''']);
   
case 'visdoc'
   
   resp=0;

   if evalin('caller','exist(''running_doe'')')
      running_doe=1;
   else
      running_doe=0;
   end
   
   if ~running_doe
      datalog=1; % creates a diary file for monitoring the optimization
   else
      datalog=0;
   end
   
   debug=0; % 1==> results in additional output information for debuging, 0==> debug prints off
   
   % define and/or increment counter
   if evalin('base','~exist(''cs_counter'')')
      evalin('base','cs_counter=1;')
   else
      evalin('base','cs_counter=cs_counter+1;')
   end
   cs_counter=evalin('base','cs_counter');
   
   if cs_counter==1 % execute these statements on first interation only
      
      % store the current directory and move to the optimization runs directory
      current_dir=evalin('base','pwd');
      advisor_path=strrep(which('advisor.m'),'\advisor.m','');
      opt_runs_path=[advisor_path,'\optimization'];
      evalin('base',['cd ''',opt_runs_path,'''']);
      
      if datalog
         % remove old *.log file
         if evalin('base','exist(''VDOC_CS.LOG'')')
            eval('!del VDOC_CS.LOG')
         end
         % start new *.log file
         diary('VDOC_CS.LOG')
         disp(' ')
         disp(['Start time: ',datestr(now)])
         disp(' ')
         disp(['Iteration #: 1'])
      end
      
      if ~running_doe
         % remove old *.mat file
         if evalin('base','exist(''VDOC_CS_OUT.MAT'')')
            eval('!del VDOC_CS_OUT.MAT')
         end
      end
      
      if ~running_doe
         % load complete vehicle file
         evalin('base','VDOC_CS_in')
      end
      
      % make vinf a global variable and set vehicle type identifier
      global vinf
      drivetrain=vinf.drivetrain.name;
      
      % initialization
      vinf.run_without_gui=1; % ensures no gui operations
      
      if ~running_doe
         % run the components datfiles in the workspace based on type of vehicle
         gui_run_files('load'); %this is a standard advisor file(few modifications since a2.1.1)
         
         % load the default initial conditions
         init_conds
         
         % load optimization and autosize parameters
         evalin('base','load(''VDOC_CS_OPT'')')
         evalin('base','vinf.control_strategy=params1;')
         evalin('base','vinf.autosize=params2;')
         evalin('base','vinf.units=params3;')
         evalin('base','clear params1 params2 params3')
         
         % turn off all emissions calculations if no emissions defined and emissions 
         % are not an objective to save simulation time
         if evalin('base','exist(''ex_calc'')')
            if evalin('base','fc_emis')
               evalin('base','ex_calc=1;')
            else
               evalin('base','ex_calc=0;')
            end
         end
         
         % turn off all thermal calculations to save simulation time
         if evalin('base','exist(''ess_th_calc'')')
            evalin('base','ess_th_calc=0;')
         end
         if evalin('base','exist(''mc_th_calc'')')
            evalin('base','mc_th_calc=0;')
         end
      end
      
      % initialization
      vinf.autosize_run_status=1; % needed for the accel_test initialization
      vinf.run_without_gui=1; % ensures no gui operations
      
      % setup simulation info
      if vinf.control_strategy.cycle.run
         vinf.cycle.run='on';
      else
         vinf.cycle.run='off';
      end
      vinf.cycle.number=1;
      vinf.cycle.name=vinf.control_strategy.cycle.name;
      vinf.cycle.soc='on';
      vinf.cycle.socmenu='zero delta';
      vinf.cycle.SOCtol=0.5;
      vinf.cycle.SOCiter=15;
      if strcmp(vinf.cycle.run,'on')
         evalin('base',vinf.cycle.name);
      end
      if ~vinf.control_strategy.cycle.run
         vinf.test.run='on';
      else
         vinf.test.run='off';
      end
      vinf.test.name=vinf.control_strategy.test.name;
      if 0%vinf.autosize.constraints(1) % grade is a constraint
         vinf.gradeability.run='on';
         vinf.gradeability.speed=vinf.autosize.con.grade.goal.mph;
      else
         vinf.gradeability.run='off';
      end;
      if 0%vinf.autosize.constraints(2) % accel is a constraint
         vinf.acceleration.run='on';
      else
         vinf.acceleration.run='off';
      end;
      vinf.road_grade.run='off';
      vinf.parametric.run='off';
      
      assignin('base','cs_counter',cs_counter) % redefine counter variable - it was cleared by gui_run_files('load')
      
   else % execute these statements for all cases other than the first iteration
      
      % make vinf a global variable and set vehicle type identifier
      global vinf
      drivetrain=vinf.drivetrain.name;
      
      if datalog
         diary on
         disp(' ')
         disp(['Iteration #: ',num2str(cs_counter)])
         disp(' ')
         disp('FROM VISUALDOC:')
         index=0;
         for i=1:length(vinf.control_strategy.dv.active)
            if vinf.control_strategy.dv.active(i)
               index=index+1;
               disp([vinf.control_strategy.dv.name{i},' = ',num2str(X(index))])
            end
         end
      end % if datalog ...
   end % if cs_counter==1 ... else ...
   
   tmp=evalin('base','cs_counter');
   cs_counter;
   
   %%%%
   % execute these statements during all iterations
   %%%%%
   
   % assign optimizer variables
   index=0;
   for i=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(i)
         index=index+1;
         assignin('base',vinf.control_strategy.dv.name{i},X(index))
      end
   end
   
   if datalog
      disp(' ')
      disp('BEFORE ANALYSIS:')
      for i=1:length(vinf.control_strategy.dv.active)
         if vinf.control_strategy.dv.active(i)
            disp([vinf.control_strategy.dv.name{i},' = ',evalin('base',['num2str(',vinf.control_strategy.dv.name{i},')'])])
         end
      end
   end
   
   %run the simulation
   evalin('base','gui_run;')
   
   % store grade test results
   if vinf.autosize.constraints(1) % grade is a constraint
      grade_test(vinf.autosize.con.grade.goal.mph);
      max_grade=vinf.max_grade;
      if isempty(max_grade)
         max_grade=0; % if grade test is unsuccessful return a zero (worst value understood by optimizer)
      end
   else % grade not a constraint
      max_grade=0; 
   end
   
   % store accel test results
   if vinf.autosize.constraints(2) % accel is a constraint
      accel_test;
      a0_18=vinf.acceleration.time_0_18;
      a0_30=vinf.acceleration.time_0_30;
      a0_60=vinf.acceleration.time_0_60;
      a40_60=vinf.acceleration.time_40_60;
      a0_85=vinf.acceleration.time_0_85;
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
   else % accel not a constraint
      a0_18=0;
      a0_30=0;
      a0_60=0;
      a40_60=0;
      a0_85=0;
   end
   
   % store fuel economy and emissions results
   if evalin('base','exist(''J17_mpgge'')')
      mpgge=evalin('base','J17_mpgge');
   elseif evalin('base','exist(''combined_mpgge'')')
      mpgge=evalin('base','combined_mpgge');
   else
      mpgge=evalin('base','mpgge');
   end
   co=evalin('base','co_gpm');
   hc=evalin('base','hc_gpm');
   nox=evalin('base','nox_gpm');
   pm=evalin('base','pm_gpm');
   
   if cs_counter==1
      % store initial design variable values
      for i=1:length(vinf.control_strategy.dv.name)
         if vinf.control_strategy.dv.active(i)
            evalin('base',[vinf.control_strategy.dv.name{i},'_init=',vinf.control_strategy.dv.name{i},';'])
         end
      end
      
      % store initial objective values
      assignin('base','mpgge_init',mpgge)
      assignin('base','co_gpm_init',co)
      assignin('base','hc_gpm_init',hc)
      assignin('base','nox_gpm_init',nox)
      assignin('base','pm_gpm_init',pm)
   end
   
   % calculate objective function
   results=[co hc nox pm mpgge];
   init=[evalin('base','co_gpm_init') evalin('base','hc_gpm_init') evalin('base','nox_gpm_init') evalin('base','pm_gpm_init') evalin('base','mpgge_init')];
   obj=0;
   for i=1:length(vinf.control_strategy.obj.name)
      if vinf.control_strategy.obj.active(i)
         if i==5 % maximize fuel economy
            obj=obj+vinf.control_strategy.obj.weight(i)*init(i)/results(i);
         else % minimize emissions
            obj=obj+vinf.control_strategy.obj.weight(i)*results(i)/init(i);
         end
      end
   end
   obj=obj/sum(vinf.control_strategy.obj.active.*vinf.control_strategy.obj.weight); % normalize
   
   % setup response vector
   index=1;
   if vinf.autosize.constraints(1)
      resp(index)=max_grade;
      index=index+1;
   end
   if vinf.autosize.constraints(2)
      if vinf.autosize.con.accel.goal.t0_18>0
         resp(index)=a0_18;
         index=index+1;
      end
      if vinf.autosize.con.accel.goal.t0_30>0
         resp(index)=a0_30;
         index=index+1;
      end
      if vinf.autosize.con.accel.goal.t0_60>0
         resp(index)=a0_60;
         index=index+1;
      end
      if vinf.autosize.con.accel.goal.t40_60>0
         resp(index)=a40_60;
         index=index+1;
      end
      if vinf.autosize.con.accel.goal.t0_85>0
         resp(index)=a0_85;
         index=index+1;
      end
   end
   resp(index)=evalin('base','cs_hi_soc-cs_lo_soc');
   index=index+1;
   resp(index)=evalin('base','missed_trace');
   index=index+1;
   resp(index)=evalin('base','missed_deltaSOC');
   index=index+1;
   resp(index)=co;
   index=index+1;
   resp(index)=hc;
   index=index+1;
   resp(index)=nox;
   index=index+1;
   resp(index)=pm;
   index=index+1;
   resp(index)=mpgge;
   index=index+1;
   resp(index)=obj;
   
   if datalog
      disp(' ')
      disp('SIMULATION RESULTS:')
      disp(['Accel 0-18 = ',num2str(a0_18)])
      disp(['Accel 0-30 = ',num2str(a0_30)])
      disp(['Accel 0-60 = ',num2str(a0_60)])
      disp(['Accel 40-60 = ',num2str(a40_60)])
      disp(['Accel 0-85 = ',num2str(a0_85)])
      disp(['max_grade = ',num2str(max_grade)])
      disp(['mpgge = ',num2str(mpgge)])
      disp(['co = ',num2str(co)])
      disp(['hc = ',num2str(hc)])
      disp(['nox = ',num2str(nox)])
      disp(['pm = ',num2str(pm)])
      disp(['objective = ',num2str(obj)])
      disp(['missed trace = ',num2str(evalin('base','missed_trace'))])
      disp(['missed deltasoc = ',num2str(evalin('base','missed_deltaSOC'))])
      disp(['dsoc = ',num2str(evalin('base','cs_hi_soc-cs_lo_soc'))])
      disp(' ')
      disp(['Simulation time: ',datestr(now)])
      disp(' ')
   end
   
   
   if cs_counter==1 % execute these statements only on the first iteration
      
      % initialize log vectors
      assignin('base','dv_log',[]);
      assignin('base','con_log',[]);
      assignin('base','obj_log',[]);
      assignin('base','counter_log',[]);
      assignin('base','results_log',[]);
      
      % store contraints
      evalin('base','constraints=[vinf.autosize.con.grade.goal.grade vinf.autosize.con.accel.goal.t0_18 vinf.autosize.con.accel.goal.t0_30 vinf.autosize.con.accel.goal.t0_60 vinf.autosize.con.accel.goal.t40_60 vinf.autosize.con.accel.goal.t0_85];')
      
      % plot optimization summary
      if running_doe
         % open a new figure window
         figure
         set(gcf,'NumberTitle','off','Name','VisualDOC Control Stategy Optimization Summary')
      else
         cs_plot('initialize')
      end
   end
   
   
   if cs_counter>=1 % execute these statements for all iterations
      
      % update counter log vector
      evalin('base','counter_log=[counter_log; cs_counter];');
      
      % update design variable log vector
      str=[];
      for i=1:length(vinf.control_strategy.dv.active)
         if vinf.control_strategy.dv.active(i)
            str=[str, ' ', vinf.control_strategy.dv.name{i}];
         end
      end
      evalin('base',['dv_log=[dv_log; ',str,'];']);
      
      % update constraint log vector
      evalin('base',['con_log=[con_log; ',num2str(max_grade),' ',num2str(a0_18),' ',num2str(a0_30),' ',num2str(a0_60),' ',num2str(a40_60),' ',num2str(a0_85),'];']);
      
      % update the normalize objective function log vector
      evalin('base',['obj_log=[obj_log; ',num2str(obj),'];']);
      
      % update the results log vector
      evalin('base',['results_log=[results_log; ',num2str(co),' ',num2str(hc),' ',num2str(nox),' ',num2str(pm),' ',num2str(mpgge),'];']);
      
      % plot optimization summary
      if running_doe
         vdoc_cs_doe_plot 
      else
         cs_plot('update')
      end
      
   end % if counter ...
   
   if ~running_doe
      % save optimization results
      str='counter_log dv_log con_log obj_log constraints results_log ';         
      %for i=1:length(vinf.control_strategy.dv.name)
      %   if vinf.control_strategy.dv.active(i)
      %      str=[str, ' ', vinf.control_strategy.dv.name{i}];
      %   end
      %end
      %if vinf.autosize.constraints(1)
      %   evalin('base','max_grade=vinf.max_grade*100;')
      %   str=[str ' max_grade '];
      %end
      %if vinf.autosize.constraints(2)
      %   str=[str ' accel_time_0_18 accel_time_0_30 accel_time_0_60 accel_time_40_60 accel_time_0_85'];
      %end
      evalin('base',['save VDOC_CS_OUT ',str,''])
   end
   
   if datalog
      % turn off the diary
      diary off
   end
   
end % case ...

% tm:7/14/00 removed \gui from advisor path information due to updated path structure
% 8/18/00:tm changed all references to counter to cs_counter - counter is used by other scripts
% 8/18/00:tm disabled run of accel and grade tests through the gui temporily, now done manually - some fields did not exist due to changes in test formats
