function AuxLoadsFigControl(option1,option2,option3)

% AuxLoadsFigControl(option1,option2,option3)
%   This function sets up and controls the AuxLoadsFig.  
%   **Note: AuxLoadsFig (figure) can be modified by using Guide.  **Use snap to grid and grid spacing=5**
%   Basic file operation:
%       1.  SimSetupFig calls to assign aux default data
%       2.  Aux load button press: Open GUI and Restore current values to figure
%       3.  User makes changes in GUI
%       4a. Back or Done: Update vinf with current figure values
%       4b. Cancel:  Close figure without making any changes to vinf values



global vinf % need for vinf.tmppath

persistent AuxLoadsFigHandle

if nargin==0 & isempty(findobj('tag','AuxLoadsFig'))    % must use this because some calls don't require opening gui (as opposed to if fig tag not existing)
    
    %   Wait bar
    AuxLoadsWaitbar=waitbar(0,'loading auxiliary loads figure...');
    try
        waitbar(0.25,AuxLoadsWaitbar);
    end

    %	Load gui file:  this file can be edited using guide.
    AuxLoadsFigHandle=open('AuxLoads.fig');
    %set(gcf,'windowstyle','modal');
    
    %   Center the figure on the screen
    center_figure(AuxLoadsFigHandle);
    
    %   set everything normalized 
    h=findobj(AuxLoadsFigHandle,'type','uicontrol');
    g=findobj(AuxLoadsFigHandle,'type','axes');
    set([h; g],'units','normalized');   
    
    %   Set Figure Object Parameters to vinf Parameters (and set lists)
    RestoreFigure;
    
    %   Set figure name to aux load file name
    set(AuxLoadsFigHandle,'name',vinf.AuxLoads.FileName);
    
    %   Set figure visible
    set(AuxLoadsFigHandle,'visible','on');
    
    waitbar(.75,AuxLoadsWaitbar);
    
    %   Update Selected Load Plot
    UpdateSelectedLoadPlot;
    
    %   Update Total Load Plot
    UpdateTotalLoad;
    
    waitbar(1,AuxLoadsWaitbar);
    close(AuxLoadsWaitbar); 	%close the waitbar   
    
    
end % End Switch nargin==0


%---GUI interaction-----------------------------------------
if nargin>0
    
    if isempty(strmatch(option1,{'SaveLoadChoices';'TotalLoad';'LoadFile';'Cancel';'Help';'Back';'Continue';'SelectedLoad';'UpdateSelectedLoadPlot'},'exact')) &...
            isempty(findstr('*',get(AuxLoadsFigHandle,'name')))
            set(AuxLoadsFigHandle,'name',[get(AuxLoadsFigHandle,'name'),'*']);
    end
    
    StandardAuxLoadFiles={'Default_aux.mat';...
            'City_summer_day_aux.mat';...
            'Counter_summer_night_aux.mat';...
            'Foul_winter_night_aux.mat'};
    
