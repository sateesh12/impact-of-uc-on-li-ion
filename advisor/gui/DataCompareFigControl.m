function DataCompareFigControl(option)

global data
evalin('base','global data')

if nargin==0
   option='openfig';
end


switch option
case 'openfig'
   DataCompareFig;
   
   vars_list=gui_get_vars('time');
   time_ind=strmatch('t',vars_list,'exact');
   if ~isempty(time_ind)
      value=time_ind;
   else
      value=1;
   end
   
   set(findobj('tag','simulation time'),'string',vars_list,'value',value)
   set(findobj('tag','simulation variable'),'string',vars_list)
   
   h0=gcf;
   %center the figure on the screen
   set(h0,'units','pixels');
   position=get(h0,'position');
   screensize=get(0,'screensize');
   set(h0,'position', [(screensize(3)-position(3))/2  (screensize(4)-position(4))/2 ...
         position(3) position(4)])

   
case 'openfile'
   
   old_dir=pwd;
   %change to desired directory
   cd(strrep(which('advisor.m'),'advisor.m', 'extras\Sample compare data'))
   
   [f,p]=uigetfile('*.*');                                                                                                   
   
   cd(old_dir)
   
   if f==0;
      return;
   end                                                                                                 
   
   set(findobj('tag','compare file name'),'string',f)
   
   fid=fopen([p,f],'rt');                                                                                             
   rem=fgetl(fid); %gets the first line (headers)                                                                                                    
   i=1;                                                                                                               
   
   clear global data
   global data
   
   %clear old headers
   data.headers={};
   %get headers in data.headers from 1st line only
   while ~isempty(rem)                                                                                                
      [data.headers{i},rem]=strtok(rem);       
      i=i+1;
   end
   
   set(findobj('tag','test variable'),'string',data.headers,'value',1);
   set(findobj('tag','test time'),'string',data.headers,'value',1);
   
   
   m=length(data.headers);
   %get the data in data.data in columns corresponding to headers.
   data.data=fscanf(fid,'%f',[m,inf])';   
   
   fclose(fid);
   
case 'openmatfile'
   
    old_dir=pwd;
    %change to desired directory
    cd(strrep(which('advisor.m'),'advisor.m', 'extras\Sample compare data'))
    
    [f,p]=uigetfile('*.mat');                                                                                                   
    
    cd(old_dir)
    
    clear old_dir
    
    if f==0;
        return;
    end                                                                                                 
   
   set(findobj('tag','compare file name'),'string',f)
   
   load([p,f])
   
   clear p f option
   clear global data
   %important to only have the variables wanted in the next command 
   
   vars=who;
   
   global data
   
   data.headers=vars;
   
   set(findobj('tag','test variable'),'string',data.headers,'value',1);
   set(findobj('tag','test time'),'string',data.headers,'value',1);
   
   m=length(data.headers);
   %get the data in data.data in columns corresponding to headers.
   for i=1:m
      data.data(:,i)=eval(data.headers{i});
   end
  
