function [resp]=gctool(inputs)
% create input file

% make vinf global
global vinf

% get path info
gctool_path=vinf.gctool.fullpath(1:end-1);
advisor_path=strrep(which('advisor.m'),'\advisor.m','');

% update *.dat file
gctool_update(advisor_path,inputs)

% run GCtool
str=[advisor_path,'\gui\GCToolsBatch.exe',' ',gctool_path,' ',advisor_path,'\gctool\gctool_model.dat',' ',advisor_path,'\gctool\gctool_model.out'];
%state=execute(str);
eval(['[state,msg]=dos(''',str,''');']);

% get results
resp=gctool_om_post(advisor_path,'gctool_model',inputs);

return

% tm:2/8/01 updated advisor path info
