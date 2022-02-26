function [myArray] = sigProcessor(reqTime, t, sig)
% function [array] = sigProcessor(reqTime, t, sig)
%
% creates an array that takes a signal specified for t and sig and maps it
% to reqTime using linear interpolation and edge extention

minTime = min(t);
maxTime = max(t);

reqTime(find(reqTime<minTime))=minTime; % give min(t) value of sig for any requested time less than min(t)
reqTime(find(reqTime>maxTime))=maxTime; % give max(t) value of sig for any requested time more than max(t)

myArray=interp1(t, sig, reqTime);