function gctool_update(advisor_path,inputs)
% update *.dat file for gctool

% open file for reading and writing
fid=fopen([advisor_path,'\gctool\gctool_model.dat'],'r+');
fprintf(fid,'//***\n//\n');
fprintf(fid,'double power_req=%.3e;\n',inputs(1));
fclose(fid);

return

% Revision History
% tm:9/8/99 file created