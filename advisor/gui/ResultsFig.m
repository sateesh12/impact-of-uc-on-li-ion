function varargout = ResultsFig(varargin)
% ResultsFig Application M-file for ResultsFig.fig
%    FIG = ResultsFig launch junk GUI.
%    ResultsFig('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 15-Feb-2002 08:27:45

if nargin == 0  % LAUNCH GUI

    fig = openfig(mfilename,'new'); %had to change because mfilename was causing problems (all lower case letters)
                                    %then changed back to mfilename and changed from reuse to new.
    %fig = openfig(mfilename,'reuse');

    % Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
    %-----------------------------------------------------------------------
    %additional code added by ss 2/14/02 (from old ResultsFigControl.m file)
    
    global vinf   
    
    %set the name for the figure
    set(fig,'Name',['Results--',advisor_ver('info')])
    
    %set up the menubar
    adv_menu('results');
    
    %set up the variable plotting section
    results_var_select;
    
    %Multi_Cycles section
    if strcmp('on',vinf.multi_cycles.run)
        set(findobj('tag','Select_Results'),'string',vinf.multi_cycles.result_name,...
            'value',length(vinf.multi_cycles.result_name))
    else
        set(findobj('userdata','select results'),'visible','off')
    end
    
    %Disable Replay button for everything except drive cycle runs
    if strcmp('off',vinf.cycle.run) | strcmp('on',vinf.test.run) | strcmp('on',vinf.multi_cycles.run)
        set(findobj('tag','replay button'),'enable','off') %set altia replay button only for reg. drive cycle runs (doesn't work properly otherwise)
    end
    
    
    %Prius Speeds Plotting
    if ~strcmp(vinf.drivetrain.name,'prius_jpn')
        set(findobj('tag','Prius_Speeds'),'visible','off');
    end
    
    %warnings
    warnings=evalin('base','warnings');
    set(findobj('tag','warnings_listbox'),'string',warnings);
    
    %set the warnings title to have the same color background of the frame if there are none
    %othewise it will remain red.
    if strcmp(warnings{1},'none')
        frame_color=[ 0.4 0.701960784313725 1 ];
        set(findobj('string','Warnings/Messages'),'backgroundcolor',frame_color)
    end
    
    %plotting
    %default plots
    
    %first axes
    axes(findobj('tag','results_axes1'));
    if strcmp(vinf.units,'metric')
        evalin('base','plot(t,cyc_kph_r,''b'',t,kpha,''r'')');
        set(gca,'userdata',strvcat(get(gca,'userdata'),'cyc\_kph\_r','kpha'));
        ylabel('km/h');
    else
        evalin('base','plot(t,cyc_mph_r,''b'',t,mpha,''r'')');
        set(gca,'userdata',strvcat(get(gca,'userdata'),'cyc\_mph\_r','mpha'));
        ylabel('mph');
    end
    
    set(gca,'tag','results_axes1')
    legend off;
    legend(get(gca,'userdata'));
    
    %second axes
    axes(findobj('tag','results_axes2'));
    if ~strcmp(vinf.drivetrain.name,'conventional')&isfield(vinf,'energy_storage')
        value1=evalin('base','ess_soc_hist');
        t=evalin('base','t');
        plot(t,value1,'b');
        ylabel('ess\_soc\_hist');
        set(gca,'tag','results_axes2')   
        
        set(gca,'userdata',strvcat(get(gca,'userdata'),'ess\_soc\_hist'));
        legend off;
        legend(get(gca,'userdata'));
    end
    
    
    %third axes
    axes(findobj('tag','results_axes3'));
    value1=evalin('base','emis');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2)/10,'g',t,value1(:,3),'b',t,value1(:,4),'m');
    ylabel('emissions');
    set(gca,'tag','results_axes3')
    set(gca,'userdata',strvcat(get(gca,'userdata'),'hc','co/10','nox','pm'));
    legend off;
    legend(get(gca,'userdata'));
    
    
    %fourth axes
    axes(findobj('tag','results_axes4'));
    value1=evalin('base','gear_ratio*fd_ratio');
    t=evalin('base','t');
    plot(t,value1);
    ylabel('overall ratio');
    set(gca,'tag','results_axes4')
    set(gca,'userdata',strvcat(get(gca,'userdata'),'overall ratio'));
    
    legend off;
    legend(get(gca,'userdata'));
    
    %run the units call to fill in missing numbers with proper units
    ResultsFig('units4ResultsFig')
    
    %set everything normalized and set the figure size and center it
    
    h=findobj('type','uicontrol');
    g=findobj('type','axes');
    
    set([h; g],'units','normalized')
    
    if isfield(vinf,'gui_size')
        set(gcf,'units','pixels','position',vinf.gui_size);
    else
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            vinf.gui_size=[238 64 768 576];
            set(gcf,'units','pixels','position',vinf.gui_size);
        else
            set(gcf,'units','normalized')
            set(gcf,'position',[.03 .05 .95 .85]);
            set(gcf,'units','pixels');
        end
        
    end
    
    %set the figure back on after everything is drawn
    set(gcf,'visible','on');
    
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
function varargout = Exit_Callback(h, eventdata, handles, varargin)
close(gcbf)

