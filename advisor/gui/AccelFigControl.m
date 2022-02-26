function AccelFigControl(option)

if nargin<1
   option='load';
end

global vinf

switch option
   
case 'load'
   % configure workspace and open GUI
   
   % load defaults if no parameters defined
   if ~isfield(vinf,'accel_test')
      AccelFigControl('defaults')
   end
   
   if isempty(findobj('tag','accel_test_fig'))
      % open gui
      AccelFig
   end
   set(findobj('tag','accel_test_fig'),'windowstyle','modal')
   
   AccelFigControl('initialize')
   
   AccelFigControl('radiobuttonevent')
   
   AccelFigControl('checkboxevent')
   
   h0=gcf;
   %center the figure on the screen
   set(h0,'units','pixels');
   position=get(h0,'position');
   screensize=get(0,'screensize');
   set(h0,'position', [(screensize(3)-position(3))/2  (screensize(4)-position(4))/2 ...
         position(3) position(4)])
   set(h0,'visible','on')
      set(h0,'windowstyle','modal')

   if strcmp(vinf.units,'metric')
      set(findobj('tag','spd1_units'),'string','km/h')
      set(findobj('tag','spd2_units'),'string','km/h')
      set(findobj('tag','spd3_units'),'string','km/h')
      set(findobj('tag','accel_time1_con_label'),'string','km/h')
      set(findobj('tag','accel_time2_con_label'),'string','km/h')
      set(findobj('tag','accel_time3_con_label'),'string','km/h')
      set(findobj('tag','max_accel_con_label'),'string','m/s^2')
      set(findobj('tag','max_spd_con_label'),'string','km/h')
      set(findobj('tag','time_in_dist_units'),'string','km')
      
      set(findobj('tag','accel_time1_spd1_editbox'),'string',num2str(vinf.accel_test.param.spds1(1)*units('mph2kmph'),3))
      set(findobj('tag','accel_time2_spd1_editbox'),'string',num2str(vinf.accel_test.param.spds2(1)*units('mph2kmph'),3))
      set(findobj('tag','accel_time3_spd1_editbox'),'string',num2str(vinf.accel_test.param.spds3(1)*units('mph2kmph'),3))
      set(findobj('tag','accel_time1_spd2_editbox'),'string',num2str(vinf.accel_test.param.spds1(2)*units('mph2kmph'),3))
      set(findobj('tag','accel_time2_spd2_editbox'),'string',num2str(vinf.accel_test.param.spds2(2)*units('mph2kmph'),3))
      set(findobj('tag','accel_time3_spd2_editbox'),'string',num2str(vinf.accel_test.param.spds3(2)*units('mph2kmph'),3))
      
      set(findobj('tag','time_in_dist_editbox'),'string',num2str(vinf.accel_test.param.time_in_dist*units('miles2km'),3))
   end
   
