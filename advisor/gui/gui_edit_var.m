function gui_edit_var(option,var_name,var_value_str)
%gui_edit_var(var)  ADVISOR 2.0
%this function edits a currently loaded variable if it is a scalar
%no option causes edit variables figure to pop up
%option='update' causes the value to be updated at the text box
%var_name and var_value_str are used for scaling components

global vinf


if nargin==0
    
    var=gui_current_str('variable_list');
    value=evalin('base',var);
    var_info=whos('value');
    
    try 
        i=strmatch(var,vinf.variables.name,'exact');
        if ~isempty(i)
            default_value=vinf.variables.default(i);
        else
            default_value=value;
        end
    catch
        default_value=value;
    end
    
    if (~isequal(var_info.size,[1 1]) | var_info.class~='double')
        return
    end
    figure_color=[0.5 .5 .75];
    
    if get(0,'screensize')==[1 1 1024 768]
        posfig=[508 315 350 139];
    else
        posfig=[408 315 350 139];
    end
    
    h0 = figure('MenuBar','none', ...
        'color',figure_color,...
        'Name',['Edit Variable--',advisor_ver('info')], ...
        'NumberTitle','off', ...
        'Position',posfig, ...
        'Tag','Fig2',...
        'WindowStyle','modal');
    %title
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figure_color,...
        'Position',[59 73 88 28], ...
        'String','Variable to modify:', ...
        'Style','text', ...
        'Tag','StaticText2');
    %
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figure_color,...
        'HorizontalAlignment','right', ...
        'Position',[10 44 141 19], ...
        'String',var, ...
        'Style','text', ...
        'Tag','variable_to_edit');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figure_color,...
        'Position',[152 47 16 17], ...
        'String','=', ...
        'Style','text', ...
        'Tag','StaticText3');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'Position',[167 46 85 21], ...
        'String',num2str(value), ...
        'Style','edit', ...
        'Tag','variable_value');
    
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figure_color,...
        'HorizontalAlignment','right', ...
        'Position',[90 20 61 19], ...
        'String','Default Val.', ...
        'Style','text');
    
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[.8 .8 .8], ...
        'Position',[167 20 85 21], ...
        'String',num2str(default_value), ...
        'Style','text', ...
        'Tag','variable_default_value');
    
    
    %buttons
    %view all edited variables button
    h1=uicontrol('parent',h0,...
        'CallBack','gui_edit_var(''view all'')',...
        'Position',[268 106 65 20],...
        'String','View All');
    
    
    h1 = uicontrol('Parent',h0, ...
        'CallBack','load_in_browser(''advisor_appendices.html'');',...
        'Position',[268 83 65 20], ...
        'String','Help', ...
        'Tag','Pushbutton3');
    h1 = uicontrol('Parent',h0, ...
        'CallBack','close(gcbf)',...
        'Position',[268 60 65 20], ...
        'String','cancel', ...
        'Tag','Pushbutton2');
    h1=uicontrol('parent',h0,...
        'callback','gui_edit_var(''default'')',...
        'position',[268 38 65 20],...
        'string','Default Val.');
    h1 = uicontrol('Parent',h0, ...
        'CallBack','gui_edit_var(''modify'');close(gcbf)',...
        'Position',[268 15 65 20], ...
        'String','O.K.', ...
        'Tag','Pushbutton1');
    
    gui_edit_var('update');
end

