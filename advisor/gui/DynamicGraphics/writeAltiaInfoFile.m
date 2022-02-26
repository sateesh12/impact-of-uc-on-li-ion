%   Write out text file for Altia to read
%       Data must be in same order as listed in the Altia "Control" of Initial Text File Read Statement
function writeAltiaInfoFile(SimType,fileInfo,savedFile,axisLimits)

AltiaInfoFilename='AltiaInfo.m';

%   Get required information
[minShaftPwr,maxShaftPwr]=getShaftPwrLimits(fileInfo);
if isfield(fileInfo,'t') & SimType > 1
    startTime=eval('min(union(fileInfo.t))','min(fileInfo.t)');
    endTime=eval('max(union(fileInfo.t))','max(fileInfo.t)');
else
    startTime=0;
    endTime=fileInfo.cyc_mph(end,1);
end

%   Specify list 
AltiaInfoList={axisLimits.fc(1),'fcMinSpd';...
        axisLimits.fc(2),'fcMaxSpd';...
        axisLimits.fc(3),'fcMinTrq';...
        axisLimits.fc(4),'fcMaxTrq';...
        axisLimits.mc(1),'mcMinSpd';...
        axisLimits.mc(2),'mcMaxSpd';...
        axisLimits.mc(3),'mcMinTrq';...
        axisLimits.mc(4),'mcMaxTrq';...
        startTime,'startTime';...
        endTime,'endTime';...
        minShaftPwr,'minShaftPwr';...
        maxShaftPwr,'maxShaftPwr';...
        axisLimits.fuelcell(1)*1000,'fuelCellMinPwr';...
        axisLimits.fuelcell(2)*1000,'fuelCellMaxPwr';...
        axisLimits.fuelcell(3),'fuelCellMinEff';...
        axisLimits.fuelcell(4),'fuelCellMaxEff';...
        SimType,'SimType'};

%   Append list
AltiaInfoList=AddConst2List(fileInfo,AltiaInfoList,'missed_trace');
AltiaInfoList(end+1:end+length(savedFile),1)=savedFile;
if length(savedFile) == 1
    AltiaInfoList(end+1,1)={'filename 2, na'};
end

%   Write out file with information
writeAltiaInfo(AltiaInfoFilename,AltiaInfoList);
rehash toolbox;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writeAltiaInfo(AltiaInfoFilename,AltiaInfoList);

AltiaInfoFid=fopen(AltiaInfoFilename,'w');
AltiaInfoDebug=fopen('AltiaInfoDebug.m','w');
for AltiaInfoListInd=1:length(AltiaInfoList(:,1))
    AltiaInfoValue=AltiaInfoList{AltiaInfoListInd,1};
    if isa(AltiaInfoValue,'numeric')
        fprintf(AltiaInfoFid,[num2str(AltiaInfoValue),'\n']);
        fprintf(AltiaInfoDebug,[num2str(AltiaInfoValue),' : ',AltiaInfoList{AltiaInfoListInd,2},'\n']);
    else
        fprintf(AltiaInfoFid,[AltiaInfoValue,'\n']);
        fprintf(AltiaInfoDebug,[AltiaInfoValue,' : ',AltiaInfoList{AltiaInfoListInd,2},'\n']);
    end
end
fclose(AltiaInfoFid);
fclose(AltiaInfoDebug);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MinMapTrq,MaxMapTrq,MinMapSpd,MaxMapSpd,EffMap]=getEffInfo(fileInfo,prefix);

if  (isfield(fileInfo(1),[prefix,'_eff_map'])... 
        & isfield(fileInfo(1),[prefix,'_map_spd'])...
        & isfield(fileInfo(1),[prefix,'_map_trq'])... 
        & isfield(fileInfo(1),[prefix,'_trq_scale'])... 
        & isfield(fileInfo(1),[prefix,'_spd_scale']))...
        & (length(fileInfo) == 1 ...
        | (eval(['isequal(fileInfo.',prefix,'_eff_map)'])...
        & eval(['isequal(fileInfo.',prefix,'_map_spd)'])...
        & eval(['isequal(fileInfo.',prefix,'_map_trq)'])...
        & eval(['isequal(fileInfo.',prefix,'_trq_scale)'])...
        & eval(['isequal(fileInfo.',prefix,'_spd_scale)'])))
    
    EffMap=eval(['fileInfo(1).',prefix,'_eff_map*fileInfo(1).',prefix,'_trq_scale;']);
    
    %   Get the max and mins
    MinMapTrq=eval(['min(min(fileInfo(1).',prefix,'_map_trq*fileInfo(1).',prefix,'_trq_scale));']);
    MaxMapTrq=eval(['max(max(fileInfo(1).',prefix,'_map_trq*fileInfo(1).',prefix,'_trq_scale));']);
    MinMapSpd=eval(['min(min(fileInfo(1).',prefix,'_map_spd*fileInfo(1).',prefix,'_spd_scale));']);
    MaxMapSpd=eval(['max(max(fileInfo(1).',prefix,'_map_spd*fileInfo(1).',prefix,'_spd_scale));']);
else % send null data
    MinMapTrq=0;
    MaxMapTrq=0;
    MinMapSpd=0;
    MaxMapSpd=0;
    EffMap=[0 0;0 0];
end

%   Force all min to be zero or less
MinMapTrq=min(0,MinMapTrq);
MinMapSpd=min(0,MinMapSpd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fuelCellMinPwr,fuelCellMaxPwr,fuelCellMinEff,fuelCellMaxEff]=getFuelCellInfo(fileInfo);

