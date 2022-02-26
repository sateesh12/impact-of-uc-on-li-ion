function set_popup(component)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the file 		: set_popup												%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description				: setup the popup menus of the initialization%
% files and the position choices													%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by 				: Sylvain Pagerit (ANL-PSAT) - 06/08/00		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other necessary files : compo_name, optionlist							%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data provided by 		: 															%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by 				: 															%
% Sylvain Pagerit (ANL-PSAT) - 06/23/00	take the version and the 	%
%	type into account																	%
% Sylvain Pagerit (ANL-PSAT) - 07/06/00	allow to run only one		%
%	component and not all the list												%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remark : 																				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global vinf

%set the popup menus' strings
   
   %list contains the tags for the popup uicontrols
   
   if nargin == 0
      %list all the component
	   list = optionlist('get','component_titles');
   
   	%add the graphical popupmenu which are not defined as model components
   	list{end+1} = 'position_choice1';
      list{end+1} = 'position_choice2';
   else
      list = {component};
   end
      
   %set the uicontrol values and strings appropriately   
   for i=1:max(size(list))
      evalin('base',['SetString(''',list{i},''')'])
      evalin('base',['SetValue(''',list{i},''')'])
   end
   
%--------------------------------------------------------------------------------------
function SetString(tag)

global vinf

	h=findobj('tag',tag);
   
   %test if there is a version and a type for the component
   compo = evalin('base',['vinf.',tag]);
   
   if isfield(compo,'ver')
      
      version=compo.ver;
      
      if isfield(compo,'type')
         type=compo.type;
         set(h,'string',optionlist('get',tag,'junk',version,type));
      else
         set(h,'string',optionlist('get',tag,'junk',version));
      end
   else
         set(h,'string',optionlist('get',tag));
   end
   
  
%--------------------------------------------------------------------------------------
function SetValue(tag)

	h=findobj('tag',tag);
   
   set(h,'value',eval(['gui_current_val(''',tag,''')']));
   
   
%06/23/00 Sylvain Pagerit (ANL-PSAT): take the version and the type into account
%07/06/00 Sylvain Pagerit (ANL-PSAT): allow to run only one	component and not all the list
% 8/15/00 ss updated how SetString works with version and type
