% Clear all the variables
clear all

% initiate timer
tic

% Load advisor saved vehicle
input.init.saved_veh_file='FUEL_CELL_defaults_in';
[error_code,resp]=adv_no_gui('initialize',input);

% Define variables
dv_names={'cs_min_pwr','cs_max_pwr','cs_charge_pwr','cs_min_off_time'};
resp_names={'combined_mpgge','delta_soc','delta_trace','vinf.accel_test.results.time(1)','vinf.accel_test.results.time(2)','vinf.accel_test.results.time(3)','vinf.grade_test.results.grade'};

% load new design variables
indata_control

% Evaluate responses
obj=obj_fun_control(X,dv_names,resp_names);
con=con_fun_control(X,dv_names,resp_names);

% write responses to file
fid=fopen('outdata_control.txt','w');
fprintf(fid,'Fuel Economy: %g',obj);
fprintf(fid,'\n');
fprintf(fid,'Delta SOC: %g',con(1));
fprintf(fid,'\n');
fprintf(fid,'Delta Trace: %g',con(2));
fprintf(fid,'\n');
fprintf(fid,'Accel 0-60: %g',con(3));
fprintf(fid,'\n');
fprintf(fid,'Accel 40-60: %g',con(4));
fprintf(fid,'\n');
fprintf(fid,'Accel 0-85: %g',con(5));
fprintf(fid,'\n');
fprintf(fid,'Grade: %g',con(6));
fprintf(fid,'\n');
fclose(fid);

% save the existing configuration and workspace for later use
no_gui_param.save.filename='optim_veh_isight'; [a,b]=adv_no_gui('save_vehicle',no_gui_param)
save optim_veh_isight % save workspace

%end timer
toc

% close matlab
exit
