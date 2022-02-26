function ReturnOnOffData=CalcLoadOnOffData(OnOffInfo)
%   This function uses the OnOffInfo to calculate the time vs. On profile
%   The OnOffInfo includes how the load on/off is defined.  Example:  Initially on, toggle at time 200 and 500 seconds

CycleLength=evalin('base','max(cyc_mph(:,1))');
CycleStart=evalin('base','min(cyc_mph(:,1))');

if strcmp(OnOffInfo.Type,'ToggleOnOff') & ~isempty(OnOffInfo.ToggleTimes)
    ToggleTimes=OnOffInfo.ToggleTimes;
    InitialOn=OnOffInfo.InitialOn;
    
    if ToggleTimes(1) <= eps
        InitialOn=~InitialOn;
        ToggleTimes=ToggleTimes(2:length(ToggleTimes));
    end
    
    ReturnOnOffData=GetOnOffData(ToggleTimes,InitialOn,CycleLength);
        
elseif strcmp(OnOffInfo.Type,'RegularCycles')
    InitialOn=0;
    StartTime=OnOffInfo.StartTime;
    Period=OnOffInfo.Period;
    DurationOn=OnOffInfo.DurationOn;
    
    ToggleOnTimes=StartTime:Period:CycleLength;
    ToggleOffTimes=(StartTime+DurationOn):Period:CycleLength;
    ToggleTimes=sort([ToggleOnTimes,ToggleOffTimes]);
    
    if StartTime==CycleStart
        InitialOn=~InitialOn;
        ToggleTimes=ToggleTimes(2:length(ToggleTimes));
    end
    
    ReturnOnOffData=GetOnOffData(ToggleTimes,InitialOn,CycleLength);
    
else
    ReturnOnOffData=[0,OnOffInfo.InitialOn;CycleLength,OnOffInfo.InitialOn];
    
    
end

%=====================================================================================
% GetOnOffData(ToggleTimes,InitialOn)
%   This function uses ToggleTimes and InitialOn to create points to plot
%=====================================================================================
function ReturnData=GetOnOffData(ToggleTimes,InitialOn,CycleLength)

OnOffData(1,1)=0;
OnOffData(1,2)=InitialOn;
TimeDataPointNum=2;
for i=1:length(ToggleTimes)  % i is the time at which the toggle is occuring
    if ToggleTimes(i) < CycleLength
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
OnOffData(length(OnOffData(:,1))+1,1)=CycleLength;
OnOffData(length(OnOffData(:,1)),2)=OnOffData(length(OnOffData)-1,2);

ReturnData=OnOffData;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)