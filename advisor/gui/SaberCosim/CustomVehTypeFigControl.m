function CustomVehTypeFigControl(option1,DataIn,EditingName)
% CustomVehTypeFigControl(option1,VarName,LoadName,VehType,DataIn)
%   This function controls the CustomVehTypeFig
%   Basic Functionality
%       if option1 is a .mat filename
%           set all custom values to selected load values (give user base values to customize from)
%       else 
%           push button functionality
%   CustomVehTypeFig (figure) can be modified by using Guide.  **NOTE**: Use snap to grid and grid spacing=10

CurrentWorkingDir=cd;

if isempty(findobj('tag','CustomVehTypeFig'))
    LoadName=option1;
    CustomVehTypeFigHandle=CustomVehTypeFig;
    set(CustomVehTypeFigHandle,'windowstyle','modal');
 
    %   Center the figure on the screen
    center_figure(CustomVehTypeFigHandle);
    
    %   set everything normalized 
    h=findobj(CustomVehTypeFigHandle,'type','uicontrol');
    g=findobj(CustomVehTypeFigHandle,'type','axes');
    set([h; g],'units','normalized');    
    
    title(LoadName);
    
    if exist('EditingName')
        set(findobj('tag','LoadName'),'string',EditingName);
        set(findobj('tag','LoadName'),'enable','off');
    else        
        set(findobj('tag','LoadName'),'string','Custom');
    end
    
    set(findobj('tag','C1'),'string',num2str(DataIn(1,2)));
    set(findobj('tag','C2'),'string',num2str(DataIn(2,2)));
    set(findobj('tag','C3'),'string',num2str(DataIn(3,2)));
    
    set(findobj('tag','V1'),'string',num2str(DataIn(1,1)));
    set(findobj('tag','V2'),'string',num2str(DataIn(2,1)));
    set(findobj('tag','V3'),'string',num2str(DataIn(3,1)));
    
    set(findobj('tag','Title'),'string',LoadName);
    PlotIt(DataIn);
    
    %   Set figure visible
    set(CustomVehTypeFigHandle,'visible','on');
    
else
    
    c1=str2num(get(findobj('tag','C1'),'string'));
    c2=str2num(get(findobj('tag','C2'),'string'));
    c3=str2num(get(findobj('tag','C3'),'string'));
    v1=str2num(get(findobj('tag','V1'),'string'));
    v2=str2num(get(findobj('tag','V2'),'string'));
    v3=str2num(get(findobj('tag','V3'),'string'));
    
    TempData=[v1 c1;v2 c2;v3 c3];
    NewName=get(findobj('tag','LoadName'),'string');
    LoadName=get(findobj('tag','Title'),'string');
    
    switch option1
        
    case 'UpdatePlot'
        PlotIt(TempData);
        
    case {'Back','Done'}
        
        LoadName=LoadName{1};
        
        OldList=get(findobj('tag','ListBox'),'string');
        if isempty(strmatch(cellstr(NewName),OldList,'exact')) | strcmp(get(findobj('tag','LoadName'),'enable'),'off')
            
            NewNameVehType=cellstr([LoadName,'\',NewName]);
            if isempty(strmatch(NewNameVehType,GetLoadNames('StandardVehTypeNames')))
                close(gcf);
                Data=[v1 v2 v3 c1 c2 c3];
                DirectoryP1=get(findobj('tag','ListFileName'),'string');
                Directory=[DirectoryP1{1},'\'];
                
                
                % set ManageListFig list & selection to new custom name
                %   If not on list, put it on list
                
                OldList=get(findobj('tag','ListBox'),'string');
                NewName=cellstr(NewName);
                if isempty(strmatch(NewName,OldList,'exact'))
                    NewList=sort([OldList;NewName]);
                    set(findobj('tag','ListBox'),'string',NewList);
                    clear OldList;
                else
                    cd(Directory);
                    clear([NewName{1},'.m']);
                end
                CreateModelFile(NewName{1},Directory,Data,{'v1','v2','v3','c1','c2','c3'});
                
                
                ManageList=get(findobj('tag','ListBox'),'string');
                for i=1:length(ManageList)  
                    if strmatch(ManageList{i},NewName,'exact')
                        set(findobj('tag','ListBox'),'value',i);
                    end
                end
                
            else
                warndlg('The load name matches a standard load name.  Specify a different name.');
            end
        else
            warndlg('The load name matches a current load name.  Specify a different name.');
        end
        
    case 'Help'
        load_in_browser('aux_loads_help2.html');
        
    case 'Cancel'
        close(gcf);
        
    end %   end "switch option1"
    
end %   end "if isstr(option1)"

%   Restore original dir
cd(CurrentWorkingDir);

%===============================================================================
% PlotIt
%   This function plots the input data TempData and Titles the plot to LoadName
%===============================================================================
function PlotIt(TempData)

plot(TempData(:,1),TempData(:,2));

TempAxis=Axis;
TempAxis(3)=0;
axis(TempAxis);

xlabel('Volts','fontweight','bold');
ylabel('Amps','fontweight','bold');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)
