% This is a example of how to build a ScriptFile for use with ADVISOR_script.exe
% 

% Clear all existing variables
clear all

% load the default parallel hybrid configuration and initialize the workspace.
input.init.saved_veh_file='Parallel_Defaults_in';
[error_code,resp]=adv_no_gui('initialize',input);

% load input data
trq_range=[0.25:0.25:1.25];
% Note: This could also read in from a text file.

for I=1:length(trq_range)
    input.modify.param={'fc_trq_scale'};input.modify.value={trq_range(I)};[a,b]=adv_no_gui('modify',input)
    % to modify the engine torque scale (i.e. change the peak power output of the engine)
    
    input.procedure.param={'test.name'};input.procedure.value={'TEST_CITY_HWY'};[a,b]=adv_no_gui('test_procedure',input)
    fuel(I)=b.procedure.mpgge
    % to run the city hwy test procedure and obtain the default fuel and emissions performance
    
    input.accel.param={'spds'};input.accel.value={[0 30; 50 70]};[a,b]=adv_no_gui('accel_test',input)
    accel1(I)=b.accel.times(1);
    accel2(I)=b.accel.times(2);
    % to run the acceleration test and obtain the 0 to 30 mph and 50 to 70 mph accel times
    
    input.resp.param={'veh_mass';'fc_trq_scale'};[a,b]=adv_no_gui('other_info',input)
    mass(I)=b.other.value{1};
    scale(I)=b.other.value{2};
    % to obtain the resulting vehicle mass
end

% write responses to file
fid=fopen('outdata.txt','w');
fprintf(fid,'Torque Scale Factor: %s',mat2str(scale));
fprintf(fid,'\n');
fprintf(fid,'Acceleration 0-30 mph: %s',mat2str(accel1));
fprintf(fid,'\n');
fprintf(fid,'Acceleration 50-70 mph: %s',mat2str(accel2));
fprintf(fid,'\n');
fprintf(fid,'Fuel Economy: %s',mat2str(fuel));
fprintf(fid,'\n');
fclose(fid);

