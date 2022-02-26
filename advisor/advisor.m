function varargout = advisor(varargin)
% advisor Application M-file for advisor.fig
%    FIG = advisor launch advisor GUI.
%    advisor('callback_name', ...) invoke the named callback.
%
% ADVISOR   Advanced Vehicle Simulator
% 
%   This function opens the first graphical user interface (GUI) into
%   the program ADVISOR.
%	
%   The ADVISOR program is designed to assist in testing different
%	vehicle configurations using standard and custom driving cycles or
%	test procedures.  
%
%	For help in running ADVISOR please use the help buttons found on
%	each user interface which links to the documentation pages.  If you still
%   need help or have helpful suggestions for improvement please email:
%							advisor@nrel.gov
%
% Last Modified by GUIDE v2.5 06-Apr-2012 15:19:01
global vinf

if nargin == 0  % LAUNCH GUI
	%-----------------------------------------------------------
    %if ADVISOR is running then don't start another one, just
    %bring the current ADVISOR figure to the top
    figure_tags={'advisor_figure';'input_figure';'execute_figure';'results_figure';...
            'rw_results_figure';'parametric_results_figure';'j1711_results_figure';...
            'city_hwy_results_figure';'ftp_results_figure'};
    for i=1:size(figure_tags)
        if ~isempty(findobj('tag',figure_tags{i}))
            figure(findobj('tag',figure_tags{i}));
            return
        end
    end
    %-------------------------------------------------------------
    
    advisor('set_path')
    
    %--------------------------------------------------
    %clear the workspace
    evalin('base','clear');
    evalin('base','global vinf')
    
    %set units to 'us' if not defined
    if ~exist('vinf.units', 'var')
        vinf.units='us';
    end
    
    hwait=waitbar(0,'loading startup figure');
    try
        waitbar(.5)
    end
    
    %add some sound if user's system can play sound
    try
        load list_optionlist.mat;  %loads list_optionlist and list_def
        if strfind(lower(list_def),'truck')
            [advisor_sound,fs]=wavread('truckwelcome.wav');
        else
            [advisor_sound,fs]=wavread('advisor.wav');
        end
        sound(advisor_sound,fs)
    end
    %---------------------------------------------------

    fig = openfig(mfilename,'new'); %'reuse' wasn't working when SOC figure was up 
    %fig = openfig(mfilename,'reuse');
    
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end
    
    %-------------------------------------------------------
    %adjust the figure appropriately
    [ver,date]=advisor_ver('info');
    set(findobj('tag','advisor_figure'),'Name',[ver ' ' date])
    
    %set the units radio buttons appropriately
    set(findobj('tag','metric_radiobutton'),'value',strcmp(vinf.units,'metric'))
    set(findobj('tag','us_radiobutton'),'value',strcmp(vinf.units,'us'))
    
    %set the optionlist popupmenu
    advisor('set_optionlist_popup')
    
    %set everything normalized and set the figure size and center it
    
    h=findobj('type','uicontrol');
    g=findobj('type','axes');
    
    set([h;g],'units','normalized')
    screensize=get(0,'screensize');
    if screensize(3)<1024
            uiwait(warndlg({'ADVISOR does not work well at resolutions lower than 1024x768.  Please increase resolution or proceed with caution!'},...
            'ADVISOR: Low Resolution Warning','modal'))
    end
    
    %test for large fonts and give warning if they are large.
    figh=figure('visible','off');
    test_string='test string';
    handle_text=text(0,0,test_string);
    set(handle_text,'units','pixels')
    extent=get(handle_text,'extent');%   0    -9    60    18
    close(figh);
    if extent(3)>61
            uiwait(warndlg({'ADVISOR does not work well with large fonts.  Please change your display settings to small fonts or proceed with caution!'},...
            'ADVISOR: Low Resolution Warning','modal'))
    end
       
    im_width=640;%this is the width of the image
    im_height=474;
    left=screensize(3)/2-im_width/2;
    bottom=screensize(4)/2-im_height/2;
    set(gcf,'position',[left bottom im_width im_height]);%
    set(gcf,'resize','off')
    
    %set the figure back on after everything is drawn
    set(gcf,'visible','on');
    
    
    advisor_ver
    
    waitbar(1)
    close(hwait); 	%close the waitbar  
    
    adv_dir=fileparts(which('advisor'));
    imagedata = imread(fullfile(adv_dir, 'gui_graphics', 'Splash_Screen_car.jpg'));
    h=image(imagedata);
    set(h,'ButtonDownFcn','advisor(''play_movie'')');
    
    advisor('play_movie')
    
    
    
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
function varargout = Copyright_button_Callback(h, eventdata, handles, varargin)
copyright

% --------------------------------------------------------------------
function varargout = Start_button_Callback(h, eventdata, handles, varargin)
global vinf
close(gcbf);
evalin('base','global vinf');
gui_input_open('defaults');

% --------------------------------------------------------------------
function varargout = edit_optionlist()
edit_profiles


% --------------------------------------------------------------------
function varargout = Profile_Popup_Callback(h, eventdata, handles, varargin)
current_selection_str=gui_current_str('Profile_Popup');
if strcmp(current_selection_str,'edit list')
    advisor('edit_optionlist')
    return
end
global vinf
vinf.optionlist.name=current_selection_str;
load list_optionlist.mat
list_def=current_selection_str;
p=which('list_optionlist.mat');
save(p,'list_def','list_optionlist');

