function varargout = doeResults(varargin)
% DOERESULTS Application M-file for doeResults.fig
%    FIG = DOERESULTS launch doeResults GUI.
%    DOERESULTS('callback_name', ...) invoke the named callback.
%    Initial Calls:
%       doeResults('filename','myResults.mat');
%       doeResults('doeResults',info);

% Last Modified by GUIDE v2.0 10-Apr-2003 07:49:50

if isempty(findobj('tag','doeResultsFig')) % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
	if nargout > 0
		varargout{1} = fig;
	end
    
    %   Apply info to figure
    applyInfo2GUI(handles,varargin{:});


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
function varargout = plotType_popupmenu_Callback(h, eventdata, handles, varargin)

%   Get information common to most plots
info=get(handles.doeResultsFig,'userdata');
vars2Use=get(handles.selectedVars_listbox,'string');

%   Get plot type selection
selectionString=get(h,'string');
selectionValue=get(h,'value');
selection=selectionString(selectionValue);

%   Get objective selection
objSelectionString=get(handles.objective_popupmenu,'string');
objSelectionValue=get(handles.objective_popupmenu,'value');
objSelection=objSelectionString(objSelectionValue);

axes(handles.axes1);

%   Create plot
switch selection{1}
case 'Line'
    drawLinePlot(vars2Use,objSelection,handles,info);
case 'Sensitivity'
    drawSensitivityPlot(vars2Use,objSelection,handles,info);
case 'Max Objective'
    drawMaxObjPlot(vars2Use,objSelection,handles,info);
case 'Interactions'
    drawInteractionsPlot(vars2Use,objSelection,handles,info);
case 'Surface'
    drawSurfacePlot(vars2Use,objSelection,handles,info);
    %warndlg('This feature is not currently available');
end


% --------------------------------------------------------------------
function varargout = objective_popupmenu_Callback(h, eventdata, handles, varargin)

plotType_popupmenu_Callback(handles.plotType_popupmenu,[],handles);


% --------------------------------------------------------------------
function varargout = varOptions_listbox_Callback(h, eventdata, handles, varargin)

try    
    info=get(handles.doeResultsFig,'userdata');
    doubleClick=checkDoubleClick(h,get(h,'value'));
    
    varOptsList=get(h,'string');
    if doubleClick & ~isempty(varOptsList)
        
        varOptsValue=get(h,'value');
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
        
    end
    
    updateSlider(handles);
    
catch
    disp('error in doeSetup(varOptions_listbox_Callback)');
    disp(lasterr);
    keyboard
end


% --------------------------------------------------------------------
function varargout = selectedVars_listbox_Callback(h, eventdata, handles, varargin)

try
    
    info=get(handles.doeResultsFig,'userdata');
    
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
        
        updateSlider(handles);
        
    end
    
catch
    disp('error in doeSetup(selectedVars_listbox_Callback)');
    disp(lasterr);
    keyboard
end


% --------------------------------------------------------------------
function varargout = add_pushbutton_Callback(h, eventdata, handles, varargin)

if ~isempty(get(handles.varOptions_listbox,'string'))
    %   Called twice to simulate a double click
    doeResults('varOptions_listbox_Callback',handles.varOptions_listbox,[],handles);
    doeResults('varOptions_listbox_Callback',handles.varOptions_listbox,[],handles);
end


% --------------------------------------------------------------------
function varargout = delete_pushbutton_Callback(h, eventdata, handles, varargin)

if ~isempty(get(handles.selectedVars_listbox,'string'))
    %   Called twice to simulate a double click
    doeResults('selectedVars_listbox_Callback',handles.selectedVars_listbox,[],handles);
    doeResults('selectedVars_listbox_Callback',handles.selectedVars_listbox,[],handles);
end


% --------------------------------------------------------------------
function varargout = yHat_pushbutton_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = varOptions_slider_Callback(h, eventdata, handles, varargin)

if ~isempty(get(handles.varOptions_listbox,'string'))
    info=get(handles.doeResultsFig,'userdata');
    varSliderValueRaw=get(h,'value');
    
    varListString=get(handles.varOptions_listbox,'string');
    varListValue=get(handles.varOptions_listbox,'value');
    varSelection=varListString(varListValue);
    
    varNum=strmatch(varSelection,info.vars.names,'exact');
    
    %   Set to actual data point
    uniqueValues=unique(info.vars.values{varNum});
    varSliderValue=interp1(uniqueValues,uniqueValues,varSliderValueRaw,'nearest');
    set(h,'value',varSliderValue);
    
    set(handles.varOptionsSlider_text,'string',num2str(varSliderValue));
    
    info.fig.varSliderValue{varNum}=varSliderValue;
    set(handles.doeResultsFig,'userdata',info);
    
    doeresults('plotType_popupmenu_Callback',handles.plotType_popupmenu,[],handles);
