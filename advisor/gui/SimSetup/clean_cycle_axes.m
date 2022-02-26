%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the file      : clean_cycle_axes.m                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description           :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by            : Sylvain Pagerit ANL - PSAT (09/21/00)      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other necessary files :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data provided by      :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by           :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remarks : Designed by ANL for PSAT 4.0                             %
% Will be integrated in the next release of Advisor                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clean_cycle_axes()

global vinf

handles = findobj(gcf,'type','axes');

for i = 1:length(handles)
   
   if isempty(findstr(get(handles(i),'tag'),'axe cycle')) & ~strcmp(get(handles(i),'tag'),'axe trip') &...
         ~strcmp(get(get(handles(i),'Parent'),'tag'),'TMWWaitbar')
      
      delete(handles(i))
      
   elseif ~isempty(findstr(get(handles(i),'tag'),'axe cycle')) | strcmp(get(handles(i),'tag'),'axe trip')
      h = handles(i);
      name = get(h,'tag');
      
      axes(h)
      cla reset
      
      set(h,'tag',name);
   end
end      

h = findobj('tag','axe trip');

if strcmp(vinf.trip.run,'on')
   set(h,'visible','on')
else
   set(h,'visible','off')
end   
   
for i = 1:8
   h = findobj('tag',['axe cycle',num2str(i)]);
      
   if strcmp(vinf.multi_cycles.run,'on')
      set(h,'visible','on')
   else
      set(h,'visible','off')
   end
end

parents = get(handles,'Parent');

if iscell(parents)
   parents = [parents{:}];
end
