function compare_sims_setup(option,info)
% Compare different simulations

% Setup figure for comparing simulations
lblue=[.7 .9 1];
buttoncolor=[.75 .75 .75];
global vinf

if nargin==0
    % big window
    %center figure on screen
    figsize=[390 394];
    screensize=get(0,'screensize'); %this should be in pixels(the default)
    left=round(screensize(3)/2-figsize(1)/2);
    bottom=round(screensize(4)/2-figsize(2)/2);
    position=[left bottom figsize];
    
    h0 = figure('Color',lblue, ...
        'MenuBar','none', ...
        'Name','Compare Simulations', ...
        'NumberTitle','off', ...
        'PaperPosition',[18 180 576 432], ...
        'PaperUnits','points', ...
        'Position',position, ...
        'Visible','off',...
        'Tag','compare_setup_figure');
    
    %Title
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',lblue, ...
        'FontSize',14, ...
        'FontWeight','bold', ...
        'HorizontalAlignment','center', ...
        'Position',[29 356 325 25], ...
        'String','Select simulations to compare', ...
        'Style','text');
    
    %paths
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',lblue, ...
        'HorizontalAlignment','left', ...
        'Position',[21 324 122 16], ...
        'String','Path:', ...
        'Style','text');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'Callback','compare_sims_setup(''path name'')', ...
        'HorizontalAlignment','left', ...
        'Position',[17 302 276 20], ...
        'Style','edit', ...
        'Tag','pathname');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',buttoncolor, ...
        'Callback','compare_sims_setup(''browse'')', ...
        'Position',[301 302 70 25], ...
        'String','Browse');
    
    %Left side
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',lblue, ...
        'HorizontalAlignment','left', ...
        'Position',[52 270 98 19], ...
        'String','Available files:', ...
        'Style','text');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'Position',[21 56 147 215], ...
        'String',' ', ...
        'Style','listbox', ...
        'Tag','avail files', ...
        'Value',1);
    %Add/delete
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[.75 .75 .75], ...
        'Callback','compare_sims_setup(''add'')', ...
        'Position',[176 175 43 22], ...
        'String','Add-->');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[.75 .75 .75], ...
        'Callback','compare_sims_setup(''delete'')', ...
        'Position',[176 144 44 22], ...
        'String','Delete');
    %Right side
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',lblue, ...
        'HorizontalAlignment','left', ...
        'Position',[265 270 98 19], ...
        'String','Simulations:', ...
        'Style','text');
    h1 = uicontrol('Parent',h0, ...
        'BackgroundColor',[1 1 1], ...
        'Position',[228 56 147 215], ...
        'Style','listbox', ...
        'Tag','sims');
    try, set(h1,'string',vinf.comparesims.files),
    catch, vinf.comparesims.files='';set(h1,'string',vinf.comparesims.files);
    end
    
    %Help, Back, Run buttons
    h1 = uicontrol('Parent',h0, ...
        'Callback','load_in_browser(''compare_sims.html'');', ...
        'Position',[164 10 62 33], ...
        'String','Help');
    h1 = uicontrol('Parent',h0, ...
        'Callback','close(gcbf);ResultsFig', ...
        'Position',[240 10 62 33], ...
        'String','Back');
    h1 = uicontrol('Parent',h0, ...
        'Callback','compare_sims_setup(''continue'');', ...
        'Position',[317 10 62 33], ...
        'String','Continue');
    
    %   Dynamic compare option
    h1 = uicontrol('Parent',h0, ...
        'Callback','compare_sims_setup(''Dynamic Compare'');', ...
        'Position',[88 10 62 33], ...
        'Style','checkbox',...
        'Tag','DynamicCompare',...
        'BackgroundColor',lblue,...
        'String','Dynamic');
    
    if isfield(vinf.comparesims,'dynamic') & vinf.comparesims.dynamic==1;
        set(findobj('tag','DynamicCompare'),'value',1);
    else
        set(findobj('tag','DynamicCompare'),'value',0);
        vinf.comparesims.dynamic=0;
    end
    
    try,
        p=vinf.comparesims.filepath;
    catch
        p=[pwd '\'];
    end
    set(findobj('Tag','pathname'),'String',p);
    compare_sims_setup('display file names',p);
    
    %set everything normalized and set the figure size and center it
    h=findobj('type','uicontrol');
    g=findobj('type','axes');
    set([h; g],'units','normalized')
    set(gcf,'Visible','on');
    
end


if nargin>0
    switch option
    case 'path name'
        p=get(findobj('tag','pathname'),'string');
        compare_sims_setup('display file names',p);
    case 'browse'
        [f p]=uigetfile('*.mat','Pick Path Name');
        %if no file is selected(ie. figure is cancelled) then exit(or return)
        %out of this function
        if f==0
            return
        end
        set(findobj('Tag','pathname'),'String',p);
        compare_sims_setup('display file names',p);
        vinf.comparesims.filepath=p;
        
    case 'display file names'
        clear filenames;
        d=dir(info);
        j=1;
        for i=1:max(size(d))
            if ~(strcmp(d(i).name, '.') | strcmp(d(i).name, '..'))& ~d(i).isdir & strcmp(d(i).name(end-3:end), '.mat')
                filenames{j}=d(i).name;
                j=j+1;
            end
        end
        try,set(findobj('Tag','avail files'), 'string', filenames);
        catch,set(findobj('Tag','avail files'), 'string', 'No mat files in directory'); end
        
    case 'add'
        %get info from avail files side
        h1=findobj('tag','avail files');
        filenames=get(h1,'string');
        filenum=get(h1,'value');
        
        %get info from data files side
        h2=findobj('tag','sims');
        selected_sims=get(h2,'string');
        simnum=size(selected_sims);
        simnum=simnum(1);	%first return of size
        
        if simnum>=8
            errordlg('Maximum number of simulations is 8.');
            return
        else
            %add new filename to list
            if isempty(selected_sims);%if this is the first sim just replace the string
                selected_sims=filenames(filenum);
            elseif isempty(strmatch(filenames(filenum),selected_sims))
                % if this is not the first file, add it to the list (if not already there)
                selected_sims(max(size(selected_sims))+1)=filenames(filenum);
            end
            
            %reset the string in the data files
            set(h2,'string',selected_sims)
            compare_sims_setup('get vars');
        end
    case 'delete'
        global varnames
        %get information on file to delete
        h1=findobj('tag','sims');
        filenum=get(h1,'value');
        filenames=get(h1,'string');
        
        %if only one filename then delete the filename
        if length(filenames)==1
            filenames='';
            %if last filename then just shorten filenames by 1   
        elseif length(filenames)==filenum
            filenames=filenames(1:filenum-1);
            set(h1,'value',filenum-1);
            %if first filename, and more than just one filename then shift filenames by 1   
        elseif length(filenames)~=1 & filenum==1
            filenames=filenames(2:length(filenames));
            %for all other cases
        else
            filenames=filenames([1:filenum-1 filenum+1:max(size(filenames))]);
        end
        
        set(h1,'string',filenames)
        compare_sims_setup('get vars');
    case 'get vars'
        global vinf
        %set simulation list to vinf.comparesims
        h1=findobj('tag','sims');
        simnames=get(h1,'string');
        vinf.comparesims.files=simnames;
        vinf.comparesims.filepath=get(findobj('tag','pathname'),'string');
        
    case 'Dynamic Compare'
        vinf.comparesims.dynamic=get(findobj('tag','DynamicCompare'),'value');
        
    case 'continue'
        
        %   Check for correct number of files for dynamic or static compare
        if strcmp(vinf.comparesims.files,'')
            errordlg('You must specify at least one simulation file.')
            return
        elseif vinf.comparesims.dynamic
            close(gcbf);
            dynamicReplay(3,vinf.comparesims.files);
            compare_sims_setup;
            return;
        else
            close(gcbf);
        end
        
        path=vinf.comparesims.filepath;
        matname=strrep(vinf.comparesims.files,'.mat','');
        try
            %evalin('base',['clear all; load ',path matname{1}]); 
            %ss added following line and commented out previous line on 8/16/00 to return without clear all
            %          if load did not work.
            evalin('base',['load ''' path matname{1} ''';clear all; load ''' path matname{1},''';'])
        catch
            vinf.comparesims.filepath=path;
            vinf.comparesims.files=matname;
            compare_sims_setup;
            errordlg('Error loading files.  Check files and/or path.  All files must be in the same path.')
            return
        end
        global vinf;
        
        %Maximum number of characters a sim can be is 10 (max characters allowed by matlab=31, 
        %																	max existing var name=20, '_'=1 character)
        vinf.comparesims.files_used=matname;
        vinf.comparesims.adj_files=[];
        for i=1:length(matname)
            num=length(matname{i});	%number of characters for the given simulation
            if num>10
                eval(['vinf.comparesims.files_used{',num2str(i),'}=''Sim',num2str(i),''';']);	%rename to Sim#
                vinf.comparesims.adj_files=[vinf.comparesims.adj_files; i];
            end
        end
        matnameused=vinf.comparesims.files_used;
        files=vinf.comparesims.adj_files;
        
        %Variable lists for comparisons between simulations
        %Metric variables to be plotted on spider plot and on bar chart
        % 1/18/00:tm updated variable name references to correspond to new accel test
        %metric_vars={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
        %      'vinf.acceleration.time_0_60';'vinf.acceleration.time_0_85';...
        %      'vinf.acceleration.time_40_60';'vinf.acceleration.max_accel';...
        %      'vinf.acceleration.feet_5sec';'vinf.max_grade'};
        metric_vars={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
                'vinf.accel_test.results.times(1)';'vinf.accel_test.results.times(3)';...
                'vinf.accel_test.results.times(2)';'vinf.accel_test.results.max_rate';...
                'vinf.accel_test.results.dist';'vinf.grade_test.results.grade'};
        
        %metric_names={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
        %      'time_0_60';'time_0_85';'time_40_60';'max_accel';...
        %      'feet_5sec';'max_grade'};
        %metric_names_si={'lp100km';'lp100kmge';'hc_gpkm';'co_gpkm';'nox_gpkm';'pm_gpkm';...
        %      'time_0_97';'time_0_137';'time_64_97';'max_accel_si';...
        %      'meters_5sec';'max_grade'};
        if isfield(vinf,'accel_test')&strcmp(vinf.acceleration.run,'on')
            metric_names={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
                    ['time_',num2str(round(vinf.accel_test.param.spds1(1))),'_',num2str(round(vinf.accel_test.param.spds1(2)))];...
                    ['time_',num2str(round(vinf.accel_test.param.spds3(1))),'_',num2str(round(vinf.accel_test.param.spds3(2)))];...
                    ['time_',num2str(round(vinf.accel_test.param.spds2(1))),'_',num2str(round(vinf.accel_test.param.spds2(2)))];...
                    'max_accel';'feet_5sec';'max_grade'};
            metric_names_si={'lp100km';'lp100kmge';'hc_gpkm';'co_gpkm';'nox_gpkm';'pm_gpkm';...
                    ['time_',num2str(round(vinf.accel_test.param.spds1(1)*units('mph2kmph'))),'_',num2str(round(vinf.accel_test.param.spds1(2)*units('mph2kmph')))];...
                    ['time_',num2str(round(vinf.accel_test.param.spds3(1)*units('mph2kmph'))),'_',num2str(round(vinf.accel_test.param.spds3(2)*units('mph2kmph')))];...
                    ['time_',num2str(round(vinf.accel_test.param.spds2(1)*units('mph2kmph'))),'_',num2str(round(vinf.accel_test.param.spds2(2)*units('mph2kmph')))];...
                    'max_accel_si';'meters_5sec';'max_grade'};
        else
            metric_names={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
                    ['time_',num2str(0),'_',num2str(60)];...
                    ['time_',num2str(0),'_',num2str(85)];...
                    ['time_',num2str(40),'_',num2str(60)];...
                    'max_accel';'feet_5sec';'max_grade'};
            metric_names_si={'lp100km';'lp100kmge';'hc_gpkm';'co_gpkm';'nox_gpkm';'pm_gpkm';...
                    ['time_',num2str(round(0*units('mph2kmph'))),'_',num2str(round(60*units('mph2kmph')))];...
                    ['time_',num2str(round(0*units('mph2kmph'))),'_',num2str(round(85*units('mph2kmph')))];...
                    ['time_',num2str(round(40*units('mph2kmph'))),'_',num2str(round(60*units('mph2kmph')))];...
                    'max_accel_si';'meters_5sec';'max_grade'};
        end
        %Conversion factor from us units to si units (special case mpg, mpgge)
        us2si=[235.209 235.209 .62137 .62137 .62137 .62137,...
                1 1 1 .3048 .3048 1];
        
        %Time variable to be plotted vs. time for all chosen simulations
        t_vars=gui_get_vars('time');
        if isempty(t_vars) | strcmp(t_vars,'none')
            vinf.comparesims.filepath=path;
            vinf.comparesims.files=matname;
            compare_sims_setup;
            errordlg('Error loading files.  Check files and/or path.  All files must be in the same path.')
            return
        end
        
        %extra_vars are varaibles that have more than one output per variable name
        %remove original name from t_vars, then record new names
        extra_vars=''; extra_vars_names='';save_i=[];
        for i=2:length(t_vars)
            %disp(i)
            if strcmp(t_vars(i),'emis')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'emis(:,1)','emis(:,2)','emis(:,3)','emis(:,4)');
                extra_vars_names=strvcat(extra_vars_names,'emis_hc','emis_co','emis_nox','emis_pm');
            elseif strcmp(t_vars(i),'ex_tmp')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'ex_tmp(:,1)','ex_tmp(:,2)','ex_tmp(:,3)','ex_tmp(:,4)','ex_tmp(:,5)');
                extra_vars_names=strvcat(extra_vars_names,'ex_tmp_monolith','ex_tmp_cat_internal','ex_tmp_cat_inlet','ex_tmp_cat_shield','ex_tmp_manifold');
            elseif strcmp(t_vars(i),'ex_gas_tmp')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'ex_gas_tmp(:,1)','ex_gas_tmp(:,2)','ex_gas_tmp(:,3)');
                extra_vars_names=strvcat(extra_vars_names,'ex_gas_tmp_cat_out','ex_gas_tmp_cat_in','ex_gas_tmp_manif_out');
            elseif strcmp(t_vars(i),'fc_emis_eo')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'fc_emis_eo(:,1)','fc_emis_eo(:,2)','fc_emis_eo(:,3)','fc_emis_eo(:,4)');
                extra_vars_names=strvcat(extra_vars_names,'fc_emis_eo_hc','fc_emis_eo_co','fc_emis_eo_nox','fc_emis_eo_pm');
            elseif strcmp(t_vars(i),'ex_cat_eff')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'ex_cat_eff(:,1)','ex_cat_eff(:,2)','ex_cat_eff(:,3)','ex_cat_eff(:,4)');
                extra_vars_names=strvcat(extra_vars_names,'ex_cat_eff_hc','ex_cat_eff_co','ex_cat_eff_nox','ex_cat_eff_pm');
            elseif strcmp(t_vars(i),'emis_ppm')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'emis_ppm(:,1)','emis_ppm(:,2)','emis_ppm(:,3)','emis_ppm(:,4)');
                extra_vars_names=strvcat(extra_vars_names,'emis_ppm_hc','emis_ppm_co','emis_ppm_nox','emis_ppm_pm');
            elseif strcmp(t_vars(i),'fc_tmp')
                save_i=[save_i;i];
                extra_vars=strvcat(extra_vars, 'fc_tmp(:,1)','fc_tmp(:,2)','fc_tmp(:,3)','fc_tmp(:,4)');
                extra_vars_names=strvcat(extra_vars_names,'fc_tmp_cylinder','fc_tmp_block','fc_tmp_eng_acc','fc_tmp_hood');
            end
        end
        if ~isempty(save_i)
            new_t_vars=[t_vars(1:save_i(1),:)];
        end
        for j=2:length(save_i)
            new_t_vars=[new_t_vars; t_vars(save_i(j-1)+1:save_i(j)-1,:)];
        end
        new_t_vars=[new_t_vars; t_vars(save_i(end)+1:end,:)];
        t_vars=new_t_vars;
        
        extra_vars=cellstr(extra_vars);
        extra_vars_names=cellstr(extra_vars_names);
        
        %Load individual simulations and rename variables
        for j=1:length(matnameused)	%loop through all input simulations
            disp(['Processing ',matname{j}]);
            %load each mat file with all variables, e.g. load sim1
            j_old=j;
            try,evalin('base',['clear; load ''',path matname{j},''';']);
            catch
                vinf.comparesims.filepath=path;
                vinf.comparesims.files=matname;
                compare_sims_setup;
                errordlg('Error loading files.  Check files and/or path.  All files must be in the same path.')
                return
            end
            j=j_old;
            %Define grade and accel fields (as NaN) if they don't exist
            if strcmp(vinf.gradeability.run,'off')
                vinf.grade_test.results.grade=NaN;
                %vinf.max_grade=NaN;
            end
            if strcmp(vinf.acceleration.run,'off')
                %vinf.acceleration.time_0_60=NaN;
                %vinf.acceleration.time_40_60=NaN;
                %vinf.acceleration.time_0_85=NaN;
                %vinf.acceleration.max_accel=NaN;
                %vinf.acceleration.feet_5sec=NaN;
                
                vinf.accel_test.results.times(1)=NaN;
                vinf.accel_test.results.times(2)=NaN;
                vinf.accel_test.results.times(3)=NaN;
                vinf.accel_test.results.max_rate=NaN;
                vinf.accel_test.results.dist=NaN;
                % 1/18/00:tm added statements to handle case when all 3 accel times do not exist
                if length(vinf.accel_test.results.times)<3
                    for i=length(vinf.accel_test.results.times)+1:3
                        vinf.accel_test.results.times(i)=nan;
                    end
                end
            end
            
            
            for i=1:length(metric_vars)	%loop through all metrics
                %rename variables of interest cataloged in 'metric_vars' to new names
                %e.g. sim1_mpg=mpg; sim1_max_grade=vinf.max_grade;
                evalin('base',['global ',matnameused{j},'_',metric_names{i}]);
                evalin('base',['global ',matnameused{j},'_',metric_names_si{i}]);
                try
                    evalin('base',[matnameused{j},'_',metric_names{i},'=',metric_vars{i},';']);
                catch
                    evalin('base',[matnameused{j},'_',metric_names{i},'=NaN;']);
                end
                
                if i<=2	%mpg and mpgge -> lp100km and lp100kmge cases
                    if evalin('base',[metric_vars{i},'==0']) %needed to avoid 'divide by zero' warnings
                        evalin('base',[matnameused{j},'_',metric_names_si{i},'=0;']);
                    else
                        evalin('base',[matnameused{j},'_',metric_names_si{i},'=1/',metric_vars{i},'*',num2str(us2si(i)),';']);
                    end
                else
                    try
                        evalin('base',[matnameused{j},'_',metric_names_si{i},'=',metric_vars{i},'*',num2str(us2si(i)),';']);
                    catch
                        evalin('base',[matnameused{j},'_',metric_names_si{i},'=NaN;']);
                    end
                end
            end
            for i=1:length(t_vars)	%loop through all time variables
                %rename variables of interest cataloged in 't_vars' to new names
                %e.g. sim1_ess_current=ess_current;
                evalin('base',['global ',matnameused{j},'_',t_vars{i}]);
                try,evalin('base',[matnameused{j},'_',t_vars{i},'=',t_vars{i},';']);
                catch,evalin('base',[matnameused{j},'_',t_vars{i},'=NaN;']);
                end
            end
            for i=1:length(extra_vars)	%loop through all time variables with >1 variable per name
                %rename variables of interest cataloged in 'extra_vars' to new names
                %e.g. sim1_ess_current=ess_current;
                evalin('base',['global ',matnameused{j},'_',extra_vars_names{i}]);
                try,evalin('base',[matnameused{j},'_',extra_vars_names{i},'=',extra_vars{i},';']);
                catch,evalin('base',[matnameused{j},'_',extra_vars_names{i},'=NaN;']);
                end
            end
        end
        
        %Declare variables needed as globals so they are accessible
        for j=1:length(matnameused)	%loop through all input simulations
            for i=1:length(metric_vars)	%loop through all metrics
                evalin('base',['global ',matnameused{j},'_',metric_names{i}]);
                evalin('base',['global ',matnameused{j},'_',metric_names_si{i}]);
            end
            for i=1:length(t_vars)	%loop through all time variables
                evalin('base',['global ',matnameused{j},'_',t_vars{i}]);
            end
            for i=1:length(extra_vars)	%loop through all time variables with >1 variable per name
                evalin('base',['global ',matnameused{j},'_',extra_vars_names{i}]);
            end
        end
        
        all_t_vars=[t_vars;extra_vars_names];					%Combine all time variables
        all_t_vars=sortrows(all_t_vars);
        
        %Redefine global variables so they're not lost
        vinf.comparesims.files_used=matnameused;
        vinf.comparesims.adj_files=files;
        vinf.comparesims.filepath=path;
        vinf.comparesims.files=matname;
        vinf.comparesims.metric.name=metric_names;			%Record name of metrics
        vinf.comparesims.metric.name_si=metric_names_si;	%Record name of metrics
        vinf.comparesims.tvars=all_t_vars;						%Record time plot variables
        
        compare_sims													%Pull up gui
    end
end



% Revision history
% 9/21/99: vhj file created
% 9/27/99: vhj vinf.comparesims.files now the filenames variable
%10/04/99: vhj extra variables catalogued
%10/07/99: vhj no mat files to display fixed, error dialog if continue with no files specified
%10/07/99: vhj back to gui_results, global si names
%10/08/99: vhj correct add'l names
%10/18/99: vhj return to setup if error in loading files; added path to loading of files; lpkm=0 if mpg=0
%					save path; if files are >10 characters long, rename to Sim#
%					return if okay loading, but no t_vars (e.g. if pick simulation file by accident)
% 3/21/00: ss changed call to gui_results to call 'ResultsFigControl' (new name for gui_results)
% 12/1/00:tm updated references to accel and grade results for new naming convention
% 1/17/01:tm updated acceleration labels in pull down menus
% 1/18/01:tm updated variable name references to correspond to new accel test output format
% 1/18/01:tm added statements to handle case when all 3 accel times do not exist
% 1/23/01:tm added conditional around spider plot label definition for case when accel test not run
% 1/23/01:tm updated reference from vinf.max_grade to vinf.grade_test.results.grade
%02/02/01 vhj allow spaces in directories for load cases
% 2/15/02: ss replaced ResultsFigControl with ResultsFig
% 4/26/02: ss added try--catch statements around metric_vars that might not exist in workspace, especially applicable to 
%             acceleration results.  Basically set the variable to NaN for Compare Simulation purposes.
