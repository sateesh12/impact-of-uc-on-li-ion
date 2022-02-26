function error_code=vdoc_cs_opt_post(name)
% scan the optimization output files for new values and update the workspace

% make vinf global and define drivetrain switch
global vinf
drivetrain=vinf.drivetrain.name;

% print parameter for debugging
debug=0; % 1==> writes additional output to command window, 0==> no debug printing

% initialize error code flag
error_code=0;

if evalin('base',['exist(''',name,'_OPT.out'')'])
   fid=fopen([name,'_OPT.out'],'r');
   if fid>0
      % scan results file for variable updates
      while ~feof(fid)&~error_code
         str=fgetl(fid);
         best_results=findstr(str,'RESULTS')&findstr(str,'OPTIMIZATION'); % results and optimization are keywords indicating the correct section to parse updates
         error_msg=findstr(str,'TERMINATED')&findstr(str,'ERROR'); % disaster and error are keywords signaling execution problems
         calls=findstr(str,'EVALUATE')&findstr(str,'FUNCTIONS'); % evaluate and functions are keywords indicating the correct section to parse updates
         obj_func=findstr(str,'OBJECTIVE')&findstr(str,'MINIMIZATION'); % objective and functions are keywords indicating the correct section to parse updates
         if error_msg
            error_code=1
         elseif best_results
            found=0;
            while found<sum(vinf.control_strategy.dv.active)
               str=fgetl(fid);
               for i=1:length(vinf.control_strategy.dv.name)
                  if findstr(str, ['CS',num2str(i)])
                     eval([vinf.control_strategy.dv.name{i},'=',str(44:60),';'])
                     found=found+1;
                     break % for loop - no need to check for other variables in the same line
                  end
               end
            end
         elseif obj_func
            obj_value=str2num(str(findstr(str,'OBJECTIVE')+length('objective function for minimization ='):end));
         elseif calls
            num_calls=str2num(str(48:end));
            num_calls=evalin('caller','num_calls')+num_calls;
            assignin('caller','num_calls',num_calls)
         end
      end % while ~feof...
      fclose(fid);
      
      evalin('base','load(''VDOC_CS_OUT'')')
      
      if obj_value<1&~error_code
         
         % assign values in workspace
         for i=1:length(vinf.control_strategy.dv.name)
            if exist(vinf.control_strategy.dv.name{i})
               assignin('base',vinf.control_strategy.dv.name{i},eval(vinf.control_strategy.dv.name{i}))
            end
         end
         
         
         % display results   
         disp(' ')
         disp('*****************************************************')
         disp('*** Control Strategy Optimization Results Summary ***')
         disp('*****************************************************')
         disp(' ')
         
         for i=1:length(vinf.control_strategy.dv.name)
            if vinf.control_strategy.dv.active(i)
               disp([vinf.control_strategy.dv.name{i},' ==> ',num2str(evalin('base',vinf.control_strategy.dv.name{i})),' ',vinf.control_strategy.dv.units{i}])
            end
         end
         disp(' ')
         
         results_log=evalin('base','results_log');
         init=results_log(1,:);
         
         if strcmp(vinf.units,'metric');
            labels={'l/100km','g/km'};
         else
            labels={'mpgge','g/mi'};
         end
         
         disp(' ')
         if strcmp(vinf.units,'metric')
            disp(['Fuel economy changed by ', num2str(round((results_log(end,5)-init(5))/init(5)*100*10)/10),'% from ',num2str(round(1/(init(5)*units('mpg2kmpl')*100)*10)/10),' ',labels{1},' to ',num2str(round(1/(results_log(end,5)*units('mpg2kmpl')*100)*10)/10),' ',labels{1},'!'])
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
         
         % update values in gui and editted variable list
         if ~isempty(findobj('tag','execute_figure'))
            %update modified variables list
            autosize_run_status=vinf.autosize_run_status; % store flag - gui_edit_var will set to zero!
            for i=1:length(vinf.control_strategy.dv.name)
               if vinf.control_strategy.dv.active(i)
                  temp=evalin('base',vinf.control_strategy.dv.name{i});
                  if temp~=vinf.control_strategy.dv.init_cond(i)
                     assignin('base',vinf.control_strategy.dv.name{i},vinf.control_strategy.dv.init_cond(i))
                     gui_edit_var('modify',vinf.control_strategy.dv.name{i},num2str(temp))
                  end
               end
            end
            vinf.autosize_run_status=autosize_run_status; % restore flag 
         end
         
      else
         disp(' ')
         disp('Unable to improve control strategy. Restoring original configuration now.')
         disp(' ')
         
         % update values in gui and editted variable list
         if ~isempty(findobj('tag','execute_figure'))
            %update modified variables list
            autosize_run_status=vinf.autosize_run_status; % store flag - gui_edit_var will set to zero!
            for i=1:length(vinf.control_strategy.dv.name)
               if vinf.control_strategy.dv.active(i)
                  %temp=evalin('base',vinf.control_strategy.dv.name{i});
                  %if temp~=vinf.control_strategy.dv.init_cond(i)
                     %assignin('base',vinf.control_strategy.dv.name{i},vinf.control_strategy.dv.init_cond(i))
                     gui_edit_var('modify',vinf.control_strategy.dv.name{i},num2str(vinf.control_strategy.dv.init_cond(i)))
                  %end
               end
            end
            vinf.autosize_run_status=autosize_run_status; % restore flag 
         end

      end
      
      cs_plot('initialize')
      cs_plot('update')
      cs_plot('end_opt')
      
   else
      disp(['Unable to open file ', name,'.out'])
      error_code=1;
   end
   
else
   disp(['Unable to find file ', name,'.out'])
   error_code=1;
end

return

% revision notes
% 8/18/00:tm added num2str( to prevent error when using gui_edit_var to return workspace to original state


