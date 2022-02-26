function obj=obj_fun(x,varargin)

% Reference informatio for this function can be found on http://titan.princeton.edu/TestProblems/ 
% and ftp://titan.princeton.edu/TestProblems/chapter4/ex4.1.5.gms
% It is refered to as the three humped camel back function.

obj=2*x(1)^2 - 1.05*x(1)^4 + 1/6*x(1)^6 - x(1)*x(2) + x(2)^2;

return
