function CopyAxes2Fig()

oldfighandle=gcf;
oldaxeshandle=gca;

%get legend handle for axes in question if exist
legendhandles=findall(oldfighandle,'tag','legend');
if ~isempty(legendhandles)
   olduserdata=get(legendhandles,'userdata');
   if length(legendhandles)==1
      if olduserdata.PlotHandle==oldaxeshandle
         oldlegendhandle=legendhandles;
      end
   else
      
      for i=1:length(legendhandles)
         if olduserdata{i}.PlotHandle==oldaxeshandle
            oldlegendhandle=legendhandles(i);
         end
      end
   end
end

newfighandle=figure;
newaxeshandle=copyobj(oldaxeshandle,newfighandle);

set(newaxeshandle,'units','normalized','position',[0.13 0.11 0.775 0.815],'tag','plot axes');

if exist('oldlegendhandle')
   %find the text handle that deletes legends and remove its delete function and delete the text object
   %this prevents unwanted deletion of legends not on the copied axes
   texthandle=findall(newaxeshandle,'tag','LegendDeleteProxy');
   set(texthandle,'DeleteFcn','');
   delete(texthandle);
   
   %create a new legend based on the old legend strings from the copied axes.
   ud=get(oldlegendhandle,'userdata');
	axes(newaxeshandle);
   
   if iscell(ud.lstrings)
      legend(ud.lstrings{:})
   else
      legend(ud.lstrings);
   end
end

%Revision History
% 7/7/00 ss: created this new file for use with adv_menu the edit menu.
% 7/10/00 ss: fixed legend copying problems
% 8/16/00 ss: added if iscell for legend plotting.
