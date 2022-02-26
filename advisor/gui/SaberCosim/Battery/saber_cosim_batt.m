function [sys,x0,str,ts] = saber_cosim_batt(t,x,u,flag,saber_sin_name,SaberModelPath,...
    FullVars,Values,ValueInit,OutVars,end_time,tmppath,time_step)
%Names of files used in cosim communications
info_init = 'info_i.txt';	                %initialization file for Saber
alter_file = 'alter_cmds_file.scs';		    %from ADVISOR to be read by Saber
data_file = 'data_out.txt';                 %from saber to be read by ADVISOR
AdvGoTrig_file = 'advisor_go_trigger.txt';	%dummy file used to trigger ADVISOR indicating end of Saber time-step
SabGoTrig_file = 'saber_go_trigger.txt';    %dummy file used to trigger Saber indicating end of ADVISOR time-step

%Debug statements
if 0
    disp(['Time: ',num2str(t),' Flag: ',num2str(flag)])
end

switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
case 0,
    [sys,x0,str,ts]=mdlInitialize(info_init,alter_file,data_file,AdvGoTrig_file,SabGoTrig_file,...
        saber_sin_name,SaberModelPath,...
        FullVars,Values,ValueInit,OutVars,end_time,tmppath,time_step);
    
    %%%%%%%%%%
    % Update %
    %%%%%%%%%%
case 2,
    %Here, update the time stamp on the new AdvGoTrig file
    sys=mdlUpdate(t,x,u,AdvGoTrig_file,tmppath,time_step,SaberModelPath);
    
    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
case 3,
    sys=mdlOutputs(t,x,u,alter_file,data_file,AdvGoTrig_file,tmppath,time_step,SabGoTrig_file,...
        end_time,FullVars,Values);
    
    %%%%%%%%%%%%%
    % Terminate %
    %%%%%%%%%%%%%
case 9,
    sys=mdlTerminate(t,x,u,tmppath,SabGoTrig_file,SaberModelPath);
    
    %%%%%%%%%%%%%%%%%%%%
    % Unexpected flags %
    %%%%%%%%%%%%%%%%%%%%
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
    
end

%=============================================================================
% mdlInitializeSizes
%=============================================================================
function [sys,x0,str,ts]=mdlInitialize(info_init,alter_file,data_file,AdvGoTrig_file,SabGoTrig_file,...
        saber_sin_name,SaberModelPath,...
        FullVars,Values,ValueInit,OutVars,end_time,tmppath,time_step)

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 2;   % time the last advisor_go_trigger file was written, initial cputime
sizes.NumOutputs     = 41;  % current, voltages (10), SOC's (10), temps (10), thermal power (10)
sizes.NumInputs      = 2;   % requested power, last time step's requested power
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

% initialize the initial conditions
%See below (time stamp state) x0  = [];

% str is always an empty matrix
str = [];

% initialize the array of sample times
ts  = [-1 0]; % inherited time step

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization of saber runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debugVHJ=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%     Initialize File  %%%%%%
%%
% Initialization information is written into a file called info_i.txt
% This file contains the over all simulation time,
% Only write this file once at beginning of ADVISOR run
% Near the top of the ***AIM*** script, we specify 2 times:
% 1. Time step at the system level.  This is the amount of solution in time ADVISOR and
%    Saber do between exchanges of information and would be a set time step of perhaps
%    1 second or so for a drive cycle.
% 2. Total time for the job.  This is the length of the drive cycle.
fid = fopen([tmppath info_init],'wt');
fprintf(fid,'%10.2f\n', time_step);  % Step time, % ADVISOR's step time
fprintf(fid,'%10.2f\n', end_time);   % Total simulation time % total cycle time
fprintf(fid,'%s\n', saber_sin_name);      % Netlist name of file to simulate

for i=1:length(ValueInit)   %voltages, soc's, temps
    fprintf(fid,'%s\n', num2str(ValueInit(i)));
end
%Close file
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Initialize "AdvGoTrig" file            %%%%
fid = fopen([tmppath AdvGoTrig_file],'wt');
fclose(fid);
% Use the "AdvGoTrig" file to control timing for continuing the simulation.
% After SABER finishes its calculations, it will open and close this file
% without altering the file contents, thus changing the time stamp.  MATLAB
% will wait until it detects a change in time stamp then continue looping
% until the completion of the simulation.
AdvGoTrig_file_time_stamp = getfield(dir([tmppath AdvGoTrig_file]), 'date');

