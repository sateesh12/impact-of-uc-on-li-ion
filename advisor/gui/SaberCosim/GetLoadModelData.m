function Data=GetLoadModelData(LoadName,Voltage,VehType,LoadChoice)
%=====================================================================================
% Data=GetLoadModelDate(LoadName,VehType,LoadChoice)
%   This function gets the data corresponding to the load model input
%=====================================================================================

global vinf % need for tmppath

CurrentWorkingDir=cd;

TempDir=strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',Voltage]);
if exist('LoadChoice') & isdir([TempDir,'\',VehType])  %strcmp(get(findobj('tag',[LoadName,'.LoadChoice']),'enable'),'on') %& ~isempty(strmatch(VehTypeFile,StandardVehTypeFiles,'exact'))
    TempDir=[TempDir,'\',VehType];
    cd(TempDir);
    RawData=eval(LoadChoice);
else
    cd(TempDir);
    RawData=eval(VehType);
end

%   Restore original dir
cd(CurrentWorkingDir);

%   CurrentLoads
if ~isempty(strmatch(LoadName,GetLoadNames('CurrentLoad')))
    CurrentData=transpose(RawData(1:3));
    CurrentData(1:3,2)=transpose(RawData(4:6));
    Data=CurrentData;
end

%   PowerLoads
if ~isempty(strmatch(LoadName,GetLoadNames('PowerLoad')))
    Data=RawData;
end

%   SpeedLoads
if ~isempty(strmatch(LoadName,GetLoadNames('SpeedLoad')))
    SpeedData(1:2,1)=transpose(RawData(1:2));
    SpeedData(1:2,2)=transpose(RawData(3:4));
    Data=SpeedData;
end

%   PowerLoads
if ~isempty(strmatch(LoadName,GetLoadNames('SingleCurrentLoad')))
    Data=RawData;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)