% --------------------------------------------------------------------
function varargout = Back_Callback(h, eventdata, handles, varargin)
close(gcbf);
going_back; %subfunction
SimSetupFig;

% --------------------------------------------------------------------
function varargout = Help_Callback(h, eventdata, handles, varargin)
load_in_browser('advisor_ch2.html', '#2.1.3');

% --------------------------------------------------------------------
function varargout = Replay_Callback(h, eventdata, handles, varargin)
%evalin('base','replay_button=1;AltiaSetup;replay;')
DynamicReplay(2);

% --------------------------------------------------------------------
function varargout = Prius_Speeds_Callback(h, eventdata, handles, varargin)
plot_prius_spds

% --------------------------------------------------------------------
function varargout = Test_Data_Callback(h, eventdata, handles, varargin)
DataCompareFigControl('openfig')

% --------------------------------------------------------------------
function varargout = Sim_Data_Callback(h, eventdata, handles, varargin)
close(gcf);compare_sims_setup

% --------------------------------------------------------------------
function varargout = Output_Check_Plots_Callback(h, eventdata, handles, varargin)
try
    evalin('base','chkoutputs'); % 10-April-2002[mpo]added the evalin so that chkoutputs will 
    % ...run on the workspace and not func-space
catch % ibid. :putting a catch block here so that the source of an error with this can be checked
    error('[ResultsFig.m: error in function Output_Check_Callback()');
end
return

% --------------------------------------------------------------------
function varargout = Energy_Use_Figure_Callback(h, eventdata, handles, varargin)
energy_figure

% --------------------------------------------------------------------
function varargout = result_variable_components_Callback(h, eventdata, handles, varargin)
results_var_select(gui_current_str('result_variable_components'))

% --------------------------------------------------------------------
function varargout = Standards_Callback(h, eventdata, handles, varargin)
load_in_browser('emission_standards.html');

% --------------------------------------------------------------------
function varargout = variables_html_Callback(h, eventdata, handles, varargin)
load_in_browser('advisor_appendices.html');

% --------------------------------------------------------------------
function varargout = Select_Results_Callback(h, eventdata, handles, varargin)

global vinf
%get the value of the select results list to know which results to pull up
select_results_num=get(findobj('tag','Select_Results'),'value');                                     
results_name=vinf.multi_cycles.result_name{select_results_num};

%close the results figure
close(gcf)

%clear all the variables in the base workspace
evalin('base','clear all');                                                                

%declare the vinf to be global again to be available in the base
evalin('base','global vinf');

%find path for loading results from
p=strrep(which('Multi_Cycles.m'),'Multi_Cycles.m','');

%load the results
evalin( 'base', ['load(''' p results_name '.mat'')'] )

ResultsFig                                                     
set(findobj('tag','Select_Results'),'value', select_results_num)

% --------------------------------------------------------------------
function varargout = units4ResultsFig()
global vinf      
% fuel economy
if strcmp(vinf.units,'metric')
    str='Fuel Consumption (L/100 km)';
else
    str='Fuel Economy (mpg)';
end
set(findobj('tag','fuel title'),'string',str)

