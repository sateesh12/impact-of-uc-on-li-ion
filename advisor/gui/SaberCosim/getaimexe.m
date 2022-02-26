function varargout = GetAimExe(varargin)
% GETAIMEXE Application M-file for GetAimExe.fig
%    FIG = GETAIMEXE launch GetAimExe GUI.
%    GETAIMEXE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 26-Mar-2002 10:38:29

if nargin == 0  % LAUNCH GUI
    
    WarnHandle=warndlg({'The ADVISOR/Saber co-simulation works using:';...
            '     Windows 2000';...
            '     Saber 2001.4';...
            '     MATLAB Release 12.1'},'Warning');
    uiwait(WarnHandle);
    
    fig = openfig(mfilename,'new'); %'reuse' wasn't working when SOC figure was up 
    %fig = openfig(mfilename,'reuse');
    
    % Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
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
function varargout = AimExeString_Callback(h, eventdata, handles, varargin)

path=get(findobj('tag','AimExeString'),'string');
WriteAimExeFile(path);
close(gcbf);


% --------------------------------------------------------------------
function varargout = Browse_Callback(h, eventdata, handles, varargin)

[file path]=uigetfile('*.exe','Pick Path of Saber (Aim) exe');
if file==0
    return
end
set(findobj('Tag','AimExeString'),'String',[path]);


% --------------------------------------------------------------------
function varargout = Cancel_Callback(h, eventdata, handles, varargin)

close(gcbf);


% --------------------------------------------------------------------
function varargout = Done_Callback(h, eventdata, handles, varargin)

path=get(findobj('tag','AimExeString'),'string');
WriteAimExeFile(path);
close(gcbf);


% --------------------------------------------------------------------
function WriteAimExeFile(path)

global vinf

if isa(path,'cell')
    path=path{1};
end

AimExeStorageFileName=strrep(vinf.tmppath,'tmp\','gui\sabercosim\');
fid=fopen([AimExeStorageFileName,'AimExe.txt'],'w');
fprintf(fid,'%s',path);
fclose(fid);


