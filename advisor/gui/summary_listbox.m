function summary_listbox(option)
%This function looks for variables in the workspace to figure out and display 
%in a listbox the current vehicle/simulation information
%option='load','print',or 'save'

global vinf

switch option
case 'load'
   
   %load the saved figure
   open('SummaryListbox.fig')
   
   if get(0,'screensize')==[1 1 1024 768]
      posfig=[408 222 450 300];
   else
      posfig=[308 222 450 300];
   end
   
   set(findobj('tag','SummaryListboxFig'),'position',posfig,'visible','on')

%build the cell array that contains the information to be placed in the listbox
%store the information in an array named str
i=1;
str{i}=['Last Saved Vehicle Name: ',vinf.name];
i=i+1;str{i}='';%put empty line in 
comp=optionlist('get','component_titles');

for x=1:length(comp)
   if isfield(vinf,comp{x})
      string=eval(['vinf.',comp{x},'.name']);
      i=i+1;
      str{i}=sprintf('%20s%2s%15s',comp{x},': ',string);
   end   
end
% BEGIN added by mpo 18-Oct-2001: adding line to display which variable electric aux. loads file is loaded
if evalin('base', 'vinf.AuxLoadsOn==1') % if variable auxiliary loads are on, put the info in the string
    strToken=''; % string Token
    strRem=evalin('base','vinf.AuxLoads.FileName'); % string remainder %26 mar 2002:mpo updated to new nomenclature *.FileName
    emptyString = blanks(0); % return an empty string
    while ~strcmp(strRem, emptyString)
        [strToken, strRem] = strtok(strRem,'\'); % tokenize the string until strToken only contains the file name
    end
    i=i+1; % increment the counter
    str{i}=sprintf('%20s%2s%15s','var_elec_aux_loads',': ',strToken);
    clear strToken strRem myCnt;
end % END added by mpo 18-Oct-2001
%check to see if there are any modified variables, and if so save them to the str
eval('vinf.variables; test4exist=1;','test4exist=0;');%this is sort of an 'exist' statement for structures
if test4exist
   i=i+1;
   i=i+1;str{i}='';%put empty line in 
   str{i}='Modified Variables';
   i=i+1;str{i}='';%put empty line in 

   for j=1:max(size(vinf.variables.name))
      i=i+1;
      str{i}=sprintf('%20s%2s%10s%11s%10s',vinf.variables.name{j},'= ',num2str(vinf.variables.value(j)),' default= ',num2str(vinf.variables.default(j)));
   end
end

eval('vinf.init_conds; test4exist=1;','test4exist=0;')
if test4exist
	i=i+1;str{i}='';%put empty line in 
   i=i+1;
   str{i}='Initial Conditions';
   i=i+1;str{i}='';%put empty line in 
   names=fieldnames(vinf.init_conds);
   for j=1:length(names)
      i=i+1;
      str{i}=sprintf('%21s%2s%10s',names{j},'= ',num2str(eval(['vinf.init_conds.',names{j}])));
   end
   
end
%if performance targets are set then save these to str
eval('h=vinf.targets; test4exist=1;','test4exist=0;')
if test4exist
   i=i+1;
   i=i+1;str{i}='';%put empty line in 
   str{i}='Performance Targets';
   i=i+1;str{i}='';%put empty line in 
   i=i+1;
   str{i}=['Grade=',num2str(vinf.targets.grade_grade),' % at ',num2str(vinf.targets.grade_mph),' mph'];
   i=i+1;
   str{i}=['Acceleration times (s):  0-60:',num2str(vinf.targets.accel_0_60),'  40-60:',num2str(vinf.targets.accel_40_60), '  0-85:',num2str(vinf.targets.accel_0_85)];
end

%if performance test has been done then show results
i=i+1;str{i}='';%put empty line in 
i=i+1;
str{i}='Performance Results';
i=i+1;str{i}='';%put empty line in 

eval('h=vinf.max_grade; test4exist=1;','test4exist=0;')
if test4exist
   i=i+1;
   str{i}=['Grade=',num2str(vinf.max_grade),' % at ',num2str(vinf.gradeability.speed),' mph'];
end

eval('h=vinf.acceleration.time_0_60; test4exist=1;','test4exist=0;')
if test4exist
   i=i+1;
   str{i}=['Acceleration times (s):  0-60:',num2str(vinf.acceleration.time_0_60),'  40-60:',num2str(vinf.acceleration.time_40_60), '  0-85:',num2str(vinf.acceleration.time_0_85)];
end

%Place the information string in the listbox
set(findobj('tag','summary_listbox'),'String',str)


case 'save'
   [f,p]=uiputfile('*.txt');
   if f==0;%user does not enter a file name
      return
   end
   fid=fopen([p,f],'wt+');
   clear str
   str=(get(findobj('tag','summary_listbox'),'string'));
   str=strrep(str,'%','%%');%make it so it prints out the percentage sign
   str=char(str);
   for i=1:size(str,1)
      fprintf(fid,str(i,:));
      fprintf(fid,'\n');
   end
   fclose(fid);
   
   
case 'print'
   
end;%switch option

% 7/17/00: ss replaced gui options with optionlist.
% 5/17/01: ss moved figure setup to SummaryListbox.fig file.
% 10/18/01:mpo added lines to record the variable auxiliary load file that was loaded for reference
% 03/26/02:mpo updated to work with new format of vinf.AuxLoads struct