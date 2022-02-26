%
% This is a MATLAB example of optimizing a cardboard box
%	3 design variables and 2 responses.
%	Design variables:	DV1 = W - width of a cardboard box
%						DV2 = H	- height of a cardboard box
%						DV3 = D	- depth of a cardboard box
%	Responses:	R1 = V	- Volume of a cardboard box
%				R2 = S	- Surface area of a cardboard box.
%
%	Problem:  Minimize a surface area in such a way that the volume
%				of a box will be greater than 2.
%
%	Design variable W is set to be discrete with the following
%	allowable discrete values 0.5, 2.2, 3.1, 5.4, 6.7
%
%	Design variable H is set to be integer
%
%	Response V is set to be pass-fail
%


% Open the database 'disb'
Error = VDOC_OpenDatabase( 'box' );
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_OpenDatabase.  Error =');
    Error
	Error = VDOC_CloseDatabase;
    return;
end

% Check if the database is really open
Error = VDOC_IsOpen;
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_IsOpen.  Error =');
    Error
	Error = VDOC_CloseDatabase;
    return;
end

% Set up all input parameters: database IDs, initial values, lower and upper bounds
%	Put them into the database
vDBIDInp=[0,0,0];
vX = [1.5,1.5,1.5];
vLBInp = [0.001,0.001,0.001];
vUBInp = [5,5,5];
[Error,vDBIDInp] = VDOC_PutInputAll( vDBIDInp, vX, vLBInp, vUBInp);
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_PutInputAll.  Error =');
    Error
	Error = VDOC_CloseDatabase;
    return;
end

% Set up all response parameters: database IDs, and lower bounds.
%	Default values will be used for upper bounds and scale factors
%	Put them into the database
vDBIDResp = [0,0];
vLBResp = [2,-1.e+30];
[Error,vDBIDResp] = VDOC_PutRespAll( vDBIDResp, vLBResp );
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_PutRespAll.  Error =');
    Error
 	Error = VDOC_CloseDatabase;
   return;
end

% Set second response (S) as objective with all default parameters
[Error,vDBIDResp(2)] = VDOC_PutRespObj( vDBIDResp(2) );
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_PutRespObj.  Error =');
    Error
 	Error = VDOC_CloseDatabase;
    return;
end

% Set the design control information 
%	first parameter=0 means DGO, 1 means RSA
Error = VDOC_PutTaskType( 1, 'MATLAB box Optimization');
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_PutDesignControl.  Error =');
    Error
	Error = VDOC_CloseDatabase;
    return;
end

% Set the RSA control information 
%Error = VDOC_PutRSAControlGeneral( NitersConv, NPointsMax,NPointsMin, ModelOrder,ToMinimize )
Error = VDOC_PutRSAControlGeneral( 2, 50, 10, 3 ,1);
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_PutRSAControlGeneral.  Error =');
    Error
	Error = VDOC_CloseDatabase;
    return;
end

% Make optimization task
TaskNumber = VDOC_MakeTask;
if TaskNumber < 0 
    disp(' ');
    disp(' Stopped after MakeTask.  Error =');
    TaskNumber 
 	Error = VDOC_CloseDatabase;
    return;
end

% Set up the optimization loop with RSA
%	StatusCode is set to initialize optimization
StatusCode = 0;
matDVs = 0;
matResps = 0;

% Loop around call to optimizer and evaluation of responses
%	The loop continues for the cases of:
%	StatusCode = 0	- Initialization 
%	StatusCode = 2	- evaluate response at one point
%	StatusCode = 3	- evaluate response at several points (for gradients)
while( (StatusCode==0) | (StatusCode==2) | (StatusCode==3) )
 
    % Call Optimizer
    [Error, StatusCode, matDVs, matResps] = VDOC_RunRSA( TaskNumber, StatusCode, matDVs, matResps );
 	if Error < 0 
    	disp(' ');
    	disp(' Stopped after VDOC_RunRSA.  Error =');
    	Error
    	return;
	end
   
    % If optimization is completed (StatusCode=1), or if some unexpected 
    %	error occured - exit.
    if ( (StatusCode==1) & (StatusCode==6) )
        StatusCode
        break;
    end
    
    % Get the number of points where we need to evaluate responses:
    %	number of rows (first dimension) in the matrix of design variables
    NSize = size( matDVs );
    NPoints = NSize(1);
    
    % For each point evaluate responses and write them into the matrix of responses
    for i = 1:NPoints
       
       % get responses
        V = con_fun_box(matDVs)
        S = obj_fun_box(matDVs)
        
        % Put responses into the corresponding row of the matrix of responses
        matResps(i,1) = V;
        matResps(i,2) = S;
    end 
    
    matDVs
    matResps
end  

disp(' ');
disp(' ====================================');
disp(' Optimization is completed!!!');
StatusCode
disp(' ====================================');



% Get the results of the optimization
[Error, BestTask, BestObj, WorstConstr, BestIterNumber, BestSubIterNumber, StopCode, RunStatus] = VDOC_GetFinalResultsOptim( TaskNumber )
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_GetFinalResultsOptim.  Error =');
    Error
    return;
end


% Get the point number where the best design occured
[Error, PointNumber, Obj, Constr, BestPointNumber, BestObj, WorstConstr] = VDOC_GetSubIter( BestTask, BestIterNumber, BestSubIterNumber )
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_GetSubIter.  Error =');
    Error
    return;
end

% Get the values of the design variables and responses at the best point
[Error, vDVs, vResps] = VDOC_GetDPoint( BestTask, PointNumber )
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_GetDPoint.  Error =');
    Error
    return;
end

% Close the database
Error = VDOC_CloseDatabase;
if Error < 0 
    disp(' ');
    disp(' Stopped after VDOC_CloseDatabase.  Error =');
    Error
    return;
end



