function autosize_setup(option)

%
% GUI interface to setup autosizing
%

global vinf

if nargin<1
   option='load';
end

switch option
   
case 'load'
   
   button=questdlg('This functionality has been greatly enhanced by using the adv_no_gui scripts combined with optimization tools.  Please refer to documentation (documentation/optimization_scripts.html) for more information.  Would you like to continue?','Control Strategy Optimization Updates','Yes','No','Help','No');
   if strcmp(button,'Help')
       load_in_browser('optimization_scripts.html');
       return
   elseif ~strcmp(button,'Yes')
       return
   end

   figure_color=[1 1 .8];
   
   screen=get(0,'screensize');
   posfig=[(screen(3)-400)/2 (screen(4)-550)/2 400 550]; 
   line_height=19;
   
   par_left=posfig(1);
   par_bottom=posfig(2);
   par_width=posfig(3);
   par_height=posfig(4);
   char_width=10;
   border=2*char_width;
   button_width=60;
   button_height=line_height+2;
   editbox_width=60;
   editbox_height=line_height;
   line_num=1;
   
   h0 = figure('Color',figure_color, ...
      'Position',posfig, ...
      'numbertitle','off',...
      'name','Autosize Configuration Window',...
      'windowstyle','modal');
   
   %set the targets to default values if not already set.
   eval('h=vinf.autosize.dv; test4exist=1;','test4exist=0;');
   clear h
   if ~test4exist%&~vinf.autosize_run_status
      autosize_setup('load_defaults')
   end
   
   
   if 0 % disabled 1/25/00:tm
      % reset values to default if they were turned off in previous runs
      if vinf.autosize.con.grade.goal.grade<0;
         vinf.autosize.con.grade.goal.mph=55;
         vinf.autosize.con.grade.goal.grade=6;
      end
   end
   
   % grab values of editted variables as default initial conditions
   eval('h=vinf.variables.name; test4exist=1;','test4exist=0;');
   if test4exist
      for x=1:length(vinf.variables.name)
         if strcmp(vinf.variables.name(x),'fc_trq_scale')
            vinf.autosize.cv.fc(1)=vinf.variables.value(x);
         end
         if strcmp(vinf.variables.name(x),'ess_module_num')
            vinf.autosize.cv.ess(1)=vinf.variables.value(x);
         end
         if strcmp(vinf.variables.name(x),'mc_trq_scale')
            vinf.autosize.cv.mc(1)=vinf.variables.value(x);
         end
      end
   end
   
   % create vector of candidate values for ess, mc, fc
   if ~strcmp(vinf.drivetrain.name,'conventional')
      vinf.autosize.cv.ess=round(vinf.autosize.cv.ess(1)*[1.0 0.75 1.5]);
      vinf.autosize.cv.mc=vinf.autosize.cv.mc(1)*[1.0 0.75 1.5];
   end
   if ~strcmp(vinf.drivetrain.name,'ev')
      vinf.autosize.cv.fc=vinf.autosize.cv.fc(1)*[1.0 0.75 1.5];
   end
   
   % Engine selection section title
   if par_height>400
      line_num=line_num+1;
   end
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Autosize Method Selection', ...
      'Fontweight','bold',...
      'Style','text');
   % Engine selection radio buttons
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''matlab'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width/2 line_height], ...
      'String','Autosize using Matlab',...
      'Style','radiobutton', ...
      'Tag','as_matlab',...
      'Value',vinf.autosize.matlab);
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''visdoc'')',...
      'BackgroundColor',figure_color, ...
      'Position',[par_width/2 par_height-line_num*line_height par_width/2 line_height], ...
      'String','Autosize using VisualDOC',...
      'Style','radiobutton', ...
      'Tag','as_visdoc',...
      'Value',~vinf.autosize.matlab);
   
   if par_height>400
      line_num=line_num+1;
   end
   
   
   % Constraints section title
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Constraints', ...
      'Fontweight','bold',...
      'Style','text');
   % Grade checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Callback','autosize_setup(''grade'')',...
      'Position',[border par_height-line_num*line_height par_width line_height], ...
      'String','Grade', ...
      'Style','checkbox', ...
      'Tag','grade_test_checkbox',...
      'Value',vinf.autosize.constraints(1));
   if 0 % disabled 1/24/01:tm
      % Goals header
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[border+10*char_width par_height-line_num*line_height 10*char_width line_height], ...
         'String','Goal', ...
         'Style','text');
      % Tolerances header
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[border+20*char_width par_height-line_num*line_height 10*char_width line_height], ...
         'String','Tolerance (+/-)', ...
         'Style','text');
      
      % Grade speed goal
      line_num=line_num+1;
      if strcmp(vinf.units,'metric')
         str='Speed(km/h)';
      else
         str='Speed(mph)';
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 10*char_width line_height], ...
         'String',str, ...
         'Style','text');
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+10*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(round(vinf.autosize.con.grade.goal.mph*units('mph2kmph')*10)/10),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_speed_goal');
      % Grade speed tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+20*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(round(vinf.autosize.con.grade.tol.mph*units('mph2kmph')*100)/100),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_speed_tol');
      % Grade grade goal
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 10*char_width line_height], ...
         'String','Grade(%)', ...
         'Style','text');
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+10*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.grade.goal.grade),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_grade_goal');
      % Grade grade tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+20*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.grade.tol.grade),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_grade_tol');
      
   else
      h1 = uicontrol('Parent',h0, ...
         'CallBack','gradefigcontrol',...
         'Position',[3*(par_width-4*button_width)/5+2*button_width par_height-line_num*line_height button_width*2 button_height], ...
         'String','Grade Options', ...
         'Tag','Grade_Pushbutton');
      
   end
   
   if par_height>400
      line_num=line_num+1;
   end
   
   % Accel checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Callback','autosize_setup(''accel'')',...
      'Position',[border par_height-line_num*line_height 15*char_width line_height], ...
      'String','Acceleration', ...
      'Style','checkbox', ...
      'Tag','accel_checkbox',...
      'Value',vinf.autosize.constraints(2));
   if 0 % disabled 1/24/01:tm
      % Goals header
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[border+15*char_width par_height-line_num*line_height 10*char_width line_height], ...
         'String','Goal', ...
         'Style','text');
      % Tolerances header
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[border+25*char_width par_height-line_num*line_height 10*char_width line_height], ...
         'String','Tolerance (+/-)', ...
         'Style','text');
      
      % 0-18 time
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'Callback','autosize_setup(''accel'')',...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 15*char_width line_height], ...
         'String','0-18mph (0-29km/h) (s)', ...
         'Style','checkbox', ...
         'value',vinf.autosize.con.accel.goal.t0_18>0, ...
         'Tag','accel_0_18_checkbox');
      if vinf.autosize.con.accel.goal.t0_18<0 
         vinf.autosize.con.accel.goal.t0_18=3.5;
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+15*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.goal.t0_18),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_18_goal');
      % 0-18 time tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+25*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.tol.t0_18),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_18_tol');
      
      % 0-30 time
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'Callback','autosize_setup(''accel'')',...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 15*char_width line_height], ...
         'String','0-30mph (0-48km/h) (s)', ...
         'Style','checkbox', ...
         'value',vinf.autosize.con.accel.goal.t0_30>0, ...
         'Tag','accel_0_30_checkbox');
      if vinf.autosize.con.accel.goal.t0_30<0 
         vinf.autosize.con.accel.goal.t0_30=10;
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+15*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.goal.t0_30),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_30_goal');
      % 0-30 time tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+25*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.tol.t0_30),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_30_tol');
      
      % 0-60 time
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'Callback','autosize_setup(''accel'')',...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 15*char_width line_height], ...
         'String','0-60mph (0-97km/h) (s)', ...
         'Style','checkbox', ...
         'value',vinf.autosize.con.accel.goal.t0_60>0, ...
         'Tag','accel_0_60_checkbox');
      if vinf.autosize.con.accel.goal.t0_60<0 
         vinf.autosize.con.accel.goal.t0_60=12.0;
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+15*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.goal.t0_60),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_60_goal');
      % 0-60 time tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+25*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.tol.t0_60),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_60_tol');
      
      % 40-60 time
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'Callback','autosize_setup(''accel'')',...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 15*char_width line_height], ...
         'String','40-60mph (64-97km/h) (s)', ...
         'Style','checkbox', ...
         'value',vinf.autosize.con.accel.goal.t40_60>0,...
         'Tag','accel_40_60_checkbox');
      if vinf.autosize.con.accel.goal.t40_60<0 
         vinf.autosize.con.accel.goal.t40_60=5.3;
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+15*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.goal.t40_60),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_40_60_goal');
      % 40-60 time tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+25*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.tol.t40_60),...
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_40_60_tol');
      
      % 0-85 time
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'Callback','autosize_setup(''accel'')',...
         'BackgroundColor',figure_color, ...
         'Position',[2*border par_height-line_num*line_height 15*char_width line_height], ...
         'String','0-85mph (0-137km/h) (s)', ...
         'Style','checkbox', ...
         'value',vinf.autosize.con.accel.goal.t0_85>0, ...
         'Tag','accel_0_85_checkbox');
      if vinf.autosize.con.accel.goal.t0_85<0 
         vinf.autosize.con.accel.goal.t0_85=23.4;
      end
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+15*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.goal.t0_85),...   
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_85_goal');
      % 0-85 time tol
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[2*border+25*char_width par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(vinf.autosize.con.accel.tol.t0_85),...   
         'Style','edit', ...
         'enable','on', ...
         'Tag','autosize_0_85_tol');
   else
      h1 = uicontrol('Parent',h0, ...
         'CallBack','AccelFigControl',...
         'Position',[3*(par_width-4*button_width)/5+2*button_width par_height-line_num*line_height button_width*2 button_height], ...
         'String','Accel Options', ...
         'Tag','Accel_Pushbutton');
      
   end
   
   if par_height>400
      line_num=line_num+1;
   end
   
   % Design variables section title
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Design Variables', ...
      'Fontweight','bold',...
      'Style','text');
   % variable name title
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height (par_width-2*border)/3 line_height], ...
      'String','Variable Name', ...
      'Fontweight','normal',...
      'Style','text');
   % initial value title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[(par_width-2*border)/2 par_height-line_num*line_height 6*char_width line_height], ...
      'String','Initial Value', ...
      'Fontweight','normal',...
      'Style','text');
   % lower bound title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[(par_width-2*border)/2+editbox_width+3 par_height-line_num*line_height 7*char_width line_height], ...
      'String','Lower Bound', ...
      'Fontweight','normal',...
      'Style','text');
   % upper bound title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[(par_width-2*border)/2+editbox_width*2+11 par_height-line_num*line_height 7*char_width line_height], ...
      'String','Upper Bound', ...
      'Fontweight','normal',...
      'Style','text');
   
   % Design variable - fuel converter checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''fuel_converter'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Fuel Converter (kW)', ...
      'Style','checkbox', ...
      'Tag','dv_fc_checkbox',...
      'enable','off', ...
      'Value',eval('~strcmp(vinf.drivetrain.name,''ev'')&vinf.autosize.dv(1)'));
   % Initial Value
   if ~strcmp(vinf.drivetrain.name,'ev')
      if evalin('base','exist(''fc_fuel_cell_model'')')
         if evalin('base','fc_fuel_cell_model')==1
            fc_pwr=evalin('base','max(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num)');
         elseif evalin('base','fc_fuel_cell_model')==2
            fc_pwr=evalin('base','max(fc_pwr_map)');
         elseif evalin('base','fc_fuel_cell_model')==3
            fc_pwr=vinf.gctool.dv.value(1);
         end
      else
         fc_pwr=evalin('base','max(fc_map_spd.*fc_max_trq)*fc_spd_scale');
      end
   else
      fc_pwr=0;
   end
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.fc(1)*fc_pwr/1000)),...
      'Style','edit', ...
      'enable','on', ...
      'Tag','cv_fc_1');
   % Candidate Value 1
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+editbox_width+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.fc(2)*fc_pwr/1000)),...
      'Style','edit', ...
      'enable','on', ...
      'Tag','cv_fc_2');
   % Candidate Value 2
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+2*editbox_width+8+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.fc(3)*fc_pwr/1000)),...
      'Style','edit', ...
      'enable','on', ...
      'Tag','cv_fc_3');
   
   % Design variable - energy storage system checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''energy_storage'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','ESS (# modules)', ...
      'Style','checkbox', ...
      'Tag','dv_ess_checkbox',...
      'enable','off', ...
      'Value',eval('~strcmp(vinf.drivetrain.name,''conventional'')&vinf.autosize.dv(2)'));
   % Initial value
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(vinf.autosize.cv.ess(1)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_ess_1');
   % Candidate Value 1
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+editbox_width+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(vinf.autosize.cv.ess(2)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_ess_2');
   % Candidate Value 2
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+2*editbox_width+8+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(vinf.autosize.cv.ess(3)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_ess_3');
   
   % Design Variable - Motor size checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''motor_controller'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Motor Size (kW)', ...
      'Style','checkbox', ...
      'Tag','dv_mc_checkbox',...
      'enable','on', ...
      'Value',eval('~strcmp(vinf.drivetrain.name,''conventional'')&vinf.autosize.dv(3)'));
   % Initial Value
   if ~strcmp(vinf.drivetrain.name,'conventional')
      mc_pwr=evalin('base','max(mc_map_spd.*mc_max_trq)*mc_spd_scale');
   else
      mc_pwr=0;
   end;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.mc(1)*mc_pwr/1000)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_mc_1');
   % Candidate Value 1
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+editbox_width+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.mc(2)*mc_pwr/1000)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_mc_2');
   % Candidate Value 2
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+2*editbox_width+8+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.cv.mc(3)*mc_pwr/1000)),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','cv_mc_3');
   % Design Variable - cs_lo_soc checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''cs_lo_soc'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Low SOC (--)', ...
      'Style','checkbox', ...
      'Tag','dv_losoc_checkbox',...
      'enable','on', ...
      'Value',eval('~strcmp(vinf.drivetrain.name,''conventional'')&vinf.autosize.dv(4)'));
   % Design Variable - cs_hi_soc checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''cs_hi_soc'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','High SOC (--)', ...
      'Style','checkbox', ...
      'Tag','dv_hisoc_checkbox',...
      'enable','on', ...
      'Value',eval('~strcmp(vinf.drivetrain.name,''conventional'')&vinf.autosize.dv(5)'));
   % Design Variable - final drive ratio checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','autosize_setup(''fd_ratio'')',...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Final Drive Ratio (--)', ...
      'Style','checkbox', ...
      'Tag','dv_fdratio_checkbox',...
      'enable','on', ...
      'Value',vinf.autosize.dv(6));
   
   % vehicle max speed title
   %line_num=line_num+1;
   if strcmp(vinf.units,'metric')
      str='==> min. top speed (km/h)';
   else
      str='==> min. top speed (mph)';
   end
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[2*border+8*char_width par_height-line_num*line_height 12*char_width line_height], ...
      'String',str, ...
      'Fontweight','normal',...
      'HorizontalAlignment','right',...
      'Style','text');
   % vehicle max speed editbox
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[(par_width-2*border)/2+editbox_width+8 par_height-line_num*line_height editbox_width line_height], ...
      'String',num2str(round(vinf.autosize.con.max_spd*units('mph2kmph')*10)/10), ...
      'Tag','autosize_max_spd',...
      'Style','edit');
   
   if par_height>400
      line_num=line_num+1;
   end
   
   
   % Objectives section title
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Objectives', ...
      'Fontweight','bold',...
      'Style','text');
   % Objective - component sizes checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Component Sizes (Minimize)', ...
      'Style','checkbox', ...
      'Tag','obj_comp_sizes_checkbox',...
      'enable','off', ...
      'Value',vinf.autosize.obj(1));
   % Objective - vehicle mass checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','Vehicle Mass (Minimize)', ...
      'Style','checkbox', ...
      'Tag','obj_vehicle_mass_checkbox',...
      'enable','off', ...
      'Value',vinf.autosize.obj(2));
   % Objective - fuel economy checkbox
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','City/Hwy Combined Fuel Economy (Maximize)', ...
      'Style','checkbox', ...
      'Tag','obj_fuel_economy_checkbox',...
      'enable','off', ...
      'Value',vinf.autosize.obj(3));
   
   if par_height>400
      line_num=line_num+1;
   end
   
   % VisualDOC Parameters section title
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height par_width-2*border line_height], ...
      'String','VisualDOC Optimization Parameters', ...
      'Fontweight','bold',...
      'Style','text');
   % Resp surf approximation optimization radio button
   %line_num=line_num+1;
   %h1 = uicontrol('Parent',h0, ...
   %   'BackgroundColor',figure_color, ...
   %   'Position',[border par_height-line_num*line_height (par_width-2*border)/2 line_height], ...
   %   'HorizontalAlignment','left',...
   %   'String','Response Surface Approximations:  ', ...
   %   'Style','text');
   %h1 = uicontrol('Parent',h0, ...
   %   'Callback','set(findobj(''tag'',''visdoc_opt_app_rb''),''value'',1); set(findobj(''tag'',''visdoc_opt_full_rb''),''value'',0); autosize_setup(''approximations'')',...
   %   'BackgroundColor',figure_color, ...
   %   'Position',[2*(par_width-2*border)/3 par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
   %   'String','Use',...
   %   'Style','radiobutton', ...
   %   'Tag','visdoc_opt_app_rb',...
   %   'enable','off', ...
   %   'Value',vinf.autosize.params.resp);
   % Full optimization radio button
   %h1 = uicontrol('Parent',h0, ...
   %   'Callback','set(findobj(''tag'',''visdoc_opt_app_rb''),''value'',0); set(findobj(''tag'',''visdoc_opt_full_rb''),''value'',1); autosize_setup(''approximations'')',...
   %   'BackgroundColor',figure_color, ...
   %   'Position',[2*(par_width-2*border)/3+6*char_width par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
   %   'String','Do Not Use',...
   %   'Style','radiobutton', ...
   %   'Tag','visdoc_opt_full_rb',...
   %   'enable','off', ...
   %   'Value',~vinf.autosize.params.resp);
   
   line_num=line_num+1;
   % min iterations
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height 12*char_width line_height], ...
      'String','Design Cycles:  ', ...
      'HorizontalAlignment','left',...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[2*(par_width-2*border)/3 par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
      'HorizontalAlignment','left',...
      'String','Min', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[2*(par_width-2*border)/3+2*char_width par_height-line_num*line_height editbox_width/2 line_height], ...
      'String',num2str(vinf.autosize.params.iter.min),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','min_iter');
   % max iterations
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[2*(par_width-2*border)/3+6*char_width par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
      'HorizontalAlignment','left',...
      'String','Max', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[2*(par_width-2*border)/3+9*char_width par_height-line_num*line_height editbox_width/2 line_height], ...
      'String',num2str(vinf.autosize.params.iter.max),...
      'Style','edit', ...
      'enable','off', ...
      'Tag','max_iter');
   
   %    optimization  method radio buttons
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height (par_width-2*border)/2 line_height], ...
      'HorizontalAlignment','left',...
      'String','Optimization Method:  ', ...
      'Style','text');
   % feasible directions
   h1 = uicontrol('Parent',h0, ...
      'Callback','set(findobj(''tag'',''visdoc_opt_feas_rb''),''value'',1); set(findobj(''tag'',''visdoc_opt_slp_rb''),''value'',0);set(findobj(''tag'',''visdoc_opt_sqp_rb''),''value'',0)',...
      'BackgroundColor',figure_color, ...
      'Position',[border+11*char_width par_height-line_num*line_height (par_width-2*border)/3 line_height], ...
      'String','Feasible Directions',...
      'Style','radiobutton', ...
      'Tag','visdoc_opt_feas_rb',...
      'enable','off', ...
      'Value',eval('vinf.autosize.params.method==1'));
   % SLP
   h1 = uicontrol('Parent',h0, ...
      'Callback','set(findobj(''tag'',''visdoc_opt_feas_rb''),''value'',0); set(findobj(''tag'',''visdoc_opt_slp_rb''),''value'',1);set(findobj(''tag'',''visdoc_opt_sqp_rb''),''value'',0)',...
      'BackgroundColor',figure_color, ...
      'Position',[2*(par_width-2*border)/3 par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
      'String','SLP',...
      'Style','radiobutton', ...
      'Tag','visdoc_opt_slp_rb',...
      'enable','off', ...
      'Value',eval('vinf.autosize.params.method==2'));
   % SQP
   h1 = uicontrol('Parent',h0, ...
      'Callback','set(findobj(''tag'',''visdoc_opt_feas_rb''),''value'',0); set(findobj(''tag'',''visdoc_opt_slp_rb''),''value'',0);set(findobj(''tag'',''visdoc_opt_sqp_rb''),''value'',1)',...
      'BackgroundColor',figure_color, ...
      'Position',[2*(par_width-2*border)/3+6*char_width par_height-line_num*line_height (par_width-2*border)/4 line_height], ...
      'String','SQP',...
      'Style','radiobutton', ...
      'Tag','visdoc_opt_sqp_rb',...
      'enable','off', ...
      'Value',eval('vinf.autosize.params.method==3'));
   
   % Response surfaces comment added 3/8/99:tm
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height (par_width-2*border) line_height], ...
      'HorizontalAlignment','left',...
      'String','** Response surface approximations method will be used.', ...
      'Style','text');
   %%%
   
   %run button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','autosize_setup(''run'')',...
      'Position',[(par_width-4*button_width)/5 10 button_width button_height], ...
      'String','RUN', ...
      'Tag','Pushbutton1');
   
   %defaults button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','autosize_setup(''load_defaults'')',...
      'Position',[2*(par_width-4*button_width)/5+1*button_width 10 button_width button_height], ...
      'String','DEFAULTS', ...
      'Tag','Pushbutton2');
   
   %cancel button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','autosize_setup(''cancel'')',...
      'Position',[3*(par_width-4*button_width)/5+2*button_width 10 button_width button_height], ...
      'String','CANCEL', ...
      'Tag','Pushbutton3');
   
   %help button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','load_in_browser(''autosize_help.html'');', ...
      'Position',[4*(par_width-4*button_width)/5+3*button_width 10 button_width button_height], ...
      'String','HELP', ...
      'Tag','Pushbutton4');
   
   eval('autosize_setup(''accel'')')
   eval('autosize_setup(''motor_controller'')')
   eval('autosize_setup(''cs_hi_soc'')')
   eval('autosize_setup(''cs_lo_soc'')')
   if ~vinf.autosize.matlab
      autosize_setup('visdoc')
   end
   
   
