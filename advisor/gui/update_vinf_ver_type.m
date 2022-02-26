function update_vinf_ver_type(component,option)

%This function updates the vinf structure to include the component version
% and type based on the name of the component.

%option doesn't do anything yet. 8/1/00 ss

global vinf

% get the specific name of the component
listitem=eval(['vinf.', component, '.name']);

exist_ver=0;
exist_type=0;

%load default if not already in workspace
if ~isfield(vinf, 'optionlist')
    load list_optionlist.mat
    vinf.optionlist.name=list_def;
end

load(vinf.optionlist.name)

array=eval(['options.' component]);

%Define if the list depends on the version
if iscell(array{1})
   exist_ver = 1;
   no_of_versions=length(array);
  	short_name=compo_name(component);   
   version_array=eval(['options.' short_name '_ver']);
     
   %Define if the list depends on the type
   if iscell(array{1}{1})
      exist_type = 1;
   	type_array=eval(['options.' short_name '_type']);   
   end
end

%find what version number and type(if applicable) the name belongs to.
if exist_ver
   for i=1:length(array) %for number of versions
      if exist_type
         for j=1:length(type_array{i}) %for number of types for a specific version
            match=strmatch(listitem,array{i}{j},'exact');
            if ~isempty(match)
               ver_string=version_array{i};
               type_string=type_array{i}{j};
               eval(['vinf.' component '.type=''' type_string ''';'])
	            eval(['vinf.' component '.ver=''' ver_string ''';'])
               return
            end
         end
      else
         match=strmatch(listitem,array{i},'exact');
         if ~isempty(match)
            ver_string=version_array{i};
            eval(['vinf.' component '.ver=''' ver_string ''';'])
            return
         end
         
      end
   end
   warndlg(['The ' component ' named ' listitem ' doesn''''t exist in any list'])
end

% 8/14/00 ss: updated to use the new cell array format for identifying version and type.
% 8/18/00 ss: fixed placement of warning for component not being in any list.  Was in the wrong loop.
% 1/24/00 ss: fixed strmatch statements with 'exact' added to input arguments.
