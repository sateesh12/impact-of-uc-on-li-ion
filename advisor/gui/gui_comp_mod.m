function gui_comp_mod(option,str)
%gui_comp_mod(option)  ADVISOR 2.0
%this function edits the component list in the gui
%option='open' or 'add' or 'delete', str=name of component type(make
%sure this coincides with gui_options).

global vinf

switch option
case 'open'
 
%setup the colors for the figure
figure_color=[.5 .5 .75];

if get(0,'screensize')==[1 1 1024 768]
   posfig=[331 378 406 232];
else
   posfig=[331 300 406 232];
end

h0 = figure('Color',figure_color, ...
	'MenuBar','none', ...
   'Name',['Edit Lists--',advisor_ver('info')], ...
	'NumberTitle','off', ...
	'Position',posfig, ...
   'Tag','figure_comp_mod',...
   'WindowStyle','modal');

% help and done buttons
h1 = uicontrol('Parent',h0, ...
	'Callback','load_in_browser(''advisor_doc.html'');', ...
	'Position',[258 9 64 29], ...
	'String','Help', ...
	'Tag','Pushbutton3');

h1 = uicontrol('Parent',h0, ...
	'Callback','gui_comp_mod(''done'')',...
	'Position',[325 9 71 29], ...
	'String','Done', ...
	'Tag','Pushbutton1');

%add, delete and edit m-file buttons
h1 = uicontrol('Parent',h0, ...
   'CallBack','gui_comp_mod(''add'');',...
	'Position',[210 170 111 32], ...
	'String','Add to list', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
   'CallBack','gui_comp_mod(''delete'');',...
	'Position',[210 130 111 32], ...
	'String','Delete from list', ...
	'Tag','Pushbutton5');
h1 = uicontrol('Parent',h0, ...
   'CallBack','eval([''edit '',gui_current_str(''component_listbox'')]);close(gcbf)',...
	'Position',[210 90 111 32], ...
	'String','View/Edit M-file', ...
   'Tag','Pushbutton6');

% Convert file button and help button

h1 = uicontrol('Parent',h0,...
   'CallBack','update_file',...
   'Position',[210 50 111 32],...
   'String','Convert a file');

h1 = uicontrol('Parent',h0,...
   'CallBack','load_in_browser(''advisor_ch2.html'', ''#2.3'');', ...
   'Position',[324 50 50 32],...
   'String','<- Help');


%component type and list box
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',figure_color, ...
	'FontSize',14, ...
	'Position',[ 9 200 148 27 ], ...
	'String',str, ...
	'Style','text', ...
	'Tag','new_comp_title');
h1 = uicontrol('Parent',h0, ...
	'BackgroundColor',[1 1 1], ...
	'Position',[9 5 181 190], ...
	'String',gui_options(str), ...
	'Style','listbox', ...
	'Tag','component_listbox', ...
   'Value',get(findobj('tag',str),'value'));

