function [vDVs,vResps]=battery_params(re,rc,rt,cb,cc,time,voltage,idx1,idx4)

% Script to exercise the DIRECT optimization Algorithm with ADVISOR.
%
% 1) initialize workspace
% 2) define the problem
% 3) run optimizer
% 4) save results
%

% define the problem
continuevar=0;
p_f='obj_fun';
p_c='con_fun';
x_L=[re;rc;rt;cb;cc]/1.1;
x_U=[re;rc;rt;cb;cc]*1.1;
A=[];
b_L=[];
b_U=[];
c_L=[0];
c_U=[1000];
I=[];
PriLev=1;
MaxEval=30;
MaxIter=7;
GLOBAL.epsilon=1e-4;
varargin={time,voltage,idx1,idx4};
prev_results_filename='direct_results';

if continuevar==1
   eval(['load(''',prev_results_filename,''')']) 
   GLOBAL = direct_opt_results.GLOBAL;
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
else
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
end

% start the optimization
direct_opt_results = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U, c_L, c_U, I, GLOBAL, PriLev, varargin);

% save the results
eval(['save(''',prev_results_filename,''',','''direct_opt_results'')']) 

% plot the optimization results
plotoptimresults(direct_opt_results.GLOBAL.f_min_hist)

vDVs=direct_opt_results.x_k;
vResps=[direct_opt_results.f_k direct_opt_results.c_k];

return