function varargout = SimSetupFig(varargin)
% SIMSETUPFIG Application M-file for SimSetupFig.fig
%    FIG = SIMSETUPFIG launch SimSetupFig GUI.
%    SIMSETUPFIG('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 13-Feb-2003 15:09:33

if nargin == 0  % LAUNCH GUI
    
    fig = openfig(mfilename,'new'); %'reuse' wasn't working when SOC figure was up 
    %fig = openfig(mfilename,'reuse');
    
    % Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
    %------------------------------
    global vinf
    
    waitbar(0,'loading setup figure...')
    try
        waitbar(0.25);
    end
    
    %set the name for the figure
    set(fig, 'Name',['Simulation Parameters--',advisor_ver('info')])
    
    %set up the menubar
    adv_menu('execute');
    
    %check to see if vinf.init_conds exists, if not then run the default file
    if ~isfield(vinf,'init_conds')
        evalin('base','init_conds');%this is the file with the default init conditions in it stored in vinf.init_conds
    end
    
    %set up default values for the simulation setup figure if not already existing   
    if ~isfield(vinf,'cycle'); %set up the defaults
        vinf.cycle.run='on';
        vinf.test.run='off';
        vinf.multi_cycles.run='off';%ss 1/25/01
        
        vinf.time_step=1;
        vinf.cycle.number=1;
        vinf.cycle.name='CYC_UDDS';
        vinf.cycle.soc='off';
        vinf.cycle.socmenu='zero delta';
        vinf.cycle.SOCiter=15;
        vinf.cycle.SOCtol=0.5;	%in percent
        vinf.cycle.ess2fuel_tol=1; %ratio of net ess stored energy to fuel energy used in percent
        vinf.cycle.soc_tol_method='soctol'; %soctol or ess2fuel
        
        evalin('base',['clear ',vinf.cycle.name]); % mpo:8/6/01 required statement to force Matlab to 
        % search for the newly modified file rather than 
        % reference functions in memory            
        
        evalin('base',vinf.cycle.name);%run so information is available for filtering
        
        % build cycle grade vector if not defined tm:8/23/99
        if evalin('base','size(cyc_grade,2)')<2
            evalin('base',['cyc_grade=[0 cyc_grade; 1 cyc_grade];']) 
        end
        
        filter_bool=evalin('base','cyc_filter_bool');
        if filter_bool==1
            vinf.cycle.filter='on';
        else
            vinf.cycle.filter='off';
        end
        vinf.cycle.filter_value=evalin('base','cyc_avg_time');
        
        vinf.test.name='TEST_CITY_HWY';
        
        vinf.gradeability.run='off';
        vinf.gradeability.speed=55;%mph
        vinf.acceleration.run='off';
        vinf.road_grade.run='off';
        vinf.road_grade.value=1.5;
        vinf.interactive_sim=0;
        vinf.parametric.run='off';
        vinf.parametric.number_variables=1;
        vinf.parametric.var={'veh_mass'; 'veh_CD' ; 'veh_FA'};
        vinf.parametric.low=[evalin('base',vinf.parametric.var{1});evalin('base',vinf.parametric.var{2});evalin('base',vinf.parametric.var{3})];
        vinf.parametric.high=vinf.parametric.low+[400; .2; 2];
        vinf.parametric.number=[3 3 3];
        vinf.parametric.saveRuns=0;
        vinf.parametric.savePrefix='cp';
        vinf.parametric.saveDir=strrep(which('advisor.m'),'advisor.m','');
    end
    
    %Drive Cycles Setup
    set(findobj('tag','cycle_radiobutton'),'Value',strcmp('on',vinf.cycle.run));
    
    %Disable the cycle button if test cycles chosen
    if strcmp(vinf.cycle.run,'off')
        set(findobj('Tag','cycle_pushbutton'),'enable','off');
    end
    
    %     %   Setup aux load values
    %     if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
    %         
    %         load Default_aux.mat;
    %         vinf.AuxLoads=AuxLoads;
    %         clear AuxLoads;
    %         % AuxLoadsFigControl('LoadAuxVars');
    %         
    %     end
    % 
    %     if ~isfield(vinf.AuxLoads,'On')
    %         vinf.AuxLoads.On=0;
    %     end
    set(findobj('tag','AuxLoads_checkbox'),'value',vinf.AuxLoadsOn);
    
    %   Turn off 42V loads for non DV
    if isfield(vinf,'energy_storage') & strcmp(vinf.energy_storage.ver,'saber') & isempty('who ess2_*') 
        V42Loads=GetLoadNames('Volt42OnlyLoad');
        for i=1:length(V42Loads)
            eval(['vinf.AuxLoads.',V42Loads{i},'.On=0;']);
        end
        
        V42Or14Loads=GetLoadNames('Volt42Or14Loads');
        for i=1:length(V42Or14Loads)
            if eval(['vinf.AuxLoads.',V42Or14Loads{i},'.On']) & eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V42'])
                eval(['vinf.AuxLoads.',V42Or14Loads{i},'.On=0;']);
                eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V42=0;']);
                eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V14=1;']);
            elseif eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V42'])
                eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V42=0;']);
                eval(['vinf.AuxLoads.',V42Or14Loads{i},'.V14=1;']);
            end
        end
    end
    
    
    
    %Cycle popupmenu
    set(findobj('tag','cycles'),...
        'String',optionlist('get','cycles'), ...
        'Value',optionlist('value','cycles',vinf.cycle.name));
    
    %enable or disable all cycle related items
    set(findobj('UserData','cycle'),'enable',vinf.cycle.run);
    
    %set time_step
    set(findobj('tag','time_step'),'string',num2str(vinf.time_step));
    
    %set number of cycles
    set(findobj('tag','num_of_cycles'),'string',num2str(vinf.cycle.number))
    
    %set checkbox for soc correction
    set(findobj('tag','soc_checkbox'),'value',strcmp('on',vinf.cycle.soc));
    if strcmp(vinf.drivetrain.name,'conventional')|strcmp(vinf.drivetrain.name,'ev')
        set(findobj('tag','soc_checkbox'),'enable','off','value',0)
        vinf.cycle.soc='off';   
    end
    
    %set the soc popupmenu value and list
    set(findobj('tag','soc_popupmenu'),'string',optionlist('get','soc'),...
        'Value',optionlist('value','soc',vinf.cycle.socmenu));
    
    %set the string for #iters of soc
    set(findobj('tag','SOC_iters_num'),'String',num2str(vinf.cycle.SOCiter));
    
    %set the string for soc tolerance %
    set(findobj('tag','soc_tol_num'),'String',num2str(vinf.cycle.SOCtol));
    
    %set the string for ess2fuel ratio tolerance %
    set(findobj('tag','ess2fuel_ratio_num'),'String',num2str(vinf.cycle.ess2fuel_tol));
    
    %safety for those who saved simulation setup or results *.mat files in advisor 3.2 or before
    if ~isfield(vinf.cycle,'soc_tol_method')
        vinf.cycle.soc_tol_method='soctol';
    end
    if ~isfield(vinf.cycle,'ess2fuel_tol')
        vinf.cycle.ess2fuel_tol=1; %ratio of net ess stored energy to fuel energy used in percent
    end
    
    %set the radiobuttons for soc tolerance method
    if strcmp(vinf.cycle.soc_tol_method,'soctol')
        set(findobj('tag','SOCtol_radiobutton'),'value',1)
        set(findobj('tag','ess2fuel_ratio_radiobutton'),'value',0)
    elseif strcmp(vinf.cycle.soc_tol_method,'ess2fuel')
        set(findobj('tag','SOCtol_radiobutton'),'value',0)
        set(findobj('tag','ess2fuel_ratio_radiobutton'),'value',1)
    end
    
    %set 'visible' properties of cycle items
    set(findobj('tag','soc_popupmenu'),'Visible',vinf.cycle.soc);
    set(findobj('tag','#iters'),'Visible',vinf.cycle.soc);
    set(findobj('tag','SOC_iters_num'),'Visible',vinf.cycle.soc);
    set(findobj('tag','SOCtol_radiobutton'),'Visible',vinf.cycle.soc);
    set(findobj('tag','soc_tol_num'),'Visible',vinf.cycle.soc);
    set(findobj('tag','ess2fuel_ratio_radiobutton'),'Visible',vinf.cycle.soc);
    set(findobj('tag','ess2fuel_ratio_num'),'Visible',vinf.cycle.soc);
    
    %set visible properties for statistics and description items
    %statistics is the default for cycles  , description is the default for tests.
    if strcmp(vinf.cycle.run,'on')
        set(findobj('userdata','statistics'),'visible','on')
        set(findobj('tag','statistics_radiobutton'),'value',1)
        set(findobj('userdata','description'),'visible','off')
        set(findobj('tag','description_radiobutton'),'value',0)
    else
        set(findobj('userdata','statistics'),'visible','off')
        set(findobj('tag','statistics_radiobutton'),'value',0)
        set(findobj('userdata','description'),'visible','on')
        set(findobj('tag','description_radiobutton'),'value',1)
    end
    
    %set properties for cycle filter
    set(findobj('tag','cycle_filter_checkbox'),'value',strcmp('on',vinf.cycle.filter));
    set(findobj('tag','smooth_value'),'visible',vinf.cycle.filter,'String',num2str(vinf.cycle.filter_value));
    set(findobj('tag','smooth_text'),'visible',vinf.cycle.filter); %ss 1/25/01
    %make sure the base has the same information as the figure. ss 5/7/02
    assignin('base','cyc_filter_bool',vinf.cycle.filter)
    assignin('base','cyc_avg_time',vinf.cycle.filter_value)
    
    %multiple cycles setup
    % radiobutton on/off
    set(findobj('tag','multi_cycles_radiobutton'),'value',strcmp('on',vinf.multi_cycles.run))
    
    % enable/disable items
    %   button
    set(findobj('string','Multiple Cycles'),'enable',vinf.multi_cycles.run)
    %   popupmenu
    set(findobj('tag','multi_cycles_popupmenu'),'enable',vinf.multi_cycles.run)
    
    if isfield(vinf.multi_cycles, 'name')
        set(findobj('tag','multi_cycles_popupmenu'),'string',vinf.multi_cycles.name)
    end
    
    %Test items enable
    set(findobj('userdata','test'),'enable',vinf.test.run);
    
    %test radiobutton on/off
    set(findobj('tag','test_radiobutton'),'value',strcmp('on',vinf.test.run));
    
    %test popupmenu
    set(findobj('tag','test_procedures'),'string',optionlist('get','test_procedures'),'value',optionlist('value','test_procedures',vinf.test.name));
    
    %acceleration test
    set(findobj('tag','acceleration_checkbox'),'value',strcmp('on',vinf.acceleration.run));
    
    %gradeability test
    set(findobj('tag','gradeability_checkbox'),'value',strcmp('on',vinf.gradeability.run));
    set(findobj('tag','grade_speed'),'String',num2str(vinf.gradeability.speed*units('mph2kmph')));
    
    %gradeability test units
    if strcmp(vinf.units,'metric'); str='km/h' ;else; str='mph'; end
    set(findobj('tag','grade speed units'),'string',str);
    
    %road grade
    set(findobj('tag','road_grade_checkbox'),'value',strcmp('on',vinf.road_grade.run));
    set(findobj('tag','road_grade_edit'),'string',num2str(vinf.road_grade.value));
    set(findobj('userdata','road_grade'),'visible',vinf.road_grade.run);
    
    %interactive sim
    set(findobj('tag','interactive_sim_checkbox'),'value',vinf.interactive_sim);
    
    %Parametric Study
    %when loading a saved simulation setup file, there may be variables saved
    %in the parametric portion that don't exist for the current vehicle
    %the following sets the variable name to the first one in the list if this is the case
    vars=gui_get_vars;
    for i=1:3
        eval(['pop_value',num2str(i),'=strmatch(vinf.parametric.var{',num2str(i),'},vars,''exact'');'])
        if eval(['isempty(pop_value',num2str(i),')'])
            eval(['pop_value',num2str(i),'=1;'])
            vinf.parametric.low(i)=evalin('base',vars{i});
            vinf.parametric.high(i)=vinf.parametric.low(i)*1.1;
        end
    end
    
    %parametric save information
    set(findobj('tag','savePSRuns_checkbox'),'value',vinf.parametric.saveRuns);
    set(findobj('tag','savePSRunsPrefix_edit'),'string',vinf.parametric.savePrefix);
    set(findobj('tag','savePSRunsDir_edit'),'string',vinf.parametric.saveDir);
    
    %parametric checkbox
    set(findobj('tag','parametric_checkbox'),'value',strcmp('on',vinf.parametric.run));
    
    %parametric enable
    set(findobj('userdata','parametric'),'enable',vinf.parametric.run);
    
    %parametric number of variables
    set(findobj('tag','num_of_vars_popupmenu'),'value',vinf.parametric.number_variables);
    
    %variable list
    set(findobj('tag','var1_popupmenu'),'string',gui_get_vars);
    set(findobj('tag','var2_popupmenu'),'string',gui_get_vars);
    set(findobj('tag','var3_popupmenu'),'string',gui_get_vars);
    
    %variable 1
    set(findobj('tag','var1_popupmenu'),'value',pop_value1);
    set(findobj('tag','var1low_edit'),'string',num2str(vinf.parametric.low(1)));
    set(findobj('tag','var1hi_edit'),'string',num2str(vinf.parametric.high(1)));
    set(findobj('tag','var1pts_edit'),'string',num2str(vinf.parametric.number(1)));
    
    %the following if statement determines whether var2 items are enabled
    if strcmp('on',vinf.parametric.run)&vinf.parametric.number_variables>1
        enable='on';
    else
        enable='off';
    end
    
    %variable 2
    set(findobj('tag','var2_popupmenu'),'value',pop_value2,'enable',enable);
    set(findobj('tag','var2low_edit'),'string',num2str(vinf.parametric.low(2)),'enable',enable);
    set(findobj('tag','var2hi_edit'),'string',num2str(vinf.parametric.high(2)),'enable',enable);
    set(findobj('tag','var2pts_edit'),'string',num2str(vinf.parametric.number(2)),'enable',enable);
    set(findobj('tag','var2_text'),'enable',enable);
    
    %the following if statement determines whether var3 items are enabled
    if strcmp('on',vinf.parametric.run)&vinf.parametric.number_variables>2
        enable='on';
    else
        enable='off';
    end
    
    %variable 3
    set(findobj('tag','var3_popupmenu'),'value',pop_value3,'enable',enable);
    set(findobj('tag','var3low_edit'),'string',num2str(vinf.parametric.low(3)),'enable',enable);
    set(findobj('tag','var3hi_edit'),'string',num2str(vinf.parametric.high(3)),'enable',enable);
    set(findobj('tag','var3pts_edit'),'string',num2str(vinf.parametric.number(3)),'enable',enable);
    set(findobj('tag','var3_text'),'enable',enable);
    
    %set everything normalized and set the figure size and center it
    h=findobj('type','uicontrol');
    g=findobj('type','axes');
    
    set([h; g],'units','normalized')
    
    
    if isfield(vinf,'gui_size')
        set(fig,'units','pixels','position',vinf.gui_size);
    else
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            vinf.gui_size=[238 64 768 576];
            set(fig,'units','pixels','position',vinf.gui_size);
        else
            set(fig,'units','normalized')
            set(fig,'position',[.03 .05 .95 .85]);
            set(fig,'units','pixels');
        end
        
    end
    
    %set the figure back on after everything is drawn
    set(fig,'visible','on');
    
    waitbar(1)
    close(findobj('tag','TMWWaitbar')); 	%close the waitbar   
    
    %display the appropriate units
    SimSetupFig('units4SimSetupFig',0) % the 0 will avoid running gui_plot_execute
    
    %bring up appropriate plot
    %gui_plot_execute;  ss commented out on 8/11/00 not necessary because it will run with 'road grade' case called below
    
    %run appropriate files to load variables into vinf and workspace
    SimSetupFig('parametric_checkbox_Callback');
    %road grade will actually run gui_plot_execute also so no need to run it in previous lines.
    SimSetupFig('road_grade_checkbox_Callback');
    
    
    if strcmp(vinf.test.run,'on')
        SimSetupFig('test_radiobutton_Callback');
    end
    
    
    
    
    
    
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
function varargout = plot_menu_Callback(h, eventdata, handles, varargin)
try
    global vinf
    if strcmp(vinf.drivetrain.name,'prius_jpn')
        if strcmp(vinf.test.name,'TEST_J1711')
            h=warndlg('J1711 does not work with prius_jpn Drivetrain','Test Procedure Warning');
            uiwait(h);
            vinf.test.name=vinf.test.previous_name;
            value=optionlist('value','test_procedures',vinf.test.name);
            
            set(findobj('tag','test_procedures'),'value',value)
            
            return
        end
    end
    
    gui_plot_execute;
    vinf.cycle.name=gui_current_str('cycles');
    
    if strcmp(vinf.cycle.run,'on')
        filter_bool=evalin('base','cyc_filter_bool');
        if filter_bool==1
            vinf.cycle.filter='on';
        else
            vinf.cycle.filter='off';
        end
        set(findobj('tag','cycle_filter_checkbox'),'value',strcmp('on',vinf.cycle.filter))
        
        SimSetupFig('cycle_filter_checkbox_Callback')
    end
    
    if strcmp(vinf.test.run,'on')
        SimSetupFig('test_radiobutton_Callback')
    end
catch
    disp(['[',mfilename,':plot_menu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
%-------------------

% --------------------------------------------------------------------
function varargout = description_radiobutton_Callback(h, eventdata, handles, varargin)
try
    set(findobj('tag','description_radiobutton'),'value',1)
    set(findobj('tag','statistics_radiobutton'),'value',0)
    set(findobj('userdata','statistics'),'visible','off')
    set(findobj('userdata','description'),'visible','on')
catch
    disp(['[',mfilename,':description_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = statistics_radiobutton_Callback(h, eventdata, handles, varargin)
try
    set(findobj('tag','statistics_radiobutton'),'value',1)
    set(findobj('tag','description_radiobutton'),'value',0)
    set(findobj('userdata','description'),'visible','off')
    set(findobj('userdata','statistics'),'visible','on')
catch
    disp(['[',mfilename,':statistics_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = cycle_radiobutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    %set visible properties for statistics and description items
    %statistics is the default for cycles  , description is the default for tests.
    set(findobj('userdata','statistics'),'visible','on')
    set(findobj('tag','statistics_radiobutton'),'value',1)
    set(findobj('userdata','description'),'visible','off')
    set(findobj('tag','description_radiobutton'),'value',0)
    
    set(findobj('tag','cycle_radiobutton'),'value',1);
    set(findobj('tag','test_radiobutton'),'value',0);
    set(findobj('tag','multi_cycles_radiobutton'),'value',0) 
    evalin('base','clear test*');
    set(findobj('userdata','test'),'enable','off');
    set(findobj('userdata','cycle'),'enable','on');
    set(findobj('string','Multiple Cycles'),'enable','off')
    set(findobj('tag','multi_cycles_popupmenu'),'enable','off')
    
    vinf.cycle.run='on';
    vinf.multi_cycles.run='off';
    vinf.test.run='off';
    set(findobj('Tag','cycle_pushbutton'),'enable','on');
    if strcmp(vinf.drivetrain.name,'conventional')|strcmp(vinf.drivetrain.name,'ev')
        set(findobj('tag','soc_checkbox'),'enable','off')
        vinf.cycle.soc='off';
    end
    
    %enable all tests and parametric study that may have been disabled by SimSetupFig('test_radiobutton_Callback')
    %set all checkboxes to unchecked and then disable the checkboxes
    set(findobj('tag','acceleration_checkbox'),'enable','on')
    
    set(findobj('tag','gradeability_checkbox'),'enable','on')
    
    set(findobj('tag','road_grade_checkbox'),'enable','on')
    
    set(findobj('tag','parametric_checkbox'),'enable','on')
    
    SimSetupFig('interactive_sim_enable')
    
    SimSetupFig('cycles_Callback')
catch
    disp(['[',mfilename,':cycle_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = cycle_pushbutton_Callback(h, eventdata, handles, varargin)
try
    OptionListFigControl('open','cycles');
catch
    disp(['[',mfilename,':cycle_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = cycles_Callback(h, eventdata, handles, varargin)
try
    global vinf
    vinf.cycle.name=gui_current_str('cycles');
    
    evalin('base',['clear ',vinf.cycle.name]); % mpo:8/6/01 required statement to force Matlab to 
    % search for the newly modified file rather than 
    % reference functions in memory            
    
    evalin('base',vinf.cycle.name);
    
    if strcmp(vinf.road_grade.run,'on');
        gradestr=num2str(vinf.road_grade.value/100);
        evalin('base',['cyc_grade=[0 ',gradestr,'; 1 ',gradestr,'];'])
    end
    
    gui_plot_execute;
    
    %   Create auxiliary load on/off vector
    AuxLoads=GetLoadNames('UserDefined');
    for i=1:length(AuxLoads)
        if isempty(strmatch(AuxLoads(i),{'BrakeLights';'Misc';'Engine';'Starter'},'exact'))
            eval(['vinf.AuxLoads.',AuxLoads{i},'.OnOffData=CalcLoadOnOffData(vinf.AuxLoads.',AuxLoads{i},'.OnOffInfo);']);
        end
    end 
catch
    disp(['[',mfilename,':cycles_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = trip_builder_button_Callback(h, eventdata, handles, varargin)
try
    CycleFigControl
catch
    disp(['[',mfilename,':trip_builder_button_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = time_step_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h=findobj('tag','time_step');
    min_time_step=.01;
    max_time_step=1;
    time_step_warning=['Time Step must be between ' num2str(min_time_step) ' and ' num2str(max_time_step)];
    user_input_time_step=str2num(get(h,'string'));
    
    % put restrictions on time step
    if user_input_time_step < min_time_step
        vinf.time_step=min_time_step;
    elseif user_input_time_step > max_time_step
        vinf.time_step=max_time_step;
    else
        vinf.time_step=user_input_time_step;
    end
    set(h,'string',vinf.time_step)
    
    if vinf.time_step ~= user_input_time_step
        warndlg(time_step_warning);
    end
catch
    disp(['[',mfilename,':time_step_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = num_of_cycles_Callback(h, eventdata, handles, varargin)
try
    global vinf
    vinf.cycle.number=str2num(gui_current_str('num_of_cycles'));
catch
    disp(['[',mfilename,':num_of_cycles_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = soc_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h(1)=findobj('tag','soc_popupmenu');
    g(1)=findobj('tag','#iters');
    g(2)=findobj('tag','SOC_iters_num');
    g(3)=findobj('tag','SOCtol_radiobutton');
    g(4)=findobj('tag','soc_tol_num');
    g(5)=findobj('tag','ess2fuel_ratio_radiobutton');
    g(6)=findobj('tag','ess2fuel_ratio_num');
    if get(findobj('tag','soc_checkbox'),'value')==1
        set(h,'visible','on')
        set(g,'visible','on')
        vinf.cycle.soc='on';
        if strcmp(gui_current_str('soc_popupmenu'),'linear')
            set(g,'visible','off')
        end
    else
        set(h,'visible','off')
        set(g,'visible','off')
        vinf.cycle.soc='off';
    end
    vinf.cycle.socmenu=gui_current_str('soc_popupmenu');
catch
    disp(['[',mfilename,':soc_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = soc_popupmenu_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('soc_checkbox_Callback')
catch
    disp(['[',mfilename,':soc_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = SOCtol_radiobutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    set(findobj('tag','SOCtol_radiobutton'),'value',1);
    set(findobj('tag','ess2fuel_ratioradiobutton'),'value',0);
    vinf.cycle.soc_tol_method='soctol';
catch
    disp(['[',mfilename,':SOCtol_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = soc_tol_num_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h=findobj('tag','soc_tol_num');
    vinf.cycle.SOCtol=str2num(get(h,'string'));
catch
    disp(['[',mfilename,':soc_tol_num_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = ess2fuel_ratio_radiobutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    set(findobj('tag','SOCtol_radiobutton'),'value',0);
    set(findobj('tag','ess2fuel_ratio_radiobutton'),'value',1);
    vinf.cycle.soc_tol_method='ess2fuel';
catch
    disp(['[',mfilename,':ess2fuel_ratio_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = ess2fuel_ratio_num_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h=findobj('tag','ess2fuel_ratio_num');
    vinf.cycle.ess2fuel_tol=str2num(get(h,'string'));
catch
    disp(['[',mfilename,':ess2fuel_ratio_num_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = SOC_iters_num_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h=findobj('tag','SOC_iters_num');
    vinf.cycle.SOCiter=str2num(get(h,'string'));
catch
    disp(['[',mfilename,':SOC_iters_num_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = cycle_filter_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h(1)=findobj('tag','smooth_value');
    h(2)=findobj('tag','smooth_text');
    avg_time=get(h(1),'string');
    vinf.cycle.filter_value=str2num(avg_time);
    if get(findobj('tag','cycle_filter_checkbox'),'value')==1
        set(h,'visible','on')
        evalin('base','cyc_filter_bool=1;')
        vinf.cycle.filter='on';
        evalin('base',['cyc_avg_time=',avg_time,';'])
        
    else
        set(h,'visible','off')
        evalin('base','cyc_filter_bool=0;')
        vinf.cycle.filter='off';
    end
catch
    disp(['[',mfilename,':cycle_filter_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = smooth_value_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('cycle_filter_checkbox_Callback')
catch
    disp(['[',mfilename,':smooth_value_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = init_conds_pushbutton_Callback(h, eventdata, handles, varargin)
try
    gui_init_cond
catch
    disp(['[',mfilename,':init_conds_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = road_grade_checkbox_Callback(h, eventdata, handles, varargin)
global vinf
try   
    h=findobj('userdata','road_grade');
    if get(findobj('tag','road_grade_checkbox'),'value')==1
        set(h,'visible','on')
        vinf.road_grade.run='on';
        grade=get(findobj('tag','road_grade_edit'),'string');%this is a string!   
        vinf.road_grade.value=str2num(grade);%save this in percentage form
        %change grade into a decimal instead of percentage for use with block diagram
        grade=num2str(str2num(grade)/100);
        % build grade vector
        evalin('base',['cyc_grade=[0 ',grade,'; 1 ',grade,'];']) 
        gui_plot_execute;% replot with new grade. ss 7/18/00 added
        
    else
        set(h,'visible','off')
        %evalin('base','cyc_grade=0;')
        % build grade vector
        evalin('base',['cyc_grade=[0 0; 1 0];']) 
        vinf.road_grade.run='off';
        gui_plot_execute; % reload input file -- it may have grade info defined tm:8/23/99
        
    end
catch
    disp(['[',mfilename,':road_grade_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = road_grade_edit_Callback(h, eventdata, handles, varargin)
try 
    SimSetupFig('road_grade_checkbox_Callback')
catch
    disp(['[',mfilename,':road_grade_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = interactive_sim_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    if get(findobj('tag','interactive_sim_checkbox'),'value')==1
        if vinf.interactive_sim~=1
            InteractiveSimDlg;
        end
        vinf.interactive_sim=1;
    else
        vinf.interactive_sim=0;
    end
catch
    disp(['[',mfilename,':interactive_sim_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = multi_cycles_radiobutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    %set visible properties for statistics and description items
    %statistics is the default for cycles  , description is the default for tests and multi cycle.
    set(findobj('userdata','statistics'),'visible','off')
    set(findobj('tag','statistics_radiobutton'),'value',0)
    set(findobj('userdata','description'),'visible','on')
    set(findobj('tag','description_radiobutton'),'value',1)
    
    %set up the radiobuttons properly
    set(findobj('tag','cycle_radiobutton'),'value',0);
    set(findobj('tag','test_radiobutton'),'value',0);
    set(findobj('tag','multi_cycles_radiobutton'),'value',1) 
    
    evalin('base','clear test*');
    set(findobj('userdata','test'),'enable','off');
    set(findobj('userdata','cycle'),'enable','off');
    set(findobj('string','Multiple Cycles'),'enable','on')
    set(findobj('tag','multi_cycles_popupmenu'),'enable','on')
    
    vinf.cycle.run='off';
    vinf.multi_cycles.run='on';
    vinf.test.run='off';
    set(findobj('Tag','cycle_pushbutton'),'enable','off');
    
    %disable all tests and parametric studies 
    %set all checkboxes to unchecked and then disable the checkboxes
    set(findobj('tag','acceleration_checkbox'),'value',0,'enable','off')
    SimSetupFig('acceleration_checkbox_Callback')
    
    set(findobj('tag','gradeability_checkbox'),'value',0,'enable','off')
    SimSetupFig('gradeability_checkbox_Callback')
    
    set(findobj('tag','road_grade_checkbox'),'value',0,'enable','off')
    SimSetupFig('road_grade_checkbox_Callback')
    
    set(findobj('tag','parametric_checkbox'),'value',0,'enable','off')
    SimSetupFig('parametric_checkbox_Callback')
    
    SimSetupFig('interactive_sim_enable')
    
    gui_plot_execute;
catch
    disp(['[',mfilename,':multi_cycles_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end        


% --------------------------------------------------------------------
function varargout = multi_cycles_pushbutton_Callback(h, eventdata, handles, varargin)
try
    CycleFigControl
catch
    disp(['[',mfilename,':multi_cycles_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = multi_cycles_popupmenu_Callback(h, eventdata, handles, varargin)
try
    set(gcbo,'value',1)
catch
    disp(['[',mfilename,':multi_cycles_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = test_radiobutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    %set visible properties for statistics and description items
    %statistics is the default for cycles  , description is the default for tests.
    set(findobj('userdata','statistics'),'visible','off')
    set(findobj('tag','statistics_radiobutton'),'value',0)
    set(findobj('userdata','description'),'visible','on')
    set(findobj('tag','description_radiobutton'),'value',1)
    
    set(findobj('tag','cycle_radiobutton'),'value',0);
    set(findobj('tag','test_radiobutton'),'value',1);
    set(findobj('tag','multi_cycles_radiobutton'),'value',0)
    set(findobj('userdata','test'),'enable','on');
    set(findobj('userdata','cycle'),'enable','off');
    set(findobj('string','Multiple Cycles'),'enable','off')
    set(findobj('tag','multi_cycles_popupmenu'),'enable','off')
    
    vinf.cycle.run='off';
    vinf.multi_cycles.run='off';
    vinf.test.run='on';
    
    
    %test list for the following if statement.
    testlist={'TEST_J1711';'TEST_CITY_HWY';'TEST_REAL_WORLD';'TEST_ACCEL';'TEST_GRADE'};
    
    if ~isempty(strmatch(vinf.test.name,testlist,'exact'))
        %disable all other tests and parametric study
        %set all checkboxes to unchecked and then disable the checkboxes
        set(findobj('tag','acceleration_checkbox'),'value',0,'enable','off')
        SimSetupFig('acceleration_checkbox_Callback')
        
        set(findobj('tag','gradeability_checkbox'),'value',0,'enable','off')
        SimSetupFig('gradeability_checkbox_Callback')
        
        set(findobj('tag','road_grade_checkbox'),'value',0,'enable','off')
        SimSetupFig('road_grade_checkbox_Callback')
        
        set(findobj('tag','parametric_checkbox'),'value',0,'enable','off')
        SimSetupFig('parametric_checkbox_Callback')
    else
        %enable all tests and parametric study that may have been disabled by SimSetupFig('test_radiobutton_Callback')
        %set all checkboxes to unchecked and then disable the checkboxes
        set(findobj('tag','acceleration_checkbox'),'enable','on')
        
        set(findobj('tag','gradeability_checkbox'),'enable','on')
        
        set(findobj('tag','road_grade_checkbox'),'enable','on')
        
        set(findobj('tag','parametric_checkbox'),'enable','on')
        
    end
    
    %disable road grade for some tests.
    %test list for the following if statement.
    testlist={'TEST_FTP';'TEST_ACCEL';'TEST_GRADE'};
    
    if ~isempty(strmatch(vinf.test.name,testlist,'exact'))
        %disable road grade
        %set checkbox to unchecked and then disable the checkbox
        set(findobj('tag','road_grade_checkbox'),'value',0,'enable','off')
        SimSetupFig('road_grade_checkbox_Callback')
    end
    
    %-------------------
    
    %set number of cycles to one otherwise test does not operate correctly
    vinf.cycle.number=1;
    set(findobj('tag','num_of_cycles'),'string',num2str(vinf.cycle.number))
    
    SimSetupFig('interactive_sim_enable')
    
    
catch
    disp(['[',mfilename,':test_radiobutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = test_procedures_Callback(h, eventdata, handles, varargin)
try
    global vinf
    vinf.test.name=gui_current_str('test_procedures');
    
    if strcmp(vinf.drivetrain.name,'prius_jpn')
        if strcmp(vinf.test.name,'TEST_J1711')
            h=warndlg('J1711 does not work with prius_jpn Drivetrain.  Please select a different test.','Test Procedure Warning');
            uiwait(h);
        end
    end
    
    gui_plot_execute;
catch
    disp(['[',mfilename,':test_procedures_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = acceleration_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    val=get(findobj('tag','acceleration_checkbox'),'value');
    if val==1
        vinf.acceleration.run='on';
    else
        vinf.acceleration.run='off';
    end
    SimSetupFig('interactive_sim_enable')
catch
    disp(['[',mfilename,':acceleration_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = accel_pushbutton_Callback(h, eventdata, handles, varargin)
try
    AccelFigControl
catch
    disp(['[',mfilename,':accel_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = gradeability_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    val=get(findobj('tag','gradeability_checkbox'),'value');
    if val==1
        vinf.gradeability.run='on';
    else
        vinf.gradeability.run='off';
    end
    SimSetupFig('interactive_sim_enable')
catch
    disp(['[',mfilename,':gradeability_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = grade_pushbutton_Callback(h, eventdata, handles, varargin)
try
    GradeFigControl 
catch
    disp(['[',mfilename,':grade_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = parametric_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h=findobj('userdata','parametric');
    if get(findobj('tag','parametric_checkbox'),'value')==1
        vinf.parametric.run='on';
        set(h,'enable','on')
        num_vars=get(findobj('tag','num_of_vars_popupmenu'),'value');
        vinf.parametric.number_variables=num_vars;
        if num_vars==1
            g(1)=findobj(h,'tag','var2_text');
            g(2)=findobj(h,'tag','var2_popupmenu');
            g(3)=findobj(h,'tag','var2low_edit');
            g(4)=findobj(h,'tag','var2hi_edit');
            g(5)=findobj(h,'tag','var2pts_edit');
            g(6)=findobj(h,'tag','var3_text');
            g(7)=findobj(h,'tag','var3_popupmenu');
            g(8)=findobj(h,'tag','var3low_edit');
            g(9)=findobj(h,'tag','var3hi_edit');
            g(10)=findobj(h,'tag','var3pts_edit');
            set(g,'enable','off');
            
            vinf.parametric.var{1}=gui_current_str('var1_popupmenu');
            vinf.parametric.low(1)=str2num(gui_current_str('var1low_edit'));
            vinf.parametric.high(1)=str2num(gui_current_str('var1hi_edit'));
            vinf.parametric.number(1)=str2num(gui_current_str('var1pts_edit'));
        elseif num_vars==2
            g(1)=findobj(h,'tag','var3_text');
            g(2)=findobj(h,'tag','var3_popupmenu');
            g(3)=findobj(h,'tag','var3low_edit');
            g(4)=findobj(h,'tag','var3hi_edit');
            g(5)=findobj(h,'tag','var3pts_edit');
            set(g,'enable','off');
            
            vinf.parametric.var{1}=gui_current_str('var1_popupmenu');
            vinf.parametric.low(1)=str2num(gui_current_str('var1low_edit'));
            vinf.parametric.high(1)=str2num(gui_current_str('var1hi_edit'));
            vinf.parametric.number(1)=str2num(gui_current_str('var1pts_edit'));
            vinf.parametric.var{2}=gui_current_str('var2_popupmenu');
            vinf.parametric.low(2)=str2num(gui_current_str('var2low_edit'));
            vinf.parametric.high(2)=str2num(gui_current_str('var2hi_edit'));
            vinf.parametric.number(2)=str2num(gui_current_str('var2pts_edit'));
        else
            
            vinf.parametric.var{1}=gui_current_str('var1_popupmenu');
            vinf.parametric.low(1)=str2num(gui_current_str('var1low_edit'));
            vinf.parametric.high(1)=str2num(gui_current_str('var1hi_edit'));
            vinf.parametric.number(1)=str2num(gui_current_str('var1pts_edit'));
            vinf.parametric.var{2}=gui_current_str('var2_popupmenu');
            vinf.parametric.low(2)=str2num(gui_current_str('var2low_edit'));
            vinf.parametric.high(2)=str2num(gui_current_str('var2hi_edit'));
            vinf.parametric.number(2)=str2num(gui_current_str('var2pts_edit'));
            vinf.parametric.var{3}=gui_current_str('var3_popupmenu');
            vinf.parametric.low(3)=str2num(gui_current_str('var3low_edit'));
            vinf.parametric.high(3)=str2num(gui_current_str('var3hi_edit'));
            vinf.parametric.number(3)=str2num(gui_current_str('var3pts_edit'));
            
        end
    else
        vinf.parametric.run='off';
        
        if get(findobj('tag','acceleration_checkbox'),'value')==0 & get(findobj('tag','gradeability_checkbox'),'value')==0
            set(findobj('tag','interactive_sim_checkbox'),'enable','on')
        end
        
        set(h,'enable','off')
    end
    SimSetupFig('savePSRuns_checkbox_Callback',findobj('tag','savePSRuns_checkbox'),[],guidata(findobj('tag','savePSRuns_checkbox')));
    SimSetupFig('interactive_sim_enable')
catch
    disp(['[',mfilename,':parametric_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = num_of_vars_popupmenu_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':num_of_vars_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var1_popupmenu_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h(1)=findobj('tag','var1low_edit');
    h(2)=findobj('tag','var1hi_edit');
    value=evalin('base',gui_current_str('var1_popupmenu'));
    set(h,'string',value);
    vinf.parametric.var{1}=gui_current_str('var1_popupmenu');
    vinf.parametric.low(1)=value;
    vinf.parametric.high(1)=value;
catch
    disp(['[',mfilename,':var1_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var1low_edit_Callback(h, eventdata, handles, varargin)
try 
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var1low_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var1hi_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var1hi_editkl_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var1pts_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var1pts_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var2_popupmenu_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h(1)=findobj('tag','var2low_edit');
    h(2)=findobj('tag','var2hi_edit');
    value=evalin('base',gui_current_str('var2_popupmenu'));
    set(h,'string',value);
    vinf.parametric.var{2}=gui_current_str('var2_popupmenu');
    vinf.parametric.low(2)=value;
    vinf.parametric.high(2)=value;
catch
    disp(['[',mfilename,':var2_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var2low_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var2low_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var2hi_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var2hi_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var2pts_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var2pts_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var3_popupmenu_Callback(h, eventdata, handles, varargin)
try
    global vinf
    h(1)=findobj('tag','var3low_edit');
    h(2)=findobj('tag','var3hi_edit');
    value=evalin('base',gui_current_str('var3_popupmenu'));
    set(h,'string',value);
    vinf.parametric.var{3}=gui_current_str('var3_popupmenu');
    vinf.parametric.low(3)=value;
    vinf.parametric.high(3)=value;
catch
    disp(['[',mfilename,':var3_popupmenu_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var3low_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var3low_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var3hi_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var3hi_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = var3pts_edit_Callback(h, eventdata, handles, varargin)
try
    SimSetupFig('parametric_checkbox_Callback')
catch
    disp(['[',mfilename,':var3pts_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = AuxLoads_checkbox_Callback(h, eventdata, handles, varargin)
try
    global vinf
    On=get(findobj('tag','AuxLoads_checkbox'),'value');
    vinf.AuxLoadsOn=On;
    RunFilesMods('modify','vinf.AuxLoadsOn',num2str(On),'acc');
catch
    disp(['[',mfilename,':AuxLoads_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = AuxLoads_pushbutton_Callback(h, eventdata, handles, varargin)
try
    AuxLoadsFigControl;
catch
    disp(['[',mfilename,':AuxLoads_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = load_exec_pushbutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    [f,p]=uigetfile('*_sim.mat','Load Simulation Setup File');
    if f==0;%exit load if user pushes cancel button
        return
    end
    str=[p,f];
    load(str);
    close(findobj('tag','execute_figure'))
    vinf.gradeability=simulation.gradeability;
    vinf.acceleration=simulation.acceleration;
    vinf.test=simulation.test;
    vinf.cycle=simulation.cycle;
    vinf.road_grade=simulation.road_grade;
    vinf.parametric=simulation.parametric;
    vinf.init_conds=simulation.init_conds;
    vinf.multi_cycles=simulation.multi_cycles;
    vinf.AuxLoadsOn=simulation.AuxLoadsOn;
    vinf.AuxLoads=simulation.AuxLoads;
    
    %reload figure
    SimSetupFig;
catch
    disp(['[',mfilename,':load_exec_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = opt_cs_var_pushbutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
    if ~(strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'parallel'))
        h=warndlg('The control strategy optimization routine is only available for series, fuel cell, and parallel vehicle configurations.','Control Strategy Optimization Warning');
        uiwait(h);
    elseif strcmp(vinf.drivetrain.name,'fuel_cell')&(strcmp(vinf.fuel_converter.type,'KTH')|strcmp(vinf.fuel_converter.type,'VT')|strcmp(vinf.fuel_converter.type,'gctool'))
        h=warndlg('The autosize function is not available for type of fuel cell selected','Autosize Warning');
        uiwait(h);
    else
        cs_setup;
    end
catch
    disp(['[',mfilename,':opt_cs_var_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = save_pushbutton_Callback(h, eventdata, handles, varargin)
try
    gui_save_execute
catch
    disp(['[',mfilename,':save_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = help_pushbutton_Callback(h, eventdata, handles, varargin)
try
    load_in_browser('advisor_ch2.html', '#2.1.2');
catch
    disp(['[',mfilename,':help_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = back_pushbutton_Callback(h, eventdata, handles, varargin)
try
    close(gcbf);
    InputFig;
catch
    disp(['[',mfilename,':back_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function varargout = run_pushbutton_Callback(h, eventdata, handles, varargin)
try
    global vinf
        
    if strcmp(vinf.condor.run,'on')
    
        run_condor
    
    else
        if isempty(varargin) | ~strcmp(varargin{1},'dontClose')
            close(gcbf);
        end
        
        SimSetupFig('init_cond_eval');      
        
        if strcmp('on',vinf.multi_cycles.run);
            Multi_Cycles; 
        elseif strcmp(vinf.parametric.run,'on') & ~isfield(vinf.parametric,'running')
            designOfExperiments;
        else
            evalin('base','gui_run');
        end                                                                
    end

    
catch
    disp(['[',mfilename,':run_pushbutton_Callback] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function init_cond_eval()
try
    global vinf
    drive=vinf.drivetrain.name;
    
    %evaluate all the initial conditions in the base workspace
    tempnames=fieldnames(vinf.init_conds);%get all the names of the variables pertaining to initial conditions
    for tempindex=1:max(size(tempnames))
        assignin('base',tempnames{tempindex},eval(['vinf.init_conds.',tempnames{tempindex}]));
    end
catch
    disp(['[',mfilename,':init_cond_eval] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function interactive_sim_enable()
try
    global vinf
    if get(findobj('tag','gradeability_checkbox'),'value')==0 & get(findobj('tag','acceleration_checkbox'),'value')==0 & get(findobj('tag','parametric_checkbox'),'value')==0 & get(findobj('tag','cycle_radiobutton'),'value')==1
        set(findobj('tag','interactive_sim_checkbox'),'enable','on')
    else
        set(findobj('tag','interactive_sim_checkbox'),'enable','off','value',0)
    end
    SimSetupFig('interactive_sim_checkbox_Callback')
    
catch
    disp(['[',mfilename,':interactive_sim_enable] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function units4SimSetupFig(option)
try
    global vinf
    %replot so units display accurately if option~=0
    if exist('option')
        if option~=0
            gui_plot_execute
        end
    else
        gui_plot_execute
    end
    
    %cycle statistics
    unit_tags={'time units','distance units','max speed units','avg speed units','max accel units',...
            'max decel units','avg accel units','avg decel units','idle time units'};
    if strcmp(vinf.units,'us')
        unit_strings={'s','miles','mph','mph','ft/s^2','ft/s^2','ft/s^2','ft/s^2','s'};
    end
    if strcmp(vinf.units,'metric')
        unit_strings={'s','km','km/h','km/h','m/s^2','m/s^2','m/s^2','m/s^2','s'};
    end
    for i=1:length(unit_tags)
        eval(['set(findobj(''tag'',''' ,unit_tags{i},'''),''string'',''' , unit_strings{i}, ''')'])
    end
catch
    disp(['[',mfilename,':units4SimSetupFig] Error! '])
    disp(lasterr)
    dbstack
end
% --------------------------------------------------------------------
function savePSRuns_checkbox_Callback(saveRunsHandle, eventdata, handles, varargin)
try
    global vinf
    vinf.parametric.saveRuns=get(saveRunsHandle,'value');
    if (vinf.parametric.saveRuns == 0) | (strcmp(vinf.parametric.run,'off'))
        savePSRunsObjOnOff='off';
    elseif (vinf.parametric.saveRuns == 1) | (strcmp(vinf.parametric.run,'on'))
        savePSRunsObjOnOff='on';
    end
    set(findobj('userdata','savePSRunsInfo'),'enable',savePSRunsObjOnOff);
catch
    disp(['[',mfilename,':savePSRuns_checkbox_Callback] Error! '])
    disp(lasterr)
    dbstack
end

% --------------------------------------------------------------------
function savePSRunsPrefix_edit_Callback(PrefixHandle, eventdata, handles, varargin)
try
    global vinf
    vinf.parametric.savePrefix=get(PrefixHandle,'string');
catch
    disp(['[',mfilename,':savePSRunsPrefix_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end


% --------------------------------------------------------------------
function varargout = savePSRunsDir_edit_Callback(DirHandle, eventdata, handles, varargin)
try
    global vinf
    vinf.parametric.saveDir=get(DirHandle,'string');
catch
    disp(['[',mfilename,':savePSRunsPrefix_edit_Callback] Error! '])
    disp(lasterr)
    dbstack
end