end

% subfunction--------------------------------------------------------------------
function applyInfo2GUI(handles,varargin)

try
    %   Get data
    if isempty(varargin) % dummy data for testing
        
        
        doeresults('load_Callback',[], [], handles, varargin)
        return
%         info.results.names{1}='mpg';
%         info.results.values{1}(1,1,1)=24;
%         info.results.values{1}(2,1,1)=22;
%         info.results.values{1}(1,2,1)=20;
%         info.results.values{1}(2,2,1)=18;
%         info.results.values{1}(1,1,2)=17;
%         info.results.values{1}(2,1,2)=16;
%         info.results.values{1}(1,2,2)=15;
%         info.results.values{1}(2,2,2)=14;
%         info.results.values{1}(1,1,3)=7;
%         info.results.values{1}(2,1,3)=6;
%         info.results.values{1}(1,2,3)=5;
%         info.results.values{1}(2,2,3)=4;
%         
%         info.results.names{2}='grade';
%         info.results.values{2}(1,1,1)=15;
%         info.results.values{2}(2,1,1)=14;
%         info.results.values{2}(1,2,1)=14;
%         info.results.values{2}(2,2,1)=13;
%         info.results.values{2}(1,1,2)=8;
%         info.results.values{2}(2,1,2)=7;
%         info.results.values{2}(1,2,2)=7;
%         info.results.values{2}(2,2,2)=6;
%         info.results.values{2}(1,1,3)=3;
%         info.results.values{2}(2,1,3)=2;
%         info.results.values{2}(1,2,3)=2;
%         info.results.values{2}(2,2,3)=1;
% 
%         info.vars.names={'veh_CD';'veh_FA';'veh_mass'};
%         info.vars.values{1}=[.2;.3];
%         info.vars.values{2}=[4;6];
%         info.vars.values{3}=[1000;1200;1400];
        
    else
        %   Load or assign information
        switch varargin{1}
        case 'filename'
            filename=varargin{2};
            load(filename);
        case 'doeResults'
            info=varargin{2};
        end    
    end
    
    for varCounter=1:length(info.vars.names)
        info.fig.varSliderMin{varCounter}=min(info.vars.values{varCounter});
        info.fig.varSliderMax{varCounter}=max(info.vars.values{varCounter});
        sliderStepSize=(info.vars.values{varCounter}(2)-info.vars.values{varCounter}(1))/(max(info.vars.values{varCounter})-min(info.vars.values{varCounter}));
        info.fig.varSliderStep{varCounter}=[sliderStepSize sliderStepSize];
        info.fig.varSliderValue{varCounter}=min(info.vars.values{varCounter});
    end
    
    set(handles.doeResultsFig,'userdata',info);
    
    set(handles.selectedVars_listbox,'string',info.vars.names);
    set(handles.objective_popupmenu,'string',info.results.names);
    
%     set(handles.plotType_popupmenu,'value',3);
%     doeresults('plotType_popupmenu_Callback',handles.plotType_popupmenu,[],handles);
%     plotType_popupmenu_Callback(handles.plotType_popupmenu,[],handles);
    
catch
    disp('error in doeResults(applyInfo2GUI)');
    disp(lasterr);
    keyboard
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
function updateSlider(handles)

if ~isempty(get(handles.varOptions_listbox,'string'))
    info=get(handles.doeResultsFig,'userdata');
    
    %   Update slider
    varOptsList=get(handles.varOptions_listbox,'string');
    varOptsValue=get(handles.varOptions_listbox,'value');
    varOptsSelection=varOptsList{varOptsValue};
    
    varNum=strmatch(varOptsSelection,info.vars.names,'exact');
    set(handles.varOptions_slider,'min',info.fig.varSliderMin{varNum},...
        'max',info.fig.varSliderMax{varNum},...
        'SliderStep',info.fig.varSliderStep{varNum},...
        'value',info.fig.varSliderValue{varNum});
    set(handles.varOptionsSlider_text,'string',num2str(info.fig.varSliderValue{varNum}));
