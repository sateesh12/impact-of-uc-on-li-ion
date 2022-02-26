function data_file_read(option)
% function data_file_read 
% requires a text file with one header line containing names(no spaces) for each column of data
% allows user to choose a data file with header(s) and assigns each column of data to 
% variables named by the header names.  The user can then save the information to a *.mat
% file.


if nargin==0 %set up the gui for user to input what file to convert
   
   figcolor=[.8 .8 1]; %light purple
   butcolor=[1 0.5 0.25]; %orange
   butcolor1=[1 1 .64]; %yellow
   butcolor2=[1 .5 .5]; %coral
   butcolor3=[.34 .67 .67]; %greenish
   butcolor4=[.85 .85 .85]; %grey
   
   dy=-25;
   
   %Figure
   h0 = figure('Color',figcolor, ...
      'MenuBar','none', ...
      'NumberTitle','off', ...
      'Name','Convert text file',...
      'Position',[117 287 450 301], ...
      'Tag','Convert text file to mat file', ...
      'Visible','off',...
      'ToolBar','none');
   %Title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[24 265 375 30], ...
      'HorizontalAlignment','left',...
      'FontWeight','bold',...
      'FontSize',14,...
      'String','Convert text file to mat file', ...
      'Style','text');

   %Heading text
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[24 265+dy 375 30], ...
      'HorizontalAlignment','left',...
      'String',{'Conversion requires a text file with one header line containing names (no spaces) for each column of data.'}, ...
      'Style','text');
   %File to convert
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',butcolor1, ...
      'CallBack','data_file_read(''get file'')',...
   	'Position',[22 223+dy 112 36], ...
      'String','Select file to convert');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Position',[145 228+dy 179 22], ...
      'String','', ...
      'Style','text', ...
      'Tag','file_name');
   %Variable lists
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'HorizontalAlignment','left',...
      'Position',[21 186+dy 179 22], ...
      'String','List of variables from header:', ...
      'Style','text');
   
   h1 = uicontrol('Parent',h0, ...
      'Position',[20 157+dy 201 24], ...
      'String',' ', ...
      'Style','popupmenu', ...
      'Tag','variable list', ...
      'Value',1);
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',butcolor1, ...
      'CallBack','data_file_read(''delete variable'')',...
   	'Position',[246 160+dy 89 24], ...
      'String','Delete from list');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',butcolor1, ...
      'CallBack','data_file_read(''modify name'')',...
   	'Position',[349 160+dy 89 24], ...
      'String','Modify name', ...
      'Tag','Pushbutton2');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'HorizontalAlignment','left',...
      'Position',[21 80+dy 375 70], ...
      'String',{'Note--Headers must be of the following format (modify names as appropriate):','  Speed named fc_spd in rpm','  Torque named fc_trq in Nm','  Fuel use named fc_fuel in g/s','  Emissions named fc_hc, fc_co, fc_nox, fc_pm in g/s.'}, ...
      'Style','text');
   
   
   %Save
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',butcolor, ...
      'CallBack','data_file_read(''file save as'')',...
   	'Position',[24 30+dy 185 36], ...
      'String','Select *.mat file to save to');
   
   % Set figure to normalized for proper resizing
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   
   %Center figure on screen
   screensize=get(0,'screensize');
   position=get(gcf,'position');
   position(1)=(screensize(3)-position(3))/2;
   position(2)=(screensize(4)-(position(4)+20))/2;
   set(gcf,'position',position,'visible','on')
   
   set([h; g],'units','normalized')
   
   
end %if nargin==0


if nargin>0
   global f
   
   switch option
      
   case 'get file'
      
      %get the file name
      [f p]=uigetfile('*.*','Select data file');
      if f==0
         return
      end
      
      f.file_name=f;
      f.file_path=p;
      set(findobj('tag','file_name'),'string',f.file_name);
      
      %strip off header and place in variable list and save an array of indices into matrix
      fid1=fopen([f.file_path f.file_name],'rt'); %ss removed the + in 'rt+' 2/7/01
      rem=fgetl(fid1); %get the first line which should be the header line
      
      %place header names into a variable list
      i=1;
      while ~isempty(rem)
            [heading,rem]=strtok(rem);
            if ~isempty(heading)
               f.variable_list{i}=heading;
            end
            i=i+1;
      end
      
      set(findobj('tag','variable list'),'string',f.variable_list);
      
      f.variable_indices=[1:length(f.variable_list)];
      
      %read rest of file into a matrix
      m=length(f.variable_list);
      f.matrix=fscanf(fid1,'%f',[m,inf]);	%scan variables to workspace
      f.matrix=f.matrix'; %transpose so data is in columns
      fclose(fid1);
      
   case 'modify name'
      value=get(findobj('tag','variable list'),'value');
      
      prompt={['enter the new name for ',f.variable_list{value},':']};
      %answer will be a cell array with new name
      answer=inputdlg(prompt,'Variable Name Change');
      if isempty(answer)
         return
      end
      
      f.variable_list{value}=answer{1}; %ss updated this statement to work in R12
      set(findobj('tag','variable list'),'string',f.variable_list);
      
      
   case 'delete variable'
      value=get(findobj('tag','variable list'),'value');
      
      j=1;
      for i=1:length(f.variable_indices)
         if value~=i
            indices(j)=f.variable_indices(i);
            variables(j)=f.variable_list(i);
            j=j+1;
         end
      end
      f.variable_indices=indices;
      f.variable_list=variables;
      
      new_value=value-1;
      if new_value==0
         new_value=1;
      end
      
      set(findobj('tag','variable list'),'value',new_value,'string',f.variable_list);
      
   case 'file save as'
      
      %get file name to save as
      [file path]=uiputfile('*.mat','Select file to save as');
      if file==0
         return
      end
      
      %make sure file ends in .mat
      test=findstr(file,'.mat');
      if isempty(test)
         index=findstr(file,'.');
         if isempty(index);
            file=[file,'.mat'];
         else
            file=[file(1:index),'mat'];
         end
      end
      
      string='';
      %assign data to variables and build string for save command
      for i=1:length(f.variable_indices)
         eval([f.variable_list{i},'=f.matrix(:,',num2str(f.variable_indices(i)),');']);
         string=[string ,'''',f.variable_list{i},'''',','];
      end
      %remove last comma
      string=string(1:end-1);
      
      %save the *.mat file
      eval(['save(''',[path file],''',',string,')']);
      
      close(gcf);
      einf.filename=file;
      einf.path=path;
      msgbox(['File has been saved as: ',file])
      
   end %switch option
   
end %if nargin>0   

%Revision history
%12/17/99: vhj adapted to work with engmodel
% 2/7/01: ss updated case 'modify name' to make it work with R12 (cell array assignment) and
%          under case 'get file' removed the '+' from 'rt+' (not necessary to write to the file)
%03/14/01: vhj center on screen
