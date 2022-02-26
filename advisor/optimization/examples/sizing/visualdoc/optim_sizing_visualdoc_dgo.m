function example()
%
%
%


% Clear all the variables
clear all

% Open the database 
Error = VDOC_OpenDatabase( 'optim_sizing_visualdoc_dgo' );
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
vDBIDInp=[0, 0, 0];
vX = [1, 25, 1];
vLBInp = [0.5, 10, 0.5];
vUBInp = [1.5, 35, 1.5];
[Error,vDBIDInp] = VDOC_PutInputAll( vDBIDInp, vX, vLBInp, vUBInp)
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
vDBIDResp = [0,0,0,0,0,0,0];
vLBResp = [-1.e+30, -1.e+30, -1.e+30, 6, -1.e+30, -1.e+30, -1.e+30];
vUBResp = [1.e+30, 0.005, 2, 1.e+30, 12, 5.3, 23.4];
[Error,vDBIDResp] = VDOC_PutRespAll( vDBIDResp, vLBResp, vUBResp);
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutRespAll.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

% Set second response (S) as objective with all default parameters
[Error,vDBIDResp(1)] = VDOC_PutRespObj( vDBIDResp(1) );
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutRespObj.  Error =');
   Error
   Error = VDOC_CloseDatabase;
   return;
end

% Set the design control information 
%	first parameter=0 means DGO, 1 means RSA 2= DOE
Error = VDOC_PutTaskType( 0, 'ADVISOR Component Sizing Optimization');
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_PutDesignControl.  Error =');
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

input.init.saved_veh_file='PARALLEL_defaults_in';
[error_code,resp]=adv_no_gui('initialize',input);

dv_names={'fc_trq_scale','ess_module_num','mc_trq_scale'};
resp_names={'combined_mpgge'};
con_names={'delta_soc','delta_trace','vinf.accel_test.results.time(1)','vinf.accel_test.results.time(2)','vinf.accel_test.results.time(3)','vinf.grade_test.results.grade'};

% Set up the optimization loop with DGO
%	StatusCode is set to initialize optimization
StatusCode = 0;
matDVs = 0;
matResps = 0;
vIndActResps = 0;

% Loop around call to optimizer and evaluation of responses
%	The loop continues for the cases of:
%	StatusCode = 0	- Initialization 
%	StatusCode = 2	- evaluate response at one point
%	StatusCode = 3	- evaluate response at several points (for gradients)
while( (StatusCode==0) | (StatusCode==2) | (StatusCode==3) )
   
   % Call Optimizer
   [Error, StatusCode, matDVs, matResps, vIndActResps] = VDOC_RunDGO( TaskNumber, StatusCode, matDVs, matResps, vIndActResps );
   if Error < 0 
      disp(' ');
      disp(' Stopped after VDOC_RunDGO.  Error =');
      Error
      return;
   end
   
   % If optimization is completed (StatusCode=1), or if some unexpected 
   %	error occured - exit.
   if ( (StatusCode~=2) & (StatusCode~=3) )
      StatusCode
      break;
   end
   
   % Get the number of points where we need to evaluate responses:
   %	number of rows (first dimension) in the matrix of design variables
   NSize = size( matDVs );
   NPoints = NSize(1);
   
   % For each point evaluate responses and write them into the matrix of responses
   for vdoc_i = 1:NPoints
     
       obj=obj_fun_sizing(matDVs(vdoc_i,:),dv_names,resp_names,con_names);
       con=con_fun_sizing(matDVs(vdoc_i,:),dv_names,resp_names,con_names);

       matResps(vdoc_i,:)=[obj con'];
      % matResps(vdoc_i,2:length(con)+1)=con;

   end 
   
end    

% Get the results of the optimization
[Error, BestObj, WorstConstr, BestIterNumber, BestSubIterNumber, StopCode, RunStatus] = VDOC_GetFinalResultsOptim( TaskNumber )
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_GetFinalResultsOptim.  Error =');
   Error
   return;
end

% Get the point number where the best design occured
[Error, PointNumber, Obj, Constr, BestPointNumber, BestObj, WorstConstr] = VDOC_GetSubIter( TaskNumber, BestIterNumber, BestSubIterNumber )
if Error < 0 
   disp(' ');
   disp(' Stopped after VDOC_GetSubIter.  Error =');
   Error
   return;
end

% Get the values of the design variables and responses at the best point
[Error, vDVs, vResps] = VDOC_GetDPoint( TaskNumber, PointNumber )
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



