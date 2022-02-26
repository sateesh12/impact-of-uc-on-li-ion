function vdoc_as_post(name)
% scan the optimization output files for new values and update the workspace

% make vinf global and define drivetrain switch
global vinf
drivetrain=vinf.drivetrain.name;

% print parameter for debugging
debug=0; % 1==> writes additional output to command window, 0==> no debug printing

if evalin('base',['exist(''',name,'_OPT.out'')'])
   
   fid=fopen([name,'_OPT.out'],'r');
   
   % scan results file for variable updates
   while ~feof(fid)
      str=fgetl(fid);
      if 0%vinf.autosize.dv(2)
         best_results=findstr(str,'RESULTS')&findstr(str,'DISCRETE')&findstr(str,'OPTIMIZATION'); % results and optimization are keywords indicating the correct section to parse updates
      else
         best_results=findstr(str,'RESULTS')&findstr(str,'APPROXIMATE')&findstr(str,'OPTIMIZATION'); % results and optimization are keywords indicating the correct section to parse updates
      end
      if best_results
         loop=1;
         while loop
            str=fgetl(fid);
            if findstr(str, 'ESSMN')
               ess_module_num=str2num(str(44:60));
            elseif findstr(str, 'FCTS')
               fc_trq_scale=str2num(str(44:60));
            elseif findstr(str, 'MCTS')
               mc_trq_scale=str2num(str(44:60));
            end;
            if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3) % both fc and ess are design variables
               if exist('fc_trq_scale')&exist('ess_module_num')&exist('mc_trq_scale') % both variables have been found
                  loop=0;
               end;
            elseif vinf.autosize.dv(1)&vinf.autosize.dv(3) % both fc and ess are design variables
               if exist('fc_trq_scale')&exist('mc_trq_scale') % both variables have been found
                  loop=0;
               end;
            elseif vinf.autosize.dv(2)&vinf.autosize.dv(3) % both fc and ess are design variables
               if exist('mc_trq_scale')&exist('ess_module_num') % both variables have been found
                  loop=0;
               end;
            elseif vinf.autosize.dv(1)&vinf.autosize.dv(2) % both fc and ess are design variables
               if exist('fc_trq_scale')&exist('ess_module_num') % both variables have been found
                  loop=0;
               end;
            elseif vinf.autosize.dv(1)==1 % only fc is a design variable
               if exist('fc_trq_scale')
                  loop=0;
               end;
            elseif vinf.autosize.dv(2)==1 % only ess is a design variable
               if exist('ess_module_num')
                  loop=0;
               end;
            elseif vinf.autosize.dv(3)==1 % only ess is a design variable
               if exist('mc_trq_scale')
                  loop=0;
               end;
            end;
         end;
      end;
   end;
   
   % update the workspace
   if exist('fc_trq_scale')
      assignin('base','fc_trq_scale',round(fc_trq_scale*1000)/1000)
   end;
   if exist('ess_module_num')
      %assignin('base','ess_module_num',ceil(ess_module_num))
      assignin('base','ess_module_num',round(ess_module_num))
   end;
   if exist('mc_trq_scale')
      assignin('base','mc_trq_scale',round(mc_trq_scale*1000)/1000)
   end;
end;

% set fuelcell flag
if strcmp(drivetrain,'fuel_cell')
   fuelcell=1;
else
   fuelcell=0;
end;

% default lower bounds
gc_lb=0.2;
mc_lb=0.2;

% default upper bounds
gc_ub=20.0;
mc_ub=20.0;

% default flags
fd_ratio_changed=0;
mc_overtrq_factor_changed=0;

if strcmp(drivetrain,'series')|strcmp(drivetrain,'fuel_cell')
   if ~fuelcell
      % match gc spd to that of the fc 
      assignin('base','gc_spd_scale',round(evalin('base','max(fc_map_spd*fc_spd_scale)/max(gc_map_spd)')*1000)/1000);
      
      % match gc trq range to that of the fc
      match_gc_to_fc(gc_lb,gc_ub);
   end
   
   % run PTC file
   evalin('base','adjust_cs')
   
   if ~vinf.autosize.dv(3)
      % adjust mc_trq_scale to match fc 
      match_mc_to_fc(mc_lb,mc_ub);
      
      % adjust mc_trq_scale to match ess
      match_mc_to_ess(max(evalin('base','mc_trq_scale'),mc_lb),mc_ub)
   end
   
end

if strcmp(drivetrain,'parallel')|strcmp(drivetrain,'ev')
   if ~vinf.autosize.dv(3)
      % adjust mc_trq_scale to match ess
      match_mc_to_ess(mc_lb,mc_ub)
   end
   
   % run PTC file
   evalin('base','adjust_cs')

end

if 0%vinf.autosize.dv(3)
   mc_overtrq_factor=evalin('base','mc_overtrq_factor');
   assignin('base','mc_overtrq_factor',1)
   if evalin('base','mc_overtrq_factor')~=mc_overtrq_factor
      mc_overtrq_factor_changed=1;
   end
end