if evalin('base','exist(''mpg'')')
    if strcmp(vinf.units,'metric')&evalin('base','mpg~=0')
        set(findobj('tag','fuel_value'),'string',evalin('base','round((1/mpg)*units(''gpm2lp100km'')*10)/10'));
    else
        set(findobj('tag','fuel_value'),'string',evalin('base','round(mpg*10)/10'));
    end
end
if evalin('base','exist(''mpgge'')')
    if strcmp(vinf.units,'metric')&evalin('base','mpgge~=0')
        set(findobj('tag','mpgge'),'string',evalin('base','round((1/mpgge)*units(''gpm2lp100km'')*10)/10'));
    else
        set(findobj('tag','mpgge'),'string',evalin('base','round(mpgge*10)/10'));
    end
end
%Distance Travelled
if strcmp(vinf.units,'metric')
    str='Distance (km)';
else
    str='Distance (miles)';
end
set(findobj('tag','distance title'),'string',str)
if evalin('base','exist(''dist'')')
    if strcmp(vinf.units,'metric')
        set(findobj('tag','distance'),'string',evalin('base','round(dist*units(''miles2km'')*10)/10'));
    else
        set(findobj('tag','distance'),'string',evalin('base','round(dist*10)/10'));
    end
end

%emissions
if strcmp(vinf.units,'metric')
    str='Emissions (grams/km)';
else
    str='Emissions (grams/mile)';
end
set(findobj('tag','emissions title'),'string',str)
set(findobj('tag','hc_value'),'String',evalin('base','round(hc_gpm*units(''gpm2gpkm'')*1000)/1000'));
set(findobj('tag','co_value'),'String',evalin('base','round(co_gpm*units(''gpm2gpkm'')*1000)/1000'));
set(findobj('tag','nox_value'),'String',evalin('base','round(nox_gpm*units(''gpm2gpkm'')*1000)/1000'));
set(findobj('tag','pm_value'),'String',evalin('base','round(pm_gpm*units(''gpm2gpkm'')*1000)/1000'));

