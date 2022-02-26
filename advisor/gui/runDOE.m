function runDOE

global vinf
vinf.run_without_gui=1; % do not use gui
vinf.parametric.running=1;

%   Clear old values
evalin('base','clear MilesPG MPGGE DeltaSOC NOx CO HC PM Accel_0_60 Accel_0_85 Accel_40_60 Feet_5sec Max_accel_ft_s2 Grade*');

%   Get variables to select for DOE
constVarsAll=gui_get_vars;
notDOEVars={'acc_proprietary'
    'acc_validation'
    'acc_version'
    'cyc_proprietary'
    'cyc_validation'
    'cyc_version'
    'ess_proprietary'
    'ess_validation'
    'ess_version'
    'ex_proprietary'
    'ex_validation'
    'ex_version'
    'fc_proprietary'
    'fc_validation'
    'fc_version'
    'i'
    'mc_proprietary'
    'mc_validation'
    'mc_version'
    'ptc_proprietary'
    'ptc_validation'
    'ptc_version'
    'tc_proprietary'
    'tc_validation'
    'tc_version'
    'tx_version'
    'veh_proprietary'
    'veh_validation'
    'veh_version'
    'wh_proprietary'
    'wh_validation'
    'wh_version'};
constVars=setdiff(constVarsAll,notDOEVars);

%   Get full factorial matrix
for varCounter=1:length(constVars)
    constValues(varCounter)=evalin('base',[constVars{varCounter},';']);
end
[valueMatrix,indexPos,doeVars,resultsFilename]=doeSetup('varList',constVars,constValues);