%build extra button if ess
if strcmp(str,'energy_storage')
   h1 = uicontrol('Parent',h0,...
   'CallBack',['cd ''',strrep(which('advisor.m'),'gui\advisor.m','batmodel'),''';close(gcf);batmodel'], ...
   'Position',[335 125 50 32],...
   'String','batmodel');
end
if strcmp(str,'fuel_converter')
   h1 = uicontrol('Parent',h0,...
   'CallBack',['cd ''',strrep(which('advisor.m'),'gui\advisor.m','engmodel'),''';close(gcf);engmodel'], ...
   'Position',[335 125 50 32],...
   'String','engmodel');
end



case 'add'
   
   comp_title=get(findobj('tag','new_comp_title'),'string');
   
   [filename,pathname]=uigetfile('*.m','Select component m-file');
   
   
  	%return out of the function if uigetfile is not used to specify a file
   if filename==0
      return
   end
   
   i=findstr('.',filename);
   %make the file name the new string for the list
   new_str=filename(1:i-1);
   
   %**************************************************************
   %%%%%UPDATE ROUTINE FOLLOWS:EDITS THE FILE OF COMPONENT BEING ADDED IF NOT UP TO DATE
   
   %run the update file routine that checks if component is up to the proper version
   flag=check_vers(new_str);
   %get out of add if update returns a flag indicating that file is not the right version or
   %has not been updated.
   if flag~=1
      return
   end
   
   %%%%END OF UPDATE ROUTINE**************************************
   
   waithandle = WAITBAR(.25,'adding component to list');
   
   
   %open gui_options for reading and temporary.m for writing.
   %first switch to gui directory
   current_directory=pwd;
   temp=which('gui_options.m');
   temp_dir=strrep(temp,'gui_options.m','');
   cd(temp_dir);
   fid=fopen(which('gui_options.m'),'rt');
   fid_temp=fopen('temporary.m','wt+');
   
   %initialize line counter
   line_counter=1;
   
   waitbar(.75)
   
   %add the new component in the proper place in a file called temporary.m
   while feof(fid)==0
      %read line from gui_options
      line=fgets(fid);
      %try to find match until found 
      match=findstr(line, ['case ''',comp_title,'''']);
    	num=length(match); %will be set to 1 if string is found
      line=strrep(line,'%','%%');%fix any comment lines to print with fprintf 
      fprintf(fid_temp,line); 
      if num>0;
         counter=0;
         while feof(fid)==0
            line=fgets(fid);
            %search for the end of case
            match=findstr(line,'}');
            num=length(match);
            if num>0&strcmp(vinf.drivetrain.name,'fuel_cell')&strcmp(comp_title,'fuel_converter')
               counter=counter+1;
               if counter==1
                 num=0;%force the while to continue to second list
               end
            end
         	if num>0
            	%fix the current last line to be the line before the last line
         		line=strrep(line,'};',';...');
   				line=strrep(line,'%','%%'); %fix any comment lines to print with fprintf  
               fprintf(fid_temp,line);
            	%print the new last line with the new component
         		fprintf(fid_temp,['               ''',new_str,'''       };\n']);   
               break
            end
            line=strrep(line,'%','%%'); %fix any comment lines to print with fprintf
            fprintf(fid_temp,line);
         end
         break
      end
   end
   
   waitbar(.95)
      
   %now copy the rest of the file over to temporary
   a=fscanf(fid,'%c');
   a=strrep(a,'%','%%'); %fix any comment lines to print with fprintf 
   fprintf(fid_temp,a);
   
   fclose(fid);
   fclose(fid_temp);
   
   %copy temporary.m file to gui_options.m
	file='gui_options.m';
   	if (isunix) %test to see if the computer is a unix machine
	  eval(['!cp temporary.m ',file]);
	elseif (isppc) %test to see if the computer is a mac
   		%the mac copy command (please see note later in the email) 
	elseif (isvms) %test to see if the compter is vms
	   %vms copy command
	else %otherwise the computer is a PC
      eval(['!copy temporary.m ',file]);
	end
   delete temporary.m
   cd(current_directory);
   
   temp=get(findobj('tag','new_comp_title'),'string');
   set(findobj('tag','component_listbox'),'string',gui_options(temp));
   h=findobj('tag',comp_title);
   if strcmp(comp_title,'cycles')
      h=findobj('tag',comp_title,'style','listbox');
   end
   set(h,'string',gui_options(temp));
   %msgbox('Don''t forget to add an m-file with same name!');
   
   close(waithandle)
   
   
case 'delete'
   
   waithandle = WAITBAR(.25,'deleting component from list');
   
   del_str=gui_current_str('component_listbox');
   comp_title=get(findobj('tag','new_comp_title'),'string');
   
   %if only one component left then don't delete otherwise problems occur
   list=get(findobj('tag','component_listbox'),'string');
   if max(size(list))==1
      errordlg('Not able to delete item when only one is left')
      return
   end
   
   %open gui_options for reading and temporary.m for writing.
   %first switch to gui directory
   current_directory=pwd;
   temp=which('gui_options.m');
   temp_dir=strrep(temp,'gui_options.m','');
   cd(temp_dir);
   fid=fopen(which('gui_options.m'),'rt');
   fid_temp=fopen('temporary.m','wt+');
   
   waitbar(.75)
   
   %remove the component in the proper place in a file called temporary.m
   while feof(fid)==0
      %read line from gui_options
      line=fgets(fid);
      %try to match until found 
      match=findstr(line, ['case ''',comp_title,'''']);
    	num=length(match); %will be set to 1 if string is found
      if num>0;
         line_prev=line;
         while feof(fid)==0
            line=fgets(fid);
            %search for component to be deleted
         	match=findstr(line,del_str);
         	num=length(match);
         	if num>0
            	%check to see if component is on last line
               match=findstr(line,'}');
               num=length(match);
               if num>0; %if component is on last line replace previous line ';...' with '};'
                  line_prev=strrep(line_prev,';...','};');
   					line=strrep(line,'%','%%'); %fix any comment lines to print with fprintf  
               	fprintf(fid_temp,line_prev);
                  break
               else; %print out the previous line without change
          		  	line_prev=strrep(line_prev,'%','%%'); %fix any comment lines to print with fprintf
            		fprintf(fid_temp,line_prev);
               end
               break
            end
            line_prev=strrep(line_prev,'%','%%'); %fix any comment lines to print with fprintf
            fprintf(fid_temp,line_prev);
            line_prev=line;
         end
         break
      end
      line=strrep(line,'%','%%');%fix any comment lines to print with fprintf 
     	fprintf(fid_temp,line); 
	end
   %now copy the rest of the file over to temporary
   a=fscanf(fid,'%c');
   a=strrep(a,'%','%%'); %fix any comment lines to print with fprintf 
   fprintf(fid_temp,a);
   
   fclose(fid);
   fclose(fid_temp);
   
   %copy temporary.m file to gui_options.m
	file='gui_options.m';
   	if (isunix) %test to see if the computer is a unix machine
	  eval(['!cp temporary.m ',file]);
	elseif (isppc) %test to see if the computer is a mac
   		%the mac copy command (please see note later in the email) 
	elseif (isvms) %test to see if the compter is vms
	   %vms copy command
	else %otherwise the computer is a PC
      eval(['!copy temporary.m ',file]);
	end
   
   waitbar(.95)
   
   delete temporary.m
   cd(current_directory);
   
   temp=get(findobj('tag','new_comp_title'),'string');
   set(findobj('tag','component_listbox'),'string',gui_options(temp),'value',1);
   h=findobj('tag',comp_title);
   if strcmp(comp_title,'cycles')
      h=findobj('tag',comp_title,'style','listbox');
   end
   set(h,'string',gui_options(temp),'value',1);
   
   close(waithandle)
   
case 'done'
   str=get(findobj('Tag','new_comp_title'),'string');
   set(findobj('tag',str),'string',get(findobj('tag','component_listbox'),'string'));
   set(findobj('tag',str),'value',get(findobj('tag','component_listbox'),'value'));
   eval(['vinf.',str,'.name=gui_current_str(''component_listbox'');']);
   evalin('base',get(findobj('tag',str),'callback'));
   close(gcbf)
otherwise
   
end

%----------------------------------
%REVISION HISTORY
%----------------------------------
% 10/22/98 (SS): added case 'done' to end of file replacing and correcting the callback for the done button.
%12/2/98-ss added if statements at the beginning for different screen resolutions
%12/14/98-ss added waitbars for adding and deleting components to/from list.  This was to
%		help users from thinking that nothing is happening.
% 12/15/99:ss enlarged the figure and the list section so that long names can be seen.
% 7/21/00 ss: updated name for version info to advisor_ver.