case 'run'
   
   error_code=check_inputs;
   
   if ~error_code
      
      h_matlab=get(findobj('tag','as_matlab'),'value');
      h_visdoc=get(findobj('tag','as_visdoc'),'value');
      
      h_grade=get(findobj('tag','grade_test_checkbox'),'value');
      h_accel=get(findobj('tag','accel_checkbox'),'value');  
      
      h_ess=get(findobj('tag','dv_ess_checkbox'),'value');
      h_fc=get(findobj('tag','dv_fc_checkbox'),'value');  
      h_mc=get(findobj('tag','dv_mc_checkbox'),'value');  
      h_cslo=get(findobj('tag','dv_losoc_checkbox'),'value');
      h_cshi=get(findobj('tag','dv_hisoc_checkbox'),'value');  
      h_fdr=get(findobj('tag','dv_fdratio_checkbox'),'value');  
      
      if h_grade&~isfield(vinf,'grade_test')
         GradeFigControl
         uiwait(gcf)
      end
      
      if h_accel&~isfield(vinf,'accel_test')
         AccelFigControl
         uiwait(gcf)
      end
      
      if ((h_grade&isfield(vinf,'grade_test'))|(h_accel&isfield(vinf,'accel_test')))
         
         if (h_ess|h_fc|h_mc|h_cslo|h_cshi|h_fdr)
            
            vinf.autosize.constraints=[h_grade h_accel];
            if 0 % disabled 1/25/01:tm
               
               grade_mph=str2num(get(findobj('tag','autosize_speed_goal'),'string'));
               grade_grade=str2num(get(findobj('tag','autosize_grade_goal'),'string'));
               
               vinf.autosize.con.grade.goal.mph=grade_mph/units('mph2kmph');
               vinf.autosize.con.grade.goal.grade=grade_grade;
               
               grade_mph_tol=str2num(get(findobj('tag','autosize_speed_tol'),'string'));
               grade_grade_tol=str2num(get(findobj('tag','autosize_grade_tol'),'string'));
               
               vinf.autosize.con.grade.tol.mph=grade_mph_tol/units('mph2kmph');
               vinf.autosize.con.grade.tol.grade=grade_grade_tol;
            end
               if 0 % disabled 1/25/01:tm
                           if h_accel
   
                  if get(findobj('tag','accel_0_18_checkbox'),'value')
                     accel_0_18=str2num(get(findobj('tag','autosize_0_18_goal'),'string'));
                  else
                     accel_0_18=-1;
                  end
                  if get(findobj('tag','accel_0_30_checkbox'),'value')
                     accel_0_30=str2num(get(findobj('tag','autosize_0_30_goal'),'string'));
                  else
                     accel_0_30=-1;
                  end
                  if get(findobj('tag','accel_0_60_checkbox'),'value')
                     accel_0_60=str2num(get(findobj('tag','autosize_0_60_goal'),'string'));
                  else
                     accel_0_60=-1;
                  end
                  if get(findobj('tag','accel_40_60_checkbox'),'value')
                     accel_40_60=str2num(get(findobj('tag','autosize_40_60_goal'),'string'));
                  else
                     accel_40_60=-1;
                  end
                  if get(findobj('tag','accel_0_85_checkbox'),'value')
                     accel_0_85=str2num(get(findobj('tag','autosize_0_85_goal'),'string'));
                  else
                     accel_0_85=-1;
                  end
               else
                  accel_0_18=-1;
                  accel_0_30=-1;
                  accel_0_60=-1;
                  accel_0_85=-1;
                  accel_40_60=-1;
               end
               
               vinf.autosize.con.accel.goal.t0_18=accel_0_18;
               vinf.autosize.con.accel.goal.t0_30=accel_0_30;
               vinf.autosize.con.accel.goal.t0_60=accel_0_60;
               vinf.autosize.con.accel.goal.t40_60=accel_40_60;
               vinf.autosize.con.accel.goal.t0_85=accel_0_85;
               
               accel_0_18_tol=str2num(get(findobj('tag','autosize_0_18_tol'),'string'));
               accel_0_30_tol=str2num(get(findobj('tag','autosize_0_30_tol'),'string'));
               accel_0_60_tol=str2num(get(findobj('tag','autosize_0_60_tol'),'string'));
               accel_40_60_tol=str2num(get(findobj('tag','autosize_40_60_tol'),'string'));
               accel_0_85_tol=str2num(get(findobj('tag','autosize_0_85_tol'),'string'));
               
               vinf.autosize.con.accel.tol.t0_18=accel_0_18_tol;
               vinf.autosize.con.accel.tol.t0_30=accel_0_30_tol;
               vinf.autosize.con.accel.tol.t0_60=accel_0_60_tol;
               vinf.autosize.con.accel.tol.t40_60=accel_40_60_tol;
               vinf.autosize.con.accel.tol.t0_85=accel_0_85_tol;
            end
            max_spd=str2num(get(findobj('tag','autosize_max_spd'),'string'));
            vinf.autosize.con.max_spd=max_spd/units('mph2kmph');
            
            %the following is if gui is running
            h=findobj('tag','input_figure');
            if ~isempty(h)
               set(h,'Visible','off')
            end
            %-------
            
            % set status variable
            vinf.autosize_run_status=1;
            
            vinf.autosize.dv=[get(findobj('tag','dv_fc_checkbox'),'value') ...
                  get(findobj('tag','dv_ess_checkbox'),'value') ...
                  get(findobj('tag','dv_mc_checkbox'),'value') ...
                  get(findobj('tag','dv_losoc_checkbox'),'value') ...
                  get(findobj('tag','dv_hisoc_checkbox'),'value') ...
                  get(findobj('tag','dv_fdratio_checkbox'),'value')];
            
            % store revised params
            if ~strcmp(vinf.drivetrain.name,'ev')
               if evalin('base','exist(''fc_fuel_cell_model'')')
                  if evalin('base','fc_fuel_cell_model')==1
                     fc_pwr=evalin('base','max(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num)');
                  elseif evalin('base','fc_fuel_cell_model')==2
                     fc_pwr=evalin('base','max(fc_pwr_map)');
                  elseif evalin('base','fc_fuel_cell_model')==3
                     fc_pwr=vinf.gctool.dv.value(1);
                  end
                  vinf.autosize.cv.fc=[str2num(get(findobj('tag','cv_fc_1'),'string')) ...
                        str2num(get(findobj('tag','cv_fc_2'),'string')) ...
                        str2num(get(findobj('tag','cv_fc_3'),'string'))]...
                     .*1000./fc_pwr;
               else
                  vinf.autosize.cv.fc=[str2num(get(findobj('tag','cv_fc_1'),'string')) ...
                        str2num(get(findobj('tag','cv_fc_2'),'string')) ...
                        str2num(get(findobj('tag','cv_fc_3'),'string'))]...
                     .*1000./evalin('base','max(fc_map_spd.*fc_max_trq)*fc_spd_scale');
               end
            end
            if ~strcmp(vinf.drivetrain.name,'conventional')
               vinf.autosize.cv.ess=[str2num(get(findobj('tag','cv_ess_1'),'string')) ...
                     str2num(get(findobj('tag','cv_ess_2'),'string')) ...
                     str2num(get(findobj('tag','cv_ess_3'),'string'))];
               vinf.autosize.cv.mc=[str2num(get(findobj('tag','cv_mc_1'),'string')) ...
                     str2num(get(findobj('tag','cv_mc_2'),'string')) ...
                     str2num(get(findobj('tag','cv_mc_3'),'string'))]...
                  .*1000./evalin('base','max(mc_map_spd.*mc_max_trq)*mc_spd_scale');
            end
            
            vinf.autosize.obj=[get(findobj('tag','obj_comp_sizes_checkbox'),'value') ...
                  get(findobj('tag','obj_vehicle_mass_checkbox'),'value') ...
                  get(findobj('tag','obj_fuel_economy_checkbox'),'value')];
            
            vinf.autosize.matlab=get(findobj('tag','as_matlab'),'value');
            
            if h_matlab
               
               % close the current figure
               close(gcf)
               
               %load initial conditions if not already loaded
               init_conds
               
               % run matlab-based autosize
               if 0
                  autosize(1,...
                     [grade_mph/units('mph2kmph') grade_grade],...
                     [accel_0_18 accel_0_30 accel_0_60 accel_0_85 accel_40_60],...
                     [grade_mph_tol/units('mph2kmph') grade_grade_tol],...
                     [accel_0_18_tol accel_0_30_tol accel_0_60_tol accel_0_85_tol accel_40_60_tol],...
                     [vinf.autosize.cv.fc(2:end); vinf.autosize.cv.ess(2:end); vinf.autosize.cv.mc(2:end)])
               else
                  if h_accel&h_grade
                     autosize(1,...
                        vinf.grade_test,...
                        vinf.accel_test,...
                        [vinf.autosize.cv.fc(2:end); vinf.autosize.cv.ess(2:end); vinf.autosize.cv.mc(2:end)])
                  elseif h_accel
                     autosize(1,...
                        [],...
                        vinf.accel_test,...
                        [vinf.autosize.cv.fc(2:end); vinf.autosize.cv.ess(2:end); vinf.autosize.cv.mc(2:end)])
                  elseif h_grade
                     autosize(1,...
                        vinf.grade_test,...
                        [],...
                        [vinf.autosize.cv.fc(2:end); vinf.autosize.cv.ess(2:end); vinf.autosize.cv.mc(2:end)])
                  end
               end
               
               
            elseif h_visdoc
               
               
               vinf.autosize.params.iter.min=str2num(get(findobj('tag','min_iter'),'string'));
               vinf.autosize.params.iter.max=str2num(get(findobj('tag','max_iter'),'string'));
               %vinf.autosize.params.resp=get(findobj('tag','visdoc_opt_app_rb'),'value');
               vinf.autosize.params.resp=1; % override 3/8/99:tm a discrete variable cannot be the objective of a direct optimization
               if get(findobj('tag','visdoc_opt_feas_rb'),'value')==1
                  vinf.autosize.params.method=1;
               elseif get(findobj('tag','visdoc_opt_slp_rb'),'value')==1
                  vinf.autosize.params.method=2;
               elseif get(findobj('tag','visdoc_opt_sqp_rb'),'value')==1
                  vinf.autosize.params.method=3;
               end;
               %vinf.autosize.params.method=2; % override 3/8/99:tm a discrete variable cannot be the objective of a direct optimization
               
               % close current figure
               close(gcf)
               
               % run autosize using visualdoc
               resp=vdoc_as_opt('matlab');
               
            end
            if 0
               % check results and confirm valid solution
               init_conds;
               
               if vinf.autosize.constraints(1)
                  max_grade=grade_test(vinf.autosize.con.grade.goal.mph);
                  if max_grade>=vinf.autosize.con.grade.goal.grade-vinf.autosize.con.grade.tol.grade
                     grade_achieved=1;
                  else
                     grade_achieved=0;
                  end
                  
                  vinf=rmfield(vinf,'max_grade');
               end
               
               if vinf.autosize.constraints(2)
                  [x,y,z]=accel_test;
                  accel_results=[vinf.acceleration.time_0_18,vinf.acceleration.time_0_30,x, y, z];
                  accel_targets=[vinf.autosize.con.accel.goal.t0_18, ...
                        vinf.autosize.con.accel.goal.t0_30, ...
                        vinf.autosize.con.accel.goal.t0_60, ...
                        vinf.autosize.con.accel.goal.t0_85, ...
                        vinf.autosize.con.accel.goal.t40_60];
                  accel_target_tols=[vinf.autosize.con.accel.tol.t0_18, ...
                        vinf.autosize.con.accel.tol.t0_30, ...
                        vinf.autosize.con.accel.tol.t0_60, ...
                        vinf.autosize.con.accel.tol.t0_85, ...
                        vinf.autosize.con.accel.tol.t40_60];
                  if ((accel_targets>0).*accel_results>=0)&(((accel_targets>0).*accel_results)<=((accel_targets>0).*(accel_targets+accel_target_tols)))
                     accel_achieved=1;
                  else
                     accel_achieved=0;
                  end
                  
                  vinf.acceleration=rmfield(vinf.acceleration,'time_0_18');
                  vinf.acceleration=rmfield(vinf.acceleration,'time_0_30');
                  vinf.acceleration=rmfield(vinf.acceleration,'time_0_60');
                  vinf.acceleration=rmfield(vinf.acceleration,'time_40_60');
                  vinf.acceleration=rmfield(vinf.acceleration,'time_0_85');
                  vinf=rmfield(vinf,'cycle');
               end
               
               if (vinf.autosize.constraints(1)&~grade_achieved)|(vinf.autosize.constraints(2)&~accel_achieved)
                  if ~grade_achieved&~accel_achieved
                     h_msg=warndlg('Grade and acceleration constraints were not met.');
                  elseif ~grade_achieved
                     h_msg=warndlg('Grade constraints were not met.');
                  else
                     h_msg=warndlg('Acceleration constraints were not met.');
                  end
                  set(h_msg,'WindowStyle','modal')
                  uiwait(h_msg)
               end
            end
            %the following is if gui is running
            if ~isempty(h)
               set(h,'Visible','on');
            end
            %----------   
         else
            h=warndlg('No design variables have been selected. The vehicle can not be autosized.','Design Variables Warning');
            uiwait(h)
         end
      else
         h=warndlg('No constraints have been selected. The vehicle can not be autosized.','Constraints Warning');
         uiwait(h)
      end;
      
   end
   
