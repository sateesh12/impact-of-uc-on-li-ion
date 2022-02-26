function [vDVs,vResps]=opt_vdoc_dgo(x_init)

%
% This script file is used to test the optimizer on a 2d Univariante Polynomial optimization problem
%
% 2 design variables, 0 constraints, and 1 responses.
%
% Solution: optimal value is at f(0,0)=0;
%


% Set up constant parameters
NInputs = 2;
NResps = 1;

% Set up all input parameters: database IDs, initial values, lower and upper bounds
vDBIDInp=[0,0];
vX=x_init; 
vLBInp = [-3,-3];
vUBInp = [3.0,3.0];

% Set up all response parameters: database IDs,lower and upper bounds
vDBIDResp = [0];
vLBResp = [-1.e+30];
vUBResp = [ 1.e+30];

% Open the database
Error = VDOC_OpenDatabase( 'optim_camel_vdoc_dgo' );
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

%	Put input parameters into the database
[Error,vDBIDInp] = VDOC_PutInputAll( vDBIDInp, vX, vLBInp, vUBInp);
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutInputAll.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

% Put just the bounds for all the responses into the database
[Error,vDBIDResp] = VDOC_PutRespAll( vDBIDResp, vLBResp, vUBResp );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutRespAll.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

% Put ONLY GOAL objective characteristic into the 1st response object (V)
vRespGoal=0; % 0=minimize,1=maximize, 2=target
[Error,vDBIDResp(1)] = VDOC_PutRespObj( vDBIDResp(1),vRespGoal );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutRespObj.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

% Set the task type information 
TaskType = 0; %	DGO=0, RSA=1, DOE=2
Error = VDOC_PutTaskType( TaskType , 'Fuel Cell System Optimization' );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutTaskType.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

defaults_bool=1; % 1 use default parameter settings; 0 use user defined optimizer parameter settings defined below

if ~defaults_bool&(TaskType==0)
   ConstMethod=0; %SQP=0, SLP=1, MMFD=2 [0]
   UnconstMethod=0; %BFGS=0, FR=1 [0]
   NItersMax=50; % [100]
   NitersConv=2; % [2]
   ToMinimize =1; %TRUE=1, FALSE=0  [1]
   Error = VDOC_PutDGOControlGeneral( ConstMethod, UnconstMethod,	NItersMax, NitersConv,ToMinimize );
   
   ActConstToler=-0.03; %A constraint is considered active if its value is more positive than ActConstToler [-0.03]
   ViolConstToler=0.003; %A constraint is considered violated if its value is more negative than ViolConstToler [0.003]
   Error = VDOC_PutDGOControlConstr( ActConstToler, ViolConstToler);
   
   SoftRel=0.001; %A maximum relative change in design variables during the last NitersConv consecutive iterations to achieve relative soft convergence [0.001]
   SoftAbs=0.0001; %A maximum absolute change in design variables during the last NitersConv iterations to achieve absolute soft convergence [0.0001]
   HardRel=0.001; %A maximum relative change in objective function during the last NitersConv consecutive iterations to achieve relative hard convergence.  Should be a positive number. [0.001]
   Error = VDOC_PutDGOControlConv( SoftRel, SoftAbs, HardRel )
   
   GradCalcMethod=0; %0-Forward differences; 1-Central differences; 2-User supplied gradients [0]
   RelFDStep=0.01; %Relative finite difference step when calculating gradients [0.001]
   AbsFDStep =0.001;  %Minimum absolute finite difference step when calculating gradients.  [0.0001]
   Error = VDOC_PutDGOControlFD( GradCalcMethod, RelFDStep,	AbsFDStep );
end

% Make optimization task
TaskNumber = VDOC_MakeTask;
if TaskNumber < 0 
   disp(' ');
   disp(' Stopped after VDOC_MakeTask.  Error =');
   TaskNumber 
   Error = VDOC_CloseDatabase;
   return;
end


% Set up the optimization loop with RSA
%	StatusCode is set to initialize optimization
StatusCode = 0;
matDVs = 0;
matResps = 0;
vIndActResps = 0;
icount = 0;

% initiate timer
tic

% Loop around call to optimizer and evaluation of responses
%	The loop continues for the cases of:
%	StatusCode = 0	- Initialization 
%	StatusCode = 2	- evaluate response at one point
%	StatusCode = 3	- evaluate response at several points (for gradients)
while( (StatusCode==0) | (StatusCode==2) | (StatusCode==3) )
   
   % Call Optimizer
   if TaskType==1
      [Error, StatusCode, matDVs, matResps] = VDOC_RunRSA( TaskNumber, StatusCode, matDVs, matResps );
   elseif TaskType==0
      [Error, StatusCode, matDVs, matResps, vIndActResps] = VDOC_RunDGO( TaskNumber, StatusCode, matDVs, matResps, vIndActResps );
   else
      Error=-1;   
   end
   
   if Error < 0 
      disp(' ');
      disp(' Stopped after VDOC_RunDGO.  Error =');
      Error
      return;
   end
   
   % If optimization is completed (StatusCode=1), or if some unexpected 
   %	error occured - exit.
   if ( (StatusCode==1) & (StatusCode==6) )
      StatusCode
      break;
   end
   
   
   % Check if we need to evaluate responses:
   if ( StatusCode == 2 )
      
      % Get the number of points where we need to evaluate responses:
      %	number of rows (first dimension) in the matrix of design variables
      NSize = size( matDVs );
      NPoints = NSize(1);
      
      % For each point evaluate responses and write them into the matrix of responses
      for vdoc_i = 1:NPoints
         
         % Evaluate responses
         obj=obj_fun_camel(matDVs(vdoc_i,:));
         con=con_fun_camel(matDVs(vdoc_i,:));
         
         % Put responses into the corresponding rows of the matrix of responses
         matResps(vdoc_i,1) = obj(1);
         
         icount=icount+1;
      end 
      
      disp(' ');
      disp(' Counting ');
      icount
      disp(' Status Code');
      StatusCode
      disp(' ====================================');
      matDVs
      disp(' -----');
      matResps    
   end
end  

%end timer
toc

disp(' ');
disp(' ====================================');
disp(' Optimization is completed!!!');
StatusCode
disp(' ====================================');



% Get the results of the optimization
[Error, BestTask, BestObj, WorstConstr, BestIterNumber, BestSubIterNumber, StopCode, RunStatus] = VDOC_GetFinalResultsOptim( TaskNumber );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_GetFinalResultsOptim.  Error =');
   Error
   return;
end


% Get the point number where the best design occured
[Error, PointNumber, Obj, Constr, BestPointNumber, BestObj, WorstConstr] = VDOC_GetSubIter( BestTask, BestIterNumber, BestSubIterNumber );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_GetSubIter.  Error =');
   Error
   return;
end

% Get the values of the design variables and responses at the best point
[Error, vDVs, vResps] = VDOC_GetDPoint( BestTask, PointNumber );
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


% %display number of function evaluations
funcev=icount

return
