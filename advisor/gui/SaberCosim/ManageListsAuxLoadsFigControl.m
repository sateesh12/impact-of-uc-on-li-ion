function ManageListsAuxLoadsFigControl(option1,option2,option3);
% function ManageListsAuxLoadsFigControl(option1,option2,option3);
%   This function controls the ManageListFig.fig 

global vinf % need for vinf.tmppath

if isempty(findobj('tag','ManageList'))
    
    LoadName=option1;
    ListDir=option2;
    CurrentList=option3;
    
    %open('ManageListFig.fig');
    ManageListFigHandle=ManageListFig;
    set(gcf,'windowstyle','modal');
    
    %   Center the figure on the screen
    center_figure(ManageListFigHandle);
    
    %   set everything normalized 
    h=findobj(gcf,'type','uicontrol');
    set(h,'units','normalized');
    
    %   set descriptive text
    set(findobj(ManageListFigHandle,'tag','StaticText1'),'string','Load Name:');
    set(findobj(ManageListFigHandle,'tag','ListVarName'),'string',LoadName);
    set(findobj(ManageListFigHandle,'tag','StaticText2'),'string','Load Directory:');
    set(findobj(ManageListFigHandle,'tag','ListFileName'),'string',ListDir);
    
    set(findobj(ManageListFigHandle,'tag','ListBox'),'string',CurrentList);
    
    %   set button callback functions (go to this control file)
    set(findobj(ManageListFigHandle,'string','Create'),'Callback','ManageListsAuxLoadsFigControl(''Add'')');
    set(findobj(ManageListFigHandle,'string','Edit'),'Callback','ManageListsAuxLoadsFigControl(''Edit'')');
    set(findobj(ManageListFigHandle,'string','Delete'),'Callback','ManageListsAuxLoadsFigControl(''Delete'')');
    set(findobj(ManageListFigHandle,'string','Rename'),'Callback','ManageListsAuxLoadsFigControl(''Rename'')');
    set(findobj(ManageListFigHandle,'string','Done'),'Callback','ManageListsAuxLoadsFigControl(''Done'')');
    set(findobj(ManageListFigHandle,'string','Back'),'Callback','ManageListsAuxLoadsFigControl(''Back'')');
    set(findobj(ManageListFigHandle,'string','Cancel'),'Callback','ManageListsAuxLoadsFigControl(''Cancel'')');
    set(findobj(ManageListFigHandle,'string','Help'),'Callback','ManageListsAuxLoadsFigControl(''Help'')');
    
    %   Set figure visible
    set(ManageListFigHandle,'visible','on');
    
else
    ListDir=get(findobj('tag','ListFileName'),'string');
    LoadName=get(findobj('tag','ListVarName'),'string');
    
    %   Get voltage info
    if ~isempty(findobj('tag',[LoadName,'.14V'])) & get(findobj('tag',[LoadName,'.14V']),'value') == 1
        VoltType='V14';
    else
        VoltType='HiV';
    end

end


switch option1
    
case 'Add'
    
    ListValue=get(findobj('tag','ListBox'),'value');
    List=get(findobj('tag','ListBox'),'string');
    VehType=List{ListValue};
    
    %   Get the selected load model data
    if ~isempty(findobj('tag',[LoadName,'.LoadChoice']))
        LoadChoiceString=get(findobj('tag',[LoadName,'.LoadChoice']),'string');
        LoadChoiceValue=get(findobj('tag',[LoadName,'.LoadChoice']),'value');
        LoadChoice=LoadChoiceString{LoadChoiceValue};
    
        CurrentSelectedData=GetLoadModelData(LoadName,VoltType,VehType,LoadChoice);
    else
        CurrentSelectedData=GetLoadModelData(LoadName,VoltType,VehType);
    end
    
    LoadName=cellstr(LoadName);
    
    if ~isempty(strmatch(LoadName,GetLoadNames('CurrentLoad')))
        CustomVehTypeFigControl(LoadName,CurrentSelectedData);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('SpeedLoad')))
        ParamList=GetLoadFields('SpeedLoad');
        ParamValueListRaw=GetLoadModelData(LoadName{1},VoltType,VehType);
        ParamValueList=[ParamValueListRaw(1,1) ParamValueListRaw(2,1) ParamValueListRaw(1,2) ParamValueListRaw(2,2)];
        CustomParamFigControl2(LoadName{1},ParamList,ParamValueList);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('PowerLoad')))
        ParamList=GetLoadFields('PowerLoad');
        ParamValueList=GetLoadModelData(LoadName{1},VoltType,VehType);
        CustomParamFigControl2(LoadName{1},ParamList,ParamValueList);
    elseif ~isempty(strmatch(LoadName,GetLoadNames('SingleCurrentLoad')))
        ParamList=GetLoadFields('SingleCurrentLoad');
        ParamValueList=GetLoadModelData(LoadName{1},VoltType,VehType);
        CustomParamFigControl2(LoadName{1},ParamList,ParamValueList);
    end
    
    
