function [sys,x0,str,ts] = SaberCosimDVSfun(t,x,u,flag,TempPath,AdvStepSize,IOFile)

persistent InputSaberParams OutputSaberValues ModelPath SaberModelName StopMatlabH FirstCall...
    InitSaberFile AlterSaberFile AdvReadFile TrigFile AimFileName FunPath Secs2TimedOut

% Determine if it is the beginning of the simulation
if (flag == 0) & isempty(FirstCall)
    FirstCall = 1;
elseif flag == 9
    FirstCall=[];
else
    FirstCall=0;
end


% Initialize... 
if ~isempty(FirstCall) & FirstCall == 1
    
    % co-simulation stop message box
    StopMatlabH=msgbox('Close this box to stop ADVISOR co-simulation.  ***NOTE:  Stopping the co-simulation continues the ADVISOR simulation to completion holding Saber outputs at their last value.',...
        'Stop Co-simulation');
    StopOkH=findobj(StopMatlabH,'string','OK');
    set(StopOkH,'string','Stop');
    Secs2TimedOut=30;
    
    % co-simulation parameter lists & Saber model location from in/out files
    [InputSaberParams,OutputSaberValues,ModelPath,SaberModelName]=eval([IOFile,'(TempPath)']);
    if isa(ModelPath,'cell') % if using old format, update to new format
        [VarSaberParams,ConstSaberParams,OutputSaberValues,ModelPath,SaberModelName]=eval([IOFile,'(TempPath)']);
        InputSaberParams=[VarSaberParams;ConstSaberParams];
    end
    
    % file names to be created and used in co-simulation
    InitSaberFile = 'info_i.txt';	                % initialization file for Saber
    AlterSaberFile = 'alter_cmds_file.scs';		    % from ADVISOR to be read by Saber
    AdvReadFile = 'data_out.txt';                   % from saber to be read by ADVISOR
    TrigFile = 'SaberCosimTrigFile.txt';	        % dummy file used to trigger ADVISOR and Saber to go
    AimFileName='SaberCosim.aim';                 % Aim file name (file written out by this file)
    
    % Saber cosim path
    FunPath=strrep(TempPath,'tmp\','gui\SaberCosim\');% path to saber cosim functions
    
end


switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
case 0,
    tic;
    [sys,x0,str,ts]=mdlInitializeSizes(OutputSaberValues,AlterSaberFile,FunPath,ModelPath,...
        TrigFile,AimFileName,AdvStepSize,TempPath,AdvReadFile,SaberModelName,FirstCall);
    
    %%%%%%%%%%%%%%%
    % Derivatives %
    %%%%%%%%%%%%%%%
case 1,
    sys=mdlDerivatives(t,x,u);
    
    %%%%%%%%%%
    % Update %
    %%%%%%%%%%
case 2,
    sys=mdlUpdate(t,x,u);
    
    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
case 3,
    sys=mdlOutputs(t,x,u,TempPath,TrigFile,AdvStepSize,AdvReadFile,AlterSaberFile,...
        InputSaberParams,FunPath,AimFileName,StopMatlabH,length(OutputSaberValues),Secs2TimedOut);
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % GetTimeOfNextVarHit %
    %%%%%%%%%%%%%%%%%%%%%%%
case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);
    
    %%%%%%%%%%%%%
    % Terminate %
    %%%%%%%%%%%%%
case 9,
    sys=mdlTerminate(t,x,u,AlterSaberFile,AdvReadFile,TrigFile,AimFileName,TempPath,ModelPath,StopMatlabH);
    
    %%%%%%%%%%%%%%%%%%%%
    % Unexpected flags %
    %%%%%%%%%%%%%%%%%%%%
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
    
end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(OutputSaberValues,AlterSaberFile,FunPath,...
    ModelPath,TrigFile,AimFileName,AdvStepSize,TempPath,AdvReadFile,SaberModelName,FirstCall)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = length(OutputSaberValues);
sizes.NumInputs      = -1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

