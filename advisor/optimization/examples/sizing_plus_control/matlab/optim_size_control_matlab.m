% Script to optimize component sizes and control in ADVISOR using the Matlab optimization toolbox
%
% 1) initialize workspace
% 2) define the problem
% 3) run optimizer
% 4) save results
%

% initialize the workspace
input.init.saved_veh_file='FUEL_CELL_defaults_in';
[a,b]=adv_no_gui('initialize',input);

% store names
dv_names={'fc_pwr_scale','mc_trq_scale','ess_module_num','ess_cap_scale','cs_min_pwr','cs_max_pwr','cs_charge_pwr','cs_min_off_time'};
resp_names={'combined_mpgge'};
con_names={'delta_soc','delta_trace','vinf.accel_test.results.time(1)','vinf.accel_test.results.time(2)','vinf.accel_test.results.time(3)','vinf.grade_test.results.grade'};

% define the problem
FUN='obj_fun_size_control';
NONLCON='con_fun_size_control';
X0=[1.5 1.25 15 1.3517 5000 45000 5000 65]; % constraint violation (accel)
LB=[1.0,0.8,11,0.333,0,25000,0,10];
UB=[3.0,2.5,35,2.0,25000,50000,25000,1000];
A=[];
B=[];
Aeq=[];
Beq=[];
c_L=[-1e30; -1e30; -1e30; -1e30; -1e30; 6.5];
c_U=[0.005; 2; 11.2; 4.4; 20; 1e30];

myoptions=optimset('fmincon');
myoptions=optimset(myoptions,'Display','iter');%'off'
myoptions=optimset(myoptions,'LargeScale','on');%'on'
myoptions=optimset(myoptions,'DiffMinChange',1e-8);%1e-8
myoptions=optimset(myoptions,'DiffMaxChange',0.1);%0.1
myoptions=optimset(myoptions,'TolFun',1e-4); %1e-6
myoptions=optimset(myoptions,'TolX',1e-4); %1e-6
myoptions=optimset(myoptions,'TolCon',1e-6);%1e-6

% start the optimization
[X,FVAL,EXITFLAG,OUTPUT]=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,myoptions,dv_names,resp_names,con_names,c_L,c_U)

% save the vehicle
input.save.filename='optim_veh_matlab';
[a,b]=adv_no_gui('save_vehicle',input);


