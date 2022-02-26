function varargout = InputFig(varargin)
% InputFig Application M-file for InputFig.fig
%    FIG = InputFig launch InputFig GUI.
%    InputFig('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 24-Apr-2013 15:04:09

if nargin == 0  % LAUNCH GUI
    
    fig = openfig(mfilename,'reuse');
    
    %set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    
    % Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
    %-----------------------------------------------------------------------
    %additional code added by ss 1/15/03 (from old InputFigControl.m file)
    global vinf
    
    %not sure if this is needed or not
    evalin('base','global vinf');
    
    waitbar(0,'loading setup figure...')
    
    try %this try is necessary if more than one waitbar is open in matlab 5.2 version, not necessary for 5.3
        waitbar(.5);%this is waitbar for  loading input figure
    end
    
    % Initialize Altia on off var (Autosize needs it here)
    vinf.interactive_sim=0;
    
    % disable all psat buttons if running advisor
    if strcmp(vinf.model,'ADVISOR')
        set(findobj('userdata','PSAT'),'enable','off')
        list={'motor2_checkbox','starter_checkbox','transmission2_checkbox',...
                'clutch_checkbox',...
                'accessory_electrical_checkbox'};
        for i=1:length(list)
            set(findobj('tag',list{i}),'visible','off')
        end
        
    end
    
    %set the name for the figure
    set(fig,'Name',['Vehicle Input--',advisor_ver('info')])
    
    %set up the menubar
    adv_menu('input');
    
    %make sure file_name shows up in the popupmenu list (add only adds if it doesn't exist)
    string=optionlist('add','input_file_names',vinf.name);
    value=optionlist('value','input_file_names',vinf.name);
    set(findobj('tag','input_file_names'),'string',string,'value',value);
    
    
    %set the popup menus' strings
    
    %list contains the tags for the popup uicontrols
    list={'drivetrain',...
            'torque_coupling',...
            'motor_controller',...
            'exhaust_aftertreat',...
            'vehicle'};
    %set the uicontrol values and strings appropriately   
    for i=1:length(list)
        % Section added 9/27/00:tm to ensure component name in menu
        if isfield(vinf, list{i})
            if ~strcmp(list{i},'drivetrain')
                % update gui menus if necessary
                update_menu(list{i})
            end
        end 
        % end section added 9/27/00:tm
        eval(['SetString(''',list{i},''')'])
        if isfield(vinf, list{i})
            eval(['SetValue(''',list{i},''')'])
        end 
    end
    
    %______set the version,type and then main popupmenus for components in list2
    list2={'fuel_converter',...
            'generator',...
            'energy_storage' ,...
            'energy_storage2',...
            'transmission',...
            'wheel_axle',... 
            'powertrain_control',...
            'accessory'};
    for i=1:length(list2)
        if isfield(vinf, list2{i})
            % Section added 9/27/00:tm to ensure component name in menu
            % update gui menus if necessary
            update_menu(list2{i})
            % end section added 9/27/00:tm
            
            %------this sets version and type popupmenus
            
            %first set version
            %figure out the tag for the version popupmenu
            tag=[list2{i},'_ver'];
            
            %get the current version for the component from the vinf variable
            update_vinf_ver_type(list2{i});
            
            currentstr=eval(['vinf.',list2{i},'.ver']);
            
            %set the string and value in the version popupmenu
            set_popup_ver(list2{i})
            
            % set the string and value in the type popupmenu
            set_popup_type(list2{i})
            
            %now set the component popupmenu.
            set_popup(list2{i})   
            
        end
    end
    %__________end of version, type and main popupmenu setup.
    
    %set options for input plotting
    %SetString('input_plots',optionlist('get','input_plots'))
    input_plot_selection
    
    %if there exist a modified variable called veh_mass then set checkbox and value
    %for override mass1
    eval('temp=vinf.variables.name; test4exist=1;','test4exist=0;'); %exist(vinf.variables.name)
    if test4exist
        test2=strmatch('veh_mass',vinf.variables.name,'exact');
        if test2>0
            set(findobj('tag','override_mass_checkbox'),'value',1)
            set(findobj('tag','override_mass_value'),'string',num2str(vinf.variables.value(test2)));
        end
    end
    
    %set everything normalized so figure size can be modified
    
    h=findobj(fig,'type','uicontrol');
    g=findobj(fig,'type','axes');
    
    set([h; g],'units','normalized')
    
    %_______set the figure size by defining vinf.gui_size and then setting the size
    if ~isfield(vinf,'gui_size')
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            vinf.gui_size=[(screensize(3)-901)/2 (screensize(4)-610)/2 901 610];
        else
            vinf.gui_size=[1    29   800   534];
            warnhandle=warndlg({'Best to have a resolution setting of 1024x768 or higher.  Screens will be compressed for your current resolution setting!'});
            uiwait(warnhandle);
        end
    end
    
    set(fig,'units','pixels','position',vinf.gui_size);
    
    %_____________end set the figure size
    
    
    InputFig('update_vinf_fields') %this will remove unnecessary component fields from vinf
    
    %set the figure back on after everything is drawn
    set(fig,'visible','on');
    gui_image;
    gui_run_files('load');
    InputFig('override_mass');
    
    %set the existing components to enable 'on' or 'off': used to be in gui_image ss 8/2/00
    if ~isfield(vinf,'powertrain_control')
        InputFig('enable','off','powertrain_control')
    end
    if ~isfield(vinf,'vehicle')
        InputFig('enable','off','vehicle')
    end
    if ~isfield(vinf,'transmission')
        InputFig('enable','off','transmission')
    end
    if ~isfield(vinf,'wheel_axle')
        InputFig('enable','off','wheel_axle')
    end
    if ~isfield(vinf,'accessory')
        InputFig('enable','off','accessory')
    end
    
    if ~isfield(vinf,'torque_coupling')
        InputFig('enable','off','torque_coupling')
    end
    if ~isfield(vinf,'generator')
        InputFig('enable','off','generator')
    end
    if ~isfield(vinf,'motor_controller')
        InputFig('enable','off','motor_controller')
    end
    if ~isfield(vinf,'energy_storage')
        InputFig('enable','off','energy_storage')
    end
    if ~isfield(vinf,'energy_storage2')
        InputFig('enable','off','energy_storage2')
    end
    if ~isfield(vinf,'fuel_converter')
        InputFig('enable','off','fuel_converter')
    end
    if ~isfield(vinf,'exhaust_aftertreat')
        InputFig('enable','off','exhaust_aftertreat')
    end
    
    %update the checkboxes
    list={'powertrain_control','vehicle','fuel_converter','exhaust_aftertreat','energy_storage','energy_storage2',...
            'motor_controller','generator','transmission','torque_coupling','wheel_axle','accessory'};
    for i=1:length(list)
        value=strcmp(get(findobj('tag',list{i}),'enable'),'on');
        if strcmp(vinf.drivetrain.name,'custom')
            set(findobj('tag',[list{i},'_checkbox']),'value',value)
        else
            set(findobj('tag',[list{i} '_checkbox']),'enable','off','value',value)
        end
        
    end
    % end of checkbox section
    
    %run the input check file
    evalin('base','gui_inpchk');
    
    waitbar(1)
    close(findobj('tag','TMWWaitbar')); 	%close the waitbar   
    
    %sound file for when input figure is opened.(if system can do sound)
    try
        load list_optionlist.mat;  %loads list_optionlist and list_def
        if findstr(lower(list_def),'truck')
            [horn_sound,fs]=wavread('truckhorn.wav');
        else
            [horn_sound,fs]=wavread('horn.wav');
        end
        sound(horn_sound,fs)
    end
    %------------------------------------ end of additional code
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
    try
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
    catch
        disp(lasterr);
    end
    
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = units(h, eventdata, handles, varargin)
%nothing here for this figure yet.

% --------------------------------------------------------------------
function varargout = override_mass(h, eventdata, handles, varargin)
if get(findobj('Tag','override_mass_checkbox'),'value')==1
    set(findobj('Tag','override_mass_value'),'enable','on');
else
    set(findobj('Tag','override_mass_value'),'enable','off');
end %value==1

% --------------------------------------------------------------------
function varargout = autosize(h, eventdata, handles, varargin)
global vinf        
if strcmp(vinf.drivetrain.name,'prius_jpn')
    h=warndlg('The autosize function is not available for the Japanese Prius','Autosize Warning');
    uiwait(h);
elseif strcmp(vinf.drivetrain.name,'fuel_cell')&(strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool'))
    h=warndlg('The autosize function is not available for type of fuel cell selected','Autosize Warning');
    uiwait(h);
else
    autosize_setup('load')
end

% --------------------------------------------------------------------
function varargout = ver(h, eventdata, handles, varargin)
global vinf
%find out what component called this
tag=get(gcbo,'tag');
compo=strrep(tag,'_ver',''); %short name
component=compo_name(compo); %long name

%get the version selected
version=gui_current_str(tag);

%if the same ver is selected then return without doing anything
if strcmp(eval(['vinf.' component '.ver']),version)
    return
end

%compatibility function call: at this point vinf.*.ver should be the old version.
compatible_choice=compatibility(tag,version);

%set back to original selection if new selection is not compatible
if ~compatible_choice
    set(gcbo,'value',optionlist('value',[compo '_ver'],eval(['vinf.',component , '.ver'])))   
    msgbox('Selection is not compatible with other settings.','Compatibility Warning','error','modal')
    return
end


eval(['vinf.',component,'.ver=''',version,''';'])

if isfield(eval(['vinf.' component]),'type')
    %update type list and set to top value (1)
    set(findobj('tag',[compo,'_type']),'string',optionlist('get',[compo,'_type'],'junk',version),'value',1);
    type=gui_current_str([compo,'_type']);
    eval(['vinf.',component,'.type=''',type,''';'])
    
    set(findobj('tag',component),'string',optionlist('get',component,'junk',version,type),'value',1)
else   
    set(findobj('tag',component),'string',optionlist('get',component,'junk',version),'value',1)
end

evalin('base',get(findobj('tag',component),'callback'))

%if plot selection is set to the component being changed then update plot list
plot_component=gui_current_str('input_plots_components');
if strcmp(plot_component,component)
    eval(get(findobj('tag','input_plots_components'),'callback'))
end

% --------------------------------------------------------------------
function varargout = type_select(h, eventdata, handles, varargin)
global vinf
%find out what component called this
tag=get(gcbo,'tag');
compo=strrep(tag,'_type',''); %short name
component=compo_name(compo); %long name

%get the type selected
type=gui_current_str(tag);

%get the version selected
version=gui_current_str([compo,'_ver']);

% when changing accessory type sv/dv, clear aux loads
if strcmp(version,'Saber') & strcmp(type,'SV')
    vinf=rmfield(vinf,'AuxLoads');
end

%compatibility function call: at this point vinf.*.ver should be the old version.
compatible_choice=compatibility(tag,type);

%set back to original selection if new selection is not compatible
if ~compatible_choice
    set(gcbo,'value',optionlist('value',[compo '_type'],eval(['vinf.',component , '.type']) , version ))   
    msgbox('Selection is not compatible with other settings.','Compatibility Warning','error','modal')
    return
end


%find out what type was selected and update component list appropriately
eval(['vinf.',component,'.type=''',type,''';'])

set(findobj('tag',component),'string',optionlist('get',component,'junk',version,type),'value',1)

evalin('base',get(findobj('tag',component),'callback'))

% --------------------------------------------------------------------
function varargout = checkbox(h, eventdata, handles, varargin)
global vinf
%find out what component called this
component=strrep(get(gcbo,'tag'),'_checkbox','');
compo=compo_name(component); %short name for component (ex.fc for fuel_converter)
value=get(gcbo,'value');

if value %if component checkbox was checked
    %list of components for which type and ver are defined.
    list={'fuel_converter','accessory','wheel_axle','generator','energy_storage','energy_storage2','transmission','powertrain_control'};
    %if component is in the list, set up ver and type
    if ~isempty(strmatch(component,list))
        %set the version menu
        verlistname=[compo,'_ver'];
        set(findobj('tag',[compo,'_ver']),'string',optionlist('get',verlistname),'value',1)
        %set the type menu
        version=gui_current_str([compo,'_ver']);
        set(findobj('tag',[compo,'_type']),'string',optionlist('get',[compo '_type'],'junk',version),'value',1)
        %select the first component in the list and run it
        
        
        
        type=gui_current_str([compo,'_type']);
        set(findobj('tag',component),'string',optionlist('get',component,'junk',version,type),'value',1)
        %set up the vinf variable
        eval(['vinf.' component '.type=''' type ''';'])
        eval(['vinf.' component '.ver=''' version ''';'])
        eval(['vinf.' component '.name=''' gui_current_str(component) ''';'])
        evalin('base',get(findobj('tag',component),'callback'))
        %make all the appropriate uicontrols enabled
        InputFig('enable','on',component) %this sets all the appropriate uicontrols enabled
        
    else %for version and type not defined for this component
        InputFig('enable','on',component)
        set(findobj('tag',component),'string',optionlist('get',component),'value',1)
        eval(['vinf.' component '.name=''' gui_current_str(component) ''';'])
        evalin('base',get(findobj('tag',component),'callback'))
    end
    
else %if component checkbox is not checked
    %disable appropriate uicontrols and remove component from vinf
    InputFig('enable','off',component)
    DataFileName=evalin('base',['vinf.',component,'.name']);
    RemoveVars(DataFileName);
    if isfield(vinf,component) 
        vinf=rmfield(vinf,component);
    end
end %if component checkbox is checked

% --------------------------------------------------------------------
function varargout = update_vinf_fields(h, eventdata, handles, varargin)
global vinf
switch vinf.drivetrain.name
case 'conventional'
    fields2remove={'torque_coupling','energy_storage','motor_controller','generator'};
case 'series'
    fields2remove={'torque_coupling'};
case  'parallel'
    fields2remove={'generator'};
case 'parallel_sa'
    fields2remove={'generator'};
case 'fuel_cell'
    fields2remove={'generator', 'torque_coupling'};
case 'ev'
    fields2remove={'fuel_converter','generator','exhaust_aftertreat','torque_coupling'};
case 'prius_jpn'
    fields2remove={'torque_coupling'};
case 'insight'
    fields2remove={'insight'};
case 'saber_conv_sv'
    fields2remove={};
case 'saber_conv_dv'
    fields2remove={};
case 'saber_ser'
    fields2remove={};
case 'saber_par'
    fields2remove={};
case 'custom'
    fields2remove={};
    
end %case vinf.drivetrain.name
for i=1:length(fields2remove)
    if  isfield(vinf,fields2remove{i})
        vinf=rmfield(vinf,fields2remove{i});
    end
end

% --------------------------------------------------------------------
function varargout = enable(option2,option3)
global vinf
on_off_str=option2;
component=option3;
not_custom=~strcmp(vinf.drivetrain.name,'custom');
clear h
fig=findobj('tag','input_figure');
if strcmp(component,'powertrain_control')
    h(1)=findobj(fig,'tag','ptc_pushbutton');
    h(2)=findobj(fig,'tag','powertrain_control');
    h(3)=findobj(fig,'tag','ptc_ver');
    h(4)=findobj(fig,'tag','ptc_type');
    if not_custom
        h(5)=findobj(fig,'tag','powertrain_control_checkbox');
    end
    set(h,'enable',on_off_str); 
    clear h
    return
end
if strcmp(component,'vehicle')
    h(1)=findobj(fig,'tag','veh_pushbutton');
    h(2)=findobj(fig,'tag','vehicle');
    h(3)=findobj(fig,'tag','veh_ver');
    h(4)=findobj(fig,'tag','veh_type');
    h(5)=findobj(fig,'tag','veh_mass');
    if not_custom
        h(6)=findobj(fig,'tag','vehicle_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'transmission')
    h(1)=findobj(fig,'tag','tx_pushbutton');
    h(2)=findobj(fig,'tag','transmission');
    h(3)=findobj(fig,'tag','tx_ver');
    h(4)=findobj(fig,'tag','tx_type');
    h(5)=findobj(fig,'tag','tx_mass');
    h(6)=findobj(fig,'tag','tx_peak_eff');
    if not_custom
        h(7)=findobj(fig,'tag','transmission_checkbox');
    end   
    set(h,'enable',on_off_str); 
    set(h(5:6),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'wheel_axle')
    h(1)=findobj(fig,'tag','wh_pushbutton');
    h(2)=findobj(fig,'tag','wheel_axle');
    h(3)=findobj(fig,'tag','wh_ver');
    h(4)=findobj(fig,'tag','wh_type');
    h(5)=findobj(fig,'tag','wh_mass');
    if not_custom
        h(6)=findobj(fig,'tag','wheel_axle_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'accessory')
    h(1)=findobj(fig,'tag','acc_pushbutton');
    h(2)=findobj(fig,'tag','accessory');
    h(3)=findobj(fig,'tag','acc_ver');
    h(4)=findobj(fig,'tag','acc_type');
    if not_custom
        h(5)=findobj(fig,'tag','accessory_checkbox');
    end
    set(h,'enable',on_off_str); 
    clear h
    return
end

if strcmp(component,'torque_coupling')
    h(1)=findobj(fig,'tag','tc_pushbutton');
    h(2)=findobj(fig,'tag','torque_coupling');
    h(3)=findobj(fig,'tag','tc_peak_eff');   
    h(4)=findobj(fig,'tag','tc_ver');
    h(5)=findobj(fig,'tag','tc_type');
    if not_custom
        h(6)=findobj(fig,'tag','torque_coupling_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'generator')
    h(1)=findobj(fig,'Tag','gc_pushbutton');
    h(2)=findobj(fig,'Tag','generator');	
    h(3)=findobj(fig,'Tag','gc_max_pwr');
    h(4)=findobj(fig,'Tag','gc_peak_eff');
    h(5)=findobj(fig,'Tag','gc_mass');
    h(6)=findobj(fig,'Tag','gc_ver');	
    h(7)=findobj(fig,'Tag','gc_type');	
    if not_custom
        h(8)=findobj(fig,'tag','generator_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3:5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'motor_controller')
    h(1)=findobj(fig,'Tag','mc_pushbutton');
    h(2)=findobj(fig,'Tag','motor_controller');
    h(3)=findobj(fig,'Tag','mc_max_pwr');
    h(4)=findobj(fig,'Tag','mc_peak_eff');
    h(5)=findobj(fig,'Tag','mc_mass');
    h(6)=findobj(fig,'Tag','mc_ver');
    h(7)=findobj(fig,'Tag','mc_type');
    if not_custom
        h(8)=findobj(fig,'tag','motor_controller_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3:5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'energy_storage')
    h(1)=findobj(fig,'Tag','ess_pushbutton');
    h(2)=findobj(fig,'Tag','energy_storage');
    h(3)=findobj(fig,'Tag','ess_num_modules');
    h(4)=findobj(fig,'Tag','ess_voltage');
    h(5)=findobj(fig,'Tag','ess_mass');
    h(6)=findobj(fig,'tag','ess_ver');
    h(7)=findobj(fig,'tag','ess_type');
    if not_custom
        h(8)=findobj(fig,'tag','energy_storage_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3:5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'energy_storage2')
    h(1)=findobj(fig,'Tag','ess2_pushbutton');
    h(2)=findobj(fig,'Tag','energy_storage2');
    h(3)=findobj(fig,'Tag','ess2_num_modules');
    h(4)=findobj(fig,'Tag','ess2_voltage');
    h(5)=findobj(fig,'Tag','ess2_mass');
    h(6)=findobj(fig,'tag','ess2_ver');
    h(7)=findobj(fig,'tag','ess2_type');
    if not_custom
        h(8)=findobj(fig,'tag','energy_storage2_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3:5),'visible',on_off_str)
    clear h
    return
end
if strcmp(component,'fuel_converter')
    h(1)=findobj(fig,'Tag','fc_pushbutton');
    h(2)=findobj(fig,'Tag','fuel_converter');
    h(3)=findobj(fig,'Tag','fc_max_pwr');
    h(4)=findobj(fig,'Tag','fc_peak_eff');
    h(5)=findobj(fig,'Tag','fc_mass');
    h(6)=findobj(fig,'Tag','fc_ver');
    h(7)=findobj(fig,'Tag','fc_type');
    if not_custom
        h(8)=findobj(fig,'tag','fuel_converter_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3:5),'visible',on_off_str);
    clear h
    return
end
if strcmp(component,'exhaust_aftertreat')
    h(1)=findobj(fig,'Tag','ex_pushbutton');
    h(2)=findobj(fig,'Tag','exhaust_aftertreat');
    h(3)=findobj(fig,'Tag','ex_mass');
    h(4)=findobj(fig,'Tag','ex_ver');
    h(5)=findobj(fig,'Tag','ex_type');
    if not_custom
        h(6)=findobj(fig,'tag','exhaust_aftertreat_checkbox');
    end
    set(h,'enable',on_off_str); 
    set(h(3),'visible',on_off_str);
    clear h
    return
end

% --------------------------------------------------------------------
function SetString(tag,string)
h=findobj('tag',tag);

if nargin==1
    set(h,'string',eval(['optionlist(''get'',''',tag,''')']));
else
    set(h,'string',string);
end

% --------------------------------------------------------------------
function SetValue(tag,value)
h=findobj('tag',tag);
if nargin==1 
    set(h,'value',eval(['gui_current_val(''',tag,''')']));
else
    set(h,'value',value)
end

% --------------------------------------------------------------------
function RemoveVars(DataFile)
global vinf
try % try is used because in some cases, to load a data file, another data file must be loaded first
    eval(DataFile);
    Vars=who;
    NumVars=length(Vars);
    for i=1:NumVars
        if ~strcmp(Vars,'vinf')
            evalin('base',['clear ',Vars{i}]);
        end
    end
end

% --------------------------------------------------------------------
function varargout = front_wheel_drive_Callback(h, eventdata, handles, varargin)
%radiobutton
set(h,'value',1)

%set front wheel drive boolean on
gui_edit_var('modify','wh_front_active_bool','1')

%turn off other two buttons and set variables accordingly
set(findobj('tag','rear_wheel_drive'),'value',0)
gui_edit_var('modify','wh_rear_active_bool','0')

set(findobj('tag','four_wheel_drive'),'value',0)


% --------------------------------------------------------------------
function varargout = rear_wheel_drive_Callback(h, eventdata, handles, varargin)
%radiobutton
%set rear wheel drive boolean on
set(h,'value',1)
gui_edit_var('modify','wh_rear_active_bool','1')

%turn off other two buttons and set variables accordingly
set(findobj('tag','front_wheel_drive'),'value',0)
gui_edit_var('modify','wh_front_active_bool','0')

set(findobj('tag','four_wheel_drive'),'value',0)



% --------------------------------------------------------------------
function varargout = four_wheel_drive_Callback(h, eventdata, handles, varargin)
%radiobutton
set(h,'value',1)

%turn off other two buttons and set variables accordingly
set(findobj('tag','front_wheel_drive'),'value',0)
gui_edit_var('modify','wh_front_active_bool','1')

set(findobj('tag','rear_wheel_drive'),'value',0)
gui_edit_var('modify','wh_rear_active_bool','1')

% --------------------------------------------------------------------
function varargout = four_wheel_drive_help_Callback(h, eventdata, handles, varargin)
load_in_browser('traction_control.html');

% --- Executes on button press in main_help_button.
function main_help_button_Callback(hObject, eventdata, handles)
% hObject    handle to main_help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load_in_browser('advisor_ch2.html', '#2.1.1');

% --- Executes on button press in Pushbutton4.
function version_type_help_button_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load_in_browser('version_type_help.html');

% 3/20/00 ss: added case 'units'
% 7/11/00 ss: added the functionality for the new popupmenu for selecting vehicles.
% 7/17/00 ss: replaced calls to gui options with optionlist
% 7/20/00 ss: replaced test4exist in eval statement for vinf.gui_size with isfield
% 7/21/00 ss: updated name for version info to advisor_ver.
% 8/1/00 ss:  updated to use ver and type with fuel converter.
% 8/15/00 ss: updated tag names under case 'enable'
% 8/15/00 ss: updated cases 'ver' and 'type' for new way of using optionlist with cell arrays.
% 8/18/00 ss: added setting the default value for input plots to fc_efficiency.
% 9/27/00:tm added statements to the nargin==0 case to ensure component name exists in menus
% 1/22/01 ab: added intereactive_sim initialization (prevents error during autosize)
% 2/2/01: ss updated prius to prius_jpn
% 2/8/01: ss updated case 'ver' to update the plotting selection when component ver being changed
% 2/12/01: ss updated case 'ver' to ignore cases when user selects the same version again.
%02/14/01: vhj added saber co-sim cases, call 'saber_cosim' case to define vinf.saber_cosim
%02/15/01: vhj updated vinf variable to be named vinf.saber_cosim.run, added vinf.saber_cosim.type
%02/20/01: vhj remember a selected saber cosim when returning from other screens
%08/22/01: ab made saber button visible (post 3.2 release)
%03/26/02: ab eliminated saber cosim button and checkbox: no longer needed
%1/15/03: ss converted to the standard format for GUIs in Matlab R12