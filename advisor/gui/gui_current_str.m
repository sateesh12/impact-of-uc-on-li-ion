function str=gui_current_str(tag)

%str=gui_current_str(tag)  ADVISOR 2.0 function
%
%	This function is used to find the current string of a popupmenu or list
%	using the tag of the desired uicontrol.  tag is a string.
%	example str=gui_current_str('drivetrain') might return str='parallel'.
%


if nargin==0
   return
end
% find the object handle h of the object with the tag property tag.
h=findobj('tag',tag,'type','uicontrol');

%find the value (an integer) indicating which row of the string matrix the 
%object is currently set on.
value=get(h,'value');
if value==0
   value=1;
end

%find the list of options for the object
stringmatrix=get(h,'string');

%select only the string from the list corresponding to the value
tempstr=char(stringmatrix(value,:));

%eliminate trailing blank spaces
tempstr=deblank(tempstr);
if isempty(tempstr)
   error('empty string');
else
   str=tempstr;
end