%Keep track of cputime for simulation run length, diplay clock time
ClockTime=clock;
ComputerTime = strcat(num2str(ClockTime(4)),':',num2str(ClockTime(5)),':',num2str(ClockTime(6)));
disp(['Begin at ', ComputerTime]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set 'initial state' to these variables used later in the output section
%need to convert date to a number to store in state vector
x0=[datenum(AdvGoTrig_file_time_stamp) cputime];	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open and edit the alter commands file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid_alter_file = fopen([tmppath alter_file],'wt');
% Values to be specified only once
% For all other time steps (e.g. other than initial time step), only power request changes
% Create saber command script file with alter commands,
%   e.g. alter lib_model.lib4/lib_rc.lib_rc1 = k = 1.0
%   strings and values found in FullVars and Value
for i=1:length(Values)
    eval(['fprintf(fid_alter_file, ''alter ' FullVars(i,:) ' = ' num2str(Values(i)) '\n'');']);
end
% Close the file
fclose(fid_alter_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Temp file signals Saber when Matlab has finished processing alter_cmds_file.scs file.
%This file is created each time ADVISOR is run.
fid = fopen([tmppath SabGoTrig_file],'wt');
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rewrite the aim script to include the 'tmp' path of all the data files 
%       and the saber path of the .sin file
%e.g. d:/val/advisor_revisions/advisor/tmp and d:/val/advisor_revisions/advisor/models/saber
tmppathAIM=strrep(tmppath,'\','/'); %replace backslashes with forward slash
tmppathAIM=tmppathAIM(1:end-1); %get rid of last slash
sabermodelpathAIM=strrep(SaberModelPath(1:end-1),'\','/'); %replace backslashes with forward slash, get rid of last slash

% Open the AIM script file
filename='advisor_cosim_ess.aim';    %this is the base file with set strings of paths
AimLocName=which(filename);
new_file='advisor_cosim.aim';       %this is a created file which the cosim calls with the user's unique paths
AimLocNameNew=strrep(AimLocName,'advisor_cosim_ess.aim','advisor_cosim.aim');
% create the advisor_cosim.aim in the gui\SaberCosim directory by backing out of the \Battery directory,
% as the gui\SaberCosim directory is used in the batch run_saber file
AimLocNameNew=strrep(AimLocNameNew,'\battery','');  
fid=fopen(filename,'r');   %open with read privledges
fid_new=fopen(AimLocNameNew,'w');   %open with write privledges

entstr=fscanf(fid,'%c'); %read in entire file to a string (%c reads spaces)
% Replace d:/val/advisor_revisions/advisor/tmp string with tmppathAIM
entstr=strrep(entstr,'d:/val/advisor_revisions/advisor/tmp',tmppathAIM);
% Replace d:/val/advisor_revisions/advisor/models/saber with sabermodelpathAIM
entstr=strrep(entstr,'d:/val/advisor_revisions/advisor/models/saber',sabermodelpathAIM);

% Replace output variable strings with OutVars
strings2replace={'CurrentString',...
        'v1String','v2String','v3String','v4String','v5String',...
        'v6String','v7String','v8String','v9String','vTenString',...
        's1String','s2String','s3String','s4String','s5String',...
        's6String','s7String','s8String','s9String','sTenString',...
        'Temp1String','Temp2String','Temp3String','Temp4String','Temp5String',...
        'Temp6String','Temp7String','Temp8String','Temp9String','TempTenString',...
        'ThermString1','ThermString2','ThermString3','ThermString4','ThermString5',...
        'ThermString6','ThermString7','ThermString8','ThermString9','ThermStringTen'};
for i=1:length(strings2replace)
    % Replace strings with OutVars
    entstr=strrep(entstr,strings2replace{i},OutVars(i,:));
end

% Print to new file
for i=1:length(entstr)-1
    fprintf(fid_new,'%s',[entstr(i)]);
end
%Close files
fclose(fid);fclose(fid_new);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Invoke Saber
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note the ! character issues a shell command to UNIX or dos.
% A DOS batch file executes the NT version of saber
% A UNIX shell script executes the UNIX version of saber
% The -script ...\advisor_cosim.aim invokes the AIM script
% The Aim script launches Saber, runs a DC analysis, and the transient analyses

if debugVHJ, disp('Invoking Saber');end
%call saber with directory, e.g. !d:\val\advisor_revisions\advisor\gui\sabercosim\run_saber
saberpath=[strrep(tmppath,'\tmp\','\gui\SaberCosim\')];   %navigate to path of run_saber.bat
evalin('base',['!',saberpath,'run_saber']);

% end mdlInitializeSizes

%=============================================================================
% mdlUpdate
%=============================================================================
function sys=mdlUpdate(t,x,u,AdvGoTrig_file,tmppath,time_step,SaberModelPath)

%The 'state' of the system is the date of the 'advisor_go_trigger' text file
AdvGoTrig_file_time_stamp = getfield(dir([tmppath AdvGoTrig_file]), 'date');

% During simulation, clean up the models directory (various .tr#)
% e.g. delete *.tr1.*
if t/time_step >= 3
    %tr files are numbered based on # of times called, so reference t/time_step
    currentPath=evalin('base','pwd');
    evalin('base',['cd ' SaberModelPath])
    evalin('base',['delete *.tr', num2str(t/time_step-2),'.*'])
    evalin('base',['cd ' currentPath])
end

%Return sys 
sys=[datenum(AdvGoTrig_file_time_stamp) x(2)];

% end mdlUpdate

%=============================================================================
% mdlOutputs
%=============================================================================
function sys=mdlOutputs(t,x,u,alter_file,data_file,AdvGoTrig_file,tmppath,time_step,SabGoTrig_file,...
    end_time,FullVars,Values)
% Main Saber co-simulation
% Data for electrical architectures is fed to Saber via a file called alter_cmds_file.scs.
% The AIM script first runs a DC analysis, and at each time it runs a transient step.
% ADVISOR edits the alter_cmds_file to change parameters in the Saber components.  
% The AIM script will look periodically at
% the "last update time" for the saber_go_trigger file and will not read the alter_cmds_file again 
% until it sees a change in the "last update time."

debugVHJ=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get values from simulink input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Variables:
ess_pwr_r=u(1);         %energy storage power request
old_pwr=u(2);           %ess power from last time step  

% Energy storage power request
% Do not specify transient command for first time call (at t=0)
if t>0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open and edit the alter commands file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid_alter_file = fopen([tmppath alter_file],'wt');
    
    if t==time_step %For first call, need to specify a small time for the ramping power command
        alpha = 0.001;
    else                %otherwise, use previous time as time for previous power
        alpha = t-time_step;
    end
    alter_cmd = strcat ('alter /c_pwl.ess_pwr_req = pwl = [0,0.1,',num2str(alpha),',',...
        num2str(old_pwr),',',num2str(t),',',num2str(ess_pwr_r),']');
    fprintf(fid_alter_file,alter_cmd);
    
    % Close the alter file
    fclose(fid_alter_file);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Temp file signals Saber when Matlab has finished processing alter_cmds_file.scs file.
    %This file is created each time ADVISOR is run.
    fid = fopen([tmppath SabGoTrig_file],'wt');
    %fprintf(fid,'Time = %s',num2str(t));
    fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Initialization function already invoked Saber.
% As Saber runs, ADV waits for updates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Wait until data_file changes before      %%%%
%%%%  reading data_file into matlab workspace  %%%%
%%%%  do this loop until time stamp changes    %%%%
if debugVHJ, 
    disp(['Saber co-simulating time step ',num2str(t),'/',num2str(end_time),', Power Req ',num2str(round(ess_pwr_r*10)/10)]);
else
    if t==0,
        disp(['Saber co-simulating']);
    elseif ~mod(t,25)
        disp([num2str(t),'/',num2str(end_time)]);
    end
end
AdvGoTrig_file_time_stamp_i=x(1);
AdvGoTrig_file_time_stamp=x(1);
while AdvGoTrig_file_time_stamp_i==AdvGoTrig_file_time_stamp
    pause(0.1);
    AdvGoTrig_file_time_stamp = datenum(getfield(dir([tmppath AdvGoTrig_file]), 'date'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in new data from saber & Pass variables of interest back to ADVISOR
% The data file contains current, voltage, temperature, and thermal power
% Saber creates a single column of data in data_out.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sys=load([tmppath data_file]);

% end mdlOutputs

%=============================================================================
% mdlTerminate
%=============================================================================
function sys=mdlTerminate(t,x,u,tmppath,SabGoTrig_file,SaberModelPath)

%Temp file signals Saber when Matlab has finished
%processing alter_cmds_file.txt file. This file is created each time ADVISOR is run.
fid = fopen([tmppath SabGoTrig_file],'wt');
cpuTimePrev=x(2);
cpuTimeNow=cputime;
ClockTime=clock;
ElapTime=cpuTimeNow-cpuTimePrev;
ComputerTime = strcat(num2str(ClockTime(4)),':',num2str(ClockTime(5)),':',num2str(ClockTime(6)));
disp(['End at ',num2str(ComputerTime),' Total Sim Time: ',num2str(ElapTime)]);
fclose(fid);

%Clean up remaining files
currentPath=evalin('base',['pwd']);
evalin('base',['cd ' SaberModelPath])
evalin('base',['delete *.tr*'])
evalin('base',['delete *.dc*'])
try, evalin('base',['delete *.tbl']),catch,end
%try, evalin('base',['delete *.out']),catch,end 
evalin('base',['cd ' currentPath])

sys = [];

% Note: if Saber fails to converge, cancel (Control-C) matlab's processing, and check results by typing
% >> gui_post_process;ResultsFig 
% at the command prompt

% end mdlTerminate

%%%%%%%%%%%%%%%%%%
% Revision notes
% 12/21/01: vhj file created using saber_cosim_sv.m as a base
% 01/03/02: vhj create the advisor_cosim.aim in the gui\SaberCosim directory by backing out of the \Battery directory,
%               as the gui\SaberCosim directory is used in the batch run_saber file,
%               only one state variable (time stamp), add old power request
% 01/04/02: vhj removed extraneous code
% 01/07/02: vhj change to saber model directory and back when deleting files (in terminate and update calls)
% 01/07/02: vhj replace hard-coded output variable names with strings to be replaced when
%               creating advisor_cosim.aim, display status every 25 seconds
% 01/08/02: vhj cleaned up code, added cpu time to the state, e.g. x(2), add pause(0.1) in while loop (speeds up cosim)
% 02/15/02: vhj replaced ResultsFigControl to ResultsFig