case 'load_defaults'
   eval('vinf.autosize; test4exist=1;','test4exist=0;')
   if test4exist
      
      %button=questdlg('Select vehicle type:','Vehicle Type Selection Window','PNGV','Transit Bus','Tractor Trailer','PNGV');
      button='PNGV';
      
      if strcmp(button,'PNGV')
         vinf=rmfield(vinf,'autosize');
         vinf.autosize.matlab=1;
         vinf.autosize.con.max_spd=90;
         if 0 %1/25/00:tm commented out for use with new gui
            vinf.autosize.con.grade.goal.mph=55;
            vinf.autosize.con.grade.goal.grade=6;
            vinf.autosize.con.accel.goal.t0_18=-1;
            vinf.autosize.con.accel.goal.t0_30=-1;
            vinf.autosize.con.accel.goal.t0_60=12;
            vinf.autosize.con.accel.goal.t40_60=5.3;
            vinf.autosize.con.accel.goal.t0_85=23.4;
            vinf.autosize.con.grade.tol.mph=0.01;
            vinf.autosize.con.grade.tol.grade=0.05;
            vinf.autosize.con.accel.tol.t0_18=0.02;
            vinf.autosize.con.accel.tol.t0_30=0.02;
            vinf.autosize.con.accel.tol.t0_60=0.02;
            vinf.autosize.con.accel.tol.t40_60=0.02;
            vinf.autosize.con.accel.tol.t0_85=0.05;
         end
         vinf.autosize.cv.fc=[1.0 0.75 1.5];
         vinf.autosize.cv.ess=[25 15 30];
         vinf.autosize.cv.mc=[1.0 0.75 1.5];
         vinf.autosize.params.resp=1;
         vinf.autosize.params.method=3;
         vinf.autosize.params.iter.min=3;
         vinf.autosize.params.iter.max=25;
         vinf.autosize.dv=[1 1 1 0 0 1];
         vinf.autosize.obj=[1 0 0];
         vinf.autosize.constraints=[1 1];
         
      elseif strcmp(button,'Transit Bus')
         vinf=rmfield(vinf,'autosize');
         vinf.autosize.matlab=1;
         vinf.autosize.con.max_spd=45;
         if 0 %1/25/00:tm commented out for use with new gui
            
            vinf.autosize.con.grade.goal.mph=20;
            vinf.autosize.con.grade.goal.grade=3;
            vinf.autosize.con.accel.goal.t0_18=6;
            vinf.autosize.con.accel.goal.t0_30=10;
            vinf.autosize.con.accel.goal.t0_60=-1;
            vinf.autosize.con.accel.goal.t40_60=-1;
            vinf.autosize.con.accel.goal.t0_85=-1;
            vinf.autosize.con.grade.tol.mph=0.01;
            vinf.autosize.con.grade.tol.grade=0.05;
            vinf.autosize.con.accel.tol.t0_18=0.02;
            vinf.autosize.con.accel.tol.t0_30=0.02;
            vinf.autosize.con.accel.tol.t0_60=0.02;
            vinf.autosize.con.accel.tol.t40_60=0.02;
            vinf.autosize.con.accel.tol.t0_85=0.05;
         end
         vinf.autosize.cv.fc=[1.0 0.75 1.5];
         vinf.autosize.cv.ess=[25 15 30];
         vinf.autosize.cv.mc=[1.0 0.75 1.5];
         vinf.autosize.params.resp=1;
         vinf.autosize.params.method=3;
         vinf.autosize.params.iter.min=3;
         vinf.autosize.params.iter.max=25;
         vinf.autosize.dv=[1 1 1 0 0 1];
         vinf.autosize.obj=[1 0 0];
         vinf.autosize.constraints=[1 1];
         
      elseif strcmp(button,'Tractor Trailer')
         vinf=rmfield(vinf,'autosize');
         vinf.autosize.matlab=1;
         vinf.autosize.con.max_spd=60;
         if 0 %1/25/00:tm commented out for use with new gui
            
            vinf.autosize.con.grade.goal.mph=20;
            vinf.autosize.con.grade.goal.grade=3;
            vinf.autosize.con.accel.goal.t0_18=6;
            vinf.autosize.con.accel.goal.t0_30=10;
            vinf.autosize.con.accel.goal.t0_60=35;
            vinf.autosize.con.accel.goal.t40_60=-1;
            vinf.autosize.con.accel.goal.t0_85=-1;
            vinf.autosize.con.grade.tol.mph=0.01;
            vinf.autosize.con.grade.tol.grade=0.05;
            vinf.autosize.con.accel.tol.t0_18=0.02;
            vinf.autosize.con.accel.tol.t0_30=0.02;
            vinf.autosize.con.accel.tol.t0_60=0.02;
            vinf.autosize.con.accel.tol.t40_60=0.02;
            vinf.autosize.con.accel.tol.t0_85=0.05;
         end
         vinf.autosize.cv.fc=[1.0 0.75 1.5];
         vinf.autosize.cv.ess=[25 15 30];
         vinf.autosize.cv.mc=[1.0 0.75 1.5];
         vinf.autosize.params.resp=1;
         vinf.autosize.params.method=3;
         vinf.autosize.params.iter.min=3;
         vinf.autosize.params.iter.max=25;
         vinf.autosize.dv=[1 1 1 0 0 1];
         vinf.autosize.obj=[1 0 0];
         vinf.autosize.constraints=[1 1];
      end
      
      close(gcbf);
      autosize_setup('load');
      
   else % load the initial defaults
      vinf.autosize.matlab=1;
      vinf.autosize.con.max_spd=90;
      if 0 %1/25/00:tm commented out for use with new gui
         
         vinf.autosize.con.grade.goal.mph=55;
         vinf.autosize.con.grade.goal.grade=6;
         vinf.autosize.con.accel.goal.t0_18=-1;
         vinf.autosize.con.accel.goal.t0_30=-1;
         vinf.autosize.con.accel.goal.t0_60=12;
         vinf.autosize.con.accel.goal.t40_60=5.3;
         vinf.autosize.con.accel.goal.t0_85=23.4;
         vinf.autosize.con.grade.tol.mph=0.01;
         vinf.autosize.con.grade.tol.grade=0.05;
         vinf.autosize.con.accel.tol.t0_18=0.02;
         vinf.autosize.con.accel.tol.t0_30=0.02;
         vinf.autosize.con.accel.tol.t0_60=0.02;
         vinf.autosize.con.accel.tol.t40_60=0.02;
         vinf.autosize.con.accel.tol.t0_85=0.05;
      end
      vinf.autosize.cv.fc=[1.0 0.75 1.5];
      vinf.autosize.cv.ess=[25 15 30];
      vinf.autosize.cv.mc=[1.0 0.75 1.5];
      vinf.autosize.params.resp=1;
      vinf.autosize.params.method=3;
      vinf.autosize.params.iter.min=3;
      vinf.autosize.params.iter.max=25;
      vinf.autosize.dv=[1 1 1 0 0 1];
      vinf.autosize.obj=[1 0 0];
      vinf.autosize.constraints=[1 1];
   end
   