if isfield(fileInfo,'fc_pwr_map')...
        & isfield(fileInfo,'fc_pwr_scale')...
        & isfield(fileInfo,'fc_eff_map')... 
        & isfield(fileInfo,'fc_eff_scale')
    
    counter=1;
    for fileNum=1:length(fileInfo)
        if ~isempty(fileInfo(fileNum).fc_pwr_map)...
                & ~isempty(fileInfo(fileNum).fc_pwr_scale)...
                & ~isempty(fileInfo(fileNum).fc_eff_map)... 
                & ~isempty(fileInfo(fileNum).fc_eff_scale)
            
            fuelCellMinPwrRaw(counter)=min(fileInfo(fileNum).fc_pwr_map * fileInfo(fileNum).fc_pwr_scale);
            fuelCellMaxPwrRaw(counter)=max(fileInfo(fileNum).fc_pwr_map * fileInfo(fileNum).fc_pwr_scale);
            fuelCellMinEffRaw(counter)=min(fileInfo(fileNum).fc_eff_map * fileInfo(fileNum).fc_eff_scale*100);
            fuelCellMaxEffRaw(counter)=max(fileInfo(fileNum).fc_eff_map * fileInfo(fileNum).fc_eff_scale*100);
            
            counter=1+counter;
        end
    end
    fuelCellMinPwr=min(fuelCellMinPwrRaw);
    fuelCellMaxPwr=max(fuelCellMaxPwrRaw);
    fuelCellMinEff=min(fuelCellMinEffRaw);
    fuelCellMaxEff=max(fuelCellMaxEffRaw);
    
else
    fuelCellMinPwr=0;
    fuelCellMaxPwr=0;
    fuelCellMinEff=0;
    fuelCellMaxEff=0;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [minShaftPwr,maxShaftPwr]=getShaftPwrLimits(FileInfo)

defaultMinPwr=-40000; %Watts
defaultMaxPwr=40000; % Watts

minShaftPwrs=0;
maxShaftPwrs=0;
for fileNum=1:length(FileInfo)
    
    %   Engine
    if isfield(FileInfo(fileNum),'fc_brake_trq') & isfield(FileInfo(fileNum),'fc_spd_est')...
            & ~isempty(FileInfo(fileNum).fc_brake_trq) & ~isempty(FileInfo(fileNum).fc_spd_est)
        minShaftPwrs(end+1)=min(FileInfo(fileNum).fc_brake_trq.*FileInfo(fileNum).fc_spd_est);
        maxShaftPwrs(end+1)=max(FileInfo(fileNum).fc_brake_trq.*FileInfo(fileNum).fc_spd_est);
    end
    
    %   Fuel Cell
    if isfield(FileInfo(fileNum),'fc_pwr_out_a') & ~isempty(FileInfo(fileNum).fc_pwr_out_a)
        minShaftPwrs(end+1)=min(FileInfo(fileNum).fc_pwr_out_a);
        maxShaftPwrs(end+1)=max(FileInfo(fileNum).fc_pwr_out_a);
    end
    
    %   Motor
    if isfield(FileInfo(fileNum),'mc_trq_out_a') & isfield(FileInfo(fileNum),'mc_spd_out_a')...
        & ~isempty(FileInfo(fileNum).mc_trq_out_a) & ~isempty(FileInfo(fileNum).mc_spd_out_a)
        minShaftPwrs(end+1)=min(FileInfo(fileNum).mc_trq_out_a.*FileInfo(fileNum).mc_spd_out_a);
        maxShaftPwrs(end+1)=max(FileInfo(fileNum).mc_trq_out_a.*FileInfo(fileNum).mc_spd_out_a);
    end
    
    %   Generator
    if isfield(FileInfo(fileNum),'gc_pwr_out_a') & ~isempty(FileInfo(fileNum).gc_pwr_out_a)
        minShaftPwrs(end+1)=min(FileInfo(fileNum).gc_pwr_out_a);
        maxShaftPwrs(end+1)=max(FileInfo(fileNum).gc_pwr_out_a);
    end
    
    %   Energy Storage System
    if isfield(FileInfo(fileNum),'ess_pwr_out_a') & ~isempty(FileInfo(fileNum).ess_pwr_out_a)
        minShaftPwrs(end+1)=min(FileInfo(fileNum).ess_pwr_out_a);
        maxShaftPwrs(end+1)=max(FileInfo(fileNum).ess_pwr_out_a);
    end
    
end

%   Assign overall min
if min(minShaftPwrs) == 0
    minShaftPwr=defaultMinPwr/1000;
else
    minShaftPwr=min(minShaftPwrs)/1000;
end

%   Assign overall max
if max(maxShaftPwrs) == 0
    maxShaftPwr=defaultMaxPwr/1000;
else
    maxShaftPwr=max(maxShaftPwrs)/1000;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AltiaInfoList=AddConst2List(fileInfo,AltiaInfoList,constName)

listInd=length(AltiaInfoList)+1;
if length(fileInfo) == 2
    for fileNum=1:length(fileInfo)
        if isfield(fileInfo,constName)
            AltiaInfoList{listInd,1}=eval(['fileInfo(fileNum).',constName]);
        else
            AltiaInfoList{listInd,1}=0;
        end
        AltiaInfoList{listInd,2}=[constName,num2str(fileNum)];
        listInd=listInd+1;
    end
elseif length(fileInfo) == 1
    if isfield(fileInfo,constName)
        AltiaInfoList{listInd,1}=eval(['fileInfo(1).',constName]);
    else
        AltiaInfoList{1,1}=0;
    end
    AltiaInfoList{listInd,2}=[constName,num2str(1)];
    AltiaInfoList{listInd+1,1}=0;
    AltiaInfoList{listInd+1,2}=[constName,num2str(2),'(na)'];
    
else
    error('This function has been hardcoded to work with 1 or 2 files only.');
end
