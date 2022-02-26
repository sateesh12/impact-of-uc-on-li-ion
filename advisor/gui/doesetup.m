function [matrixOut,matrixIndOut,varListOut,resultsFilenameOut,distComputingOut] = doesetup(varargin)
% DOESETUP Application M-file for doesetup.fig
%    FIG = DOESETUP('filename',filename) or
%    FIG = DOESETUP('varList',variables,values)   launch doesetup GUI.
%       Info:    structure with fields:
%                   doe:
%                           varOptions (required)
%                           listDefValues (required)
%                   fig:
%                           selectedVars
%                           varOptionsList
%                           plusMinusPercent
%                           lowValue
%                           highValue
%                           numSteps
%                           method
%    DOESETUP('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 11-Apr-2003 13:54:56

persistent matrix matrixInd varList resultsFilename distComputing

if isempty(findobj('tag','doeSetupFig')) % LAUNCH GUI
    
    fig = openfig(mfilename,'reuse');
    
    % Use system color scheme for figure:
    set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    
    % Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
     
    %   Apply info to figure
    applyInfo2GUI(handles,varargin{:});
  
    waitfor(fig);
    
    matrixOut=matrix;
    matrixIndOut=matrixInd;
    varListOut=varList;
    resultsFilenameOut=resultsFilename;
    distComputingOut=distComputing;
    

elseif strcmp(varargin{1},'done')
    matrix=varargin{2};
    matrixInd=varargin{3};
    varList=varargin{4};
    resultsFilename=varargin{5};
    distComputing=varargin{6};
    
elseif strcmp(varargin{1},'cancel')
    matrix=[];
    matrixInd=[];
    varList=[];
    resultsFilename=[];
    distComputing=[];
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = varOptions_listbox_Callback(h, eventdata, handles, varargin)

try    
    doubleClick=checkDoubleClick(h,get(h,'value'));
    
    varOptsList=get(h,'string');
    varOptsValue=get(h,'value');
    
    if doubleClick & ~isempty(varOptsList)
        varOptsSelection=varOptsList{varOptsValue};
        
        %   Add selection to selectedVars list
        selectedVarsList=get(handles.selectedVars_listbox,'string');
        selectedVarsList{end+1}=varOptsSelection;
        set(handles.selectedVars_listbox,'string',selectedVarsList);
        set(handles.selectedVars_listbox,'value',length(selectedVarsList));
        
        %   Delete selection from varOptions list
        newVarOptsList=rmCell(varOptsList,varOptsValue);
        set(h,'value',1);
        set(h,'string',newVarOptsList);
        
        setSetupValues(handles);
        
        enableSetup('on',handles.doeSetupFig); % high/low/plus minus percent text boxes
        
    end
    
    updateNumRuns(handles);
    
catch
    disp('error in doeSetup(varOptions_listbox_Callback)');
    disp(lasterr);
    keyboard
end

% --------------------------------------------------------------------
function varargout = selectedVars_listbox_Callback(h, eventdata, handles, varargin)

try
    
    doubleClick=checkDoubleClick(h,get(h,'value'));
    
    list=get(h,'string');
    listValue=get(h,'value');
    
    %   If item is double clicked, move from selectedVars list to varOptions list
    if  doubleClick & ~isempty(list)
        
        %   Delete selection from selectedVars list
        newList=rmCell(list,listValue);
        set(h,'value',1);
        set(h,'string',newList);
        
        %   Add selection to varOptions list
        varOptionsList=get(handles.varOptions_listbox,'string');
        varOptionsList{end+1}=list{listValue};
        set(handles.varOptions_listbox,'string',varOptionsList,...
            'value',length(varOptionsList));
        
        list=newList;
        listValue=1;
    end
    
    %   Set the list item values in the textboxes
    if ~isempty(list)
        setSetupValues(handles);        
        setup='on';
    else
        setup='off';
    end
    
    enableSetup(setup,handles.doeSetupFig); % high/low/plus minus percent text boxes
    
    updateNumRuns(handles);
    
catch
    disp('error in doeSetup(selectedVars_listbox_Callback)');
    disp(lasterr);
    keyboard
end
% --------------------------------------------------------------------
function varargout = add_pushbutton_Callback(h, eventdata, handles, varargin)

if ~isempty(get(handles.varOptions_listbox,'string'))
    %   Called twice to simulate a double click
    doesetup('varOptions_listbox_Callback',handles.varOptions_listbox,[],handles);
    doesetup('varOptions_listbox_Callback',handles.varOptions_listbox,[],handles);
end


% --------------------------------------------------------------------
function varargout = delete_pushbutton_Callback(h, eventdata, handles, varargin)

if ~isempty(get(handles.selectedVars_listbox,'string'))
    %   Called twice to simulate a double click
    doesetup('selectedVars_listbox_Callback',handles.selectedVars_listbox,[],handles);
    doesetup('selectedVars_listbox_Callback',handles.selectedVars_listbox,[],handles);
end



% --------------------------------------------------------------------
function varargout = cancel_pushbutton_Callback(h, eventdata, handles, varargin)
doesetup('cancel'); % sets the outputs of this function to []
close(handles.doeSetupFig);


% --------------------------------------------------------------------
function varargout = run_pushbutton_Callback(h, eventdata, handles, varargin)

%   Assign info.fig
info=assignInfoDotFig(handles);


if isfield(info.fig,'selectedVars') & ~isempty(info.fig.selectedVars)
    for selectVarCounter=1:length(info.fig.selectedVars)
        doeListValue=strmatch(info.fig.selectedVars(selectVarCounter),info.inputs.varOptions,'exact');
        if strcmp(info.fig.setup,'hiLow')
            lowValues(selectVarCounter)=info.fig.hiLowSetup.lowValue(doeListValue);
            highValues(selectVarCounter)=info.fig.hiLowSetup.highValue(doeListValue);
            numSteps(selectVarCounter)=info.fig.hiLowSetup.numSteps(doeListValue);
        elseif strcmp(info.fig.setup,'plusOrMinus')
            lowValues(selectVarCounter)=info.inputs.varValueDefaults(doeListValue)*(1 - info.fig.plusMinusSetup.percent/100);
            highValues(selectVarCounter)=info.inputs.varValueDefaults(doeListValue)*(1 + info.fig.plusMinusSetup.percent/100);
            numSteps(selectVarCounter)=2;
        end
    end
    
    [matrix,matrixValueInd]=getFullFactorialMatrix(highValues,lowValues,numSteps);
    
    doesetup('done',matrix,matrixValueInd,info.fig.selectedVars,info.fig.resultsFilename,info.fig.distComputing)
else
    doesetup('cancel'); % sets the outputs of this function to []
end

close(handles.doeSetupFig);


% --------------------------------------------------------------------
function varargout = hiLowSetup_radiobutton_Callback(h, eventdata, handles, varargin)
set(h,'value',1);
set(handles.plusOrMinus_radiobutton,'value',0);



% --------------------------------------------------------------------
function varargout = plusOrMinus_radiobutton_Callback(h, eventdata, handles, varargin)

set(h,'value',1);
set(handles.hiLowSetup_radiobutton,'value',0);


% --------------------------------------------------------------------
function varargout = plusMinusPer_editbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = lowValue_editbox_Callback(h, eventdata, handles, varargin)

info=get(handles.doeSetupFig,'userdata');

selectedListString=get(handles.selectedVars_listbox,'string');
selectedListValue=get(handles.selectedVars_listbox,'value');
selectedListItem=selectedListString(selectedListValue);

doeListValue=strmatch(selectedListItem,info.inputs.varOptions,'exact');

info.fig.hiLowSetup.lowValue(doeListValue)=str2num(get(h,'string'));
set(handles.doeSetupFig,'userdata',info);

% --------------------------------------------------------------------
function varargout = highValue_editbox_Callback(h, eventdata, handles, varargin)

info=get(handles.doeSetupFig,'userdata');

selectedListString=get(handles.selectedVars_listbox,'string');
selectedListValue=get(handles.selectedVars_listbox,'value');
selectedListItem=selectedListString(selectedListValue);

doeListValue=strmatch(selectedListItem,info.inputs.varOptions,'exact');

info.fig.hiLowSetup.highValue(doeListValue)=str2num(get(h,'string'));
set(handles.doeSetupFig,'userdata',info);

% --------------------------------------------------------------------
function varargout = numSteps_editbox_Callback(h, eventdata, handles, varargin)

info=get(handles.doeSetupFig,'userdata');

selectedListString=get(handles.selectedVars_listbox,'string');
selectedListValue=get(handles.selectedVars_listbox,'value');
selectedListItem=selectedListString(selectedListValue);

doeListValue=strmatch(selectedListItem,info.inputs.varOptions,'exact');

info.fig.hiLowSetup.numSteps(doeListValue)=str2num(get(h,'string'));

set(handles.doeSetupFig,'userdata',info);

updateNumRuns(handles);


% --------------------------------------------------------------------
function varargout = open_Callback(h, eventdata, handles, varargin)

try
    
    [filename,pathname]=uigetfile('*.mat','Load Design of Experiments Setup');
    
    applyInfo2GUI(handles,'filename',[pathname,filename]);
    
catch
    disp('error in doeSetup(open_Callback)');
    disp(lasterr);
    keyboard
end

% --------------------------------------------------------------------
function varargout = file_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = save_Callback(h, eventdata, handles, varargin)
%   Assign info.fig
info=assignInfoDotFig(handles);

if ~isfield(info,'filename')
    saveAs_Callback(handles.saveAs,[],handles);
else
    set(handles.doeSetupFig,'userdata',info);
    save(info.filename,'info');
    rehash toolbox;
end


% --------------------------------------------------------------------
function varargout = saveAs_Callback(h, eventdata, handles, varargin)

try
    %   Assign info.fig
    info=assignInfoDotFig(handles);
    [filename, pathname] = uiputfile('*.mat','Save Design of Experiments Setup');
    
    info.filename=[pathname,filename];
    set(handles.doeSetupFig,'userdata',info);
    
    save(info.filename,'info');
    rehash toolbox;
    
catch
    disp('error in doeSetup(saveAs_Callback)');
    disp(lasterr);
    keyboard
end

% subfunction --------------------------------------------------------------------
function applyInfo2GUI(handles,varargin)
%   varargin{1}:  'filename' or 'varList'
%       'filename':
%           varargin{2}=filename
%       'varList':
%           varargin{2}=varOptions
%           varargin{3}=varValueDefaults

try
    
    %   Dummy data for test
    if isempty(varargin)
        varargin{1}='varList';
        varargin{2}={'this';'and';'that'};
        varargin{3}=[4;5;9];
    end
    
    %   Load or create information
    switch varargin{1}
    case 'filename'
        filename=varargin{2};
        load(filename);
    case 'varList'
        %   Assign doe info
        info.inputs.varOptions=varargin{2};
        info.inputs.varValueDefaults=varargin{3};
        
        %   Assign figure info
        defaultValueOffset=1;
        defaultSetup='hiLow';
        defaultNumSteps=2;
        
        info.fig.varOptionsList=info.inputs.varOptions;
        info.fig.selectedVars={};
        info.fig.plusMinusSetup.percent=defaultValueOffset;
        info.fig.hiLowSetup.highValue=info.inputs.varValueDefaults*(1+defaultValueOffset/100);
        info.fig.hiLowSetup.lowValue=info.inputs.varValueDefaults*(1-defaultValueOffset/100);
        info.fig.hiLowSetup.numSteps(1:length(info.inputs.varValueDefaults))=defaultNumSteps;
        info.fig.setup=defaultSetup;
        info.fig.resultsFilename='DOE_default';
        info.fig.distComputing='off';
    end
    
    
    %   Apply info to figure
    set(findobj(handles.doeSetupFig,'tag','varOptions_listbox'),'value',1,...
        'string',info.fig.varOptionsList);
    set(findobj(handles.doeSetupFig,'tag','selectedVars_listbox'),'value',1,...
        'string',info.fig.selectedVars);
    set(findobj(handles.doeSetupFig,'tag','plusMinusPercent_editbox'),'string',info.fig.plusMinusSetup.percent,...
        'value',strcmp(info.fig.setup,'plusMinusPercent'));
    set(findobj(handles.doeSetupFig,'tag','resultsFilename_editbox'),'string',info.fig.resultsFilename);
    
    if ~isempty(info.fig.selectedVars)
        selectedVarsListChoice=get(findobj(handles.doeSetupFig,'tag','selectedVars_listbox'),'value');
        set(findobj(handles.doeSetupFig,'tag','lowValue_editbox'),'string',num2str(info.fig.hiLowSetup.lowValue(selectedVarsListChoice)));
        set(findobj(handles.doeSetupFig,'tag','highValue_editbox'),'string',num2str(info.fig.hiLowSetup.highValue(selectedVarsListChoice)));
        set(findobj(handles.doeSetupFig,'tag','numSteps_editbox'),'string',num2str(info.fig.hiLowSetup.numSteps(selectedVarsListChoice)));
        setupEnable='on';
    else
        set(findobj(handles.doeSetupFig,'tag','lowValue_editbox'),'string','');
        set(findobj(handles.doeSetupFig,'tag','highValue_editbox'),'string','');
        set(findobj(handles.doeSetupFig,'tag','numSteps_editbox'),'string',num2str(info.fig.hiLowSetup.numSteps(1)));
        setupEnable='off';
    end
    
    enableSetup(setupEnable,handles.doeSetupFig); % high/low/plus minus percent text boxes
    
    set(handles.hiLowSetup_radiobutton,'value',strcmp(info.fig.setup,'hiLow'));
    set(handles.plusOrMinus_radiobutton,'value',strcmp(info.fig.setup,'plusOrMinus'));
    
    set(handles.doeSetupFig,'userdata',info);
    
    
catch
    disp('error in doeSetup(applyInfo2GUI)');
    disp(lasterr);
    keyboard
end


% subfunction --------------------------------------------------------------------
function newlist=rmCell(list,value)

if value == 1
    newlist=list(2:end);
elseif value == length(list)
    newlist=list(1:end-1);
else
    newlist=list(1:value-1);
    newlist={newlist{:},list{value+1:length(list)}}';
end


% subfunction --------------------------------------------------------------------
function doubleClick=checkDoubleClick(handle,value)

persistent clickTime1 lastHandle lastValue lastClick

clickSpeed=.5;

if ~isempty(clickTime1)...
        & (etime(clock,clickTime1) < clickSpeed)...
        & (lastHandle == handle)...
        & (lastValue == value)...
        & (lastClick ~= 1)
    
    doubleClick=1;
    lastClick=1;
else
    doubleClick=0;
    lastClick=0;
end

lastHandle=handle;
lastValue=value;
clickTime1=clock;


% subfunction --------------------------------------------------------------------
function setSetupValues(handles)
try
    
    info=get(handles.doeSetupFig,'userdata');
    
    selectedVarsValue=get(handles.selectedVars_listbox,'value');
    selectedVarsList=get(handles.selectedVars_listbox,'string');
    listSelection=selectedVarsList(selectedVarsValue);
    
    if ~isempty(selectedVarsList)
        doeListValue=strmatch(listSelection,info.inputs.varOptions,'exact');
        set(handles.lowValue_editbox,'string',num2str(info.fig.hiLowSetup.lowValue(doeListValue)));
        set(handles.highValue_editbox,'string',num2str(info.fig.hiLowSetup.highValue(doeListValue)));
        set(handles.numSteps_editbox,'string',num2str(info.fig.hiLowSetup.numSteps(doeListValue)));
    end
    
catch
    disp('error in doeSetup(setSetupValues)');
    disp(lasterr);
    keyboard
end

% subfunction --------------------------------------------------------------------
function enableSetup(setupEnable,figHandle);

try
    
    enableTags={'lowValue_editbox';
        'highValue_editbox';
        'numSteps_editbox';
        'hiLowSetup_radiobutton';
        'plusOrMinus_radiobutton';
        'plusMinusPer_editbox'};
    
    for tagCounter=1:length(enableTags)
        handles(tagCounter)=findobj(figHandle,'tag',enableTags{tagCounter});
    end
    
    set(handles,'enable',setupEnable);
    
catch
    disp('error in doeSetup(enableSetup)');
    disp(lasterr);
    keyboard
end

% subfunction --------------------------------------------------------------------
function info = assignInfoDotFig(handles)

info=get(handles.doeSetupFig,'userdata');

info.fig.varOptionsList=get(handles.varOptions_listbox,'string');
info.fig.selectedVars=get(handles.selectedVars_listbox,'string');
info.fig.plusMinusSetup.percent=str2num(get(handles.plusMinusPer_editbox,'string'));
info.fig.resultsFilename=get(handles.resultsFilename_editbox,'string');
%info.fig.distComputing=get(handles.distComputing,'checked');

setupPlusMinus=get(handles.plusOrMinus_radiobutton,'value');
if setupPlusMinus == 1
    info.fig.setup='plusOrMinus';
else
    info.fig.setup='hiLow';
end

% subfunction --------------------------------------------------------------------
function updateNumRuns(handles)

info=get(handles.doeSetupFig,'userdata');

selectedVarsValue=get(handles.selectedVars_listbox,'value');
selectedVarsList=get(handles.selectedVars_listbox,'string');

if ~isempty(selectedVarsList)
    for selectedListItem=1:length(selectedVarsList)
        listSelection=selectedVarsList(selectedListItem);
        doeListValue=strmatch(listSelection,info.inputs.varOptions,'exact');
        
        if selectedListItem == 1
            numRuns=info.fig.hiLowSetup.numSteps(doeListValue);
        else
            numSteps=info.fig.hiLowSetup.numSteps(doeListValue);
            numRuns=numSteps*numRuns;
        end
    end
    set(handles.numOfRuns,'string',num2str(numRuns));
else
    set(handles.numOfRuns,'string','0');
end




% --------------------------------------------------------------------
function varargout = resultsFilename_editbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = distComputing_Callback(h, eventdata, handles, varargin)

currentStatus=get(h,'checked');
if strcmp(currentStatus,'off')
    set(h,'checked','on');
else
    set(h,'checked','off');
end


% --------------------------------------------------------------------
function varargout = options_Callback(h, eventdata, handles, varargin)

