function varargout = edit_profiles(varargin)
% EDIT_PROFILES Application M-file for Edit_Profiles.fig
%    FIG = EDIT_PROFILES launch Edit_Profiles GUI.
%    EDIT_PROFILES('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 06-Apr-2012 14:04:06

if nargin == 0  % LAUNCH GUI

    fig = openfig(mfilename,'new'); %'reuse' wasn't working when SOC figure was up 
	%fig = openfig(mfilename,'reuse');
	%set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end
    
    %--------------------------------------------------------------------
    %set everything normalized and set the figure size and center it
    
    h=findobj('type','uicontrol');
    g=findobj('type','axes');

    set([h;g],'units','normalized')
    screensize=get(0,'screensize');
    pos=get(gcf,'position');
    im_width=pos(3);%this is the width of the image
    im_height=pos(4);
    left=screensize(3)/2-im_width/2;
    bottom=screensize(4)/2-im_height/2;
    set(gcf,'position',[left bottom im_width im_height]);%
    set(gcf,'resize','off')
    set(gcf,'visible','on')
    
    edit_profiles('update_list')
    
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
function varargout = listbox1_Callback(h, eventdata, handles, varargin)
load list_optionlist.mat
current_name=list_optionlist{get(h,'value')};
list_def=current_name;
p=which('list_optionlist.mat');
save(p,'list_optionlist','list_def');


% --------------------------------------------------------------------
function varargout = update_list()
load list_optionlist.mat
%leave off 'edit list' (last item in list)
list_value=strmatch(list_def,list_optionlist,'exact');

set(findobj('tag','listbox1'),'string',list_optionlist(1:end-1),'value',list_value)


% --------------------------------------------------------------------
function varargout = Delete_pushbutton_Callback(h, eventdata, handles, varargin)
%make sure there remains at least one name in list 
str=get(findobj('tag','listbox1'),'string');

if length(str)>1  
    
    load list_optionlist.mat
    index=get(findobj('tag','listbox1'),'value');
    j=1;
    for i=1:length(list_optionlist)
        if index~=i
            new_list{j,1}=list_optionlist{i};
            j=j+1;
        end
    end
    list_optionlist=new_list;
    list_def=list_optionlist{1};
    p=which('list_optionlist.mat');
    save(p,'list_optionlist','list_def');
end

edit_profiles('update_list')

% --------------------------------------------------------------------
function varargout = Done_pushbutton_Callback(h, eventdata, handles, varargin)
delete(gcbf);
advisor('set_optionlist_popup')



% --------------------------------------------------------------------
function varargout = NewName_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Create_pushbutton_Callback(h, eventdata, handles, varargin)
current_name=gui_current_str('listbox1');
load([current_name , '.mat'])
newpath=strrep(which('list_optionlist.mat') , 'list_optionlist.mat' , '');
new_name=get(findobj('tag','NewName'),'string');
if findstr(new_name,'.')
    index=min(findstr(new_name,'.'));
    new_name=new_name(1:index-1);
end
load list_optionlist.mat
%make sure name is not already in the list
if strmatch(new_name,list_optionlist)
    return
end
%make sure user doesn't interfere with the file 'list_optionlist.mat'
if strmatch(lower(new_name),'list_optionlist.mat')
    return
end
save([newpath new_name], 'options');
list_optionlist{end}=new_name;
list_optionlist{end+1}='edit list';
list_def=new_name;
p=which('list_optionlist.mat');
save(p, 'list_optionlist', 'list_def');

edit_profiles('update_list')
%rehash so matlab can find the new file.
rehash toolbox

% --------------------------------------------------------------------
function varargout = Add_pushbutton_Callback(h, eventdata, handles, varargin)
current_directory=pwd;
cd(strrep(which('list_optionlist.mat'),'list_optionlist.mat',''));
[f,p]=uigetfile('*.mat','Select Profile to Add to list');
cd(current_directory)
if f==0
    return
end

%check to make sure .mat file contains the options structure
load([p,f])
if exist('options')
    if ~isstruct(options)
        warndlg([f ,' does not contain the required structure named ''options''.'])
        return    
    end
else
    warndlg([f ,' does not contain the required structure named ''options''.'])
    return
end

new_name=strrep(f,'.mat','');


load list_optionlist.mat
%make sure name is not already in the list
if strmatch(new_name,list_optionlist)
    helpdlg([new_name, ' already exists in the list!'])
    return
end

list_optionlist{end}=new_name;
list_optionlist{end+1}='edit list';
list_def=new_name;
p=which('list_optionlist.mat');
save(p, 'list_optionlist', 'list_def');

edit_profiles('update_list')
%rehash so matlab can find the new file.
rehash toolbox

% --------------------------------------------------------------------
function varargout = Help_Pushbutton_Callback(h, eventdata, handles, varargin)
edit_profiles('Done_pushbutton_Callback')
load_in_browser('custom_menus.html');
