function make_ADV_RC_bat_file(action,var_name)
% Make ADVISOR engine file

global binf MakeFile;
type='ess';
%Files and path for .mat files at different temperatures
files=strrep(MakeFile.data_files,'.mat','');
path=MakeFile.path;
%sort files in order of ascending temperatures
for i=1:length(files)
    eval(['load ''',path files{i},'''']);
    tmp(i)=binf.RC.temperature;
end
[temperature, index]=sort(tmp);
for i=1:length(files)
    files{i}=strrep(MakeFile.data_files{index(i)},'.mat','');
end

if nargin==0
    
    figcolor=[.8 .8 1];
    dy=-250;
    dx=-37;
    big_dx=325;
    
    %figure
    h0 = figure('Color',figcolor, ...
        'Name','ADVISOR battery file generation', ...
        'NumberTitle','off', ...
        'PaperPosition',[18 30 576 432], ...
        'PaperUnits','points', ...
        'Position',[506+dx 100 652 631+dy], ...
        'ToolBar','none',...
        'Visible','off');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figcolor, ...
        'FontSize',14, ...
        'FontWeight','bold', ...
        'Position',[40+dx 597+dy 342 25], ...
        'String','ADVISOR battery file information', ...
        'Style','text');
    
    %Name of file
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figcolor, ...
        'HorizontalAlignment','left', ...
        'Position',[87+dx 569+dy 125 17], ...
        'String','Name of file to create', ...
        'Style','text');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'Position',[189 569+dy big_dx 22], ...
        'String','ESS_', ...
        'Style','edit', ...
        'Tag','file name');
    eval(['load ''',path files{1},''';global binf;']);
    set(h1,'string',['ESS_PB',num2str(round(max(binf.RC.ratedAh))),'_rc.m']);
    
    %Gen'l file info
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',figcolor, ...
        'HorizontalAlignment','left', ...
        'Position',[87+dx 539+dy 94 17], ...
        'String','General File Info', ...
        'Style','text');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'Position',[189 465+dy big_dx 94], ...
        'String',' ', ...
        'Style','listbox', ...
        'Tag','Listbox1', ...
        'Value',1);
    %Notes
    notes=['File created by batmodel using mat files: '];
    for i=1:length(files)
        notes=cellstr(strvcat(char(notes),char([' ' files{i}])));
    end
    for i=1:length(files)
        eval(['load ''',path files{i},'''']);
        notes=cellstr(strvcat(char(notes),char([' '])));
        notes=cellstr(strvcat(char(notes),char(['File notes for ' files{i}])));
        vars1={'VOC','RC'};
        for j=1:length(vars1)
            if strcmp(vars1{j},'VOC')
                vars2={'batname','batnum','testdate','testdescription','testscript','percentage_error'};
            elseif strcmp(vars1{j},'RC'), 
                vars2={'batname','batnum','testdate','testdescription','testscript','AvgPerror','MaxPerror'};
            end
            for k=1:length(vars2)
                if k==6	| k==7 %num2str for percentage_errors
                    %eval(['notes=[notes,'';%   ',vars1{j},'.',vars2{k},': '' num2str(binf.',vars1{j},'.',vars2{k},')];']);
                    eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' num2str(binf.',vars1{j},'.',vars2{k},')])));']);
                else
                    %eval(['notes=[notes,'';%   ',vars1{j},'.',vars2{k},': '' binf.',vars1{j},'.',vars2{k},'];']);
                    eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' binf.',vars1{j},'.',vars2{k},'])));']);
                end
            end
        end
    end
    set(h1,'string',notes);
    
    %File info
    var_input={'Created by:',[type '_description'],[type '_version'],...
            [type '_proprietary'],[type '_validation']};
    init_str={'your name, email','X Ah Lead Acid battery','3.1','(0=nonprop,1=prop)',...
            '(0=no valid,1=data agrees w/ source,2=1+data collection methods verified)'};
    dy_input=-30;
    dx_input=300;
    %create the names and edit boxes
    for i=1:length(var_input)
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',figcolor, ...
            'HorizontalAlignment','left', ...
            'Position',[87+dx+dx_input*mod(i-1,2)*(i>2) 434+dy+(i-1)*dy_input*(i<3)+(dy_input+floor((i)/2)*dy_input-dy_input*mod(i-1,2))*(i>2) 110 17],...
            'String',var_input{i}, ...
            'Style','text');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[1 1 1], ...
            'Callback',['make_ADV_RC_bat_file(''edit'',''',var_input{i},''')'],...
            'HorizontalAlignment','left', ...
            'Position',[189+dx_input*mod(i-1,2)*(i>2) 434+dy+(i-1)*dy_input*(i<3)+(dy_input+floor((i)/2)*dy_input-dy_input*mod(i-1,2))*(i>2) big_dx*(i<3)+145*(i>=3) 22], ...
            'String',init_str{i}, ...
            'Style','edit', ...
            'Tag',var_input{i});
        %make_ADV_RC_bat_file('edit',var_input{i})
    end
    
    %Make file
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 0.5 0.25], ...
        'Callback','make_ADV_RC_bat_file(''make file'')', ...
        'Position',[520 10 110 24], ...
        'String','Make ADVISOR File');
    
    % Set figure to normalized for proper resizing
    %set everything normalized
    h=findobj('type','uicontrol');
    set([h],'units','normalized')
    %_______set the figure size and location
    screensize=get(0,'screensize'); %this should be in pixels(the default)
    figsize=[(screensize(3)-652)/2 (screensize(4)-(631+dy))/2 652 631+dy];
    set(gcf,'units','pixels','position',figsize,'visible','on');
    %_____________end set the figure size
end

if nargin>0
    switch action
    case 'edit'
        %disp('entering edit case')
        hvariable=findobj('tag',var_name);
        %find index where there's a space
        for i=1:length(var_name)
            if strcmp(var_name(i),' ')
                i=i-1;
                break
            end
        end
        var_name=var_name(1:i);

        %get the value from the edit menu and assign it in the workspace as a string
        str_name=get(hvariable,'string');
        evalin('base',[var_name,'=''',str_name,''';'])
        %disp('after renaming var')
        
    case 'make file'
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %Save
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        filename=get(findobj('tag','file name'),'string');
        template='ESS_RC_template.m';
        
        %open the template and new file
        fid=fopen(template,'r');
        fid_new=fopen(filename,'w');
        
        entstr=fscanf(fid,'%c'); %read in entire file to a string (%c reads spaces)
        %Replace name
        entstr=strrep(entstr,'template_name',filename);
        %Notes
        notes=['File created by batmodel using mat files: '];
        for i=1:length(files)
            tmp=[';% ' files{i}];
            notes=[notes,tmp];
        end
        for i=1:length(files)
            eval(['load ''',path files{i},'''']);
            notes=[notes,';% '];
            notes=[notes,';%  File notes for ' files{i}];
            vars1={'VOC','RC'};
            for j=1:length(vars1)
                if strcmp(vars1{j},'VOC')
                    vars2={'batname','batnum','testdate','testdescription','testscript','percentage_error'};
                elseif strcmp(vars1{j},'RC'), 
                    vars2={'batname','batnum','testdate','testdescription','testscript','AvgPerror','MaxPerror'};
                end
                for k=1:length(vars2)
                    if k==6	| k==7 %num2str for percentage_errors
                        eval(['notes=[notes,'';%   ',vars1{j},'.',vars2{k},': '' num2str(binf.',vars1{j},'.',vars2{k},')];']);
                        %eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' num2str(binf.',vars1{j},'.',vars2{k},')])));']);
                    else
                        eval(['notes=[notes,'';%   ',vars1{j},'.',vars2{k},': '' binf.',vars1{j},'.',vars2{k},'];']);
                        %eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' binf.',vars1{j},'.',vars2{k},'])));']);
                    end
                end
            end
        end
        entstr=strrep(entstr,'template_notes',notes);
        %Created by:
        entstr=strrep(entstr,'template_createdby',get(findobj('tag','Created by:'),'string'));
        %Date
        entstr=strrep(entstr,'template_date',datestr(now,0));
        %Replace all params input by user in this screen
        var_input={'Created by:',[type '_description'],[type '_version'],...
                [type '_proprietary'],[type '_validation']};
        for i=1:length(var_input)
            var_name=var_input{i};
            temp=strrep(var_name,type,''); %eliminate type (e.g. fc, ess)
            entstr=strrep(entstr,['template',temp],get(findobj('tag',var_input{i}),'string'));
        end

        %Replace all params input by user in earlier screen
        var_input={[type '_module_mass'],[type '_min_volts'],[type '_max_volts'],[type '_module_num'],...
                [type '_mod_cp'],[type '_set_tmp'],[type '_mod_sarea'],...
                [type '_mod_airflow'],[type '_mod_flow_area'],[type '_mod_case_thk'],...
                [type '_mod_case_th_cond']};
        
        for i=1:length(var_input)
            temp=strrep(var_input{i},type,''); %eliminate type (e.g. fc, ess)
            eval(['value_str=num2str(binf.RC.',var_input{i},');']);
            entstr=strrep(entstr,['template',temp],value_str);
        end
        
        
        %Maps
        %Preprocessing involves loading various files
        eval(['load ''',path files{1},'''']);
        ess_soc=binf.VOC.ess_soc/100;
        for i=1:length(files)
            eval(['load ''',path files{i},'''']);
            ess_tmp(i)=round(binf.RC.temperature);	%temperature
            %if the SOC eval pts were'nt the same, interp
            if i>1
                if length(binf.RC.ess_re)~=length(ess_re)
                    binf.RC.ess_re=interp1(binf.RC.ess_soc,binf.RC.ess_re,ess_soc);
                    binf.RC.ess_rc=interp1(binf.RC.ess_soc,binf.RC.ess_rc,ess_soc);
                    binf.RC.ess_rt=interp1(binf.RC.ess_soc,binf.RC.ess_rt,ess_soc);
                    binf.RC.ess_cb=interp1(binf.RC.ess_soc,binf.RC.ess_cb,ess_soc);
                    binf.RC.ess_cc=interp1(binf.RC.ess_soc,binf.RC.ess_cc,ess_soc);
                    binf.VOC.ess_voc=interp1(binf.VOC.ess_soc/100,binf.VOC.ess_voc,ess_soc);
                end
            end
            %Resistances
            ess_re(i,:)=binf.RC.ess_re;
            ess_rc(i,:)=binf.RC.ess_rc;
            ess_rt(i,:)=binf.RC.ess_rt;
            %Capacitances, take mean over SOC
            ess_cb(i)=mean(binf.RC.ess_cb);
            ess_cc(i)=mean(binf.RC.ess_cc);
            %open circuit voltage
            ess_voc(i,:)=binf.VOC.ess_voc;
        end
        %if only one file, duplicate values
        if length(files)==1
            ess_tmp(2)=ess_tmp(1)*1.01;	%temperature
            %Resistances
            ess_re(2,:)=ess_re(1,:);
            ess_rc(2,:)=ess_rc(1,:);
            ess_rt(2,:)=ess_rt(1,:);
            %Capacitances
            ess_cb(2)=ess_cb(1);
            ess_cc(2)=ess_cc(1);
            %open circuit voltage
            ess_voc(2,:)=ess_voc(1,:);
        end
        
        entstr=strrep(entstr,'template_soc',mat2str(ess_soc,4));
        entstr=strrep(entstr,'template_tmp',mat2str(ess_tmp,4));
        entstr=strrep(entstr,'template_re',mat2str(ess_re,4));
        entstr=strrep(entstr,'template_rc',mat2str(ess_rc,4));
        entstr=strrep(entstr,'template_rt',mat2str(ess_rt,4));
        entstr=strrep(entstr,'template_cb',mat2str(ess_cb,4));
        entstr=strrep(entstr,'template_cc',mat2str(ess_cc,4));
        entstr=strrep(entstr,'template_voc',mat2str(ess_voc,4));
        
        %Print to new file
        for i=1:length(entstr)-1
            if strcmp(entstr(i),';') & ~strcmp(entstr(i+1),' ')
                fprintf(fid_new,'%s',[entstr(i)]);
                fprintf(fid_new,'\n');
            else
                fprintf(fid_new,'%s',[entstr(i)]);
            end
        end
        
        %Close files
        fclose(fid);fclose(fid_new);
        close(gcf);
        helpdlg(['File saved as:',filename]);
        
    end
end


%Revision history
%03/13/01: vhj file created from make_ADV_bat_file
%03/16/01: vhj take mean of C's, if the SOC eval pts were'nt the same, interp1
%03/19/01: vhj added /100 for binf.VOC.ess_soc reference
%03/26/01: vhj/mz eliminate reference to peukert field