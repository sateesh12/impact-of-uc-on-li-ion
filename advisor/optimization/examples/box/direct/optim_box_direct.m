% Script to link to the DIRECT optimization Algorithm.
%
% This is a example of optimizing a cardboard box
%	3 design variables and 2 responses.
%	Design variables:	DV1 = W - width of a cardboard box
%							DV2 = H	- height of a cardboard box
%							DV3 = D	- depth of a cardboard box
%	Responses:		R1 = V	- Volume of a cardboard box
%						R2 = S	- Surface area of a cardboard box.
%
%	Problem: Minimize a surface area in such a way that the volume
%				of a box will be greater than 2.
%
% Basic steps:
% 1) initialize the problem
% 2) run optimizer
% 3) save results
%
% For more information on parameter definitions see direct_doc.txt

% define the problem
cont_bool=0; % boolean, 1 ==> continue from end of previous run, 0 ==> new optimization run
prev_results_filename='direct_results'; % name of results file from which to start if a restart
new_results_filename='direct_results'; % name of results file in which to save current results
p_f='obj_fun_box'; % name of objective function file
p_c='con_fun_box'; % name of constraint function file
x_L=[0.001; 0.001; 0.001]; % lower bound of design variables
x_U=[5.0; 5.0; 5.0]; % upper bound of design variables
A=[]; 
b_L=[];
b_U=[]; 
c_L=[2]; % constraint lower bound
c_U=[100]; % constraint upper bound
I=[]; % vector of indices of integer variables
PriLev=2; % print level; 0=only final results; 1=display intermediate results; 2=display intermediate results and graphical plots
MaxEval=250; % maximum number of function evaluations to complete
MaxIter=20; % maximum number of design interations to complete
GLOBAL.epsilon=1e-4; % controls emphasis on global vs. local search - useful range is between 1e-4 and 1e-7
varargin=[];

dv_names={'Width','Height','Depth'};
resp_names={'Surface Area'};
con_names={'Volume'};

plot_info.var_label=dv_names;
plot_info.var_ub=num2cell(x_U);
plot_info.var_lb=num2cell(x_L);
plot_info.con_label=con_names;
plot_info.con_ub=num2cell(c_U);
plot_info.con_lb=num2cell(c_L);
plot_info.fun_label=resp_names;

if cont_bool==1 % if continue from previous run load the previous set of results and update global parameters
   eval(['load(''',prev_results_filename,''')']) 
   GLOBAL = opt_results.GLOBAL;
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
else
   GLOBAL.MaxEval = MaxEval;
   GLOBAL.MaxIter = MaxIter;
end

% start the optimization
opt_results = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U, c_L, c_U, I, GLOBAL, PriLev, plot_info, dv_names, resp_names, con_names);

% save the results
eval(['save(''',new_results_filename,''',','''opt_results'')']) 

% plot the optimization results
if PriLev==2
   PlotOptimResults(opt_results.GLOBAL.f_min_hist, plot_info)
end

%Revision History
%7/31/01:tm renamed continue to cont_bool - continue is a reserved word