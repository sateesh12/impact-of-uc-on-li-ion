function gui_run_files(option)

%function gui_run_files()    ADVISOR 
%This function first runs all the currently selected files associated with
%the input_figure and then
%updates the list of variables that can be viewed
%and modified in the input figure window.


global vinf

if nargin>0
    
    %the following is used to determine if autosize has just run
    %here it is set to zero because it has not just run.  Originally
    %this is used in conjuction with vinf.targets.accel_0_85 for 
    %determining how long to run the accel test for.
    
    if (strcmp(option,'load')|strcmp(option,'calc_total_mass')|strcmp(option,'edit_mod_var'))
        eval('h=vinf.autosize_run_status; test4exist=1;','test4exist=0;')
        if ~test4exist
            vinf.autosize_run_status=0;
            
            %clear vinf.autosize field  if exists
            eval('h=vinf.autosize; test4exist=1;','test4exist=0;');%check if vinf.autosize exists
            if test4exist
                vinf=rmfield(vinf,'autosize');
            end
            
            %clear vinf.control_strategy field  if exists
            eval('h=vinf.control_strategy; test4exist=1;','test4exist=0;');%check if vinf.autosize exists
            if test4exist
                vinf=rmfield(vinf,'control_strategy');
            end
        end
    else
        vinf.autosize_run_status=0;
        
        %clear vinf.autosize field  if exists
        eval('h=vinf.autosize; test4exist=1;','test4exist=0;');%check if vinf.autosize exists
        if test4exist
            vinf=rmfield(vinf,'autosize');
        end
        
        %clear vinf.control_strategy field  if exists
        eval('h=vinf.control_strategy; test4exist=1;','test4exist=0;');%check if vinf.autosize exists
        if test4exist
            vinf=rmfield(vinf,'control_strategy');
        end
    end
    
    
    switch option
    case 'load'
        
        if ~isfield(vinf,'run_without_gui')&strcmp(gui_current_str('drivetrain'),'insight')
            %button=questdlg({'You have selected the preliminary Honda Insight model',...
            %      'This model is based on data from published sources, but is not yet complete.',...
            %      '','For additional information on the Insight model select HELP.'},...
            %   'Insight Help','OK','HELP','OK');
            %if strcmp(button,'HELP')
            %   load_in_browser('InsightHelp.html');
            %end
            
            if exist('insight_msg.m')
                assignin('base','dont_show',0);
                [vdoc_image,vdoc_image_map] = evalin('base','imread(''advisor.bmp'',''bmp'')');
                h_msg=msgbox({'You have selected a vehicle model of the Honda Insight. ',...
                        'This model is based on test data from the National Renewable Energy Laboratory and Argonne National Laboratory and data from published sources.',...
                        '','For additional information on the Insight model select HELP.'},'Insight Message','custom',vdoc_image,vdoc_image_map);
                ok_pos=get(findobj('string','OK'),'position');
                new_pos=ok_pos;
                new_pos(1)=150;
                set(findobj('string','OK'),'position',new_pos)
                set(h_msg,'windowstyle','modal')
                h1 = uicontrol('Parent',h_msg, ...
                    'Callback','dont_show=get(findobj(''tag'',''insight_msg_checkbox''),''value'');', ...
                    'Position',[10 10 165 20], ...
                    'String','Don''t show this message again.', ...
                    'Style','checkbox', ...
                    'Tag','insight_msg_checkbox',...
                    'Value',evalin('base','dont_show'));
                h1 = uicontrol('Parent',h_msg, ...
                    'Callback','close; load_in_browser(''honda_insight.html'');', ...
                    'Position',[270 10 50 27], ...
                    'String','HELP', ...
                    'Style','pushbutton', ...
                    'Tag','insight_help_pushbutton');
                uiwait(h_msg)
                if evalin('base','dont_show')==1
                    path_old=evalin('base','which(''insight_msg.m'')');
                    name_new='insight_ms_.m';
                    evalin('base',['!rename "',path_old,'" ',name_new,''])
                end
                evalin('base','clear dont_show')
            end
            
            
        end
        if ~isfield(vinf,'run_without_gui')&strcmp(gui_current_str('drivetrain'),'prius_jpn')
            
            if exist('prius_msg.m')
                assignin('base','dont_show',0);
                [vdoc_image,vdoc_image_map] = evalin('base','imread(''advisor.bmp'',''bmp'')');
                h_msg=msgbox({'You have selected the Toyota Prius_jpn model',...
                        'This model is based on data from published sources and NREL and ANL test data'},...
                    'Prius Message','custom',vdoc_image,vdoc_image_map);
                ok_pos=get(findobj('string','OK'),'position');
                new_pos=ok_pos;
                new_pos(1)=150;
                set(findobj('string','OK'),'position',new_pos)
                set(h_msg,'windowstyle','modal')
                h1 = uicontrol('Parent',h_msg, ...
                    'Callback','dont_show=get(findobj(''tag'',''prius_msg_checkbox''),''value'');', ...
                    'Position',[10 10 165 20], ...
                    'String','Don''t show this message again.', ...
                    'Style','checkbox', ...
                    'Tag','prius_msg_checkbox',...
                    'Value',evalin('base','dont_show'));
                uiwait(h_msg)
                if evalin('base','dont_show')==1
                    path_old=evalin('base','which(''prius_msg.m'')');
                    name_new='prius_ms_.m';
                    evalin('base',['!rename "',path_old,'" ',name_new,''])
                end
                evalin('base','clear dont_show')
            end
            
            
        end
        
        
        %--------------------------   
        %clear all the variables in the 'base' workspace, do not delete any global variables
        evalin('base','clear');
        evalin('base','global vinf');
        
        %what drivetrain is currently selected?
        drivetrain=vinf.drivetrain.name;
        
        try, vinf.test.vars=[]; end
        
        %based on which drivetrain is selected run the appropriate files and variables
        %in the 'base' workspace.
        
        %_________generic running of files for all cases.
        
        % run fuel_converter
        if isfield(vinf,'fuel_converter'); evalin('base',['run ',vinf.fuel_converter.name]); end
        
        % run generator file
        if isfield(vinf,'generator'); evalin('base',['run ',vinf.generator.name]); end
        
        %run motor_controller file
        if isfield(vinf,'motor_controller'); evalin('base',['run ',vinf.motor_controller.name]);end
        
        %run energy_storage file
        if isfield(vinf,'energy_storage');  evalin('base',['run ',vinf.energy_storage.name]); end
        
        %run energy_storage file
        if isfield(vinf,'energy_storage2');  evalin('base',['run ',vinf.energy_storage2.name]); end
        
        %run wheel_axle file
        if isfield(vinf,'wheel_axle'); evalin('base',['run ',vinf.wheel_axle.name]); end
        
        %run vehicle file
        if isfield(vinf,'vehicle'); evalin('base',['run ',vinf.vehicle.name]); end
        
        % run accessory file
        if isfield(vinf,'accessory'); evalin('base',['run ',vinf.accessory.name]); end
        
        % load modified variables into workspace      
        run_modified_variables;
        
        %calc max fc power for use in exhaust
        if isfield(vinf,'fuel_converter'); 
            assignin('base','fc_max_pwr',calc_max_pwr('fuel_converter'))
            if evalin('base','~exist(''fc_fuel_cell_model'')')
                evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale;')
            end
            %pre_calcs('calc_fc_max_pwr'); replaced with statements above
        end
        
        %run exhaust_aftertreatment file
        if isfield(vinf,'exhaust_aftertreat'); evalin('base',['run ',vinf.exhaust_aftertreat.name]); end
        
        %run transmission file
        if isfield(vinf,'transmission'); evalin('base',['run ',vinf.transmission.name]); end
        
        %run torque_coupling file  , tm: important that this is after mc so that it can use gb_ratios
        if isfield(vinf,'torque_coupling'); evalin('base',['run ',vinf.torque_coupling.name]); end 
        
        % run powertrain_control file
        if isfield(vinf,'powertrain_control'); evalin('base',['run ',vinf.powertrain_control.name]); end
        
        %________end generic running of files
        
        
        % setup default sim control parameters
        if evalin('base','~exist(''fc_on'')')
            assignin('base','fc_on',1);
        end
        if evalin('base','~exist(''ess_on'')')
            if isfield(vinf,'fuel_converter') & ~isfield(vinf,'energy_storage')
                assignin('base','ess_on',0);
            else 
                assignin('base','ess_on',1);
            end
        end
        assignin('base','gb_num_init',1); %tm 3/31/00
        if strcmp(vinf.drivetrain.name,'ev')
            assignin('base','enable_stop',1);
        else
            assignin('base','enable_stop',0);
        end
        
        %Path to save misc. files under
        pathstr = fileparts(which('advisor.m'));
        vinf.tmppath=fullfile(pathstr, 'tmp');
        
        % tm:1/3/00 added a defaults for use with j1711
        assignin('base','enable_speed_scope',0); 
        assignin('base','enable_stop_fc',0); 
        assignin('base','j17_endtimes',[inf inf]);
        %---
        
        % tm:7/18/00 added defaults for use with accel_test_advanced
        assignin('base','enable_sim_stop_speed',0); 
        assignin('base','sim_stop_speed',inf);
        assignin('base','enable_sim_stop_distance',0); 
        assignin('base','sim_stop_distance',inf);
        assignin('base','enable_sim_stop_time',0); 
        assignin('base','sim_stop_time',inf);
        %---
        
        % tm:11/16/00 added defaults for use with accel_test_advanced
        assignin('base','enable_sim_stop_max_spd',0); 
        %---
        
        % tm:12/10/00 added defaults for use with autosize
        if ~isfield(vinf,'time_step')
            vinf.time_step=1;
        end
        %---
        
        % tm:1/23/01 added defaults for use with autosize
        if ~isfield(vinf,'interactive_sim')
            vinf.interactive_sim=0;
        end
        %---
        
        %set up the variable list on the input figure
        if ~isfield(vinf,'run_without_gui') ;
            variable_selection %ss replaced update_var_list (subfunction)1/15/01
        end
        
        run_modified_variables; %subfunction ss 10/7/99
        
        gui_edit_var('update');%make sure the variable value displays correctly
        
        if strcmp(drivetrain,'custom')|strcmp(drivetrain,'series')|strcmp(drivetrain,'fuel_cell') % added or custom (tm:12/14/99)
            adjust_cs; %updates the cs_spd and cs_pwr vectors
        end
        
        %4/6/99 ss added 4/7/99 mc: added if and end statements
        if evalin('base','exist(''fc_trq_scale'')') & evalin('base','exist(''fc_spd_scale'')')
            evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale;')
        end
        
        if isfield(vinf,'fuel_converter')
            %fc max power
            fc_max_pwr=calc_max_pwr('fuel_converter');
            vinf.fuel_converter.def_max_pwr=fc_max_pwr/evalin('base','fc_trq_scale*fc_spd_scale');
            set(findobj('tag','fc_max_pwr'),'string',num2str(round(fc_max_pwr)));
            
            %fc max efficiency
            fc_peak_eff=round(calc_max_eff('fuel_converter')*100)/100;
            vinf.fuel_converter.def_peak_eff=fc_peak_eff;
