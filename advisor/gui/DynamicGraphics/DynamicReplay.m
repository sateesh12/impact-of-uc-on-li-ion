%   DynamicReplay sets up Altia graphics simulations of type:
%       1.  interactive (SimType 1)
%       2.  replay (SimType 2)
%       3.  dynamic compare (SimType 3)
%       
%       Input argument "SimType" is required.
%       Input argument resultFiles is not.  If not specified, data from the workspace is used.
function DynamicReplay(SimType,resultFiles)
waitBar=waitbar(.2,'Loading dynamic graphics...                      ');
                      
global vinf

%   Assignments needed for DynamicReplay
SimulinkReqNumFiles=2;
BaseModelName='BD_DynamicCompareSims';
Model2Run=[BaseModelName,'2'];
Model2Run41Var=[BaseModelName,'1'];
AltiaDesignName='Altia_Advisor2';
AltiaDesignFileName=[AltiaDesignName,'.dsn'];
AltiaInfoFilename='AltiaInfo.m';

%   Store and change current directory
orgDir=cd;
NewDir=strrep(which(AltiaDesignFileName),['\',AltiaDesignFileName],'');
evalin('base',['cd(''',NewDir,''');']);

%   Use workspace data if no file specified
if ~exist('resultFiles')
    evalin('base','save TempWorkspaceFile');
    resultFiles={'TempWorkspaceFile'};
    evalin('base','rehash toolbox');
end
waitbar(.4,waitBar,'Loading dynamic graphics...retrieving simulation info');

%   Get file info
FileInfo=getFileInfo(resultFiles);

%   Check data file(s)
DSFilesOk=CheckDynamicSimFiles(resultFiles,SimType,FileInfo);
if ~DSFilesOk
    close(waitBar);
    return;
end

%   Store and clear current workspace
orgWorkspaceFilename='orgWorkspace.mat';
evalin('base',['save ',orgWorkspaceFilename]);
evalin('base','clear all');
evalin('base','rehash toolbox');

%   Required Inputs
ReqInputVars={'time';...
        'MinPosTimeStep';...
        'MinNegTimeStep';...
        'SimLength'};

%   Additional (mpha is in by default) time based parameters
AddInputVarsRaw={'mpha';...
        'fc_spd_est';...
        'fc_brake_trq';...
        'mc_spd_out_a';...
        'mc_trq_out_a';...
        'ess_soc_hist';...
        'gear_number';...
        'grade';...
        'gal';...
        'fc_fuel_rate';...
        'trace_miss';...
        'fc_pwr_out_a';...
        'fc_eff_out_a';...
        'gc_pwr_out_a';...
        'ess_pwr_out_a';...
        'veh_pwr_accel_a';...
        'veh_pwr_drag_a';...
        'veh_pwr_ascent_a';...
        'veh_pwr_rr_a';...
        'cyc_mph_r'};

AddInputVars=sort(AddInputVarsRaw);

waitbar(.6,waitBar,'Loading dynamic graphics...writing images for Altia  ');
%   Write out bmp files for Altia
axisLimits=writeAltiaBmps(SimType,FileInfo);

waitbar(.8,waitBar,'Loading dynamic graphics...writing info for Altia    ');
%   Write out data file for Altia to read (constants)
WriteAltiaInfoFile(SimType,FileInfo,resultFiles,axisLimits);

%   Assign zeros to any non-existing variables input to Altia
if length(FileInfo) < SimulinkReqNumFiles
    for fileNum=length(FileInfo)+1:SimulinkReqNumFiles
        eval(['FileInfo(',num2str(fileNum),').t=FileInfo(1).t;']);
    end
end
for InputNameInd=1:length(AddInputVars)
    for fileNum=1:length(FileInfo)
        if isfield(FileInfo,AddInputVars{InputNameInd})...
                & ~isempty(eval(['FileInfo(fileNum).',AddInputVars{InputNameInd}]))...
                & (length(eval(['FileInfo(fileNum).',AddInputVars{InputNameInd}]))  == length(FileInfo(fileNum).t))
            tempValue=eval(['FileInfo(fileNum).',AddInputVars{InputNameInd}]);
        else
            tempValue=zeros(length(FileInfo(fileNum).t),1);
        end
        assignin('base',[AddInputVars{InputNameInd},num2str(fileNum)],tempValue);
    end
end

%   Assign time vectors in base
for fileNum=1:length(FileInfo)
    assignin('base',['time',num2str(fileNum)],FileInfo(fileNum).t);
end

close(waitBar);


%   Start simulation
sim(Model2Run);


%   Quit simulation (Close)
evalin('base',['cd(''',orgDir,''');']);
evalin('base','clear all');
evalin('base',['load ',orgWorkspaceFilename]);




%= subfunctions ==================================================================================%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DSFilesOk=CheckDynamicSimFiles(resultFiles,SimType,FileInfo)

for fileNum=1:length(resultFiles)
    fileInfo{fileNum}=load(resultFiles{fileNum});
end

for fileNum=1:length(fileInfo)
    startTime(fileNum)=fileInfo{fileNum}.t(1);
    endTime(fileNum)=fileInfo{fileNum}.t(end);
end

%   Check for correct number of files
if  (SimType == 3) & (length(resultFiles) ~= 2)
    warnDlgH=warndlg('Dynamic compare simulations requires two simulation picks.');
    uiwait(warnDlgH);
    DSFilesOk=0;

%   Check if drive cycles have same start and end times (same length)
elseif (SimType == 3) & (~isempty(find(startTime ~= startTime(1))) | ~isempty(find(endTime ~= endTime(1))))
    warnDlgH=warndlg('Dynamic compare simulations must have same start and end times.','Dynamic Compare','modal');
    uiwait(warnDlgH);
    DSFilesOk=0;

    
else
    DSFilesOk=1;
end


