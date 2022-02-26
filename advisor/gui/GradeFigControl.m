function GradeFigControl(option)


global vinf

if nargin<1
   option='load';
end

radiobutton_tags={
   'disable_none',...
      'disable_ess',...
      'disable_fc',...
      'curnt_mass',...
      'override_mass',...
      'add_mass'};

editbox_tags={'grade',...
      'speed',...
      'duration',...
      'gear_num',...
      'ess_init_soc',...
      'ess_min_soc',...
      'override_mass',...
      'add_mass',...
      'grade_lb',...
      'grade_ub',...
      'grade_init_step',...
      'speed_tol',...
      'grade_tol',...
      'max_iter',...
      'disp_status'};

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

switch option
   
case 'load'
   % configure workspace and open GUI
   
   % load defaults if no parameters defined
   if ~isfield(vinf,'grade_test')
      GradeFigControl('defaults')
   end
   
   if isempty(findobj('tag','grade_test_fig'))
      % open gui
      gradefig
   end
   set(findobj('tag','grade_test_fig'),'windowstyle','modal')
   
   GradeFigControl('initialize')
   
   GradeFigControl('radiobuttonevent')
   
   GradeFigControl('checkboxevent')
   
   h0=gcf;
   %center the figure on the screen
   set(h0,'units','pixels');
   position=get(h0,'position');
   screensize=get(0,'screensize');
   set(h0,'position', [(screensize(3)-position(3))/2  (screensize(4)-position(4))/2 ...
         position(3) position(4)])
   set(h0,'visible','on')
   set(h0,'windowstyle','modal')
   
