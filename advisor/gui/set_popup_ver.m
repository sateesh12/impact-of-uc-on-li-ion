function set_popup_ver(component)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the file 		: set_popup_ver										%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description				: setup the popup menus for the version		%
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

%set the popup version menus' strings

if nargin == 0
   compos = optionlist('get','component_titles');
else
   compos = {component};
end

for i = 1:length(compos),
     
   %test if the component has a version
   compo = eval(['vinf.',compos{i}]);
   
   if isfield(compo,'ver')
      evalin('base',['SetString(''',compos{i},''')']);
      evalin('base',['SetValue(''',compos{i},''')']);
   end
end
   
      
%--------------------------------------------------------------------------------------
function SetString(tag)

	h=findobj('tag',[compo_name(tag),'_ver']);
   
   if 0
      %define the string of the compo_ver popupmenu depending on the number of versions defined in optionlist
      %number of versions = first dimension of the table of the component
      ver{1,1} = 'none';
      
      list = optionlist('get',tag);
      
      for i = 1:max(size(list))
         %maximum number of version = 99
         if i < 10
            ver{i,1} = ['0',num2str(i)];
         else
            ver{i,1} = num2str(i);
         end
      end
   end; %if 0
   
	ver=optionlist('get',[compo_name(tag),'_ver']);	   

   
   set(h,'string',ver);

   
  
%--------------------------------------------------------------------------------------
function SetValue(tag)

	compo_ver = [compo_name(tag),'_ver'];

	h=findobj('tag',compo_ver);
   set(h,'value',eval(['gui_current_val(''',tag,''',''ver'')']));
   
%07/06/00 Sylvain Pagerit (ANL-PSAT): allow to run only one	component and not all the list
%8/14/00 ss updated to use the component_ver list instead of counting how big the component array was
