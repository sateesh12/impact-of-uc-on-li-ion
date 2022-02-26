function varargout = scale_bore_stroke(varargin)
% SCALE_BORE_STROKE Application M-file for scale_bore_stroke.fig
%    FIG = SCALE_BORE_STROKE launch scale_bore_stroke GUI.
%    SCALE_BORE_STROKE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 03-Apr-2002 08:20:17

if nargin == 0  % LAUNCH GUI

    fig = openfig(mfilename,'new'); %'reuse' wasn't working when SOC figure was up 
	%fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

    
    %initialization stuff
    global bns
    bns.engine_type='SIPI';
    
    if isfield(bns,'full_filename')
        set(findobj('tag','old_engine_edit'),'string',bns.full_filename)
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
function varargout = old_engine_edit_Callback(h, eventdata, handles, varargin)
global bns
bns.full_filename=get(h,'string');


% --------------------------------------------------------------------
function varargout = Browse_pushbutton_Callback(h, eventdata, handles, varargin)
global bns
[f,p]=uigetfile('*.m','Select Engine File to Scale by Bore and Stroke');
if f==0; return; end

bns.full_filename=[p,f];
set(findobj('tag','old_engine_edit'),'string',bns.full_filename)


% --------------------------------------------------------------------
function varargout = SIPI_radiobutton_Callback(h, eventdata, handles, varargin)
global bns
set(findobj('tag','SIDI_radiobutton'),'value',0)
set(findobj('tag','CIDI_radiobutton'),'value',0)

bns.engine_type='SIPI';

% --------------------------------------------------------------------
function varargout = SIDI_radiobutton_Callback(h, eventdata, handles, varargin)
global bns
set(findobj('tag','SIPI_radiobutton'),'value',0)
set(findobj('tag','CIDI_radiobutton'),'value',0)

bns.engine_type='SIDI';

% --------------------------------------------------------------------
function varargout = CIDI_radiobutton_Callback(h, eventdata, handles, varargin)
global bns
set(findobj('tag','SIPI_radiobutton'),'value',0)
set(findobj('tag','SIDI_radiobutton'),'value',0)

bns.engine_type='CIDI';

% --------------------------------------------------------------------
function varargout = original_bore_Callback(h, eventdata, handles, varargin)
global bns
bns.old_bore=str2num(get(h,'string'));


% --------------------------------------------------------------------
function varargout = original_stroke_Callback(h, eventdata, handles, varargin)
global bns
bns.old_stroke=str2num(get(h,'string'));

% --------------------------------------------------------------------
function varargout = new_bore_Callback(h, eventdata, handles, varargin)
global bns
bns.new_bore=str2num(get(h,'string'));

% --------------------------------------------------------------------
function varargout = new_stroke_Callback(h, eventdata, handles, varargin)
global bns
bns.new_stroke=str2num(get(h,'string'));

% --------------------------------------------------------------------
function varargout = new_engine_edit_Callback(h, eventdata, handles, varargin)
global bns
filename=get(h,'string');
index=findstr(filename,'.');
if ~isempty(index)
    filename=[filename(1:index-1) '.m'];
end
bns.new_filename=filename;

% --------------------------------------------------------------------
function varargout = run_pushbutton_Callback(h, eventdata, handles, varargin)
global bns
bore1=bns.old_bore;
strk1=bns.old_stroke;
bore2=bns.new_bore;
strk2=bns.new_stroke;
if strcmp(bns.engine_type,'CIDI')
    etype=1;
elseif strcmp(bns.engine_type,'SIDI')
    etype=2;
elseif strcmp(bns.engine_type,'SIPI')
    etype=3;
end

run(bns.full_filename);

spd_vec=fc_map_spd;
trq_vec=fc_map_trq;
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;

if exist('fc_fuel_map_gpkWh');
    sfc=fc_fuel_map_gpkWh';
else
    sfc=fc_fuel_map./(fc_map_kW+eps)*3600;
end
if exist('fc_nox_map_gpkWh');
    no=fc_nox_map_gpkWh';
else
    no=fc_nox_map./(fc_map_kW+eps)*3600;
end
if exist('fc_hc_map_gpkWh');
    hc=fc_hc_map_gpkWh';
else
    hc=fc_hc_map./(fc_map_kW+eps)*3600;
end
if exist('fc_co_map_gpkWh');
    co=fc_co_map_gpkWh';
else
    co=fc_co_map./(fc_map_kW+eps)*3600;
end

if ~isfield(bns,'new_filename')
    bns.new_filename='out.m';
end

interpolator(bore1,strk1,etype,bore2,strk2,trq_vec,spd_vec,sfc,no,hc,co,bns.new_filename);

% --------------------------------------------------------------------
function varargout = exit_pushbutton_Callback(h, eventdata, handles, varargin)
clear global bns
close(gcbf)

% --------------------------------------------------------------------
function varargout = help_pushbutton_Callback(h, eventdata, handles, varargin)
load_in_browser('bore_stroke_scaling.html');
