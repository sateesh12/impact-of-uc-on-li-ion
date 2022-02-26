function out=optionlist(selector,listname,listitem, version, type)
% function out=optionlist(selector,listname,listitem,version,type)
%    Updates the 'options' structure stored in the 'optionlist.mat' file (optionlist_car.mat,optionlist_truck.mat,...)
%    The 'options' structure contains the lists for popupmenus and such for the GUI
%
% input arguments:
%
%    selector:
%       'add' : adds 'listitem' to 'listname'
%       'del' : deletes 'listitem' from 'listname'
%       'get' : gets the entire list for 'listname'
%       'value' : get 'listitem' position in the 'listname' list
%       'createlist': creates a new listname 
%       'deletelist': deletes a listname from the options structure
%       'display'	: display the structure of the component		%Added by Sylvain Pagerit (ANL - PSAT)
%
%    listname: 
%       a character string containing the options list to be updated (ex. 'input_file_names'
%       to update options.input_file_names)
%
%    listitem: 
%       character string containing the item to add or delete (neither add nor
%       delete if already added or deleted) to the listname
%
%    version:
%        a character string defining the version of the item into the list
%
%    type: 
%        a character string defining the type of the item into the list
%
% output arguments:
%
%    'out':
%       in the case of 'add','del' or 'get' it is an array containing the list
%       in the case of 'value' it is a number indicative of the position within the list.
%       all other cases it is an empty matrix.
%
% Variables used:
%    
%
% Examples:
%
%   See also OptionlistFig, OptionlistFigControl

global vinf

% load the structure named 'options' that contains all the lists
%load default if not already in workspace
if ~isfield(vinf, 'optionlist')
    load list_optionlist.mat
    vinf.optionlist.name=list_def;
end

load(vinf.optionlist.name)
% structure 'options' is now in workspace

%-----ERROR CHECKING SECTION---------------------------------------
exist_ver = 0;
exist_type = 0;

if nargin == 0
   error('You must specify at least one input argument')
elseif nargin > 5
   error('You specified too much input arguments. The maximum is 5')
end

