function set_popup_type(component)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the file 		: set_popup_type										%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description				: setup the popup menus for the type			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by 				: Sylvain Pagerit (ANL-PSAT) - 06/23/00		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other necessary files : compo_name, optionlist							%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data provided by 		: 															%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by 				: 															%
% Sylvain Pagerit (ANL-PSAT) - 07/06/00	allow to run only one		%
%	component and not all the list												%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remark : 																				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global vinf

%set the popup type menus' strings

if nargin == 0
   compos = optionlist('get','component_titles');
else
   compos = {component};
end

for i = 1:length(compos),
   
   %test if a type is defined for the component compos{i}
   compo = eval(['vinf.',compos{i}]);
   
   if isfield(compo,'type')
      evalin('base',['SetString(''',compos{i},''')']);
      evalin('base',['SetValue(''',compos{i},''')']);
   end
end

%--------------------------------------------------------------------------------------
function SetString(tag)

	global vinf


	compo_type = [compo_name(tag),'_type'];
   
   h=findobj('tag',compo_type);
   
   string_type = optionlist('get',compo_type,'junk',eval(['vinf.' tag '.ver']));
   
   set(h,'value',1);
   set(h,'string',string_type);
   
%--------------------------------------------------------------------------------------
function SetValue(tag)

   compo = compo_name(tag);
   
   h=findobj('tag',[compo,'_type']);
   
   set(h,'value',eval(['gui_current_val(''',tag,''',''type'')']));
   
%07/06/00 Sylvain Pagerit (ANL-PSAT): allow to run only one	component and not all the list
% 8/15/00 ss changed around quite a bit for the new way to use optionlist('get'...)