% Script to link to the iSIGHT optimization tools to Matlab.
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
% 1) modify workspace
% 2) calculate objective and constraint responses
% 3) save results
%
% Note: all problem definition takes place within iSIGHT.

% Define variables
dv_names={'Width','Height','Depth'};
resp_names={'Surface Area'};
con_names={'Volume'};

% load new design variables
indata_box

% Evaluate responses
obj=obj_fun_box(X,dv_names,resp_names,con_names);
con=con_fun_box(X,dv_names,resp_names,con_names);

% write responses to file
fid=fopen('outdata_box.txt','w');
fprintf(fid,'This is the output data file produced by Matlab and read by iSIGHT')
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'Surface Area: %g',obj(1));
fprintf(fid,'\n');
fprintf(fid,'Volume: %g',con(1));
fprintf(fid,'\n');
fclose(fid);

% close matlab
exit
