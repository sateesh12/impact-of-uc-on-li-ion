function AuxControlFigControl(option1,option2)
% function AuxControlFigControl(option1)
%   This function controls the AuxControlFig
%   Basic Functionality
%       Allows user to defined load on/off states during the cycle
%       Sends on/off info to aux loads block in fuel converter block in simulink
%   AuxControlFig can be modified by using Guide.  **NOTE**: Use snap to grid and grid spacing=10


global vinf

%   Open and initialize if figure is not open
if isempty(findobj('tag','AuxControlFig'))
    AuxControlFigHandle=AuxControlFig;
    set(gcf,'windowstyle','modal');
   
    %   Center figure on the screen
    center_figure(AuxControlFigHandle);
    
    %   set everything normalized 
    h=findobj(AuxControlFigHandle,'type','uicontrol');
    g=findobj(AuxControlFigHandle,'type','axes');
    set([h; g],'units','normalized');    

    
    %   Figure setup
    XLabel('Time (s)','FontWeight','bold');
    YLabel('On: 1   Off: 0','FontWeight','bold');
    CycleLength=evalin('base','max(cyc_mph(:,1))');
    axis([0 CycleLength -.5 1.5]);
    title([option1,' On/Off Profile'],'FontWeight','bold','FontSize',12);
    set(gcf,'userdata',option1);  % store loadname in userdata
    
    %   Restore figure info
    OnOffInfo=get(findobj('tag',[option1,'.Control']),'userdata');
    if strcmp(OnOffInfo.Type,'ToggleOnOff');
        set(findobj('tag','InitiallyOn'),'value',OnOffInfo.InitialOn);
        set(findobj('tag','ToggleTimes'),'string',num2str(OnOffInfo.ToggleTimes));
        AuxControlFigControl('ToggleOnOff');
    elseif strcmp(OnOffInfo.Type,'RegularCycles')
        set(findobj('tag','StartTime'),'string',num2str(OnOffInfo.StartTime));
        set(findobj('tag','OnFrequency'),'string',num2str(OnOffInfo.Period));
        set(findobj('tag','DurationOn'),'string',num2str(OnOffInfo.DurationOn));
        AuxControlFigControl('RegularCycles');
    end
    
    %   Set figure visible
    set(AuxControlFigHandle,'visible','on');
    
    %AuxControlFigControl('ToggleTimes');
    
end


