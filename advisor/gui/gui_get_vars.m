function vars=gui_get_vars(option)
%function vars=gui_get_vars(option) returns variable names 
%from the workspace in cell array vars.  If no input 
%arguments then vars is a list of scalars.  If option='time' then
%vars returns variable names that are vectors or matrices the same size
%as the variable t(which is used to store time)

vars{1,1}='none';
h=evalin('base','whos');%this is a structure
j=1;

if nargin==0;%get scalars
%select only scalar variables of type double array
for i=1:size(h,1)
   if (isequal(h(i).size,[1 1]) & strcmp(h(i).class,'double'))
      vars{j,1}=h(i).name;%curly brackets indicate cell array{}
      j=j+1;
   end
end
end;%if nargin==0

if nargin>0
   switch option
   case 'time'
      if evalin('base',['exist(''t'',''var'')'])
      	t=evalin('base','t');	   
      	if ~isempty(t)
      	   for i=1:size(h,1)
      	   	if (isequal(h(i).size(1),length(t)) & strcmp(h(i).class,'double'))   
      	      vars{j,1}=h(i).name;
      	      j=j+1;
      	   	end
      	   end
         end; %if ~isempty(eval...
      end
   otherwise
   end
end; %if nargin>0
      