%             if evalin('base','fc_eff_scale')~=1
%                 eff_scaling('fc')
%             end
            fc_peak_eff=fc_peak_eff*evalin('base','fc_eff_scale');
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                set(findobj('tag','fc_peak_eff'),'string',num2str(round(fc_peak_eff*100)/100));
            end
            
            %disable max power and eff edit boxes if VT,KTH, or gctool
            if strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
                set(findobj('tag','fc_max_pwr'),'enable','off')
                set(findobj('tag','fc_peak_eff'),'enable','off')
            else
                set(findobj('tag','fc_max_pwr'),'enable','on')
                set(findobj('tag','fc_peak_eff'),'enable','on')
            end

            
            
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                if strcmp(vinf.drivetrain.name,'prius_jpn')&strcmp(evalin('base','fc_fuel_type'),'Gasoline')
                    set(findobj('tag','fuel_type'),'string',{'Gas-';'oline'})
                else
                    set(findobj('tag','fuel_type'),'string',evalin('base','fc_fuel_type'));
                end
                
            end
            
        end
        
        if isfield(vinf,'motor_controller')
            %mc max power
            mc_max_pwr=calc_max_pwr('motor_controller');
            vinf.motor_controller.def_max_pwr=mc_max_pwr/evalin('base','mc_trq_scale*mc_spd_scale');
            set(findobj('tag','mc_max_pwr'),'string',num2str(round(mc_max_pwr)));
            
            %mc max eff
            mc_peak_eff=round(calc_max_eff('motor_controller')*100)/100;
            vinf.motor_controller.def_peak_eff=mc_peak_eff;
            mc_peak_eff=mc_peak_eff*evalin('base','mc_eff_scale');