% adjust final drive ratio to allow max speed of max_spd mph with current 
fd_ratio=evalin('base','fd_ratio');
adjust_fd(vinf.autosize.con.max_spd);
if evalin('base','fd_ratio')~=fd_ratio
   fd_ratio_changed=1;
end

% recompute component and vehicle masses
recompute_mass

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
   if ~strcmp(drivetrain,'conventional')
      set(findobj('tag','ess_num_modules'),'string',num2str(evalin('base','ess_module_num')));
      gui_edit_var('ess_num_modules')
   end
   if fd_ratio_changed
      new_fd_ratio=evalin('base','fd_ratio');
      assignin('base','fd_ratio',fd_ratio)
      gui_edit_var('modify','fd_ratio',num2str(new_fd_ratio))
   end
   if 0%mc_overtrq_factor_changed
      new_mc_overtrq_factor=evalin('base','mc_overtrq_factor');
      assignin('base','mc_overtrq_factor',mc_overtrq_factor)
      gui_edit_var('modify','mc_overtrq_factor',num2str(new_mc_overtrq_factor))
   end
end

% debug print statements
if debug
   disp(' ')
   disp('After GUI updates:')
   if evalin('base','exist(''fc_trq_scale'')')
      disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
   end
   if evalin('base','exist(''gc_trq_scale'')')
      disp(['gc_trq_scale = ',evalin('base','num2str(gc_trq_scale)')])
      disp(['gc_spd_scale = ',evalin('base','num2str(gc_spd_scale)')])
   end
   if evalin('base','exist(''mc_trq_scale'')')
      disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
   end
   if evalin('base','exist(''ess_module_num'')')
      disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
   end
   disp(['fd_ratio = ',evalin('base','num2str(fd_ratio)')])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('********************************')
disp('*** Autosize Results Summary ***')
disp('********************************')
disp(' ')

if ~strcmp(drivetrain,'ev')
   disp(['Fuel converter ==> ', num2str(evalin('base',...
         'round(calc_max_pwr(''fuel_converter''))')), ' kW'])
end
if evalin('base','exist(''gc_trq_scale'')')
   if ~fuelcell
      disp(['Generator/controller ==> ', num2str(evalin('base',...
            'round(max(gc_map_spd.*gc_max_trq)*gc_trq_scale*gc_spd_scale/1000)')), ' kW'])
   end
end
if evalin('base','exist(''mc_trq_scale'')')
   disp(['Motor/controller ==> ', num2str(evalin('base',...
         'round(max(mc_map_spd.*mc_max_trq)*mc_trq_scale*mc_spd_scale/1000)')), ' kW'])
end
if evalin('base','exist(''ess_module_num'')')
   disp(['Energy storage system number of modules ==> ', num2str(evalin('base','ess_module_num'))])
end
if fd_ratio_changed
   max_spd=vinf.autosize.con.max_spd;
   disp(['Final drive ratio ==> ',num2str(evalin('base','fd_ratio')),' to allow max speed of ',num2str(max_spd),' mph.'])
end
if 0%mc_overtrq_factor_changed
   disp(['Motor overtorque factor ==> ',num2str(evalin('base','mc_overtrq_factor')),' for nameplate motor sizing.'])
end

% update vehicle mass if override mass case
check_if_override_mass
disp(['Total vehicle mass ==> ', num2str(evalin('base','veh_mass')), ' kg.'])
disp(' ')

% debug print statements
if debug
   disp(' ')
   disp('After Simulation:')
   if evalin('base','exist(''fc_trq_scale'')')
      disp(['fc_trq_scale = ',evalin('base','num2str(fc_trq_scale)')])
   end
   if evalin('base','exist(''gc_trq_scale'')')
      disp(['gc_trq_scale = ',evalin('base','num2str(gc_trq_scale)')])
      disp(['gc_spd_scale = ',evalin('base','num2str(gc_spd_scale)')])
   end
   if evalin('base','exist(''mc_trq_scale'')')
      disp(['mc_trq_scale = ',evalin('base','num2str(mc_trq_scale)')])
   end
   if evalin('base','exist(''ess_module_num'')')
      disp(['ess_module_num = ',evalin('base','num2str(ess_module_num)')])
   end
   disp(['fd_ratio = ',evalin('base','num2str(fd_ratio)')])
end

% plot optimization summary
evalin('base','load VDOC_AS_OUT')
figure
set(gcf,'NumberTitle','off','Name','VisualDOC Optimization Summary');
as_plot

% set status variable
vinf.autosize_run_status=1;

return


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SUBFUNCTION SECTION
%%%%%%%%%%%%%%%%%%%%%%%%%

function check_if_override_mass()
%ss 9/20/98-
%use override mass if defined 
%only use override mass if input figure is open
if ~isempty(findobj('tag','input_figure'));%sam added 9/17/98
   if get(findobj('tag','override_mass_checkbox'),'value')==1
      assignin('base','veh_mass',str2num(gui_current_str('override_mass_value')));
      %disp(['USING OVERRIDE MASS OF ',gui_current_str('override_mass_value'),' kg!!']);
   end
end%~isempty
return


% revision history
% 1/31/01:tm updated to work with dat file that sets up problem as a continous optimization rather than discrete
%