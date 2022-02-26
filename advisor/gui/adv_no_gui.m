function [err_code,resp]=advisor_no_gui(action,input)
%
% This function can be used to run the main features of ADVISOR without
% using the GUI. This allows easy use of ADVISOR as a solution engine for 
% other programs such as optimization.
%
% Possible Actions:
% 1) initialize workspace
% 		inputs
%			vehicle type, data file names, override variables and values, units
%		responses
%			error code
% 2) run grade test
% 		inputs
%			grade, speed, init soc, final soc, duration, gear ratio, lower bound, upper bound, grade tol, speed tol
%		responses
%			error code, grade
% 3) run accel test
% 		inputs
%			spds1, spds2
%		responses
%			error code, times
% 4) run drive cycle
% 			inputs
%				cycle name, soc_corr_flag, soc_corr_tol, soc_corr_iter, number of cycles, init conditions
%			responses
%				error code, fe, co, hc, nox, final soc, initial soc, trace miss flag
% 5) run test procedure
% 		inputs
%			procedure name
%		responses
%			error code, fe, co, hc, nox, pm
%
%
DEBUG=1; % set to 1 to enable all keyboard commands to come on and allow error checking

% if no arguments provided return with error
if nargin<1
    err_code=1;
    resp=[];
    return
end

% if attempt to run actions other than initialize first return with error
if evalin('base','~exist(''vinf'')')&~strcmp(action,'initialize')
    err_code=1;
    resp=[];
    return
end

% make vinf info accessible
global vinf

% decide what action to take
switch action
    
