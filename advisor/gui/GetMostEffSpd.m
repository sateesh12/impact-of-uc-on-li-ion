function MostEffSpd=GetMostEffSpd(Pwr,SpdMap,TrqMap,EffMap,MaxTrq,Plot)
%   MostEffSpd=GetMostEffSpd(Pwr,SpdMap,TrqMap,EffMap,MaxTrq,Plot)
%
%   This function finds the most efficient Spd and Trq for the Pwr
%   constrained by the MaxTrq.  If the Pwr is higher than any Spd
%   Trq combination, the Spd cooresponding to the highest Trq Spd
%   combination is returned.  For a constant efficiency map, the 
%   lowest spd that can meet the Pwr below the MaxTrq is returned.
%   
%   To turn off plotting, set varargin=0

%   Get spd indices that can provide Pwr without exceeding MaxTrq
warning off
GoodSpdInd=find((SpdMap > 0) & ((Pwr./SpdMap) < MaxTrq));
warning on
NZSpdInd=find(SpdMap > 0);

if ~isempty(GoodSpdInd)
    
    GoodSpd=[];
    
    %   Get min spd that can achieve Pwr staying under max trq curve
    FirstGoodSpdInd=GoodSpdInd(1);
    PreFirstGoodSpdInd=FirstGoodSpdInd-1;
    if (FirstGoodSpdInd > 1)  &  (SpdMap(PreFirstGoodSpdInd) ~= 0) 
        
        FirstCrossOverMaxTrqs=MaxTrq(PreFirstGoodSpdInd:FirstGoodSpdInd);
        FirstCrossOverSpds=SpdMap(PreFirstGoodSpdInd:FirstGoodSpdInd);
        FirstCrossOverMaxPwrs=FirstCrossOverMaxTrqs.*FirstCrossOverSpds;
                
        LowestGoodSpd=interp1(FirstCrossOverMaxPwrs,FirstCrossOverSpds,Pwr);
        
        GoodSpd(1)=LowestGoodSpd;
    end
    
    GoodSpd=[GoodSpd SpdMap(GoodSpdInd)];
    
    %   Get max spd that can achieve Pwr staying under max trq curve
    LastGoodSpdInd=GoodSpdInd(end);
    PostLastGoodSpdInd=LastGoodSpdInd+1;
    if (LastGoodSpdInd < length(SpdMap))
        
        LastCrossOverMaxTrqs=MaxTrq(LastGoodSpdInd:PostLastGoodSpdInd);
        LastCrossOverSpds=SpdMap(LastGoodSpdInd:PostLastGoodSpdInd);
        LastCrossOverMaxPwrs=LastCrossOverMaxTrqs.*LastCrossOverSpds;
        
        HiGoodSpd=interp1(LastCrossOverMaxPwrs,LastCrossOverSpds,Pwr);
        
        GoodSpd=[GoodSpd HiGoodSpd];
    end
    
    GoodTrq=Pwr./GoodSpd;
    
    Eff=interp2(SpdMap,TrqMap,EffMap',GoodSpd,GoodTrq);
    
    [BestEff,BestSpdInd]=max(Eff);
    
    MostEffSpd=GoodSpd(BestSpdInd);
    MostEffTrq=Pwr/MostEffSpd;
    
else % pick max power point (on MaxTrq)
    HighestPwrs=SpdMap.*MaxTrq;
    [HighestPwr,HighestPwrInd]=max(HighestPwrs);
    
    MostEffSpd=SpdMap(HighestPwrInd);
    MostEffTrq=MaxTrq(HighestPwrInd);
    BestEff=interp2(SpdMap,TrqMap,EffMap',MostEffSpd,MostEffTrq);
end
    

%   Display
if Plot
    %   Create figure if it doesn't exist
    DispHandle=findobj('tag','GenOpPtFig');
    if isempty(DispHandle)
        DispHandle=figure;
        set(DispHandle,'numbertitle','off',...
            'name','Generator Operating Point',...
            'tag','GenOpPtFig');
        axes
    end
    
    figure(DispHandle);
    
    cla;
    surfc(SpdMap,TrqMap,EffMap')
    hold on
    
    if exist('GoodSpd') & exist('GoodTrq')
        %   Plot good spd-trq curve (meet all constraints and provide pwr)
        line(GoodSpd,GoodTrq,(Eff+.005));
    end
    
    %   Plot most eff good spd-trq point
    line(MostEffSpd,MostEffTrq,BestEff+.005,'marker','*','markersize',10);
    
    %   Get good max trq points (spd ~=0 at that trq)
    GoodMaxTrqCounter=1;
    for SpdMapCounter=1:length(SpdMap)
        if (SpdMap(SpdMapCounter) ~= 0) & (MaxTrq(SpdMapCounter) ~= 0)
            GoodMaxTrqInd(GoodMaxTrqCounter)=SpdMapCounter;
            GoodMaxTrqCounter=GoodMaxTrqCounter+1;
        end
    end
    
    %   Plot max trq curve
    line(SpdMap(GoodMaxTrqInd),MaxTrq(GoodMaxTrqInd),interp2(SpdMap,TrqMap,EffMap',SpdMap(GoodMaxTrqInd),MaxTrq(GoodMaxTrqInd))+.005,...
        'marker','x','markersize',8,...
        'color','black',...
        'linewidth',2);
    
    if exist('GoodSpd') & exist('GoodTrq')
        legend('GC Eff For FC Pwr Setpt','Best GC Pt','Max Trq');
    else
        legend('Best GC Pt','Max Trq');
    end
    
    title(['Eff: ',num2str(round(100*BestEff)),' %   Trq: ',num2str(round(MostEffTrq)),' N*m   Spd: ',num2str(round(MostEffSpd)),' rad/s']);
    
    xlim([min(SpdMap),max(SpdMap)]);
    ylim([min(TrqMap),max(TrqMap)]);
    zlim([0,1]);
    
    xlabel('Speed (rad/s)');
    ylabel('Torque (N*m)');
    zlabel('Efficiency');
    
end