case 'run'
   % run the test
   
   % check input data
   error_code=check_inputs;
   
   if ~error_code % if no errors
      
      % save current inputs
      vinf.accel_test.param.active=[...
            get(findobj('tag',['gb_shift_delay_checkbox']),'value')...
            get(findobj('tag',['ess_init_soc_checkbox']),'value')...
            get(findobj('tag',['accel_time1_checkbox']),'value')...
            get(findobj('tag',['accel_time2_checkbox']),'value')...
            get(findobj('tag',['accel_time3_checkbox']),'value')...
            get(findobj('tag',['dist_in_time_checkbox']),'value')...
            get(findobj('tag',['time_in_dist_checkbox']),'value')...
            get(findobj('tag',['max_accel_rate_checkbox']),'value')...
            get(findobj('tag',['max_speed_checkbox']),'value')...
            get(findobj('tag',['disable_none_radiobutton']),'value')...
            get(findobj('tag',['disable_ess_radiobutton']),'value')...
            get(findobj('tag',['disable_fc_radiobutton']),'value')...
            get(findobj('tag',['curnt_mass_radiobutton']),'value')...
            get(findobj('tag',['override_mass_radiobutton']),'value')...
            get(findobj('tag',['add_mass_radiobutton']),'value')];
      
      vinf.accel_test.param.ess_init_soc=str2num(get(findobj('tag',['ess_init_soc_editbox']),'string'));
      vinf.accel_test.param.gb_shift_delay=str2num(get(findobj('tag',['gb_shift_delay_editbox']),'string'));
      vinf.accel_test.param.spds1=[str2num(get(findobj('tag',['accel_time1_spd1_editbox']),'string')) str2num(get(findobj('tag',['accel_time1_spd2_editbox']),'string'))]/units('mph2kmph');
      vinf.accel_test.param.spds2=[str2num(get(findobj('tag',['accel_time2_spd1_editbox']),'string')) str2num(get(findobj('tag',['accel_time2_spd2_editbox']),'string'))]/units('mph2kmph');
      vinf.accel_test.param.spds3=[str2num(get(findobj('tag',['accel_time3_spd1_editbox']),'string')) str2num(get(findobj('tag',['accel_time3_spd2_editbox']),'string'))]/units('mph2kmph');
      vinf.accel_test.param.dist_in_time=str2num(get(findobj('tag',['dist_in_time_editbox']),'string'));
      vinf.accel_test.param.time_in_dist=str2num(get(findobj('tag',['time_in_dist_editbox']),'string'))/units('miles2km');
      vinf.accel_test.param.max_rate_bool=get(findobj('tag',['max_accel_rate_checkbox']),'value');
      vinf.accel_test.param.max_speed_bool=get(findobj('tag',['max_speed_checkbox']),'value');
      
      vinf.accel_test.param.accel_time1_con=[str2num(get(findobj('tag',['accel_time1_con_editbox']),'string'))];
      vinf.accel_test.param.accel_time2_con=[str2num(get(findobj('tag',['accel_time2_con_editbox']),'string'))];
      vinf.accel_test.param.accel_time3_con=[str2num(get(findobj('tag',['accel_time3_con_editbox']),'string'))];
      vinf.accel_test.param.dist_in_time_con=str2num(get(findobj('tag',['dist_in_time_con_editbox']),'string'))/units('ft2m');
      vinf.accel_test.param.time_in_dist_con=str2num(get(findobj('tag',['time_in_dist_con_editbox']),'string'));
      vinf.accel_test.param.max_accel_con=str2num(get(findobj('tag',['max_accel_con_editbox']),'string'))/units('ft2m')/units('ft2m');
      vinf.accel_test.param.max_spd_con=str2num(get(findobj('tag',['max_spd_con_editbox']),'string'))/units('mph2kmph');
      
      vinf.accel_test.param.accel_time1_tol=[str2num(get(findobj('tag',['accel_time1_tol_editbox']),'string'))];
      vinf.accel_test.param.accel_time2_tol=[str2num(get(findobj('tag',['accel_time2_tol_editbox']),'string'))];
      vinf.accel_test.param.accel_time3_tol=[str2num(get(findobj('tag',['accel_time3_tol_editbox']),'string'))];
      vinf.accel_test.param.dist_in_time_tol=str2num(get(findobj('tag',['dist_in_time_tol_editbox']),'string'))/units('ft2m');
      vinf.accel_test.param.time_in_dist_tol=str2num(get(findobj('tag',['time_in_dist_tol_editbox']),'string'));
      vinf.accel_test.param.max_accel_tol=str2num(get(findobj('tag',['max_accel_tol_editbox']),'string'))/units('ft2m')/units('ft2m');
      vinf.accel_test.param.max_spd_tol=str2num(get(findobj('tag',['max_spd_tol_editbox']),'string'))/units('mph2kmph');

      if get(findobj('tag','disable_ess_radiobutton'),'value')
         vinf.accel_test.param.disable_systems=1;
      elseif get(findobj('tag','disable_fc_radiobutton'),'value')
         vinf.accel_test.param.disable_systems=2;
      else
         vinf.accel_test.param.disable_systems=0;
      end
      
      vinf.accel_test.param.override_mass=str2num(get(findobj('tag','override_mass_editbox'),'string'));
      vinf.accel_test.param.add_mass=str2num(get(findobj('tag','add_mass_editbox'),'string'));
      
      
      % build argument string
      str=[];
      mat=[];
      for i=1:3
         if get(findobj('tag',['accel_time',num2str(i),'_checkbox']),'value')
            mat=[mat; str2num(get(findobj('tag',['accel_time',num2str(i),'_spd1_editbox']),'string')) str2num(get(findobj('tag',['accel_time',num2str(i),'_spd2_editbox']),'string'))];
         end
      end
      if ~isempty(mat)
         str=[str,'''spds'',',mat2str(mat),','];
      end
      if get(findobj('tag','dist_in_time_checkbox'),'value')
         str=[str,'''dist_in_time'',',str2mat(get(findobj('tag','dist_in_time_editbox'),'string')),','];
      end
      if get(findobj('tag','time_in_dist_checkbox'),'value')
         str=[str,'''time_in_dist'',',str2mat(get(findobj('tag','time_in_dist_editbox'),'string')),','];
      end
      if get(findobj('tag','max_accel_rate_checkbox'),'value')
         str=[str,'''max_rate_bool'',',num2str(get(findobj('tag','max_accel_rate_checkbox'),'value')),','];
      end
      if get(findobj('tag','max_speed_checkbox'),'value')
         str=[str,'''max_speed_bool'',',num2str(get(findobj('tag','max_speed_checkbox'),'value')),','];
      end
      if get(findobj('tag','ess_init_soc_checkbox'),'value')
         str=[str,'''ess_init_soc'',',str2mat(get(findobj('tag','ess_init_soc_editbox'),'string')),','];
      end
      if get(findobj('tag','gb_shift_delay_checkbox'),'value')
         str=[str,'''gb_shift_delay'',',str2mat(get(findobj('tag','gb_shift_delay_editbox'),'string')),','];
      end
      if vinf.accel_test.param.disable_systems
         str=[str,'''disable_systems'',',mat2str(vinf.accel_test.param.disable_systems),','];
      end
      if get(findobj('tag','override_mass_radiobutton'),'value')
         str=[str,'''override_mass'',',mat2str(vinf.accel_test.param.override_mass),','];
      end
      if get(findobj('tag','add_mass_radiobutton'),'value')
         str=[str,'''add_mass'',',mat2str(vinf.accel_test.param.add_mass),','];
      end
      
      
      if ~isempty(str)
         str=str(1:end-1); 
         str=['vinf.accel_test.results=accel_test_advanced(',str,');'];
      else
         str=['vinf.accel_test.results=accel_test_advanced;'];
      end
      
      close(findobj('tag','accel_test_fig'));
      
      % clear any previous results
      if isfield(vinf.accel_test,'results')
         vinf.accel_test=rmfield(vinf.accel_test,'results');
      end
      
      if isempty(findobj('tag','execute_figure'))&isempty(findobj('tag','input_figure'))&(isfield(vinf,'test')&strcmp(vinf.test.run,'on'))
         % run acceleration test
         eval(str)
         
         evalin('base','gui_post_process')
         
         if ~isfield(vinf,'run_without_gui')
            ResultsFig
         end
      end
   end
   
case 'cancel'
   close(findobj('tag','accel_test_fig'));
   if isempty(findobj('tag','execute_figure'))&isempty(findobj('tag','input_figure'))
      SimSetupFig
   end
   
case 'initialize'
   set(findobj('tag',['gb_shift_delay_checkbox']),'value',vinf.accel_test.param.active(1))
   set(findobj('tag',['ess_init_soc_checkbox']),'value',vinf.accel_test.param.active(2))
   set(findobj('tag',['accel_time1_checkbox']),'value',vinf.accel_test.param.active(3))
   set(findobj('tag',['accel_time2_checkbox']),'value',vinf.accel_test.param.active(4))
   set(findobj('tag',['accel_time3_checkbox']),'value',vinf.accel_test.param.active(5))
   set(findobj('tag',['dist_in_time_checkbox']),'value',vinf.accel_test.param.active(6))
   set(findobj('tag',['time_in_dist_checkbox']),'value',vinf.accel_test.param.active(7))
   set(findobj('tag',['max_accel_rate_checkbox']),'value',vinf.accel_test.param.active(8))
   set(findobj('tag',['max_speed_checkbox']),'value',vinf.accel_test.param.active(9))
   set(findobj('tag',['curnt_mass_radiobutton']),'value',vinf.accel_test.param.active(10))
   set(findobj('tag',['override_mass_radiobutton']),'value',vinf.accel_test.param.active(11))
   set(findobj('tag',['add_mass_radiobutton']),'value',vinf.accel_test.param.active(12))
   set(findobj('tag',['disable_none_radiobutton']),'value',vinf.accel_test.param.active(13))
   set(findobj('tag',['disable_ess_radiobutton']),'value',vinf.accel_test.param.active(14))
   set(findobj('tag',['disable_fc_radiobutton']),'value',vinf.accel_test.param.active(15))
   
   set(findobj('tag',['gb_shift_delay_editbox']),'string',num2str(vinf.accel_test.param.gb_shift_delay))
   set(findobj('tag',['ess_init_soc_editbox']),'string',num2str(vinf.accel_test.param.ess_init_soc))
   set(findobj('tag',['accel_time1_spd1_editbox']),'string',num2str(vinf.accel_test.param.spds1(1)))
   set(findobj('tag',['accel_time1_spd2_editbox']),'string',num2str(vinf.accel_test.param.spds1(2)))
   set(findobj('tag',['accel_time2_spd1_editbox']),'string',num2str(vinf.accel_test.param.spds2(1)))
   set(findobj('tag',['accel_time2_spd2_editbox']),'string',num2str(vinf.accel_test.param.spds2(2)))
   set(findobj('tag',['accel_time3_spd1_editbox']),'string',num2str(vinf.accel_test.param.spds3(1)))
   set(findobj('tag',['accel_time3_spd2_editbox']),'string',num2str(vinf.accel_test.param.spds3(2)))
   set(findobj('tag',['dist_in_time_editbox']),'string',num2str(vinf.accel_test.param.dist_in_time))
   set(findobj('tag',['time_in_dist_editbox']),'string',num2str(vinf.accel_test.param.time_in_dist))
   
   set(findobj('tag',['accel_time1_con_editbox']),'string',num2str(vinf.accel_test.param.accel_time1_con))
   set(findobj('tag',['accel_time2_con_editbox']),'string',num2str(vinf.accel_test.param.accel_time2_con))
   set(findobj('tag',['accel_time3_con_editbox']),'string',num2str(vinf.accel_test.param.accel_time3_con))
   set(findobj('tag',['dist_in_time_con_editbox']),'string',num2str(vinf.accel_test.param.dist_in_time_con))
   set(findobj('tag',['time_in_dist_con_editbox']),'string',num2str(vinf.accel_test.param.time_in_dist_con))
      set(findobj('tag',['max_accel_con_editbox']),'string',num2str(vinf.accel_test.param.max_accel_con))
   set(findobj('tag',['max_spd_con_editbox']),'string',num2str(vinf.accel_test.param.max_speed_con))
   
   set(findobj('tag',['accel_time1_tol_editbox']),'string',num2str(vinf.accel_test.param.accel_time1_tol))
   set(findobj('tag',['accel_time2_tol_editbox']),'string',num2str(vinf.accel_test.param.accel_time2_tol))
   set(findobj('tag',['accel_time3_tol_editbox']),'string',num2str(vinf.accel_test.param.accel_time3_tol))
   set(findobj('tag',['dist_in_time_tol_editbox']),'string',num2str(vinf.accel_test.param.dist_in_time_tol))
   set(findobj('tag',['time_in_dist_tol_editbox']),'string',num2str(vinf.accel_test.param.time_in_dist_tol))
      set(findobj('tag',['max_accel_tol_editbox']),'string',num2str(vinf.accel_test.param.max_accel_tol))
   set(findobj('tag',['max_spd_tol_editbox']),'string',num2str(vinf.accel_test.param.max_speed_tol))

   set(findobj('tag','curnt_mass_textbox'),'string',num2str(evalin('base','veh_mass')));
   set(findobj('tag','override_mass_editbox'),'string',num2str(vinf.accel_test.param.override_mass));
   set(findobj('tag','add_mass_editbox'),'string',num2str(vinf.accel_test.param.add_mass));
   
   if isempty(findobj('tag','input_figure'))
      set(findobj('tag',['accel_time1_con_editbox']),'visible','off')
      set(findobj('tag',['accel_time2_con_editbox']),'visible','off')
      set(findobj('tag',['accel_time3_con_editbox']),'visible','off')
      set(findobj('tag',['dist_in_time_con_editbox']),'visible','off')
      set(findobj('tag',['time_in_dist_con_editbox']),'visible','off')
      set(findobj('tag',['max_accel_con_editbox']),'visible','off')
      set(findobj('tag',['max_spd_con_editbox']),'visible','off')
      
      set(findobj('tag',['accel_time1_tol_editbox']),'visible','off')
      set(findobj('tag',['accel_time2_tol_editbox']),'visible','off')
      set(findobj('tag',['accel_time3_tol_editbox']),'visible','off')
      set(findobj('tag',['dist_in_time_tol_editbox']),'visible','off')
      set(findobj('tag',['time_in_dist_tol_editbox']),'visible','off')
      set(findobj('tag',['max_accel_tol_editbox']),'visible','off')
      set(findobj('tag',['max_spd_tol_editbox']),'visible','off')

      set(findobj('tag',['accel_time1_con_label']),'visible','off')
      set(findobj('tag',['accel_time2_con_label']),'visible','off')
      set(findobj('tag',['accel_time3_con_label']),'visible','off')
      set(findobj('tag',['dist_in_time_con_label']),'visible','off')
      set(findobj('tag',['time_in_dist_con_label']),'visible','off')
      set(findobj('tag',['max_accel_con_label']),'visible','off')
      set(findobj('tag',['max_spd_con_label']),'visible','off')

      set(findobj('tag',['cond_label']),'visible','off')
      set(findobj('tag',['units_label']),'visible','off')
      set(findobj('tag',['constraints_label']),'visible','off')
   end

case 'help'
   load_in_browser('accel_test_help.html');

case 'defaults'

   button='PNGV';

   % clear the param field if it exists
   if isfield(vinf,'accel_test')
      vinf.accel_test=rmfield(vinf.accel_test,'param');
      % clear the results field if it exists
      if isfield(vinf.accel_test,'results')
         vinf.accel_test=rmfield(vinf.accel_test,'results');
      end 
      %button=questdlg('Select Vehicle Type','Vehicle Type','PNGV','Transit Bus','Heavy Truck','PNGV');
   end
   
   switch button
      
   case 'PNGV'
      
      % assign default values
      vinf.accel_test.param.active=[1 1 1 1 1 0 0 0 0 1 0 0 1 0 0];
      vinf.accel_test.param.gb_shift_delay=0.2;
      vinf.accel_test.param.spds1=[0 60];
      vinf.accel_test.param.spds2=[40 60];
      vinf.accel_test.param.spds3=[0 85];
      vinf.accel_test.param.dist_in_time=5;
      vinf.accel_test.param.time_in_dist=0.25;
      vinf.accel_test.param.disable_systems=0;
      vinf.accel_test.param.override_mass=evalin('base','veh_mass');
      vinf.accel_test.param.add_mass=0;
      
      vinf.accel_test.param.accel_time1_con=12.0;
      vinf.accel_test.param.accel_time2_con=5.3;
      vinf.accel_test.param.accel_time3_con=23.4;
      vinf.accel_test.param.dist_in_time_con=140;
      vinf.accel_test.param.time_in_dist_con=20;
      vinf.accel_test.param.max_accel_con=17;
      vinf.accel_test.param.max_speed_con=90;
      
            vinf.accel_test.param.accel_time1_tol=0.04;
      vinf.accel_test.param.accel_time2_tol=0.04;
      vinf.accel_test.param.accel_time3_tol=0.04;
      vinf.accel_test.param.dist_in_time_tol=0.4;
      vinf.accel_test.param.time_in_dist_tol=0.4;
      vinf.accel_test.param.max_accel_tol=0.4;
      vinf.accel_test.param.max_speed_tol=0.4;

      if isfield(vinf,'energy_storage')
          vinf.accel_test.param.active(2)=1;
          if evalin('base','exist(''cs_lo_soc'')')
              vinf.accel_test.param.ess_init_soc=evalin('base','mean([cs_lo_soc cs_hi_soc])');
          else
              vinf.accel_test.param.ess_init_soc=1;
          end
      else
          vinf.accel_test.param.active(2)=0;
          vinf.accel_test.param.ess_init_soc=0.5;
      end
  end
   
   AccelFigControl('load')
   
   case 'PNGV defaults'
   
   button='PNGV';
   
   % clear the param field if it exists
   if isfield(vinf,'accel_test')
      vinf.accel_test=rmfield(vinf.accel_test,'param');
      % clear the results field if it exists
      if isfield(vinf.accel_test,'results')
         vinf.accel_test=rmfield(vinf.accel_test,'results');
      end 
      %button=questdlg('Select Vehicle Type','Vehicle Type','PNGV','Transit Bus','Heavy Truck','PNGV');
   end
   
   switch button
      
   case 'PNGV'
      
      % assign default values
      vinf.accel_test.param.active=[1 1 1 1 1 1 0 1 1 1 0 0 1 0 0];
      vinf.accel_test.param.gb_shift_delay=0.2;
      vinf.accel_test.param.spds1=[0 60];
      vinf.accel_test.param.spds2=[40 60];
      vinf.accel_test.param.spds3=[0 85];
      vinf.accel_test.param.dist_in_time=5;
      vinf.accel_test.param.time_in_dist=0.25;
      vinf.accel_test.param.disable_systems=0;
      vinf.accel_test.param.override_mass=evalin('base','veh_mass');
      vinf.accel_test.param.add_mass=0;
      
      vinf.accel_test.param.accel_time1_con=12.0;
      vinf.accel_test.param.accel_time2_con=5.3;
      vinf.accel_test.param.accel_time3_con=23.4;
      vinf.accel_test.param.dist_in_time_con=140;
      vinf.accel_test.param.time_in_dist_con=20;
      vinf.accel_test.param.max_accel_con=17;
      vinf.accel_test.param.max_speed_con=90;
      
      vinf.accel_test.param.accel_time1_tol=0.04;
      vinf.accel_test.param.accel_time2_tol=0.04;
      vinf.accel_test.param.accel_time3_tol=0.04;
      vinf.accel_test.param.dist_in_time_tol=0.4;
      vinf.accel_test.param.time_in_dist_tol=0.4;
      vinf.accel_test.param.max_accel_tol=0.4;
      vinf.accel_test.param.max_speed_tol=0.4;
      
      if isfield(vinf,'energy_storage')
          vinf.accel_test.param.active(2)=1;
          if evalin('base','exist(''cs_lo_soc'')')
              vinf.accel_test.param.ess_init_soc=evalin('base','mean([cs_lo_soc cs_hi_soc])');
          else
              vinf.accel_test.param.ess_init_soc=1;
          end
      else
          vinf.accel_test.param.active(2)=0;
          vinf.accel_test.param.ess_init_soc=0.5;
      end
   end
   
   AccelFigControl('load')

case 'radiobuttonevent'
   
   % special cases
   % disable system disables for conventional and evs vehicles
   if strcmp(vinf.drivetrain.name,'conventional')|strcmp(vinf.drivetrain.name,'ev')
      set(findobj('tag',['disable_none_radiobutton']),'enable','off')
      set(findobj('tag',['disable_ess_radiobutton']),'enable','off')
      set(findobj('tag',['disable_fc_radiobutton']),'enable','off')
      
      set(findobj('tag',['disable_none_radiobutton']),'value',1)
      set(findobj('tag',['disable_ess_radiobutton']),'value',0)
      set(findobj('tag',['disable_fc_radiobutton']),'value',0)
   end
   
   % enable/disable SOC checkboxes and editboxes based on radiobutton settings
   if get(findobj('tag',['disable_ess_radiobutton']),'value')|strcmp(vinf.drivetrain.name,'conventional')
      set(findobj('tag',['ess_init_soc_editbox']),'enable','off')
      set(findobj('tag',['ess_init_soc_checkbox']),'value',0)
      set(findobj('tag',['ess_init_soc_checkbox']),'enable','off')
   else
      set(findobj('tag',['ess_init_soc_editbox']),'enable','on')
      set(findobj('tag',['ess_init_soc_checkbox']),'enable','on')
      set(findobj('tag',['ess_init_soc_checkbox']),'value',1)
   end
   
   if get(findobj('tag',['override_mass_radiobutton']),'value')
      set(findobj('tag',['override_mass_editbox']),'enable','on')
   else
      set(findobj('tag',['override_mass_editbox']),'enable','off')
   end
   
   if get(findobj('tag',['add_mass_radiobutton']),'value')
      set(findobj('tag',['add_mass_editbox']),'enable','on')
   else
      set(findobj('tag',['add_mass_editbox']),'enable','off')
   end
   
case 'checkboxevent'
   % enable and disable appropriate editboxes when the associate checkbox is selected
   
   for i=1:3
      if get(findobj('tag',['accel_time',num2str(i),'_checkbox']),'value')
         set(findobj('tag',['accel_time',num2str(i),'_spd1_editbox']),'enable','on')
         set(findobj('tag',['accel_time',num2str(i),'_spd2_editbox']),'enable','on')
         set(findobj('tag',['accel_time',num2str(i),'_con_editbox']),'enable','on')
         set(findobj('tag',['accel_time',num2str(i),'_tol_editbox']),'enable','on')
      else
         set(findobj('tag',['accel_time',num2str(i),'_spd1_editbox']),'enable','off')
         set(findobj('tag',['accel_time',num2str(i),'_spd2_editbox']),'enable','off')
         set(findobj('tag',['accel_time',num2str(i),'_con_editbox']),'enable','off')
         set(findobj('tag',['accel_time',num2str(i),'_tol_editbox']),'enable','off')
      end
   end
   if get(findobj('tag','time_in_dist_checkbox'),'value')
      set(findobj('tag','time_in_dist_editbox'),'enable','on')
      set(findobj('tag','time_in_dist_con_editbox'),'enable','on')
      set(findobj('tag','time_in_dist_tol_editbox'),'enable','on')
   else
      set(findobj('tag','time_in_dist_editbox'),'enable','off')
      set(findobj('tag','time_in_dist_con_editbox'),'enable','off')
      set(findobj('tag','time_in_dist_tol_editbox'),'enable','off')
   end
   if get(findobj('tag','dist_in_time_checkbox'),'value')
      set(findobj('tag','dist_in_time_editbox'),'enable','on')
      set(findobj('tag','dist_in_time_con_editbox'),'enable','on')
      set(findobj('tag','dist_in_time_tol_editbox'),'enable','on')
   else
      set(findobj('tag','dist_in_time_editbox'),'enable','off')
      set(findobj('tag','dist_in_time_con_editbox'),'enable','off')
      set(findobj('tag','dist_in_time_tol_editbox'),'enable','off')
   end
   if get(findobj('tag','max_accel_rate_checkbox'),'value')
      set(findobj('tag','max_accel_con_editbox'),'enable','on')
      set(findobj('tag','max_accel_tol_editbox'),'enable','on')
   else
      set(findobj('tag','max_accel_con_editbox'),'enable','off')
      set(findobj('tag','max_accel_tol_editbox'),'enable','off')
   end
   if get(findobj('tag','max_speed_checkbox'),'value')
      set(findobj('tag','max_spd_con_editbox'),'enable','on')
      set(findobj('tag','max_spd_tol_editbox'),'enable','on')
   else
      set(findobj('tag','max_spd_con_editbox'),'enable','off')
      set(findobj('tag','max_spd_tol_editbox'),'enable','off')
   end
   if get(findobj('tag','ess_init_soc_checkbox'),'value')
      set(findobj('tag','ess_init_soc_editbox'),'enable','on')
   else
      set(findobj('tag','ess_init_soc_editbox'),'enable','off')
   end
   if get(findobj('tag','gb_shift_delay_checkbox'),'value')
      set(findobj('tag','gb_shift_delay_editbox'),'enable','on')
   else
      set(findobj('tag','gb_shift_delay_editbox'),'enable','off')
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

%Revision History
% 7/14/00 ss created.
% 8/14/00:tm revised inputs parameters - added gb_shift_delay, limited speeds to three sets
% 8/14/00:tm fixed error with time_in_dist and dist_in_time - they were switched at times
% 8/15/00:tm updated order of defaults definition - required to work with results processing 
% 8/15/00:tm added defaults for PNGV, Transit Bus, and Heavy Truck
% 8/15/00:tm revised all speed related entries for 3 rather than 5 speed entries
% 8/15/00:tm store 3 speed pairs rather than one matrix - required to work with param.active and results processing
% 8/15/00:tm added case to handle function call when no inputs provided
% 8/15/00:tm added conditional to only run accel test from options window if execute figure was killed otherwise simply store user inputs
% 8/21/00:tm in case 'cancel' added conditional to only load execute figure if it doesn't already exist
% 8/21/00:tm in case 'load' added statement to set window style to 'modal'
% 11/16/00:tm revised implementation of max accel rate check box
% 11/16/00:tm added statements to handle max speed as a new input checkbox
% 1/24/01:tm added & isempty(findobj('tag','input_figure' to prevent running grade test on OK from input figure so that gui can be used with autosize
% 1/24/01:tm added initialization case
% 1/24/01:tm updated variable nameing to work with new accelfig
% 1/25/01:tm added isempty('input_figure in cancel case to prevent opening simsetupfig
% 1/29/01:tm added additional conditions to running test from here and opening results fig from here
% 1/29/01:tm added case 'PNGV Defaults'
% 1/29/01:tm removed transit bus and heavy truck cases
% 1/29/01:tm added default tolerances for constraints
% 1/29/01:tm fixed settings for conv and evs
% 6/25/01:tm mass and disabled systems radiobutton values were saved in the incorrect order when saved
%            to the vinf.accel_test.param.active matrix - mass effects not active when run as a performance attribute
%				 rather than a test.  Moved all enable systems values before all mass values in .active matrix to fix problem.
% 10/18/01:mpo added dialogue box to help users with custom drivetrains to use accel features
% 2/15/02: ss replaced ResultsFigControl with ResultsFig
% 041802:tm changed conditional for ess_init_soc initialization to be based on energy storage field rather than drivetrain name
% 04/18/02:tm added conditional for ess_init_soc value if cs_lo_soc does not exist
% 8/28/03:ss & tm removed close figure requests when the defaults or pngv
% buttons were pushed.  Unneccessary and caused problems with autosize and
% 'run'.
