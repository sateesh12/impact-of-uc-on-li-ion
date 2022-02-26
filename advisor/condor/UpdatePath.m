function updatepath(ADVISORRootDir,SupportDir)
% this function can be used to automate the process of updating the 
% Matlab path to work with ADVISOR. ADVISORRootDir is the path location of 
% ADVISOR relative to the current working directory and SupportDir is the 
% path location of a supporting directory relative to the current working 
% directory. Do not include the leading backslash in the input parameters.
%
% Created 4/29/03 by Tony Markel, NREL.
%

% get the current working directory
str=cd;

% remove any blanks or carriage returns that might exist
str=deblank(str);

% change to advisor root directory
eval(['cd ',ADVISORRootDir])

% setup the path information for ADVISOR
SetADVISORPath([str,'\',SupportDir])

% return to the original current working directory
eval(['cd ',str])

% debugging features
thepath=path;
thepwd=pwd;
save myinfo.mat thepath thepwd

return