case 'save2mat'
   
    old_dir=pwd;
    %change to desired directory
    cd(strrep(which('advisor.m'),'advisor.m', 'extras\Sample compare data'))

   %save to .mat file
   [f,p]=uiputfile('*.mat','save mat file?');
     
   cd(old_dir)
    
   if f==0
      return
   end
   
   %save data to *.mat file
   for i=1:length(data.headers)
      eval([data.headers{i},'=data.data(:,' num2str(i) ');'])
   end
   
   vars=['''' data.headers{1} ''''];
   for i=2:length(data.headers)
   	vars=[vars ',''' data.headers{i} ''''];
   end
   eval(['save(''' [p,f] ''',' vars ')'])
   
   
case 'plot'
   
   figure;                                                                                                                                                                                             
   
   test_var_index=get(findobj('tag','test variable'),'value');                                                                                                                                                              
   test_time_index=get(findobj('tag','test time'),'value');                                                                                                                                                     
   test_conversion=get(findobj('tag','test conversion'),'string');                                                                                                                                         
   
   sim_var_str=gui_current_str('simulation variable');                                                                                                                                                        
   sim_time_str=gui_current_str('simulation time');                                                                                                                                               
   sim_conversion=get(findobj('tag','simulation conversion'),'string');                                                                                                                                   
   
   test_time=data.data(:,test_time_index);
   test_var=eval(['data.data(:,' num2str(test_var_index) ')*' test_conversion]);
   
   sim_time=evalin('base',sim_time_str);
   sim_var=evalin('base',[sim_var_str '*' sim_conversion]);
   
   subplot(2,1,1)
   plot(test_time,test_var,sim_time,sim_var);
   xlabel('time (sec)');                                                                                                                                                                               
   
   test_legend=['data: ' data.headers{test_var_index} '*' test_conversion];
   sim_legend=['sim: ' sim_var_str '*' sim_conversion];
   legend(strrep(test_legend,'_','\_'),strrep(sim_legend,'_','\_'));                                                                                          
   title(get(findobj('tag','title for plot'),'string'))                                                          
   
   subplot(2,1,2)
   difference=interp1(test_time,test_var,sim_time)-sim_var;
   plot(sim_time,difference)
   %title('difference: (test - sim)')
   %xlabel('time (sec)')
   temp1=difference./sim_var;
   temp2 = ~isnan(temp1)+~isinf(temp1);
   indices=find(temp2>1);
   temp=temp1(indices);
   
   max_difference=round(10*max(abs(temp))*100)/10;
   
   avg_difference=round(10*mean(temp)*100)/10;
   
   
   legend('diff. (test-sim)',['max %diff=' num2str(max_difference)],['avg %diff=' num2str(avg_difference)])
   
   %xlim=get(gca,'xlim');
   %ylim=get(gca,'ylim');
   %x_pos=.6*(xlim(2)- xlim(1))+xlim(1);
   %y_pos1=.8*(ylim(2)-ylim(1))+ylim(1);
   %y_pos2=.9*(ylim(2)-ylim(1))+ylim(1)
   %text(x_pos,y_pos1,['max %diff=' num2str(max_difference)]);
   %text(x_pos,y_pos2,['avg %diff=' num2str(avg_difference)]);
   
   
   
case 'create cycle file from data'
   
   old_dir=pwd;
   %change to desired directory
   cd(strrep(which('advisor.m'),'advisor.m', 'data\drive_cycle'))

   [f,p]=uiputfile('*.m', 'Save As');
   
   cd(old_dir)
   
   if f==0 
      return 
   end
   
   %make sure file does not end in .mat
   if strcmp(f(end-3:end),'.mat')
        f=strrep(f,'.mat','.m')
   end
    
   %make sure file ends in .m
   if ~strcmp(f(end-1:end),'.m')
       f=[f '.m'];
   end
      
   time=data.data(:,get(findobj('tag','test time'),'value'));
   speed=data.data(:,get(findobj('tag','test variable'),'value'));
   speed=eval(['speed*' get(findobj('tag','test conversion'),'string')]);
   cyc_mph=[time speed];
   
   
   save(strrep([p,f],'.m','.mat'),'cyc_mph');
   fid=fopen([p,f],'wt+');
   
   fprintf(fid,['%% ADVISOR data file:  ' f '\n']);
   fprintf(fid,['%%\n']);
   fprintf(fid,['%% Data source:\n']);
   fprintf(fid,['%% Automatically generated from DataCompareFigControl.m\n']);
   fprintf(fid,['%%\n']);
   fprintf(fid,['%% Data confirmation:\n']);
   fprintf(fid,['%% \n']);
   fprintf(fid,['%% Notes:\n']);
   fprintf(fid,['%% \n']);
   fprintf(fid,['%% \n']);
   fprintf(fid,['%% Created on: ',date '\n']);
   fprintf(fid,['%% By:  DataCompareFigControl.m \n']);
   fprintf(fid,['%%\n']);
   fprintf(fid,['%% Revision history at end of file.\n']);
   fprintf(fid,['%%%%\n']);

   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% FILE ID INFO\n']);
   fprintf(fid,['%%%%\n']);
   fprintf(fid,['cyc_description=''automatically generated '';\n']);
   fprintf(fid,['cyc_version=3.1; %% version of ADVISOR for which the file was generated\n']);
   fprintf(fid,['cyc_proprietary=0; %% 0=> non-proprietary, 1=> proprietary, do not distribute\n']);
   fprintf(fid,['cyc_validation=0; %% 0=> no validation, 1=> data agrees with source data, \n']);
   fprintf(fid,['%% 2=> data matches source data and data collection methods have been verified\n']);
   fprintf(fid,['disp([''Data loaded: ' strrep(f,'.m','') '-'' ,cyc_description])\n']);


   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% SPEED AND KEY POSITION vs. time\n']);
   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% load variable ''cyc_mph'', 2 column matrix with time in the first column\n']);
   fprintf(fid,['load ' strrep(f,'.m','.mat') '\n']);
   fprintf(fid,['%% keep key in ''on'' position throughout cycle (''1'' in the 2nd column => ''on'')\n']);
   fprintf(fid,['vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];\n']);


   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% OTHER DATA		\n']);
   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% Size of ''window'' used to filter the trace with centered-in-time averaging;\n']);
   fprintf(fid,['%% higher numbers mean more smoothing and less rigorous following of the trace.\n']);
   fprintf(fid,['%% Used when cyc_filter_bool=1\n']);
   fprintf(fid,['cyc_avg_time=3;  %% (s)\n']);
   fprintf(fid,['cyc_filter_bool=0;	%% 0=> no filtering, follow trace exactly; 1=> smooth trace\n']);
   fprintf(fid,['cyc_grade=0;	%%(decimal, ex. 0.01 would be used if a 1%% grade is wanted)\n']);
   fprintf(fid,['%%if a constant grade is wanted then cyc_grade can be set to that grade\n']);
   fprintf(fid,['%%if a variable grade is desired then cyc_grade has to contain distance and grade info.\n']);
   fprintf(fid,['%%the first column of cyc_grade would be the distance in meters and the second column would\n']);
   fprintf(fid,['%%be the grade at that distance.\n']);
   fprintf(fid,['cyc_elevation_init=0; %%the initial elevation in meters.\n']);

   fprintf(fid,['if size(cyc_grade,1)<2\n']);
   fprintf(fid,['   %% convert cyc_grade to a two column matrix, grade vs. dist\n']);
   fprintf(fid,['   cyc_grade=[0 cyc_grade; 1 cyc_grade]; %% use this for a constant roadway grade\n']);
   fprintf(fid,['end\n']);
   
   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% REVISION HISTORY\n']);
   fprintf(fid,['%%%%\n']);
   fprintf(fid,['%% ' date ': automatically created from DataCompareFigControl\n']);
   
   fclose(fid);
   
   
   
end; %switch option


%Revision History
%8/10/00 ss: centered the figure on the screen based on current screen resolution.
% 8/14/00 ss: added setting the value of the test variable popupmenus to 1 after loading a file.
% 2/9/01 ss: changed version to 3.1
% 2/9/01 kw: added separator (,) to separate elements of  a matrix
% 2/9/01 ss: made sure cyc  file is saved with a .m extension