case 'cancel'
   close(gcbf);
   
case 'matlab'
   set(findobj('tag','as_matlab'),'value',1);
   
   % disable all visdoc related parameters
   set(findobj('tag','as_visdoc'),'value',0);
   set(findobj('tag','obj_fuel_economy_checkbox'),'enable','off');
   set(findobj('tag','obj_comp_sizes_checkbox'),'enable','off');
   set(findobj('tag','obj_vehicle_mass_checkbox'),'enable','off');
   set(findobj('tag','visdoc_opt_full_rb'),'enable','off');
   set(findobj('tag','visdoc_opt_app_rb'),'enable','off');
   set(findobj('tag','visdoc_opt_feas_rb'),'enable','off');
   set(findobj('tag','visdoc_opt_sqp_rb'),'enable','off');
   set(findobj('tag','visdoc_opt_slp_rb'),'enable','off');
   set(findobj('tag','min_iter'),'enable','off');
   set(findobj('tag','max_iter'),'enable','off');
   %tm 7/16/00 condidate values to be used in autosize now as upper and lower bounds
   %set(findobj('tag','cv_fc_1'),'enable','off');
   %set(findobj('tag','cv_fc_2'),'enable','off');
   %set(findobj('tag','cv_fc_3'),'enable','off');
   %set(findobj('tag','cv_ess_1'),'enable','off');
   %set(findobj('tag','cv_ess_2'),'enable','off');
   %set(findobj('tag','cv_ess_3'),'enable','off');
   %set(findobj('tag','cv_mc_1'),'enable','off');
   %set(findobj('tag','cv_mc_2'),'enable','off');
   %set(findobj('tag','cv_mc_3'),'enable','off');
   
   %set(findobj('tag','autosize_0_85_tol'),'enable','on');
   %set(findobj('tag','autosize_40_60_tol'),'enable','on');
   %set(findobj('tag','autosize_0_60_tol'),'enable','on');
   %set(findobj('tag','autosize_0_18_tol'),'enable','on');
   %set(findobj('tag','autosize_0_30_tol'),'enable','on');
   %set(findobj('tag','autosize_speed_tol'),'enable','on');
   %set(findobj('tag','autosize_grade_tol'),'enable','on');
   
   % update design variable parameters
   set(findobj('tag','dv_fc_checkbox'),'enable','off');
   set(findobj('tag','dv_ess_checkbox'),'enable','off');
   set(findobj('tag','dv_fdratio_checkbox'),'enable','on');
   if ~strcmp(vinf.drivetrain.name,'conventional')
      set(findobj('tag','dv_mc_checkbox'),'enable','on');
      %set(findobj('tag','dv_mc_checkbox'),'value',1);
      if ~strcmp(vinf.drivetrain.name,'ev')
         set(findobj('tag','dv_losoc_checkbox'),'enable','on');
         set(findobj('tag','dv_hisoc_checkbox'),'enable','on');
         %set(findobj('tag','dv_losoc_checkbox'),'value',1);
         %set(findobj('tag','dv_hisoc_checkbox'),'value',1);
      else         
         set(findobj('tag','dv_losoc_checkbox'),'enable','off');
         set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
         set(findobj('tag','dv_losoc_checkbox'),'value',0);
         set(findobj('tag','dv_hisoc_checkbox'),'value',0);
      end
   else
      set(findobj('tag','dv_mc_checkbox'),'enable','off');
      set(findobj('tag','dv_mc_checkbox'),'value',0);
      set(findobj('tag','dv_losoc_checkbox'),'enable','off');
      set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
      set(findobj('tag','dv_losoc_checkbox'),'value',0);
      set(findobj('tag','dv_hisoc_checkbox'),'value',0);
   end
   
   eval('autosize_setup(''grade'')')
   eval('autosize_setup(''accel'')')
   
