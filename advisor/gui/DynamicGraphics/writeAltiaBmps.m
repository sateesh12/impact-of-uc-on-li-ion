%   writeAltiaBmps(SimType,fileInfo)
%       This function writes out the bmps needed for the Altia graphics.  The bmps include
%       efficiency plots and time trace plots.
function axisLimits=writeAltiaBmps(SimType,fileInfo)

bmpFilePath=strrep(which('DynamicReplay.m'),'DynamicReplay.m','');

%   --Write out contour efficiency bmps------------------
prefixes={'mc';'fc'};
axisLimits=writeContourEffBmps(prefixes,fileInfo,bmpFilePath);

%   --Write out fuel cell efficiecy map---------------------
axisLimits=writeFuelCellBmp(fileInfo,bmpFilePath,axisLimits);


%   --Write out time trace bmps----------------------------
color={'blue';...
        'red'};
writeTimeTraceBmps(SimType,color,fileInfo,bmpFilePath);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [axisLimits]=writeContourEffBmps(prefixes,fileInfo,bmpFilePath)

for prefixInd=1:length(prefixes)
    
    %   Create plot
    figHandle=figure('visible','off');
    axesHandle=axes;
    
    if (isfield(fileInfo(1),[prefixes{prefixInd},'_eff_map'])... 
            & isfield(fileInfo(1),[prefixes{prefixInd},'_map_spd'])...
            & isfield(fileInfo(1),[prefixes{prefixInd},'_map_trq'])... 
            & isfield(fileInfo(1),[prefixes{prefixInd},'_trq_scale'])... 
            & isfield(fileInfo(1),[prefixes{prefixInd},'_spd_scale'])) &...
            (length(fileInfo) == 1 |...
            (eval(['isequal(fileInfo.',prefixes{prefixInd},'_eff_map)'])...
            & eval(['isequal(fileInfo.',prefixes{prefixInd},'_map_spd)'])...
            & eval(['isequal(fileInfo.',prefixes{prefixInd},'_map_trq)'])...
            & eval(['isequal(fileInfo.',prefixes{prefixInd},'_trq_scale)'])...
            & eval(['isequal(fileInfo.',prefixes{prefixInd},'_spd_scale)'])))
        
        %   Use map of first file that has one defined
        fileNum=1;
        while eval(['isempty(fileInfo(fileNum).',prefixes{prefixInd},'_eff_map)'])
            fileNum=fileNum+1;
        end
        
        %   Contour plot
        EffMap=eval(['fileInfo(fileNum).',prefixes{prefixInd},'_eff_map*fileInfo(fileNum).',prefixes{prefixInd},'_trq_scale']);
        SpdMapRaw=eval(['fileInfo(fileNum).',prefixes{prefixInd},'_map_spd*fileInfo(fileNum).',prefixes{prefixInd},'_spd_scale']);
        TrqMapRaw=eval(['fileInfo(fileNum).',prefixes{prefixInd},'_map_trq*fileInfo(fileNum).',prefixes{prefixInd},'_trq_scale']);
        %   Remove zeros that don't coorespond to the eff map due to div by zero issues with creating the eff map
        if length(SpdMapRaw) ~= size(EffMap,1)
            SpdMap=SpdMapRaw(find(SpdMapRaw ~= 0));
        else
            SpdMap=SpdMapRaw;
        end
        if length(TrqMapRaw) ~= size(EffMap,2)
            TrqMap=TrqMapRaw(find(TrqMapRaw ~= 0));
        else
            TrqMap=TrqMapRaw;
        end
        [cmatrix,contMapH]=contour(SpdMap,TrqMap,EffMap',4);
        
        cmatrix=round(cmatrix.*100)/100;
        
        clabel(cmatrix,contMapH,'LabelSpacing',20000);
        hold on;
        
        %   Max torque curve
        if isfield(fileInfo(1),[prefixes{prefixInd},'_max_trq'])
            MaxTrq=eval(['fileInfo(fileNum).',prefixes{prefixInd},'_max_trq*fileInfo(fileNum).',prefixes{prefixInd},'_trq_scale']);
            plot(SpdMap,MaxTrq,'marker','x','color','black','linewidth',2);
        end
        
        %   Axis limits
        eval(['axisLimits.',prefixes{prefixInd},'=[min(0,min(SpdMap)),max(SpdMap),min(0,min(TrqMap)),max(TrqMap)];']);
        axis([eval(['axisLimits.',prefixes{prefixInd}])]);
                        
        %   Set labels
        xlabel('Speed');
        ylabel('Torque');
        
    else
        text(.4,.5,'not available','color','blue');
        eval(['axisLimits.',prefixes{prefixInd},'=[0 1 0 1];']);
    end
    
    %   Write out bmp from plot
    setPlotProps(figHandle,axesHandle);
    bmpFileName=[prefixes{prefixInd},'_eff'];
    fig2bmp(figHandle,bmpFileName,bmpFilePath);
    close(figHandle)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function axisLimits=writeFuelCellBmp(fileInfo,bmpFilePath,axisLimits)
bmpFileName='fuel_cell_eff.bmp';

%   Create plot
figHandle=figure('visible','off');
axesHandle=axes;

if isfield(fileInfo,'fc_pwr_map')...
        & isfield(fileInfo,'fc_pwr_scale')...
        & isfield(fileInfo,'fc_eff_map')... 
        & isfield(fileInfo,'fc_eff_scale')...
        & (length(fileInfo) == 1 |...
        (isequal(fileInfo.fc_pwr_map)...
        & isequal(fileInfo.fc_pwr_scale)...
        & isequal(fileInfo.fc_eff_map)...
        & isequal(fileInfo.fc_eff_scale)))
    
    plot(fileInfo(1).fc_pwr_map*fileInfo(1).fc_pwr_scale/1000,fileInfo(1).fc_eff_map*fileInfo(1).fc_eff_scale*100,'k-')
    
    axisLimits.fuelcell=axis;
    
    xlabel('Power (kW)');
    ylabel('Efficiency');
else
    text(.4,.5,'not available','color','blue');
    axisLimits.fuelcell=[0 1 0 1];
end
setPlotProps(figHandle,axesHandle);

%   Write out bmp from plot
fig2bmp(figHandle,bmpFileName,bmpFilePath);

%   Clean up
close(figHandle)    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writeTimeTraceBmps(SimType,color,fileInfo,bmpFilePath)

%   Create list to plot
traceNames={'mpha';...
        'ess_soc_hist';...
        'gal';...
        'ess_pwr_out_a';...
        'ess2_pwr_out_a'};


%   Create plots and copy to bmps
for traceInd=1:length(traceNames)
    
    %   Create plot
    figHandle=figure('visible','off');
    axesHandle=axes;
    hold on;
    
    if isfield(fileInfo,traceNames{traceInd}) & (SimType == 3 | ~strcmp(traceNames{traceInd},'mpha'))
        for fileNum=1:length(fileInfo)
            if ~isempty(eval(['fileInfo(fileNum).',traceNames{traceInd}])) & (SimType ~= 1)
                plot(fileInfo(fileNum).t,eval(['fileInfo(fileNum).',traceNames{traceInd}]),'color',color{fileNum});
                maxY(fileNum)=eval(['max(fileInfo(fileNum).',traceNames{traceInd},')']);
                minY(fileNum)=eval(['min(fileInfo(fileNum).',traceNames{traceInd},')']);
            else
                text((max(fileInfo(1).t)/3),.5,['not available'],'color',color{fileNum});
            end
        end
    elseif SimType == 1  &  strcmp(traceNames{traceInd},'mpha')
        fileInfo.t=evalin('base','cyc_mph(:,1)');
        fileInfo.cyc_mphr=evalin('base','cyc_mph(:,2)');
        traceNames(traceInd)={'cyc_mphr'};
        plot(fileInfo.t,fileInfo.cyc_mphr,'color',color{1});
        maxY=max(fileInfo.cyc_mphr);
        minY=0;
    elseif SimType == 2 & strcmp(traceNames{traceInd},'mpha')
        traceNames(traceInd)={'mph'};
        plot(fileInfo.t,fileInfo.cyc_mph_r,'color',color{1});
        hold on;
        plot(fileInfo.t,fileInfo.mpha,'color',color{2});
        legend('cyc\_mph\_r','mpha',0);
        maxY=max(max(fileInfo.cyc_mph_r),max(fileInfo.mpha));
        minY=0;
    else
        text((max(fileInfo(1).t)/3),.5,'not available','color','blue');
    end
    
    if exist('minY')
        minYtotal=min(minY);
    else
        minYtotal=0;
    end
    
    if exist('maxY')
        maxYtotal=max(maxY)+.05*(max(maxY)-minYtotal);
    else
        maxYtotal=1;
    end
    
    ylabel(strrep(traceNames{traceInd},'_','\_'));
    xlabel('time');
    axis([min(fileInfo(1).t) max(fileInfo(1).t) minYtotal maxYtotal+eps]); % eps added to prevent error from settig min and max to 0
    setPlotProps(figHandle,axesHandle);
    
    %   Write out bmp from plot
    bmpFileName=traceNames{traceInd};
    fig2bmp(figHandle,bmpFileName,bmpFilePath);
    
    %   Clean up
    close(figHandle)    
    clear minY maxY;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setPlotProps(figHandle,axesHandle)

set(get(axesHandle,'XLabel'),'FontSize',12,'FontWeight','bold');
set(get(axesHandle,'YLabel'),'FontSize',12,'FontWeight','bold');
set(axesHandle,'FontWeight','bold','FontSize',11);
set(figHandle,'Color',[.87,.87,1]);
set(axesHandle,'Color',[.98,.98,1]);
set(figHandle,'PaperPosition',[0,0,4.73,3.25]);
set(axesHandle,'Position',[.15,.15,.75,.7]);
set(get(axesHandle,'Title'),'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fig2bmp(figHandle,filename,filePath)

%   Write out bmp from plot
set(figHandle,'InvertHardcopy','off')
try
    print(figHandle,'-dbmp','-r72',[filePath,filename]) 
catch
    errordlg('You must install Ghostscript from the Matlab installation CD for all of the dynamic compare outputs to display correctly.');
    waitfor(findobj('tag','OKButton'));
end
