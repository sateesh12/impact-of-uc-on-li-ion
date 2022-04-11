function [x,fval,exitflag,output,lambda,grad,hessian] = gencode(x0,Aeq,beq,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', {  @optimplotx @optimplotfunccount });
options = optimoptions(options,'SpecifyObjectiveGradient', true);
options = optimoptions(options,'HessianApproximation', 'bfgs');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@rosenbrockGrad,x0,[],[],Aeq,beq,lb,ub,[],options);