%             if evalin('base','mc_eff_scale')~=1
%                 eff_scaling('mc');
%             end
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                set(findobj('tag','mc_peak_eff'),'string',num2str(round(mc_peak_eff*100)/100));
            end
            
        end
        if isfield(vinf,'generator')
            gc_max_pwr=calc_max_pwr('generator');
            if evalin('base','exist(''gc_trq_scale'')') & evalin('base','exist(''gc_spd_scale'')')
                vinf.generator.def_max_pwr=gc_max_pwr/evalin('base','gc_trq_scale*gc_spd_scale');
            elseif evalin('base','exist(''gc_max_pwr'')')
                vinf.generator.def_max_pwr=gc_max_pwr/evalin('base','gc_max_pwr');
            end
            if isa(gc_max_pwr,'char')
                set(findobj('tag','gc_max_pwr'),'string',gc_max_pwr);
                if strcmp(gc_max_pwr,'na')
                    set(findobj('tag','gc_max_pwr'),'enable','off');
                end
            else
                set(findobj('tag','gc_max_pwr'),'string',num2str(round(gc_max_pwr)));
            end
            
            %gc max eff
            gc_calc_max_eff=calc_max_eff('generator');
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                if isa(gc_calc_max_eff,'char')
                    set(findobj('tag','gc_peak_eff'),'string',gc_calc_max_eff);
                else
                    gc_peak_eff=round(gc_calc_max_eff*100)/100;
                    set(findobj('tag','gc_peak_eff'),'string',num2str(round(gc_peak_eff*100)/100));
                end
            end
            
        end
        
        if isfield(vinf,'energy_storage')
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                ess_module_number=evalin('base','ess_module_num');
                set(findobj('tag','ess_num_modules'),'string',num2str(ess_module_number));
                volt=evalin('base','mean(mean(ess_voc))');
                set(findobj('tag','ess_voltage'),'string',num2str(round(ess_module_number*volt)));
            end
            
        end
        
        if isfield(vinf,'energy_storage2')
            if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
                ess2_module_number=evalin('base','ess2_module_num');
                set(findobj('tag','ess2_num_modules'),'string',num2str(ess2_module_number));
                volt2=evalin('base','mean(mean(ess2_voc))');
                set(findobj('tag','ess2_voltage'),'string',num2str(round(ess2_module_number*volt2)));
            end
            
        end
                
        if isfield(vinf,'wheel_axle')
            if ~isfield(vinf,'run_without_gui') 
                %set up the four wheel drive radio buttons
                if evalin('base','wh_front_active_bool')==1 & evalin('base','wh_rear_active_bool')==1
                    set(findobj('tag','front_wheel_drive'),'value',0)
                    set(findobj('tag','rear_wheel_drive'),'value',0)
                    set(findobj('tag','four_wheel_drive'),'value',1)
                else
                    set(findobj('tag','front_wheel_drive'),'value',evalin('base','wh_front_active_bool'))
                    set(findobj('tag','rear_wheel_drive'),'value',evalin('base','wh_rear_active_bool'))
                    set(findobj('tag','four_wheel_drive'),'value',0)
                end
            end
            
        end

        recompute_mass
        
        if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
            %--gearbox efficiency scaling
            if ~strcmp(vinf.transmission.ver,'pgcvt') %~prius cvt
                tx_peak_eff=round(calc_max_eff('transmission')*100)/100;
                vinf.transmission.def_peak_eff=tx_peak_eff;
                tx_peak_eff=tx_peak_eff*evalin('base','gb_eff_scale');
                if evalin('base','gb_eff_scale')~=1
                    eff_scaling('gb')
                end
                set(findobj('tag','tx_peak_eff'),'string',num2str(round(tx_peak_eff*100)/100))   
            else
                % reset the file name   
            end
        end
        
        %set up the variable list on the input figure
        if ~isfield(vinf,'run_without_gui') ;
            variable_selection %ss replaced update_var_list (subfunction) 1/15/01
        end
        
        if ~isfield(vinf,'run_without_gui') ;%ss 4/28/99
            if strcmp(vinf.drivetrain.name,'prius_jpn')&strcmp(evalin('base','fc_fuel_type'),'Gasoline')
                set(findobj('tag','fuel_type'),'string',{'Gas-';'oline'})
            elseif evalin('base','exist(''fc_fuel_type'')')
                set(findobj('tag','fuel_type'),'string',evalin('base','fc_fuel_type'));
            end
            
        end
        
    case 'drivetrain'
        
        file_name=[upper(vinf.drivetrain.name),'_defaults_in'];
        close(gcf)
        
        try
            temp=vinf.gui_size;
        end
        temp2=vinf.units;
        
        if isfield(vinf.drivetrain,'name_prev')
            temp3=vinf.drivetrain.name_prev;
        end
        temp4=vinf.name;   
        
        %clear vinf if present
        clear global vinf
        
        global vinf
        
        if exist('temp3')
            vinf.drivetrain.name_prev=temp3;
        end
        vinf.name_prev=temp4;
        
        clear temp3
        
        if exist('temp')
            vinf.gui_size=temp; %reassign the variable vinf.gui_size
        end
        vinf.units=temp2;
        
        %Run the file associated with the drivetrain selection
        eval(['run ''',file_name,'''']);
        
        %-------------------------------------
        
        vinf.name=file_name;
        
        if ~isfield(vinf, 'model')
            vinf.model='ADVISOR';
        end
        
        %Run the function that opens the input figure
        InputFig;
        
        % if drivetrain type is custom let user pick the block diagram to use and components to load (12/14/99:tm)
        if ~isfield(vinf,'run_without_gui')&&strcmp(gui_current_str('drivetrain'),'custom')
            loop=1;
            while loop
                uiwait(warndlg('Please specify block diagram to be used in analysis.','Block Diagram Selection'));
                [f,p]=uigetfile('*.mdl');
                if f==0 % user hit cancel
                    
                    close(findobj('tag','input_figure'))
                    gui_input_open(vinf.name_prev)
                    
                    
                    %set(findobj('tag','drivetrain'),'value',optionlist('value','drivetrain',vinf.drivetrain.name_prev))
                    %vinf.drivetrain.name=vinf.drivetrain.name_prev;
                    %gui_image
                    return
                elseif evalin('base',['exist(''',f,''')']) % file selected and in path
                    vinf.block_diagram.name=strrep(f,'.mdl','');
                    loop=0;
                else % file not in path
                    uiwait(warndlg('Selected file not in current Matlab path.','Block Diagram Selection Error'));
                    loop=1;
                end
            end
            % insert lines of code to allow user to specify which components to load
        end
        
    case 'fuel_converter'
        %For NOx Absorber, only allow the pick with CI60_emis and CI67_emis
        % (these two have oxygen flow defined)
        if strcmp(vinf.exhaust_aftertreat.name,'EX_CI_OxCat') | strcmp(vinf.exhaust_aftertreat.name,'EX_CI_OxCat_DPF')
            if ~(strcmp(vinf.fuel_converter.name,'FC_CI60_emis') | strcmp(vinf.fuel_converter.name,'FC_CI67_emis'))
                h=msgbox('Note: Oxidation Catalyst only runs with FC_CI60_emis and FC_CI67_emis.  Returning to previous choice.');
                set(h,'WindowStyle','modal');
                %Set the fc choice to previous choice
                vinf.fuel_converter.name=vinf.fuel_converter.prev_name;
                fc_hdl=findobj('tag','fuel_converter');
                fc_str_list=get(fc_hdl,'string');
                set(fc_hdl,'value',find(strcmp(fc_str_list,vinf.fuel_converter.prev_name)));
            end
        end
        
        
        if isfield(vinf.fuel_converter,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.fuel_converter.prev_name);
        end
        
        evalin('base',['clear ',vinf.fuel_converter.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        evalin('base',['run ',vinf.fuel_converter.name]);
        
        %The following added to make sure that generator is sized for fuel converter selected
        if strcmp(vinf.drivetrain.name,'series')
            gc_fc_size('fuel_converter')
            %if returned to old file commented out 9/19/99 by ss for proper resetting of edited variables if exist
            %if strcmp(vinf.fuel_converter.name,vinf.fuel_converter.prev_name)
            %return;%return without running the rest of the case
            %end
        end
        %END OF GENERATOR sizing for use with FUEL CONVERTER
        
        %run the gearbox component, torque coupling, exhaust components, and
        %powertrain control(series) because they depend on the fuel converter
        gui_run_files('transmission');
        %if ~strcmp(vinf.drivetrain.name,'conventional')&~strcmp(vinf.drivetrain.name,'prius_jpn')
        if strcmp(vinf.drivetrain.name,'parallel')
            gui_run_files('torque_coupling');
        end;   
        gui_run_files('exhaust_aftertreat');
        
        
        %fc max power
        fc_max_pwr=calc_max_pwr('fuel_converter');
        vinf.fuel_converter.def_max_pwr=fc_max_pwr/evalin('base','fc_trq_scale*fc_spd_scale');
        set(findobj('tag','fc_max_pwr'),'string',num2str(round(fc_max_pwr)));
        
        
        %fc max eff
        fc_peak_eff=round(100*calc_max_eff('fuel_converter'))/100;
        vinf.fuel_converter.def_peak_eff=fc_peak_eff;
        fc_peak_eff=fc_peak_eff*evalin('base','fc_eff_scale');
%         if evalin('base','fc_eff_scale')~=1
%             eff_scaling('fc')
%         end
        set(findobj('tag','fc_peak_eff'),'string',num2str(round(fc_peak_eff*100)/100));
        
        %fc mass
        fc_mass=evalin('base','fc_mass'); 
        set(findobj('tag','fc_mass'),'string',num2str(round(fc_mass)));
        vinf.fuel_converter.def_mass=fc_mass; 
        
        if strcmp(vinf.drivetrain.name,'prius_jpn')&strcmp(evalin('base','fc_fuel_type'),'Gasoline')
            set(findobj('tag','fuel_type'),'string',{'Gas-';'oline'})
        else
            set(findobj('tag','fuel_type'),'string',evalin('base','fc_fuel_type'));
        end
        
        %disable max power and eff edit boxes if VT,KTH, or gctool
        if strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
            set(findobj('tag','fc_max_pwr'),'enable','off')
            set(findobj('tag','fc_peak_eff'),'enable','off')
        else
            set(findobj('tag','fc_max_pwr'),'enable','on')
            set(findobj('tag','fc_peak_eff'),'enable','on')
        end
            
        gui_run_files('powertrain_control');%sam moved from beginning of fc case to here 9/16/98
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'generator'
        
        evalin('base','clear gc_*');
        
        if isfield(vinf.generator,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.generator.prev_name);
        end
        
        evalin('base',['clear ',vinf.generator.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        evalin('base',['run ',vinf.generator.name]);
        
        if evalin('base','exist(''gc_trq_scale'')') & evalin('base','exist(''gc_spd_scale'')')
            %The following added to make sure that generator is sized for fuel converter selected
            if strcmp(vinf.drivetrain.name,'series')
                gc_fc_size('generator')
                %if returned to old file
                if strcmp(vinf.generator.name,vinf.generator.prev_name)
                    return;%return without running the rest of the case
                end
            end
            %END OF GENERATOR sizing for use with FUEL CONVERTER
            
            %gc max power
            gc_max_pwr=calc_max_pwr('generator');
            vinf.generator.def_max_pwr=gc_max_pwr/evalin('base','gc_trq_scale*gc_spd_scale');
            set(findobj('tag','gc_max_pwr'),'string',num2str(round(gc_max_pwr)),'enable','on');
            
            %gc max eff
            gc_peak_eff=round(100*calc_max_eff('generator'))/100;
            vinf.generator.def_peak_eff=gc_peak_eff;
            set(findobj('tag','gc_peak_eff'),'string',num2str(gc_peak_eff));
            
            %gc mass
            gc_mass=evalin('base','gc_mass'); 
            set(findobj('tag','gc_mass'),'string',num2str(round(gc_mass)));
            vinf.generator.def_mass=gc_mass; 
        elseif evalin('base','exist(''gc_max_pwr'')')
            gc_max_pwr=evalin('base','gc_max_pwr');
            vinf.generator.def_max_pwr=gc_max_pwr;
            gc_geneff=evalin('base','gc_geneff');
            vinf.generator.def_peak_eff=gc_geneff;
            gc_mass=evalin('base','gc_mass');
            vinf.generator.def_mass=gc_mass;
            
            set(findobj('tag','gc_max_pwr'),'string',num2str(round(gc_max_pwr)),'enable','on');
            set(findobj('tag','gc_peak_eff'),'string',num2str(gc_geneff));
            set(findobj('tag','gc_mass'),'string',num2str(round(gc_mass)));
            
        else
            set(findobj('tag','gc_max_pwr'),'string','na','enable','off');
            set(findobj('tag','gc_peak_eff'),'string','na');
            set(findobj('tag','gc_mass'),'string',num2str(round(evalin('base','gc_mass'))));
            
        end
        
        recompute_mass;
        gui_run_files('powertrain_control');%sam added 9/16/98
        gui_run_files('edit_mod_var');
        
    case 'torque_coupling'
        if isfield(vinf.torque_coupling,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.torque_coupling.prev_name);
        end
        
        evalin('base',['clear ',vinf.torque_coupling.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        evalin('base',['run ',vinf.torque_coupling.name]);
        
        check2run_ptc(option);
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'motor_controller'
        
        if isfield(vinf.motor_controller,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.motor_controller.prev_name);
        end
        
        evalin('base',['clear ',vinf.motor_controller.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory            
        evalin('base',['run ',vinf.motor_controller.name]);
        %run the gearbox component and torque coupling component
        %because it depends on the motor controller
        %5 spd series tx will have fd reset to 1 as of 7/26/99 ss,kw
        % 1 spd calculates gb_ratio for max speed but 5 spd doesn't
        if strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')
            gui_run_files('transmission');
        end 
        
        if strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'parallel_sa')|strcmp(vinf.drivetrain.name,'insight') % tm:7/11/00 added |parallel_sa and |insight 
            gui_run_files('torque_coupling')
        end
        
        %mc max power
        mc_max_pwr=calc_max_pwr('motor_controller');
        vinf.motor_controller.def_max_pwr=mc_max_pwr/evalin('base','mc_trq_scale*mc_spd_scale');
        set(findobj('tag','mc_max_pwr'),'string',num2str(round(mc_max_pwr)));
        
        %mc max eff
        mc_peak_eff=round(100*calc_max_eff('motor_controller'))/100;
        vinf.motor_controller.def_peak_eff=mc_peak_eff;
        mc_peak_eff=mc_peak_eff*evalin('base','mc_eff_scale');
%         if evalin('base','mc_eff_scale')~=1
%             eff_scaling('mc')
%         end
        set(findobj('tag','mc_peak_eff'),'string',num2str(round(mc_peak_eff*100)/100));
        
        %mc mass
        mc_mass=evalin('base','mc_mass'); 
        
        set(findobj('tag','mc_mass'),'string',num2str(round(mc_mass)));
        vinf.motor_controller.def_mass=mc_mass;
        
        gui_run_files('powertrain_control');%sam added 9/16/98
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'exhaust_aftertreat'
        %For NOx Absorber, only allow the pick with CI60_emis and CI67_emis
        % (these two have oxygen flow defined)
        if strcmp(vinf.exhaust_aftertreat.name,'EX_CI_OxCat') | strcmp(vinf.exhaust_aftertreat.name,'EX_CI_OxCat_DPF')
            if ~(strcmp(vinf.fuel_converter.name,'FC_CI60_emis') | strcmp(vinf.fuel_converter.name,'FC_CI67_emis'))
                h=msgbox('Note: Oxidation Catalyst only runs with FC_CI60_emis and FC_CI67_emis.  Returning to previous choice.');
                set(h,'WindowStyle','modal');
                %Set the ex choice to previous choice
                vinf.exhaust_aftertreat.name=vinf.exhaust_aftertreat.prev_name;
                ex_hdl=findobj('tag','exhaust_aftertreat');
                ex_str_list=get(ex_hdl,'string');
                set(ex_hdl,'value',find(strcmp(ex_str_list,vinf.exhaust_aftertreat.prev_name)));
            end
        end
        
        if isfield(vinf.exhaust_aftertreat,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.exhaust_aftertreat.prev_name);
        end
        
        assignin('base','fc_max_pwr',calc_max_pwr('fuel_converter'))
        if evalin('base','~exist(''fc_fuel_cell_model'')')
            evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale;')
        end
        %pre_calcs('calc_fc_max_pwr'); replaced with statements above
        evalin('base',['clear ',vinf.exhaust_aftertreat.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        evalin('base',['run ',vinf.exhaust_aftertreat.name]);
        
        %exhaust mass
        ex_mass=evalin('base','round(ex_mass*fc_pwr_scale)');
        set(findobj('tag','ex_mass'),'string',num2str(ex_mass));
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'transmission'
        
        %ss added 2/12/01 to clear pre existing variables
        evalin('base','clear tx* gb* htc* fd*')
        assignin('base','gb_num_init',1); %ss added 2/12/01, this was previously only in load case
        assignin('base','gb_shift_delay',0); %ss added 2/12/01
        
        if isfield(vinf.transmission,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.transmission.prev_name);
        end
        
        %run fuel converter file if an automatic transmission and then reload the modified variables.
        % this is because the auto transmission adds inertia to the fuel converter fc_inertia.
        if strcmp(vinf.transmission.ver,'auto') %ss 2/12/01 changed to 'auto' from 'v02'
            evalin('base','run(vinf.fuel_converter.name)')
            run_modified_variables
        end
        
        %these are used for setting the current PTC file name in the popup menu.
        version=vinf.powertrain_control.ver;
        type=vinf.powertrain_control.type;
        
        evalin('base',['clear ',vinf.transmission.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory            
        evalin('base',['run ',vinf.transmission.name]);
        
        if ~strcmp(vinf.transmission.ver,'pgcvt')% ~prius CVT
            % tx eff
            tx_peak_eff=round(100*calc_max_eff('transmission'))/100;
            vinf.transmission.def_peak_eff=tx_peak_eff;
            tx_peak_eff=tx_peak_eff*evalin('base','gb_eff_scale');
            if evalin('base','gb_eff_scale')~=1
                eff_scaling('gb')
            end
            set(findobj('tag','tx_peak_eff'),'string',num2str(round(tx_peak_eff*100)/100))   
        end
        
        %gearbox mass
        tx_mass=evalin('base','round(tx_mass)');
        set(findobj('tag','tx_mass'),'string',num2str(tx_mass));
        
        if 0
            %section to select proper powertrain control
            if tx_type==3 % cvt
                if strcmp(vinf.drivetrain.name,'conventional')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_CONVCVT',version,type))
                    vinf.powertrain_control.name='PTC_CONVCVT';
                elseif strcmp(vinf.drivetrain.name,'prius_jpn')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_PRIUS_JPN',version,type))
                    vinf.powertrain_control.name='PTC_PRIUS_JPN';
                elseif strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'parallel_sa')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_PAR_CVT',version,type))
                    vinf.powertrain_control.name='PTC_PAR_CVT';
                else
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_CONVCVT',version,type))
                    vinf.powertrain_control.name='PTC_CONVCVT';
                end
            elseif tx_type==2 % auto
                if strcmp(vinf.drivetrain.name,'conventional')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_CONVAT',version,type))
                    vinf.powertrain_control.name='PTC_CONVAT';
                elseif 0
                    % add statements later
                else
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_CONVAT',version,type))
                    vinf.powertrain_control.name='PTC_CONVAT';
                end
            elseif tx_type==4 % prius cvt
                if strcmp(vinf.drivetrain.name,'prius_jpn')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_PRIUS_JPN',version,type))
                    vinf.powertrain_control.name='PTC_PRIUS_JPN';
                elseif 0
                    % add statements later
                else
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_PRIUS_JPN',version,type))
                    vinf.powertrain_control.name='PTC_PRIUS_JPN';
                end
            elseif tx_type==1 % manual
                if strcmp(vinf.drivetrain.name,'conventional')
                    set(findobj('tag','powertrain_control'),'value',optionlist('value','powertrain_control','PTC_CONV',version,type))
                    vinf.powertrain_control.name='PTC_CONV';
                end
            end
        end; %if 0
        
        gui_run_files('powertrain_control');%ss added 10/13/98
        recompute_mass
        gui_run_files('edit_mod_var');
        
        
    case 'wheel_axle'
        
        if isfield(vinf.wheel_axle,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.wheel_axle.prev_name);
        end
        
        
        evalin('base',['clear ',vinf.wheel_axle.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory            
        evalin('base',['run ',vinf.wheel_axle.name]);
        
        %run the gearbox component because it depends on the wheel_axle only if series and output a warning.
        if strcmp(vinf.drivetrain.name,'series')
            evalin('base',['run ',vinf.transmission.name]);
            disp('WARNING!! Transmission file was run which may have reset variables such as fd_ratio')
        end
        
        %set up the four wheel drive radio buttons
        if evalin('base','wh_front_active_bool')==1 & evalin('base','wh_rear_active_bool')==1
            set(findobj('tag','front_wheel_drive'),'value',0)
            set(findobj('tag','rear_wheel_drive'),'value',0)
            set(findobj('tag','four_wheel_drive'),'value',1)
        else
            set(findobj('tag','front_wheel_drive'),'value',evalin('base','wh_front_active_bool'))
            set(findobj('tag','rear_wheel_drive'),'value',evalin('base','wh_rear_active_bool'))
            set(findobj('tag','four_wheel_drive'),'value',0)
        end
        
        set(findobj('tag','wh_mass'),'string',num2str(evalin('base','round(wh_mass)')));
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'vehicle'
        
        if isfield(vinf.vehicle,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.vehicle.prev_name);
        end
        
        
        evalin('base',['clear ',vinf.vehicle.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        evalin('base',['run ',vinf.vehicle.name]);
        
        set(findobj('tag','veh_mass'),'string',num2str(evalin('base','round(veh_glider_mass)')));
        
        %update cargo mass in gui
        set(findobj('tag','cargo_mass'),'string',num2str(round(evalin('base','veh_cargo_mass'))));
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'energy_storage'
        %don't allow nnet or fund battery model to be used with prius
        %         if strcmp(vinf.drivetrain.name,'prius_jpn')
        %             ess_name=vinf.energy_storage.name;
        %             if strcmp(ess_name,'ESS_PB12_nnet')|strcmp(ess_name,'ESS_PB16_fund_optima')|strcmp(ess_name,'ESS_PB16_fund_generic')
        %                 vinf.energy_storage.name=vinf.energy_storage.prev_name;
        %                 set(findobj('tag','energy_storage'),'value',gui_current_val('energy_storage'))
        %                 handle=errordlg({'Battery not compatible with drivetrain selected';'Returning to previous battery'},'Battery Selection Error')
        %                 uiwait(handle)
        %                 clear handle
        %             end
        %             clear ess_name
        %         end
        
        if isfield(vinf.energy_storage,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.energy_storage.prev_name);
        end
        
        evalin('base',['clear ',vinf.energy_storage.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory
        evalin('base',['run ',vinf.energy_storage.name]);
        mod_str=num2str(evalin('base','round(ess_module_num)'));
        
        set(findobj('tag','ess_num_modules'),'string',mod_str);% tm:4/7/99
        ess_module_number=str2num(gui_current_str('ess_num_modules'));
        assignin('base','ess_module_num',ess_module_number);
        volt=evalin('base','mean(mean(ess_voc))');
        set(findobj('tag','ess_voltage'),'string',num2str(round(ess_module_number*volt)));
        %ess mass
        ess_mass=evalin('base','ess_module_mass*ess_module_num');
        set(findobj('tag','ess_mass'),'string',num2str(round(ess_mass)));
        
        check2run_ptc(option);
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
        
    case 'energy_storage2'
        
        evalin('base',['clear ',vinf.energy_storage2.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory
        evalin('base',['run ',vinf.energy_storage2.name]);
        mod_str=num2str(evalin('base','round(ess2_module_num)'));
        
        set(findobj('tag','ess2_num_modules'),'string',mod_str);% tm:4/7/99
        ess2_module_number=str2num(gui_current_str('ess2_num_modules'));
        assignin('base','ess2_module_num',ess2_module_number);
        volt=evalin('base','mean(mean(ess2_voc))');
        set(findobj('tag','ess2_voltage'),'string',num2str(round(ess2_module_number*volt)));
        %ess mass
        ess2_mass=evalin('base','ess2_module_mass*ess2_module_num');
        set(findobj('tag','ess2_mass'),'string',num2str(round(ess2_mass)));
        
        check2run_ptc(option);
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
        
    case 'powertrain_control'
        
        if isfield(vinf.powertrain_control,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.powertrain_control.prev_name);
        end
        
        evalin('base',['clear ',vinf.powertrain_control.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        evalin('base',['run ',vinf.powertrain_control.name]);
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'accessory'
        
        if isfield(vinf.accessory,'prev_name')
            %clear all the variables from the previously loaded file
            %clearfile(vinf.accessory.prev_name);
        end
        
        evalin('base',['clear ',vinf.accessory.name]); % tm:8/3/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory      
        
        if evalin('base','isfield(vinf,''ElecAuxTmp'')')
            evalin('base','vinf=rmfield(vinf,''ElecAuxTmp'');');     
        end
        
        evalin('base',['run ',vinf.accessory.name]);
        
        recompute_mass
        gui_run_files('edit_mod_var');
        
    case 'edit_mod_var'
        %compare all the modified variables with workspace variables, if values do
        %not match then delete modified variable from the modified variable list
        eval('h=vinf.variables.name; test4exist=1;','test4exist=0;');%check if vinf.variables.name exists
        if test4exist
            no_of_vars=max(size(vinf.variables.name));
            not_end_of_vars=1;
            i=1;%initialize counter
            while not_end_of_vars
                % BEGIN added/edited by mpo [23-April-2002]
                % fixing an error where evalin tried to evaluate vinf.variables.name{i} when it did not exist
                % Logic-- if the variable vinf.variables.name{i} exists and has a different value from the workspace,
                % ........then delete it. Else, if the variable does not exist on the workspace, then delete it.
                % ........If the variable exists on the workspace and has the same value, then let it be.
                deleteFlag=0;
                if evalin('base',['exist(vinf.variables.name{',num2str(i),'})'])
                    if vinf.variables.value(i)~=evalin('base',vinf.variables.name{i})
                        deleteFlag=1;
                    end
                else
                    deleteFlag=1;
                end
                % if vinf.variables.value(i)~=evalin('base',vinf.variables.name{i}) % the old if evaluation...
                if deleteFlag
                    % END added/edited by mpo [23-April-2002]             
                    %delete variable from modified variable list
                    if max(size(vinf.variables.name))==1
                        vinf=rmfield(vinf,'variables');
                        not_end_of_vars=0;
                    elseif i==max(size(vinf.variables.name))
                        j=max(size(vinf.variables.name))-1;
                        vinf.variables.name=vinf.variables.name(1:j);
                        vinf.variables.value=vinf.variables.value(1:j);
                        vinf.variables.default=vinf.variables.default(1:j);
                        not_end_of_vars=0;
                    else   
                        for j=i:max(size(vinf.variables.name))-1
                            vinf.variables.name{j}=vinf.variables.name{j+1};
                            vinf.variables.value(j)=vinf.variables.value(j+1);
                            vinf.variables.default(j)=vinf.variables.default(j+1);
                        end
                        vinf.variables.name=vinf.variables.name(1:j);
                        vinf.variables.value=vinf.variables.value(1:j);
                        vinf.variables.default=vinf.variables.default(1:j);
                        %do not increase the index by 1 use same index
                    end;%if max(size(vinf.variables.name))   
                else 
                    if i==max(size(vinf.variables.name))
                        not_end_of_vars=0;
                    else
                        i=i+1;
                    end; %if i==max(size(vinf.variables.name))
                end;%end if statement
                
            end;%while loop
        end;%if test4exist
        gui_edit_var('update');%this will update the variable value display   
        
        
    end;%end switch option
    
end;%if nargin>0


%----------------------------------   
function type=check_trans_type
%
% determines the compatibility of a transmission with a drivetrain type
% type=0 --> incompatible, type=1 --> manual, type=2 --> automatic, type=3 --> CVT
%

% make vinf global
global vinf

% initialize the identifier
type=0;

% get required base data
if ~strcmp(vinf.drivetrain.name,'conventional')
    mc_map_spd=evalin('base','mc_map_spd');
    mc_spd_scale=evalin('base','mc_spd_scale');
else
    fc_map_spd=evalin('base','fc_map_spd');
    fc_spd_scale=evalin('base','fc_spd_scale');
end
wh_radius=evalin('base','wh_radius');

% load trans data
eval(['run ',vinf.transmission.name]);

% determine trans type
if exist('htc_sr')&exist('htc_tr') % automatic transmission
    if strcmp(vinf.drivetrain.name,'conventional')|(strcmp(vinf.drivetrain.name,'custom'))%|strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'parallel_sa') % tm:7/11/00 to be added in the future
        % tm 7/11/00 added |custom to pervent warnings
        type=2;
    else
        type=0; % BD_CONVAT is the only block compatible with a auto transmission
    end
elseif (exist('gb_map1_spd')&exist('gb_map1_trq'))|exist('gb_map_trq_out') % standard CVT
    if (strcmp(vinf.drivetrain.name,'conventional'))|(strcmp(vinf.drivetrain.name,'custom'))|strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'parallel_sa')
        % added "custom" above to prevent warnings with custom design
        % tm:7/11/00 added parallel and parallel_sa above to make available
        type=3;
    else
        type=0; % BD_CONVCVT, BD_PAR_CVT, and BD_PAR_SA_CVT are only blocks compatible with a CVT except custom
    end
elseif exist('tx_pg_s')&exist('tx_pg_r') % prius_jpn_CVT
    if strcmp(vinf.drivetrain.name,'prius_jpn')
        type=4;
    else
        type=0; % BD_PRIUS_JPN is the only block compatible with a PRIUS_CVT
    end
elseif exist('gb_ratio') % must be a manual if non of the above exist just make sure the file actually loaded
    if ~strcmp(vinf.drivetrain.name,'prius_jpn')
        type=1;
    else
        type=0; % manaul trans is not compatible with ??? 
    end
end
return
%----------------------------------   
function run_modified_variables
%ss 10/7/99
global vinf

%if any modified variables, run those
eval('h=vinf.variables; test4exist=1;','test4exist=0;');
if test4exist
    for i=1:max(size(vinf.variables.name))
        evalin('base',[vinf.variables.name{i},'=',num2str(vinf.variables.value(i)),';']);
        %assignin('base',vinf.variables.name{i},vinf.variables.value(i));
    end
end

%   If any other modifications, run those
RunFilesMods('update');

%-----------------------------------
function check2run_ptc(option)

try ptc_dep_comps=evalin('base','ptc_dep_comps');end
if exist('ptc_dep_comps') & ~isempty(strmatch(option,ptc_dep_comps,'exact'))
    adjust_cs;
end

%-----------------------------------
%Revision history
%08/28/98:vh added run files for ev
%08/28/98:vh eliminated generator from parallel
%08/31/98:vh ev begins at hi soc limit
%8/31/98:sam added gb efficiency and masses for ex,fd, and gb
% 09/03/98:tm added statements for fuel cell
% 09/03/98:tm fixed fc eff calc to prevent divide by zero warnings
% 9/14/98:vh, added init soc=1 for ev under load
%9/16/98:ss, added gui_run_files('powertrain_control') to cases: mc and gc and
%           moved it to bottom on fc
%9/23/998:ss-corrected the way total_mass is calculated with respect to mc in the load and drivetrain case.
%9/24/98:ss added set override_mass_checkbox value equal to 0 in the drivetrain case so when user selects new drivetrain, 
%   the calculated mass will be used.  Also disabled the override mass value edit box.
%9/30/98-ss: removed gearbox and final drive and replaced with transmission
%10/1/98-ss and tm added subroutines and added spd_scale to power and mass calcs
%10/9/98-ss added statements to clear init conditions when loading or switching drivetrains
%10/13/98-sam added running powertrain control in transmission case and made sure that powertrain was run after transmission
%10/15/98-ss added running of ptc at the end of the load case.
%10/16/98-ss changed all GB_* file names to TX_* filenames
%10/16/98-ss when transmission is picked it will automatically bring up a compatible PTC  Changes made in case 'transmission'
% 11/3/98:tm introduced vinf.autosize_run_status variable, set to 0 if anything has changed after an autosize run
%12/31/98: tm fixed roundoff error associated with max powers in subfunction calc_max_pwr
%1/28/99:ss updated exhaust name for fuel cell to EX_FUELCELL it was EX_FC
%1/28/99:ss simplified ess_module_num code since it is now loaded with each ess_* file.
%2/2/99:ss updated cargo mass code
%3/15/99:ss added vinf=rmfield(vinf,'autosize') in the load and drivetrain cases.
% 3/15/99:ss added       assignin('base','fc_on',1);  assignin('base','enable_stop',0);
% 3/16/99:ss removed running ptc file at end of load case(unnecessary and was overwriting variables)
% 3/16/99:SS TM, added statements under case 'fuel converter' for sizing of generator with respect to fuel converter
% 3/16/99:ss, tm, kw: updated how and when error message appears when selecting transmissions.
% 3/19/99:ss removed a line disp(value) so it wouldn't show up on the workspace.
% 3/22/99:ss added the line ('calc_fc_max_pwr') before running any exhaust file.
% 4/6/99 ss under load case, added fc_pwr_scale evalin base
% 4/7/99 mc: added if and end statements around the fc_pwr_scale from 4/6 for use with
%           vehicles that don't have fc's(ie. ev)
% 4/7/99 tm: added line to read the number of modules under case 'energy storage'
% 4/12/99 ss: changed strcmp to strncmp in the case 'transmission'
% 4/28/99 ss: added several if statements in load case if run without gui.
% 7/15/99 ss: added prius drivetrain
% 7/26/99 ss,kw: stopped running of transmission file under case 'motor controller' for vehicles
%                 except fuel_cell, series and ev for fd ratio calculation problems.
% 
% 8/26/99 ss: added loading of all prius components when prius drivetrain selected.
%8/13/99:tm changed if drivetrain statement on 722 from ~conventional&~prius to parallel because tc 
%            only needs to be loaded for parallel vehicles
% 8/13/99:tm modified case transmission so that fuel_cell vehicles don't have a default ptc file
% 8/13/99:tm updated calc_max_pwr fuel converter case routines based on available data
%8/22/99:tm added vinf=rmfield(vinf,'control_strategy') in the load and drivetrain cases.
% 9/9/99:tm replace repeated fc max eff calcs with a call to subfunction calc_max_eff('fuel_converter')
% 9/9/99:tm created subfuntion calc_max_pwr with cases for fc (gc,mc,... not active yet!)
% 9/9/99:tm updated the trans/drivetrain mismatch warnings - incompatible selections can not be 
%           loaded (ie TX_CVT with anything other than conventional,...)
% 9/9/99:tm create transmission case in calc_max_eff subfunction and replaced all eff calcs with call to this function
% 9/10/99:tm updated all component eff calcs to use calc_max_eff subfunction
% 9/10/99:tm verified that all displayed efficiency values and ..def_max_eff values have two decimal places
%9/17/99:ss updated voltage calcs to be the mean of the mean of ess_voc so it comes up with one number for the matrix.
%9/17/99: vhj added variable ess_on (2 places)
% 9/19/99: ss repaired call for mc & gc_peak_eff.  It was calling calc_max_pwr instead of calc_max_eff
% 9/20/99:tm updated calc_max_pwr and calc_max_eff for 3 fuel cell cases
% 9/20/99:tm changed default fuel cell ptc file to ptc_fuelcell
% 9/20/99:tm modified trans effieicney calc so that fuelcell and ev use same calc 
% 9/22/99: ss removed subfunction calc_max_pwr(it is now its own m-file function)
% 9/24/99: vhj enable_stop set to 1 for ev
% 10/7/99: ss added subfunction run_modified_variables and inserted throughout 'load' case
% 11/02/99:tm added conditional to the calc_total_mass case, run if the input figure is open else run recompute_mass - for parametric analysis
% 11/03/99:ss replaced gui_run_files('calc_total_mass') with recompute_mass
% 11/03/99:ss removed subfunction calc_comp_mass and did all mass calculations with recompute_mass function
% 11/17/99:ss under the load case had to add conditional evalin('base','exist(''fc_fuel_type'')') in order to set
%             or not to set the text placeholder on the vehicle schematic.
% 11/18/99:ss under generator case made sure the handling of gc eff was handled properly.
% 12/09/99:ss tx_pg_r/s for transmission type check (was pg_r), tx_type>0 now tx_type>0 & tx_type~=4 (for prius not having gb efficiency calc)
% 12/14/99:tm added statements to the case 'drivetrain' to handle drivetrain = 'custom'
% 12/15/99:ss changed the rounding of the voltage from the individual module calculation to where it is multiplied by the number of modules.
% 1/13/99:tm added enable_stop_fc, enable_speed_scope, and j17_endtimes variable definitions for improved j1711 operation
% 2/22/00:tm added |exist('gb_map_trq_out') to conditional to determine tranmission type == CVT - new CVT data format
% 3/6/00: ss added conditional to running transmission file under case 'wh_axle' to only run for series case and displays a help dialogue.
% 3/31/00: tm added assignin('base','gb_num_init',1);
% 6/12/00: ss added 'value',1 to setting the variable list to prevent errors when selecting a new drivetrain, bug reported by Aymeric
% 6/6/00:tm added |custom to trans type CVT conditional in subfunction check_trans_type
% 6/15/00: ss changed default fc for prius to be FC_PRIUS instead of FC_PRIUS_ANL
% 7/6/00: ss commented out the calc_max_eff for now, we have a new file named calc_max_eff from tm
% 7/11/00:tm revised entire contents of while loop (line 340) for case 'drivetrain' and selection 'custom' to exit gracefully upon cancel
% 7/11/00:tm revised text in lines 435 and 437 from PTC_FC to PTC_FUELCELL
% 7/11/00:tm added insight and parallel_sa to the list of hybrid configs on line 421
% tm:7/11/00 added |parallel_sa to line 430
% tm:7/11/00 added section for selecting appropriate files when insight selected from drivetrain menu
% tm:7/11/00 added |insight to conditional for loading acc_hybrid to prevent acc_insight from being overriden
% tm:7/11/00 added |parallel_sa and |insight to conditional of running torque converter
% tm:7/11/00 removed line to load GC_NULL for fuelcell vehicle - this is no longer necessary - fuel cell specific block diagram
% tm 7/11/00 replaced drivetrain conditional with variable name conditional to allow greater flexibility lines 667, 652, 634, 610       
% tm 7/11/00 in case 'motor_controller' added conditionals |parallel_sa and |insight to running the torque coupling file         
% tm:7/11/00 added parallel and parallel_sa to cvt conditional in check_trans_type function to make available
% tm 7/11/00 added |custom auto trans type conditional in check trans type function to pervent warnings
% tm 7/11/00 line 945 revised PTC_CONVAT to be PTC_PRIUS typo
% tm 7/11/00 new elseif added to select PTC_PAR_CVT when parallel or parallel_sa and cvt selected
% 7/17/00 ss: replaced all gui options with optionlist.
% 7/19/00 ss: fixed bug: optionlist was optiolist on line 344, fixed call to optionlist on 583 (missing ,)
%tm 7/18/00 revised actions taken when user hits cancel after custom drivetrain to reset appropriate params and return out of function
% tm 7/18/00 added definition of defaults sim_stop variables for speed, distance,and time for use with accel test advanced
% 7/20/00 ss: added functionality (2 places: load and drivetrain) to check and uncheck checkboxes in front of components.
% 7/21/00 ss: updated insight files and names to draft where necessary.
% 7/21/00 ss: added insight and parallel_sa into the load case
%7/24/00:tm moved assignment of sim control parameters in load case to before run_modified variables so that sim params can be editted variables
% 7/26/00 ss replaced all GC_ETA100 with GC_NULL (new file)
% 8/1/00 ss started converting over to using ver and type for fuel converter.
% 8/13/00 ss: under case 'drivetrain' made sure that the default files end in _in , so added _in to _defaults
% 8/17/00 kjk: under case 'load file' added Insight information window
% 8/19/00 ss: added Prius information window under case 'load file'
% 8/18/00 tm: updated message for insight
% 8/21/00 ss: updated message for prius.
% 8/21/00 ss: updated case 'transmission' with version and type.
% 8/21/00 ss: added calls to clearfile function to clear out previous file before loading new one.
% 8/21/00 ss: added the word 'yet' to prius message
% 2/2/01: ss updated prius to prius_jpn
% 8/21/00:tm commented out all references to clearfile function - causes havoc with tt files - what is its purpose??
% 8/21/00:tm replaced call to pre_calcs on lines 170  and 561 with call to calc_max_pwr function and fc_pwr_scale assignment
% 8/21/00:tm moved request for user input for the custom drivetrain from the top of the drivetrain case to the end of the case - vinf was cleared in the middle and the default file is loaded in the middle
% 8/21/00:tm added if exist conditionals around fc_on and ess_on initialization statements to allow user to set within the datafile
% 8/22/00 ss case 'drivetrain' added statements to preserve drivetrain previous and vinf.name for cancelling out of custom block diagram definition.
% 1/15/01 ss replaced update_var_list with calls to variable_selection for component specific variable lists
% 11/16/00:tm added default definition of enable_sim_stop_max_speed to work with updated accel_test_advanced
% tm:12/10/00 added defaults for use with autosize
% 1/23/01:Tm added default definition of vinf.interactive_sim for use with adv_no_gui and autosize
%02/09/01: vhj allow fuel cell to use nnet and fund battery models 
% 2/12/01: ss under case 'transmission' updated the version from 'v02' to 'auto' so fuel converter would run for automatic transmission
%          added statement to clear existing transmission variables and added assignin('base','gb_num_init',1);
%			  added statement to set gb_shift_delay equal to 0 (this is overwritten if it is also assigned in ptc* file.
% 2/12/01: ss changed the way cell array was referenced in case 'edit_mod_var' so it would work in R12. (ex. var(1)=var(2) now has to be var{1}=var{2} for cell array)
%02/14/01: vhj created vinf.tmppath variable
%02/15/01: vhj tmppath keys off of location of advisor.m
%02/26/01:  vhj  for NOx Absorber, only allow the pick with CI60_emis and CI67_emis (under exhaust and fc)
%02/27/01: vhj updated 'NOx Abs' to 'Ox Cat'
%08/03/01: tm added statement to force Matlab to search for the newly modified file rather than reference functions in memory
%04-26-02:mpo added lines in case 'edit_mod_var' to fix an evalin error where variables evaluated that don't exist
%04-26-02:mpo in case 'energy_storage', commented out the lines that prevent the user from using the prius with other battery models
% 11/19/02:tm converted assignin to evalin in the run_modified_variables sub function to handle variables with indices - gui_edit_var already uses this format