startTime=clock;
if ~isempty(valueMatrix)
    %   Loop through runs
    parStudyWaitbarH=waitbar(0,'Parametric Study');
    for runNumber=1:length(valueMatrix(:,1))
        
        %   Modify variable values
        for varIndex=1:length(valueMatrix(1,:))
            input.modify.param(varIndex)=doeVars(varIndex);
            input.modify.value{varIndex}=valueMatrix(runNumber,varIndex);
            gui_edit_var('modify',input.modify.param{varIndex},num2str(input.modify.value{varIndex}))        
        end
        
        %   Display variable values
        for varIndex=1:length(valueMatrix(1,:))
            disp([doeVars{varIndex},' : ',num2str(valueMatrix(runNumber,varIndex))]);
        end
        
        %   Run
        evalin('base','clear combined_mpg combined_mpgge');
        runButtonHandle=findobj('tag','run_pushbutton');
        SimSetupFig('run_pushbutton_Callback',runButtonHandle,[],[],'dontClose');
        
        %   Record constant results
        results2Record={'mpg';...
                'mpgge';...
                'nox_gpm';...
                'co_gpm';...
                'hc_gpm';...
                'pm_gpm';...
                'missed_trace'};
        if evalin('base','exist(''combined_mpg'')') & evalin('base','exist(''combined_mpgge'')') % this is a fix for running City Hwy Test Procedure
            results2Record{1}='combined_mpg';
            results2Record{2}='combined_mpgge';
        end
        for resultInd=1:length(results2Record)
            if evalin('base',['exist(''',results2Record{resultInd},''')']) & evalin('base',['~isnan(',results2Record{resultInd},')'])
                info.results.names{resultInd}=results2Record{resultInd};
                resultValue=evalin('base',results2Record{resultInd});
                eval(['info.results.values{',num2str(resultInd),'}(',indexPos{runNumber},')=',num2str(resultValue),';']);
            end
        end

        
        %   Record acceleration test results
        if strcmp(vinf.acceleration.run,'on')
            recordAccel=1;
            if vinf.accel_test.param.active(3)
                resultInd=1+length(results2Record);
                if runNumber==1
                    info.results.names{resultInd}=['Accel_',strrep(num2str(vinf.accel_test.param.spds1),'  ','_')];
                end
                eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.accel_test.results.times(1);']);
            end
            if vinf.accel_test.param.active(4)
                resultInd=resultInd+1;
                if runNumber==1
                    info.results.names{resultInd}=['Accel_',strrep(num2str(vinf.accel_test.param.spds2),'  ','_')];
                end
                eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.accel_test.results.times(2);']);
            end
            if vinf.accel_test.param.active(5)
                resultInd=resultInd+1;
                if runNumber==1
                    info.results.names{resultInd}=['Accel_',strrep(num2str(vinf.accel_test.param.spds3),'  ','_')];
                end
                eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.accel_test.results.times(3);']);
            end
            if vinf.accel_test.param.active(6)
                resultInd=resultInd+1;
                if runNumber==1
                    info.results.names{resultInd}=['Feet_',num2str(vinf.accel_test.param.dist_in_time),'sec'];
                end
                eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.accel_test.results.dist;']);
            end
            if vinf.accel_test.param.active(8)
                resultInd=resultInd+1;
                if runNumber==1
                    info.results.names{resultInd}='Max_Accel_ft_s2';
                end
                eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.accel_test.results.max_rate;']);
            end
        else
            recordAccel=0;
        end
        
        %   Record grade test results
        if strcmp(vinf.gradeability.run,'on') & vinf.grade_test.param.active(2)
            recordGrade=1;
            resultInd=resultInd+1;
            if runNumber==1
                info.results.names{resultInd}=['Grade_',num2str(vinf.grade_test.param.speed),'mph'];
            end
            eval(['info.results.values{resultInd}(',indexPos{runNumber},')=vinf.grade_test.results.grade;']);
        else
            recordGrade=0;
        end
        
        %   Save run
        if vinf.parametric.saveRuns == 1
            fileName=strrep(indexPos{runNumber},',','_');
            vinf.parametric.run='off'; % turned off for bringing up results in resultsfig.  Otherwise parametric_gui is executed.
            vinf.parametric.running=0; % when going back and then running again, prevents the simulation from thinking it is in the middle of a call to designOfExperiments
            vinf=rmfield(vinf,'run_without_gui'); % allows ADVISOR gui to be used with results
            try
                evalin('base',['save ',vinf.parametric.saveDir,vinf.parametric.savePrefix,'_',fileName,';']);
                disp(['Results saved as: ',vinf.parametric.saveDir,vinf.parametric.savePrefix,'_',fileName,';']);
            catch
                disp(['Results could not be saved.  Improper filename prefix or directory.']);
            end
            vinf.parametric.run='on';
            vinf.parametric.running=1;
            vinf.run_without_gui=1;
        end
        disp('--------------------------');
        
        %   Update waitbar
        aveRunTime=etime(clock,startTime)/runNumber; % seconds
        estRemainingSecs=aveRunTime*(length(valueMatrix(:,1))-runNumber);
        estRemainingDays=fix(estRemainingSecs/(3600*24));
        remSecs=rem(estRemainingSecs,(3600*24));
        estRemainingHrs=fix(remSecs/3600);
        remSecs=rem(remSecs,3600);
        estRemainingMins=fix(remSecs/60);
        remSecs=rem(remSecs,60);
        estRemainingSecs=fix(remSecs);
        
        waitbarDispStr=[];
        if estRemainingDays ~= 0
            waitbarDispStr=[waitbarDispStr,num2str(estRemainingDays),' days;  '];
        elseif estRemainingHrs ~= 0
            waitbarDispStr=[waitbarDispStr,num2str(estRemainingHrs),' hours;  '];
        elseif estRemainingMins ~=0
            waitbarDispStr=[waitbarDispStr,num2str(estRemainingMins),' minutes;  '];
        end
        waitbarDispStr=[waitbarDispStr,num2str(estRemainingSecs),' seconds remaining'];
        
        waitbar(runNumber/length(valueMatrix(:,1)),parStudyWaitbarH,waitbarDispStr);
        
    end % end while doeDone == 0
    close(parStudyWaitbarH);
    
    %   Restore workspace
    for varIndex=1:length(doeVars)
        orgValueInd=strmatch(doeVars(varIndex),constVars,'exact');
        orgValue=constValues(orgValueInd);
        gui_edit_var('modify',doeVars{varIndex},num2str(orgValue));   
    end
    %   If three or less variables were used, parametric_gui can display results
    if 0%length(doeVars) <= 3 
        vinf.parametric.var(1:length(doeVars))=doeVars;
        vinf.parametric.low(1:length(doeVars))=valueMatrix(1,:);
        vinf.parametric.high(1:length(doeVars))=valueMatrix(end,:);
        vinf.parametric.number_variables=length(doeVars);
        stringNum=strrep(indexPos(end),',',' ');
        eval(['vinf.parametric.number(1:',num2str(length(doeVars)),')=[',stringNum{1},'];']);
        
        close(findobj('tag','execute_figure'));
        parametric_gui;
    else
        
        %   Create info.vars
        info.vars.names=doeVars;
        for doeVarsInd=1:length(doeVars)
            info.vars.values{doeVarsInd}=unique(valueMatrix(:,doeVarsInd));
        end
        
        if ~isempty(info.results.names) & ~isempty(info.vars.names)
            save(resultsFilename,'info');
            doeResults('doeResults',info);
        end
    end
end
vinf=rmfield(vinf,'run_without_gui');
vinf.parametric=rmfield(vinf.parametric,'running');

% chirpSound=load('chirp');
% wavplay(chirpSound.y,chirpSound.Fs);
