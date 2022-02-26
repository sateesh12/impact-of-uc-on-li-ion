function designOfExperiments
%   designOfExperiments    Full factoral design of experiments.

global vinf
vinf.run_without_gui=1; % do not use gui
vinf.parametric.running=1;

%   Clear old values
evalin('base','clear MilesPG MPGGE DeltaSOC NOx CO HC PM Accel_0_60 Accel_0_85 Accel_40_60 Feet_5sec Max_accel_ft_s2 Grade*');

%   Get full factorial matrix based on GUI selections
[valueMatrix,indexPos]=getFullFactorialMatrix(vinf.parametric.high(1:vinf.parametric.number_variables),...
    vinf.parametric.low(1:vinf.parametric.number_variables),...
    vinf.parametric.number(1:vinf.parametric.number_variables));

%   Loop through runs
parStudyWaitbarH=waitbar(0,'Parametric Study');
for runNumber=1:length(valueMatrix(:,1))
    
    %   Modify variable values
    for varIndex=1:length(valueMatrix(1,:))
        input.modify.param(varIndex)=vinf.parametric.var(varIndex);
        input.modify.value{varIndex}=valueMatrix(runNumber,varIndex);
        gui_edit_var('modify',input.modify.param{varIndex},num2str(input.modify.value{varIndex}))        
    end
    
    %   Display variable values
    for varIndex=1:length(valueMatrix(1,:))
        disp([vinf.parametric.var{varIndex},' : ',num2str(valueMatrix(runNumber,varIndex))]);
    end
    
    %   Run
    runButtonHandle=findobj('tag','run_pushbutton');
    SimSetupFig('run_pushbutton_Callback',runButtonHandle);
    
    %   Record drive cycle results
    if evalin('base','exist(''mpg'')')
        evalin('base',['MilesPG(',indexPos{runNumber},')=mpg;']);
        evalin('base',['MPGGE(',indexPos{runNumber},')=mpgge;']);
    else
        evalin('base',['MilesPG(',indexPos{runNumber},')=0;']);%this is for series when no gas mileage exists, set to zero
    end
    if evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'off')
        evalin('base',['DeltaSOC(',indexPos{runNumber},')=ess_soc_hist(end)-ess_soc_hist(1);']);
    elseif evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'on')
        if strcmp(vinf.cycle.socmenu,'zero delta')
            evalin('base',['DeltaSOC(',indexPos{runNumber},')=ess_soc_hist(end)-ess_soc_hist(1);']);
        elseif strcmp(vinf.cycle.socmenu,'linear')
            evalin('base',['DeltaSOC(',indexPos{runNumber},')=0;']);%for SOC correct linear, the DeltaSOC is zero
        end
    end
    if evalin('base',['exist(''nox_gpm'')'])
        evalin('base',['NOx(',indexPos{runNumber},')=nox_gpm;']);
        evalin('base',['CO(',indexPos{runNumber},')=co_gpm;']);
        evalin('base',['HC(',indexPos{runNumber},')=hc_gpm;']);
        evalin('base',['PM(',indexPos{runNumber},')=pm_gpm;']);
    end
    
    %   Record acceleration test results
    if strcmp(vinf.acceleration.run,'on')
        if vinf.accel_test.param.spds1 == [0 60] & vinf.accel_test.param.active(3)
            evalin('base',['Accel_0_60(',indexPos{runNumber},')=vinf.accel_test.results.times(1);']);
        end
        if vinf.accel_test.param.spds2 == [40 60] & vinf.accel_test.param.active(4)
            evalin('base',['Accel_40_60(',indexPos{runNumber},')=vinf.accel_test.results.times(2);']);
        end
        if vinf.accel_test.param.spds3 == [0 85] & vinf.accel_test.param.active(5)
            evalin('base',['Accel_0_85(',indexPos{runNumber},')=vinf.accel_test.results.times(3);']);
        end
        if vinf.accel_test.param.dist_in_time == 5 & vinf.accel_test.param.active(6)
            evalin('base',['Feet_5sec(',indexPos{runNumber},')=vinf.accel_test.results.dist;']);
        end
        if isfield(vinf.accel_test.results,'max_rate') & vinf.accel_test.param.active(8)
            evalin('base',['Max_accel_ft_s2(',indexPos{runNumber},')=vinf.accel_test.results.max_rate;']);
        end
    end
    
    %   Record grade test results
    if strcmp(vinf.gradeability.run,'on') & vinf.grade_test.param.active(2)
        evalin('base',['Grade_',num2str(vinf.grade_test.param.speed),'mph(',indexPos{runNumber},')=vinf.grade_test.results.grade;']);
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
    waitbar(runNumber/length(valueMatrix(:,1)),parStudyWaitbarH);
    
end % end while doeDone == 0
close(parStudyWaitbarH);

%   Restore workspace
vinf=rmfield(vinf,'run_without_gui');
vinf.parametric=rmfield(vinf.parametric,'running');

parametric_gui;