%acceleration test
if isfield(vinf,'accel_test')&isfield(vinf.accel_test,'param')
    if strcmp(vinf.units,'metric')
        str1=[num2str(round(10*vinf.accel_test.param.spds1(1)*units('mph2kmph'))/10),'-',num2str(round(10*vinf.accel_test.param.spds1(2)*units('mph2kmph'))/10),' km/h (s):'];
        str2=[num2str(round(10*vinf.accel_test.param.spds2(1)*units('mph2kmph'))/10),'-',num2str(round(10*vinf.accel_test.param.spds2(2)*units('mph2kmph'))/10),' km/h (s):'];
        str3=[num2str(round(10*vinf.accel_test.param.spds3(1)*units('mph2kmph'))/10),'-',num2str(round(10*vinf.accel_test.param.spds3(2)*units('mph2kmph'))/10),' km/h (s):'];
        str4='Max. Accel. (m/s^2):';
        str5=['Distance in ',num2str(vinf.accel_test.param.dist_in_time),'s (m):'];
        str6=['Time in ',num2str(round(100*vinf.accel_test.param.time_in_dist*units('miles2km'))/100),'km (s):'];
        str7='Max. Speed (kmph):';
    else
        str1=[num2str(vinf.accel_test.param.spds1(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds1(2)*units('mph2kmph')),' mph (s):'];
        str2=[num2str(vinf.accel_test.param.spds2(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds2(2)*units('mph2kmph')),' mph (s):'];
        str3=[num2str(vinf.accel_test.param.spds3(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds3(2)*units('mph2kmph')),' mph (s):'];
        str4='Max. Accel. (ft/s^2):';
        str5=['Distance in ',num2str(vinf.accel_test.param.dist_in_time),'s (ft):'];
        str6=['Time in ',num2str(vinf.accel_test.param.time_in_dist*units('miles2km')),'mi (s):'];
        str7='Max. Speed (mph):';
    end
else
    if strcmp(vinf.units,'metric')
        str1=[num2str(round(10*0*units('mph2kmph'))/10),'-',num2str(round(10*60*units('mph2kmph'))/10),' km/h (s):'];
        str2=[num2str(round(10*40*units('mph2kmph'))/10),'-',num2str(round(10*60*units('mph2kmph'))/10),' km/h (s):'];
        str3=[num2str(round(10*0*units('mph2kmph'))/10),'-',num2str(round(10*85*units('mph2kmph'))/10),' km/h (s):'];
        str4='Max. Accel. (m/s^2):';
        str5=['Distance in ',num2str(5),'s (m):'];
        str6=['Time in ',num2str(round(100*0.25*units('miles2km'))/100),'km (s):'];
        str7='Max. Speed (kmph):';
    else
        str1=[num2str(0*units('mph2kmph')),'-',num2str(60*units('mph2kmph')),' mph (s):'];
        str2=[num2str(40*units('mph2kmph')),'-',num2str(60*units('mph2kmph')),' mph (s):'];
        str3=[num2str(0*units('mph2kmph')),'-',num2str(85*units('mph2kmph')),' mph (s):'];
        str4='Max. Accel. (ft/s^2):';
        str5=['Distance in ',num2str(5),'s (ft):'];
        str6=['Time in ',num2str(0.25*units('miles2km')),'mi (s):'];
        str7='Max. Speed (mph):';
    end
end 

set(findobj('tag','acc0-60 title'),'string',str1);
set(findobj('tag','acc40-60 title'),'string',str2);
set(findobj('tag','acc0-85 title'),'string',str3);
set(findobj('tag','acc max title'),'string',str4);
set(findobj('tag','acc 5s dist title'),'string',str5);
set(findobj('tag','acc quart mi title'),'string',str6);
set(findobj('tag','acc max spd title'),'string',str7);

labels={'acc_value_0_60','acc_value_40_60','acc_value_0_85'};
if strcmp(vinf.acceleration.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_ACCEL')) 
    count=0;
    if isfield(vinf.accel_test,'param')
        active=vinf.accel_test.param.active(3:5);
    else
        active=[1 1 1];
    end
    for i=1:length(active)
        if active(i)
            count=count+1;
            if vinf.accel_test.results.times(count)==-1
                str='??';
            else
                str=num2str(round(10*vinf.accel_test.results.times(count))/10);
            end
        else
            str='n/a';
        end
        set(findobj('tag',labels{i}),'string',str);
    end
else
    for i=1:length(labels)
        str='n/a';
        set(findobj('tag',labels{i}),'string',str);
    end
end

if strcmp(vinf.acceleration.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_ACCEL')) %maximum acceleration
    if isfield(vinf.accel_test.results,'max_rate')
        str_max_accel=num2str(round(vinf.accel_test.results.max_rate*units('ft2m')*10)/10); 
    else
        str_max_accel='n/a';
    end
else
    str_max_accel='n/a';
end
set(findobj('tag','max_accel'),'string',str_max_accel);

if strcmp(vinf.acceleration.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_ACCEL')) %maximum acceleration
    if isfield(vinf.accel_test.results,'max_speed')
        str_max_speed=num2str(round(vinf.accel_test.results.max_speed*units('mph2kmph')*10)/10); 
    else
        str_max_speed='n/a';
    end
else
    str_max_speed='n/a';
end
set(findobj('tag','max_speed'),'string',str_max_speed);

if strcmp(vinf.acceleration.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_ACCEL')) %feet traveled in 5 seconds (max)
    if isfield(vinf.accel_test.results,'dist')
        str_feet_5sec=num2str(round(vinf.accel_test.results.dist*units('ft2m')*10)/10);
    else
        str_feet_5sec='n/a';
    end
else
    str_feet_5sec='n/a';
end
set(findobj('tag','5sec_distance'),'string',str_feet_5sec);

if strcmp(vinf.acceleration.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_ACCEL')) %quarter mile time
    if isfield(vinf.accel_test.results,'time')
        str_time_quart_mi=num2str(round(vinf.accel_test.results.time*10)/10); 
    else
        str_time_quart_mi='n/a';
    end
else
    str_time_quart_mi='n/a';
end
set(findobj('tag','time_quart_mi'),'string',str_time_quart_mi);

%end of acceleration section

%gradeability
if strcmp(vinf.gradeability.run,'on')|(strcmp(vinf.test.run,'on')&strcmp(vinf.test.name,'TEST_GRADE')) %grade able to maintain at prescribed mph
    if isfield(vinf.grade_test,'param')
        if strcmp(vinf.units,'metric')
            str=['Gradeability at ',num2str(round(10*vinf.grade_test.param.speed*units('mph2kmph'))/10),' km/h:'];
        else
            str=['Gradeability at ',num2str(round(10*vinf.grade_test.param.speed*units('mph2kmph'))/10),' mph:'];
        end
    else
        if strcmp(vinf.units,'metric')
            str=['Gradeability at ',num2str(round(10*55*units('mph2kmph'))/10),' km/h:'];
        else
            str=['Gradeability at ',num2str(round(10*55*units('mph2kmph'))/10),' mph:'];
        end
    end
    str_grade=num2str(round(vinf.grade_test.results.grade*10)/10);
else
    str=['Gradeability: '];
    str_grade='n/a';
end
set(findobj('tag','grade title'),'string',str);
set(findobj('tag','grade value'),'string',str_grade);

% --------------------------------------------------------------------
function varargout = num_plots_popupmenu_Callback(h, eventdata, handles, varargin)

num=get(findobj('tag','num_plots_popupmenu'),'value');
h1=findobj('tag','results_axes1');axes(h1);legend off;
h2=findobj('tag','results_axes2');axes(h2);legend off;
h3=findobj('tag','results_axes3');axes(h3);legend off;
h4=findobj('tag','results_axes4');axes(h4);legend off;
if num==4
    set(h1,'position',[ 0.09 0.77 0.57 0.2 ]);
    set(h2,'position',[ 0.09 0.53 0.57 0.2 ]);
    set(h3,'position',[ 0.09 0.29 0.57 0.2 ]);
    set(h4,'position',[ 0.09 0.055 0.57 0.2 ]);
    set([h1 h2 h3 h4],'visible','on');
end
if num==3
    set(h1,'position',[ 0.09 0.7 0.57 0.27 ]);
    set(h2,'position',[ 0.09 0.38 0.57 0.27 ]);
    set(h3,'position',[ 0.09 0.055 0.57 0.27 ]);
    set([h4],'visible','off');axes(h4);cla;axes(h3);axes(h2);axes(h1);
    set([h1 h2 h3],'visible','on');
end
if num==2
    set(h1,'position',[ 0.09 0.55 0.57 0.4 ]);
    set(h2,'position',[ 0.09 0.055 0.57 0.4 ]);
    set([h1 h2],'visible','on');
    set([h3 h4],'visible','off');axes(h3);cla;axes(h4);cla;
end
if num==1
    set(h1,'position',[0.09 0.055 0.57 .8],'visible','on');
    set([h2 h3 h4],'visible','off');axes(h2);cla;axes(h3);cla;axes(h4);cla;   
end
axes(h1);%make the first axes the current axes       

% --------------------------------------------------------------------
function varargout = time_plots_popupmenu_Callback(h, eventdata, handles, varargin)

var_to_plot=gui_current_str('time_plots_popupmenu');

%the following added because the legend was registering as gca instead of the plot ss 8/5/99
global last_axes_handle
if strcmp(get(gca,'tag'),'legend')
    axes(last_axes_handle)
end

tag=get(gca,'tag');
colornum=0;
if strcmp(var_to_plot,'emis')
    hold off
    value1=evalin('base','emis');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2)/10,'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('hc','co/10','nox','pm'))
elseif strcmp(var_to_plot,'emis_old')
    hold off
    value1=evalin('base','emis_old');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2)/10,'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('hc','co/10','nox','pm'))
elseif strcmp(var_to_plot,'ex_tmp')
    hold off
    value1=evalin('base','ex_tmp');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2),'g',t,value1(:,3),'b',t,value1(:,4),'m',t,value1(:,5),'k');
    set(gca,'userdata',strvcat('monolith','cat internal','cat inlet','cat sheild','manifold'))
elseif strcmp(var_to_plot,'ex_gas_tmp')
    hold off
    value1=evalin('base','ex_gas_tmp');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2),'g',t,value1(:,3),'b');
    set(gca,'userdata',strvcat('cat out','cat in','manifold out'))
elseif strcmp(var_to_plot,'fc_emis_eo')
    hold off
    value1=evalin('base','fc_emis_eo');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2)/10,'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('HC','CO/10','NOX','PM'))
elseif strcmp(var_to_plot,'ex_cat_eff')
    hold off
    value1=evalin('base','ex_cat_eff');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2),'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('HC','CO','NOX','PM'))  
