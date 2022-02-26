% Script to link to the Matlab optimization toolbox.
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
% For more information on parameter definitions see optimization toolbox documentation

% define the problem
FUN='obj_fun_box';
NONLCON='con_fun_box';
X0=[1, 1, 1];  % initial design value
LB=[0.001, 0.001, 0.001]; % design variables lower bound
UB=[5.0, 5.0, 5.0]; % design variables upper bound
A=[];
B=[];
Aeq=[];
Beq=[];
c_L=[2]; % constraint lower bound
c_U=[1e30]; % constraint upper bound

% store names
dv_names={'Width','Height','Depth'};
resp_names={'Surface Area'};
con_names={'Volume'};

% define optimizer options
myoptions=[];

% start the optimization
[X,FVAL,EXITFLAG,OUTPUT]=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,myoptions,dv_names,resp_names,con_names,c_L,c_U)