%---------------------------------------------------------------------
function varargout = set_optionlist_popup
load list_optionlist.mat;  %loads list_optionlist and list_def
set(findobj('tag','Profile_Popup'),'string',list_optionlist)
index=strmatch(list_def, list_optionlist, 'exact');
set(findobj('tag','Profile_Popup'),'value',index);
global vinf
vinf.optionlist.name=list_def;


% --------------------------------------------------------------------
function varargout = Help_button_Callback(h, eventdata, handles, varargin)
load_in_browser('advisor_doc.html');


% --------------------------------------------------------------------
function varargout = Exit_button_Callback(h, eventdata, handles, varargin)
close(gcbf)

%----------------------------------------------------
function set_path()
%------------------Add ADVISOR directories to the MATLAB path-------------
% Add the appropriate paths based on where advisor.m is found with the which command (This
% defines the main ADVISOR directory)
%
% NOTE: paths will only be added with the addpath command if they don't already exist.
% If new directories were added to the path (using addpath), a 1 will be returned 
% otherwise a 0 will be returned.
% 
% SetAdvisorPath can accept a comma separated list of arguments.  The arguments should be
% the name of an existing directory.  Non-existing directories will not be created.
%

path_added=SetAdvisorPath; % external function that contains necessary path information

%find out if user wants to save the path changes.
if path_added==1
    ButtonName=questdlg('The Matlab path has been updated with ADVISOR directories for this Matlab session.  Would you like to save the new path for future Matlab sessions?  Note: Using VisualDoc optimization requires the path to be saved. ', ...
        'ADVISOR path setting', ...
        'Yes','No','Yes');
    
    switch ButtonName,
    case 'Yes', 
        result=savepath; %savepath saves the current path to pathdef.m (Both are MATLAB files-- not ADVISOR files)
        if result==0
            disp('ADVISOR Directories were successfully added to the Matlab Path.  See Path browser for path information.');
        else
            disp('Not successful.  ADVISOR directories were not successfully saved in the Matlab Path.');
        end
    case 'No',
    end % switch   
end; %if path_added=1;


% --------------------------------------------------------------------
function varargout = Load_Results_Callback(h, eventdata, handles, varargin)

global vinf

if ~exist('varargin') % no user-specified filename provided
    [name, path]=uigetfile('*.mat');	%user input for mat name of saved simulation
elseif isempty(varargin)    
    [name, path]=uigetfile('*.mat');	%user input for mat name of saved simulation
else % user-specified filename provided
    
    path_name=varargin{1};
    
    % break argument into the path and filename parts
    idx=strfind(path_name,'\');
    if isempty(idx)
        idx=strfind(path_name,'/');
    end
    if isempty(idx)
        name=path_name;
        path='';
    else
        name=path_name((max(idx)+1):end); 
        path=path_name(1:max(idx));
    end
end

%if no file is selected(ie. figure is cancelled) 
%then exit(or return) out of this function
if name==0
    return
end

evalin('base','clear all')
evalin('base',['load ''', path, name,'''']);
close(gcbf);

global vinf;

if strcmp(vinf.parametric.run,'off')
    ResultsFig;
else
    parametric_gui;
end

%---------------------------------------------------------------------      
function metric_radiobutton_Callback(h, eventdata, handles, varargin)
global vinf

vinf.units='metric';
set(findobj('tag','us_radiobutton'),'value',0);
set(findobj('tag','metric_radiobutton'),'value',1);

%---------------------------------------------------------------------
function us_radiobutton_Callback(h, eventdata, handles, varargin)
    global vinf
    vinf.units='us';
    set(findobj('tag','metric_radiobutton'),'value',0);
    set(findobj('tag','us_radiobutton'),'value',1);
    
%---------------------------------------------------------------------
function play_movie()

try
    adv_dir=strrep(which('advisor'),'\advisor.m','');
    
    imagenames={'car2truck001.gif';
        'car2truck002.gif';
        'car2truck003.gif';
        'car2truck004.gif';
        'car2truck005.gif';
        'car2truck006.gif';
        'car2truck007.gif';
        'car2truck008.gif';
        'car2truck009.gif';
        'car2truck010.gif';
        'car2truck011.gif';
        'car2truck012.gif';
        'car2truck013.gif';
        'car2truck014.gif';
        'car2truck015.gif'};
    
    for i=1:length(imagenames)
        [X,map]=imread([adv_dir '\gui_graphics\' imagenames{i}]);
        M(i)=im2frame(flipud(X),map);
    end
    
    loc=[36 206 0 0];
    N=[-2 1 1 1 1 1 1 1:15 15 15 15 15 15 15 15];
    movie(M,N,8,loc)
end

function LoadVehicle(filename)
% allows user to start ADVISOR with a specific saved vehicle other than the default

if ~exist('filename')
    filename='PARALLEL_defaults_in';
end

if evalin('base',['~exist(''',filename,'.m'')'])
    disp(['File ',filename,'.m not found.'])
else
    global vinf
    vinf.units='us';
    gui_input_open(filename)
end

return

function LoadResults(filename)
% allows user to start ADVISOR with a specific results file from the command line

if exist('filename')
    if evalin('base',['~exist(''',filename,'.mat'')'])
        disp(['File ',filename,'.mat not found.'])
    else
        advisor('Load_Results_Callback',[],[],[],filename)
    end
end

return

% Revision History
% 041802:tm added call to SetAdvisorPath external function and removed common code from this file
% 041802:tm added statements to the Load_Results_Callback function to allow the user to specify a 
%           results file to load from the command line
% 041802:tm added function to allow user to load a specific vehicle from the command line
% 041802:tm added function to allow user to load a specific results file from the command line
