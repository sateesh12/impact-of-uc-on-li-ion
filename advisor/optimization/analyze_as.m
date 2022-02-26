function RESP = analyze(X)
% ************************************
% analyze.m -function used to run matlab
% files and return responses for optimization use.
% Optimization done with VisualDOC.
% ************************************

%
% Define function for objective function and constraints
%

if nnz(X)>0
   RESP = vdoc_as_opt('visdoc',X);
else
   RESP=1;
end

return