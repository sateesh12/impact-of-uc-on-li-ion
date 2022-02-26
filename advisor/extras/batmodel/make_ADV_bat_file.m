function make_ADV_bat_file(action,var_name)
% Make ADVISOR engine file

global binf MakeFile;
type='ess';
%Files and path for .mat files at different temperatures
files=strrep(MakeFile.data_files,'.mat','');
path=MakeFile.path;
%sort files in order of ascending temperatures
for i=1:length(files)
    eval(['load ''',path files{i},'''']);
    tmp(i)=binf.peukert.temperature;
end
[temperature, index]=sort(tmp);
for i=1:length(files)
    files{i}=strrep(MakeFile.data_files{index(i)},'.mat','');
end

if nargin==0
    
    figcolor=[.8 .8 1];
    dy=80;
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
    try,set(h1,'string',['ESS_PB',num2str(round(max(binf.peukert.ICresid(:,2)))),'.m']);
    catch,set(h1,'string',['ESS_PB',num2str(round(max(binf.peukert.IC(:,2)))),'.m']);end
    
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
    notes={'File created by batmodel using mat files: '};
    for i=1:length(files)
        notes=cellstr(strvcat(char(notes),char([' ' files{i}])));
    end
    for i=1:length(files)
        eval(['load ''',path files{i},'''']);
        notes=cellstr(strvcat(char(notes),char([' '])));
        notes=cellstr(strvcat(char(notes),char(['File notes for ' files{i}])));
        vars1={'peukert','VOC','Rint'};
        for j=1:length(vars1)
            vars2={'batname','batnum','testdate','testdescription','testscript','percentage_error'};
            if j==3, vars2={'batname','batnum','testdate','testdescription','testscript'};end
            for k=1:length(vars2)
                if k==6	%num2str for percentage_error
                    eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' num2str(binf.',vars1{j},'.',vars2{k},')])));']);
                else
                    eval(['notes=cellstr(strvcat(char(notes),char(['' ',vars1{j},'.',vars2{k},': '' binf.',vars1{j},'.',vars2{k},'])));']);
                end
            end
        end
    end
    set(h1,'string',notes);
    
    %File info
    var_input={'Created by:',[type '_description'],[type '_version'],...
            [type '_proprietary'],[type '_validation'],['num_cells_per_mod']};
    init_str={'your name, email','X Ah Lead Acid battery','3.0','(0=nonprop,1=prop)',...
            '(0=no valid,1=data agrees w/ source,2=1+data collection methods verified)','6'};
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
            'Callback',['make_ADV_bat_file(''edit'',''',var_input{i},''')'],...
            'HorizontalAlignment','left', ...
            'Position',[189+dx_input*mod(i-1,2)*(i>2) 434+dy+(i-1)*dy_input*(i<3)+(dy_input+floor((i)/2)*dy_input-dy_input*mod(i-1,2))*(i>2) big_dx*(i<3)+145*(i>=3) 22], ...
            'String',init_str{i}, ...
            'Style','edit', ...
            'Tag',var_input{i});
        make_ADV_bat_file('edit',var_input{i})
    end
    
    
    %Load defaults?
    h1 = uicontrol('Parent',h0, ...
        'Callback','make_ADV_bat_file(''PbA defaults'')',...
        'Position',[87+dx 225+dy 130 24], ...
        'String','Load Default Lead Acid?', ...
        'Value',0);
    %h1 = uicontrol('Parent',h0, ...
    %   'Callback','make_ADV_bat_file(''NiMH defaults'')',...
    %   'Position',[237+dx 225+dy 130 24], ...
    %   'String','Load Default NiMH?', ...
    %   'Value',0);
    %h1 = uicontrol('Parent',h0, ...
    %   'Callback','make_ADV_bat_file(''LI defaults'')',...
    %   'Position',[387+dx 225+dy 130 24], ...
    %   'String','Load Default Li-Ion?', ...
    %   'Value',0);
    
    var_input={[type '_module_mass (kg)'],[type '_min_volts'],[type '_max_volts'],[type '_module_num'],...
            [type '_mod_cp (J/kgK)'],[type '_set_tmp (C)'],[type '_mod_sarea (m^2)'],...
            [type '_mod_airflow (kg/s)'],[type '_mod_flow_area (m^2)'],[type '_mod_case_thk (m)'],...
            [type '_mod_case_th_cond (W/mK)']};
    init_str={'1','9.5','16.5','25',...
            '660','35','0.2',...
            '.07/12','.004','.002',...
            '.20'};
    for i=1:length(files)
        eval(['load ''',path files{i},'''']);
        var_input=cellstr(strvcat(char(var_input),char([type '_coulombic_eff ' num2str(round(binf.peukert.temperature)),'C'])));
        init_str=cellstr(strvcat(char(init_str),char('.9')));
    end
    dy_input=-30;
    dx_input=300;
    %create the names and edit boxes
    for i=1:length(var_input)
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',figcolor, ...
            'HorizontalAlignment','left', ...
            'Position',[87+dx+dx_input*mod(i-1,2) 184+dy+(floor((i)/2)*dy_input-dy_input*mod(i-1,2)) 160 17],...
            'String',var_input{i}, ...
            'Style','text');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[1 1 1], ...
            'Callback',['make_ADV_bat_file(''edit'',''',var_input{i},''')'],...
            'HorizontalAlignment','left', ...
            'Position',[214+dx_input*mod(i-1,2) 184+dy+(floor((i)/2)*dy_input-dy_input*mod(i-1,2)) 110 22], ...
            'String',init_str{i}, ...
            'Style','edit', ...
            'Tag',var_input{i});
        make_ADV_bat_file('edit',var_input{i})
    end
    
    %Help
    h1 = uicontrol('Parent',h0, ...
        'Callback','load_in_browser(''ess_therm.html'');',...
        'Position',[430 10 80 24], ...
        'String','Help (thermal)', ...
        'Tag','load default box', ...
        'Value',0);
    %Make file
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 0.5 0.25], ...
        'Callback','make_ADV_bat_file(''make file'')', ...
        'Position',[520 10 110 24], ...
        'String','Make ADVISOR File');
    
    % Set figure to normalized for proper resizing
    h=findobj('type','uicontrol');
    g=findobj('type','axes');
    set([h; g],'units','normalized')
    set(gcf,'visible','on');
    
end

if nargin>0
    switch action
    case 'edit'
        %disp('entering edit case')
        str_name=get(findobj('tag',var_name),'string');
        %find index where there's a space
        for i=1:length(var_name)
            if strcmp(var_name(i),' ')
                i=i-1;
                break
            end
        end
        var_name=var_name(1:i);
        %disp('after renaming var')
        evalin('base',[var_name,'=''',str_name,''';'])
    case 'PbA defaults'
        var_input={[type '_module_mass (kg)'],[type '_min_volts'],[type '_max_volts'],[type '_module_num'],...
                [type '_mod_cp (J/kgK)'],[type '_set_tmp (C)'],[type '_mod_sarea (m^2)'],...
                [type '_mod_airflow (kg/s)'],[type '_mod_flow_area (m^2)'],[type '_mod_case_thk (m)'],...
                [type '_mod_case_th_cond (W/mK)']};
        default_str={'1','9.5','16.5','25',...
                '660','35','0.2',...
                '.07/12','.004','.002',...
                '.20'};
        
        for i=1:length(var_input)
            set(findobj('tag',var_input{i}),'string',default_str{i});
        end
        
    case 'make file'
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %Save
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        filename=get(findobj('tag','file name'),'string');
        template='ESS_template.m';
        
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
            vars1={'peukert','VOC','Rint'};
            for j=1:length(vars1)
                vars2={'batname','batnum','testdate','testdescription','testscript','percentage_error'};
                if j==3, vars2={'batname','batnum','testdate','testdescription','testscript'};end
                for k=1:length(vars2)
                    if k==6	%num2str for percentage_error
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
        %Replace all params input by user
        var_input={'Created by:',[type '_description'],[type '_version'],...
                [type '_proprietary'],[type '_validation'],['num_cells_per_mod'],...
                [type '_module_mass (kg)'],[type '_min_volts'],[type '_max_volts'],[type '_module_num'],...
                [type '_mod_cp (J/kgK)'],[type '_set_tmp (C)'],[type '_mod_sarea (m^2)'],...
                [type '_mod_airflow (kg/s)'],[type '_mod_flow_area (m^2)'],[type '_mod_case_thk (m)'],...
                [type '_mod_case_th_cond (W/mK)']};
        
        for i=1:length(var_input)
            var_name=var_input{i};
            for j=1:length(var_name)
                if strcmp(var_name(j),' ') %find space
                    j=j-1;
                    break
                end
            end
            var_name=var_name(1:j);	%eliminate units after space
            temp=strrep(var_name,type,''); %eliminate type (e.g. fc, ess)
            entstr=strrep(entstr,['template',temp],get(findobj('tag',var_input{i}),'string'));
        end
        
        
        %Maps
        %Preprocessing involves loading various files
        eval(['load ''',path files{1},'''']);
        ess_soc=binf.VOC.ess_soc;
        for i=1:length(files)
            eval(['load ''',path files{i},'''']);
            ess_tmp(i)=round(binf.peukert.temperature);	%temperature
            %max capacity either max of initial C, or max of residual tests
            try, ess_max_ah_cap(i)=max(binf.peukert.ICresid(:,2))
            catch, ess_max_ah_cap(i)=max(binf.peukert.IC(:,2))	%max capacity
            end
            %coulombic efficiency
            ess_coulombic_eff(i)=str2num(get(findobj('tag',[type '_coulombic_eff ' num2str(ess_tmp(i)),'C']),'string'));
            %Discharge resistance
            ess_r_dis(i,:)=binf.Rint.ess_r_dis;
            %Charge resistance
            ess_r_chg(i,:)=binf.Rint.ess_r_chg;
            %open circuit voltage
            ess_voc(i,:)=binf.VOC.ess_voc;
        end
        %if only one file, duplicate values
        if length(files)==1
            ess_tmp(2)=ess_tmp(1)*1.01;	%temperature
            ess_max_ah_cap(2)=ess_max_ah_cap(1);	%max capacity
            %coulombic efficiency
            ess_coulombic_eff(2)=ess_coulombic_eff(1);
            %Discharge resistance
            ess_r_dis(2,:)=ess_r_dis(1,:);
            %Charge resistance
            ess_r_chg(2,:)=ess_r_chg(1,:);
            %open circuit voltage
            ess_voc(2,:)=ess_voc(1,:);
        end
        
        entstr=strrep(entstr,'template_soc',mat2str(ess_soc,4));
        entstr=strrep(entstr,'template_tmp',mat2str(ess_tmp,4));
        entstr=strrep(entstr,'template_max_ah_cap',mat2str(ess_max_ah_cap,4));
        entstr=strrep(entstr,'template_r_dis',mat2str(ess_r_dis,4));
        entstr=strrep(entstr,'template_r_chg',mat2str(ess_r_chg,4));
        entstr=strrep(entstr,'template_voc',mat2str(ess_voc,4));
        %Coulombic efficiency (user input for now)
        entstr=strrep(entstr,'template_coulombic_eff',mat2str(ess_coulombic_eff,4));
        
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
%12/27/99: vhj file created from make_ADV_eng_file
%01/18/01: vhj updated version #, updated loading of files to allow spaces in directories, 
%           added help button, grab ICresid capacity if available (wasn't working right)
%03/13/01: vhj if only 1 temperature, second temp is 1% above