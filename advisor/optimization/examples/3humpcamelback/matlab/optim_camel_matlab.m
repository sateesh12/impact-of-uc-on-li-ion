function [X,FVAL]=opt_matlab(x_init)

% Script to exercise the matlab optimization on Univariante Polynomial Problem.
%
% 1) initialize workspace
% 2) define the problem
% 3) run optimizer
% 4) save results
%


% define the problem
FUN='obj_fun_camel';
X0=x_init;
A=[];
B=[];
Aeq=[];
Beq=[];
LB=[-3,-3];
UB=[3,3];

% initiate timer
tic

% start the optimization
[X,FVAL,exitflag,output]=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB)
   
% end timer
toc

% display # of function evaluations
FuncEv=output.funcCount

return