function set_component_listitem(component);

global vinf

%the tag for the popupmenu containing the component list
tag=component;

listitem=eval(['vinf.' component, '.name']);
listname=[component , '_', eval(['vinf.' component '.type']) '_' eval(['vinf.', component, '.ver'])];

set(findobj('tag',tag),'string',optionlist('get',listname),...
   'value',optionlist('value',listname,listitem))

%set the version popupmenu
listname=[component '_ver'];
set(findobj('tag',[component '_ver']),'string',optionlist('get',listname),...
   'value',optionlist('value',listname, eval(['vinf.', component ,'.ver'])));
%set the type popupmenu
listname=[component '_type_', eval(['vinf.' component '.ver'])];
set(findobj('tag',[component '_type']),'string',optionlist('get',listname),...
      'value',optionlist('value',listname ,eval(['vinf.', component ,'.type'])));
      
      
      