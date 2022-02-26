function convert_motor_tables
%%%%
%
% Function to translate motor files from ADVISOR into a form
% readable in Saber using the saber include block.  
% 
% The purpose is to have an easily defineable block to
% change the motor file within a schematic.
%
%  
%%%%
global vinf

SaberPath=strrep(which('advisor.m'),'advisor.m','models\Saber\');

input_file = vinf.motor_controller.name;   % motor_file
% Aaron - you'll have to pass this file name into this 
% when you make it a function jjc

% eval(input_file);
% Aaron - yuo won't have to use "eval" here when properly integrated into the
% ADVISOR structure.  The MC file should have already been loaded into memory
% from the GUI selections. jjc

mc_efficency_file = [SaberPath,'mc_eff.ai_dat'];
mc_max_motor_file = [SaberPath,'mc_max_motor_trq.ai_dat'];
mc_max_regen_file = [SaberPath,'mc_max_regen_trq.ai_dat'];

mc_map_spd=evalin('base','mc_map_spd*mc_spd_scale');
mc_map_trq=evalin('base','mc_map_trq*mc_trq_scale');
mc_max_trq=evalin('base','mc_max_trq*mc_overtrq_factor*mc_trq_scale');
mc_max_gen_trq=evalin('base','mc_max_gen_trq*mc_overtrq_factor*mc_trq_scale');
mc_eff_map=evalin('base','mc_eff_map');

num_spds = size(mc_map_spd);
num_trqs=size(mc_map_trq);

j=1;
k=1;

fid = fopen(mc_efficency_file,'wt');

fprintf(fid,'#========================================================================\n');
fprintf(fid,'#   EFFICIENCY LOOKUP TABLE                                           \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Saber model parameters for motor table look model used in         \n');
fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   This data extracted from the ADVISOR file %s                \n',input_file);
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Speed (rpm)    trq (Nm)     eff 0->1.00         \n');
fprintf(fid,'#========================================================================\n\n');


%saber_motor_matrix=zeros(3,num_spds(:,2)*num_trqs(:,2));
for i=1:num_spds(:,2)
   for j=1:num_trqs(:,2)
     data_row=[(30/pi)*mc_map_spd(i),mc_map_trq(j),mc_eff_map(i,j)];
     fprintf(fid,[num2str(data_row),'\n']);
  end
end
fclose (fid);

fid = fopen(mc_max_motor_file,'wt');
fprintf(fid,'#========================================================================\n');
fprintf(fid,'#   MAX Torque in MOTORING mode                                        \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Saber model parameters for motor table look model used in         \n');
fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   This data extracted from the ADVISOR file %s                \n',input_file);
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Speed (rpm)    trq (Nm)                     \n');
fprintf(fid,'#========================================================================\n\n');

for i=1:num_spds(:,2)    
     fprintf(fid,[num2str((30/pi)*mc_map_spd(i)),'   ',num2str(mc_max_trq(i)),'\n']);
end

fclose (fid);

fid = fopen(mc_max_regen_file,'wt');
fprintf(fid,'#========================================================================\n');
fprintf(fid,'#   MAX Torque in REGEN   mode                                        \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Saber model parameters for motor table look model used in         \n');
fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   This data extracted from the ADVISOR file %s                \n',input_file);
fprintf(fid,'#                                                                     \n');
fprintf(fid,'#   Speed (rpm)    trq (Nm)                     \n');
fprintf(fid,'#========================================================================\n\n');

for i=1:num_spds(:,2)    
     fprintf(fid,[num2str((30/pi)*mc_map_spd(i)),'   ',num2str(mc_max_gen_trq(i)),'\n']);
end

fclose (fid);





% disp(['Created: ', output_file]);
disp('Done converting motor file for cosim');