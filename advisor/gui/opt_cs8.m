function opt_cs(inputs)
%
% Optimize Vehicle Control Strategy
%
% format:  opt_cs(params)
%
% params.cycle.name - name of the drive cycle/test procedure in quotes
% params.cycle.run - name of the drive cycle/test procedure in quotes
% params.test.name - name of the drive cycle/test procedure in quotes
% params.dv.lower_bound - lower bound defining range to explore
% params.dv.upper_bound - upper bound defining range to explore
% params.dv.first_points - number of points to evaluate in first round
% params.dv.second_points - number of points to evaluate in second round
% params.dv.active - boolean vector defining which design variables to use
% params.dv.name - boolean vector defining which design variables to use
% params.obj.active - boolean vector defining which objectives to evaluate [FE HC CO NOx PM]
% params.obj.weight - weighting factors corresponding to the objectives 
% params.con.value - weighting factors corresponding to the objectives 
%

% make vinf available to the function
global vinf

if strcmp(vinf.units,'metric');
   labels={'l/100km','g/km'};
else
   labels={'mpgge','g/mi'};
end


% make params available to the subfunctions
global params
params=inputs;
clear inputs

linear=0;
num_calls=0;
display=0;

% setup simulation info
if vinf.control_strategy.cycle.run
   vinf.cycle.run='on';
   vinf.test.run='off';
else
   vinf.cycle.run='off';
   vinf.test.run='on';
end
vinf.cycle.number=1;
vinf.cycle.name=vinf.control_strategy.cycle.name;
vinf.test.name=vinf.control_strategy.test.name;
vinf.cycle.soc='on';
vinf.cycle.socmenu='zero delta';
vinf.cycle.SOCtol=0.5;
vinf.cycle.SOCiter=15;
if strcmp(vinf.cycle.run,'on')
   evalin('base',vinf.cycle.name);
   if evalin('base','size(cyc_grade,2)<2')
      evalin('base','cyc_grade=[0 cyc_grade; 1 cyc_grade];')
   end
end
if 0%vinf.autosize.constraints(1) % grade is a constraint
   vinf.gradeability.run='on';
   vinf.gradeability.speed=vinf.autosize.con.grade.goal.mph;
else
   vinf.gradeability.run='off';
end
if 0%vinf.autosize.constraints(2) % accel is a constraint
   vinf.acceleration.run='on';
else
   vinf.acceleration.run='off';
end
vinf.road_grade.run='off';
vinf.parametric.run='off';
vinf.run_without_gui=1;

% define the override values here
if strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'fuel_cell')
   params.dv.override=[0 0 0 0 inf inf -inf 0 0];
elseif strcmp(vinf.drivetrain.name,'parallel')
   params.dv.override=[0 0 0 0 0 0 0 0];
end

if (sum(params.obj.active(1:4))>0)|(nnz((~params.obj.active(1:4).*params.con.value(1:4))>0))
   
   % if any emissions are active obj or con then calc emissions else don't calc emissions
   
   % turn on all emissions calculations 
   if evalin('base','exist(''ex_calc'')')
      ex_calc_default=evalin('base','ex_calc');
      evalin('base','ex_calc=1;')
   end
   % turn on all thermal calculations 
   if evalin('base','exist(''ess_th_calc'')')
      ess_th_calc_default=evalin('base','ess_th_calc');
      evalin('base','ess_th_calc=1;')
   end
   if evalin('base','exist(''mc_th_calc'')')
      mc_th_calc_default=evalin('base','mc_th_calc');
      evalin('base','mc_th_calc=1;')
   end
else
   % turn off all emissions calculations to save simulation time
   if evalin('base','exist(''ex_calc'')')
      ex_calc_default=evalin('base','ex_calc');
      evalin('base','ex_calc=0;')
   end
   % turn off all thermal calculations to save simulation time
   if evalin('base','exist(''ess_th_calc'')')
      ess_th_calc_default=evalin('base','ess_th_calc');
      evalin('base','ess_th_calc=0;')
   end
   if evalin('base','exist(''mc_th_calc'')')
      mc_th_calc_default=evalin('base','mc_th_calc');
      evalin('base','mc_th_calc=0;')
   end
end
start_time=clock;
disp(' ')
disp('** Starting Control Strategy Optimization **')
disp(' ')
disp(['Simulation start time: ',datestr(now)])
disp(' ')
if linear
   disp('Using linear search method.')
else
   disp('Using 2-stage full range search method.')
end
disp(' ')

if display
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         eval(['h_',params.obj.name{i},'_fig=figure;'])
         set(gcf,'NumberTitle','off','Name',[params.obj.name{i},'-obj'])
      elseif params.con.value(i)>0
         eval(['h_',params.obj.name{i},'_fig=figure;'])
         set(gcf,'NumberTitle','off','Name',[params.obj.name{i},'-con'])
      end
   end
end

cs_plot('initialize')

% initialize counter
counter=0;
results_log=[];
dv_log=[];
obj_log=[];
con_log=[];

% set initial conditions
for i=1:length(params.dv.active)
   if params.dv.active(i)
      assignin('base',params.dv.name{i},params.dv.init_cond(i))
   end
end

% determine the initial fuel economy and emissions
[co, hc, nox, pm, mpgge, con]=run_test;
counter=counter+1;
init=[co hc nox pm mpgge];
results_log=[results_log; init];
con_log=[con_log; con];
obj_log=[obj_log; 1];
index=1;
for i=1:length(params.dv.active)
   if params.dv.active(i)
      val(index)=evalin('base',params.dv.name{i});
      index=index+1;
   end