if nargin > 0
    switch option1
        
    case 'ToggleOnOff'
        set(findobj('tag','ToggleOnOff'),'value',1);
        set(findobj('tag','RegularCycles'),'value',0);
        
        set(findobj('tag','ToggleTimes'),'enable','on');
        set(findobj('tag','ToggleOnOffText'),'enable','on');
        set(findobj('tag','InitiallyOn'),'enable','on');
        set(findobj('tag','StartTime'),'enable','off');
        set(findobj('tag','OnFrequency'),'enable','off');
        set(findobj('tag','DurationOn'),'enable','off');
        set(findobj('tag','RegularIntervalsText'),'enable','off');
        
        AuxControlFigControl('ToggleTimes');
        
        
    case 'RegularCycles'
        set(findobj('tag','RegularCycles'),'value',1);
        set(findobj('tag','ToggleOnOff'),'value',0);
        
        set(findobj('tag','ToggleTimes'),'enable','off');
        set(findobj('tag','ToggleOnOffText'),'enable','off');
        set(findobj('tag','InitiallyOn'),'enable','off');
        set(findobj('tag','StartTime'),'enable','on');
        set(findobj('tag','OnFrequency'),'enable','on');
        set(findobj('tag','DurationOn'),'enable','on');
        set(findobj('tag','RegularIntervalsText'),'enable','on');
        
        AuxControlFigControl('OnFrequency');
        
        
    case 'ToggleTimes'
        
        ToggleTimesString=get(findobj('tag','ToggleTimes'),'string');
        if ~isempty(ToggleTimesString)
            if isempty(str2num(ToggleTimesString)) 
                ToggleTimes=0;
                warndlg('Must Enter Values');
                set(findobj('tag','ToggleTimes'),'string','0');
            else
                ToggleTimes=str2num(ToggleTimesString);
            end
            ToggleTimes=sort(ToggleTimes);
        else
            ToggleTimes=[];
        end
        
        InitialOn=get(findobj('tag','InitiallyOn'),'value');
        
        cla;
        
        Info.Type='ToggleOnOff';
        Info.ToggleTimes=ToggleTimes;
        Info.InitialOn=InitialOn;
        
        OnOffData=CalcLoadOnOffData(Info);
        evalin('base','line(cyc_mph(:,1),cyc_mph(:,2)/max(cyc_mph(:,2)),''color'',[.8 .8 .8])');
        line(OnOffData(:,1),OnOffData(:,2));
        %PlotIt(InitialOn,ToggleTimes);
        
        
        
    case {'OnFrequency';'DurationOn';'StartTime'}
            
        OnFrequencyString=get(findobj('tag','OnFrequency'),'string');
        DurationOnString=get(findobj('tag','DurationOn'),'string');
        StartTimeString=get(findobj('tag','StartTime'),'string');
        
        %   If inputs are good, plot or update vinf
        GoodInputs=CheckRegIntervalInputs(OnFrequencyString,DurationOnString,StartTimeString);
        if GoodInputs == 1
            %ToggleTimes=GetRegIntervalToggleTimes(str2num(OnFrequencyString),str2num(DurationOnString),str2num(StartTimeString));
            %InitialOn=0;
            cla;
            
            %PlotIt(InitialOn,ToggleTimes);
            Info.Type='RegularCycles';
            Info.StartTime=str2num(StartTimeString);
            Info.DurationOn=str2num(DurationOnString);
            Info.Period=str2num(OnFrequencyString);
            OnOffData=CalcLoadOnOffData(Info);
            evalin('base','line(cyc_mph(:,1),cyc_mph(:,2)/max(cyc_mph(:,2)),''color'',[.8 .8 .8])');
            line(OnOffData(:,1),OnOffData(:,2));
        end
        
        
    case 'InitiallyOn'
        if get(findobj('tag','ToggleTimes'),'value') == 1
            AuxControlFigControl('ToggleOnOff');
        elseif get(findobj('tag','RegularCycles'),'value') == 1
            AuxControlFigControl('RegularIntervals');
        end
        
    case {'Back','Done'}
        LoadName=get(gcf,'userdata');
        
        OnFrequencyString=get(findobj('tag','OnFrequency'),'string');
        DurationOnString=get(findobj('tag','DurationOn'),'string');
        StartTimeString=get(findobj('tag','StartTime'),'string');
        GoodInputs=CheckRegIntervalInputs(OnFrequencyString,DurationOnString,StartTimeString);
        
        if (get(findobj('tag','RegularCycles'),'value') == 1)  &  (GoodInputs == 1)
            ToggleTimes=GetRegIntervalToggleTimes(str2num(OnFrequencyString),str2num(DurationOnString),str2num(StartTimeString));
            Info.Type='RegularCycles';
            Info.StartTime=str2num(StartTimeString);
            Info.DurationOn=str2num(DurationOnString);
            Info.Period=str2num(OnFrequencyString);
            set(findobj('tag',[LoadName,'.Control']),'userdata',Info);
            
            %UpdateVinf(ToggleTimes,InitialOn);
        else
            ToggleTimesString=get(findobj('tag','ToggleTimes'),'string');
            if ~isempty(ToggleTimesString)
                if isempty(str2num(ToggleTimesString)) 
                    ToggleTimes=0;
                    warndlg('Must Enter Values');
                    set(findobj('tag','ToggleTimes'),'string','0');
                else
                    ToggleTimes=str2num(ToggleTimesString);
                end
                ToggleTimes=sort(ToggleTimes);
            else
                ToggleTimes=[];
            end
            Info.Type='ToggleOnOff';
            Info.InitialOn=get(findobj('tag','InitiallyOn'),'value');
            Info.ToggleTimes=ToggleTimes;
            
            set(findobj('tag',[LoadName,'.Control']),'userdata',Info);
            %UpdateVinf(ToggleTimes,InitialOn);
        end
        
        close(gcf);
        
        if ~strcmp(LoadName,'AllLoads')
            AuxLoadsFigControl('VehType',findobj('tag',[LoadName,'.VehType'])); % update average power
        else
            assignin('base','AuxAllLoadsControl',1);
        end
        
    case 'Help'
    load_in_browser('aux_loads_help3.html');
        
    case 'Cancel'
        close(gcf);
        
        
        
    end % end switch option1
    
end % end nargin>0


%==========================================================================================
% function Good=CheckRegIntervalInputs;
%   This function checks if all the inputs to defined regular interval On/Off cycles are 
%   good.
%==========================================================================================
function Good=CheckRegIntervalInputs(OnFrequencyString,DurationOnString,StartTimeString)