%     %   Let user know that loaded file has changed
%     if isempty(strmatch(option1,{'Back';'Continue';'Cancel';'Help';'SelectedLoad';'TotalLoad';'UpdateSelectedLoadPlot'}))
%         CurrentFigName=get(findobj('tag','AuxLoadsFig'),'name');
%         if ~strcmp('Auxiliary Loads',CurrentFigName) & isempty(findstr('*',CurrentFigName))
%             set(findobj('tag','AuxLoadsFig'),'name',[CurrentFigName,'*']);
%         end
%     end
    
    switch option1
        
        
     case 'SaveLoadChoices'
        CurrentWorkingDir=cd;
        advisorTopDir = fileparts(which('advisor.m'));
        LookInPath=fullfile(advisorTopDir, 'data', 'accessory');
        cd(LookInPath);
        [SaveFileName,SavePathName]=uiputfile('*_aux.mat','Save Auxiliary Load Scenario As');
        
        
        StandardAuxLoadFileNum=strmatch(SaveFileName,StandardAuxLoadFiles,'exact');
        if  isempty(findstr('*',get(AuxLoadsFigHandle,'name'))) & strcmp(SaveFileName,get(AuxLoadsFigHandle,'name'))
            %   Do nothing
        elseif(SaveFileName ~= 0) & isempty(StandardAuxLoadFileNum)
            if isempty(findstr('.',SaveFileName))
                SaveFileName=[SaveFileName,'_aux.mat'];
            elseif isempty(findstr('.mat',SaveFileName))
                SaveFileName=strrep(SaveFileName,'.*','_aux.mat');
            end
            AssignVinfData(SaveFileName);
            
            AuxLoads=vinf.AuxLoads;
            
            SaveMatFile(AuxLoads,SaveFileName,SavePathName);
            
            cd(SavePathName);
            
            %   Set saved file name to "Load File" pulldown
            AccFiles=dir(fullfile(advisorTopDir,'data', 'accessory', '*_aux.mat'));
            for i=1:length(AccFiles)
                AccFilesList{i}=AccFiles(i).name;
            end
            set(findobj('tag','LoadFile'),'string',AccFilesList);
            set(findobj('tag','LoadFile'),'value',strmatch(SaveFileName,AccFilesList));
            
            %   Update file name in figure title
            set(AuxLoadsFigHandle,'name',SaveFileName);
            
        else
            warndlg(['Cannot overwrite standard file: ',StandardAuxLoadFiles{StandardAuxLoadFileNum},'.  Must save changes with a different name.']);
        end
        
        cd(CurrentWorkingDir);
        
        
    case 'LoadFile'
        LoadFilePath=strrep(vinf.tmppath,'tmp','data\accessory\');
        
        SelectionValue=get(gcbo,'value');
        SelectionString=get(gcbo,'string');
        SelectionName=SelectionString{SelectionValue};
        
        close(gcf);
        RunFilesMods('modify','vinf.AuxLoads',['load(''',SelectionName,''')'],'acc');
        vinf.AuxLoads=load([LoadFilePath,SelectionName]);
        AuxLoadsFigControl;
        
        
    case 'acc_elec_eff'
        UserInput=get(findobj('tag','EditText_acc_elec_eff'),'string');
        if isempty(str2num(UserInput)) | (str2num(UserInput) > 1) | (str2num(UserInput) < 0)
            warndlg('Efficiency must be between 0 and 1','Input Error');
            set(findobj('tag','EditText_acc_elec_eff'),'string','1');
        end
        
        
        
        %---All Loads Objects-----------------------------------------
    case 'AllLoads'
        
        %   Define LoadNames to make changes to (DV or only SV loads)
        if strcmp(vinf.drivetrain.name,'saber_conv_sv')  %~isfield(vinf.saber_cosim,'type') | ~strcmp(vinf.saber_cosim.type,'DV')
            LoadNames=GetLoadNames('UserDefinedSV');
        else
            LoadNames=GetLoadNames('All');
        end
        
        LoadName=strtok(get(gco,'tag'),'.');
        AllLoadFunction=strrep(get(gco,'tag'),[LoadName,'.'],'');
        
        %   Get control on/off data to assign in following loop
        if strcmp(AllLoadFunction,'Control')
            AuxControlFigControl('AllLoads');
            waitfor(findobj('tag','AuxControlFig'));
        end
        
        for i=1:length(LoadNames)  % Go through all LoadNames
            LoadObjHandle=findobj('tag',[LoadNames{i},'.',AllLoadFunction]);
            
            switch AllLoadFunction
            case 'On'
                set(LoadObjHandle,'value',get(gco,'value'));
                AuxLoadsFigControl(AllLoadFunction,LoadObjHandle);
                
            case 'VehType'
                LoadNameVehTypeList=get(findobj('tag',[LoadNames{i},'.VehType']),'string');
                AllLoadsVehTypeValue=get(gco,'value');
                AllLoadsVehTypeString=get(gco,'string');
                AllLoadsVehTypeSelected=AllLoadsVehTypeString(AllLoadsVehTypeValue);
                MatchValue=strmatch(AllLoadsVehTypeSelected,LoadNameVehTypeList,'exact');
                if ~isempty(MatchValue)
                    set(LoadObjHandle,'value',MatchValue);
                    AuxLoadsFigControl(AllLoadFunction,LoadObjHandle);
                end
                
                
            case 'LoadChoice'
                CurrentWorkingDir=cd;
                
                
                LoadChoiceHandle=findobj('tag',[LoadNames{i},'.LoadChoice']);
                if ~isempty(LoadChoiceHandle) & strcmp(get(LoadChoiceHandle,'enable'),'on')  
                    clear Watts;
                    
                    LoadChoiceList=get(LoadChoiceHandle,'string');
                    VehTypeFolder=GetListSelection([LoadNames{i},'.VehType']);
                    
                    for j=1:length(LoadChoiceList)
                        SaberModelPath=strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadNames{i},'\V14\',VehTypeFolder]);
                        cd(SaberModelPath);
                        
                        Data=eval(LoadChoiceList{j});
                        
                        %   Get Watts
                        if length(Data)==6
                            CurrentData=[Data(1),Data(4);Data(2),Data(5);Data(3),Data(6)];
                            Watts(j)=AveragePower(CurrentData);
                        elseif length(Data)==2
                            Watts(j)=sum(Data(:,2)/2);
                        else
                            Watts(j)=Data;
                        end
                        
                    end
                    
                    LowWatts=min(Watts);
                    HighWatts=max(Watts);
                    
                    LoadChoiceLowValue=find(Watts==LowWatts);
                    LoadChoiceHighValue=find(Watts==HighWatts);
                    
                    LoadChoiceLowValue=LoadChoiceLowValue(1); % make single value if multiple Low Watts
                    LoadChoiceHighValue=LoadChoiceHighValue(1);
                    
                    if get(findobj('tag','AllLoads.LoadChoice'),'value')==1  % Then looking for lowest
                        set(LoadChoiceHandle,'value',LoadChoiceLowValue);
                    else
                        set(LoadChoiceHandle,'value',LoadChoiceHighValue);
                    end
                    
                end
                
                %   Restore Current Working Dir
                cd(CurrentWorkingDir);
                
            case 'Control'
                if evalin('base','exist(''AuxAllLoadsControl'')') & isempty(strmatch(LoadNames{i},GetLoadNames('CycleDependent')))
                    set(LoadObjHandle,'userdata',get(findobj('tag','AllLoads.Control'),'userdata'));
                end
                
            case 'Num'
                if ~isempty(ObjHandle)
                    set(ObjHandle,'string',get(gco,'string'));
                    AuxLoadsFigControl(AllLoadFunction,ObjHandle);
                end
                
            end % end switch
            UpdateAveragePower(LoadNames{i});
        end
        
        %   Clear variable that is allowing AllLoads Control to be changed
        evalin('base','clear AuxAllLoadsControl');

        %   Update total average power
        set(findobj('tag','UserDefined.TotalAveragePower'),'string',UserTotalAveragePower);
        
        %   Update selected load plot
        UpdateSelectedLoadPlot;
        
        %   Update Total Load
        UpdateTotalLoad;
        
        
        %---On/Off Checkboxes-----------------------------------------
    case 'On'
        
        if nargin==1
            ObjHandle=gco;
        else
            ObjHandle=option2;
        end
        
        LoadName=strtok(get(ObjHandle,'tag'),'.');
        CheckboxOnOff=get(ObjHandle,'value');
        OnOff=EnableObj(CheckboxOnOff);
        
        %   Set Add Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.Add''])']))
            set(findobj('tag',[LoadName,'.Add']),'enable',OnOff);
        end
        
        %   Set 14V HiV Enable On/Off
        V14OrV42Loads=GetLoadNames('Volt42Or14Loads');
        if ~isempty(strmatch(LoadName,V14OrV42Loads,'exact')) & strcmp(vinf.accessory.type,'DV')
            set(findobj('tag',[LoadName,'.14V']),'enable',OnOff);
            set(findobj('tag',[LoadName,'.42V']),'enable',OnOff);
        else 
            set(findobj('tag',[LoadName,'.14V']),'enable','Off');
            set(findobj('tag',[LoadName,'.42V']),'enable','Off');
            set(findobj('tag',[LoadName,'.14V']),'value',1);
        end
        
        %   Set VehType Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.VehType''])']))
            set(findobj('tag',[LoadName,'.VehType']),'enable',OnOff);
        end
        
        %   Set LoadChoice Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.LoadChoice''])']))...
                & isdir(strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',GetVoltageType(LoadName),'\',GetListSelection([LoadName,'.VehType'])]))
            set(findobj('tag',[LoadName,'.LoadChoice']),'enable',OnOff);
        else
            set(findobj('tag',[LoadName,'.LoadChoice']),'enable','off');
        end
        
        %   Set Number Active (LoadName.Num) Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.Num''])']))
            set(findobj('tag',[LoadName,'.Num']),'enable',OnOff);
        end
        
        %   Set Control Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.Control''])']))
            set(findobj('tag',[LoadName,'.Control']),'enable',OnOff);
        end
        
        %   Set Average Power Enable On/Off
        if ~isempty(eval(['findobj(''tag'',[LoadName,''.AveragePower''])']))
            set(findobj('tag',[LoadName,'.AveragePower']),'enable',OnOff);
        end
        
        %   Update Average Watts
        UpdateAveragePower(LoadName);
        
        %   Update total average power
        set(findobj('tag','UserDefined.TotalAveragePower'),'string',UserTotalAveragePower);
        
        %   UpdateTotalLoadPlot;
        UpdateTotalLoad;
        
        
        %---Add/Delete/Rename---------------------------------------------
    case 'Add'
        %   Assign vinf.AuxLoads.LoadName.Data 
        if nargin==1
            ObjHandle=gco;
        else
            ObjHandle=option2;
        end
        
        if strcmp(get(ObjHandle,'tag'),'LoadFile.Add')
            LoadsDir=([strrep(vinf.tmppath,'tmp\','data\accessory\')]);
            CurrentList=get(findobj('tag','LoadFile'),'string');
            CurrentListHandle=findobj('tag','LoadFile');
            listcontrol;
            listcontrol('SetupFig',LoadsDir,CurrentList,CurrentListHandle);
           
        else
            
            %   Add/Delete VehType List Items
            LoadName=strtok(get(ObjHandle,'tag'),'.');
            Volts=GetVoltageType(LoadName);
            LoadsDir=strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',Volts]);
            CurrentList=get(findobj('tag',[LoadName,'.VehType']),'string');
            
            ManageListsAuxLoadsFigControl(LoadName,cellstr(LoadsDir),cellstr(CurrentList));
        end
        
        
        
        

        %---14V HiV---------------------------------------------------- 
    case {'14V','42V'}
        %   This function will need to change the VehType List to reflect 14V or 42V--now our only model is == 0 so it doesn't matter
        
        ObjHandle=gco;;
        LoadName=strtok(get(ObjHandle,'tag'),'.');
        VoltageSelection=strrep(get(ObjHandle,'tag'),[LoadName,'.'],'');
        
        %   Control Radio Buttons
        switch VoltageSelection
        case '14V'
            set(findobj('tag',[LoadName,'.HiV']),'value',0);
            set(findobj('tag',[LoadName,'.14V']),'value',1);
            %if ~isempty(findobj('tag',[LoadName,'.LoadChoice']))
                %if 
            
        case '42V'
            set(findobj('tag',[LoadName,'.14V']),'value',0);
            set(findobj('tag',[LoadName,'.HiV']),'value',1);
        end
        
        %   Set VehType List
        [VehTypeList]=GetVehTypeList(LoadName);
        set(findobj('tag',[LoadName,'.VehType']),'string',VehTypeList);
        
        %   Set LoadChoice List
        LoadChoiceList=GetLoadChoiceList(LoadName,GetListSelection([LoadName,'.VehType']));
        if ~isempty(LoadChoiceList)
            set(findobj('tag',[LoadName,'.LoadChoice']),'string',LoadChoiceList);
        end
        
        if get(findobj('tag',[LoadName,'.On']),'value')==1
            
            %   Update Average Watts
            UpdateAveragePower(LoadName);
            
            %   Update total average power
            set(findobj('tag','UserDefined.TotalAveragePower'),'string',UserTotalAveragePower);
            
            %   Disable LoadChoice box if doesn't have LoadChoice
            if ~isempty(findobj('tag',[LoadName,'.LoadChoice']))
                if ~isdir(strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',GetVoltageType(LoadName),'\',GetListSelection([LoadName,'.VehType'])]))
                    set(findobj('tag',[LoadName,'.LoadChoice']),'enable','off');
                else
                    set(findobj('tag',[LoadName,'.LoadChoice']),'enable','on');
                end
            end
            
        end
        
        %   Update Selected Load Plot
        if strcmp(GetListSelection('SelectedLoad'),LoadName)
            UpdateSelectedLoadPlot;
        end
        
        UpdateTotalLoad;
        
        %---VehType----------------------------------------------------    
    case 'VehType'
        if nargin==1
            ObjHandle=gco;
        else
            ObjHandle=option2;
        end
        
        LoadName=strtok(get(ObjHandle,'tag'),'.');
        
        %   Record current load choice
        eval('CurrentLoadChoice=GetListSelection([LoadName,''.LoadChoice'']);','CurrentLoadChoice=[];');
        
        %   Restore Vehicle Type and Load Choice List
        LoadChoiceList=GetLoadChoiceList(LoadName,GetListSelection([LoadName,'.VehType']));
        if ~isempty(LoadChoiceList) 
            set(findobj('tag',[LoadName,'.LoadChoice']),'string',LoadChoiceList);
        end
        
        %   Restore original load choice if exist
        LoadChoiceValue=strmatch(CurrentLoadChoice,LoadChoiceList,'exact');
        if ~isempty(LoadChoiceValue) & ~isempty(LoadChoiceList)
            set(findobj('tag',[LoadName,'.LoadChoice']),'value',LoadChoiceValue);
        end
        clear LoadChoiceList;
        clear CurrentLoadChoice;
        
        
        if get(findobj('tag',[LoadName,'.On']),'value')==1
            
            %   Update Average Watts
            UpdateAveragePower(LoadName);
            
            %   Update total average power
            set(findobj('tag','UserDefined.TotalAveragePower'),'string',UserTotalAveragePower);
            
            %   Set LoadChoice Enable On/Off
            if ~isempty(eval(['findobj(''tag'',[LoadName,''.LoadChoice''])']))...
                    & isdir(strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',GetVoltageType(LoadName),'\',GetListSelection([LoadName,'.VehType'])]))
                set(findobj('tag',[LoadName,'.LoadChoice']),'enable','on');
            else
                set(findobj('tag',[LoadName,'.LoadChoice']),'enable','off');
            end
           
        end
        
        %   Update Selected Load Plot
        if strcmp(GetListSelection('SelectedLoad'),LoadName)
            UpdateSelectedLoadPlot;
        end
        
        UpdateTotalLoad;

        
        
        %---Load Choice-------------------------------------------------------------    
    case 'LoadChoice'
        if nargin==1
            ObjHandle=gco;
        else
            ObjHandle=option2;
        end
        
        LoadName=strtok(get(ObjHandle,'tag'),'.');
        
        %   Update Average Watts
        if get(findobj('tag',[LoadName,'.On']),'value')==1
            UpdateAveragePower(LoadName);
        end
        
        %   Update total average power
        set(findobj('tag','UserDefined.TotalAveragePower'),'string',UserTotalAveragePower);
        
        %   Update Selected Load Plot
        if strcmp(GetListSelection('SelectedLoad'),LoadName)
            UpdateSelectedLoadPlot;
        end
        
        %   UpdateTotalLoad;
        UpdateTotalLoad;
        
        
        %---Control-------------------------------------------------------------    
    case 'Control'
        
        LoadName=strtok(get(gco,'tag'),'.');
        
        if ~isempty(strmatch(cellstr(LoadName),{'BrakeLights';'Misc';'Engine'}))
            msgbox('This load is automatically controlled.','Message','modal');
        elseif strcmp('Starter',cellstr(LoadName))
            DefaultDuration=get(findobj('tag',[LoadName,'.Control']),'userdata');
            DurationOn=inputdlg('Enter time (seconds) starter is on during each engine start:','Starter Duration',1,cellstr(num2str(DefaultDuration)));
            if ~isempty(DurationOn)
                try
                    set(findobj('tag',[LoadName,'.Control']),'UserData',str2num(DurationOn{1}));
                catch
                    warndlg('Not a valid input');
                end
            end
        else
            AuxControlFigControl(LoadName);
        end
        
        
        
    case 'Cancel'
%         GetCurrentFigName=get(findobj('tag','AuxLoadsFig'),'name');
%         %   Save load file name if exist
%         if ~strcmp(GetCurrentFigName,'Auxiliary Loads')
%             vinf.AuxLoads.SavedFile=get(findobj('tag','AuxLoadsFig'),'name');
%         end
        
        close(gcf);
        
    case 'Help'
        load_in_browser('aux_loads_help.html');
        
    case {'Back','Continue'}
        
        SaveFileName=GetListSelection('LoadFile');
        
        StandardAuxLoadFileNum=strmatch(SaveFileName,StandardAuxLoadFiles,'exact');
        if isempty(findstr('*',get(AuxLoadsFigHandle,'name')))
            vinf.AuxLoads.FileName=SaveFileName;
            %   Don't need to save or assign other vinf data because nothing has changed
            AuxLoadsFigControl('Cancel');
        elseif isempty(StandardAuxLoadFileNum) 
            
            %   Assign user selections to vinf.AuxLoads in workspace
            AssignVinfData(SaveFileName);
            
            %   Update saved aux loads file with changes
            SavePathName=strrep(which(SaveFileName),SaveFileName,'');
            
            SaveMatFile(vinf.AuxLoads,SaveFileName,SavePathName);
            
            close(findobj('tag','AuxLoadsFig'));
        else
            warndlg(['Cannot overwrite standard file: ',StandardAuxLoadFiles{StandardAuxLoadFileNum},'.  Must first save changes with a different name.']);
        end
        
   
        
    case 'SelectedLoad'
        UpdateSelectedLoadPlot;
        
    case 'UpdateAveragePower'
        LoadName=option2;
        UpdateAveragePower(LoadName);
        
    case 'UpdateSelectedLoadPlot'
        UpdateSelectedLoadPlot;
        
    case 'TotalLoad'
        UpdateTotalLoad;
        
    case 'UpdateLoadsOnOff'
        UpdateLoadsOnOff;
        
        
    end %end switch
    
end %end if nargin>0 




%   end of main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=====================================================================================
% GetVehTypeList
%   This function returns the ModelName's vehtype and loadchoice list 
%=====================================================================================
function [ReturnVehTypeList]=GetVehTypeList(ModelName)

VehTypeList=[];

%   Get HiV or V14 directory
if ~isempty(findobj('tag',[ModelName,'.14V'])) & get(findobj('tag',[ModelName,'.14V']),'value') == 1
    VoltType='V14';
else
    VoltType='HiV';
end

AdvisorPath=strrep(which('advisor.m'),'\advisor.m','');
ModelPath=[AdvisorPath,'\models\Saber\',ModelName,'\',VoltType,'\'];
    
% if folder doesn't exist, created folder and default file
if length(dir(ModelPath)) == 2  % if folder is empty (dir always get items . and ..)
    % create default file
    if ~isempty(strmatch(ModelName,GetLoadNames('CurrentLoad')))
        Data=[36,39,42,0,0,0];
        DataNames={'v1','v2','v3','c1','c2','c3'};
    elseif ~isempty(strmatch(ModelName,GetLoadNames('PowerLoad')))
        Data=0;
        DataNames={'Power'};
    elseif ~isempty(strmatch(ModelName,GetLoadNames('SpeedLoad')))
        Data=[800,6000,0,0];
        DataNames={'rpm1','rpm2','power1','power2'};
    end
    
    CreateModelFile('Default',ModelPath,Data,DataNames)
end


%   Get vehtypes that are in top level load name folder
FolderStruct=dir(ModelPath);
for j=1:length(FolderStruct)
    if ~strcmp(FolderStruct(j).name,'.') & ~strcmp(FolderStruct(j).name,'..')
        VehTypeList{end+1}=strrep(FolderStruct(j).name,'.m','');
    end
end

ReturnVehTypeList=VehTypeList;

%========================================================================================
% GetLoadChoiceList
%   This function returns the ModelName's loadchoice list for the specified vehicle type
%========================================================================================
function [ReturnLoadChoiceList]=GetLoadChoiceList(ModelName,VehTypeSelection)

%   Get HiV or V14 directory
if ~isempty(findobj('tag',[ModelName,'.14V'])) & get(findobj('tag',[ModelName,'.14V']),'value') == 1
    VoltType='V14';
else
    VoltType='HiV';
end

AdvisorPath=strrep(which('advisor.m'),'\advisor.m','');
LoadChoicesPath=[AdvisorPath,'\models\Saber\',ModelName,'\',VoltType,'\',VehTypeSelection,'\'];

FolderStruct=dir([LoadChoicesPath,'*.m']);
LoadChoiceList=[];
for j=1:length(FolderStruct)
    LoadChoiceList{end+1}=strrep(FolderStruct(j).name,'.m','');
end

ReturnLoadChoiceList=LoadChoiceList;

%=========================================================================================
% RestoreFigure
%   This function restores the current values to the Aux Loads GUI
%=========================================================================================
function RestoreFigure

global vinf;

LoadNames=GetLoadNames('All');
AllLoadsTypeList=GetLoadNames('StandardVehType');

%---Set acc_elec_pwr and acc_elec_eff-----------
set(findobj('tag','EditText_acc_elec_pwr'),'string',evalin('base','acc_elec_pwr'));
set(findobj('tag','EditText_acc_elec_eff'),'string',evalin('base','acc_elec_eff'));

%---Set "All Loads" lists-----------------------
%set(findobj('tag','AllLoads.VehType'),'string',{'Large_Car_1';'Mid_Sized_Car_1';'Sub_Compact_Car_1';'Small_SUV_1'})
set(findobj('tag','AllLoads.VehType'),'string',AllLoadsTypeList);
set(findobj('tag','AllLoads.LoadChoice'),'string',{'Lowest';'Highest'});

%---Set plot lists------------------------------
if strcmp(vinf.drivetrain.name,'saber_conv_sv') %isfield(vinf.saber_cosim,'type') & strcmp(vinf.saber_cosim.type,'SV')
    SelectedLoadList=[GetLoadNames('Volt42Or14Loads');GetLoadNames('Volt14OnlyLoad')];
else
    SelectedLoadList=GetLoadNames('All');
end
set(findobj('tag','SelectedLoad'),'string',SelectedLoadList);
set(findobj('tag','TotalLoad'),'string',{'14V Current Loads';'HiV Current Loads';'14V Power Loads';'HiV Power Loads';'14V Speed Loads';'HiV Speed Loads'});

%---Set Load File lists-------------------------
AccFiles=dir([strrep(vinf.tmppath,'tmp\','data\accessory\*_aux.mat')]);
for i=1:length(AccFiles)
    AccFilesList{i}=AccFiles(i).name;
end
set(findobj('tag','LoadFile'),'string',AccFilesList);
set(findobj('tag','LoadFile'),'value',strmatch(vinf.AuxLoads.FileName,AccFilesList));

for i=1:length(LoadNames)
    
    %   Restore Checkboxes On/Off
    if ~isempty(findobj('tag',[LoadNames{i},'.On']))
        if strcmp(vinf.accessory.type,'DV') &...
                strmatch(LoadNames{i},GetLoadNames('Volt42OnlyLoad'),'exact') %       if (~isfield(vinf.saber_cosim,'type') | ~strcmp(vinf.saber_cosim.type,'DV')) & strmatch(LoadNames{i},GetLoadNames('Volt42OnlyLoad'),'exact')
            set(findobj('tag',[LoadNames{i},'.On']),'value',eval(['vinf.AuxLoads.',LoadNames{i},'.On']));
        else
            set(findobj('tag',[LoadNames{i},'.On']),'value',eval(['vinf.AuxLoads.',LoadNames{i},'.On']));
        end
    end
    
    %   Restore 14V/HiV
    if ~isempty(findobj('tag',[LoadNames{i},'.14V']))
        set(findobj('tag',[LoadNames{i},'.14V']),'value',eval(['vinf.AuxLoads.',LoadNames{i},'.V14']));
    end
    if ~isempty(findobj('tag',[LoadNames{i},'.42V'])) %& isfield(vinf.saber_cosim,'type') & strcmp(vinf.saber_cosim.type,'DV')
        set(findobj('tag',[LoadNames{i},'.42V']),'value',eval(['vinf.AuxLoads.',LoadNames{i},'.HiV']));
    end
    
    %   Restore Vehicle Type List
    VehTypeList=GetVehTypeList(LoadNames{i});
    set(findobj('tag',[LoadNames{i},'.VehType']),'string',VehTypeList);
    
    %   Restore Load Choice List
    LoadChoiceList=GetLoadChoiceList(LoadNames{i},GetListSelection([LoadNames{i},'.VehType']));
    if ~isempty(LoadChoiceList)
        set(findobj('tag',[LoadNames{i},'.LoadChoice']),'string',LoadChoiceList);
    end   
    clear LoadChoiceList;
    
    %   Restore Vehicle Type
    if ~isempty(findobj('tag',[LoadNames{i},'.VehType']))
        VehTypeSelection=eval(['vinf.AuxLoads.',LoadNames{i},'.VehType']);
        VehTypeSelectionNum=strmatch(VehTypeSelection,VehTypeList,'exact');
        if ~isempty(VehTypeSelectionNum)
            set(findobj('tag',[LoadNames{i},'.VehType']),'value',VehTypeSelectionNum);
        else
            warndlg(['Attempted ''Type'' for load ''',LoadNames{i},''' no longer exists.  Top list choice has been substituted.'],'Warning');
            set(findobj('tag',[LoadNames{i},'.VehType']),'value',1);
            VehTypeReplacement=GetListSelection([LoadNames{i},'.VehType']);
            evalin('base',['vinf.AuxLoads.',LoadNames{i},'.VehType=''',VehTypeReplacement,''';']);
            
            %   Identify file as being changed
            if isfield(vinf.AuxLoads,'FileName') & isempty(findstr(vinf.AuxLoads.FileName,'*'))
                vinf.AuxLoads.FileName=[vinf.AuxLoads.FileName,'*'];
            end
        end
    end
    clear VehTypeList;
    
    %   Restore Load Choice
    if ~isempty(findobj('tag',[LoadNames{i},'.LoadChoice']))
        LoadChoiceList=get(findobj('tag',[LoadNames{i},'.LoadChoice']),'string');
        set(findobj('tag',[LoadNames{i},'.LoadChoice']),'value',strmatch(eval(['vinf.AuxLoads.',LoadNames{i},'.LoadChoice']),LoadChoiceList,'exact'));
        clear LoadChoiceList;
    end
    
    %   Restore Control
    if ~isempty(findobj('tag',[LoadNames{i},'.Control'])) & isempty(strmatch(LoadNames(i),{'BrakeLights';'Engine';'Misc';'ComboLoads';'Starter'}))
        set(findobj('tag',[LoadNames{i},'.Control']),'userdata',eval(['vinf.AuxLoads.',LoadNames{i},'.OnOffInfo']));
    elseif strcmp(LoadNames(i),'Starter')
        set(findobj('tag',[LoadNames{i},'.Control']),'userdata',eval(['vinf.AuxLoads.',LoadNames{i},'.DurationOn']));
    end
    
    %   Restore Average Power
    UpdateAveragePower(LoadNames{i});
    
end

%   Reset Enable/Disable
for i=1:length(LoadNames)
    OnHandle=findobj('tag',[LoadNames{i},'.On']);
    AuxLoadsFigControl('On',OnHandle);
end
    
%   Set enable off for SV only loads
if strcmp(vinf.drivetrain.name,'saber_conv_sv') %evalin('base','exist(''acc_mech_model_name'')') & strcmp(evalin('base','acc_mech_model_name'),'Saber Single Voltage Cosim')    % strcmp(vinf.accessory.type,'SV')
    V42OnlyLoads=GetLoadNames('Volt42OnlyLoad');
    for i=1:length(V42OnlyLoads)
        set(findobj('tag',[V42OnlyLoads{i},'.On']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.Add']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.VehType']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.LoadChoice']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.Control']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.AveragePower']),'enable','off');
        set(findobj('tag',[V42OnlyLoads{i},'.TimeAveragePower']),'enable','off');
    end
end

%   Set SaberCosim/Advisor Alone info
set(findobj('tag','SaberCosimOn'),'enable','off');
set(findobj('tag','AdvisorAlone'),'enable','off');
if vinf.saber_cosim.run==1
    set(findobj('tag','SaberCosimOn'),'value',1);
    set(findobj('tag','AdvisorAlone'),'value',0);
else
    set(findobj('tag','SaberCosimOn'),'value',0);
    set(findobj('tag','AdvisorAlone'),'value',1);
end

%   Restore saved file name if exist
if isfield(vinf.AuxLoads,'FileName')
    set(findobj('tag','AuxLoadsFig'),'name',vinf.AuxLoads.FileName)
end

%=====================================================================================
% AssignVinfData
%   This function assigns the figures current vinf values
%=====================================================================================
function AssignVinfData(FileName)

global vinf

CurrentWorkingDir=cd;

%   Assign acc_elec_pwr
UserInputString=get(findobj('tag','EditText_acc_elec_pwr'),'string');
SingleInput=strtok(UserInputString);
if ~isempty(str2num(SingleInput))
    gui_edit_var('modify','acc_elec_pwr',SingleInput);
end

%   Assign acc_elec_eff
UserInputString=get(findobj('tag','EditText_acc_elec_eff'),'string');
SingleInput=strtok(UserInputString);
if ~isempty(str2num(SingleInput))
    gui_edit_var('modify','acc_elec_eff',SingleInput);
end

%   Assign modify variable vinf.RunFileMods aux load file change
FileListString=get(findobj('tag','LoadFile'),'string');
FileListValue=get(findobj('tag','LoadFile'),'value');
SavedFileName=FileListString{FileListValue};
vinf.AuxLoads.FileName=SavedFileName;
RunFilesMods('modify','vinf.AuxLoads',['load(''',SavedFileName,''')'],'acc');

LoadNames=GetLoadNames('All');
for i=1:length(LoadNames)
    
    VoltType=GetVoltageType(LoadNames{i});

    %   Assign On/Off and CheckboxOnOff 
    if strcmp(get(findobj('tag',[LoadNames{i},'.On']),'enable'),'on')
        eval(['vinf.AuxLoads.',LoadNames{i},'.On=',num2str(get(findobj('tag',[LoadNames{i},'.On']),'value')),';']);
    else
        eval(['vinf.AuxLoads.',LoadNames{i},'.On=0;']);
    end
    
    %   Assign 14V/HiV
    if ~isempty(findobj('tag',[LoadNames{i},'.42V']))
        eval(['vinf.AuxLoads.',LoadNames{i},'.HiV=',num2str(get(findobj('tag',[LoadNames{i},'.42V']),'value')),';']);
    end
    if ~isempty(findobj('tag',[LoadNames{i},'.14V']))
        eval(['vinf.AuxLoads.',LoadNames{i},'.V14=',num2str(get(findobj('tag',[LoadNames{i},'.14V']),'value')),';']); 
    end

    %   Assign OnOffData (Control)
    if isempty(strmatch(LoadNames(i),{'BrakeLights';'Engine';'Misc';'ComboLoads';'Starter'}))
        ControlInfo=get(findobj('tag',[LoadNames{i},'.Control']),'UserData');
        ControlData=CalcLoadOnOffData(ControlInfo);
        eval(['vinf.AuxLoads.',LoadNames{i},'.OnOffInfo=ControlInfo;']);
        eval(['vinf.AuxLoads.',LoadNames{i},'.OnOffData=ControlData;']);
    elseif strcmp(LoadNames(i),'Starter')
        ControlInfo=get(findobj('tag',[LoadNames{i},'.Control']),'UserData');
        eval(['vinf.AuxLoads.',LoadNames{i},'.DurationOn=ControlInfo;']);
    end
    
    %   Assign SaberVehType & SaberLoadChoice
    VehTypeFolder=[];
    VehType=GetListSelection([LoadNames{i},'.VehType']);
    VehTypeFile=[LoadNames{i},'\',VoltType,'\',VehType];
    VehTypeFileBasePath=strrep(vinf.tmppath,'tmp\',['models\Saber\',VehTypeFile]);
    
    eval(['vinf.AuxLoads.',LoadNames{i},'.SaberVehType=6;']);%   Never actually use Saber vehicle type specific load models:  use custom Saber load models
    if ~isempty(findobj('tag',[LoadNames{i},'.LoadChoice']))
        eval(['vinf.AuxLoads.',LoadNames{i},'.SaberLoadChoice=1;']);
    end
    
if isdir(VehTypeFileBasePath)
    VehTypeFolder=VehType;
    LoadChoiceName=GetListSelection([LoadNames{i},'.LoadChoice']);
else
    LoadChoiceName=[];
end
eval(['vinf.AuxLoads.',LoadNames{i},'.SaberVehType=6;']);
%     end
    
    %   Assign VehType 
    eval(['vinf.AuxLoads.',LoadNames{i},'.VehType=GetListSelection([LoadNames{i},''.VehType'']);']);   %num2str(get(findobj('tag',[LoadNames{i},'.VehType']),'value')),';']);
    
    %   Assign LoadChoice
    if ~isempty(findobj('tag',[LoadNames{i},'.LoadChoice']))
        %         eval(['vinf.AuxLoads.',LoadNames{i},'.LoadChoice=',num2str(get(findobj('tag',[LoadNames{i},'.LoadChoice']),'value')),';']);
        eval(['vinf.AuxLoads.',LoadNames{i},'.LoadChoice=GetListSelection([LoadNames{i},''.LoadChoice'']);']); 
    end
    
    %   Assign Average Power
    if ~isempty(get(findobj('tag',[LoadNames{i},'.AveragePower']),'string'))
        eval(['vinf.AuxLoads.',LoadNames{i},'.AverageWatts=str2num(get(findobj(''tag'',[LoadNames{i},''.AveragePower'']),''string''));']);
    else
        eval(['vinf.AuxLoads.',LoadNames{i},'.AverageWatts=0;']);
    end
    
    %   Change current directory to get data
    TempDir=strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadNames{i},'\',VoltType]);
    if ~isempty(VehTypeFolder)
        TempDir=[TempDir,'\',VehTypeFolder];
        cd(TempDir);
        Data=eval(LoadChoiceName);
    else
        cd(TempDir);
        Data=eval(VehType);
    end
    
    
    %   CurrentLoads
    if ~isempty(strmatch(LoadNames(i),GetLoadNames('CurrentLoad')))
        CurrentData=transpose(Data(1:3));
        CurrentData(1:3,2)=transpose(Data(4:6));
        eval(['vinf.AuxLoads.',LoadNames{i},'.Data=CurrentData;']);
    end
    
    %   PowerLoads
    if ~isempty(strmatch(LoadNames(i),GetLoadNames('PowerLoad')))
        eval(['vinf.AuxLoads.',LoadNames{i},'.Data=[',num2str(Data),'];']);
    end
    
    %   SpeedLoads
    if ~isempty(strmatch(LoadNames(i),GetLoadNames('SpeedLoad')))
        SpeedData(1:2,1)=transpose(Data(1:2));
        SpeedData(1:2,2)=transpose(Data(3:4));
        eval(['vinf.AuxLoads.',LoadNames{i},'.Data=SpeedData;']);
    end
    
    %   PowerLoads
    if ~isempty(strmatch(LoadNames(i),GetLoadNames('SingleCurrentLoad')))
        eval(['vinf.AuxLoads.',LoadNames{i},'.Data=[',num2str(Data),'];']);
    end
        
end

vinf.AuxLoads.FileName=FileName;


%   Assign Userdefined On/Off
% vinf.AuxLoads.UserDefined.On=get(findobj('tag','UserDefined.On'),'value');

%   Restore orginal working directory
cd(CurrentWorkingDir);

%=====================================================================================
% DefineLoadOnOff
%   This function uses the on/off information stored in the control button's userdata
%   to calculate and assign on/off info
%=====================================================================================
function UpdateLoadsOnOff

global vinf

Loads=GetLoadNames('UserDefined');

for i=1:length(Loads)
    Load=eval(['vinf.AuxLoads.',Loads{i}]);
    
    %   If defined by toggle times
    if ~isempty('Load.ToggleTimes')
        ToggleTimes=Load.ToggleTimes;
        InitialOn=Load.InitialOn;
        
        if ToggleTimes(1) == 0
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
        
    elseif ~isempty('Load.StartTime')
        ToggleTimes=Load.StartTime;
        InitialOn=0;
        
        if ToggleTimes(1) == 0
            InitialOn=~InitialOn;
            ToggleTimes=ToggleTimes(2:length(ToggleTimes));
        end
        
    else
        eval(['vinf.AuxLoads.',Loads{i},'.OnOffData=[0 1]']);
        
    end
end



%=====================================================================================
% UpdateSelectedLoadPlot
%   This function updates the selected load plot
%=====================================================================================
function UpdateSelectedLoadPlot

global vinf

LoadName=GetListSelection('SelectedLoad');
axes(findobj('tag','SelectedLoadAxes'));

%   Get load data
VoltType=GetVoltageType(LoadName);
VehType=GetListSelection([LoadName,'.VehType']);
if ~isempty(findobj('tag',[LoadName,'.LoadChoice']))...
        & isdir(strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',GetVoltageType(LoadName),'\',GetListSelection([LoadName,'.VehType'])]))       %strcmp(get(findobj('tag',[LoadName,'.LoadChoice']),'enable'),'on')
    LoadChoice=GetListSelection([LoadName,'.LoadChoice']);
    Data=GetLoadModelData(LoadName,VoltType,VehType,LoadChoice);
else
    Data=GetLoadModelData(LoadName,VoltType,VehType);
end

if ~isempty(strmatch(LoadName,GetLoadNames('CurrentLoad'),'exact'))
    plot(Data(:,1),Data(:,2));
    Xlabel('Volts','fontweight','bold','fontsize',8);
    Ylabel('Amps','fontweight','bold','fontsize',8);
    set(gca,'tag','SelectedLoadAxes');
    TempY=YLim;
    TempY(1)=0;
    YLim(TempY);
elseif ~isempty(strmatch(LoadName,GetLoadNames('SpeedLoad'),'exact'))
    plot(Data(:,1),Data(:,2));
    Xlabel('Speed','fontweight','bold','fontsize',8);
    Ylabel('RPM','fontweight','bold','fontsize',8);
    set(gca,'tag','SelectedLoadAxes');
    TempY=YLim;
    TempY(1)=0;
    YLim(TempY);
elseif ~isempty(strmatch(LoadName,GetLoadNames('PowerLoad'),'exact'))
    plot(0,Data,'o');
    Xlabel('','fontweight','bold','fontsize',8);
    Ylabel('Watts','fontweight','bold','fontsize',8);
    set(gca,'tag','SelectedLoadAxes');
end


%=====================================================================================
% UpdateAveragePower(LoadName)
%   This function updates the average power of a load
%=====================================================================================
function UpdateAveragePower(LoadName)

global vinf

%   Update Average Power (on and time average)
if get(findobj('tag',[LoadName,'.On']),'value')==1
    
    %   Get load data
    VoltType=GetVoltageType(LoadName);
    VehType=GetListSelection([LoadName,'.VehType']);
    TempDir=strrep(vinf.tmppath,'tmp\',['models\Saber\',LoadName,'\',VoltType]);   
    if ~isempty(findobj('tag',[LoadName,'.LoadChoice'])) & isdir([TempDir,'\',VehType])  %strcmp(get(findobj('tag',[LoadName,'.LoadChoice']),'enable'),'on')
        LoadChoice=GetListSelection([LoadName,'.LoadChoice']);
        Data=GetLoadModelData(LoadName,VoltType,VehType,LoadChoice);
    else
        Data=GetLoadModelData(LoadName,VoltType,VehType);
    end
    
    
    %   Set average power
    if ~isempty(strmatch(LoadName,GetLoadNames('CurrentLoad')))
        AvePower=num2str(AveragePower(Data));
        set(findobj('tag',[LoadName,'.AveragePower']),'string',AvePower);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('SpeedLoad')))
        AvePower=num2str(sum(Data(:,2))/2);
        set(findobj('tag',[LoadName,'.AveragePower']),'string',AvePower);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('PowerLoad')))
        AvePower=num2str(Data);
        set(findobj('tag',[LoadName,'.AveragePower']),'string',AvePower);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('SingleCurrentLoad')))
        switch VoltType
        case 'V14'
            Volts=14;
        case 'HiV'
            Volts=42;
        end
        AvePower=num2str(Data*Volts);
        set(findobj('tag',[LoadName,'.AveragePower']),'string',AvePower);
    end
    
    %   If UserDefined, set cycle average power
    if ~isempty(strmatch(cellstr(LoadName),GetLoadNames('UserDefined'),'exact'))...
            & ~isempty(get(findobj('tag',[LoadName,'.Control']),'userdata'))...
            & ~strcmp(LoadName,'Starter')
        
        %   Get on off area
        CycleTimeLength=evalin('base','max(cyc_mph(:,1))');
        OnOffInfo=get(findobj('tag',[LoadName,'.Control']),'userdata');
        OnOffData=CalcLoadOnOffData(OnOffInfo);
        if length(OnOffData(:,1)) == 1
            OnOffArea=CycleTimeLength*OnOffData(1,2);
        elseif length(OnOffData(:,1)) >= 2
            for i=1:length(OnOffData(:,1))-1
                OnOffArea(i)=(((OnOffData(i,2)+OnOffData(i+1,2))/2)*(OnOffData(i+1,1)-OnOffData(i,1)));
            end
        end
        
        %   Set cycle average power
        if sum(OnOffArea) ~= 0
            TimeAveragePower=(sum(OnOffArea)/CycleTimeLength)*str2num(AvePower);
        else
            TimeAveragePower=0;
        end
        set(findobj('tag',[LoadName,'.TimeAveragePower']),'string',num2str(round(TimeAveragePower)));
    end
    
else
    set(findobj('tag',[LoadName,'.AveragePower']),'string',[]);
    set(findobj('tag',[LoadName,'.TimeAveragePower']),'string',[]);
end


%=======================================================================
% EnableObj
%   This function translates a 1 or 0 input into a 'On' or 'Off' output
%   CheckboxOnOff Format:   '1' or '2'
%   EnableOnOff Format:   'On' or 'Off'
%=======================================================================
function [EnableOnOff]=EnableObj(CheckboxOnOff)
if CheckboxOnOff == 1
    EnableOnOff='On';
else
    EnableOnOff='Off';
end



%=======================================================================
% function SelectionString=GetListSelection(Tag)
%   This function returns the current pulldown list string
%=======================================================================
function SelectionString=GetListSelection(TheTag)

FigHandle=findobj('tag','AuxLoadsFig');
StringList=get(findobj(FigHandle,'tag',TheTag),'string');
TagValue=get(findobj(FigHandle,'tag',TheTag),'value');

SelectionString=StringList{TagValue};



%==================================================================================
% SummedCurves
%   This function sums 2D curves
%   CurvesMatrix Format:    (xvalues,yvalues,CurveNumber for those x and y values)
%   SummedCurves:   (Every unique x, sum of y values at each x)
%==================================================================================
function SummedCurves=Sum2DCurves(CurvesMatrix)


NumCurves=length(CurvesMatrix(1,1,:));

xPoints=[CurvesMatrix(:,1,1:NumCurves)];
xPoints=xPoints(:);

xPoints=sort(xPoints);
xPoints=unique(xPoints);

for i=1:NumCurves
    NewCurves(:,i)=interp1(CurvesMatrix(:,1,i),CurvesMatrix(:,2,i),xPoints);
end



for j=1:NumCurves
    for i=1:length(xPoints)
        if isnan(NewCurves(i,j))
            NewCurves(i,j)=0;
        end
    end
end

NewCurvesSum=sum(NewCurves,2);

SummedCurves=[xPoints,NewCurvesSum];



%=====================================================================
% UpdateTotalLoad
%   This function checks which checkboxes are selected, adds their
%   curves, and plots the total under the Total Load Plot
%=====================================================================
function UpdateTotalLoad

LoadType=GetListSelection('TotalLoad');

%   Determine total type (current, speed, power)
if strcmp(LoadType,'14V Current Loads') | strcmp(LoadType,'HiV Current Loads')
    LoadNames=GetLoadNames('CurrentLoad');
    CurveNumber=1;
    for i=1:length(LoadNames)
        if get(findobj('tag',[LoadNames{i},'.On']),'value')==1 &...
                strcmp(get(findobj('tag',[LoadNames{i},'.On']),'enable'),'on') &...
                ~isempty(findstr(strrep(GetVoltageType(LoadNames{i}),'V',''),LoadType))
            
            VoltType=GetVoltageType(LoadNames{i});
            %   Get Data
            if isempty(findobj('tag',[LoadNames{i},'.LoadChoice']))
                Data=GetLoadModelData(LoadNames{i},VoltType,GetListSelection([LoadNames{i},'.VehType']));
            else
                Data=GetLoadModelData(LoadNames{i},VoltType,GetListSelection([LoadNames{i},'.VehType']),GetListSelection([LoadNames{i},'.LoadChoice']));
            end
            
            TotalLoadCurveMatrix(:,:,CurveNumber)=Data;
            CurveNumber=CurveNumber+1;
        end
    end
    
    %   Sum TotalLoadCurveMatrix Curves Into One Curve
    if exist('TotalLoadCurveMatrix')
        TotalSum=Sum2DCurves(TotalLoadCurveMatrix);
    end
    
    %   Plot
    AxesHandle=findobj('tag','TotalLoadAxes');
    axes(AxesHandle);
    if exist('TotalSum')
        plot(TotalSum(:,1),TotalSum(:,2));
    else
        cla;
    end
    set(AxesHandle,'tag','TotalLoadAxes');
    TempY=YLim;
    TempY(1)=0;
    YLim(TempY);
    xlabel('Volts','fontweight','bold','fontsize',8);
    ylabel('Amps','fontweight','bold','fontsize',8);
    
elseif strcmp(LoadType,'14V Speed Loads') | strcmp(LoadType,'HiV Speed Loads')
    LoadNames=GetLoadNames('SpeedLoad');
    CurveNumber=1;
    for i=1:length(LoadNames)
        if get(findobj('tag',[LoadNames{i},'.On']),'value')==1 &...
                strcmp(get(findobj('tag',[LoadNames{i},'.On']),'enable'),'on') &...
                ~isempty(findstr(strrep(GetVoltageType(LoadNames{i}),'V',''),LoadType))
            
            %   Get Data
            VoltType=GetVoltageType(LoadNames{i});
            if isempty(findobj('tag',[LoadNames{i},'.LoadChoice']))
                Data=GetLoadModelData(LoadNames{i},VoltType,GetListSelection([LoadNames{i},'.VehType']));
            else
                Data=GetLoadModelData(LoadNames{i},VoltType,GetListSelection([LoadNames{i},'.VehType']),GetListSelection([LoadNames{i},'.LoadChoice']));
            end
            
            TotalLoadCurveMatrix(:,:,CurveNumber)=Data;
            CurveNumber=CurveNumber+1;
        end
    end
    
    %   Sum TotalLoadCurveMatrix Curves Into One Curve
    if exist('TotalLoadCurveMatrix')
        TotalSum=Sum2DCurves(TotalLoadCurveMatrix);
    end
    
    %   Plot
    AxesHandle=findobj('tag','TotalLoadAxes');
    axes(AxesHandle);
    if exist('TotalSum')
        plot(TotalSum(:,1),TotalSum(:,2));
    else
        cla;
    end
    
    set(AxesHandle,'tag','TotalLoadAxes');
    TempY=YLim;
    TempY(1)=0;
    YLim(TempY);
    xlabel('RPM','fontweight','bold','fontsize',8);
    ylabel('Watts','fontweight','bold','fontsize',8);
    
elseif strcmp(LoadType,'14V Power Loads') | strcmp(LoadType,'HiV Power Loads')
    LoadNames=GetLoadNames('PowerLoad');
    TotalSum=0;
    for i=1:length(LoadNames)
        if ~isempty(findstr(strrep(GetVoltageType(LoadNames{i}),'V',''),LoadType))
            VoltType=GetVoltageType(LoadNames{i});
            if get(findobj('tag',[LoadNames{i},'.On']),'value')==1 & strcmp(get(findobj('tag',[LoadNames{i},'.On']),'enable'),'on')
                Data=GetLoadModelData(LoadNames{i},VoltType,GetListSelection([LoadNames{i},'.VehType']));
                TotalSum=Data+TotalSum;
            end
        end
    end
    
    %   Plot
    AxesHandle=findobj('tag','TotalLoadAxes');
    axes(AxesHandle);
    if exist('TotalSum')
        plot(0,TotalSum,'o');
    else
        cla;
    end
    
    set(AxesHandle,'tag','TotalLoadAxes');
    TempY=YLim;
    TempY(1)=0;
    YLim(TempY);
    xlabel('','fontweight','bold','fontsize',8);
    ylabel('Watts','fontweight','bold','fontsize',8);
    
end



%=====================================================================================
% UserTotalAveragePower
%   This function returns the sum of the user defined average powers
%=====================================================================================
function TotalAvePower=UserTotalAveragePower

LoadNames=GetLoadNames('UserDefined');

for i=1:length(LoadNames)
    Value=get(findobj('tag',[LoadNames{i},'.AveragePower']),'string');
    if ~isempty(Value);
        Powers(i)=str2num(Value);
    end
end

if ~exist('Powers')
    Powers=0;
end


TotalAvePower=num2str(sum(Powers));

%=====================================================================================
% GetVoltageType
%   This function returns '14V' or 'HiV' depending on the selection
%=====================================================================================
function Volts=GetVoltageType(LoadName)

if ~isempty(findobj('tag',[LoadName,'.14V'])) & get(findobj('tag',[LoadName,'.14V']),'value') == 1
    Volts='V14';
else
    Volts='HiV';
end

%=====================================================================================
% AveragePower
%   This function calculates an average power from multiple voltage vs current data
%=====================================================================================
function Watts=AveragePower(Data)

global vinf

%   Find Power
PowerData(:,1)=Data(:,1);
PowerData(:,2)=Data(:,1).*Data(:,2);
for i=1:length(Data(:,1))-1
    PowerArea(i)=(((PowerData(i,2)+PowerData(i+1,2))/2)*(PowerData(i+1,1)-PowerData(i,1)));
end

Watts=round(sum(PowerArea)/(max(Data(:,1))-min(Data(:,1))));


%=====================================================================================
% SaveMatFile
%   This function saves the current gui data
%=====================================================================================
function SaveMatFile(AuxLoads,SaveFileName,SavePathName);

LoadNames=GetLoadNames('All');

for i=1:length(LoadNames)
    eval([LoadNames{i},'=AuxLoads.',LoadNames{i},';']);
end

FileName=SaveFileName;
LoadNames{end+1}='FileName';

save([SavePathName,SaveFileName],LoadNames{:});

%=====================================================================================
% CheckSaved
%   This function checks for changes in the current gui data
%=====================================================================================
function IsSaved=CheckSaved

FileNameList=get(findobj('tag','LoadFile'),'string');
FileNameValue=get(findobj('tag','LoadFile'),'value');
FileName=FileNameList{FileNameValue};

SavedFileData.AuxLoads=load(FileName);

CurrentData.AuxLoads=evalin('base','vinf.AuxLoads');
CurrentData.AuxLoads=rmfield(CurrentData.AuxLoads,'On');

IsSaved=isequal(CurrentData,SavedFileData);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)
