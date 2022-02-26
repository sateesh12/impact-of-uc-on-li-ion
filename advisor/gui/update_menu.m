function update_menu(comp_name)
%
% This function will ensure that the current data file for the specified component 
% is in the Matlab path and it will ensure that the data file is in the appropriate menu.
%

global vinf
global DEBUG
DEBUG=0; % set to 1 to start debugging

% is the file in the current path
while isempty(eval(['which(vinf.',comp_name,'.name)']))
   uiwait(warndlg(['File ', eval(['vinf.',comp_name,'.name']),' cannot be used until it is present in the Matlab path.']))
   if ~eval(['addtopath(vinf.',comp_name,'.name)']) % function returns an error code = 1 if path not updated
      uiwait(warndlg(['Directory successfully added to Matlab path.']))
   end
end

% is the file ready for use with current version
% BEGIN added by mok [2002-04-16]
% the below added because differences in capitolization can cause the string not to be replaced in 'path'
fname=eval(['vinf.',comp_name,'.name']);
[TOK,REM]=strtok(which(fname), filesep);
while ~isempty(REM) % when remainder is empty, the last token (TOK) must be the filename (*.m)
    [TOK,REM]=strtok(REM, filesep);
    if DEBUG
        disp(['update_menu[main]: REM is not empty'])
        disp(['...Tok: ' TOK])
        disp(['...Rem: ' REM])
    end            
end
path =strrep(which(eval(['vinf.',comp_name,'.name'])),TOK,'');
if DEBUG
    path
    fname
end
% END added by mok [2002-04-16]
if check_vers(fname,path)
   
   % is the file in the current menus
   if ~isinmenu( eval(['vinf.',comp_name,'.name']),comp_name) % function returns an 0 if not in menu 
      if addtomenu(eval(['vinf.',comp_name,'.name']),comp_name); % function returns an error code = 1 if menu not updated
         uiwait(warndlg(['File ',  eval(['vinf.',comp_name,'.name']),' cannot be used until it is present in a component menu.']))
      end
   end
   
end

return

%-----------------------------------
%Subfunction Section 
%-----------------------------------
function resp=isinmenu(file_name,comp_name)
% This function ensures that the file_name is in the comp_name menu.  It prompts the user for 
% version and type information if none exist but is required.

global vinf

% initialization
exist_ver=0;
exist_type=0;
%load default if not already in workspace
if ~isfield(vinf, 'optionlist')
    load list_optionlist.mat
    vinf.optionlist.name=list_def;
end

load(vinf.optionlist.name)
array=eval(['options.' comp_name]);

%Define if the list depends on the version
if iscell(array{1})
   exist_ver = 1;
   no_of_versions=length(array);
  	short_name=compo_name(comp_name);   
   version_array=eval(['options.' short_name '_ver']);
     
   %Define if the list depends on the type
   if iscell(array{1}{1})
      exist_type = 1;
   	type_array=eval(['options.' short_name '_type']);   
   end
end

%check to make sure version exists in version array, if not then remove .ver field
if eval(['isfield(vinf.',comp_name,',''ver'')'])
   if isempty(strmatch( eval(['vinf.',comp_name,'.ver']) ,version_array,'exact'))
      tempstruct=rmfield(eval(['vinf.',comp_name]),'ver');
      eval(['vinf.',comp_name,'=tempstruct;'])
   end
end

   
   
