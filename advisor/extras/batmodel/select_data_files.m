function select_data_files(action,info)

if nargin==0
   global binf;
   figcolor=[1 1 .6]; %yellow
   buttoncolor=[.75 .75 .75];
   
   h0 = figure('Color',figcolor, ...
      'MenuBar','none', ...
      'Name','File Specification', ...
      'NumberTitle','off', ...
      'Position',[237 114 690 389], ...
      'Visible','off',...
      'ToolBar','none');
   
   %title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'FontSize',12, ...
      'FontWeight','bold', ...
      'Position',[175 345 317 32], ...
      'String',['File Specification for ',binf.test_type,' tests'], ...
      'Style','text');
   if strcmp(binf.test_type,'MakeFile'), set(h1,'String','Mat files for advisor file generation'), end
   if strcmp(binf.test_type,'Plot_T_Var'), set(h1,'String','Mat files for temperature comparison'), end
   
   %paths
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'HorizontalAlignment','left', ...
      'Position',[21 324 122 16], ...
      'String','Path:', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Callback','select_data_files(''path name'')', ...
      'HorizontalAlignment','left', ...
      'Position',[17 302 516 20], ...
      'Style','edit', ...
      'Tag','pathname');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',buttoncolor, ...
      'Callback','select_data_files(''browse'')', ...
      'Position',[541 302 113 25], ...
      'String','Browse');
   
   %Directory Listing
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'HorizontalAlignment','left', ...
      'Position',[18 276 122 16], ...
      'String','Directory Listing', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Callback','select_data_files(''add'')',...
      'Position',[17 48 284 226], ...
      'String',' ', ...
      'Style','listbox', ...
      'Tag','directory listing', ...
      'Value',1);
   %Add/delete buttons
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Style','text',...
      'Position',[313 77 51 180], ...
      'String','Click on the file under Directory Listing (on left) to add, click on the file under Data Files (on right) to delete.');
   %h1 = uicontrol('Parent',h0, ...
   %   'BackgroundColor',buttoncolor, ...
   %   'Callback','select_data_files(''add'')', ...
   %   'Position',[313 187 51 30], ...
   %   'String','Add-->');
   %h1 = uicontrol('Parent',h0, ...
   %   'BackgroundColor',buttoncolor, ...
   %   'Callback','select_data_files(''delete'')', ...
   %   'Position',[313 145 51 30], ...
   %   'String','Delete');
   %Data Files
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'HorizontalAlignment','left', ...
      'Position',[382 277 122 16], ...
      'String','Data Files', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[379 48 284 226], ...
      'Callback','select_data_files(''delete'')', ...
      'Style','listbox', ...
      'Tag','data files', ...
      'Value',1);
   
   %Next
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',buttoncolor, ...
      'Callback','select_data_files(''next'')', ...
      'Position',[557 6 102 27], ...
      'String','Next');
   
   
   try
      p=eval(['binf.',binf.test_type,'.path']);
   catch
      try
         p=eval(['binf.peukert.path']);
      catch
         p=[pwd '\'];
      end
   end
   set(findobj('Tag','pathname'),'String',p);
   select_data_files('display file names',p);
   
   try
      str=eval(['binf.',binf.test_type,'.data_files']);
      set(findobj('Tag','data files'),'String',str);
   end
   
   %set everything normalized
    h=findobj('type','uicontrol');
    set([h],'units','normalized')
    %_______set the figure size and location
    screensize=get(0,'screensize'); %this should be in pixels(the default)
    figsize=[(screensize(3)-718)/2 (screensize(4)-418)/2 718 418];
    set(gcf,'units','pixels','position',figsize,'visible','on');
    %_____________end set the figure size
    
end

if nargin > 0
   switch action
   case 'path name'
      p=get(findobj('tag','pathname'),'string');
      select_data_files('display file names',p);
   case 'browse'
      [f p]=uigetfile('*.*','Pick Path Name');
      if f==0
         return
      end
      set(findobj('Tag','pathname'),'String',p);
      select_data_files('display file names',p);
   case 'display file names'
      d=dir(info);
      j=1;
      for i=1:max(size(d))
         if ~(strcmp(d(i).name, '.') | strcmp(d(i).name, '..'))& ~d(i).isdir
            filenames{j}=d(i).name;
            j=j+1;
         end
      end
      try, set(findobj('Tag','directory listing'), 'string', filenames);end
   case 'add'
      %get info from directory listing side
      h1=findobj('tag','directory listing');
      filenames=get(h1,'string');
      filenum=get(h1,'value');
      
      %get info from data files side
      h2=findobj('tag','data files');
      selected_files=get(h2,'string');
      
      %add new filename to list
      if isempty(selected_files);%if this is the first file just replace the string
         selected_files=filenames(filenum);
      elseif isempty(strmatch(filenames(filenum),selected_files) )
         % if this is not the first file, add it to the list (if not already there)
         selected_files(max(size(selected_files))+1)=filenames(filenum);
      end
      
      %reset the string in the data files
      set(h2,'string',selected_files)
      
   case 'delete'
      
      global filenames
      
      %get information on file to delete
      h1=findobj('tag','data files');
      filenum=get(h1,'value');
      filenames=get(h1,'string');
      
      %if only one filename then delete the filename
      if length(filenames)==1
         filenames='';
      %if last filename then just shorten filenames by 1   
      elseif length(filenames)==filenum
         filenames=filenames(1:filenum-1);
         set(h1,'value',filenum-1);
      %if first filename, and more than just one filename then shift filenames by 1   
      elseif length(filenames)~=1 & filenum==1
         filenames=filenames(2:max(size(filenames)));
      %for all other cases
  		else
           filenames=filenames([1:filenum-1 filenum+1:max(size(filenames))]);
      end
       
      set(h1,'string',filenames)
      
   case 'next'
      global binf;
      datafiles=get(findobj('tag','data files'),'string');
      path=get(findobj('tag','pathname'),'string');
      close(gcbf);
      if strcmp(binf.test_type,'MakeFile')
         global MakeFile
         eval([binf.test_type,'.data_files=datafiles;']);
         eval([binf.test_type,'.path=path;']);
         if isfield(binf,'RC')
             make_ADV_RC_bat_file
         else
             make_ADV_bat_file;
         end
      elseif strcmp(binf.test_type,'Plot_T_Var')
         eval(['binf.',binf.test_type,'.data_files=datafiles;']);
         eval(['binf.',binf.test_type,'.path=path;']);
         plot_T_var;
      else
         eval(['binf.',binf.test_type,'.data_files=datafiles;']);
         eval(['binf.',binf.test_type,'.path=path;']);
         data_file_info;
      end
   end
end

%Revision history
% 07/19/99: vhj added default path to be peukert if it exists
% 07/23/99: vhj changed path
% 11/29/99: ss under case 'browse'  added return if no file is picked.
% 12/07/99: vhj added makefile option
% 12/28/99: vhj selected files on left add, selected on right delete
% 03/17/00: vhj normalized fig
% 01/18/01: vhj remove Add/Delete buttons
%03/13/01: vhj center figure, call RC make file