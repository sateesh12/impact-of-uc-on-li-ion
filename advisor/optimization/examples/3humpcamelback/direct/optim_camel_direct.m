function [x_k,f_k]=opt_direct(x_init,bounds)

% Script to exercise the DIRECT optimization on Univariante Polynomial Problem.
%
% 1) initialize workspace
% 2) define the problem
% 3) run optimizer
% 4) save results
%


% define the problem
cont_bool=0;
p_f='obj_fun_camel';
p_c='con_fun_camel';
b_L=bounds(1,:);
b_U=bounds(2,:);
dist1=b_U-x_init;
dist2=x_init-b_L;
offset=abs(dist1-dist2);
x_L=[b_L-offset.*(dist1>dist2)];
x_U=[b_U+offset.*(dist1<dist2)];
A=[(dist1>dist2); (dist1<dist2)];
c_L=[0];
c_U=[0];
I=[];
PriLev=1;
MaxEval=500;
MaxIter=20;
GLOBAL.epsilon=1e-4;

prev_results_filename='optim_camel_direct';

if cont_bool==1
   eval(['load(''',prev_results_filename,''')']) 
   GLOBAL = direct_opt_results.GLOBAL;
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
else
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
end

% initiate timer
tic

% start the optimization
optim_results_direct = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U, c_L, c_U, I, GLOBAL, PriLev)

% end timer
toc

% save the results
eval(['save(''',prev_results_filename,''',','''optim_results_direct'');']) 

% plot the optimization results
plot_info.var_label={'var1','var2'};
plot_info.var_ub=num2cell(x_U);
plot_info.var_lb=num2cell(x_L);
plot_info.con_label={' '};
plot_info.con_ub=num2cell(c_U);
plot_info.con_lb=num2cell(c_L);
plot_info.fun_label={'F'};
plotoptimresults(optim_results_direct.GLOBAL.f_min_hist,plot_info)

% return results
x_k=optim_results_direct.x_k;
f_k=optim_results_direct.f_k;

% display number of function evaluations
funcev=optim_results_direct.FuncEv+1

return