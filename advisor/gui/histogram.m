function [hist,fhandle,posMean,negMean,totMean]=histogram(data, diffTime, binSize, maxBin, minBin, plotFlag)
% function [hist, fhandle,posMean,negMean,totMean]=histogram(data, diffTime, binSize, max, min, plotFlag)
% given a vector of data and times/weights for the data, binSize, max value
% and min value, a structure with histogram info, hist, will be returned
% fhandle is a figure handle and plotFlag says whether you want a plot or
% not. posMean, negMean, and totMean are the means of the data over
% positive, negative, and total regions
%
% hist.bin, hist.time, hist.percentageTime

try
    fhandle=[];
    if isempty(diffTime)
        diffTime = ones(size(data));
    end
    
    %binSize=10000; % 10 kW size
    
    minData=min(data);
    if minData<minBin % limit in case we have more than a megawatt
        minData=minBin;
    end
    numNeg=floor(abs(minData)/binSize)+(mod(abs(minData),binSize)>0);
    
    maxData=max(data);
    if maxData>maxBin % limit in case we have a divide by eps--more than a megawatt
        maxData=maxBin;
    end
    numPos=floor(abs(maxData)/binSize)+(mod(abs(maxData),binSize)>0);
    
    negArray=[];
    posArray=[];
    for i=1:numNeg % the extra "+1" is for the zero bin
        negArray(i,:)=[-binSize*(i-1), -binSize*(i)];
    end
    for i=1:numPos
        posArray(i,:)=[binSize*(i-1), binSize*(i)];
    end
    
    negArray=flipud(fliplr(negArray));
    
    % make sure 0 isn't included in the last decel array and make sure values equal to and less than minimum are included
    if ~isempty(negArray)
        negArray(end,end)=negArray(end,end)-binSize/100;
        temp = negArray;
        negArray=[-inf, temp(1,1);temp];
    end
    if ~isempty(posArray)
        posArray(1,1)=posArray(1,1)+binSize/100;
        posArray=[posArray; posArray(end,end), inf];
    end
    hist.bin=[negArray;-binSize/100, binSize/100;posArray];
    
    maxTime = sum(diffTime);
    for i=1:size(hist.bin,1)
        idx=find((data)>hist.bin(i,1)&(data)<=hist.bin(i,2));
        hist.time(i)=sum(diffTime(idx));
        hist.percentTime(i)=hist.time(i)/maxTime;
    end
    
    if plotFlag
        fhandle=figure;
        for i=1:size(hist.bin,1)
            x1=hist.bin(i,1);
            x2=hist.bin(i,2);
            y1=0;
            y2=hist.percentTime(i);
            patch([x1;x1;x2;x2],[y1; y2; y2; y1],'b');
        end
   
    end
    
    posIdx = find(data>0);
    negIdx = find(data<0);
    
    if sum(diffTime(posIdx))~=0
        posMean = sum(data(posIdx).*diffTime(posIdx))./sum(diffTime(posIdx));
    else
        posMean = 0;
    end
    if sum(diffTime(negIdx))~=0
        negMean = sum(data(negIdx).*diffTime(negIdx))./sum(diffTime(negIdx));
    else
        negMean=0;
    end
    totMean = sum(data.*diffTime)./sum(diffTime);
catch
    disp(lasterr)
    dbstack
    keyboard
end