% make sure that selector is one of the available options
check=strmatch(selector,{'add','del','get','value','createlist','deletelist','display'});
if isempty(check)
   error(['''' selector, ''' is an incorrect input argument for optionlist'])
end

% make sure that listname is specified (ie. there are at least 2 input arguments.
if nargin < 2
   error('not enough input arguments for optionlist')
elseif nargin >= 2
   % make sure listname is a character string.
   if ~ischar(listname)
      error('listname needs to be a character string')
   end
   
   %make sure that listname is an existing component of the options structure. (except
   % for the 'create' case.
   if ~strcmp(selector,'createlist')
      if ~isfield(options,listname)
         error(['incorrect listname, ''',listname, ''' is nonexistent in options structure'])
      end
   end
   
   %this is a temporary cell array for ease of use in the following cases.  array can be used instead
   % of long and confusing eval commands with variables in them.  This is not compatible with the 'create'
   %  case.
   if ~strcmp(selector,'createlist')
      array=eval(['options.',listname]);
   end
   
   if ~strcmp(listname,'component_titles') & ~isempty(strmatch(listname,optionlist('get','component_titles'))) | ~isempty(findstr(listname,'_type'))
      %Define if the list depends on the version
      if iscell(array{1})
         exist_ver = 1;
         
         %Define if the list depends on the type
         if iscell(array{1}{1})
            exist_type = 1;
         end
      end
   end
end

%make sure that there are at least 3 input arguments for 'add','del','value' cases
check=strmatch(selector,{'add','del','value'});
if ~isempty(check)
   if exist_type == 1 & nargin < 5
      error('incorrect number of input arguments for optionlist. You must enter a version AND a type for this component')
   elseif exist_ver == 1 & nargin < 4
      error('incorrect number of input arguments for optionlist. You must enter a version for this component')
   elseif nargin < 3
      error('incorrect number of input arguments for optionlist')
   end
   
     
   % make sure that listitem is a character string
   if ~ischar(listitem)
      error('listitem needs to be a character string')
   end
end

if strcmp(selector,'display')
   if nargin > (3 + exist_ver + exist_type)
      error('you entered too much arguments');
   end
end

%if createlist is input selector and there are at least 3 arguments in,check to make sure listitem is a character string
if strcmp(selector,'createlist')& nargin >= 3
   if ~ischar(listitem)
      error('listitem needs to be a character string')
   end
end

% Make sure that there are only 2 input arguments when 'deletelist' is selector.  This makes sure
% that the caller didn't actually want to use 'del' which just deletes a listitem.
if strcmp(selector,'deletelist')
   if nargin==3
      error('too many input arguments for ''deletelist'' option')
   end
end

%----END OF ERROR CHECKING SECTION---------------------------------------
% get directory and file name for current optionlist (optionlist_car.mat, optionlist_truck.mat, ...) to be able to save it to the same name and
%directory later in the file.
filename=which([vinf.optionlist.name '.mat']);

%define the list which contains the all structure of the component
if exist('array')
   list = array;
end

%if the command is add, del ,value, or get then set the array
%with the list of the files depending on version and type if they exist
check = strmatch(selector,{'add','del','value','get'});
if ~isempty(check)
   if exist_ver
      
      if isempty(findstr(listname,'_type')) %if it's not a *_type listname
         list_ver = eval(['options.',compo_name(listname),'_ver']);
      else %it is a *_type listname
         list_ver=eval(['options.',strrep(listname,'_type','_ver')]);
      end
      index_version = strmatch(version,list_ver,'exact');
      
      array = array{index_version};
      
      if exist_type
         list_type = eval(['options.',compo_name(listname),'_type']);
         list_type = list_type{index_version};
         
         index_type = strmatch(type,list_type);
         
         array = array{index_type};
      end
   end               
end

switch selector
case 'add'   
   %compare new name with list to see if already in list
   index = strmatch(listitem, array, 'exact');
   
   % add to list if not already there
   if isempty(index)
      array{end + 1, 1} = listitem;
      %sort list for all cases except for type and versions
      if isempty(findstr(listname,'_type'))&isempty(findstr(listname,'_ver'))
         array = sort(array);
   	end
   
      %replace the list by the new one
      if exist_type
         list{index_version}{index_type} = array;
      elseif exist_ver
         list{index_version} = array;
      else
         list = array;
      end
      eval(['options.',listname,' = list;'])
      %save the options structure in the optionlist_car.mat or optionlist_truck.mat ...
      save(filename, 'options');
   end
      
   %output the cell array containing the list 
   list = eval(['options.',listname]);
   if exist_type
      out = list{index_version}{index_type};
   elseif exist_ver
      out = list{index_version};
   else
      out = list;
   end
   
   if 0
   %if it's a component list which has been changed, then display the whole structure of the component
   if ~isempty(strmatch(listname,optionlist('get','component_titles')))
      optionlist('display',listname);
      
      str = get(findobj('tag','list2'),'string');
      
      %if the file was not previously in the list, then inform where it has been added
      if isempty(index)
         if exist_type
            str = cat(1,str,{'';'';['You added the component file ',listitem,' in the list ',listname,' version ',version,' type ',type,'']});
         elseif exist_ver
            str = cat(1,str,{'';'';['You added the component file ',listitem,' in the list ',listname,' version ',version,'']});
         else
            str = cat(1,str,{'';'';['You added the component file ',listitem,' in the list ',listname,'']});
         end
      end
      
      set(findobj('tag','list2'),'string',str);
   end
   end %if 0
   
case 'del'
   %compare listitem with list to make sure it exists already in the list
   index=strmatch(listitem,array,'exact');
   
   if ~isempty(index)
      %if only listitem just make it an empty cell
      if length(array)==1
         array{index}='';
      else %rewrite the cell array using old array minus the listitem to delete
      	j=1;
         for i=1:length(array)
            if index~=i
               new_array(j,1)=array(i); % made sure it was a column array (nicer display) with the (j,1)
               j=j+1;
            end
         end
         array=new_array;
      end
      
      %replace the list by the new one
      if exist_type
         list{index_version}{index_type} = array;
      elseif exist_ver
         list{index_version} = array;
      else
         list = array;
      end
      eval(['options.',listname,' = list;'])
      
      %save the options structure in n the optionlist_car.mat or optionlist_truck.mat ...
      save(filename, 'options');
   end
   
   % output the cell array containing the list
   list = eval(['options.',listname]);
   if exist_type
      out = list{index_version}{index_type};
   elseif exist_ver
      out = list{index_version};
   else
      out = list;
   end
   
   if 0
   %if it's a component list which has been changed, then display the whole structure of the component
   if ~isempty(strmatch(listname,optionlist('get','component_titles')))
      optionlist('display',listname);
      
      str = get(findobj('tag','list2'),'string');
      
      %if the file was previously in the list, then inform from where it has been removed
      if ~isempty(index)
         if exist_type
            str = cat(1,str,{'';'';['You deleted the component file ',listitem,' in the list ',listname,' version ',version,' type ',type,'']});
         elseif exist_ver
            str = cat(1,str,{'';'';['You deleted the component file ',listitem,' in the list ',listname,' version ',version,'']});
         else
            str = cat(1,str,{'';'';['You deleted the component file ',listitem,' in the list ',listname,'']});
         end
      end   
      
      set(findobj('tag','list2'),'string',str);
   end
   end; %if 0
   
case 'get'
   
   if nargin == 5
      out = list{index_version}{index_type};
   elseif nargin == 4
      out = list{index_version};
   else
      out = list;
   end
   
case 'value'
   out=strmatch(listitem,array,'exact');
   
   if isempty(out)
      if exist_type
         error(['''',listitem,''' does not exist in ''',listname,''' version ',version,' type ',type])
      elseif exist_ver
         error(['''',listitem,''' does not exist in ''',listname,''' version ',version])
      else
         error(['''',listitem,''' does not exist in ''',listname,''''])
      end
   end
      
case 'createlist'
   if isfield(options,listname)
      error(['''',listname,''' already exists'])
   else
      eval(['options.', listname,'={};'])
      
      %save the options structure in the optionlist_car.mat or optionlist_truck.mat ...
      save(filename, 'options');
      
      %if listitem also input then add to the new list.
      if nargin==3
         out=optionlist('add',listname,listitem);
      end
      
   end
   
   
case 'deletelist'
   options=rmfield(options,listname);
   %save the options structure in the optionlist_car.mat or optionlist_truck.mat ...
   save(filename, 'options');

case 'display'
%Allow to easily inspect the structure of a component in the options structure   
   
   if 0
   
   if exist_ver
      str = {['The ',listname,' has ',num2str(length(list)),' version(s)'];...
            ''};
   else
      str = '';
   end
   
   
   %To display the structure of the types of component if it exist
   if nargin < 5 & exist_type
      str{end+1, 1} = ['the ',listname,' types are :'];
      str{end+1, 1} = '';
      
      list_type = eval(['options.',compo_name(listname),'_type']);
      
      %To display the types of a specified version
      if nargin == 4
         list_type = list_type{str2num(version)};
         str_type = '';
         
         for i = 1:length(list_type)
            str_type = [str_type, list_type{i},', '];
         end
         
         str{end+1, 1} = ['for the version ',version,': ',str_type];
         
      %To display the types for all the versions
      else
         for i = 1:length(list_type)
            list_type2 =  list_type{i};
            str_type = '';
            
            for j = 1:length(list_type2)
               str_type = [str_type, list_type{i}{j},', '];
            end
            
            str{end+1, 1} = ['for the version ',num2str(i),': ',str_type];
         end
      end
      
      str{end+1, 1} = '-------------------------';
      str{end+1, 1} = '';
   end
   
   
   %To display the structure of a component having a version
   if nargin < 4 & exist_ver
      str{end+1, 1} = ['the ',listname,' initialization files are :'];
      str{end+1, 1} = '';
      
         %To display the structure of a component depending on its version and its type
         if exist_type
            list_type = eval(['options.',compo_name(listname),'_type']);
         
         for i = 1:length(list)
            str{end+1, 1} = ['Version ',num2str(i),':'];
            
            list_type2 =  list_type{i};
            
            for j = 1: length(list_type2)
               str{end+1, 1} = ['    Type ',list_type{i}{j},':'];
               
               for k = 1:length(list{i}{j})
                  str{end+1, 1} = ['          ',list{i}{j}{k},', '];
               end
               
               str{end+1, 1} = '';
            end
         end
      else
         %To display the structure of a component which has only a version
         for i = 1:length(list)
            str{end+1, 1} = ['Version ',num2str(i),':'];
                        
            for k = 1:length(list{i})
               str{end+1, 1} = ['          ', list{i}{k},', '];
            end
            
            str{end+1, 1} = '';
         end
      end
   elseif nargin < 4
      %To display the structure of a component which has neither version nor type
      for i = 1:length(list)
         str{end+1, 1} = [list{i},', '];
      end
   end
   
   %To display the structure of a component for a specified a version
   if nargin == 4
      str{end+1, 1} = ['the ',listname,' initialization file(s) are (is):'];
      str{end+1, 1} = '';
      str{end+1, 1} = ['Version ',version,':'];
      
      index_version = str2num(version);
      
      list_type = eval(['options.',compo_name(listname),'_type']);
                  
      for j = 1: length(list_type{index_version})
         str{end+1, 1} = ['    Type ',list_type{index_version}{j},':'];
      
         for k = 1:length(list{index_version}{j})
            str{end+1, 1} = ['          ',list{index_version}{j}{k},', '];
         end      
      end
   end   
   
   %To display the structure of a component for a specified a version and a specified type
   if nargin == 5
      str{end+1, 1} = ['the ',listname,' initialization file(s) are (is):'];
      str{end+1, 1} = '';
      str{end+1, 1} = ['Version ',version,', type ',type,':'];
   
      list_type = eval(['options.',compo_name(listname),'_type']);
         
      index_version = str2num(version);
      index_type = strmatch(type,list_type{index_version});
      
      for k = 1:length(list{index_version}{index_type})
         str{end+1, 1} = ['          ', list{index_version}{index_type}{k},', '];
      end      
  end   
   
   
   h0 = OptionListDisplay;
   h1 = get(h0,'children');
   
   set(h1,'units','normalized');
   
   set(0,'units','pixel');
   screensize=get(0,'screensize');
   
   window_width = 500;
   window_high = 700;
   
   set(h0,'position',[(screensize(3)-window_width)/2 (screensize(4)-window_high)/2 window_width window_high]);
   
   set(findobj('tag','list2'),'string',str);
   
   set(findobj('tag','listname2'),'string',listname)
   
   %To display the type and/or the version of the component
   if nargin >= 4
      set(findobj('tag','TextVersion2'),'visible','on');
      set(findobj('tag','Version2'),'visible','on','string',get(findobj('tag','Version'),'string'));
      
      if nargin == 5
         set(findobj('tag','TextType2'),'visible','on');
         set(findobj('tag','Type2'),'visible','on','string',get(findobj('tag','Type'),'string'));
      end
   end
	end; %if 0   
otherwise
   
end


% Revision History:
% 7/11/00 ss: created this function for manipulation of options structure that is saved in the optionlist.mat file.
% 7/12/00 ss: added 'createlist' and 'deletelist' cases for new listname addition and deltion to the options structure.
% 7/26/00 Sylvain Pagerit (ANL-PSAT): modified the error section and the add, del, get and value cases
%		to take the version and the type into account and to display what has been changed in the structure.
% 7/26/00 Sylvain Pagerit (ANL-PSAT): added the display case for easily inspect the structure of components.
% 8/10/00 ss: corrected minor problem in MATLAB 6.0.  Added a space between strings on line 37 (line that makes sure
%             selector is one of the options.
% 8/15/00 ss: updated so it would read in the version list (ex. options.fc_ver) rather than going by depth into the array
% 8/15/00 ss: commented out display sections for now (not working) with if 0 statements
% 8/15/00 ss: added conditional to not sort list for type and version cases under case 'add'
% 8/15/00 ss: added using exist_ver for *_type listnames because they need to be indexed into depending on the version.
% 10/23/00 ss: updated header comments, removed vinf variable (not used)