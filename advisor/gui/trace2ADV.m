% Trace data comes in the following format:
%trace_date          trace_x_n           trace_y_n           
%trace_headlines     trace_x_u           trace_y_u           
%trace_x             trace_y    

%Date of simulation-trace_date
%Header information on simulation-trace_headlines
%Time label-trace_x_n
%Units of time-trace_x_u
%Variable time-trace_x
%Names of variables to be available-trace_y_n
%Units of variables-trace_y_u
%Values of variables-trace_y

%Pick trace file to load
[f p]=uigetfile('*.mat','Pick Trace Test File');
%load the file
eval(['load ' p f]);

%Create variable list for use with Advisor
[a,b]=size(trace_y_n);
for i=1:a,
   endStr=0;startStr=0;
   for j=b:-1:1,
      if (trace_y_n(i,j)~=' ' & endStr==0)
         endStr=j;
      end
      if (trace_y_n(i,j)=='/' & startStr==0)
         startStr=j+1;
      end
   end
   if (endStr>startStr)
      testVars{i}=trace_y_n(i,startStr:endStr);
   end
end

%Get rid of 'matlab unfriendly' parts of the names
testVars=strrep(testVars,':','');
testVars=strrep(testVars,' ','');
testVars=strrep(testVars,'(','');
testVars=strrep(testVars,')','');
testVars=strrep(testVars,'.','');
testVars=strrep(testVars,'-','');

%Save variables to their respective names
for i=1:length(testVars)
   eval([testVars{i} '=trace_y(i,:);']);
end
%Create fuel usage in g/s
try,
   fuel_gal_s=Bfueldelivered.*Ldieselrpm*6.6043E-9;
   testVars{end+1}='fuel_gal_s';
end
%record time as variable named t_trace;
t_trace=trace_x;

%Save trace vars to a mat file
[f,p]=uiputfile('*.mat','Name mat file to save test data to.');
vars=['''t_trace'''];
for i=1:length(testVars)
   vars=[vars ',''' testVars{i} ''''];
end
eval(['save(''' [p,f] ''',' vars ')'])
disp(['Trace data saved to ',p,f])

clear a b endStr startStr i j;
%Revision History
% 6/04/99: vhj file created
%09/14/00: vhj eliminated time recalculation (.99 factor) to maintatin trace value for time
%					testVars--now matlab friendly names, save vars to a mat file
%09/15/00: vhj saves to a mat file now, to be used with DataCompareFig etc
%09/22/00: vhj try to create a fuel_gal_s variable