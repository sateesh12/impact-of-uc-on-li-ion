function gui_save_input(name,varargin)

global vinf

if exist('name')
    f=[name,'_in.m'];
    p=[cd,'\'];
    %p=strrep(which([name,'_in.m']),[name,'_in.m'],'');
else
    old_dir=pwd;
    new_dir=strrep(which('advisor.m'),'advisor.m','saved_vehicles\');
    cd(new_dir)
    
    [f,p] = uiputfile('*_in.m','ADVISOR Input File Save as *.m');
    
    cd(old_dir)
    
    if f==0 %user did not select a file name
        return
    end
end

%make sure file does not contain -,+,!,~,&
if ~isempty(findstr('-',f))|~isempty(findstr('+',f))|~isempty(findstr('!',f))|...
        ~isempty(findstr('~',f))|~isempty(findstr('&',f))|~isempty(findstr(';',f))|...
        ~isempty(findstr('''',f))|~isempty(findstr(' ',f))
    WARNDLG({'invalid filename';'illegal characters - , + , ! , ~ , & , ; ,'',space'})
    return
end

%make sure file does not start with a number, make sure i&j are ok though (imaginary by default).
if ~isempty(str2num(f(1)))
    if ~(strcmp(f(1),'j')|strcmp(f(1),'i')) %i and j are ok.
        WARNDLG({'invalid filename';'first character cannot be a number'})
        return;
    end
end

%make sure file ends in '_in.m'
temp=length(f);

if temp>5
    if ~strcmp(f(temp-4:temp),'_in.m')
        index=temp+1; %initialize the place where the _in.m will be added
        %match the letters from the end towards the beginning, when there is a mismatch
        %that is where the additional characters will be added.
        if strcmp(f(temp-1:temp),'.m')
            index=index-2;
        elseif strcmp(f(temp-2:temp),'_in')
            index=index-3;
        end
        
        f=[f(1:index-1),'_in.m'];
        
        %clear problem with extra '.' in the name
        if length(findstr(f,'.'))>1
            WARNDLG({['invalid filename:  ',f];'contains more than 1 '' . '''})
            return;
        end
        
        errordlg(['input file name will be: ',f],' ');
        uiwait(gcf);
    end
else
    if ~isempty(findstr(f,'.m'))
        f=[f(1:length(f)-2),'_in.m'];
    elseif ~isempty(findstr(f,'_in'))
        index2=findstr(f,'_in');
        f=[f(1:index2-1), '_in.m'];
    else
        f=[f,'_in.m'];
    end
    
    %clear problem with extra '.' in the name
    if length(findstr(f,'.'))>1
        WARNDLG({['invalid filename:  ',f];'contains more than 1 '' . '''})
        return;
    end
    
    errordlg(['input file name will be: ',f],' ');
    uiwait(gcf);
    
end

%do not overwrite *defaults_in.m
temp=which(f); %see if it exists first otherwise user can create a defualts file
if ~isempty(findstr(f,'defaults_in'))&~isempty(temp)
    errordlg('cannot overwrite *defaults_in.m.  Do it manually!');
    uiwait(gcf);
    return;
end

% special case:  If using DIRECT, modify workspace with DIRECT optimal settings
if nargin>=1
    directVarInd=strmatch('updateWSWithDirect',varargin{1:2:end});
    if ~isempty(directVarInd)
        optResults=varargin{directVarInd+1};
        input.modify.param=optResults.dv;%varargin{1}; % parameter names are stored in the first optional argument
        input.modify.value=num2cell(optResults.x_k);%num2cell(x); % assign corresponding values
        %   Assign in base if it doesn't exist, otherwise modify doesn't work
        for modVarInd=1:length(input.modify.param)
            assignin('base',input.modify.param{modVarInd},input.modify.value{modVarInd});
        end
        [error,resp]=adv_no_gui('modify',input);
    end
end


%open file and write information
fullname=[p,f];
fid = fopen(fullname,'wt');

fprintf(fid,['%% ',f, '  ',advisor_ver('info'),' input file created: ',datestr(now,0),'\n\n']);

fprintf(fid,'global vinf \n\n');

comp=optionlist('get','component_titles');

fwithoutmext=strrep(f,'.m','');
vinf.name=fwithoutmext;
fprintf(fid,['vinf.name=''',fwithoutmext,''';\n']);

eval('vinf.block_diagram.name; test4exist=1;','test4exist=0;')
if test4exist
    fprintf(fid,['vinf.block_diagram.name=''',vinf.block_diagram.name,''';\n']);
end

for x=1:length(comp)
    if isfield(vinf,comp{x})
        string=eval(['vinf.',comp{x},'.name']);
        fprintf(fid,['vinf.',comp{x,1},'.name=''',string,''';\n']);
        if isfield(eval(['vinf.',comp{x}]),'ver')
            fprintf(fid,['vinf.',comp{x},'.ver=''', eval(['vinf.',comp{x},'.ver']),''';\n']);
            if isfield(eval(['vinf.',comp{x}]),'type')
                fprintf(fid,['vinf.',comp{x},'.type=''', eval(['vinf.',comp{x},'.type']),''';\n']);
            end
        end
    end   
end

%add saber info up to 3 fields deep
% if isfield(vinf,'saber_cosim') & isfield(vinf.saber_cosim,'run') 
%     saber_vars=struct2cell(vinf.saber_cosim);
%     FirstFieldNames=fieldnames(vinf.saber_cosim);
%     for i=1:length(saber_vars)
%         if isstruct(saber_vars{i})
%             saber_fd2_vars=struct2cell(saber_vars{i});
%             SecondFieldNames=fieldnames(eval(['vinf.saber_cosim.',FirstFieldNames{i}]));
%             for j=1:length(saber_fd2_vars)
%                 if isstruct(saber_fd2_vars{j})
%                     saber_fd3_vars=struct2cell(saber_fd2_vars{j});
%                     ThirdFieldNames=fieldnames(eval(['vinf.saber_cosim.',FirstFieldNames{i},'.',SecondFieldNames{j}]));
%                     for k=1:length(saber_fd3_vars)
%                         if isnumeric(saber_fd3_vars)
%                             fprintf(fid,['vinf.saber_cosim.',saber_vars{i},'.',saber_fd2_vars{j},'=[',num2str(saber_fd3_vars{k}),'];\n']);
%                         else
%                             PrintText=['vinf.saber_cosim.',saber_vars{i},'.',saber_fd2_vars{j},'=''',saber_fd3_vars{k},''';'];
%                             PrintText=strrep(PrintText,'\','\\');
%                             PrintText=strrep(PrintText,'%','%%');
%                             fprintf(fid,([PrintText,'\n']));
%                         end
%                     end
%                 elseif isnumeric(saber_fd2_vars{j})
%                     fprintf(fid,['vinf.saber_cosim.',FirstFieldNames{i},'.',SecondFieldNames{j},'=[',num2str(saber_fd2_vars{j}),'];\n']);
%                 else
%                     PrintText=['vinf.saber_cosim.',FirstFieldNames{i},'.',SecondFieldNames{j},'=''',saber_fd2_vars{j},''';'];
%                     PrintText=strrep(PrintText,'\','\\');
%                     PrintText=strrep(PrintText,'%','%%');
%                     fprintf(fid,([PrintText,'\n']));
%                 end
%             end
%         elseif isnumeric(saber_vars{i})
%             fprintf(fid,['vinf.saber_cosim.',FirstFieldNames{i},'=[',num2str(saber_vars{i}),'];\n']);
%         else
%             PrintText=['vinf.saber_cosim.',FirstFieldNames{i},'=''',saber_vars{i},''';'];
%             PrintText=strrep(PrintText,'\','\\');
%             PrintText=strrep(PrintText,'%','%%');
%             fprintf(fid,([PrintText,'\n']));
%         end
%     end
% end

%check to see if there are any modified variables, and if so then write them to the file
eval('vinf.variables; test4exist=1;','test4exist=0;');%this is sort of an 'exist' statement for structures
if test4exist
    for i=1:max(size(vinf.variables.name))
        fprintf(fid,['vinf.variables.name{',num2str(i),'}=''',vinf.variables.name{i},''';\n']);
        fprintf(fid,['vinf.variables.value(',num2str(i),')=',num2str(vinf.variables.value(i)),';\n']);
        fprintf(fid,['vinf.variables.default(',num2str(i),')=',num2str(vinf.variables.default(i)),';\n']);
    end
end

%   Add any other modifications to run files
eval('vinf.RunFileMods;test4exist=1;','test4exist=0;');
if test4exist
    for i=1:length(vinf.RunFileMods(:,1))
        ParamValue=strrep(vinf.RunFileMods{i,2},'''','''''');
        if isempty(str2num(ParamValue))
            ParamValue=['''',ParamValue,''''];
        end
        fprintf(fid,['vinf.RunFileMods{',num2str(i),',1}=''',vinf.RunFileMods{i,1},''';\n']);
        fprintf(fid,['vinf.RunFileMods{',num2str(i),',2}=',ParamValue,';\n']);
        fprintf(fid,['vinf.RunFileMods{',num2str(i),',3}=''',vinf.RunFileMods{i,3},''';\n']);
    end
end


fclose(fid);

string=optionlist('add','input_file_names',vinf.name);
value=optionlist('value','input_file_names',vinf.name);
set(findobj('tag','input_file_names'),'string',string,'value',value);

%revisions
%9/24/98-ss added vinf.name=fwithoutmext;
%12/15/98-ss added warning when user tries to save filename with -,+,~,!,&  in it.
%5/12/99-ss added warning when user tries to save filename with a number as first character.
%5/20/99-ss added all kinds of conditionals for name of filename to save.
% 12/28/99-ss made the version printed in the header to be dependent on advisor_ver('info'), before it was just ADVISOR 2.0
%1/3/99 -tm added vinf.block_diagram.name to the list
% 6/14/00 ss made sure file may start with i and j which are generally considered imaginary numbers.
% 7/10/00 ss: made it so it would open up the save dialogue within the 'saved_vehicles' directory.
% 7/11/00 ss: updated to use optionlist function to automatically add saved file to popupmenu for input file names
% 7/17/00 ss: replaced gui options with optionlist.
% 7/21/00 ss: updated name for version info to advisor_ver.
% 8/13/00 ss: changed the section that checks to see if it is a defaults file.  Added _in to defaults name. Changed
%           the SERIES_defualts to SERIES_defaults_in for the default folder to open the uiputfile window in.
% 8/13/00 ss: added back in the _in.m naming convention for input files.
% 8/15/00 ss: added space as an invalid character to save file with.
% 8/16/00:tm added conditional statement to use input name if provided and to prevent popup windows for gui-less operation
%