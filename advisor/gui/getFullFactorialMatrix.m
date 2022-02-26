function [matrix,matrixValueInd]=getFullFactorialMatrix(highValues,lowValues,numSteps)
%   function [matrix,matrixInd]=getFullFactorialMatrix(highValues,lowValues,numSteps)
%       This function returns every combination of values for a full factorial
%       design of experiments.  Each combination is indexed by row.  The value index
%       is also returned in matrixInd.  For example, in a two by two matrix:
%           matrixInd={'1,1';'2,1';'1,2';'2,2'};
%       The inputs are:
%           highValues: the high setting for each variable
%           lowValues:  the low setting for each variable
%           numSteps:   number of steps evaluated for each variable

numVars=length(highValues);
matrix=[];

%   Create varValueArray{varIndex}{varStep} cell array (all values for each variable)
for varIndex=1:numVars
    stepSize=((highValues(varIndex)-lowValues(varIndex))/(numSteps(varIndex)-1));
    for varStepInd=1:numSteps(varIndex)
        varValueArray{varIndex}{varStepInd}=lowValues(varIndex) + (varStepInd-1)*stepSize;
    end
end

%   Loop through combinations
varStep(1:length(varValueArray))={1}; % all variables start at low setting
doeDone(1:length(varValueArray))=0;
fracDonePerLoop=1/prod(numSteps); % for waitbar
percentDone=0; % for waitbar
matrixCreationWaitbarH=waitbar(percentDone,'Creating Full Factorial Matrix');
matrixInd=0;
matrixValueInd={};
while sum(doeDone) ~= length(varValueArray)
    
    %   Create matrix with variable values
    matrixInd=1+matrixInd;
    matrixValueIndStr=[];
    for varIndex=1:length(varValueArray)
        matrix(matrixInd,varIndex)=varValueArray{varIndex}{varStep{varIndex}};
        matrixValueIndStr=[matrixValueIndStr,',',num2str(varStep{varIndex})];
    end
    matrixValueInd{end+1}=matrixValueIndStr(2:end); % 2:end eliminates extra ',' 
    
    %   Check if DOE is done (all combinations have been run)
    for varIndex=1:length(varValueArray)
        if varStep{varIndex} == length(varValueArray{varIndex})
                doeDone(varIndex)=1;
            else
            doeDone(varIndex)=0;
        end
    end
    
    %   Modify current lookup position of varValueArray{varIndex}{varStep} (which value is being used for each variable)
    if varStep{1} == length(varValueArray{1})
        varStep{1}=1;
        varStepReset=1;
    else
        varStep{1}=varStep{1}+1;
        varStepReset=0;
    end
    for varIndex=2:length(varValueArray)
        if varStepReset == 1
            if varStep{varIndex} == length(varValueArray{varIndex})
                varStep{varIndex}=1;
                varStepReset=1;
            else
                varStep{varIndex}=varStep{varIndex}+1;
                varStepReset=0;
            end
        end
    end
    
    %   Update waitbar
    percentDone=fracDonePerLoop+percentDone;
    waitbar(percentDone,matrixCreationWaitbarH);
    
end % end while doeDone == 0
close(matrixCreationWaitbarH);