end
dv_log=[dv_log; val];

if display
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         figure(eval(['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],init(i)./results_log(:,i),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},'/',labels{1},''])
         else
            plot([1:counter],results_log(:,i)/init(i),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' (',labels{2},')/(',labels{2},')'])
         end
         title('Control Strategy Optimization - Objective')
         xlabel('Design Iteration')
      elseif params.con.value(i)>0
         figure(eval(['h_',params.obj.name{i},'_fig']))
         plot([1:counter],results_log(:,i),'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
         if i==5
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
         else
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
         end
         title('Control Strategy Optimization - Constraint')
         xlabel('Design Iteration')
      end
   end
end

assignin('base','results_log',results_log)
assignin('base','dv_log',dv_log)
assignin('base','obj_log',obj_log)
cs_plot('update')
drawnow

% save the current configuration and override active params
for i=3:length(params.dv.name)
   init_config(i)=evalin('base',params.dv.name{i});
   if params.dv.active(i)
      assignin('base',params.dv.name{i},params.dv.override(i));
   end
end

% run parametric sweeps
for i=3:length(params.dv.active)
   if i==3
      if params.dv.active(3)&params.dv.active(4)
         search3(params.dv.name{3},params.dv.lower_bound(3),params.dv.upper_bound(3),...
            params.dv.first_points(3),params.dv.second_points(3),params.dv.name{4},...
            params.dv.lower_bound(4),params.dv.upper_bound(4),params.dv.first_points(4),...
            params.dv.second_points(4))
      elseif params.dv.active(3)
         search2(params.dv.name{3},params.dv.lower_bound(3),params.dv.upper_bound(3),...
            params.dv.first_points(3),params.dv.second_points(3))
      elseif params.dv.active(4)
         search2(params.dv.name{4},params.dv.lower_bound(4),params.dv.upper_bound(4),...
            params.dv.first_points(4),params.dv.second_points(4))
      end
   elseif i==4
      % case 4 accounted for above
   else
      if params.dv.active(i)
         search2(params.dv.name{i},params.dv.lower_bound(i),params.dv.upper_bound(i),...
            params.dv.first_points(i),params.dv.second_points(i))
      end
   end
end

% determine the final fuel economy and emissions
counter=counter+1;
[co, hc, nox, pm, fe, con]=run_test;
results_log=[results_log; co, hc, nox, pm, fe];
con_log=[con_log; con];
index=1;
for i=1:length(params.dv.active)
   if params.dv.active(i)
      val(index)=evalin('base',params.dv.name{i});
      index=index+1;
   end
end
dv_log=[dv_log; val];

if display
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         figure(eval(['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],init(i)./(results_log(:,i)+eps)+(results_log(:,i)==0)*0.999,'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},'/',labels{1},''])
         else
            plot([1:counter],results_log(:,i)/init(i)+(results_log(:,i)==0)*1.001,'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' (',labels{2},')/(',labels{2},')'])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Objective')
      elseif params.con.value(i)>0
         figure(eval(['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],results_log(:,i)+(results_log(:,i)==0)*init(i)*0.999,'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
         else
            plot([1:counter],results_log(:,i)+(results_log(:,i)==0)*init(i)*1.001,'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Constraint')
      end
   end
end

% check for improved objective function 
obj=0;
if con_log(end)==0
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         if i==5
            obj=obj+init(i)./results_log(end,i)*params.obj.weight(i);
         else
            obj=obj+results_log(end,i)/init(i)*params.obj.weight(i);
         end
      end
   end
   obj=obj/(sum(params.obj.active.*params.obj.weight));
else
   obj=2;
end
obj_log=[obj_log; obj];

assignin('base','results_log',results_log)
assignin('base','dv_log',dv_log)
assignin('base','obj_log',obj_log)
cs_plot('update')
cs_plot('end_opt')
drawnow

if obj>1  % revert to initial configuration if objective function not improved
   disp(' ')
   disp('Unable to improve control strategy. Restoring original configuration now.')
   disp(' ')
   for i=3:length(params.dv.active)
      eval([params.dv.name{i},'=',num2str(init_config(i)),';'])
   end
else
   disp(' ')
   if strcmp(vinf.units,'metric')
      disp(['Fuel economy changed by ', num2str(round((results_log(end,5)-init(5))/init(5)*100*10)/10),'% from ',num2str(round(1/(init(5)*units('mpg2kmpl'))*100*10)/10),' ',labels{1},' to ',num2str(round(1/(results_log(end,5)*units('mpg2kmpl'))*100*10)/10),' ',labels{1},'!'])
   else
      disp(['Fuel economy changed by ', num2str(round((results_log(end,5)-init(5))/init(5)*100*10)/10),'% from ',num2str(round(init(5)*10)/10),' ',labels{1},' to ',num2str(round(results_log(end,5)*10)/10),' ',labels{1},'!'])
   end
   if init(1)~=0
      disp(['CO emissions changed by ', num2str(round((results_log(end,1)-init(1))/init(1)*100*10)/10),'% from ',num2str(round(init(1)*1000)/1000),' ',labels{2},' to ',num2str(round(results_log(end,1)*1000)/1000),' ',labels{2},'!'])
   end
   if init(2)~=0
      disp(['HC emissions changed by ', num2str(round((results_log(end,2)-init(2))/init(2)*100*10)/10),'% from ',num2str(round(init(2)*1000)/1000),' ',labels{2},' to ',num2str(round(results_log(end,2)*1000)/1000),' ',labels{2},'!'])
   end
   if init(3)~=0
      disp(['NOx emissions changed by ', num2str(round((results_log(end,3)-init(3))/init(3)*100*10)/10),'% from ',num2str(round(init(3)*1000)/1000),' ',labels{2},' to ',num2str(round(results_log(end,3)*1000)/1000),' ',labels{2},'!'])
   end
   if init(4)~=0
      disp(['PM emissions changed by ', num2str(round((results_log(end,4)-init(4))/init(4)*100*10)/10),'% from ',num2str(round(init(4)*1000)/1000),' ',labels{2},' to ',num2str(round(results_log(end,4)*1000)/1000),' ',labels{2},'!'])
   end
   disp(' ')
   disp('Control Strategy Parameters:')
   for i=3:length(params.dv.active)
      if params.dv.active(i)
         disp([params.dv.name{i},' ', num2str(evalin('base',params.dv.name{i})),' ',params.dv.units{i}])
      end
   end
end

disp(' ')
disp(['Elapsed Time: ',num2str(etime(clock, start_time)/60), ' minutes'])
disp(['Number of Function Calls: ',num2str(num_calls)])
disp(' ')
disp('** Control Strategy Optimization Completed **')
disp(' ')

% update the gui
for i=3:length(params.dv.active)
   if params.dv.active(i)
      assignin('base',params.dv.name{i},init_config(i))
      gui_edit_var('modify',params.dv.name{i},num2str(eval(params.dv.name{i}))) 
   end
end

% clean up
vinf=rmfield(vinf,'cycle');
vinf=rmfield(vinf,'run_without_gui');
evalin('base','clear no_results_fig')

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

return


%%% SUBFUNCTION SECTION

function [co, hc, nox, pm, mpgge, con_violation]=run_test

% make vinf available to the function
global vinf

% run simulation
evalin('base','gui_run');
if vinf.autosize.constraints(1) % accel is a constraint
   vinf.gradeability.speed=vinf.autosize.con.grade.goal.mph;
   vinf.max_grade=grade_test(vinf.gradeability.speed);
end
if vinf.autosize.constraints(2) % accel is a constraint
   accel_test;
end


% get the results
if evalin('base','exist(''combined_mpgge'')')
   mpgge=evalin('base','combined_mpgge');
elseif evalin('base','exist(''J17_mpgge'')')
   mpgge=evalin('base','J17_mpgge');
else
   mpgge=evalin('base','mpgge');
end
hc=evalin('base','hc_gpm');
co=evalin('base','co_gpm');
nox=evalin('base','nox_gpm');
pm=evalin('base','pm_gpm');
resp=[co hc nox pm mpgge];

% initialize constraint violation flag
con_violation=0;

% grade results
if vinf.autosize.constraints(1)
   if vinf.max_grade<vinf.autosize.con.grade.goal.grade-vinf.autosize.con.grade.tol.grade
      con_violation=con_violation+1;
   end
end

% accel results
if vinf.autosize.constraints(2)
   if vinf.autosize.con.accel.goal.t0_18>0
      if vinf.acceleration.time_0_18>vinf.autosize.con.accel.goal.t0_18+vinf.autosize.con.accel.tol.t0_18
         con_violation=con_violation+1;
      end
   end
   if vinf.autosize.con.accel.goal.t0_30>0
      if vinf.acceleration.time_0_30>vinf.autosize.con.accel.goal.t0_30+vinf.autosize.con.accel.tol.t0_30
         con_violation=con_violation+1;
      end
   end
   if vinf.autosize.con.accel.goal.t0_60>0
      if vinf.acceleration.time_0_60>vinf.autosize.con.accel.goal.t0_60+vinf.autosize.con.accel.tol.t0_60
         con_violation=con_violation+1;
      end
   end
   if vinf.autosize.con.accel.goal.t40_60>0
      if vinf.acceleration.time_40_60>vinf.autosize.con.accel.goal.t40_60+vinf.autosize.con.accel.tol.t40_60
         con_violation=con_violation+1;
      end
   end
   if vinf.autosize.con.accel.goal.t0_85>0
      if vinf.acceleration.time_0_85>vinf.autosize.con.accel.goal.t0_85+vinf.autosize.con.accel.tol.t0_85
         con_violation=con_violation+1;
      end
   end
end

% delta soc correction
if evalin('base','missed_deltaSOC')
   con_violation=con_violation+1;
end

% initial soc too small
if evalin('base','ess_init_soc')<0.1
   con_violation=con_violation+1;
end

% missed trace
if evalin('base','missed_trace')
   con_violation=con_violation+1;
end

% objective/constraints
for i=1:length(vinf.control_strategy.obj.active)
   if ~vinf.control_strategy.obj.active(i)&vinf.control_strategy.con.value(i)>0
      if i==5
         if resp(i)<vinf.control_strategy.con.value(i)
            con_violation=con_violation+1;
         end
      else
         if resp(i)>vinf.control_strategy.con.value(i)
            con_violation=con_violation+1;
         end
      end
   end
end

%if con_violation&evalin('caller','counter')~=0 
% if any constraints violated throw-out the results 
% except when calculating initial conditions
%   co=0; 
%   hc=0; 
%   nox=0; 
%   pm=0; 
%   mpgge=0;
%end

%con_violation;

% increment function call counter
evalin('caller','num_calls=num_calls+1;')

return


function search2(var_name,lower_bound,upper_bound,first_intervals,second_intervals)

global params

labels=evalin('caller','labels');
results_log=evalin('caller','results_log');
con_log=evalin('caller','con_log');
dv_log=evalin('caller','dv_log');
obj_log=evalin('caller','obj_log');
counter=evalin('caller','counter');
init=evalin('caller','init');
num_calls=evalin('caller','num_calls');
display=evalin('caller','display');

delta=(upper_bound-lower_bound)/first_intervals; 

results=[];
con_log2=[];
eval(['dv1_',var_name,'=[];'])

if display
   for i=1:length(params.obj.name)
      if params.obj.active(i)
         eval(['h_obj',num2str(i),'=figure;'])
      elseif params.con.value(i)>0
         eval(['h_con',num2str(i),'=figure;'])
      end
   end
end

for i=0:first_intervals
   var_value=lower_bound+delta*i;
   assignin('base',var_name,var_value);
   [co, hc, nox, pm, fe, con]=run_test;
   results=[results; co, hc, nox, pm, fe];
   con_log2=[con_log2; con];
   eval(['dv1_',var_name,'=[dv1_',var_name,'; ',num2str(var_value),'];'])
   
   if display
      for i=1:length(params.obj.active)
         if params.obj.active(i)
            figure(eval(['h_obj',num2str(i)]))
            if i==5
               subplot(2,1,1); plot(lower_bound+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*0.999),'g-')
               ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
            else
               subplot(2,1,1); plot(lower_bound+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*1.001),'g-')
               ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
            end
            xlabel('Variable Value')
            title([strrep(var_name,'_','\_'),' - Objective'])
         elseif params.con.value(i)>0
            figure(eval(['h_con',num2str(i)]))
            if i==5
               subplot(2,1,1); plot(lower_bound+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*0.999),'g-')
               ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
            else
               subplot(2,1,1); plot(lower_bound+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*1.001),'g-')
               ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
            end
            xlabel('Variable Value')
            title([strrep(var_name,'_','\_'),' - Constraint'])
         end
      end
   end
   cs_plot('update')
   drawnow
end

co_min_index=min(find(results(:,1)==min(results(:,1))));
hc_min_index=min(find(results(:,2)==min(results(:,2))));
nox_min_index=min(find(results(:,3)==min(results(:,3))));
pm_min_index=min(find(results(:,4)==min(results(:,4))));
mpgge_max_index=min(find(results(:,5)==max(results(:,5))));

obj=zeros(size(results(:,1)));
for i=1:length(params.obj.active)
   if params.obj.active(i)
      if i==5
         obj=obj+init(i)./results(:,i)*params.obj.weight(i);
      else
         obj=obj+results(:,i)/init(i)*params.obj.weight(i);
      end
   end
end
obj=obj/(sum(params.obj.active.*params.obj.weight))
eval(['obj1_',var_name,'=obj;'])
eval(['con1_',var_name,'=con_log2;'])
for i=1:length(con_log2)
   if con_log2(i)>0
      obj(i)=1000;
   end
end
obj_min_index=min(find(obj==min(obj)));

if first_intervals~=1
   if obj_min_index==1
      var_value_base=lower_bound;
      old_delta=delta;
      old_obj_min_index=obj_min_index;
      delta=old_delta*1/3;
      range=old_delta*1;
   elseif obj_min_index==length(obj)
      var_value_base=lower_bound+delta*(obj_min_index-2);
      old_delta=delta;
      old_obj_min_index=obj_min_index;
      delta=old_delta*1/3;
      range=old_delta*1;
   else
      var_value_base=lower_bound+delta*(obj_min_index-2);
      old_delta=delta;
      old_obj_min_index=obj_min_index;
      delta=old_delta*2/second_intervals;
      range=old_delta*2;
   end
   
   old_results=results;
   old_obj=obj;
   old_con_log2=con_log2;
   
   results=[];
   con_log2=[];
   eval(['dv2_',var_name,'=[];'])
   
   for i=0:range/delta
      var_value=var_value_base+delta*i;
      assignin('base',var_name,var_value);
      [co, hc, nox, pm, fe, con]=run_test;
      results=[results; co, hc, nox, pm, fe];
      con_log2=[con_log2; con];
      eval(['dv2_',var_name,'=[dv2_',var_name,'; ',num2str(var_value),'];'])
      
      if display
         for i=1:length(params.obj.active)
            if params.obj.active(i)
               figure(eval(['h_obj',num2str(i)]))
               if i==5
                  subplot(2,1,2); plot(var_value_base+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*0.999),'g-')
                  ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
               else
                  subplot(2,1,2); plot(var_value_base+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*1.001),'g-')
                  ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
               end
               xlabel('Variable Value')
               title([strrep(var_name,'_','\_'),' - Objective'])
            elseif params.con.value(i)>0
               figure(eval(['h_con',num2str(i)]))
               if i==5
                  subplot(2,1,2); plot(var_value_base+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*0.999),'g-')
                  ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
               else
                  subplot(2,1,2); plot(var_value_base+(delta*([1:size(results,1)]-1)),results(:,i)+((results(:,i)==0)*init(i)*1.001),'g-')
                  ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
               end
               xlabel('Variable Value')
               title([strrep(var_name,'_','\_'),' - Constraint'])
            end
         end
      end
      cs_plot('update')
      drawnow
   end
   
   co_min_index=min(find(results(:,1)==min(results(:,1))));
   hc_min_index=min(find(results(:,2)==min(results(:,2))));
   nox_min_index=min(find(results(:,3)==min(results(:,3))));
   pm_min_index=min(find(results(:,4)==min(results(:,4))));
   mpgge_max_index=min(find(results(:,5)==max(results(:,5))));
   
   obj=zeros(size(results(:,1)));
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         if i==5
            obj=obj+init(i)./results(:,i)*params.obj.weight(i);
         else
            obj=obj+results(:,i)/init(i)*params.obj.weight(i);
         end
      end
   end
   obj=obj/(sum(params.obj.active.*params.obj.weight));
   eval(['obj2_',var_name,'=obj;'])
   eval(['con2_',var_name,'=con_log2;'])
   for i=1:length(con_log2)
      if con_log2(i)>0
         obj(i)=1000;
      end
   end
   obj_min_index=min(find(obj==min(obj)));
   
   if obj(obj_min_index)>old_obj(old_obj_min_index)
      var_value=lower_bound+old_delta*(old_obj_min_index-1);
   else
      var_value=var_value_base+delta*(obj_min_index-1);
   end
   