end

% subfunction--------------------------------------------------------------------
function drawLinePlot(selectedVar,objVar,handles,info)

persistent lastObjVarArray lastSelectedVar

try
    if length(selectedVar) > 1
        warndlg('Only one variable can be selected for a line graph');
    else
        
        objVarInd=strmatch(objVar,info.results.names,'exact');
        selectedVarInd=strmatch(selectedVar,info.vars.names,'exact');
        
        %   Get indices of variable settings
        for varCounter=1:length(info.fig.varSliderValue)
            varIndex(varCounter)=find(info.fig.varSliderValue{varCounter}==info.vars.values{varCounter});
        end
        
        %   Create results array
        for arrayCounter=1:length(info.vars.values{selectedVarInd})
            varIndex(selectedVarInd)=arrayCounter;
            indexStr=array2Str(varIndex);
            
            objVarArray(arrayCounter)=eval(['info.results.values{objVarInd}(',indexStr,');']);
        end
        
        %   Plot
        axes(handles.axes1);
        plotBuffer=.05;
        fontSize=12;
        fontWeight='bold';
        
        %   Get min and max values for setting axes limits
        minX=min(info.vars.values{selectedVarInd});
        maxX=max(info.vars.values{selectedVarInd});
        minY=min(objVarArray);
        maxY=max(objVarArray);
        
        newMinXAxis=minX-((maxX-minX)*plotBuffer);
        newMaxXAxis=maxX+((maxX-minX)*plotBuffer);
        newMinYAxis=minY-((maxY-minY)*plotBuffer);
        newMaxYAxis=maxY+((maxY-minY)*plotBuffer);
        
        if newMinXAxis == newMaxXAxis
            newMinYAxis=newMinXAxis-(plotBuffer*(abs(minX)));
            newMaxYAxis=newMaxXAxis+(plotBuffer*(abs(minX)));
        end
        if newMinYAxis == newMaxYAxis
            newMinYAxis=newMinYAxis-(plotBuffer*(abs(minY)));
            newMaxYAxis=newMaxYAxis+(plotBuffer*(abs(minY)));
        end
        
        if gcbo==handles.varOptions_slider & strcmp(lastSelectedVar,selectedVar) & ~isequal(objVarArray,lastObjVarArray)
            
            orgAxis=axis;
            
            
            axis4Animation=[orgAxis(1:2) min(newMinYAxis,orgAxis(3)) max(newMaxYAxis,orgAxis(4))];            
            
            %   Animate axis limits change
            curYAxis=orgAxis(3:4);
            newYAxis=axis4Animation(3:4);
            numSteps=10;
            yInc=(newYAxis-curYAxis)/numSteps;
            tempYAxis=curYAxis;
            if ~isequal(curYAxis,newYAxis)
                for axesStep=1:numSteps
                    tempYAxis=tempYAxis+yInc;
                    axis([orgAxis(1:2) tempYAxis]);
                    pause(.05);
                end
            end
            pause(.5);
            
            %   Loop through line plotting
            numSteps=10;
            arrayDiff=objVarArray-lastObjVarArray;
            if ~isequal(objVarArray,lastObjVarArray)
                arrayInc=arrayDiff/numSteps;
                
                tempArray=lastObjVarArray;
                for animationStep=1:numSteps
                    tempArray=tempArray+arrayInc;
                    plot(info.vars.values{selectedVarInd},tempArray');
                    axis(axis4Animation);
                    xlabel(strrep(info.vars.names{selectedVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
                    ylabel(strrep(info.results.names{objVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
                    pause(.05);
                end
                pause(.5);
            end
            
            %   Animate final axis limits change
            finalAxis=[orgAxis(1:2) newMinYAxis newMaxYAxis];
            curYAxis=axis4Animation(3:4);
            newYAxis=finalAxis(3:4);
            numSteps=10;
            yInc=(newYAxis-curYAxis)/numSteps;
            tempYAxis=curYAxis;
            if ~isequal(curYAxis,newYAxis)
                for axesStep=1:numSteps
                    tempYAxis=tempYAxis+yInc;
                    axis([orgAxis(1:2) tempYAxis]);
                    pause(.05);
                end
            end
            
        else
            plot(info.vars.values{selectedVarInd},objVarArray);
            xlabel(strrep(info.vars.names{selectedVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
            ylabel(strrep(info.results.names{objVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
            
            if newMinYAxis < newMaxYAxis
                axis([newMinXAxis newMaxXAxis newMinYAxis newMaxYAxis]);
            else
                xlim([newMinXAxis newMaxXAxis]);
            end
        end
                
        lastObjVarArray=objVarArray;
        lastSelectedVar=selectedVar;
    end
    
    
catch
    disp('error in doeResults(drawLinePlot)');
    disp(lasterr);
    keyboard
end

% subfunction--------------------------------------------------------------------
function drawSensitivityPlot(selectedVars,objVar,handles,info)
%   Note:  Assumes linearly spaced parametric study (see plotting call "line")

if ~isempty(selectedVars)
    
    objVarInd=strmatch(objVar,info.results.names,'exact');
        
    %   Get selected variables indices  [Example:  the first selected variable name is info.vars.names{selectedVarNameInd(1)} ]
    for selectedVarCounter=1:length(selectedVars)
        selectedVarNameInd(selectedVarCounter)=strmatch(selectedVars(selectedVarCounter),info.vars.names);
    end
    

    %   Get matrix of indexs to use for finding the results of each run
    for varInd=1:length(info.vars.names)
        highIndValues(varInd)=length(info.vars.values{varInd});
        lowIndValues(varInd)=1;
        numSteps(varInd)=length(info.vars.values{varInd});
    end
    indexMatrix=getFullFactorialMatrix(highIndValues,lowIndValues,numSteps);
    
    %   Get an array containing the results of each run
    for resultInd=1:length(indexMatrix(:,1))
        indexStr=array2Str(indexMatrix(resultInd,:));
        resultArray(resultInd)=eval(['info.results.values{objVarInd}(',indexStr,');']);
    end
    
    %   Create coded matrix (-,0,+)
    lowSettings(1:length(info.vars.names))=-1;
    highSettings(1:length(info.vars.names))=1;
    codedMatrix=getFullFactorialMatrix(highSettings,lowSettings,numSteps);
    
    %   Create selected variable results matrix
    plotItemNum=1;
    for comboLevel=1:length(selectedVars)
        combos=nchoosek(selectedVarNameInd,comboLevel);
        for comboInd=1:length(combos(:,1)) % selected variables
            
            codedArray=prod(codedMatrix(:,combos(comboInd,:)),2);
            codedValues=unique(codedArray);
            if (comboLevel == 1) | (length(codedValues) == 2)
                
                %   Record name of plot item
                shortIntName=get(handles.sensitivity_shortIntNames,'checked');
                shortPriName=get(handles.sensitivity_shortPriNames,'checked');
                if comboLevel == 1
                    if strcmp(shortPriName,'off')
                        resultName=info.vars.names{combos(comboInd,1)};
                    elseif strcmp(shortPriName,'on')
                        resultName=num2str(find(combos(comboInd,1)==selectedVarNameInd));
                    end
                elseif strcmp(shortIntName,'off')
                    resultName=info.vars.names{combos(comboInd,1)};
                    for nameComboInd=2:length(combos(comboInd,:))
                        resultName=[resultName,',',info.vars.names{combos(comboInd,nameComboInd)}];
                    end
                elseif strcmp(shortIntName,'on')
                    resultName=num2str(find(combos(comboInd,1)==selectedVarNameInd));
                    for numComboInd=2:length(combos(comboInd,:))
                        resultName=[resultName,',',num2str(find(combos(comboInd,numComboInd)==selectedVarNameInd))];
                    end
                end
                    
                resultNames{plotItemNum}=resultName;
                
                %   Record values of variables for plot item
                if comboLevel == 1
                    resultVarValues{plotItemNum}=info.vars.values{combos(comboInd,1)};
                else
                    resultVarValues{plotItemNum}=[-1 1]';
                end
                
                %   Record results
                for pointInd=1:length(codedValues)
                    resultInds=find(codedValues(pointInd)==codedArray);
                    allPoints{plotItemNum}{pointInd}=resultArray(resultInds);
                    varResults{plotItemNum}(pointInd)=mean(resultArray(resultInds));
                end
                plotItemNum=plotItemNum+1; 
            end
            
        end
    end

    
    %   Plot
    axes(handles.axes1);
    xStartValue=1;
    maxValue=0;
    minValue=inf;
    
    for resultsCounter=1:length(varResults)
        numValues=length(varResults{resultsCounter});
        xEndValue=numValues+xStartValue-1;
        
        %   Display in workspace actual values of main variables
        if 0 & (resultsCounter <= length(info.vars.names)) 
            resultNames{resultsCounter}
            varResults{resultsCounter}
        end
        
        
        plot((xStartValue:xEndValue),varResults{resultsCounter});
        if resultsCounter == 1
            hold on;
        end
        maxValue=max(maxValue,max(varResults{resultsCounter}));
        minValue=min(minValue,min(varResults{resultsCounter}));
        
        showPoints=get(handles.sensitivity_showPoints,'checked');
        if strcmp(showPoints,'on')
            pointCounter=1;
            for currentXValue=xStartValue:xEndValue
                plot(currentXValue,allPoints{resultsCounter}{pointCounter},'x');
                maxValue=max(maxValue,max(allPoints{resultsCounter}{pointCounter}));
                minValue=min(minValue,min(allPoints{resultsCounter}{pointCounter}));
                
                pointCounter=pointCounter+1;
            end
        end
        text(xStartValue+.2,varResults{resultsCounter}(1),strrep(resultNames{resultsCounter},'_','\_'));
        xStartValue=xEndValue+1;
    end
    hold off;
    
    
    %   Set axes properties
    plotBuffer=.05;
    xlim([0 xStartValue]);
    newMinYAxis=minValue-((maxValue-minValue)*plotBuffer);
    newMaxYAxis=maxValue+((maxValue-minValue)*plotBuffer);
    if newMinYAxis == newMaxYAxis
        newMinYAxis=newMinYAxis-(plotBuffer*(abs(minValue)));
        newMaxYAxis=newMaxYAxis+(plotBuffer*(abs(minValue)));
    end
    
    if newMinYAxis < newMaxYAxis
        ylim([newMinYAxis newMaxYAxis]);
    end
    varValueArray=[0];
    for varCounter=1:length(varResults)
        varValueArray=[varValueArray resultVarValues{varCounter}'];
    end
    set(handles.axes1,'xticklabel',fix(varValueArray*100)/100);
    set(handles.axes1,'xtick',[0:1:length(varValueArray)+1]);
    ylabel(strrep(objVar,'_','\_'),'fontsize',12,'fontweight','bold');
    
    zoom on;
end


% subfunction--------------------------------------------------------------------
function drawInteractionsPlot(selectedVars,objVar,handles,info);
%   Note:  Assumes linearly spaced parametric study (see plotting call "line")

if length(selectedVars)~=2
    warndlg('Two variables must be selected for interaction plot');
else
    objVarInd=strmatch(objVar,info.results.names,'exact');
    
    %   Get selected variables indices (maps variable selection order to order of saved info)
    for selectedVarCounter=1:length(selectedVars)
        selectedVarNameInd(selectedVarCounter)=strmatch(selectedVars(selectedVarCounter),info.vars.names);
    end
    
    %   Get results information
    for varStep1=1:length(info.vars.values{selectedVarNameInd(1)})
        for varStep2=1:length(info.vars.values{selectedVarNameInd(2)})
            
            %   Create index string for results information
            indString=[];
            for varCounter=1:length(info.vars.names)
                if varCounter==selectedVarNameInd(1)
                    indString=[indString,num2str(varStep1),','];
                elseif varCounter==selectedVarNameInd(2)
                    indString=[indString,num2str(varStep2),','];
                else
                    indString=[indString,':,'];
                end
            end
            indString=indString(1:end-1); %remove extra comma on end
            
            allValues=eval(['info.results.values{',num2str(objVarInd),'}(',indString,')']);
            
            %   Get mean value of entire n-dimensional matrix
            meanValue=allValues;
            for dimCounter=1:length(size(allValues))
                meanValue=mean(meanValue);
            end
            
            varResults(varStep1,varStep2)=meanValue;
        end
        
    end
    
    %   Plot
    fontsize=12;
    fontweight='bold';
    plotBuffer=.05;
    
    plot(info.vars.values{selectedVarNameInd(1)},varResults);
    xlabel(strrep(selectedVars(1),'_','\_'),'fontsize',fontsize,'fontweight',fontweight);
    ylabel(strrep(objVar,'_','\_'),'fontsize',fontsize,'fontweight',fontweight);
    
    minX=min(info.vars.values{selectedVarNameInd(1)});
    maxX=max(info.vars.values{selectedVarNameInd(1)});
    minY=min(min(varResults));
    maxY=max(max(varResults));
    
    newMinXAxis=minX-((maxX-minX)*plotBuffer);
    newMaxXAxis=maxX+((maxX-minX)*plotBuffer);
    newMinYAxis=minY-((maxY-minY)*plotBuffer);
    newMaxYAxis=maxY+((maxY-minY)*plotBuffer);
    if newMinXAxis == newMaxXAxis
        newMinYAxis=newMinXAxis-(plotBuffer*(abs(minX)));
        newMaxYAxis=newMaxXAxis+(plotBuffer*(abs(minX)));
    end
    if newMinYAxis == newMaxYAxis
        newMinYAxis=newMinYAxis-(plotBuffer*(abs(minY)));
        newMaxYAxis=newMaxYAxis+(plotBuffer*(abs(minY)));
    end
    
    
    xlim([newMinXAxis newMaxXAxis]);
    if newMinYAxis < newMaxYAxis
        ylim([newMinYAxis newMaxYAxis]);
    end
    
    legendStr=[];
    for varStep2Counter=1:length(info.vars.values{selectedVarNameInd(2)})
        legendStr{varStep2Counter}=[strrep(selectedVars{2},'_','\_'),' ',num2str(info.vars.values{selectedVarNameInd(2)}(varStep2Counter))];
    end
    legend(legendStr);
    
end

% subfunction--------------------------------------------------------------------
function drawMaxObjPlot(selectedVar,objVar,handles,info)

try
    if length(selectedVar) > 1
        warndlg('Only one variable can be selected for this graph');
    else
        
        objVarInd=strmatch(objVar,info.results.names,'exact');
        selectedVarNameInd=strmatch(selectedVar,info.vars.names,'exact');
        
        %   Get results information
        for varStep=1:length(info.vars.values{selectedVarNameInd})
            
            %   Create index string for results information
            indString=[];
            for varCounter=1:length(info.vars.names)
                if varCounter==selectedVarNameInd
                    indString=[indString,num2str(varStep),','];
                else
                    indString=[indString,':,'];
                end
            end
            indString=indString(1:end-1);%remove extra comma on end
            
            allValues=eval(['info.results.values{',num2str(objVarInd),'}(',indString,')']);
            
            %   Get max value of entire n-dimensional matrix
            maxValue=allValues;
            for dimCounter=1:length(size(allValues))
                maxValue=max(maxValue);
            end
            
            varResults(varStep)=maxValue;
        end
        
        %   Plot
        plotBuffer=.05;
        fontSize=12;
        fontWeight='bold';
        
        plot(info.vars.values{selectedVarNameInd},varResults);
        xlabel(strrep(info.vars.names{selectedVarNameInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
        ylabel(strrep(info.results.names{objVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
        
        minX=min(info.vars.values{selectedVarNameInd});
        maxX=max(info.vars.values{selectedVarNameInd});
        minY=min(varResults);
        maxY=max(varResults);
        
        newMinXAxis=minX-((maxX-minX)*plotBuffer);
        newMaxXAxis=maxX+((maxX-minX)*plotBuffer);
        newMinYAxis=minY-((maxY-minY)*plotBuffer);
        newMaxYAxis=maxY+((maxY-minY)*plotBuffer);
        if newMinXAxis == newMaxXAxis
            newMinYAxis=newMinXAxis-(plotBuffer*(abs(minX)));
            newMaxYAxis=newMaxXAxis+(plotBuffer*(abs(minX)));
        end
        if (newMinYAxis == newMaxYAxis) & (newMinYAxis ~= 0)
            newMinYAxis=newMinYAxis-(plotBuffer*(abs(minY)));
            newMaxYAxis=newMaxYAxis+(plotBuffer*(abs(minY)));
        elseif newMinYAxis == 0
            newMinYAxis=-.5;
            newMaxYAxis=.5;
        end
        
        xlim([newMinXAxis newMaxXAxis]);
        ylim([newMinYAxis newMaxYAxis]);
    end
    
catch
    disp('error in doeResults(drawMaxObjPlot)');
    disp(lasterr);
    keyboard
end

% subfunction--------------------------------------------------------------------
function drawSurfacePlot(vars2Use,objVar,handles,info)

persistent lastObjVarMatrix lastVars2Use
if length(vars2Use) ~= 2
    warndlg('Surface plot requires two variable selections.');
else
    
    %   Map selected variable indices to info indices
    objVarInd=strmatch(objVar,info.results.names,'exact');
    for selectedVarNum=1:length(vars2Use)
        selectedVarInd(selectedVarNum)=strmatch(vars2Use{selectedVarNum},info.vars.names,'exact');
    end
    
    %   Get indices of variable settings
    for varCounter=1:length(info.fig.varSliderValue)
        varIndex(varCounter)=find(info.fig.varSliderValue{varCounter}==info.vars.values{varCounter});
    end
    
    %   Create results array
    for arrayCounter1=1:length(info.vars.values{selectedVarInd(1)})
        for arrayCounter2=1:length(info.vars.values{selectedVarInd(2)})
                
            varIndex(selectedVarInd(1))=arrayCounter1;
            varIndex(selectedVarInd(2))=arrayCounter2;
            indexStr=array2Str(varIndex);
            
            objVarMatrix(arrayCounter1,arrayCounter2)=eval(['info.results.values{objVarInd}(',indexStr,');']);
        end
    end
    
    %-- Plot ------------------
    fontSize=12;
    fontWeight='bold';
    plotBuffer=.05;
    axes(handles.axes1);
    
    %   Animate if just changing a variable setting (slider input)
    if gcbo==handles.varOptions_slider & isequal(lastVars2Use,vars2Use) & ~isequal(objVarMatrix,lastObjVarMatrix)
        
        %   Store view
        axesView=get(handles.axes1,'view');
        
        %   Zoom axis to include all plotting space before and after slider change
        orgAxis=axis;
        minZ=min(min(objVarMatrix));
        maxZ=max(max(objVarMatrix));
        
        newMinZAxis=minZ-((maxZ-minZ)*plotBuffer);
        newMaxZAxis=maxZ+((maxZ-minZ)*plotBuffer);
        if newMinZAxis == newMaxZAxis
            newMinZAxis=newMinZAxis-(plotBuffer*(abs(minZ)));
            newMaxZAxis=newMaxZAxis+(plotBuffer*(abs(minZ)));
        end
        
        newAxis=[orgAxis(1:4) newMinZAxis newMaxZAxis];
        
        axis4Animation=[min(newAxis(1),orgAxis(1))...
                max(newAxis(2),orgAxis(2))...
                min(newAxis(3),orgAxis(3))...
                max(newAxis(4),orgAxis(4))...
                min(newAxis(5),orgAxis(5))...
                max(newAxis(6),orgAxis(6))];
        
        %   Animate axis limits change
        curZAxis=orgAxis(5:6);
        newZAxis=axis4Animation(5:6);
        numSteps=10;
        zInc=(newZAxis-curZAxis)/numSteps;
        tempZAxis=curZAxis;
        if (curZAxis(1) ~= newZAxis(1) | curZAxis(2) ~= newZAxis(2))
            %             for axesStep=1:numSteps
            %                 tempZAxis=tempZAxis+zInc;
            %                 axis([newAxis(1:4) tempZAxis]);
            %                 set(handles.axes1,'view',axesView);
            %                 pause(.05);
            %             end
            axis(axis4Animation);
            set(handles.axes1,'view',axesView);
        end
        pause(.5);
        
        %   Loop through surface plotting
        numSteps=10;
        matrixDiff=objVarMatrix-lastObjVarMatrix;
        matrixInc=matrixDiff/numSteps;
        
        tempMatrix=lastObjVarMatrix;
        for animationStep=1:numSteps
            tempMatrix=tempMatrix+matrixInc;
            if ~exist('surfH')
                surfH=surf(info.vars.values{selectedVarInd(1)},info.vars.values{selectedVarInd(2)},tempMatrix',...
                    'EraseMode','xor');
            else
                set(surfH,'XData',info.vars.values{selectedVarInd(1)},'YData',info.vars.values{selectedVarInd(2)},'ZData',tempMatrix');
                drawnow
            end
            axis(axis4Animation);
            axis square
            set(handles.axes1,'view',axesView);
            shading interp
            xlabel(strrep(info.vars.names{selectedVarInd(1)},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
            ylabel(strrep(info.vars.names{selectedVarInd(2)},'_','\_'),'FontWeight',fontWeight','FontSize',fontSize);
            zlabel(strrep(info.results.names{objVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
            pause(.05);
        end
        pause(.5);
        
        %   Animate axis limits change
        curZAxis=axis4Animation(5:6);
        newZAxis=newAxis(5:6);
        numSteps=10;
        zInc=(newZAxis-curZAxis)/numSteps;
        tempZAxis=curZAxis;
        if ~isequal(curZAxis,newZAxis)
            %             for axesStep=1:numSteps
            %                 tempZAxis=tempZAxis+zInc;
            %                 axis([newAxis(1:4) tempZAxis]);
            %                 set(handles.axes1,'view',axesView);
            %                 pause(.05);
            %             end
            %axis(newAxis);
            %set(handles.axes1,'view',axesView);
        end
        
    else
        surf(info.vars.values{selectedVarInd(1)},info.vars.values{selectedVarInd(2)},objVarMatrix');
        shading interp
    end
    %   Set axis properties
    axis square
    xlabel(strrep(info.vars.names{selectedVarInd(1)},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
    ylabel(strrep(info.vars.names{selectedVarInd(2)},'_','\_'),'FontWeight',fontWeight','FontSize',fontSize);
    zlabel(strrep(info.results.names{objVarInd},'_','\_'),'FontWeight',fontWeight,'FontSize',fontSize);
    
    lastObjVarMatrix=objVarMatrix;
    lastVars2Use=vars2Use;
    
    rotate3d on
    
end


% --------------------------------------------------------------------
function varargout = file_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = load_Callback(h, eventdata, handles, varargin)

info=get(handles.doeResultsFig,'userdata');

[filename,pathname]=uigetfile('*.mat','Open design of experiments results');

if filename ~= 0
    close(handles.doeResultsFig);
    doeresults('filename',[pathname,filename]);
elseif isempty(info)
    close(handles.doeResultsFig);
end



% --------------------------------------------------------------------
function varargout = save_Callback(h, eventdata, handles, varargin)

info=get(handles.doeResultsFig,'userdata');

if ~isfield(info.fig,'file')
    saveAs_Callback(handles.saveAs,[],handles);
else
    save(info.fig.file,'info');
end




% --------------------------------------------------------------------
function varargout = saveAs_Callback(h, eventdata, handles, varargin)

info=get(handles.doeResultsFig,'userdata');
[filename,pathname]=uiputfile('*.mat','Save design of experiments');
info.fig.file=[pathname,filename];

save(info.fig.file,'info');

set(handles.doeResultsFig,'userdata',info);

% --------------------------------------------------------------------
function varargout = help_Callback(h, eventdata, handles, varargin)

msgbox('This function is under construction');


% --------------------------------------------------------------------
function varargout = options_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = sensitivity_shortIntNames_Callback(h, eventdata, handles, varargin)

currentStatus=get(h,'checked');
if strcmp(currentStatus,'off')
    set(h,'checked','on');
else
    set(h,'checked','off');
end

plotTypeString=get(handles.plotType_popupmenu,'string');
plotTypeValue=get(handles.plotType_popupmenu,'value');
plotType=plotTypeString(plotTypeValue);

if strcmp(plotType,'Sensitivity')
    plotType_popupmenu_Callback(handles.plotType_popupmenu, [], handles);
end


% --------------------------------------------------------------------
function varargout = sensitivity_shortPriNames_Callback(h, eventdata, handles, varargin)

currentStatus=get(h,'checked');
if strcmp(currentStatus,'off')
    set(h,'checked','on');
else
    set(h,'checked','off');
end

plotTypeString=get(handles.plotType_popupmenu,'string');
plotTypeValue=get(handles.plotType_popupmenu,'value');
plotType=plotTypeString(plotTypeValue);

if strcmp(plotType,'Sensitivity')
    plotType_popupmenu_Callback(handles.plotType_popupmenu, [], handles);
end



% --------------------------------------------------------------------
function varargout = sensitivity_showPoints_Callback(h, eventdata, handles, varargin)

currentStatus=get(h,'checked');
if strcmp(currentStatus,'off')
    set(h,'checked','on');
else
    set(h,'checked','off');
end

plotTypeString=get(handles.plotType_popupmenu,'string');
plotTypeValue=get(handles.plotType_popupmenu,'value');
plotType=plotTypeString(plotTypeValue);

if strcmp(plotType,'Sensitivity')
    plotType_popupmenu_Callback(handles.plotType_popupmenu, [], handles);
end


% --------------------------------------------------------------------
function string=array2Str(array);

string=num2str(array(1));
for arrayInd=2:length(array)
    string=[string,',',num2str(array(arrayInd))];
end