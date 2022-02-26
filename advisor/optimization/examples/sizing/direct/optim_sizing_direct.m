% Script to exercise the DIRECT optimization Algorithm with ADVISOR.
%
% 1) initialize workspace
% 2) define the problem
% 3) run optimizer
% 4) save results
%

% initiate timer
tic

% initialize the workspace
if 1% 1=initialize, 0=don't initial - for continuation runs
input.init.saved_veh_file='FUEL_CELL_defaults_in';
[a,b]=adv_no_gui('initialize',input);
end

dv_names={'fc_pwr_scale','mc_trq_scale','ess_module_num','ess_cap_scale'};
resp_names={'combined_mpgge'};
con_names={'delta_soc','delta_trace','vinf.accel_test.results.time(1)','vinf.accel_test.results.time(2)','vinf.accel_test.results.time(3)','vinf.grade_test.results.grade'};

% define the problem
cont_bool=0;
p_f='obj_fun_sizing';
p_c='con_fun_sizing';
x_L=[1.0,0.8,11,0.333]';
x_U=[3.0,2.5,35,2.0]';
A=[];
b_L=[];
b_U=[];
c_L=[0; 0; 0; 0; 0; 6.5];
c_U=[0.005; 2; 11.2; 4.4; 20; 100];
I=[];
PriLev=2;
MaxEval=500;
MaxIter=50;
GLOBAL.epsilon=1e-4;
prev_results_filename='optim_sizing_direct';

if cont_bool==1
   eval(['load(''',prev_results_filename,''')']) 
   GLOBAL = direct_opt_results.GLOBAL;
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
else
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
end

plot_info.var_label=dv_names;
plot_info.var_ub=num2cell(x_U);
plot_info.var_lb=num2cell(x_L);
plot_info.con_label=con_names;
plot_info.con_ub=num2cell(c_U);
plot_info.con_lb=num2cell(c_L);
plot_info.fun_label=resp_names;

% start the optimization
direct_opt_results = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U, c_L, c_U, I, GLOBAL, PriLev, plot_info, dv_names, resp_names, con_names);

% save the results
eval(['save(''',prev_results_filename,''',','''direct_opt_results'');']) 

% save the vehicle
input.save.filename='optim_veh_direct';
[a,b]=adv_no_gui('save_vehicle',input);

% plot the optimization results
plotoptimresults(direct_opt_results.GLOBAL.f_min_hist, plot_info)

% end timer
toc