elseif strcmp(var_to_plot,'emis_ppm')
    hold off
    value1=evalin('base','emis_ppm');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2)/10,'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('HC','CO/10','NOX','PM'))  
elseif strcmp(var_to_plot,'fc_tmp')
    hold off
    value1=evalin('base','fc_tmp');
    t=evalin('base','t');
    h=plot(t,value1(:,1),'r',t,value1(:,2),'g',t,value1(:,3),'b',t,value1(:,4),'m');
    set(gca,'userdata',strvcat('cylinder','block','eng. acc.','hood'))  
elseif length(var_to_plot)>9 & strcmp(var_to_plot(1:9),'saber_ess')
    hold off
    value1=evalin('base',var_to_plot);
    t=evalin('base','t');
    h=plot(t,value1);
    varstr=strrep(var_to_plot(11:end),'_','\_');
    set(gca,'userdata',strvcat([varstr '1'],[varstr '2'],[varstr '3'],[varstr '4'],...
        [varstr '5'],[varstr '6'],[varstr '7'],[varstr '8'],[varstr '9'],[varstr '10']))  
else
    if ishold
        h=get(gca,'children');
        %figure out number of lines already plotted
        for i=1:length(h)
            if strcmp(get(h(i),'type'),'line')
                colornum=colornum+1;
                
            end
        end
    end
    
    colorselection=['b','r','g','m','y','k','c'];
    colornum=colornum+1;
    color=colorselection(colornum);
    evalin('base',['plot(t,',var_to_plot,',''',color,''')']);
    
    %var_to_plot has to be at least two characters for legend to work.
    if length(var_to_plot)==1
        var_to_plot=[var_to_plot,' '];
    end
    
    set(gca,'userdata',strvcat(get(gca,'userdata'),strrep(var_to_plot,'_','\_')));
end
ylabel(strrep(var_to_plot,'_','\_'));
set(gca,'tag',tag);

last_axes_handle=gca;
legend off;
legend(get(gca,'userdata'));

% --------------------------------------------------------------------
function varargout = set_axes_limits(h, eventdata, handles, varargin)

if ~strcmp(get(gcbf,'SelectionType'),'normal')
    axlimdlg
end

% --------------------------------------------------------------------
function varargout = Back_Two_Callback(h, eventdata, handles, varargin)
close(gcbf); 
going_back; %subfunction
InputFig;


% --------------------------------------------------------------------
function varargout = going_back(h, eventdata, handles, varargin)

global vinf      
%remove grade achieved information
eval('h=vinf.max_grade; test4exist=1;', 'test4exist=0;')
if test4exist
    vinf=rmfield(vinf,'max_grade');
end

if isfield(vinf,'gradeability')
    if isfield(vinf.gradeability,'results')
        vinf.gradeability=rmfield(vinf.gradeability,'results');
    end
end

if isfield(vinf,'grade_test')
    if isfield(vinf.grade_test,'results')
        if ~isfield(vinf.grade_test,'param')
            vinf=rmfield(vinf,'grade_test');
        else
            vinf.grade_test=rmfield(vinf.grade_test,'results');
        end
    end
end

if isfield(vinf,'accel_test')
    if isfield(vinf.accel_test,'results')
        if ~isfield(vinf.accel_test,'param')
            vinf=rmfield(vinf,'accel_test');
        else
            vinf.accel_test=rmfield(vinf.accel_test,'results');
        end
    end
end

%remove acceleration performance information
eval('h=vinf.acceleration; test4exist=1;', 'test4exist=0;')
if test4exist
    eval('h=vinf.acceleration.run; test4exist=1;', 'test4exist=0;')
    if test4exist
        temp_setting=vinf.acceleration.run;
    end
    vinf=rmfield(vinf,'acceleration');
end
vinf.acceleration.run=temp_setting;

% --------------------------------------------------------------------
function varargout = save_simulation(h, eventdata, handles, varargin)
%Save all information in workspace
[name, path]=uiputfile('*.mat');	%user input for mat name to save simulation
if name==0
    return
else
    evalin('base',['save ''', path, name,'''']);
    disp(['Workspace successfully saved to ',name,'.']);
    evalin('base','rehash toolbox');
end

%---------------------------------------------------------------------
%Revision history
% 8/31/98: vh, added distance into gui
% 9/14/98:ss adjusted size of bar graph so multiplier is visible and for the bar graph, changed
%	the variable named aux_load_loss_kj(was aux_load_in_kj)
% 9/14/98: vh, grade now displays >10 if at limit
% 11/3/98:tm updated the acceleration performance display to use correct cycle length if not achieved
% 3/8/99:ss replaced variables with *_temp to *_tmp updated ex_gas_tmp legends to the three variables it 
%	represents rather than four variables from before.
% 3/10/99:ss removed case 'energy_figure'--> now energy_figure is its own function m-file
% 3/16/99:ss aligned third plotting figure to rest of them.
% 3/23/99:ss added case 'going_back' for the two callbacks for back and back two, it clears grade and accel infor
% 4/6/99 ss: set 'visible' to 'off' while creating and turned back 'on' when created
% 5/21/99 ss: removed waitbars from callbacks in the back and back two buttons.
% 5/26/99 ss: changed the way the figure size is determined.  If screensize is 1024x___ or bigger it uses
%             a predefined size in pixels else it uses normalized units.  Size is still saved between
%             figures.
% 6/8/99 ss,vhj: updated so legend is plotted every time
% 7/19/99 ss: updated acceleration section to make sure it knew when to plot up acceleration times or not(had problem
%             when cyc_accel was picked but running tests instead of cycles.
% 8/5/99 ss: added last_axes_handle and associated items in case 'plot_time_series' because there was a problem with
%            the legend being the returned axes for gca instead of the plot axes.
% 8/17/99 ss: added button for Prius speed plots only if prius_jpn drivetrain was selected.
% 2/2/01: ss updated prius to prius_jpn
% 9/14/99: vhj, added case 'save'
% 9/15/99: ss added if statements for units, plotted up kpha and cyc_kph_r instead of mph if units are 'metric'
% 9/22/99: ss allowed spaces in file name for saving results.
%10/08/99: vhj return gracefully from cancelled save
% 3/8/00: ss updated call to input figure to be InputFig and sim setup figure to SimSetupFig
% 3/21/00: ss changed 'action' to 'option' for the input argument.
% 3/21/00: ss split gui_results into three new files: ResultsFig.m, ResultsFig.mat & ResultsFigControl.m now need to call
%             ResultsFigControl in place of gui_results.
% 3/22/00: ss updated the tag for the gradeability value to 'grade value' instead of 'str_grade'
% 7/21/00 ss: updated name for version info to advisor_ver.
% 8/15/00:tm updated section for display of accel results because there are only 3 speed options now not 5 speeds
% 8/15/00:tm in case going_back added statements to remove grade and accel results fields
%% 8/18/00:tm added semicolon to prevent display of active in workspace
% 8/22/00 ss added isfield(vinf,'energy_storage') for plotting ess_soc_hist for custom case with no batteries.
% 11/16/00:tm added statements to display vehicle max speed from accel test results
% 01/18/01:ab added axes2bmp('') to print drive cycle bmp for Altia replay
% 1/29/01:tm removed statements that generated a time_max as a default value to display when accel not met - no longer used
% 2/1/01:ss made replay button invisible when multicycles was run (does not work properly for all cycles run in multi cycle run)
% 2/22/01:ss added call to new function results_var_select to setup variables for plotting. (now dependent on component chosen)
% 7/11/01:ss modified warnings section.  Warnings title background color will be same color as frame if there are no warnings. 
%01/04/02: vhj added plot specification for saber_ess case, fixed underscore for saber_ess labels
%01/07/02: vhj fixed reference to long var_to_plot for saber plotting (line 451)
%2/14/02: created this file to be in harmony with the way matlab now saves figures and associated , created from file ResultsFigControl.m
%4/10/02:mpo added the evalin so that chkoutputs will run on the workspace and not func-space--also added try/catch for error checking