case 'visdoc'
   
   
   set(findobj('tag','as_matlab'),'value',0);
   
   % disable the run button while checking vdoc version
   %set(findobj('tag','Pushbutton1'),'enable','off');
   h=waitbar(0.5,'Please wait...');
   set(h,'windowstyle','modal');
   
   % search for vdoc_matlab.exe
   advisor_path=evalin('base','which(''advisor.m'')');
   vdoc_path=[strrep(advisor_path,'\advisor.m','\optimization\'),'vdoc_matlab.exe'];
   info=dir(vdoc_path);
   if length(info)>0
      locate=info.name(1);
   else
      locate='';
   end
   if strcmp(locate,'')
      btn=questdlg('ADVISOR was unable to locate vdoc_matlab.exe on this machine.  Please refer to documentation on Autosize using VisualDOC for troubleshooting tips.','VisualDOC Warning','OK','HELP','OK');
      if strcmp(btn,'HELP')
         evalin('base','load_in_browser(''autosize_help.html'');')
      end
      eval('autosize_setup(''matlab'')')
   else
      [ver_num,demo]=vdoc_ver_num(locate);
      if ver_num>0
         if demo&exist('vdoc_msg.m')
            assignin('base','dont_show',0);
            [vdoc_image,vdoc_image_map] = evalin('base','imread(''smlogo'',''jpg'')');
            h_msg=msgbox('ADVISOR will use a limited version of VisualDOC to perform your optimization.  For more information about VisualDOC or to obtain a full release version for more complex optimization problems please contact Vanderplaats R&D at www.vrand.com.','VisualDOC Message','custom',vdoc_image,vdoc_image_map);
            set(h_msg,'windowstyle','modal')
            h1 = uicontrol('Parent',h_msg, ...
               'Callback','dont_show=get(findobj(''tag'',''vdoc_msg_checkbox''),''value'');', ...
               'Position',[10 10 165 20], ...
               'String','Don''t show this message again.', ...
               'Style','checkbox', ...
               'Tag','vdoc_msg_checkbox',...
               'Value',evalin('base','dont_show'));
            uiwait(h_msg)
            if evalin('base','dont_show')==1
               path_old=evalin('base','which(''vdoc_msg.m'')');
               name_new='vdoc_ms_.m';
               evalin('base',['!rename "',path_old,'" ',name_new,''])
            end
            evalin('base','clear dont_show')
         end
         
         set(findobj('tag','as_matlab'),'value',0);
         set(findobj('tag','as_visdoc'),'value',1);
         set(findobj('tag','obj_fuel_economy_checkbox'),'enable','on');
         set(findobj('tag','obj_comp_sizes_checkbox'),'enable','on');
         set(findobj('tag','obj_vehicle_mass_checkbox'),'enable','on');
         %set(findobj('tag','visdoc_opt_full_rb'),'enable','on');
         %set(findobj('tag','visdoc_opt_app_rb'),'enable','on');
         %set(findobj('tag','autosize_0_85_tol'),'enable','off');
         %set(findobj('tag','autosize_40_60_tol'),'enable','off');
         %set(findobj('tag','autosize_0_60_tol'),'enable','off');
         %set(findobj('tag','autosize_0_18_tol'),'enable','off');
         %set(findobj('tag','autosize_0_30_tol'),'enable','off');
         %set(findobj('tag','autosize_speed_tol'),'enable','off');
         %set(findobj('tag','autosize_grade_tol'),'enable','off');
         set(findobj('tag','min_iter'),'enable','on');
         set(findobj('tag','max_iter'),'enable','on');
         set(findobj('tag','dv_fc_checkbox'),'enable','on');
         set(findobj('tag','dv_ess_checkbox'),'enable','on');
         set(findobj('tag','dv_mc_checkbox'),'enable','on');
         set(findobj('tag','dv_fdratio_checkbox'),'enable','on');
         %set(findobj('tag','dv_mc_checkbox'),'enable','off');
         set(findobj('tag','dv_losoc_checkbox'),'enable','off');
         set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
         %set(findobj('tag','dv_mc_checkbox'),'value',1);
         %set(findobj('tag','dv_mc_checkbox'),'value',0);
         set(findobj('tag','dv_losoc_checkbox'),'value',0);
         set(findobj('tag','dv_hisoc_checkbox'),'value',0);
         
         eval('autosize_setup(''fuel_converter'')')
         eval('autosize_setup(''energy_storage'')')
         eval('autosize_setup(''motor_controller'')')
         eval('autosize_setup(''approximations'')')
         eval('autosize_setup(''grade'')')
         eval('autosize_setup(''accel'')')
         
      else
         h=warndlg('Unable to determine version number of VisualDOC.  ','Warning - version number error!');
         uiwait(h)
      end
   end
   
   % enable the run button after checking vdoc version
   %set(findobj('tag','Pushbutton1'),'enable','on');
   close(h);
   
case 'approximations'
   if 0 % get(findobj('tag','visdoc_opt_app_rb'),'value')==1
      set(findobj('tag','visdoc_opt_feas_rb'),'enable','off');
      set(findobj('tag','visdoc_opt_sqp_rb'),'enable','off');
      set(findobj('tag','visdoc_opt_slp_rb'),'enable','off');
   else
      set(findobj('tag','visdoc_opt_feas_rb'),'enable','on');
      set(findobj('tag','visdoc_opt_sqp_rb'),'enable','on');
      set(findobj('tag','visdoc_opt_slp_rb'),'enable','on');
   end
   
case 'grade'
   if get(findobj('tag','grade_test_checkbox'),'value')==0
      if 0 % disabled 1/25/01:tm
         
         set(findobj('tag','autosize_grade_goal'),'enable','off');
         set(findobj('tag','autosize_speed_goal'),'enable','off');
         set(findobj('tag','autosize_grade_tol'),'enable','off');
         set(findobj('tag','autosize_speed_tol'),'enable','off');
      end
      if ~strcmp(vinf.drivetrain.name,'ev')
         set(findobj('tag','dv_fc_checkbox'),'value',0)
      elseif get(findobj('tag','accel_checkbox'),'value')==0
         set(findobj('tag','dv_ess_checkbox'),'value',0)
      end
      if strcmp(vinf.drivetrain.name,'conventional')
         set(findobj('tag','dv_fc_checkbox'),'value',1)
      end
   else 
      if 0 % disabled 1/25/01:tm
         
         set(findobj('tag','autosize_grade_goal'),'enable','on');
         set(findobj('tag','autosize_speed_goal'),'enable','on');
         if get(findobj('tag','as_visdoc'),'value')==1
            set(findobj('tag','autosize_grade_tol'),'enable','off');
            set(findobj('tag','autosize_speed_tol'),'enable','off');
         else
            set(findobj('tag','autosize_grade_tol'),'enable','on');
            set(findobj('tag','autosize_speed_tol'),'enable','on');
         end
      end
      if ~strcmp(vinf.drivetrain.name,'ev')
         set(findobj('tag','dv_fc_checkbox'),'value',1)
      end
   end
   
   eval('autosize_setup(''fuel_converter'')')
   
case 'accel'
   h1=findobj('tag','accel_checkbox');
   h2=findobj('tag','as_visdoc');
   if 0
      h14=findobj('tag','accel_0_18_checkbox');
      h15=findobj('tag','accel_0_30_checkbox');
      h11=findobj('tag','accel_0_60_checkbox');
      h12=findobj('tag','accel_40_60_checkbox');
      h13=findobj('tag','accel_0_85_checkbox');
      hx=findobj('tag','autosize_0_60_goal');
      hy=findobj('tag','autosize_40_60_goal');
      hz=findobj('tag','autosize_0_85_goal');
      hza=findobj('tag','autosize_0_18_goal');
      hzb=findobj('tag','autosize_0_30_goal');
      ha=findobj('tag','autosize_0_60_tol');
      hb=findobj('tag','autosize_40_60_tol');
      hc=findobj('tag','autosize_0_85_tol');
      hd=findobj('tag','autosize_0_18_tol');
      he=findobj('tag','autosize_0_30_tol');
   end
   
   if get(h1,'value')==0 
      if 0 % disabled 1/25/01:tm
         % disable all accel-related checkboxes and editboxes
         set(hx,'enable','off');
         set(hy,'enable','off'); 
         set(hz,'enable','off');
         set(ha,'enable','off');
         set(hb,'enable','off');
         set(hc,'enable','off');
         set(hd,'enable','off');
         set(he,'enable','off');
         set(hza,'enable','off');
         set(hzb,'enable','off');
         set(h11,'enable','off');
         set(h12,'enable','off');
         set(h13,'enable','off');
         set(h14,'enable','off');
         set(h15,'enable','off');
      end
      if ~strcmp(vinf.drivetrain.name,'ev')
         set(findobj('tag','dv_ess_checkbox'),'enable','off');
         set(findobj('tag','dv_ess_checkbox'),'value',0);
      end
      %set(findobj('tag','dv_mc_checkbox'),'enable','off');
      %set(findobj('tag','dv_mc_checkbox'),'value',0);
      set(findobj('tag','dv_losoc_checkbox'),'enable','off');
      set(findobj('tag','dv_losoc_checkbox'),'value',0);
      set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
      set(findobj('tag','dv_hisoc_checkbox'),'value',0);
      
   else
      if 0 % disabled 1/25/01:tm
         % enable all checkboxes
         set(h11,'enable','on');
         set(h12,'enable','on');
         set(h13,'enable','on');
         set(h14,'enable','on');
         set(h15,'enable','on');
         
         % enable goal editboxes if checked 
         if get(h11,'value')==1
            set(hx,'enable','on');
         else
            set(hx,'enable','off');
         end
         if get(h12,'value')==1
            set(hy,'enable','on');
         else
            set(hy,'enable','off');
         end
         if get(h13,'value')==1
            set(hz,'enable','on');
         else
            set(hz,'enable','off');
         end
         if get(h14,'value')==1
            set(hza,'enable','on');
         else
            set(hza,'enable','off');
         end
         if get(h15,'value')==1
            set(hzb,'enable','on');
         else
            set(hzb,'enable','off');
         end
      end
      if ~strcmp(vinf.drivetrain.name,'conventional')
         set(findobj('tag','dv_ess_checkbox'),'enable','on');
         set(findobj('tag','dv_ess_checkbox'),'value',1);
      end
      if get(h2,'value')==1
         if 0 % disabled 1/25/01:tm
            
            % disable tol editboxes when using visdoc
            set(ha,'enable','off');
            set(hb,'enable','off');
            set(hc,'enable','off');
            set(hd,'enable','off');
            set(he,'enable','off');
         end 
      else
         if 0 % disabled 1/25/01:tm
            
            % enable tol editboxes when using matlab
            if get(h11,'value')==1
               set(ha,'enable','on');
            else
               set(ha,'enable','off');
            end
            if get(h12,'value')==1
               set(hb,'enable','on');
            else
               set(hb,'enable','off');
            end
            if get(h13,'value')==1
               set(hc,'enable','on');
            else
               set(hc,'enable','off');
            end
            if get(h14,'value')==1
               set(hd,'enable','on');
            else
               set(hd,'enable','off');
            end
            if get(h15,'value')==1
               set(he,'enable','on');
            else
               set(he,'enable','off');
            end
         end
         % enable design variable checkboxes
         if ~strcmp(vinf.drivetrain.name,'conventional')
            set(findobj('tag','dv_ess_checkbox'),'enable','on');
            set(findobj('tag','dv_ess_checkbox'),'value',1);
            set(findobj('tag','dv_mc_checkbox'),'enable','on');
            set(findobj('tag','dv_mc_checkbox'),'value',1);
            if ~strcmp(vinf.drivetrain.name,'ev')
               set(findobj('tag','dv_losoc_checkbox'),'enable','on');
               %set(findobj('tag','dv_losoc_checkbox'),'value',1);
               set(findobj('tag','dv_hisoc_checkbox'),'enable','on');
               %set(findobj('tag','dv_hisoc_checkbox'),'value',1);
            else
               set(findobj('tag','dv_losoc_checkbox'),'enable','off');
               set(findobj('tag','dv_losoc_checkbox'),'value',0);
               set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
               set(findobj('tag','dv_hisoc_checkbox'),'value',0);
            end
         else
            set(findobj('tag','dv_ess_checkbox'),'enable','off');
            set(findobj('tag','dv_ess_checkbox'),'value',0);
            set(findobj('tag','dv_mc_checkbox'),'enable','off');
            set(findobj('tag','dv_mc_checkbox'),'value',0);
            set(findobj('tag','dv_losoc_checkbox'),'enable','off');
            set(findobj('tag','dv_losoc_checkbox'),'value',0);
            set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
            set(findobj('tag','dv_hisoc_checkbox'),'value',0);
         end
      end
   end
   
   eval('autosize_setup(''energy_storage'')')
   eval('autosize_setup(''motor_controller'')')
   eval('autosize_setup(''cs_hi_soc'')')
   eval('autosize_setup(''cs_lo_soc'')')
   
case 'fuel_converter'
   if ~strcmp(vinf.drivetrain.name,'ev')
      if get(findobj('tag','dv_fc_checkbox'),'value')==1
         set(findobj('tag','cv_fc_1'),'enable','on');
         set(findobj('tag','cv_fc_2'),'enable','on');
         set(findobj('tag','cv_fc_3'),'enable','on');
      else 
         set(findobj('tag','cv_fc_1'),'enable','off');
         set(findobj('tag','cv_fc_2'),'enable','off');
         set(findobj('tag','cv_fc_3'),'enable','off');
      end;
   else
      set(findobj('tag','dv_fc_checkbox'),'value',0)
      set(findobj('tag','dv_fc_checkbox'),'enable','off');
      set(findobj('tag','cv_fc_1'),'enable','off');
      set(findobj('tag','cv_fc_2'),'enable','off');
      set(findobj('tag','cv_fc_3'),'enable','off');
   end;
   
case 'energy_storage'
   if strcmp(vinf.drivetrain.name,'conventional')
      set(findobj('tag','dv_ess_checkbox'),'value',0) 
      set(findobj('tag','dv_ess_checkbox'),'enable','off');
      set(findobj('tag','cv_ess_1'),'enable','off');
      set(findobj('tag','cv_ess_2'),'enable','off');
      set(findobj('tag','cv_ess_3'),'enable','off');
   end
   
   %if get(findobj('tag','as_visdoc'),'value')==1
   if get(findobj('tag','dv_ess_checkbox'),'value')==1
      set(findobj('tag','cv_ess_1'),'enable','on');
      set(findobj('tag','cv_ess_2'),'enable','on');
      set(findobj('tag','cv_ess_3'),'enable','on');
   else
      set(findobj('tag','cv_ess_1'),'enable','off');
      set(findobj('tag','cv_ess_2'),'enable','off');
      set(findobj('tag','cv_ess_3'),'enable','off');
   end
   %else
   %set(findobj('tag','cv_ess_1'),'enable','off');
   %set(findobj('tag','cv_ess_2'),'enable','off');
   %set(findobj('tag','cv_ess_3'),'enable','off');
   %end
   
   
case 'motor_controller'
   if ~strcmp(vinf.drivetrain.name,'conventional')
      if get(findobj('tag','dv_mc_checkbox'),'value')
         %if get(findobj('tag','as_visdoc'),'value')
         set(findobj('tag','cv_mc_1'),'enable','on');
         set(findobj('tag','cv_mc_2'),'enable','on');
         set(findobj('tag','cv_mc_3'),'enable','on');
         %else
         %set(findobj('tag','cv_mc_1'),'enable','off');
         %set(findobj('tag','cv_mc_2'),'enable','off');
         %set(findobj('tag','cv_mc_3'),'enable','off');
         %end
      else 
         set(findobj('tag','cv_mc_1'),'enable','off');
         set(findobj('tag','cv_mc_2'),'enable','off');
         set(findobj('tag','cv_mc_3'),'enable','off');
      end
   else
      set(findobj('tag','dv_mc_checkbox'),'value',0) 
      set(findobj('tag','dv_mc_checkbox'),'enable','off');
   end
   
case 'cs_hi_soc'
   if strcmp(vinf.drivetrain.name,'ev')
      set(findobj('tag','dv_hisoc_checkbox'),'value',0) 
      set(findobj('tag','dv_hisoc_checkbox'),'enable','off');
   end
   
case 'cs_lo_soc'
   if strcmp(vinf.drivetrain.name,'ev')
      set(findobj('tag','dv_losoc_checkbox'),'value',0) 
      set(findobj('tag','dv_losoc_checkbox'),'enable','off');
   end
   
case 'fd_ratio'
   if get(findobj('tag','dv_fdratio_checkbox'),'value')
      set(findobj('tag','autosize_max_spd'),'enable','on');
   else
      set(findobj('tag','autosize_max_spd'),'enable','off');
   end
   
end

%%%% ----- Subfunctions ------ %%%%%
function error_code=check_inputs
% 
% provide warnings regarding input data
%

% make vinf accessible
global vinf

% initialize flag
error_code=0;

% Are any upper bounds less than lower bounds?
if (str2num(get(findobj('tag','cv_fc_3'),'string'))<str2num(get(findobj('tag','cv_fc_2'),'string')))|(str2num(get(findobj('tag','cv_ess_3'),'string'))<str2num(get(findobj('tag','cv_ess_2'),'string')))|(str2num(get(findobj('tag','cv_mc_3'),'string'))<str2num(get(findobj('tag','cv_mc_2'),'string')))
   errordlg('At least one upper bound is less than the associated lower bound. Please revise inputs!','Autosize Setup Check')
   error_code=1;
   return
end

% Does ess lower bound conflict with mc min volts?
if ~strcmp(vinf.drivetrain.name,'conventional')
   ess_min_voltage=evalin('base','mc_min_volts'); % (volts) smallest allowed energy storage system voltage
   ess_min_module_num=round(ess_min_voltage/evalin('base','ess_min_volts'));
   if get(findobj('tag','cv_ess_1'),'string')<ess_min_module_num
      button=questdlg('Energy storage system lower bound will result in mininum pack voltage less than the motor minimum voltage.  It is recommended that you increase the energy storage system lower bound to avoid instability.','Autosize Setup Check','Cancel','Continue','Cancel');
      if strcmp('button','Cancel')
         error_code=1;
         return
      end
   end
end
if 0
% Check impacts of constraints and final drive ratio settings
max_constraint_spd=max([get(findobj('tag','accel_checkbox'),'value')*units('mph2kmph')*...
      [get(findobj('tag','accel_0_18_checkbox'),'value')*18,...
         get(findobj('tag','accel_0_35_checkbox'),'value')*35,...
         get(findobj('tag','accel_40_60_checkbox'),'value')*60,...
         get(findobj('tag','accel_0_60_checkbox'),'value')*60,...
         get(findobj('tag','accel_0_85_checkbox'),'value')*85],...
      get(findobj('tag','grade_test_checkbox'),'value')*str2num(get(findobj('tag','autosize_speed_goal'),'string'))]);
if get(findobj('tag','dv_fdratio_checkbox'),'value')
   % If fd ratio checked and does max spd violate prevent constraint satisfaction?
   if str2num(get(findobj('tag','autosize_max_spd'),'string'))<max_constraint_spd
      button=questdlg('Minimum top speed setting may prevent satisfaction on one or more constraints. It is recommended that you increase the minimum top vehicle speed or deselect one or more constraints.','Autosize Setup Check','Cancel','Continue','Cancel');
      if strcmp('button','Cancel')
         error_code=1;
         return
      end
   end
else
   % If fd ratio not checked is drivetrain speed limited?
   ratios=evalin('base','gb_ratio');
   mph=max_constraint_spd/units('mph2kmph');
   if strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'series')
      spds=mph*0.447.*ratios*evalin('base','fd_ratio/wh_radius'); % estimate possible motor speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','mc_map_spd*mc_spd_scale'))); % limit to those speeds within the motor map
      trqs=evalin('base',['interp1(mc_map_spd*mc_spd_scale,mc_max_trq*mc_trq_scale,',mat2str(spds),')']); % determine max torque (continuous) at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
   else
      spds=mph*0.447.*ratios*evalin('base','fd_ratio/wh_radius'); % estimate possible engine speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','fc_map_spd*fc_spd_scale'))); % limit to those speeds within the engine map
      trqs=evalin('base',['interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,',mat2str(spds),')']); % determine max torque at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
end
   if isempty(gear_number)|(nnz(spds)<1)
      button=questdlg('Current drivetrain is speed limited and may prevent satisfaction on one or more constraints. It is recommended that you make the final drive ratio an active design variable or deselect one or more constraints.','Autosize Setup Check','Cancel','Continue','Cancel');
      if strcmp('button','Cancel')
         error_code=1;
         return
      end
   end
end
end

return

%%%% ----- END Subfunctions ------ %%%%%


% revision history
% 01/13/99:tm created from autosize_targets - added the flexibility to use VisualDOC for optimization
% 9/15/99:tm updated for metric units capability
% 01/25/00:tm updated figure position to center horizontally and vertically
% 7/14/00:tm revised advisor path information from \..\gui to \..\ for vdoc_matlab.exe
% 7/14/00:tm linked help button directly to autosize_help.html
% 7/17/00:tm changed max speed constraint to parameter of final drive design variable
% 7/17/00:tm changed candidate values title to upper and lower bounds
% 7/17/00:tm added final drive as a design variable
% 7/17/00:tm commented out lines that turn cv boxes off when not matlab engine
% 7/17/00:tm added case for fd_ratio
% 7/17/00:tm added new argument to autosize call to pass dv bounds
% 7/17/00:tm added check_inputs function to verify that inputs are valid - call after hitting run button
% 1/24/01:tm commented out code to build grade and speed editboxes - replaced with grade options button
% 1/24/01:tm commented out code to build accel editboxes - replaced with accel options button
% 1/24/01:tm revised figure size based on removal of the accel and grade editboxes
% 1/25/01:tm in case load_defaults, commented out all references to grade and accel constraint parameters
% 1/29/01:tm added conditionals to matlab call to autosize to pass [] if accel or grade not selected