case 'Edit'
    %   Get selected string
    ListBoxString=get(findobj('tag','ListBox'),'string');
    SelectedStringValue=get(findobj('tag','ListBox'),'value');
    SelectedString=ListBoxString(SelectedStringValue);
    VehTypeName=cellstr([LoadName,'\',VoltType,'\',SelectedString{1}]);
    
    if isempty(strmatch(VehTypeName,GetLoadNames('StandardVehTypeNames')))
        
        ListValue=get(findobj('tag','ListBox'),'value');
        List=get(findobj('tag','ListBox'),'string');
        VehType=List{ListValue};
        
        %   Get the selected load model data
        if ~isempty(findobj('tag',[LoadName,'.LoadChoice']))
            LoadChoiceString=get(findobj('tag',[LoadName,'.LoadChoice']),'string');
            LoadChoiceValue=get(findobj('tag',[LoadName,'.LoadChoice']),'value');
            LoadChoice=LoadChoiceString{LoadChoiceValue};
            
            CurrentSelectedData=GetLoadModelData(LoadName,VoltType,VehType,LoadChoice);
        else
            CurrentSelectedData=GetLoadModelData(LoadName,VoltType,VehType);
        end
        
        LoadName=cellstr(LoadName);
        
        if ~isempty(strmatch(LoadName,GetLoadNames('CurrentLoad')))
            CustomVehTypeFigControl(LoadName,CurrentSelectedData,VehType);
        elseif ~isempty(strmatch(LoadName,GetLoadNames('SpeedLoad')))
            ParamList=GetLoadFields('SpeedLoad');
            ParamValueListRaw=GetLoadModelData(LoadName{1},VoltType,VehType);
            ParamValueList=[ParamValueListRaw(1,1) ParamValueListRaw(2,1) ParamValueListRaw(1,2) ParamValueListRaw(2,2)];
            CustomParamFigControl2(LoadName{1},ParamList,ParamValueList,SelectedString{1});
        elseif ~isempty(strmatch(LoadName,GetLoadNames('PowerLoad')))
            ParamList=GetLoadFields('PowerLoad');
            ParamValueList=GetLoadModelData(LoadName{1},VoltType,VehType);
            CustomParamFigControl2(LoadName{1},ParamList,ParamValueList,SelectedString{1});
        elseif ~isempty(strmatch(LoadName,GetLoadNames('SingleCurrentLoad')))
            ParamList=GetLoadFields('SingleCurrentLoad');
            ParamValueList=GetLoadModelData(LoadName{1},VoltType,VehType);
            CustomParamFigControl2(LoadName{1},ParamList,ParamValueList,SelectedString{1});
        end
    else
        warndlg('Only valid for user defined vehicle types');
    end
    
case 'Delete'
    %   Create path to dir to search in
    AdvisorPath=strrep(which('advisor.m'),'\advisor.m','');
    ModelsPath=[AdvisorPath,'\models\Saber\',LoadName,'\',VoltType,'\'];
    
    %   Get selected string
    ListBoxString=get(findobj('tag','ListBox'),'string');
    SelectedStringValue=get(findobj('tag','ListBox'),'value');
    SelectedString=ListBoxString(SelectedStringValue);
    VehTypeName=cellstr([LoadName,'\',VoltType,'\',SelectedString{1}]);
    
    %   Delete file and list item
    if isempty(strmatch(VehTypeName,GetLoadNames('StandardVehTypeNames')))
        FileName=SelectedString{1};
        clear([ModelsPath,FileName,'.m']);
        delete([ModelsPath,FileName,'.m']);
        StringValueCounter=1;
        for i=1:length(ListBoxString)
            if ~strcmp(ListBoxString(i),SelectedString)
                NewListString(StringValueCounter)=ListBoxString(i);
                StringValueCounter=StringValueCounter+1;
            end
        end
        set(findobj('tag','ListBox'),'string',NewListString);
        set(findobj('tag','ListBox'),'value',1);
    else
        warndlg('Only user defined vehicle types can be deleted or renamed');
    end
    
    
    
case {'Done','Back'}
    ListSelectionValue=get(findobj('tag','ListBox'),'value');
    List=get(findobj('tag','ListBox'),'string');
    set(findobj('tag',[LoadName,'.VehType']),'string',List);
    set(findobj('tag',[LoadName,'.VehType']),'value',ListSelectionValue);
    close(gcf);
    AuxLoadsFigControl('VehType',findobj('tag',[LoadName,'.VehType']));
   
case 'Help'
    load_in_browser('aux_loads_help4.htm');
    
case 'Cancel'
    close(gcf);
    
end % end switch option1



%=======================================================================
% GetLoadFields(Type)
%   This function returns load parameter fields of "Type"
%=======================================================================
function Fields=GetLoadFields(Type)

switch Type
case 'CurrentLoad'
    Fields={'v1';...
            'v2';...
            'v3';...
            'c1';...
            'c2';...
            'c3'};
    
case 'PowerLoad'
    Fields={'Power'};
    
case 'SpeedLoad'
    Fields={'rpm1';...
            'rpm2';...
            'power1';...
            'power2'};
    
case 'SingleCurrentLoad'
    Fields={'Current'};
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)
