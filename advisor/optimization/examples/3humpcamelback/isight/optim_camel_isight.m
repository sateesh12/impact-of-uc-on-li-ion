% Script to link to the iSIGHT optimization tools to Matlab.
%
% This is a example of optimizing the 3 hump camel back function
%	3 design variables and 2 responses.
%	Design variables:	DV1 = var 1
%							DV2 = var 2
%	Responses:		R1 = function value
%
%	Problem: Minimize the function value.
%
% Basic steps:
% 1) modify workspace
% 2) calculate objective and constraint responses
% 3) save results
%
% Note: all problem definition takes place within iSIGHT.

% Define variables
dv_names={'Var1','Var2'};
resp_names={'Function'};
con_names={' '};

% load new design variables
indata_camel

% Evaluate responses
obj=obj_fun_camel(X,dv_names,resp_names,con_names);
con=con_fun_camel(X,dv_names,resp_names,con_names);

% write responses to file
fid=fopen('outdata_camel.txt','w');
fprintf(fid,'This is the output data file produced by Matlab and read by iSIGHT')
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'Function: %g',obj(1));
fprintf(fid,'\n');
fclose(fid);

% close matlab
exit
