function OptionListFigControl(option,listname,tag)

%this function for use with optionlist and optionlist_gui
%  listname

global Tag4OptionListFigControl
global vinf

if nargin==3
   if strcmp(tag,'def_tag')
      %use Tag4OptionListFigControl from before
   else
      Tag4OptionListFigControl=tag;
   end
elseif nargin==2
   Tag4OptionListFigControl=listname;
end


switch option
case 'open'
   
h0=open('OptionListFig.fig'); %display the gui

%set the figure name
set(h0,'Name',['Edit List--',advisor_ver('info')])


set(findobj('tag','listname'),'string',listname)

%if a component name then do type and version update
if isfield(vinf,listname) 
   %find out if it has ver and/or type associated with it and update accordingly.
   if isfield(eval(['vinf.' listname]),'ver')
      version=eval(['vinf.' listname '.ver']);
      if isfield(eval(['vinf.' listname]),'type')
         type=eval(['vinf.' listname '.type']);
         set(findobj('tag','list'),'string',optionlist('get',listname,'junk',version,type),'value',get(findobj('tag',Tag4OptionListFigControl),'value'))
      else
         set(findobj('tag','list'),'string',optionlist('get',listname,'junk',version),'value',get(findobj('tag',Tag4OptionListFigControl),'value'))
      end
   else
      set(findobj('tag','list'),'string',optionlist('get',listname),'value',get(findobj('tag',Tag4OptionListFigControl),'value'))
   end
else
   set(findobj('tag','list'),'string',optionlist('get',listname),'value',get(findobj('tag',Tag4OptionListFigControl),'value'))
end

%set the size of the figure and center it.
global size
size=get(0,'screensize');

posfig=[(size(3)-406)/2 (size(4)-232)/2 406 232];
set(gcf,'position',posfig);
set(gcf,'visible','on');

%build extra button if ess
if strcmp(Tag4OptionListFigControl,'energy_storage')
   h1 = uicontrol('Parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack',['close(gcf);batmodel'], ...
   'Position',[335 90 50 32],...
   'String','batmodel');
end
%build extra buttons if fuel_converter
if strcmp(Tag4OptionListFigControl,'fuel_converter')
   h1 = uicontrol('Parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack',['close(gcf);engmodel'], ...
   'Position',[335 90 50 32],...
   'String','engmodel');
   h1 = uicontrol('Parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack','OptionListFigControl(''scale_bore_stroke'')', ...
   'Position',[305 170 100 32],...
   'fontsize',8,...
   'String','Scale Bore/Stroke');
end




case 'add'
   
   
   if strcmp(listname,'input_file_names')
      old_dir=pwd;
      advisor_root_dir = fileparts(which('advisor.m'));
      saved_vehicles_dir = fullfile(advisor_root_dir, 'saved_vehicles');
      cd(saved_vehicles_dir);
      [f,p]=uigetfile('*_in.m','select file to add to list');
      cd(old_dir)
   else
      [f,p]=uigetfile('*.m','select file to add to list');
   end
      
   if f==0; return; end
   
   listitem=strrep(f,'.m','');
   if ~strcmp(listname,'input_file_names')
      ver_flag=check_vers(listitem,p);
      if ~ver_flag %everything did not work ok.
         return
      end
   end
   
	%find out if it has ver and/or type associated with it and update accordingly.
   if isfield(vinf,listname)
      
      if isfield(eval(['vinf.' listname]),'ver')
         version=eval(['vinf.' listname '.ver']);
         if isfield(eval(['vinf.' listname]),'type')
            type=eval(['vinf.' listname '.type']);
            list=optionlist('add',listname,listitem,version,type);
            set(findobj('tag','list'),'string',list, 'value',optionlist('value',listname,listitem,version,type))
         else
            list=optionlist('add',listname,listitem,version);
            set(findobj('tag','list'),'string',list,'value',optionlist('value',listname,listitem,version))
         end
      else
         list=optionlist('add',listname,listitem);
         set(findobj('tag','list'),'string',list,'value',optionlist('value',listname,listitem));
      end
   else
      list=optionlist('add',listname,listitem);
      set(findobj('tag','list'),'string',list,'value',optionlist('value',listname,listitem));
   end
   
   
   %if the popupmenu being modified exists make sure the list is updated and the string stays the same
   % as before.  (this is in case something is added but the done button is never selected)
   h=findobj('tag',Tag4OptionListFigControl);
   if ~isempty(h)
      listitem=gui_current_str(Tag4OptionListFigControl);
      
      %find out if it has ver and/or type associated with it and update accordingly.
      if isfield(vinf,listname)
         if isfield(eval(['vinf.' listname]),'ver')
            version=eval(['vinf.' listname '.ver']);
            if isfield(eval(['vinf.' listname]),'type')
               type=eval(['vinf.' listname '.type']);
               set(h,'string',list,'value',optionlist('value',listname,listitem,version,type));
            else
               set(h,'string',list,'value',optionlist('value',listname,listitem,version));
            end
         else
            set(h,'string',list,'value',optionlist('value',listname,listitem));
         end
      else
         set(h,'string',list,'value',optionlist('value',listname,listitem));
      end
      
  end
   