case 'initialize'
    
    err_code=0;
    resp=[];
    try % NOTES: changed evalin to eval for vinf.* assignments 15-MAR-2002[mpo]
        eval('input.init.saved_veh_file;test4exist=1;','test4exist=0;')
        if test4exist % saved vehicle file provided
            eval(input.init.saved_veh_file)
            % BEGIN ADD 15-MAR-2002[mpo]
            % adding functionality so user can load a saved vehicle AND change component files in a single initialization
            eval('input.init.comp_files;test4exist=1;','test4exist=0;')
            if test4exist % list of component files provided
                for i=1:length(input.init.comp_files.comp) % 15-MAR-2002[mpo]:added the surrounding quote to force a string assignment//20-MAR-2002[mpo]: changed input.init.comp_files to input.init.comp_files.comp to get correct length
                    eval(['vinf.',input.init.comp_files.comp{i},'.name=''',input.init.comp_files.name{i},''';'])
                    try % Jan 28, 2003 [mpo] adding this try/catch block to support previous versions of component setting in adv_no_gui
                        eval(['vinf.',input.init.comp_files.comp{i},'.ver=''',input.init.comp_files.ver{i},''';'])
                        eval(['vinf.',input.init.comp_files.comp{i},'.type=''',input.init.comp_files.type{i},''';'])
                    catch
                        disp(['[',mfilename,'] Note: no version and type information detected for component settings-- specify cell of char for fields *.init.comp_files.ver and *.init.comp_files.type to set in the future'])
                        if DEBUG
                            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
                            keyboard
                        end
                    end
                end
            end            
            eval('input.init.overrides;test4exist=1;','test4exist=0;')
            if test4exist % list of override variables provided
                for i=1:length(input.init.overrides.name)
                    eval(['vinf.variables.name{',num2str(i),'}=''',input.init.overrides.name{i},''';'])
                    eval(['vinf.variables.value(',num2str(i),')=',mat2str(input.init.overrides.value{i}),';'])
                    eval(['vinf.variables.default(',num2str(i),')=',mat2str(input.init.overrides.default{i}),';'])
                end
            end
            % END ADD 15-MAR-2002[mpo]
        else
            eval('input.init.comp_files;test4exist=1;','test4exist=0;')
            if test4exist % list of component files provided
                for i=1:length(input.init.comp_files.comp) % 15-MAR-2002[mpo]:added the surrounding quote to force a string assignment
                    eval(['vinf.',input.init.comp_files.comp{i},'.name=''',input.init.comp_files.name{i},''';'])
                    try % Jan 28, 2003 [mpo] adding this try/catch block to support previous versions of component setting in adv_no_gui
                        eval(['vinf.',input.init.comp_files.comp{i},'.ver=''',input.init.comp_files.ver{i},''';'])
                        eval(['vinf.',input.init.comp_files.comp{i},'.type=''',input.init.comp_files.type{i},''';'])
                    catch
                        disp(['[',mfilename,'] Note: no version and type information detected for component settings-- specify cell of char for fields *.init.comp_files.ver and *.init.comp_files.type to set in the future'])
                        if DEBUG
                            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
                            keyboard
                        end
                    end
                end
                eval('input.init.overrides;test4exist=1;','test4exist=0;')
                if test4exist % list of override variables provided
                    for i=1:length(input.init.overrides.name)
                        eval(['vinf.variables.name{',num2str(i),'}=''',input.init.overrides.name{i},''''])
                        eval(['vinf.variables.value(',num2str(i),')=',mat2str(input.init.overrides.value{i}),';'])
                        eval(['vinf.variables.default(',num2str(i),')=',mat2str(input.init.overrides.default{i}),';'])
                    end
                end
            else
                err_code=1; % no saved vehicle file or list of component files provided
            end
        end
        
        vinf.run_without_gui=1; % do not use gui
        
        vinf.time_step=1; % set default time step size
        
        eval('input.init.units;test4exist=1;','test4exist=0;')
        if test4exist&(strcmp(input.init.units,'us')|strcmp(input.init.units,'metric')) % units selection provided and a valid input
            vinf.units=input.init.units;
        else
            vinf.units='us'; % default to 'us' units
        end
        
        gui_run_files('load') % standard ADVISOR action for building workspace
        
        % BEGIN ADD 15-MAR-2002[mpo]
        eval('input.init.init_conds_file;test4exist=1;','test4exist=0;')
        if test4exist
            eval(input.init.init_conds_file); % load the user defined intial conditions file
        else
            init_conds % load standard initial conditions
        end
        % END ADD 15 MAR-2002[mpo]
    
%         % BEGIN added by 14-MAR-2002[mpo] 
%     % SETUP a default AuxLoads struct in vinf (not necessary at this time? also done in the 'cycle' area but this in case
%     % ...user goes straight to an accel or grade test...)
%     eval('input.init.aux_load_file_name;test4exist=1;','test4exist=0;')
%     if test4exist
%         AuxLoadFile=input.init.aux_load_file_name;
%     else
%         AuxLoadFile='Default_aux';
%     end
%     try
%         eval(['AuxLoads=load(''',AuxLoadFile,''');']); % creates the variable AuxLoads on the (function) workspace
%         vinf.AuxLoads=AuxLoads.AuxLoads; % assigns AuxLoads values to the vinf.AuxLoads (global) variable
%         eval('vinf.AuxLoads.On;test4exist=1;','test4exist=0;')
%         if ~test4exist % if vinf.AuxLoads.On does not exist, let's make it with a default of zero!
%             vinf.AuxLoads.On=0;
%         end
%         clear AuxLoads AuxLoadFile;         % clears AuxLoads because we don't need it anymore
%     catch
%         disp(['Error loading the AuxLoadFile: in adv_no_gui{initialize}: ', AuxLoadFile])
%         disp(lasterr);
%     end
%     % END added by 14-MAR-2002[mpo]
    
    catch
        err_code=1;
        disp('Error in adv_no_gui case {initialize}:')      
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end
    end
    
case 'modify'
    
    err_code=0;
    resp=[];
    try
        eval('input.modify.param;test4exist=1;','test4exist=0;')
        if test4exist
            for i=1:length(input.modify.param)
                %gui_edit_var('modify',input.modify.param{i},mat2str(input.modify.value{i})) % tm:11/15/00 make active once gui_edit_var is capable of handling matrices
                gui_edit_var('modify',input.modify.param{i},num2str(input.modify.value{i}))
            end
        end
        
    catch
        err_code=1;
        disp('Error in adv_no_gui case {modify}:')      
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'accel_test'
    
    err_code=0;
    resp=[];
    
%     % BEGIN ADD 14-MAR-2002[mpo]
%     % if the accel_test is accessed directly without initialization, error checking is required to
%     % ...ensure vinf.AuxLoads created properly.
%     % ...GetLoadNames() is a function that returns all of the aux load names when given parameter 'All'
%     if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
%         % Let user know that a default variable aux loads schedule is being created:
%         disp('NOTE from adv_no_gui case{accel_test}:')
%         disp('......The template file Default_aux.mat is being used to create vinf.AuxLoads fields.')
%         disp('......Variable auxiliary loads are set up as ''off'' for this run as a default.')
%         disp('......The struc vinf.AuxLoads.* (variable auxiliary loads) should be setup prior to running accel test')
%         disp('......if you would like to run the accel test with variable electric loads engaged.')
%         
%         AuxLoadFile='Default_aux'; % No Aux Load struct exists so let's use a default
%         try
%             eval(['AuxLoads=load(''',AuxLoadFile,''');']); % creates the variable AuxLoads on the (function) workspace
%             vinf.AuxLoads=AuxLoads.AuxLoads; % assigns AuxLoads values to the vinf.AuxLoads (global) variable
%             eval('vinf.AuxLoads.On;test4exist=1;','test4exist=0;')
%             if ~test4exist % if vinf.AuxLoads.On does not exist, let's make it with a default of zero!
%                 vinf.AuxLoads.On=0;
%             end
%             clear AuxLoads AuxLoadFile;         % clears AuxLoads because we don't need it anymore
%         catch
%             disp(['Error loading the AuxLoadFile: in adv_no_gui{accel_test}: ', AuxLoadFile])
%             disp(lasterr);
%         end        
%     end    
%     % END ADD 14-MAR-2002[mpo]
    
    try
        str=[];
        eval('input.accel.param;test4exist=1;','test4exist=0;')
        if test4exist
            for i=1:length(input.accel.param)
                str=[str,'''',input.accel.param{i},''',',mat2str(input.accel.value{i}),','];
            end
            str=str(1:end-1);
        end
        
        if ~isempty(str)
            str=['accel_test_advanced(',str,')'];
        else
            str='accel_test_advanced';
        end
        str;
        resp.accel=eval(str);
        
    catch
        err_code=1;
        disp('Error in adv_no_gui case {accel_test}:')      
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'grade_test'
    
    err_code=0;
    resp=[];
    
%     % BEGIN ADD 14-MAR-2002[mpo]
%     % if the grade_test is accessed directly without initialization, error checking is required to
%     % ...ensure vinf.AuxLoads is created properly.
%     % ...GetLoadNames() is a function that returns all of the aux load names when given parameter 'All'
%     if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
%         % Let user know that a default variable aux loads schedule is being created:
%         disp('NOTE from adv_no_gui case{grade_test}:')
%         disp('......The template file Default_aux.mat is being used to create vinf.AuxLoads fields.')
%         disp('......Variable auxiliary loads are set up as ''off'' for this run as a default.')
%         disp('......The struc vinf.AuxLoads.* (variable auxiliary loads) should be setup prior to running grade test')
%         disp('......if you would like to run the grade test with variable electric loads engaged.')
%         
%         AuxLoadFile='Default_aux'; % No Aux Load struct exists so let's use a default
%         try
%             eval(['AuxLoads=load(''',AuxLoadFile,''');']); % creates the variable AuxLoads on the (function) workspace
%             vinf.AuxLoads=AuxLoads.AuxLoads; % assigns AuxLoads values to the vinf.AuxLoads (global) variable
%             eval('vinf.AuxLoads.On;test4exist=1;','test4exist=0;')
%             if ~test4exist % if vinf.AuxLoads.On does not exist, let's make it with a default of zero!
%                 vinf.AuxLoads.On=0;
%             end
%             clear AuxLoads AuxLoadFile;         % clears AuxLoads because we don't need it anymore
%         catch
%             disp(['Error loading the AuxLoadFile: in adv_no_gui{grade_test}: ', AuxLoadFile])
%             disp(lasterr);
%         end        
%     end    
%     % END ADD 14-MAR-2002[mpo]
    
    try
        str=[];
        eval('input.grade.param;test4exist=1;','test4exist=0;')
        if test4exist
            for i=1:length(input.grade.param)
                str=[str,'''',input.grade.param{i},''',',mat2str(input.grade.value{i}),','];
            end
            str=str(1:end-1);
        end
        
        if ~isempty(str)
            str=['grade_test_advanced(',str,')'];
        else
            str='grade_test_advanced';
        end
        
        if ~isfield(vinf,'saber_cosim') | ~isfield(vinf.saber_cosim,'run')
            vinf.saber_cosim.run=0;
        end
        
        [grade,gear]=eval(str);
        
        resp.grade.grade=grade;
        resp.grade.gear=gear;
        
    catch
        err_code=1;
        disp('Error in adv_no_gui case {grade_test}:')     
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end
    end
    
case 'drive_cycle'
    
    err_code=0;
    resp=[];
    try
        % set defaults
        vinf.cycle.run='on';
        vinf.cycle.number=1;
        vinf.cycle.name='CYC_UDDS';
        if strcmp(vinf.drivetrain.name,'conventional')
            vinf.cycle.soc='off';
        else
            vinf.cycle.soc='on';
        end
        vinf.cycle.socmenu='zero delta';
        vinf.cycle.soc_tol_method='soctol'; % 03/14/02:tm and mo added to work with new soc tol options
        vinf.cycle.SOCtol=0.5;
        vinf.cycle.SOCiter=15;
        vinf.test.run='off';
        vinf.test.name='TEST_CITY_HWY';
        vinf.gradeability.run='off';
        vinf.acceleration.run='off';
        vinf.road_grade.run='off';
        vinf.parametric.run='off';
        vinf.multi_cycles.run='off'; % 040402:tm added to allowed save sims to be pulled up in results fig without errors
%        vinf.AuxLoads.On=0;
        if ~isfield(vinf,'saber_cosim') | ~isfield(vinf.saber_cosim,'run')
            vinf.saber_cosim.run=0;
        end
        
        % BEGIN ADD by 14-MAR-2002[mpo] 
        % setup a default AuxLoads struct in vinf 
%         eval('input.cycle.aux_load_file_name;test4exist=1;','test4exist=0;')
%         if test4exist
%             AuxLoadFile=input.cycle.aux_load_file_name{1};
%         else
%             AuxLoadFile='Default_aux';
%         end
%         try
%             eval(['AuxLoads=load(''',AuxLoadFile,''');']); % creates the variable AuxLoads on the (function) workspace
%             vinf.AuxLoads=AuxLoads.AuxLoads; % assigns AuxLoads values to the vinf.AuxLoads (global) variable
%             eval('input.cycle.aux_load_on;test4exist=1;','test4exist=0;')
%             if test4exist % if vinf.AuxLoads.On does not exist, let's make it with a default of zero!
%                 vinf.AuxLoads.On=str2num(input.cycle.aux_load_on{1});
%             else
%                 vinf.AuxLoads.On=0;
%             end
%             clear AuxLoads AuxLoadFile;         % clears AuxLoads because we don't need it anymore
%         catch
%             disp(['Error loading the AuxLoadFile in adv_no_gui case{drive_cycle}: ', AuxLoadFile])
%             disp(lasterr);
%         end
        % END ADD added by 14-MAR-2002[mpo]
        
        % BEGIN COMMENT OUT by 14-MAR-2002[mpo]
        % NOTE: AuxLoadsFigControl('LoadAuxVars') is depricated (no longer supported--code commented out)
        % disable cycle varying aux loads
        %if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
        %    AuxLoadsFigControl('LoadAuxVars');
        %end
        % vinf.AuxLoads.On=0; % no cycle varying aux loads // 14-MAR-2002[mpo]: vinf.AuxLoads.On will 
        % ......................................................no longer be automatically zeroed out
        % END COMMENT OUT by 14-MAR-2002[mpo]
        
        % override defaults with user inputs
        eval('input.cycle.param;test4exist=1;','test4exist=0;')
        if test4exist
            for i=1:length(input.cycle.param)
                if isstr(input.cycle.value{i})
                    eval(['vinf.',input.cycle.param{i},'=''',input.cycle.value{i},''';'])
                else
                    eval(['vinf.',input.cycle.param{i},'=',mat2str(input.cycle.value{i}),';'])
                end
            end
        end
        
        % build workspace
        evalin('base',vinf.cycle.name); 
        
        % run simulation
        evalin('base','gui_run') 
        
        % process results
        evalin('base','gui_post_process') 
        
        % build response structure
        resp.cycle.mpgge=evalin('base','mpgge');
        resp.cycle.hc_gpm=evalin('base','hc_gpm');
        resp.cycle.co_gpm=evalin('base','co_gpm');
        resp.cycle.nox_gpm=evalin('base','nox_gpm');
        resp.cycle.pm_gpm=evalin('base','pm_gpm');
        resp.cycle.delta_trace=evalin('base','max(abs(trace_miss))');
        if strcmp(vinf.cycle.soc,'on') & strcmp(vinf.cycle.socmenu,'zero delta')
            resp.cycle.delta_soc=evalin('base','DeltaSOC(end)');
        end
        
    catch
        err_code=1;
        disp('Error in adv_no_gui case {drive_cycle}:')
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'test_procedure'
    
    err_code=0;
    resp=[];
    try
        % set defaults
        vinf.cycle.run='off';
        vinf.cycle.number=1;
        vinf.cycle.name='CYC_UDDS';
        if strcmp(vinf.drivetrain.name,'conventional')
            vinf.cycle.soc='off';
        else
            vinf.cycle.soc='on';
        end
        vinf.cycle.socmenu='zero delta';
        vinf.cycle.soc_tol_method='soctol'; % 03/14/02:tm and mo added to work with new soc tol options
        vinf.cycle.SOCtol=0.5;
        vinf.cycle.SOCiter=15;
        vinf.test.run='on';
        vinf.test.name='TEST_CITY_HWY';
        vinf.gradeability.run='off';
        vinf.acceleration.run='off';
        vinf.road_grade.run='off';
        vinf.parametric.run='off';
        vinf.multi_cycles.run='off'; % 040402:tm added to allowed save sims to be pulled up in results fig without errors
        assignin('base','no_results_fig',1);
        if ~isfield(vinf,'saber_cosim') | ~isfield(vinf.saber_cosim,'run')
            vinf.saber_cosim.run=0;
        end
        
%         % BEGIN ADD by 14-MAR-2002[mpo] 
%         % setup a default AuxLoads struct in vinf 
%         eval('input.procedure.aux_load_file_name;test4exist=1;','test4exist=0;')
%         if test4exist
%             AuxLoadFile=input.procedure.aux_load_file_name;
%         else
%             AuxLoadFile='Default_aux';
%         end
%         try
%             eval(['AuxLoads=load(''',AuxLoadFile,''');']); % creates the variable AuxLoads on the (function) workspace
%             vinf.AuxLoads=AuxLoads.AuxLoads; % assigns AuxLoads values to the vinf.AuxLoads (global) variable
%             eval('vinf.AuxLoads.On;test4exist=1;','test4exist=0;')
%             if ~test4exist % if vinf.AuxLoads.On does not exist, let's make it with a default of zero!
%                 vinf.AuxLoads.On=0;
%             end
%             clear AuxLoads AuxLoadFile;         % clears AuxLoads because we don't need it anymore
%         catch
%             disp(['Error loading the AuxLoadFile in adv_no_gui case{test_procedure}: ', AuxLoadFile])
%             disp(lasterr);
%         end
%         % END ADD added by 14-MAR-2002[mpo]
        
        % BEGIN COMMENT OUT by 14-MAR-2002[mpo]
        % NOTE: AuxLoadsFigControl('LoadAuxVars') is depricated (no longer supported--code commented out)
        % disable cycle varying aux loads
        %if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
        %    AuxLoadsFigControl('LoadAuxVars');
        %end
        % vinf.AuxLoads.On=0; % no cycle varying aux loads // 14-MAR-2002[mpo]: vinf.AuxLoads.On will 
        % ......................................................no longer be automatically zeroed out
        % END COMMENT OUT by 14-MAR-2002[mpo]
        
        % override defaults with user inputs
        eval('input.procedure.param;test4exist=1;','test4exist=0;')
        if test4exist
            for i=1:length(input.procedure.param)
                % 31-Jan-2003: mpo: changing the values here so test_procedure works as specified in documentation
                if isstr(input.procedure.value{i}) 
                    eval(['vinf.test.',input.procedure.param{i},'=''',input.procedure.value{i},''';'])
                else
                    eval(['vinf.test.',input.procedure.param{i},'=',mat2str(input.procedure.value{i}),';'])
                end
            end
        end
        
        % run simulation
        try
            evalin('base','gui_run;') 
        catch
            disp('Error while trying to run gui_run from adv_no_gui case{test_procedure}')
            disp(lasterr);
            if DEBUG
                disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
                keyboard
            end            
        end
        
        % build response structure
        switch vinf.test.name
        case 'TEST_CITY_HWY'
            resp.procedure.mpgge=evalin('base','combined_mpgge');
            resp.procedure.hc_gpm=evalin('base','hc_gpm');
            resp.procedure.co_gpm=evalin('base','co_gpm');
            resp.procedure.nox_gpm=evalin('base','nox_gpm');
            resp.procedure.pm_gpm=evalin('base','pm_gpm');
            resp.procedure.delta_trace=evalin('base','delta_trace');
            if strcmp(vinf.cycle.soc,'on')
                resp.procedure.delta_soc=evalin('base','delta_soc');
            end
        case 'TEST_CITY_HWY_HYBRID'
            resp.procedure.mpgge=evalin('base','combined_mpgge');
            resp.procedure.hc_gpm=evalin('base','hc_gpm');
            resp.procedure.co_gpm=evalin('base','co_gpm');
            resp.procedure.nox_gpm=evalin('base','nox_gpm');
            resp.procedure.pm_gpm=evalin('base','pm_gpm');
            resp.procedure.delta_trace=evalin('base','delta_trace');
            if strcmp(vinf.cycle.soc,'on')
                resp.procedure.delta_soc=evalin('base','delta_soc');
            end
            
        case 'TEST_FTP'
            resp.procedure.mpgge=evalin('base','mpgge');
            resp.procedure.hc_gpm=evalin('base','hc_gpm');
            resp.procedure.co_gpm=evalin('base','co_gpm');
            resp.procedure.nox_gpm=evalin('base','nox_gpm');
            resp.procedure.pm_gpm=evalin('base','pm_gpm');
            resp.procedure.delta_trace=evalin('base','max(abs(trace_miss))');
            if strcmp(vinf.cycle.soc,'on')
                resp.procedure.delta_soc=evalin('base','DeltaSOC(end)');
            end
        case 'TEST_FTP_HYBRID'
            resp.procedure.mpgge=evalin('base','mpgge');
            resp.procedure.hc_gpm=evalin('base','hc_gpm');
            resp.procedure.co_gpm=evalin('base','co_gpm');
            resp.procedure.nox_gpm=evalin('base','nox_gpm');
            resp.procedure.pm_gpm=evalin('base','pm_gpm');
            resp.procedure.delta_trace=evalin('base','max(abs(trace_miss))');
            if strcmp(vinf.cycle.soc,'on')
                resp.procedure.delta_soc=evalin('base','DeltaSOC(end)');
            end
            
        case 'TEST_REAL_WORLD'
            % to be updated later
        case 'TEST_J1711'
            % to be updated later
        end
        
    catch
        err_code=1;
        disp('Error in adv_no_gui case {test_procedure}:')      
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'other_info'
    
    err_code=0;
    resp=[];
    try
        % return any additional parameter values requested
        eval('input.resp.param;test4exist=1;','test4exist=0;');
        if test4exist
            for i=1:length(input.resp.param)
                resp.other.param{i}=input.resp.param{i};
                resp.other.value{i}=evalin('base',input.resp.param{i});
            end
        end
    catch
        err_code=1;
        disp('Error in adv_no_gui case {other_info}:')
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'save_vehicle'
    
    err_code=0;
    resp=[];
    try
        % return any additional parameter values requested
        eval('input.save.filename;test4exist=1;','test4exist=0;');
        if test4exist
            if isfield(input.save,'directStruct')
                gui_save_input(input.save.filename,'updateWSWithDirect',input.save.directStruct);
            else
                gui_save_input(input.save.filename);
            end
        else
            time=clock;
            str=[num2str(time(1)),'_',num2str(time(2)),'_',num2str(time(3)),'_',num2str(time(4)),'_',num2str(time(5)),'_',num2str(time(6))];
            gui_save_input(['adv_no_gui_',str,'_in'])
        end
    catch
        err_code=1;
        disp('Error in adv_no_gui case {save_vehicle}:')
        disp(lasterr);
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
case 'autosize'
    err_code=0;
    resp=[];
    
    % setup the defaults
    % the following must be defined
    %accel_input.param.active=zeros(1,15);
    %accel_input.param.gb_shift_delay
    %accel_input.param.ess_init_soc
    %accel_input.param.spds1
    %accel_input.param.spds2
    %accel_input.param.spds3
    %accel_input.param.dist_in_time
    %accel_input.param.time_in_dist
    %accel_input.param.override_mass
    %accel_input.param.add_mass
    %accel_input.param.accel_time1_tol
    %accel_input.param.accel_time1_con
    %accel_input.param.accel_time2_tol
    %accel_input.param.accel_time2_con
    %accel_input.param.accel_time3_tol
    %accel_input.param.accel_time3_con
    %accel_input.param.dist_in_time_tol
    %accel_input.param.dist_in_time_con
    %accel_input.param.time_in_dist_tol
    %accel_input.param.time_in_dist_con
    %accel_input.param.max_accel_tol
    %accel_input.param.max_accel_con
    %accel_input.param.max_spd_tol
    %accel_input.param.max_spd_con
    %dv_bounds=[0 1;0 1;0 1];
    %grade_input.param.active=zeros(1,19)
    %grade_input.param.grade
    %grade_input.param.speed
    %grade_input.param.duration
    %grade_input.param.gear_num
    %grade_input.param.ess_init_soc
    %grade_input.param.ess_min_soc
    %grade_input.param.grade_lb
    %grade_input.param.grade_ub
    %grade_input.param.grade_init_step
    %grade_input.param.grade_tol
    %grade_input.param.speed_tol
    %grade_input.param.max_iter
    %grade_input.param.disp_status
    %grade_input.param.disable_systems
    %grade_input.param.override_mass
    %grade_input.param.add_mass
    
    % we need a legit input struct with the following fields:
    % ......input.autosize.grade_test
    % ......input.autosize.accel_test
    % ......input.autosize.autosize
    % ...where input.autosize.* is the same as its corresponding vinf.*
    % ...this is most easily done by running autosize with the GUI and saving the fields of vinf.* to a *.mat file
    if ~isfield(input,'autosize')
        disp('NOTE from adv_no_gui case{autosize}')
        disp('...the fields autosize.grade_test, autosize.accel_test, and autosize.autosize are needed in the input')
        disp('...struct to adv_no_gui for the autosize feature to work.')
        disp('...The above mentioned fields must be equivalent to the corresponding vinf.* fields of the same name')
        disp('...This is most easily done by running autosize on the GUI and saving the corresponding fields to a *.mat file')
        disp('...For example: ')
        disp('...   autosize=vinf.grade_test;autosize=vinf.accel_test;autosize=vinf.autosize;save fname autosize');
        disp('...   ...')
        disp('...   input=load(''fname'');[a,b]=adv_no_gui(''autosize'',input);')
        disp('')
        err_code=1;
        return
    elseif ~isfield(input.autosize,'grade_test')|~isfield(input.autosize,'accel_test')|~isfield(input.autosize,'autosize')
        disp('NOTE from adv_no_gui case{autosize}')
        disp('...the fields autosize.grade_test, autosize.accel_test, and autosize.autosize are needed in the input')
        disp('...struct to adv_no_gui for the autosize feature to work.')
        disp('...The above mentioned fields must be equivalent to the corresponding vinf.* fields of the same name')
        disp('...This is most easily done by running autosize on the GUI and saving the corresponding fields to a *.mat file')
        disp('...For example: ')
        disp('...   autosize=vinf.grade_test;autosize=vinf.accel_test;autosize=vinf.autosize;save fname autosize');
        disp('...   ...')
        disp('...   input=load(''fname'');[a,b]=adv_no_gui(''autosize'',input);')
        disp('')
        err_code=1;
        return
    end
    % setup some of the other fields correctly
    dv_bounds=[input.autosize.autosize.cv.fc(2:3);input.autosize.autosize.cv.ess(2:3);input.autosize.autosize.cv.mc(2:3)];
    vinf.autosize=input.autosize.autosize; % setup vinf with the autosize variables from input--this is the only way I know
    %........................................of to set variables like vinf.autosize.dv
    try
        autosize(0,input.autosize.grade_test,input.autosize.accel_test,dv_bounds);
    catch
        disp('Error running autosize in adv_no_gui case{''autosize''}')
        disp(lasterr)
        if DEBUG
            disp(['[',mfilename,'] going to keyboard -- type return to continue code or dbquit to exit'])
            keyboard
        end        
    end
    
otherwise % undefined case
    
    err_code=1;
    resp=[];
    
end

return

% revision history
% 7/6/00:tm file created based on advisor_no_gui in A2.2.1d
% 7/10/99:ss all references to FUDS are now UDDS
% 7/14/00:tm added case to handle modification of variables
% 7/14/00:tm added the ability to return additional information during any performance calc
% 7/14/00:tm added check to ensure that vinf exists before any action other than initialize is executed
% 11/15/00:tm updated to accept and return vectors rather than just scalors - param values now passed as cell array rather than vector
% 11/15/00:tm added case to save the vehicle configuration for future use
% 11/15/00:tm added a case to return other information - removed this functionality from other cases
% 1/23/00:tm changed interpretation of grade input parameters to match that of the accel test - changed so that both params and values are cell arrays
% 8/21/01:tm added cases to return results for TEST_CITY_HWY_HYBRID and TEST_FTP_HYBRID
% 10/19/01:mpo added disp(lasterr) statements to each catch block so user has a sense of the error when an err_code=1 appears
% 03/14/02:mpo added more comments for error catching
% 03/14/02:tm&mpo added default values to vinf.cycle.soc_tol_method='soctol' in 'test_procedure' and 'drive_cycle'
% 03/14/02:mpo added statements to correctly load in vinf.AuxLoads and allow vinf.AuxLoads to be set to On=1
% 03/15/02:mpo fixed a single-quote problem in case 'initialization' for comp_files
% 03/15/02:mpo added functionality so user can load a saved vehicle AND change component files in a single initialization
% 03/15/02:mpo changed evalin to eval for vinf assignments in 'initialization'. evalin doesn't seem to work with global vars
% 03/20/02:mpo changed input.init.comp_files to input.init.comp_files.comp to get correct length and similarly for input.init.overrides to *.name (in 'initialize')
% 04/04/02:tm added default assignment for vinf.multi_cycles.run='off' to allow saved sims to be pulled up in results fig without errors
% 04/18/02:tm added .comp and .name inside the length statements for the initialize with component filenames case
% 04/18/02:tm updated units definition so that valid options are "us" and "metric"
% 04/18/02:tm commented out the special code for auxloads
% 04/18/02:tm replaced .max_trace_miss with .delta_trace in cycle and test procedure cases