else
   var_value=lower_bound+delta*(obj_min_index-1);
   eval(['obj2_',var_name,'=[];'])
   eval(['con2_',var_name,'=[];'])
   eval(['dv2_',var_name,'=[];'])
end

assignin('base',var_name,var_value);
assignin('caller',var_name,var_value);

counter=counter+1;
[co, hc, nox, pm, fe, con]=run_test;
results_log=[results_log; co, hc, nox, pm, fe];
con_log=[con_log; con];
index=1;
for i=1:length(params.dv.active)
   if params.dv.active(i)
      val(index)=evalin('base',params.dv.name{i});
      index=index+1;
   end
end
dv_log=[dv_log; val];

obj=0;
for i=1:length(params.obj.active)
   if params.obj.active(i)
      if i==5
         obj=obj+init(i)./results_log(end,i)*params.obj.weight(i);
      else
         obj=obj+results_log(end,i)/init(i)*params.obj.weight(i);
      end
   end
end
obj=obj/(sum(params.obj.active.*params.obj.weight));
obj_log=[obj_log; obj];

if display
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         figure(evalin('caller',['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],init(i)./(results_log(:,i)+eps)+((results_log(:,i)==0)*0.999),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},'/',labels{1},''])
         else
            plot([1:counter],results_log(:,i)/init(i)+((results_log(:,i)==0)*1.001),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' (',labels{2},')/(',labels{2},')'])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Objective')
      elseif params.con.value(i)>0
         figure(evalin('caller',['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],results_log(:,i)+((results_log(:,i)==0)*init(i)*0.999),'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
         else
            plot([1:counter],results_log(:,i)+((results_log(:,i)==0)*init(i)*1.001),'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Constraint')
      end
   end
end

assignin('base','results_log',results_log)
assignin('base','dv_log',dv_log)
assignin('base','obj_log',obj_log)
assignin('base',['dv1_',var_name],eval(['dv1_',var_name]))
assignin('base',['obj1_',var_name],eval(['obj1_',var_name]))
assignin('base',['con1_',var_name],eval(['con1_',var_name]))
assignin('base',['dv2_',var_name],eval(['dv2_',var_name]))
assignin('base',['obj2_',var_name],eval(['obj2_',var_name]))
assignin('base',['con2_',var_name],eval(['con2_',var_name]))
cs_plot('update')
drawnow

assignin('caller','results_log',results_log)
assignin('caller','dv_log',dv_log)
assignin('caller','con_log',con_log)
assignin('caller','obj_log',obj_log)
assignin('caller','counter',counter)
assignin('caller','num_calls',num_calls)

return

function search3(var_name1,lower_bound1,upper_bound1,first_intervals1,second_intervals1,var_name2,lower_bound2,upper_bound2,first_intervals2,second_intervals2)

global params

labels=evalin('caller','labels');
results_log=evalin('caller','results_log');
dv_log=evalin('caller','dv_log');
obj_log=evalin('caller','obj_log');
con_log=evalin('caller','con_log');
counter=evalin('caller','counter');
init=evalin('caller','init');
num_calls=evalin('caller','num_calls');
display=evalin('caller','display');

delta1=(upper_bound1-lower_bound1)/first_intervals1; 
delta2=(upper_bound2-lower_bound2)/first_intervals2; 

results=[];
con_log2=[];
eval(['dv1_',var_name1,'=[];'])
eval(['dv1_',var_name2,'=[];'])
iter=0;

if display
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         eval(['h_obj',num2str(i),'=figure;'])
      elseif params.con.value(i)>0
         eval(['h_con',num2str(i),'=figure;'])
      end
   end
end


for i1=0:first_intervals1
   var_value1=lower_bound1+delta1*i1;
   assignin('base',var_name1,var_value1);
   eval(['dv1_',var_name1,'=[dv1_',var_name1,'; ',num2str(var_value1),'];'])
   for i2=0:first_intervals2
      iter=iter+1;
      var_value2=lower_bound2+delta2*i2;
      assignin('base',var_name2,var_value2);
      
      if i1==0
         eval(['dv1_',var_name2,'=[dv1_',var_name2,'; ',num2str(var_value2),'];'])
      end
      
      [co, hc, nox, pm, fe, con]=run_test;
      results(i1+1,i2+1,1)=co;
      results(i1+1,i2+1,2)=hc;
      results(i1+1,i2+1,3)=nox;
      results(i1+1,i2+1,4)=pm;
      results(i1+1,i2+1,5)=fe;
      con_log2(i1+1,i2+1)=con;
      
      if (rem(iter,first_intervals1+1)==0)&(iter>=(2*(first_intervals1+1)))
         if display
            for i=1:length(params.obj.active)
               if params.obj.active(i)
                  figure(eval(['h_obj',num2str(i)]))
                  if i==5
                     subplot(2,1,1); surf(lower_bound1+(delta1*([1:size(results(:,:,i),1)]-1)),lower_bound2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*0.999))')
                     zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
                  else
                     subplot(2,1,1); surf(lower_bound1+(delta1*([1:size(results(:,:,i),1)]-1)),lower_bound2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*1.001))')
                     zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
                  end
                  ylabel(strrep(var_name2,'_','\_'))
                  xlabel(strrep(var_name1,'_','\_'))
                  title([strrep(var_name1,'_','\_'),' vs. ',strrep(var_name2,'_','\_'),' - Objective'])
               elseif params.con.value(i)>0
                  figure(eval(['h_con',num2str(i)]))
                  if i==5
                     subplot(2,1,1); surf(lower_bound1+(delta1*([1:size(results(:,:,i),1)]-1)),lower_bound2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*0.999))')
                     zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
                  else
                     subplot(2,1,1); surf(lower_bound1+(delta1*([1:size(results(:,:,i),1)]-1)),lower_bound2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*1.001))')
                     zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
                  end
                  ylabel(strrep(var_name2,'_','\_'))
                  xlabel(strrep(var_name1,'_','\_'))
                  title([strrep(var_name1,'_','\_'),' vs. ',strrep(var_name2,'_','\_'),' - Constraint'])
               end
            end
         end
      end
      cs_plot('update')
      drawnow
   end
end

[co_min_index1, co_min_index2]=find(results(:,:,1)==min(min(results(:,:,1))));
[hc_min_index1, hc_min_index2]=find(results(:,:,2)==min(min(results(:,:,2))));
[nox_min_index1,nox_min_index2]=find(results(:,:,3)==min(min(results(:,:,3))));
[pm_min_index1, pm_min_index2]=find(results(:,:,4)==min(min(results(:,:,4))));
[mpgge_max_index1, mpgge_max_index2]=find(results(:,:,5)==max(max(results(:,:,5))));

mpgge_max_index1=min(mpgge_max_index1);
mpgge_max_index2=min(mpgge_max_index2);
hc_min_index1=min(hc_min_index1);      
hc_min_index2=min(hc_min_index2);
co_min_index1=min(co_min_index1);
co_min_index2=min(co_min_index2);
nox_min_index1=min(nox_min_index1);
nox_min_index2=min(nox_min_index2);
pm_min_index1=min(pm_min_index1);
pm_min_index2=min(pm_min_index2);

obj=zeros(size(results(:,:,1)));
for i=1:length(params.obj.active)
   if params.obj.active(i)
      if i==5
         obj=obj+init(i)./results(:,:,i)*params.obj.weight(i);
      else
         obj=obj+results(:,:,i)/init(i)*params.obj.weight(i);
      end
   end
end
obj=obj/(sum(params.obj.active.*params.obj.weight));
eval(['obj1_',var_name1,'_',var_name2,'=obj;'])
eval(['con1_',var_name1,'_',var_name2,'=con_log2;'])
for x=1:size(con_log2,1)
   for y=1:size(con_log2,2)
      if con_log2(x,y)>0
         obj(x,y)=1000;
      end
   end
end

[obj_min_index1, obj_min_index2]=find(obj(:,:,1)==min(min(obj(:,:,1))));
obj_min_index1=min(obj_min_index1);
obj_min_index2=min(obj_min_index2);

if first_intervals1~=1&first_intervals2~=1
   if obj_min_index1==1|obj_min_index2==1
      if obj_min_index1==1
         var_value_base1=lower_bound1;
         old_delta1=delta1;
         old_obj_min_index1=obj_min_index1;
         delta1=old_delta1*1/3;
         range1=1*old_delta1;
      elseif obj_min_index1==size(obj,1)
         var_value_base1=lower_bound1+delta1*(obj_min_index1-2);
         old_delta1=delta1;
         old_obj_min_index1=obj_min_index1;
         delta1=old_delta1*1/3;
         range1=1*old_delta1;
      else
         var_value_base1=lower_bound1+delta1*(obj_min_index1-2);
         old_delta1=delta1;
         old_obj_min_index1=obj_min_index1;
         delta1=old_delta1*2/second_intervals1;
         range1=2*old_delta1;
      end
      if obj_min_index2==1
         var_value_base2=lower_bound2;
         old_delta2=delta2;
         old_obj_min_index2=obj_min_index2;
         delta2=old_delta2*1/3;
         range2=1*old_delta2;
      elseif obj_min_index2==size(obj,2)
         var_value_base2=lower_bound2+delta2*(obj_min_index2-2);
         old_delta2=delta2;
         old_obj_min_index2=obj_min_index2;
         delta2=old_delta2*1/3;
         range2=1*old_delta2;
      else
         var_value_base2=lower_bound2+delta2*(obj_min_index2-2);
         old_delta2=delta2;
         old_obj_min_index2=obj_min_index2;
         delta2=old_delta2*2/second_intervals2;
         range2=2*old_delta2;
      end
   elseif obj_min_index1==size(obj,1)|obj_min_index2==size(obj,2)
      if obj_min_index1==size(obj,1)
         var_value_base1=lower_bound1+delta1*(obj_min_index1-2);
         old_delta1=delta1;
         old_obj_min_index1=obj_min_index1;
         delta1=old_delta1*1/3;
         range1=1*old_delta1;
      else
         var_value_base1=lower_bound1+delta1*(obj_min_index1-2);
         old_delta1=delta1;
         old_obj_min_index1=obj_min_index1;
         delta1=old_delta1*2/second_intervals1;
         range1=2*old_delta1;
      end
      if obj_min_index2==size(obj,2)
         var_value_base2=lower_bound2+delta2*(obj_min_index2-2);
         old_delta2=delta2;
         old_obj_min_index2=obj_min_index2;
         delta2=old_delta2*1/3;      
         range2=1*old_delta2;
      else
         var_value_base2=lower_bound2+delta2*(obj_min_index2-2);
         old_delta2=delta2;
         old_obj_min_index2=obj_min_index2;
         delta2=old_delta2*2/second_intervals2;
         range2=2*old_delta2;
      end
   else
      var_value_base1=lower_bound1+delta1*(obj_min_index1-2);
      old_delta1=delta1;
      old_obj_min_index1=obj_min_index1;
      delta1=old_delta1*2/second_intervals1;
      range1=2*old_delta1;
      
      var_value_base2=lower_bound2+delta2*(obj_min_index2-2);
      old_delta2=delta2;
      old_obj_min_index2=obj_min_index2;
      delta2=old_delta2*2/second_intervals2;
      range2=2*old_delta2;
   end
   
   old_obj=obj;
   old_con_log2=con_log2;
   old_results=results;
   obj=zeros(size(results(:,:,1)));
   results=[];
   con_log2=[];
   eval(['dv2_',var_name1,'=[];'])
   eval(['dv2_',var_name2,'=[];'])
iter=0;
   
   for i1=0:(range1/delta1)
      var_value1=var_value_base1+delta1*i1;
      assignin('base',var_name1,var_value1);
      eval(['dv2_',var_name1,'=[dv2_',var_name1,'; ',num2str(var_value1),'];'])
      for i2=0:(range2/delta2)
         iter=iter+1;
         var_value2=var_value_base2+delta2*i2;
         assignin('base',var_name2,var_value2);
         
         if i1==0
            eval(['dv2_',var_name2,'=[dv2_',var_name2,'; ',num2str(var_value2),'];'])
         end

         [co, hc, nox, pm, fe, con]=run_test;
         results(i1+1,i2+1,1)=co;
         results(i1+1,i2+1,2)=hc;
         results(i1+1,i2+1,3)=nox;
         results(i1+1,i2+1,4)=pm;
         results(i1+1,i2+1,5)=fe;
         con_log2(i1+1,i2+1)=con;
         
         if (rem(iter,range1/delta1+1)==0)&(iter>=(2*(range1/delta1+1)))
            if display
               for i=1:length(params.obj.active)
                  if params.obj.active(i)
                     figure(eval(['h_obj',num2str(i)]))
                     if i==5
                        subplot(2,1,2); surf(var_value_base1+(delta1*([1:size(results(:,:,i),1)]-1)),var_value_base2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*0.999))')
                        zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
                     else
                        subplot(2,1,2); surf(var_value_base1+(delta1*([1:size(results(:,:,i),1)]-1)),var_value_base2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*1.001))')
                        zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
                     end
                     ylabel(strrep(var_name2,'_','\_'))
                     xlabel(strrep(var_name1,'_','\_'))
                     title([strrep(var_name1,'_','\_'),' vs. ',strrep(var_name2,'_','\_'),' - Objective'])
                  elseif params.con.value(i)>0
                     figure(eval(['h_con',num2str(i)]))
                     if i==5
                        subplot(2,1,2); surf(var_value_base1+(delta1*([1:size(results(:,:,i),1)]-1)),var_value_base2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*0.999))')
                        zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
                     else
                        subplot(2,1,2); surf(var_value_base1+(delta1*([1:size(results(:,:,i),1)]-1)),var_value_base2+(delta2*([1:size(results(:,:,i),2)]-1)),(results(:,:,i)+((results(:,:,i)==0)*init(i)*1.001))')
                        zlabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
                     end
                     ylabel(strrep(var_name2,'_','\_'))
                     xlabel(strrep(var_name1,'_','\_'))
                     title([strrep(var_name1,'_','\_'),' vs. ',strrep(var_name2,'_','\_'),' - Constraint'])
                  end
               end
            end
         end
         cs_plot('update')
         drawnow
      end
   end
   
   [co_min_index1, co_min_index2]=find(results(:,:,1)==min(min(results(:,:,1))));
   [hc_min_index1, hc_min_index2]=find(results(:,:,2)==min(min(results(:,:,2))));
   [nox_min_index1, nox_min_index2]=find(results(:,:,3)==min(min(results(:,:,3))));
   [pm_min_index1, pm_min_index2]=find(results(:,:,4)==min(min(results(:,:,4))));
   [mpgge_max_index1, mpgge_max_index2]=find(results(:,:,5)==max(max(results(:,:,5))));
   
   mpgge_max_index1=min(mpgge_max_index1);
   mpgge_max_index2=min(mpgge_max_index2);
   hc_min_index1=min(hc_min_index1);      
   hc_min_index2=min(hc_min_index2);
   co_min_index1=min(co_min_index1);
   co_min_index2=min(co_min_index2);
   nox_min_index1=min(nox_min_index1);
   nox_min_index2=min(nox_min_index2);
   pm_min_index1=min(pm_min_index1);
   pm_min_index2=min(pm_min_index2);
   
   obj=zeros(size(results(:,:,1)));
   for i=1:length(params.obj.active)
      if params.obj.active(i)
         if i==5
            obj=obj+init(i)./results(:,:,i)*params.obj.weight(i);
         else
            obj=obj+results(:,:,i)/init(i)*params.obj.weight(i);
         end
      end
   end
   obj=obj/(sum(params.obj.active.*params.obj.weight));
   eval(['obj2_',var_name1,'_',var_name2,'=obj;'])
   eval(['con2_',var_name1,'_',var_name2,'=con_log2;'])
   for x=1:size(con_log2,1)
      for y=1:size(con_log2,2)
         if con_log2(x,y)>0
            obj(x,y)=1000;
         end
      end
   end
   
   [obj_min_index1, obj_min_index2]=find(obj(:,:,1)==min(min(obj(:,:,1))));
   obj_min_index1=min(obj_min_index1);
   obj_min_index2=min(obj_min_index2);
   
   if obj(obj_min_index1, obj_min_index2)<old_obj(old_obj_min_index1, old_obj_min_index2)
      var_value1=lower_bound1+old_delta1*(old_obj_min_index1-1);
      var_value2=lower_bound2+old_delta2*(old_obj_min_index2-1);
   else
      var_value1=var_value_base1+delta1*(obj_min_index1-1);
      var_value2=var_value_base2+delta2*(obj_min_index2-1);
   end
   
else
   var_value1=lower_bound1+delta1*(obj_min_index1-1);
   var_value2=lower_bound2+delta2*(obj_min_index2-1);
   eval(['obj2_',var_name1,'_',var_name2,'=[];'])
   eval(['con2_',var_name1,'_',var_name2,'=[];'])
   eval(['dv2_',var_name1,'=[];'])
   eval(['dv2_',var_name2,'=[];'])
end

assignin('base',var_name1,var_value1);
assignin('base',var_name2,var_value2);

assignin('caller',var_name1,var_value1);
assignin('caller',var_name2,var_value2);

counter=counter+1;
[co, hc, nox, pm, fe, con]=run_test;
results_log=[results_log; co hc nox pm fe];
con_log=[con_log; con];

index=1;
for i=1:length(params.dv.active)
   if params.dv.active(i)
      val(index)=evalin('base',params.dv.name{i});
      index=index+1;
   end
end
dv_log=[dv_log; val];

obj=0;
for i=1:length(params.obj.active)
   if params.obj.active(i)
      if i==5
         obj=obj+init(i)./results_log(end,i)*params.obj.weight(i);
      else
         obj=obj+results_log(end,i)/init(i)*params.obj.weight(i);
      end
   end
end
obj=obj/(sum(params.obj.active.*params.obj.weight));
obj_log=[obj_log; obj];

if display
   for i=i:length(params.obj.active)
      if params.obj.active(i)
         figure(evalin('caller',['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],init(i)./(results_log(:,i)+eps)+((results_log(:,i)==0)*0.999),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},'/',labels{1},''])
         else
            plot([1:counter],results_log(:,i)/init(i)+((results_log(:,i)==0)*1.001),'rx-',[1:counter],ones(1,counter),'b--')
            ylabel(['Normalized ',strrep(upper(params.obj.name{i}),'_','\_'),' (',labels{2},')/(',labels{2},')'])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Objective')
      elseif params.con.value(i)>0
         figure(evalin('caller',['h_',params.obj.name{i},'_fig']))
         if i==5
            plot([1:counter],results_log(:,i)+((results_log(:,i)==0)*init(i)*0.999),'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{1},''])
         else
            plot([1:counter],results_log(:,i)+((results_log(:,i)==0)*init(i)*1.001),'rx-',[1:counter],params.con.value(i)*ones(1,counter),'b--')
            ylabel([strrep(upper(params.obj.name{i}),'_','\_'),' ',labels{2},''])
         end
         xlabel('Design Iteration')
         title('Control Strategy Optimization - Constraint')
      end
   end
end

assignin('base','results_log',results_log)
assignin('base','dv_log',dv_log)
assignin('base','obj_log',obj_log)
assignin('base',['dv1_',var_name1],eval(['dv1_',var_name1]))
assignin('base',['dv1_',var_name2],eval(['dv1_',var_name2]))
assignin('base',['obj1_',var_name1,'_',var_name2],eval(['obj1_',var_name1,'_',var_name2]))
assignin('base',['con1_',var_name1,'_',var_name2],eval(['con1_',var_name1,'_',var_name2]))
assignin('base',['dv2_',var_name1],eval(['dv2_',var_name1]))
assignin('base',['dv2_',var_name2],eval(['dv2_',var_name2]))
assignin('base',['obj2_',var_name1,'_',var_name2],eval(['obj2_',var_name1,'_',var_name2]))
assignin('base',['con2_',var_name1,'_',var_name2],eval(['con2_',var_name1,'_',var_name2]))
cs_plot('update')
drawnow

assignin('caller','results_log',results_log)
assignin('caller','dv_log',dv_log)
assignin('caller','obj_log',obj_log)
assignin('caller','con_log',con_log)
assignin('caller','counter',counter)
assignin('caller','num_calls',num_calls)

return

