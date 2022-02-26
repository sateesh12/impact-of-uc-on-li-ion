function [out, cs] = effAsFuncOfPwrModelMaker(emArray, names, pwrPts, queriesPerPwrCurve, order, plotFlag, bendCurveCorrectFlag)
% [out, cs] = effAsFuncOfPwrModelMaker(emArray, names, pwrPts, queriesPerPwrCurve, order, plotFlag, bendCurveCorrectFlag)
% effAsFuncOfPwrModelMaker
% Efficiency as a Function of Output Power Model Making function
% 
% emArray is the eng_map or eng_map array to process
% names is name of the eng_map [optional]
% pwrPts are the normalized power points to examine [0<-->1] [optional]
% queriesPerPwrCurve is the number of points to examine on a power curve
% order is the order of the exponential fit
% plotFlag tells whether to plot or not
% bendCurveCorrectFlag is the flag to bend the curve or not (?)
%
% the output structure yields regular or normalized results. They give the
% coefficients to a polynomial fit to the average, maximum, and minimum
% efficiencies per a given power point (power in watts).
%
% the cs (compilation structure) structure is given only if emArray is an
% array
for emArrayCnt=1:length(emArray)
    em=emArray(emArrayCnt);
    
    if ~exist('pwrPts','var')
        pwrPts=[0.1:0.1:1];
    end
    
    if ~exist('names','var')|(length(names)~=length(emArray))
        names(1:length(emArray))={'Not Specified'};
    end
    
    if ~exist('queriesPerPwrCurve','var')
        queriesPerPwrCurve=10;
    end
    
    if ~exist('order','var')
        if queriesPerPwrCurve>=10
            tmp=9;
        else
            tmp=queriesPerPwrCurve-1;
            if tmp<1
                tmp=1;
            end
        end
        order=[tmp tmp];
    end
    
    if ~exist('plotFlag','var')
        plotFlag=1;
    end
    
    if ~exist('bendCurveCorrectFlag','var')
        bendCurveCorrectFlag=0;
    end
    
    if length(order)==1
        order=[order order];
    end
    
    pwrPts=sort(pwrPts); % make sure it is increasing
    
    [T,w]=meshgrid(em.map_trq,em.map_spd);
    map_pwr=T.*w;
    
    pwrArray = [];
    effArray = [];
    
    spdMax = max(em.map_spd); % maximum speed
    spdMin = min(em.map_spd); % minimum speed
    pwrAtMaxTrq = em.max_trq.*em.map_spd; % the maximum torque of the engine
    pwrMax = max(pwrAtMaxTrq); % the maximum power in watts given out by the engine
    maxTrqMonoIndex=length(pwrAtMaxTrq); % up to this index, pwr at max. torque is monotonically increasing
    for i=1:(length(pwrAtMaxTrq)-1)
        if pwrAtMaxTrq(i+1)<=pwrAtMaxTrq(i);
            maxTrqMonoIndex=i;
            break;
        end
    end
    
    plotInfo=[];
    index=1;
    for i=1:length(pwrPts)
        constPwr = pwrPts(i)*pwrMax; % the line of constant power we will try and sample
        pwrArray(index)=constPwr;
        onePtPwrArray(i)=constPwr;
        if constPwr>max(pwrAtMaxTrq)
            effArray(index)=NaN;
            maxEffArray(i)=NaN;
            minEffArray(i)=NaN;
            continue;
        elseif constPwr<=0
            effArray(index)=NaN;
            maxEffArray(i)=NaN;
            minEffArray(i)=NaN;
            continue;
        elseif constPwr<=min(pwrAtMaxTrq)    % find the speed where the constant power curve crosses the max torque curve
            spdStart=min(em.map_spd); % the constant power curve doesn't reach the max. torque curve at lowest speed but we want to stay in the "square of data points" 
        else
            spdStart=interp1(pwrAtMaxTrq(1:maxTrqMonoIndex), em.map_spd(1:maxTrqMonoIndex), constPwr);
        end
        bendSpd=constPwr^0.5; % this is speed where the constant power curve intersects the y=x line
        
        % spdi are the sample speeds to query the power curve on
        if bendCurveCorrectFlag
            if (bendSpd>min(em.map_spd))&(bendSpd<max(em.map_spd))
                spdi=linspace(spdStart,bendSpd, queriesPerPwrCurve)'; % make a number of equal spaced points to the bend--column vector
                spdi=[spdi; linspace(bendSpd, max(em.map_spd), queriesPerPwrCurve)'];
                spdi=[spdi(1:queriesPerPwrCurve); spdi(queriesPerPwrCurve+2:end)]; % remove the duplicate point
            elseif bendSpd<=min(em.map_spd)
                spdi=linspace(spdStart,max(em.map_spd),queriesPerPwrCurve*2-1)'; 
            elseif bendSpd>=max(em.map_spd)
                spdi=linspace(spdStart,max(em.map_spd),queriesPerPwrCurve*2-1)';
            end
        else
            spdi=linspace(spdStart,max(em.map_spd),queriesPerPwrCurve*2-1)';
        end
        
        for j=1:length(spdi)
            pwrArray(index)=constPwr;
            effArray(index)=interp(em,spdi(j),constPwr/spdi(j));
            index=index+1;
        end    
        if plotFlag
            plotInfo{i}=spdi;
        end
        
        onePtPwrArray(i)=constPwr;
        maxEffArray(i)=max(effArray(find(pwrArray==constPwr)));
        minEffArray(i)=min(effArray(find(pwrArray==constPwr)));
    end
    
    I = find(~isnan(effArray));
    pwrArray=pwrArray(I);
    effArray=effArray(I);
    I = find(~isnan(maxEffArray));
    onePtPwrArray=onePtPwrArray(I);
    maxEffArray=maxEffArray(I);
    minEffArray=minEffArray(I);
    
    nPwrArray=pwrArray/pwrMax;
    nOnePtPwrArray=onePtPwrArray/pwrMax;
    nEffArray=effArray/max(effArray);
    nMaxEffArray=maxEffArray/max(effArray);
    nMinEffArray=minEffArray/max(effArray);
    
    % regular
    [coef,S,MU]=polyfit(pwrArray,effArray,order(1));
    [maxCoef,maxS]=polyfit(onePtPwrArray,maxEffArray,order(2));
    [minCoef,minS]=polyfit(onePtPwrArray,minEffArray,order(2));
    % normalized
    [nCoef,nS,nMU]=polyfit(nPwrArray,nEffArray,order(1));
    [nMaxCoef,nMaxS]=polyfit(nOnePtPwrArray,nMaxEffArray,order(2));
    [nMinCoef,nMinS]=polyfit(nOnePtPwrArray,nMinEffArray,order(2));
    
    
    % [coef, MU, pwrArray, effArray, nCoef, nMU, nPwrArray, nEffArray]
    
    % make output structure
    out(emArrayCnt).reg.ave.coef=coef;
    out(emArrayCnt).reg.ave.MU=MU;
    out(emArrayCnt).reg.ave.pwrArray=pwrArray;
    out(emArrayCnt).reg.ave.effArray=effArray;
    out(emArrayCnt).reg.max.coef=maxCoef;
    out(emArrayCnt).reg.max.pwrArray=onePtPwrArray;
    out(emArrayCnt).reg.max.effArray=maxEffArray;
    out(emArrayCnt).reg.min.coef=minCoef;
    out(emArrayCnt).reg.min.pwrArray=onePtPwrArray;
    out(emArrayCnt).reg.min.effArray=minEffArray;
    
    out(emArrayCnt).norm.ave.coef=nCoef;
    out(emArrayCnt).norm.ave.MU=nMU;
    out(emArrayCnt).norm.ave.pwrArray=nPwrArray;
    out(emArrayCnt).norm.ave.effArray=nEffArray;
    out(emArrayCnt).norm.max.coef=nMaxCoef;
    out(emArrayCnt).norm.max.pwrArray=nOnePtPwrArray;
    out(emArrayCnt).norm.max.effArray=nMaxEffArray;
    out(emArrayCnt).norm.min.coef=nMinCoef;
    out(emArrayCnt).norm.min.pwrArray=nOnePtPwrArray;
    out(emArrayCnt).norm.min.effArray=nMinEffArray;
    
    if plotFlag
        figure,plot(out(emArrayCnt).norm.ave.pwrArray, out(emArrayCnt).norm.ave.effArray, 'ro'), hold on
        title(['Normalized Efficiency versus Normalized Power for ',names{emArrayCnt}])
        xlabel('Normalized Power [Pi/Pmax]')
        ylabel('Normalized Efficiency [effi/effpeak]')
        x=linspace(min(pwrPts),max(pwrPts),100);
        plot(x,polyval(out(emArrayCnt).norm.ave.coef,x,[],out(emArrayCnt).norm.ave.MU),'pk-')    
        plot(x,polyval(out(emArrayCnt).norm.max.coef,x),'pb-')
        plot(x,polyval(out(emArrayCnt).norm.min.coef,x),'pm-')
        plot(em,'radps'), hold on
        for i=1:length(plotInfo)
            if ~isempty(plotInfo{i})
                plot(plotInfo{i},pwrPts(i)*pwrMax./plotInfo{i},'ro-')
                plot(plotInfo{i},plotInfo{i},'k-')
            end
        end
        plot(em,'rpm'), hold on
        for i=1:length(plotInfo)
            if ~isempty(plotInfo{i})
                plot(plotInfo{i}*30/pi,pwrPts(i)*pwrMax./plotInfo{i},'ro-')
            end
        end
    end
    clear plotInfo;
end

if length(emArray)>1
    % Compilation Structure
    cs.norm.ave.pwrArray=[];
    cs.norm.ave.effArray=[];
    cs.norm.max.pwrArray=[];
    cs.norm.max.effArray=[];
    cs.norm.min.pwrArray=[];
    cs.norm.min.effArray=[];
    for i=1:length(out)
        cs.norm.ave.pwrArray=[cs.norm.ave.pwrArray, out(i).norm.ave.pwrArray];
        cs.norm.ave.effArray=[cs.norm.ave.effArray, out(i).norm.ave.effArray];
        cs.norm.max.pwrArray=[cs.norm.max.pwrArray, out(i).norm.max.pwrArray];
        cs.norm.max.effArray=[cs.norm.max.effArray, out(i).norm.max.effArray];
        cs.norm.min.pwrArray=[cs.norm.min.pwrArray, out(i).norm.min.pwrArray];
        cs.norm.min.effArray=[cs.norm.min.effArray, out(i).norm.min.effArray];
    end
    [cs.norm.ave.pwrArray, I]=sort(cs.norm.ave.pwrArray);
    cs.norm.ave.effArray=cs.norm.ave.effArray(I);
    [cs.norm.max.pwrArray, I]=sort(cs.norm.max.pwrArray);
    cs.norm.max.effArray=cs.norm.max.effArray(I);
    [cs.norm.min.pwrArray, I]=sort(cs.norm.min.pwrArray);
    cs.norm.min.effArray=cs.norm.min.effArray(I);
    
    [nCoef,       nS,    nMU]=polyfit(cs.norm.ave.pwrArray, cs.norm.ave.effArray, order(1));
    [nMaxCoef, nMaxS, nMaxMU]=polyfit(cs.norm.max.pwrArray, cs.norm.max.effArray, order(2));
    [nMinCoef, nMinS, nMinMU]=polyfit(cs.norm.min.pwrArray, cs.norm.min.effArray, order(2));

    cs.norm.ave.coef=nCoef;
    cs.norm.ave.MU=nMU;
    cs.norm.max.coef=nMaxCoef;
    cs.norm.max.MU=nMaxMU;
    cs.norm.min.coef=nMinCoef;
    cs.norm.min.MU=nMinMU;
    if plotFlag
        figure,plot(cs.norm.ave.pwrArray, cs.norm.ave.effArray, 'ro'), hold on
        title(['Normalized Efficiency versus Normalized Power for Compilation of All Engines'])
        xlabel('Normalized Power [Pi/Pmax]')
        ylabel('Normalized Efficiency [effi/effpeak]')
        x=linspace(min(pwrPts),max(pwrPts),100);
        plot(x,polyval(cs.norm.ave.coef,x,[],cs.norm.ave.MU),'pk-')    
        plot(x,polyval(cs.norm.max.coef,x,[],cs.norm.max.MU),'pb-')    
        plot(x,polyval(cs.norm.min.coef,x,[],cs.norm.min.MU),'pm-')    
    end    
else
    cs = NaN;
end