%   If all inputs are not empty
if ~isempty(OnFrequencyString)...
        & ~isempty(DurationOnString)...
        & ~isempty(StartTimeString)
    
    OnFrequencyNum=str2num(OnFrequencyString);
    DurationOnNum=str2num(DurationOnString);
    StartTimeNum=str2num(StartTimeString);
    
    %   And all inputs are valid
    if ~isempty(OnFrequencyNum)...
            & ~isempty(DurationOnNum)...
            & ~isempty(StartTimeNum)...
            & (length(OnFrequencyNum) == 1)...
            & (length(DurationOnNum) == 1)...
            & (length(StartTimeNum) == 1)
        Good=1;
    else
        warndlg('Must Enter Positive Single Value','Input Error','modal');
        Good=0;
    end
else
    Good=0;
end




%==========================================================================================
% function UpdateVinf(ToggleTimes,InitialOn);
%   This function defines vinf.SaberAuxLoads.UserDefined.'LoadName'.OnOffData
%==========================================================================================
function UpdateVinf(ToggleTimes,InitialOn);

global vinf


if isempty(ToggleTimes)
    eval(['vinf.AuxLoads.',get(gcf,'userdata'),'.OnOffData=[0,InitialOn];']);
else
    
    if ToggleTimes(1) <= eps
        InitialOn=~InitialOn;
        ToggleTimes=ToggleTimes(2:length(ToggleTimes));
    end
    
    OnOffData(1,1)=0;
    OnOffData(1,2)=InitialOn;
    TimeDataPointNum=2;
    for i=1:length(ToggleTimes)  % i is the time at which the toggle is occuring
        OnOffData(TimeDataPointNum,1)=ToggleTimes(i)-eps;
        OnOffData(TimeDataPointNum,2)=OnOffData(TimeDataPointNum-1,2);
        
        TimeDataPointNum=TimeDataPointNum+1;
        OnOffData(TimeDataPointNum,1)=ToggleTimes(i);
        
        if OnOffData(TimeDataPointNum-1,2)==1
            OnOffData(TimeDataPointNum,2)=0;
        else
            OnOffData(TimeDataPointNum,2)=1;
        end
        
        TimeDataPointNum=TimeDataPointNum+1;
    end
    
end
if ~exist('OnOffData')
    OnOffData(1,1)=0;
    OnOffData(1,2)=InitialOn;
end

LoadName=get(gcf,'userdata');
set(findobj('tag',[LoadName,'.Control']),'userdata',OnOffData);
%eval(['vinf.AuxLoads.',get(gcf,'userdata'),'.OnOffData=OnOffData;']);


%===============================================================================================
% GetRegIntervalToggleTimes(OnFreq,DurationOn,StartTime)
%   This function plots a line at 1 or 0 toggling at "SwitchTimes" Starting at InitialOn(1 or 0)
%===============================================================================================
function ReturnToggleTimes=GetRegIntervalToggleTimes(OnFreq,DurationOn,StartTime)

CycleLength=evalin('base','max(cyc_mph(:,1))');

if DurationOn > OnFreq
    ToggleTimes=StartTime;
else
    ToggleOnTimes=StartTime:OnFreq:CycleLength;
    counter=1;
    for i=1:length(ToggleOnTimes)
        ToggleTimes(counter)=ToggleOnTimes(i);
        counter=counter+1;
        ToggleTimes(counter)=ToggleOnTimes(i)+DurationOn;
        counter=counter+1;
    end
end

ReturnToggleTimes=ToggleTimes;

%===============================================================================================
% PlotIt(InitialOn,SwitchTimes)
%   This function plots a line at 1 or 0 toggling at "SwitchTimes" Starting at InitialOn(1 or 0)
%===============================================================================================
function PlotIt(InitialOn,SwitchTimes)

evalin('base','line(cyc_mph(:,1),cyc_mph(:,2)/max(cyc_mph(:,2)),''color'',[.8 .8 .8])');
CurrentAxes=axis;
CycleLength=evalin('base','max(cyc_mph(:,1))');
CycleStart=evalin('base','min(cyc_mph(:,1))');

y(1)=InitialOn;
x(1)=CycleStart;

if ~isempty(SwitchTimes)
    counter=2;
    for i=1:length(SwitchTimes)
        x(counter)=SwitchTimes(i)-eps;
        y(counter)=y(counter-1);
        counter=counter+1;
        
        x(counter)=SwitchTimes(i);
        y(counter)=~y(counter-1);
        counter=counter+1;
    end
    
    x(counter)=CycleLength;
    y(counter)=y(counter-1);
    
else
    x(2)=CycleLength;
    y(2)=y(1);
end

line(x,y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)
