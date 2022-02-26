function CustomParamFigControl2(option1,option2,option3,option4)
%   function CustomParamFigControl(option1,option2,option3)
%       This function controls CustomParamFig
%       Initial Call:
%           option1: Model Name
%           option2: Parameter text list
%           option3: Parameter value list

global vinf

if isempty(findobj('tag','CustomParamFig')) & nargin > 1
    
    CPHandle=CustomParamFig;
    set(CPHandle,'windowstyle','modal');
    
    %   Center the figure on the screen
    center_figure(CPHandle);
    
    %   set everything normalized 
    h=findobj(CPHandle,'type','uicontrol');
    set(h,'units','normalized');    
    
    ModelName=option1;
    ParamTextList=option2;
    
    set(findobj(CPHandle,'tag','ModelName'),'string',[ModelName,'\']);
    set(findobj(CPHandle,'tag','Back'),'callback','CustomParamFigControl2(''Back'')');
    set(findobj(CPHandle,'tag','Done'),'callback','CustomParamFigControl2(''Done'')');
    set(findobj(CPHandle,'tag','Cancel'),'callback','CustomParamFigControl2(''Cancel'')');
    set(findobj(CPHandle,'tag','Help'),'callback','CustomParamFigControl2(''Help'')');
    
    
    %   Turn extra parameter definition slots visibile off
    for i=length(ParamTextList)+1:11
        eval(['set(findobj(''tag'',''ParamText',num2str(i),'''),''visible'',''off'')']);
        eval(['set(findobj(''tag'',''ParamValue',num2str(i),'''),''visible'',''off'')']);
    end
    
    %   Set parameter text names
    for i=1:length(ParamTextList)
        eval(['set(findobj(''tag'',''ParamText',num2str(i),'''),''string'',ParamTextList(i))']);
    end
    
    %   Set values if provided
    if exist('option3')
        ParamValueList=option3;
        for i=1:length(ParamValueList)
            eval(['set(findobj(''tag'',''ParamValue',num2str(i),'''),''string'',num2str(ParamValueList(i)))']);
        end
    end
    
    %   Set file name if provided (edit)
    if exist('option4')
        set(findobj(CPHandle,'tag','CustomName'),'string',option4);
        set(findobj(CPHandle,'tag','CustomName'),'enable','off');
    else
        set(findobj(CPHandle,'tag','CustomName'),'string','custom');
    end
    
    %   Set figure visible
    set(CPHandle,'visible','on');
    
end


ModelNameSS=get(findobj('tag','ModelName'),'string');
if ~isempty(ModelNameSS)
    LoadName=strrep(ModelNameSS,'\','');
end

switch option1
    
case {'Back','Done'}
    
    %   Update list in ManageListFig 
    OldList=get(findobj('tag','ListBox'),'string');
    NewModelName=get(findobj('tag','CustomName'),'string');
    NewModelDirPart1=get(findobj('tag','ListFileName'),'string');
    NewModelDir=[NewModelDirPart1{1},'\'];  %[strrep(vinf.tmppath,'tmp\','models\Saber\'),LoadName,'\'];
    if isempty(strmatch(cellstr(NewModelName),OldList,'exact')) | strcmp(get(findobj('tag','CustomName'),'enable'),'off')
        
        CreateModelFail=CreateModelFileFn(NewModelName,NewModelDir);  % If successful, it closes the figure
        
        if CreateModelFail==0
            NewModelName=strrep(NewModelName,'.m','');
            NewModelName=cellstr(NewModelName);
            
            %   If not on list, put it on list
            if isempty(strmatch(NewModelName,OldList))
                NewList=sort([OldList;NewModelName]);
                set(findobj('tag','ListBox'),'string',NewList);
            end
            
            close(findobj('tag','CustomParamFig'));
        end
    else
        warndlg('The load name matches a current load name.  Specify a different name.');
    end    
    
case 'Help'
    load_in_browser('aux_loads_help2.html');
    
case 'Cancel'
    close(gcf);
    
    
end

    
    


%===============================================================================
% CreateModelFileFn(NewModelName)
%   This function writes out a new M file with the custom data defined
%   in the figure.
%===============================================================================
function Fail=CreateModelFileFn(NewModelName,NewModelDir)

directory=NewModelDir;

%   Assign parameter data to variable ModelData
j=1;
while ~isempty(findobj('tag',['ParamValue',num2str(j)])) & strcmp(get(findobj('tag',['ParamValue',num2str(j)]),'visible'),'on')
    ModelDataString{j}=get(findobj('tag',['ParamValue',num2str(j)]),'string');
    try 
        ModelData(j)=str2num(ModelDataString{j});
    catch
        warndlg('Numerical values must be entered for all parameters');
        Fail=1;
        break
    end
    j=j+1;
end

ModelDataNames=[];
j=1;
while ~isempty(findobj('tag',['ParamValue',num2str(j)])) & strcmp(get(findobj('tag',['ParamValue',num2str(j)]),'visible'),'on')
    ModelDataNames=[ModelDataNames;get(findobj('tag',['ParamText',num2str(j)]),'string')];
    j=j+1;
end

if ~exist('Fail')
    CreateModelFile(NewModelName,NewModelDir,ModelData,ModelDataNames)
    Fail=0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 08/02/01: ab file created (first working)