case 'delete'
   listitem=gui_current_str('list');
   
   %find out if it has ver and/or type associated with it and update accordingly.
   if isfield(vinf,listname)
      if isfield(eval(['vinf.' listname]),'ver')
         version=eval(['vinf.' listname '.ver']);
         if isfield(eval(['vinf.' listname]),'type')
            type=eval(['vinf.' listname '.type']);
            list=optionlist('del',listname,listitem,version,type);
         else
            list=optionlist('del',listname,listitem,version);
         end
      else
         list=optionlist('del',listname,listitem);
      end
   else
      list=optionlist('del',listname,listitem);
   end
   
   set(findobj('tag','list'),'string',list,'value',1);
   
   % added 9/27/00:tm to prevent errors in code below - without it the name does not exist because it was deleted above
   set(findobj('tag',Tag4OptionListFigControl),'string',list,'value',1);
   % end added 9/27/00:tm
   
      %if the popupmenu being modified exists make sure the list is updated and the string stays the same
      % as before.  (this is in case something is added but the done button is never selected)
      h=findobj('tag',Tag4OptionListFigControl);
      if ~isempty(h)
         listitem=gui_current_str(Tag4OptionListFigControl);
         
         %find out if it has ver and/or type associated with it and update accordingly.
         if isfield(vinf, listname)
            if isfield(eval(['vinf.' listname]),'ver')
               version=eval(['vinf.' listname '.ver']);
               if isfield(eval(['vinf.' listname]),'type')
                  type=eval(['vinf.' listname '.type']);
                  set(h,'string',list,'value',optionlist('value',listname,listitem,version,type));
               else
                  set(h,'string',list,'value',optionlist('value',listname,listitem,version));
               end
            else
               set(h,'string',list,'value',optionlist('value',listname,listitem));
            end
         else
            set(h,'string',list,'value',optionlist('value',listname,listitem));
         end
      end
   
  case 'scale_bore_stroke'
     listitem_name= gui_current_str('list');
     global bns
     bns.full_filename=which(listitem_name);
     close(gcf);
     scale_bore_stroke;
     
  case 'done'
   set(findobj('tag',Tag4OptionListFigControl),'string',get(findobj('tag','list'),'string'))
   set(findobj('tag',Tag4OptionListFigControl),'value',get(findobj('tag','list'),'value'))
   close(gcbf)
   string=get(findobj('tag',Tag4OptionListFigControl),'callback');
   %handle differently if callback contains guidata  (from auto generating figure creation code)
   if ~isempty(strfind(string,'guidata'))
       indices=strfind(string,',');
       %replace first , with ) and remove the rest of the string, this will work in most cases unless
       %callback really needs the handle of the current object or guidata
       string=string(1:indices(1));
       string=strrep(string , ',' , ')' );
   end
   evalin('base',string)
   
otherwise
end

% ss 7/21/00: added h0=  to OptionListFig to get handle.
% ss 7/26/00 ss: changed directories for engmodel and batmodel
% ss 8/1/00 ss: added Tag4OptionListFigControl to the input argument.
% ss 8/11/00 ss: added setting of the figure name to include version of advisor.
% ss 8/13/00 ss: under the case where listname=input_file_names changed looking for saved_vehicles directory 
%               from looking for SERIES_defaults_in to looking for advisor.m and switching directories
%              to the saved_vehicles directory
% 8/15/00 ss added ver and type functionality.
% 9/27/00:tm added statement to the delete case to update menu strings and current 
%            value when entry deleted - prevents errors in following statements - without 
%            it the name does not exist because it was deleted previous statements
% 01/24/01: vhj removed changing directory when calling batmodel or engmodel