if nargin>0
    
    global vinf
    
    if ~(strcmp(option,'update')|strcmp(option,'view all'))
        %the following is used to determine if autosize has just run
        %here it is set to zero because it has not just run.  Originally
        %this is used in conjuction with vinf.targets.accel_0_85 for 
        %determining how long to run the accel test for.
        vinf.autosize_run_status=0;
    end
    
    switch option
    case 'update'
        %this should only work if input figure is up and running
        if ~isempty(findobj('tag','input_figure'))
            new_list=variable_selection(gui_current_str('input_variables_components'),1);   
            current_list=get(findobj('tag','variable_list'),'string');
            
            if size(new_list)==size(current_list) % ab added to allow for files having different variable names
                if strcmp(new_list,current_list)
                    h=findobj('tag','var_value');%this is the display on the input figure
                    value=evalin('base',gui_current_str('variable_list'));
                    set(h,'string',num2str(value))
                else
                    variable_selection(gui_current_str('input_variables_components'));
                end
            else
                variable_selection(gui_current_str('input_variables_components'));
                
            end
        end
        
    case 'modify'
        
        %if mass override then process a little differently
        if strcmp(get(gco,'tag'),'override_mass_checkbox')|strcmp(get(gco,'tag'),'override_mass_value')
            var_name='veh_mass';
            default_value=str2num(gui_current_str('calc_mass'));
            assignin('base','veh_mass',default_value);%set it up so default is calc value
            if get(findobj('tag','override_mass_checkbox'),'value')==1
                var_value_str=gui_current_str('override_mass_value');
                if str2num(var_value_str)<=0
                    var_value_str='1';
                    warndlg('mass has to be >0')
                end
            else
                var_value_str=gui_current_str('calc_mass');
            end;
            
        elseif nargin==3
            %use the input arguments
        else         
            var_name=gui_current_str('variable_list');
            var_value_str=gui_current_str('variable_value');
        end
        
        %if KTH,VT or gctool then don't allow fc_eff_scale to be modified
        if strcmp(var_name,'fc_eff_scale')
            if strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
                helpdlg('Cannot change fc_eff_scale for the fuel converter type selected')
                return
            end
        end

        
        %check to see if variable already exists in vinf.variables
        %if so then the default value has already been set
        %otherwise set the default value
        %save to vinf.variables...
        %find the next index for the variable name and value
        %but use current index if variable is already modified
        %also save a default value and if modified value=default value then
        %delete the variable from the modified variables
        eval('vinf.variables.name; test4exist=1;','test4exist=0;');%kind of like the function exist but exist is no good on structures
        if test4exist; %check to see if any variables have already been set up
            i=strmatch(var_name,vinf.variables.name,'exact');%see if the variable in question has been set up
            if ~isempty(i);%if there is a match then just modify the existing modified variable
                var_index=i;%index of existing variable
                %if the new value=default value then get rid of that variable out of vinf.variables...
                if str2num(var_value_str)==vinf.variables.default(i);%if the new value=default value
                    if i==1
                        if length(vinf.variables.name)==1;
                            vinf=rmfield(vinf,'variables');%remove the variable list cause it only contained one variable
                        else  %remove just the first variable from the variable list
                            j=length(vinf.variables.name);
                            vinf.variables.name=vinf.variables.name(2:j);
                            vinf.variables.value=vinf.variables.value(2:j);
                            vinf.variables.default=vinf.variables.default(2:j);
                        end
                    elseif i==max(size(vinf.variables.name))
                        j=max(size(vinf.variables.name))-1;
                        vinf.variables.name=vinf.variables.name(1:j);
                        vinf.variables.value=vinf.variables.value(1:j);
                        vinf.variables.default=vinf.variables.default(1:j);
                    else   
                        for j=i:max(size(vinf.variables.name))-1
                            vinf.variables.name{j}=vinf.variables.name{j+1};
                            vinf.variables.value(j)=vinf.variables.value(j+1);
                            vinf.variables.default(j)=vinf.variables.default(j+1);
                        end
                        vinf.variables.name=vinf.variables.name(1:j);
                        vinf.variables.value=vinf.variables.value(1:j);
                        vinf.variables.default=vinf.variables.default(1:j);
                        
                    end;%if i==1   
                else
                    vinf.variables.value(var_index)=str2num(var_value_str);
                end;%end if new value==default value      
            else
                %if str2num(var_value_str)~=evalin('base',var_name)
                    var_index=max(size(vinf.variables.name))+1;
                    vinf.variables.name{var_index}=var_name;
                    vinf.variables.value(var_index)=str2num(var_value_str);
                    vinf.variables.default(var_index)=evalin('base',var_name);
                    %end;   
            end   
        elseif str2num(var_value_str)==evalin('base',var_name);%if variable is not being changed then don't do anything
            %do nothing   
        else
            var_index=1;
            vinf.variables.name{var_index}=var_name;
            vinf.variables.value(var_index)=str2num(var_value_str);
            vinf.variables.default(var_index)=evalin('base',var_name);         
        end
        evalin('base',[var_name,'=',var_value_str,';']);
        
        %if the variable being modified has anything to do with the input
        %figure then need to update input figure
        if strcmp(var_name,'wh_front_active_bool')|strcmp(var_name,'wh_rear_active_bool')
            if evalin('base','wh_front_active_bool')==1 & evalin('base','wh_rear_active_bool')==1
                set(findobj('tag','front_wheel_drive'),'value',0)
                set(findobj('tag','rear_wheel_drive'),'value',0)
                set(findobj('tag','four_wheel_drive'),'value',1)
            elseif evalin('base','wh_front_active_bool')==0 & evalin('base','wh_rear_active_bool')==0
                errordlg('need at least one of the axles driven: please correct wh_*_active_bool before continuing')
            else
                set(findobj('tag','front_wheel_drive'),'value',evalin('base','wh_front_active_bool'))
                set(findobj('tag','rear_wheel_drive'),'value',evalin('base','wh_rear_active_bool'))
                set(findobj('tag','four_wheel_drive'),'value',0)
            end
        end
        
        if strcmp(var_name,'veh_mass')
            eval('h=vinf.variables; test4exist=1;','test4exist=0;')
            if test4exist&~isempty(strmatch('veh_mass',vinf.variables.name,'exact'));
                if ~strcmp(get(gco,'tag'),'override_mass_checkbox')&~strcmp(get(gco,'tag'),'override_mass_value')
                    set(findobj('tag','override_mass_checkbox'),'value',1);
                    h=strmatch('veh_mass',vinf.variables.name,'exact');
                    if vinf.variables.value(h)==0
                        vinf.variables.value(h)=1;
                        assignin('base','veh_mass',1);
                        warndlg('Mass must be >0!')
                    end   
                    set(findobj('tag','override_mass_value'),'string',num2str(vinf.variables.value(h)));
                    set(findobj('Tag','override_mass_value'),'enable','on');
                    
                end
            else
                if ~strcmp(get(gco,'tag'),'override_mass_checkbox')&~strcmp(get(gco,'tag'),'override_mass_value')
                    set(findobj('tag','override_mass_checkbox'),'value',0);
                end
            end
        end
        if strcmp(var_name,'ess_module_mass')
            num_mod=evalin('base','ess_module_num');
            set(findobj('tag','ess_mass'),'string',num2str(round(num_mod*str2num(var_value_str))));
            recompute_mass;
        end
        if strcmp(var_name,'ess_parallel_mod_num')
            recompute_mass;
        end
        if strcmp(var_name,'ess_module_num')
            set(findobj('tag','ess_num_modules'),'string',var_value_str)
            mass_mod=evalin('base','ess_module_mass');
            set(findobj('tag','ess_mass'),'string',num2str(round(mass_mod*str2num(var_value_str))));
            volt=evalin('base','mean(mean(ess_voc))');
            set(findobj('tag','ess_voltage'),'string',num2str(round(str2num(var_value_str)*volt)));
            recompute_mass;
        end
        
         if strcmp(var_name,'fc_eff_scale')
            peak_eff=evalin('base','fc_eff_scale*vinf.fuel_converter.def_peak_eff');
            set(findobj('tag','fc_peak_eff'),'string',num2str(round(peak_eff*100)/100));
            
            
            if ~isempty(findobj('tag','input_figure'))
                evalin('base','gui_inpchk;')
            end
            
        end
        if strcmp(var_name,'fc_trq_scale')|strcmp(var_name,'fc_spd_scale')|strcmp(var_name,'fc_pwr_scale')
            if strcmp(var_name,'fc_spd_scale')&evalin('base','exist(''fc_fuel_cell_model'')')
                evalin('base','fc_spd_scale=1;')
            end
            if strcmp(var_name,'fc_pwr_scale')
                %evalin('base','fc_trq_scale=fc_pwr_scale/fc_spd_scale;') % tm: 5/18/01 replaced with line below
                gui_edit_var('modify','fc_trq_scale',num2str(evalin('base','fc_pwr_scale/fc_spd_scale')))
            end
            max_pwr=evalin('base','fc_trq_scale*fc_spd_scale*vinf.fuel_converter.def_max_pwr');
            set(findobj('tag','fc_max_pwr'),'string',num2str(round(max_pwr)))
            set(findobj('tag','fc_mass'),'string',num2str(round(evalin('base','fc_trq_scale*fc_spd_scale*fc_mass'))));
            
            %gui_run_files('exhaust_aftertreat') % tm:11/02/99 not necessary to reload ex file
            
            recompute_mass;
            
            %added 1/27/99 for thermal models
            evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale;')
            
            %if strcmp(var_name,'fc_spd_scale')
            %   evalin('base',['run ',vinf.powertrain_control.name]);% ss 10/7/99
            %end
            
            adjust_cs % tm 11/01/99
            
            if ~isempty(findobj('tag','input_figure'))
                try 
                    evalin('base','gui_inpchk;')
                end
            end
            
        end
        
        if strcmp(var_name,'gc_trq_scale')|strcmp(var_name,'gc_spd_scale')
            max_pwr=evalin('base','gc_trq_scale*gc_spd_scale*vinf.generator.def_max_pwr');
            set(findobj('tag','gc_max_pwr'),'string',num2str(round(max_pwr)))
            set(findobj('tag','gc_mass'),'string',num2str(round(evalin('base','gc_trq_scale*gc_spd_scale*gc_mass'))));
            recompute_mass;
            adjust_cs %tm added 3/15/00   
        end
        
        if strcmp(var_name,'mc_trq_scale')|strcmp(var_name,'mc_spd_scale')
            max_pwr=evalin('base','mc_trq_scale*mc_spd_scale*vinf.motor_controller.def_max_pwr');
            set(findobj('tag','mc_max_pwr'),'string',num2str(round(max_pwr)))
            set(findobj('tag','mc_mass'),'string',num2str(round(evalin('base','mc_trq_scale*mc_spd_scale*mc_mass'))));
            recompute_mass;
        end
        
        % added tm: 8/21/00
        if strcmp(var_name,'gb_trq_scale')|strcmp(var_name,'gb_spd_scale')
            set(findobj('tag','mc_mass'),'string',num2str(round(evalin('base','gb_trq_scale*gb_spd_scale*tx_mass'))));
            recompute_mass;
        end
        % end added tm 8/21/00
        
        if strcmp(var_name,'mc_eff_scale')
            peak_eff=evalin('base','mc_eff_scale*vinf.motor_controller.def_peak_eff');
            set(findobj('tag','mc_peak_eff'),'string',num2str(peak_eff))
            
            if ~isempty(findobj('tag','input_figure'))
                evalin('base','gui_inpchk;')
            end
        end
        if strcmp(var_name,'gb_eff_scale')
            peak_eff=evalin('base','gb_eff_scale*vinf.transmission.def_peak_eff');
            set(findobj('tag','tx_peak_eff'),'string',num2str(round(peak_eff*100)/100));
            
            evalin('base',['run ',vinf.transmission.name]);
            %if any modified variables, run those to make sure all is as before
            eval('h=vinf.variables; test4exist=1;','test4exist=0;');
            if test4exist
                for i=1:max(size(vinf.variables.name))
                    %assignin('base',vinf.variables.name{i},vinf.variables.value(i));
                    evalin('base',[vinf.variables.name{i},'=',mat2str(vinf.variables.value(i)),';']);
                end
            end
            
            eff_scaling('gb');
            if ~isempty(findobj('tag','input_figure'))
                %evalin('base','gui_inpchk;')  not used yet in graphing in input figure
            end
        end
        if strcmp(var_name,'veh_cargo_mass')
            recompute_mass
        end
        if strcmp(var_name,'wh_mass')
            recompute_mass
        end
        if strcmp(var_name,'veh_glider_mass')
            recompute_mass
        end
        if strcmp(var_name,'fc_mass')
            recompute_mass
        end
        if strcmp(var_name,'gc_mass')
            recompute_mass
        end
        if strcmp(var_name,'mc_mass')
            recompute_mass
        end
        if strcmp(var_name,'ex_mass')
            recompute_mass
        end
        if strcmp(var_name,'tx_mass')
            recompute_mass
        end
        if strcmp(var_name,'ess_cap_scale') | strcmp(var_name,'ess2_cap_scale')
            recompute_mass
            if ~isempty(findobj('tag','input_figure'))
                try 
                    evalin('base','gui_inpchk;')
                end
            end
        end
        
        recompute_mass
        
        gui_edit_var('update')         
        
        
    case 'default'
        set(findobj('tag','variable_value'),'string',gui_current_str('variable_default_value'))     
        
    case 'view all'
        figure_color=[.8 .8 .8];
        
        if get(0,'screensize')==[1 1 1024 768]
            posfig=[508 315 370 200];
        else
            posfig=[408 315 370 200];
        end
        
        h0=figure('MenuBar','none', ...
            'color',figure_color,...
            'Name',['View All Modified Variables--',advisor_ver('info')], ...
            'NumberTitle','off', ...
            'MenuBar','none',...
            'Position',posfig,...
            'WindowStyle','modal');
        
        eval('h=vinf.variables.name(1); test4exist=1;','test4exist=0;');
        if test4exist==1
            string{1}='         Name           new value     default';
            string{2}='  ';
            for i=1:max(size(vinf.variables.name))
                string{i+2}=sprintf('%20s%10s%10s',vinf.variables.name{i},num2str(vinf.variables.value(i)),num2str(vinf.variables.default(i)));
            end
        else
            string='none';
        end
        
        h1=uicontrol('parent',h0,...
            'position',[5 30 360 165],...
            'listboxtop',1,...
            'Fontname','Courier New',...
            'Fontsize',9,...
            'style','listbox',...
            'string',string);
        h1=uicontrol('Parent',h0,...
            'Callback','close(gcbf)',...
            'Position',[158 4 55 25],...
            'String','Done');
    case 'fc_max_pwr'
        new_fc_max_pwr=str2num(get(findobj('tag','fc_max_pwr'),'string'));
        if evalin('base','exist(''fc_fuel_cell_model'')')
            
            %don't allow this for kth ,vt fuel cell, or gctool either
            if strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
                set(findobj('tag','fc_max_pwr'),'string',num2str(round(vinf.fuel_converter.def_max_pwr)))
                helpdlg('This functionality is not available for the current fuel converter.  If fuel cell, try editing the variable fc_cell_num')
                return
            end
            %check to make sure user entered a number if not put number in and return out of this case
            if isempty(new_fc_max_pwr)
                fc_pwr_scale=evalin('base','fc_pwr_scale');
                set(findobj('tag','fc_max_pwr'),'string',num2str(round(fc_pwr_scale*vinf.fuel_converter.def_max_pwr)))
                return
            end
            
            fc_pwr_scale=new_fc_max_pwr/vinf.fuel_converter.def_max_pwr;
            set(findobj('tag','fc_max_pwr'),'string',num2str(round(new_fc_max_pwr)));
            
            %may be needed to fix the default
            assignin('base','fc_pwr_scale',1);
            gui_edit_var('modify','fc_pwr_scale',num2str(fc_pwr_scale))
            assignin('base','fc_trq_scale',1);
            gui_edit_var('modify','fc_trq_scale',num2str(fc_pwr_scale))
            recompute_mass
            %gui_run_files('powertrain_control'); %tm:5/20/99
            adjust_cs % tm 5/20/99
        else
            fc_spd_scale=evalin('base','fc_spd_scale');
            
            %don't allow this for kth ,vt fuel cell, or gctool either
            if strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
                set(findobj('tag','fc_max_pwr'),'string',num2str(round(vinf.fuel_converter.def_max_pwr)))
                helpdlg('This functionality is not available for the current fuel converter.  If fuel cell, try editing the variable fc_cell_num')
                return
            end
            %check to make sure user entered a number if not put number in and return out of this case
            if isempty(new_fc_max_pwr)
                fc_trq_scale=evalin('base','fc_trq_scale');
                set(findobj('tag','fc_max_pwr'),'string',num2str(round(fc_trq_scale*fc_spd_scale*vinf.fuel_converter.def_max_pwr)))
                return
            end
            
            fc_trq_scale=new_fc_max_pwr/fc_spd_scale/vinf.fuel_converter.def_max_pwr;
            set(findobj('tag','fc_max_pwr'),'string',num2str(round(new_fc_max_pwr)));
            
            %may be needed to fix the default
            assignin('base','fc_trq_scale',1);
            gui_edit_var('modify','fc_trq_scale',num2str(fc_trq_scale))
            recompute_mass
            %gui_run_files('powertrain_control'); %tm:5/20/99
            adjust_cs % tm 5/20/99
            
        end
        
        
        
    case 'fc_peak_eff'
        new_fc_peak_eff=str2num(get(findobj('tag','fc_peak_eff'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        %don't allow this for kth ,vt fuel cell, or gctool either
        if isempty(new_fc_peak_eff)|strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool')
            fc_eff_scale=evalin('base','fc_eff_scale');
            set(findobj('tag','fc_peak_eff'),'string',num2str(round(100*fc_eff_scale*vinf.fuel_converter.def_peak_eff)/100))
            helpdlg('Either the entry is incorrect or this functionality is not available for the current fuel converter')
            return
        end
        
        fc_eff_scale=new_fc_peak_eff/vinf.fuel_converter.def_peak_eff;
        
        
        gui_edit_var('modify','fc_eff_scale',num2str(fc_eff_scale))
        
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99
        
    case 'gc_max_pwr'
        new_gc_max_pwr=str2num(get(findobj('tag','gc_max_pwr'),'string'));
        
        if evalin('base','exist(''gc_spd_scale'')')
            gc_spd_scale=evalin('base','gc_spd_scale');
            
            %check to make sure user entered a number if not put number in and return out of this case
            if isempty(new_gc_max_pwr)
                gc_trq_scale=evalin('base','gc_trq_scale');
                set(findobj('tag','gc_max_pwr'),'string',num2str(round(gc_trq_scale*gc_spd_scale*vinf.generator.def_max_pwr)))
                return
            end
            
            gc_trq_scale=new_gc_max_pwr/gc_spd_scale/vinf.generator.def_max_pwr;
            set(findobj('tag','gc_max_pwr'),'string',num2str(round(new_gc_max_pwr)));
            
            %may be needed to fix the default
            assignin('base','gc_trq_scale',1);
            gui_edit_var('modify','gc_trq_scale',num2str(gc_trq_scale))
            
            assignin('base','gc_spd_scale',1);
            gui_edit_var('modify','gc_spd_scale',num2str(gc_spd_scale))
        else
            %check to make sure user entered a number if not put number in and return out of this case
            if isempty(new_gc_max_pwr)
                evalin('base','gc_max_pwr');
                set(findobj('tag','gc_max_pwr'),'string',num2str(round(gc_max_pwr*vinf.generator.def_max_pwr)))
                return
            end
            gui_edit_var('modify','gc_user_imax93',num2str(new_gc_max_pwr*1000/evalin('base','max(gc_reg_volt1,gc_reg_volt2)')));
            gui_edit_var('modify','gc_user_imax12',num2str(new_gc_max_pwr*1000/evalin('base','max(gc_reg_volt1,gc_reg_volt2)')));
            set(findobj('tag','gc_max_pwr'),'string',num2str(round(new_gc_max_pwr)));
            %gui_edit_var('modify','gc_max_pwr');
            
        end
        
        recompute_mass
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99
        
        
        
    case 'mc_max_pwr'
        new_mc_max_pwr=str2num(get(findobj('tag','mc_max_pwr'),'string'));
        
        mc_spd_scale=evalin('base','mc_spd_scale');
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(new_mc_max_pwr)
            mc_trq_scale=evalin('base','mc_trq_scale');
            set(findobj('tag','mc_max_pwr'),'string',num2str(round(mc_trq_scale*mc_spd_scale*vinf.motor_controller.def_max_pwr)))
            return
        end
        
        mc_trq_scale=new_mc_max_pwr/mc_spd_scale/vinf.motor_controller.def_max_pwr;
        set(findobj('tag','mc_max_pwr'),'string',num2str(round(new_mc_max_pwr)));
        
        %may be needed to fix the default
        assignin('base','mc_trq_scale',1);
        gui_edit_var('modify','mc_trq_scale',num2str(mc_trq_scale))
        recompute_mass
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99 ??? is this necessary
        
    case 'mc_peak_eff'
        new_mc_peak_eff=str2num(get(findobj('tag','mc_peak_eff'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(new_mc_peak_eff)
            mc_eff_scale=evalin('base','mc_eff_scale');
            set(findobj('tag','mc_peak_eff'),'string',num2str(round(100*mc_eff_scale*vinf.motor_controller.def_peak_eff)/100))
            return
        end
        
        mc_eff_scale=new_mc_peak_eff/vinf.motor_controller.def_peak_eff;
        
        gui_edit_var('modify','mc_eff_scale',num2str(mc_eff_scale));
        
        %run the file that actually modifies the eff and pwr loss maps
        %eff_scaling('mc'); % 24-Aug-2001 don't call this here--it gets called on line 362, if we call here, 
        % eff is scaled twice from the GUI...
        
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99
        
        
    case 'tx_peak_eff'
        new_tx_peak_eff=str2num(get(findobj('tag','tx_peak_eff'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(new_tx_peak_eff)
            gb_eff_scale=evalin('base','gb_eff_scale');
            set(findobj('tag','tx_peak_eff'),'string',num2str(round(100*gb_eff_scale*vinf.transmission.def_peak_eff)/100))
            return
        end
        
        gb_eff_scale=new_tx_peak_eff/vinf.transmission.def_peak_eff;
        
        gui_edit_var('modify','gb_eff_scale',num2str(gb_eff_scale))
        
    case 'ess_num_modules'
        ess_module_number=str2num(get(findobj('tag','ess_num_modules'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(ess_module_number)
            ess_module_num=evalin('base','ess_module_num');
            set(findobj('tag','ess_num_modules'),'string',num2str(ess_module_num))
            return
        end
        
        volt=evalin('base','mean(mean(ess_voc))');
        set(findobj('tag','ess_voltage'),'string',num2str(round(ess_module_number*volt)));
        %ess mass
        ess_mass=evalin('base','ess_module_mass*ess_module_num');
        set(findobj('tag','ess_mass'),'string',num2str(round(ess_mass)));
        
        %set default number of modules to zero so it is the default  
        assignin('base','ess_module_num',0);
        gui_edit_var('modify','ess_module_num',num2str(ess_module_number));  
        recompute_mass
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99
        
    case 'ess2_num_modules'
        ess2_module_number=str2num(get(findobj('tag','ess2_num_modules'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(ess2_module_number)
            ess2_module_num=evalin('base','ess2_module_num');
            set(findobj('tag','ess2_num_modules'),'string',num2str(ess2_module_num))
            return
        end
        
        volt2=evalin('base','mean(mean(ess2_voc))');
        set(findobj('tag','ess2_voltage'),'string',num2str(round(ess2_module_number*volt2)));
        %ess mass
        ess2_mass=evalin('base','ess2_module_mass*ess2_module_num');
        set(findobj('tag','ess2_mass'),'string',num2str(round(ess2_mass)));
        
        %set default number of modules to zero so it is the default  
        assignin('base','ess2_module_num',0);
        gui_edit_var('modify','ess2_module_num',num2str(ess2_module_number));  
        recompute_mass
        %gui_run_files('powertrain_control'); %tm:5/20/99
        adjust_cs % tm 5/20/99
        
    case 'cargo_mass'
        cargo_mass=str2num(get(findobj('tag','cargo_mass'),'string'));
        
        %check to make sure user entered a number if not put number in and return out of this case
        if isempty(cargo_mass)
            cargo_mass=evalin('base','veh_cargo_mass');
            set(findobj('tag','cargo_mass'),'string',num2str(round(cargo_mass)))
            return
        end
        
        gui_edit_var('modify','veh_cargo_mass',num2str(cargo_mass));  
        recompute_mass
        
    end; %end switch option
end;%end if nargin>0

%9/16/98-sam added run powertrain control after mc power scaling and efficiency scaling
%09/28/98:tm editted fc_max_pwr,mc_max_pwr, and gc_max_pwr cases such that the proper trq_scale 
%				value is maintained after and autosize run
% 11/3/98:tm introduced vinf.autosize_run_status variable, set to 0 if anything is changed
% 12/30/98:tm added rounding to peak efficiency for fc and tx
% 
% 1/27/99:ss added the following line for thermal models:
%evalin('base','fc_pwr_scale=fc_trq_scale*fc_spd_scale')
% 2/2/99:ss added case 'cargo_mass' and if statement under 'modify'
% 7/2/99:tm replaced calls to powertrain contro file with adjust_cs calls
% 7/6/99:ss under var fc_eff_scale updated so only fc maps necessary for scaling efficiency are used
%            in routine.  (had problems with fc_pwr_scale changing).
% 8/17/99 ss: added semicolon after new_fc_max_pwr to avoid display in workspace
% 9/20/99:tm modified case fc_max_pwr for to work with new fuel cell varialbes
% 9/21/99:tm modified case modify so that fc_pwr_scale included and so fc_spd_scale not allowed for fuelcells
% 9/22/99: ss updated the mean voltage for batteries to be mean(mean(voltage)) so only one value displayed in input figure
% 10/7/99: ss added running of ptc file for fc_spd_scale case and added running gui_inpchk after fc scaling variables are modified
% 11/02/99:tm added conditional to only run the gui_inpchk function if the input figure exists - for parametric runs
% 11/02/99:tm modified run ptc file after fc_spd_scale mod case to run adjust_cs after spd_scale, pwr_scale, and trq_scale mod case
% 11/3/99:ss called recompute_mass instead of gui_run_files('calc_total_mass')
% 11/4/99:ss deleted out all areas that set the mass in gui and had previously used vinf.*.def_mass variables which are
%            no longer necessary and everything is taken care of in recompute_mass.
% 12/15/99:ss changed the rounding of the voltage from the individual module calculation to where it is multiplied by the number of modules.
% 3/1/00:ss on line 179 under the if i==1 (if variable to be deleted is the first one) added if and else statements
%           to prevent whole list from being deleted if only wanted to delete the first item.
% 3/15/00:tm add "adjust_cs" to case modify, case gc_spd_scale, gc_trq_scale so 
%            that the design curve updates based on the modified parameters
% 7/21/00 ss: updated name for version info to advisor_ver.
% 8/15/00:tm changed tx_eff_scale to gb_eff_scale in lines 589, 590, and 594
% 8/21/00:tm added statements to handle effects of gearbox scaling
% 5/18/01:tm revised update of fc_trq_scale when fc_pwr_scale is modified to use the gui_edit_var function to ensure proper variable tracking in saved vehicle file
% 7/27/01:tm added statements to modify case to call recompute mass if ess_cap_scale is modified
% 8/24/01:mpo commented out a second call to eff_scaling('mc') that was causing double scaling to mc from GUI
% 11/20/02:tm on line 300 changed assiginin to evalin so that it will work with indexed variables ie. variable_name(1,2)=...
% 11/20/02:tm repeated above change for lines 375 and 394
% 6/6/03:tm added a call to recompute mass at the end of the modify case to eliminate the need for all of the special cases