case 'run'
   % run the test
   
   % check input data
   error_code=check_inputs;
   
   if ~error_code % if no errors
      
      % save current inputs and build command str
      str=[];
      for i=1:length(checkbox_tags)
         vinf.grade_test.param.active(i)=get(findobj('tag',[checkbox_tags{i},'_checkbox']),'value');
         eval(['vinf.grade_test.param.',checkbox_tags{i},'=',get(findobj('tag',[checkbox_tags{i},'_editbox']),'string'),';']);
         if get(findobj('tag',[checkbox_tags{i},'_checkbox']),'value')
            str=[str,'''',checkbox_tags{i},''',',get(findobj('tag',[checkbox_tags{i},'_editbox']),'string'),','];
         end
      end
      
      offset=i;
      for i=1:length(radiobutton_tags)
         vinf.grade_test.param.active(i+offset)=get(findobj('tag',[radiobutton_tags{i},'_radiobutton']),'value');
      end

      if get(findobj('tag',[radiobutton_tags{2},'_radiobutton']),'value')
         vinf.grade_test.param.disable_systems=1;
      elseif get(findobj('tag',[radiobutton_tags{3},'_radiobutton']),'value')
         vinf.grade_test.param.disable_systems=2;
      else
         vinf.grade_test.param.disable_systems=0;
      end
      if vinf.grade_test.param.disable_systems
         str=[str,'''disable_systems'',',num2str(vinf.grade_test.param.disable_systems),','];
      end
      
      vinf.grade_test.param.override_mass=str2num(get(findobj('tag',[editbox_tags{7},'_editbox']),'string'));
      vinf.grade_test.param.add_mass=str2num(get(findobj('tag',[editbox_tags{8},'_editbox']),'string'));
      
      if get(findobj('tag',[radiobutton_tags{5},'_radiobutton']),'value')
         str=[str,'''override_mass'',',num2str(vinf.grade_test.param.override_mass),','];
      elseif get(findobj('tag',[radiobutton_tags{6},'_radiobutton']),'value')
         str=[str,'''add_mass'',',num2str(vinf.grade_test.param.add_mass),','];
      end
      
      if ~isempty(str)
         str=str(1:end-1);
         str=['[vinf.grade_test.results.grade vinf.grade_test.results.gear]=grade_test_advanced(',str,');'];
      else
         str=['[vinf.grade_test.results.grade vinf.grade_test.results.gear]=grade_test_advanced;'];
      end
      
      % close the GUI
      close(findobj('tag','grade_test_fig'));
      
      % clear any previous results
      if isfield(vinf.grade_test,'results')
         vinf.grade_test=rmfield(vinf.grade_test,'results');
      end
      
      if isempty(findobj('tag','execute_figure'))&isempty(findobj('tag','input_figure'))&(isfield(vinf,'test')&strcmp(vinf.test.run,'on'))
         % run grade test
         eval(str)
         
         % process results
         evalin('base','gui_post_process')
         
         % open results fig
         if ~isfield(vinf,'run_without_gui')
            ResultsFig
         end
      end
   end
   
case 'cancel'
   close(findobj('tag','grade_test_fig'));
   if isempty(findobj('tag','execute_figure'))&isempty(findobj('tag','input_figure'))
      SimSetupFig
   end
   
case 'help'
   load_in_browser('grade_test_help.html');
   
case 'initialize'
   for i=1:length(checkbox_tags)
      set(findobj('tag',[checkbox_tags{i},'_checkbox']),'value',vinf.grade_test.param.active(i));
      set(findobj('tag',[checkbox_tags{i},'_editbox']),'string',num2str(eval(['vinf.grade_test.param.',checkbox_tags{i}])));
   end
   
   offset=i;
   for i=1:length(radiobutton_tags)
      set(findobj('tag',[radiobutton_tags{i},'_radiobutton']),'value',vinf.grade_test.param.active(i+offset));
   end
   
   set(findobj('tag','curnt_mass_textbox'),'string',num2str(evalin('base','veh_mass')));
   set(findobj('tag','override_mass_editbox'),'string',num2str(vinf.grade_test.param.override_mass));
   set(findobj('tag','add_mass_editbox'),'string',num2str(vinf.grade_test.param.add_mass));
   
   if ~isempty(findobj('tag','input_figure'))
      set(findobj('tag','grade_checkbox'),'value',1)
      set(findobj('tag','speed_checkbox'),'value',1)
      GradeFigControl('checkboxevent')
   end
   
   
case 'defaults'
   % load appropriate default information
   
   % clear the param field if it exists
   if isfield(vinf,'grade_test')
      vinf.grade_test=rmfield(vinf.grade_test,'param');
      % clear the results field if it exists
      if isfield(vinf.grade_test,'results')
         vinf.grade_test=rmfield(vinf.grade_test,'results');
      end
   end
   
   % assign default values
   vinf.grade_test.param.active=[0 1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0];
   vinf.grade_test.param.grade=[6];
   vinf.grade_test.param.speed=[55];
   vinf.grade_test.param.duration=[10];
   vinf.grade_test.param.gear_num=[1];
   vinf.grade_test.param.ess_init_soc=[0.5];
   vinf.grade_test.param.ess_min_soc=[0.5];
   vinf.grade_test.param.grade_lb=[0];
   vinf.grade_test.param.grade_ub=[10];
   vinf.grade_test.param.grade_init_step=[1];
   vinf.grade_test.param.grade_tol=[0.05];
   vinf.grade_test.param.speed_tol=[0.01];
   vinf.grade_test.param.max_iter=[25];
   vinf.grade_test.param.disp_status=[0];
   vinf.grade_test.param.disable_systems=1;
   vinf.grade_test.param.override_mass=[evalin('base','veh_mass')];
   vinf.grade_test.param.add_mass=[0];
   
   if isfield(vinf,'energy_storage')
       if evalin('base','exist(''cs_lo_soc'')')         
           vinf.grade_test.param.ess_init_soc=evalin('base','mean([cs_lo_soc cs_hi_soc])');
           vinf.grade_test.param.ess_min_soc=evalin('base','cs_lo_soc');
       else
           vinf.grade_test.param.ess_init_soc=1; % start at fully charged
           vinf.grade_test.param.ess_min_soc=0; % don't go below fully discharged
       end
   else
       vinf.grade_test.param.active(5)=0;
       vinf.grade_test.param.active(6)=0;
   end

   GradeFigControl('load')
   
   case 'PNGV defaults'
   % load appropriate default information
   
   % clear the param field if it exists
   if isfield(vinf,'grade_test')
      vinf.grade_test=rmfield(vinf.grade_test,'param');
      % clear the results field if it exists
      if isfield(vinf.grade_test,'results')
         vinf.grade_test=rmfield(vinf.grade_test,'results');
      end
   end
   
   % assign default values
   vinf.grade_test.param.active=[0 1 1 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1];
   vinf.grade_test.param.grade=[6.5];
   vinf.grade_test.param.speed=[55];
   vinf.grade_test.param.duration=[1200];
   vinf.grade_test.param.gear_num=[1];
   vinf.grade_test.param.ess_init_soc=[0.5];
   vinf.grade_test.param.ess_min_soc=[0.5];
   vinf.grade_test.param.grade_lb=[0];
   vinf.grade_test.param.grade_ub=[10];
   vinf.grade_test.param.grade_init_step=[1];
   vinf.grade_test.param.grade_tol=[0.05];
   vinf.grade_test.param.speed_tol=[0.01];
   vinf.grade_test.param.max_iter=[25];
   vinf.grade_test.param.disp_status=[0];
   vinf.grade_test.param.disable_systems=0;
   vinf.grade_test.param.override_mass=[evalin('base','veh_mass')];
   vinf.grade_test.param.add_mass=[272];
   
   if isfield(vinf,'energy_storage')
       if evalin('base','exist(''cs_lo_soc'')')         
           vinf.grade_test.param.ess_init_soc=evalin('base','mean([cs_lo_soc cs_hi_soc])');
           vinf.grade_test.param.ess_min_soc=evalin('base','cs_lo_soc');
       else
           vinf.grade_test.param.ess_init_soc=1; % start at fully charged
           vinf.grade_test.param.ess_min_soc=0; % don't go below fully discharged
       end
   else
       vinf.grade_test.param.active(5)=0;
       vinf.grade_test.param.active(6)=0;
   end

   GradeFigControl('load')

case 'checkboxevent'
   
   % special cases
   % disable SOC inputs for conventional vehicles
   if strcmp(vinf.drivetrain.name,'conventional')
      set(findobj('tag',[checkbox_tags{5},'_checkbox']),'value',0)
      set(findobj('tag',[checkbox_tags{6},'_checkbox']),'value',0)
   end
   
   % disable gear number inputs for prius
   if strcmp(vinf.drivetrain.name,'prius_jpn')
      set(findobj('tag',[checkbox_tags{4},'_checkbox']),'value',0)
   end
   
   % disable gear number inputs for cvt vehicles
   if evalin('base','exist(''gb_map_trq_out'')')
      set(findobj('tag',[checkbox_tags{4},'_checkbox']),'value',0)
   end
   
   % enable and disable appropriate editboxes when the associate checkbox is selected
   for i=1:length(checkbox_tags)
      if get(findobj('tag',[checkbox_tags{i},'_checkbox']),'value')
         set(findobj('tag',[checkbox_tags{i},'_editbox']),'enable','on')
      else
         set(findobj('tag',[checkbox_tags{i},'_editbox']),'enable','off')
      end
   end
   
case 'radiobuttonevent'
   
   % special cases
   % disable system disables for conventional and evs vehicles
   if strcmp(vinf.drivetrain.name,'conventional')|strcmp(vinf.drivetrain.name,'ev')
      set(findobj('tag',[radiobutton_tags{1},'_radiobutton']),'enable','off')
      set(findobj('tag',[radiobutton_tags{2},'_radiobutton']),'enable','off')
      set(findobj('tag',[radiobutton_tags{3},'_radiobutton']),'enable','off')
      
      set(findobj('tag',[radiobutton_tags{1},'_radiobutton']),'value',1)
      set(findobj('tag',[radiobutton_tags{2},'_radiobutton']),'value',0)
      set(findobj('tag',[radiobutton_tags{3},'_radiobutton']),'value',0)
   end
   
   % enable/disable SOC checkboxes and editboxes based on radiobutton settings
   if get(findobj('tag',[radiobutton_tags{2},'_radiobutton']),'value')
      set(findobj('tag',[editbox_tags{5},'_editbox']),'enable','off')
      set(findobj('tag',[editbox_tags{6},'_editbox']),'enable','off')
      set(findobj('tag',[checkbox_tags{5},'_checkbox']),'value',0)
      set(findobj('tag',[checkbox_tags{6},'_checkbox']),'value',0)
      set(findobj('tag',[checkbox_tags{5},'_checkbox']),'enable','off')
      set(findobj('tag',[checkbox_tags{6},'_checkbox']),'enable','off')
   else
      set(findobj('tag',[editbox_tags{5},'_editbox']),'enable','on')
      set(findobj('tag',[editbox_tags{6},'_editbox']),'enable','on')
         set(findobj('tag',[checkbox_tags{5},'_checkbox']),'enable','on')
      set(findobj('tag',[checkbox_tags{6},'_checkbox']),'enable','on')
end
   
   if get(findobj('tag',[radiobutton_tags{5},'_radiobutton']),'value')
      set(findobj('tag',[editbox_tags{7},'_editbox']),'enable','on')
   else
      set(findobj('tag',[editbox_tags{7},'_editbox']),'enable','off')
   end
   
   if get(findobj('tag',[radiobutton_tags{6},'_radiobutton']),'value')
      set(findobj('tag',[editbox_tags{8},'_editbox']),'enable','on')
   else
      set(findobj('tag',[editbox_tags{8},'_editbox']),'enable','off')
   end
      
otherwise
   
   disp('Invalid case') 
   
end

% END Main program

% Subfunction Section
function error_code=check_inputs

% initialize error flag
error_code=0;

% add statements to check for valid inputs

return
% END Subfunction Section

% Revision History
% 7/14/00 ss created.
% 8/10/00 ss centered figure on screen based on screen resolution.
% 8/14/00:tm changed order of parameter names in param_name array to match gui
% 8/14/00:tm default gear number set to 1
% 8/14/00:tm added statements to disable certain inputs based on vehicle config "special cases"
% 8/14/00:tm added else case to if str is empty to handle case when no inputs selected
% 8/14/00:tm added conditional statements to only run if execute figure has been killed - called from run button not options button
% 8/21/00:tm in case 'cancel' added conditional to only load execute figure if it doesn't already exist
% 8/21/00:tm in case 'load' added statement to set window style to 'modal'
% 1/23/01:tm added & isempty(findobj('tag','input_figure' to prevent running grade test on OK from input figure so that gui can be used with autosize
% 1/24/01:tm deleted param_names cell array and replaced with checkbox_tags, radiobutton_tags, and editbox_tags cell arrays
% 1/24/01:tm updated defaults to include new parameter options
% 1/24/01:tm updated save parameter settings and build str for new parameter options
% 1/24/01:tm added new case to handle initialization
% % 1/25/01:tm added isempty('input_figure in cancel case to prevent opening simsetupfig
% 1/29/01:tm added additional conditions to running test from here and opening results fig from here
% 1/29/01:tm fixed error associated with saving radiobutton settings
% 1/29/01:tm fixed settings for conv and evs
% 2/2/01: ss updated prius to prius_jpn
% 10/18/01:mpo added dialogue box to help users with custom drivetrains to use accel feature
% 2/15/02: ss replaced ResultsFigControl with ResultsFig
% 041802:tm removed dialog box for custom drivetrains added by mpo and revised conditional to be based on active fields also added
% conditional to set defaults depending on whether cs_lo_soc exists or not
% 8/28/03:ss & tm removed close figure requests when the defaults or pngv
% buttons were pushed.  Unneccessary and caused problems with autosize and
% 'run'.