% prompt for version information
if exist_ver&~eval(['isfield(vinf.',comp_name,',''ver'')'])
   uiwait(warndlg(['A version specification is required for ',comp_name,'.']))
   %h0=VersionListFig; 1/4/01 ss replaced this with the following three lines to use a .fig instead of .m & .mat
   open('VersionListFig.fig');
   h0=gcf;
   set(h0,'windowstyle','modal');
   
   set(findobj('tag','filename_text_box'),'string',file_name);
   set(findobj('tag','version_list'),'String',version_array,'value',1);
   assignin('base','versionliststr',version_array{1})
   uiwait(h0)
   ver_string=evalin('base','versionliststr');
   eval(['vinf.' comp_name '.ver=''' ver_string ''';'])
   evalin('base','clear versionliststr')
end

%check to make sure type exists in type array for version selected, if not then remove .type field
if eval(['isfield(vinf.',comp_name,',''type'')'])
   spec_type_array=optionlist('get',[short_name,'_type'],'junk',eval(['vinf.',comp_name,'.ver']));
   if isempty(strmatch( eval(['vinf.',comp_name,'.type']) ,spec_type_array,'exact'))
      tempstruct=rmfield(eval(['vinf.',comp_name]),'type');
      eval(['vinf.',comp_name,'=tempstruct;'])
   end
end

% prompt for type information
if exist_type&~eval(['isfield(vinf.',comp_name,',''type'')'])
   uiwait(warndlg(['A type specification is required for ',comp_name,'.']))
   %h0=TypeListFig; 1/4/01 ss replaced this with the following three lines to use a .fig instead of .m & .mat
   open('TypeListFig.fig');
   h0=gcf;
   set(h0,'windowstyle','modal');
   
   version_no=strmatch(eval(['vinf.',comp_name,'.ver']),version_array,'exact');
   set(findobj('tag','filename_text_box'),'string',file_name);
   set(findobj('tag','type_list'),'String',type_array{version_no},'value',1);
   assignin('base','typeliststr',type_array{version_no}{1})
   uiwait(h0)
   type_string=evalin('base','typeliststr');
   eval(['vinf.' comp_name '.type=''' type_string ''';'])
   evalin('base','clear typeliststr')
end

% build command string to get current menu list
if isfield(eval(['vinf.' comp_name]),'ver')
   version=eval(['vinf.' comp_name '.ver']);
   if isfield(eval(['vinf.' comp_name]),'type')
      type=eval(['vinf.' comp_name '.type']);
      str='optionlist(''get'', comp_name ,''junk'',version,type)';
   else
      str='optionlist(''get'', comp_name ,''junk'',version)';
   end
else
   str='optionlist(''get'', comp_name)';
end

% get current menu list
list=eval(str); 

% is file_name in the list?
if strmatch(file_name, list ,'exact')
   resp=1;
else
   resp=0;
end

return
%-----------------------------------

%-----------------------------------
function error_code=addtomenu(file_name,comp_name)
% This function adds the file_name to the appropriate menu

global vinf

% build command string to add to menu
if isfield(eval(['vinf.' comp_name]),'ver')
   version=eval(['vinf.' comp_name '.ver']);
   if isfield(eval(['vinf.' comp_name]),'type')
      type=eval(['vinf.' comp_name '.type']);
      str='optionlist(''add'', comp_name ,file_name,version,type)';
   else
      str='optionlist(''add'', comp_name ,file_name,version)';
   end
else
   str='optionlist(''add'', comp_name,file_name)';
end

% add to menu
list=eval(str); % list is the new menu list

% confirm addition to menu
if strmatch(file_name, list ,'exact')
   error_code=0;
else
   error_code=1;
end

return
%-----------------------------------

%-----------------------------------
function error_code=addtopath(file_name)
% This function will add the specified directory to the Matlab path

% prompt user for path
[f,p]=uigetfile([file_name,'.m'],'Locate File');

% add path info
if p~=0
   addpath(p);
   error_code=0;
else
   error_code=1;
end

return
%-----------------------------------

% Revision History
% 9/27/00:tm file created
% 1/4/01: ss changed to call a .fig file instead of a .m & .mat figure file for TypeListFig and VersionListFig
% 1/24/01; ss added sections for version and type to make sure the version and type existed in their respective lists
% 04/16/02: mpo changed the way the path is determined--due to differences in capitolization the path string was not...
% ..............always being reduced to just the path (sometimes it would go in with the filename as well which messes
% ..............up the algorithm)