% initialize the initial conditions
x0  = [];

% str is always an empty matrix
str = [];

% initialize the array of sample times
ts  = [-1 0];

if FirstCall
    
    % Initialize trigger file
    fid=fopen([TempPath,TrigFile],'w');
    fprintf(fid,'this is just filler to add bytes and identify that is Sabers turn to run');
    fclose(fid);
    
    % Modify paths written to .aim script to use / instead of \
    SaberTempPath=strrep(TempPath,'\','/');
    SaberTempPath=SaberTempPath(1:length(SaberTempPath)-1);
    SaberModelPath=strrep(ModelPath,'\','/');
    SaberModelPath=SaberModelPath(1:length(SaberModelPath)-1);
    
    % Write out .aim script that controls Saber
    fid=fopen([TempPath,AimFileName],'w');
    
    % Assign Saber's list of outputs to record (siglist)
    PlotSignal=['/...'];  %  went back to all signals because it is faster, more flexible (Li & NiMH), and easier to read in .out file
    % for OutputCounter=1:length(OutputSaberValues);
    %     SaberSignal=OutputSaberValues{OutputCounter};
    %     if strcmp(SaberSignal(end),')')
    %        StartParen = strfind(SaberSignal,'(');
    %        EndParen = strfind(SaberSignal,')');
    %        ModelName=SaberSignal((StartParen+1):(EndParen-1));
    %        SignalName=SaberSignal(1:(StartParen-1));
    %        Signal=['/',ModelName,'/',SignalName,' '];
    %     else
    %        Signal=['/',OutputSaberValues{OutputCounter},' '];
    %     end       
    %     PlotSignal=[PlotSignal,Signal];
    % end
    
    fprintf(fid,'##########################################################\n');
    fprintf(fid,'#  Saber Dual Voltage Co-simulation with ADVISOR\n');
    fprintf(fid,'#\n');
    fprintf(fid,' ##########################################################\n');
    fprintf(fid,' \n');
    fprintf(fid,' global pf\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,[' ####  Script to write data output to the ',AdvReadFile,' file\n']);
    fprintf(fid,' ####  proc loads this "subroutine" into SABER memory to be called anywhere\n');
    fprintf(fid,' ####  within the main program\n');
    fprintf(fid,' ####  Joe Conover - October 1, 2001\n');
    fprintf(fid,' ########################################################################\n');
    fprintf(fid,' #\n');
    fprintf(fid,' # Select Signals of interest (read from plotfile, measure at end)\n');
    fprintf(fid,' #\n');
    fprintf(fid,' \n');
    fprintf(fid,' proc write_dataout_txt_file {} {\n');
    fprintf(fid,' \n');
    fprintf(fid,'     global pf\n');
    fprintf(fid,' \n');
    fprintf(fid,'     #########################################################################\n');
    fprintf(fid,'     ###  Get Saber outputs back to Simulink\n');
    fprintf(fid,' \n');
    fprintf(fid,'     ###  Assign values to names\n');
    for OutputCounter=1:length(OutputSaberValues)
        fprintf(fid,['     set value',num2str(OutputCounter),'_wf [pf:read $pf ',OutputSaberValues{OutputCounter},']\n']);
        fprintf(fid,['     set value',num2str(OutputCounter),' [Measure:At $value',num2str(OutputCounter),'_wf end]\n']);
        fprintf(fid,'       \n');
    end
    
    fprintf(fid,'     ###  Print to file values of names\n');
    fprintf(fid,['     set fpout [open ',SaberTempPath,'/',AdvReadFile,' w]\n']);
    for OutputCounter=1:length(OutputSaberValues)
        fprintf(fid,['     puts $fpout $value',num2str(OutputCounter),'             ; # (',num2str(OutputCounter),')\n']);
        fprintf(fid,'  \n');
    end
    fprintf(fid,'     close $fpout\n');
    fprintf(fid,' \n');
    fprintf(fid,['     ### Done writing to ',AdvReadFile,' file\n']);
    fprintf(fid,' \n');
    fprintf(fid,' } ; # Close Proc bracket\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' #########                                                     #########\n');
    fprintf(fid,' ####                     BEGIN MAIN PROGRAM                         ###\n');
    fprintf(fid,' #########                                                     #########\n');
    fprintf(fid,' ####################################################################### \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' # This sets the internal time step which saber will use. This is a first\n');
    fprintf(fid,' # approximation and can be changed later     -  JJC 7/28/00\n');
    fprintf(fid,' # VHJ 3/01 set to $e/10 and not $xe/10\n');
    fprintf(fid,' #set sabertstep [expr $e/10.0]\n');
    fprintf(fid,' set sabertstep 0.0000001\n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' # Load saber design\n');
    fprintf(fid,[' Guide:LoadDesign -design ',SaberModelPath,'/',SaberModelName,'.sin\n']);
    fprintf(fid,' console show\n');
    fprintf(fid,' \n');
    fprintf(fid,' ################################\n');
    fprintf(fid,' # Read alter commands\n');
    fprintf(fid,['Saber:Send {<',SaberTempPath,'/',AlterSaberFile,'}\n']);
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' ######               Run DC Analysis                          #########\n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' \n');
    fprintf(fid,[' Saber:Send {dc (eppfile dcpf,siglist ',PlotSignal,'}  \n']);
    fprintf(fid,' puts " DC Analysis Complete "\n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,['### Write out initial ',AdvReadFile,' file for ADVISOR to read\n']);
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #Open plotfile with results\n');
    fprintf(fid,['set pf [pf:open ',SaberModelPath,'/',SaberModelName,'.dcpf]\n']);
    fprintf(fid,' write_dataout_txt_file ; # calls sub procedure write_dataout_txt_file\n');
    fprintf(fid,' pf:close $pf\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' # Delete contents of junk.aim to signal matlab that Saber is ready\n');
    fprintf(fid,[' set chk_file [open ',SaberTempPath,'/',TrigFile,' w]\n']);
    fprintf(fid,' puts $chk_file "1"             ; # (1)\n');
    fprintf(fid,' close $chk_file\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' # This WHILE loop waits for Matlab to change the size of the trigger\n');
    fprintf(fid,' # file to anything greater than zero\n');
    fprintf(fid,' set sgt_size 0 \n');
    fprintf(fid,[' # [file size ',SaberTempPath,'/',TrigFile,']\n']);
    fprintf(fid,' while {$sgt_size <10 }  {\n');
    fprintf(fid,['     set sgt_size [file size ',SaberTempPath,'/',TrigFile,']\n']);
    fprintf(fid,' } ; # CLOSE WHILE LOOP\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' #######################################################################\n');
    fprintf(fid,' ###\n');
    fprintf(fid,' ###  Transient analysis\n');
    fprintf(fid,' ###\n');
    fprintf(fid,'  \n');
    fprintf(fid,' set i 0\n');
    fprintf(fid,' set step 0\n');
    fprintf(fid,' while {$sgt_size <100 }  {\n');
    fprintf(fid,[' set i [expr $i + ',num2str(AdvStepSize),']\n']);
    fprintf(fid,[' set step [expr $step + 1]\n']);
    fprintf(fid,' puts " Transient Step:  $i"\n');
    fprintf(fid,' \n');
    fprintf(fid,'     ################################\n');
    fprintf(fid,'     # Read alter commands\n');
    fprintf(fid,['     Saber:Send {<',SaberTempPath,'/',AlterSaberFile,'}\n']);
    fprintf(fid,' \n');
    fprintf(fid,'     # Calculate the end time\n');
    fprintf(fid,'     # Ex. i=20 & AdvStepSize=1 thus Saber will end the simulation at 19 seconds.\n');
    fprintf(fid,['     set xe [expr ($i-0)]\n']);
    fprintf(fid,'     \n');
    fprintf(fid,'     # Calculate the start time\n');
    fprintf(fid,'     # Ex. i=20 & AdvStepSize=1 thus Saber will start the simulation at 18 seconds.\n');
    fprintf(fid,['     set xs [expr ($i-',num2str(AdvStepSize),')]\n']);
    fprintf(fid,' \n');
    fprintf(fid,'     ################################\n');
    fprintf(fid,'     # Transient analysis commands\n');
    fprintf(fid,' \n');
    fprintf(fid,'     # Output file ending letters\n');
    fprintf(fid,'     set init_point "tr"\n');
    fprintf(fid,'     set end_point "tr"\n');
    fprintf(fid,'    \n');
    fprintf(fid,'     if {$step == 1 } {\n');
    fprintf(fid,'         # For first run, begin with dc file, end with tr1 file\n');
    fprintf(fid,'         set init_point "dc"\n');
    fprintf(fid,'         append end_point $step\n');
    fprintf(fid,'     } else {\n');
    fprintf(fid,'        # For other runs, begin with tr(i-1) and end eith tr(i), e.g. for i==3, begin tr2 end tr3\n');
    fprintf(fid,'        append init_point [expr $step - 1]\n');
    fprintf(fid,'        append end_point $step\n');
    fprintf(fid,'        set previous_num $end_point\n');
    fprintf(fid,'     }\n');
    fprintf(fid,' \n');
    fprintf(fid,'     #Send transient command.  Linearly ramp between engine speeds over small time step\n');
    fprintf(fid,['     Saber:Send "tr(aditer 300, density 10, dfile _,nsdensity 10,siglist ',PlotSignal,',tbegin $xs,tend $xe,terror 0.00001,tniter 30,trep $end_point,trip $init_point,tsmax 0.25,tstep $sabertstep,xsampling from $xs to $xe lin 2,zditer 1000)"\n']);
    fprintf(fid,'     \n');
    fprintf(fid,'     \n');
    fprintf(fid,'     #######################################################################\n');
    fprintf(fid,['     ### Write out initial ',AdvReadFile,' file for ADVISOR to read\n']);
    fprintf(fid,' \n');
    fprintf(fid,'     \n');
    fprintf(fid,'     #Open plotfile with results\n');
    fprintf(fid,['     set pf [pf:open ',SaberModelPath,'/',SaberModelName,'.tr]\n']);
    fprintf(fid,'     write_dataout_txt_file ; # calls sub procedure write_dataout_txt_file\n');
    fprintf(fid,'     pf:close $pf\n');
    fprintf(fid,'     \n');
    fprintf(fid,'     \n');
    fprintf(fid,'     \n');
    fprintf(fid,'     #######################################################################\n');
    fprintf(fid,'     # Delete contents of junk.aim to signal matlab that Saber is ready\n');
    fprintf(fid,['     set chk_file [open ',SaberTempPath,'/',TrigFile,' w]\n']);
    fprintf(fid,'     puts $chk_file "1"             ; # (1)\n');
    fprintf(fid,'     close $chk_file\n');
    fprintf(fid,'     \n');
    fprintf(fid,'     #######################################################################\n');
    fprintf(fid,'     # This WHILE loop waits for Matlab to change the size of the trigger\n');
    fprintf(fid,'     # file to anything greater than zero\n');
    fprintf(fid,'     set sgt_size 0\n');
    fprintf(fid,'     while {$sgt_size <10 }  {\n');
    fprintf(fid,['     set sgt_size [file size ',SaberTempPath,'/',TrigFile,']\n']);
    fprintf(fid,'     after 26\n');
    fprintf(fid,'     } ; # CLOSE WHILE LOOP\n');
    fprintf(fid,'     \n');
    fprintf(fid,'     if {$step > 2 } {\n');
    fprintf(fid,['      set old_tr_filename1 ',SaberModelName,'\n']);
    fprintf(fid,['      set old_tr_filename2 ',SaberModelName,'\n']);
    fprintf(fid,'      append old_tr_filename1 .tr\n');
    fprintf(fid,'      append old_tr_filename2 .tr\n');
    fprintf(fid,'      append old_tr_filename1 [expr $step - 2]\n');
    fprintf(fid,'      append old_tr_filename2 [expr $step - 2]\n');
    fprintf(fid,'      append old_tr_filename1 .i1\n');
    fprintf(fid,'      append old_tr_filename2 .i2\n');
    fprintf(fid,['      file delete $old_tr_filename1 ',strrep(SaberModelPath,':',''),'\n']);
    fprintf(fid,['      file delete $old_tr_filename2 ',strrep(SaberModelPath,':',''),'\n']);
    fprintf(fid,'     } ; # CLOSE IF\n');
    fprintf(fid,'     \n');
    fprintf(fid,' } ; # Close WHILE loop bracket to end Saber\n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    fprintf(fid,' exit; # Exit Saber when simulation is finished.  Errors are generated if Saber is not closed before next run.   \n');
    fprintf(fid,' \n');
    fprintf(fid,' #Revision history\n');
    fprintf(fid,' # 03/21/02: ab created from advisor_cosim_dv.aim\n');
    
    fclose(fid);
    % Done writing out .aim script
    
end % end if FirstCall



% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function [sys]=mdlOutputs(t,x,u,TempPath,TrigFile,AdvStepSize,AdvReadFile,AlterSaberFile,...
    InputSaberParams,FunPath,AimFileName,StopMatlabH,NumSaberOutputs,Secs2TimedOut)

persistent LastParamValues;

Params=InputSaberParams;

% Create a cell array that has all the variable values
ParamCounter=1;
AlterParamCounter=1;
while ParamCounter <= length(Params)
    
    % If array, place all values of array in same cell
    if ~isempty(strfind(Params{ParamCounter},'[...')) | ~isempty(strfind(Params{ParamCounter},'<-('))
        ArrayEnd=0;
        ValueString=[];
        while ArrayEnd == 0
            AdditionalString=strrep(Params{ParamCounter},'...',num2str(u(ParamCounter)));
            ValueString=[ValueString,AdditionalString];
            
            if strcmp(Params{ParamCounter}(end),']') | strcmp(Params{ParamCounter}(end),')')
                ArrayEnd=1;
            end
            ParamCounter=ParamCounter+1;
        end
    else 
        ValueString=[Params{ParamCounter},num2str(u(ParamCounter))];
        ParamCounter=ParamCounter+1;
    end
    ParamValues{AlterParamCounter}=ValueString;
    AlterParamCounter=AlterParamCounter+1;
end


% Get list of parameters that changed and thus need to be altered in Saber
if t == 0
    Params2AlterCounter=1;
    for i=1:length(ParamValues)
        if isempty(strfind(ParamValues{i},'NaN'))
            Params2Alter(Params2AlterCounter)=ParamValues(i);
            Params2AlterCounter=Params2AlterCounter+1;
        end
    end
elseif t > 0
    %   Find indices of list that have values that need to be altered (updated)
    Params2AlterIndicesRaw=find(~strcmp(LastParamValues,ParamValues));
    
    %   Remove indices assigned NaN (old method to flag variables that don't need to be updated)
    Param2AlterIndCounter=1;
    for Param2AlterIndNum=1:length(Params2AlterIndicesRaw)
        if isempty(strfind(ParamValues{Param2AlterIndNum},'NaN'))
            Params2AlterIndices(Param2AlterIndCounter)=Params2AlterIndicesRaw(Param2AlterIndNum);
            Param2AlterIndCounter=Param2AlterIndCounter+1;
        end
    end
    
    %   Assign list of parameters based on indices
    if exist('Params2AlterIndices')
        Params2Alter=ParamValues(Params2AlterIndices);
    else
        Params2Alter=[];
    end
end
LastParamValues=ParamValues;


% Print alter commands to file
fid_alter_file=fopen([TempPath,AlterSaberFile],'w');
if ~isempty(Params2Alter)
    fprintf(fid_alter_file,'alter %s\n',Params2Alter{:});
end
fclose(fid_alter_file);


% Write trigger file for Saber to go
eval('findobj(StopMatlabH);StopMatlab=0;','StopMatlab=1;')
if StopMatlab == 0
    fid=fopen([TempPath,TrigFile],'w');
    fprintf(fid,'this is just filler to add bytes and identify that is Sabers turn to run');
    fclose(fid);
else
    fid=fopen([TempPath,TrigFile],'w');
    fprintf(fid,'');
    fclose(fid);
end

% If first pass, start Saber by running .aim script
if t==0
    % Get aim.exe location
    fid=fopen([FunPath,'aimexe.txt'],'r');
    AimExeLocation=fscanf(fid,'%s');
    fclose(fid);
    
    % Begin Saber (and run DC analysis)
    evalin('base',['! ',AimExeLocation,'aim.exe -detach -c Guide:Init -withscope -name SaberGuide -script ',TempPath,AimFileName]);
end

% Wait for Saber to finish %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Saber writes out trigger file with size less than 10 bytes
file_dir=dir([TempPath,TrigFile]);
size=file_dir.bytes;
StartTime=clock;

while size > 10 
    file_dir=dir([TempPath,TrigFile]);
    size=file_dir.bytes;
    CurrentTime=clock;
    if etime(CurrentTime,StartTime) > Secs2TimedOut
        disp(['ADVISOR timed out after waiting for Saber for: ',num2str(etime(CurrentTime,StartTime)),' seconds.']);
        fid=fopen([TempPath,TrigFile],'w');
        fprintf(fid,'');
        fclose(fid);
        try
            close(StopMatlabH);
        end
    end    
    pause(.1);
end

%   Get Saber outputs for ADVISOR
try
    %saber_data=load([TempPath AdvReadFile]);
    try
        saber_data=textread([TempPath AdvReadFile]);
        SuffExists=0;
    catch
        saber_data_raw=textread([TempPath AdvReadFile],'%q');
        SuffExists=1;
    end
catch
    saber_data=zeros(NumSaberOutputs,1);
end

%   Translate Saber outputs that have multipliers
if SuffExists
    
    Suffix={'meg','1e6';...
            'mu','1e-6';...
            'me','1e6';...
            'm','1e-3';...
            'a','1e-18';...
            'f','1e-15';...
            'p','1e-12';...
            'n','1e-9';...
            'u','1e-6';...
            'k','1e-3';...
            'g','10e9';...
            't','10e12'};
    
    %   Replace suffix with '* value'
    for SuffixIndex=1:length(Suffix)
        saber_data_raw=strrep(saber_data_raw,Suffix{SuffixIndex,1},['*',Suffix{SuffixIndex,2}]);
    end
    
    for CellCounter=1:length(saber_data_raw)
        saber_data(CellCounter,1)=eval(saber_data_raw{CellCounter});
    end
    
end    

sys=saber_data;


% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u,AlterSaberFile,AdvReadFile,TrigFile,AimFileName,TempPath,ModelPath,StopMatlabH)

% Write trigger file for Saber to quit
fid=fopen([TempPath,TrigFile],'w');
fprintf(fid,'This is just filler to  identify that Sabers should quit.  Saber quits based on the size of the file this line writes');
fclose(fid);

% Close Matlab quit message box
try
    close(StopMatlabH);
end

% Clean up Saber files
ExtraFilesExtList={'*.tr*'
    '*.dc*'
    '*.ai_tdb'
    '*.tbl'};

warning off
for i=1:length(ExtraFilesExtList)
        delete([ModelPath,ExtraFilesExtList{i}])
end
warning on

% Clean up other files
% evalin('base',['delete ',TempPath,AlterSaberFile]);
% evalin('base',['delete ',TempPath,AdvReadFile]);
% evalin('base',['delete ',TempPath,TrigFile]); accel test doesn't like this
% evalin('base',['delete ',TempPath,AimFileName]);

SimTime=toc;
disp(['Total simulation time:  ',num2str(SimTime)])
sys = [];

% end mdlTerminate
