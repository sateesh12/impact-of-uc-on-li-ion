function convert_generator_tables

%%%%
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

input_file = [vinf.generator.name];   % gen_file
% Aaron - you'll have to pass this file name into this 
% when you make it a function jjc

% eval(input_file);
% Aaron - yuo won't have to use "eval" here when properly integrated into the
% ADVISOR structure.  The GC file should have already been loaded into memory
% from the GUI selections. jjc

gc_efficency_file = [SaberPath,'gc_ind_gen_eff.ai_dat'];
gc_max_trq_file = [SaberPath,'gc_max_trq.ai_dat'];

gc_map_trq=evalin('base','gc_map_trq*gc_trq_scale*gc_overtrq_factor');
gc_eff_map=evalin('base','gc_eff_map');
gc_map_spd=evalin('base','gc_map_spd*gc_spd_scale');
gc_max_trq=evalin('base','gc_max_trq*gc_trq_scale*gc_overtrq_factor');

num_spds = size(gc_map_spd);
num_trqs=size(gc_map_trq);

j=1;
k=1;

fid = fopen(gc_efficency_file,'wt');

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
     data_row=[(30/pi)*gc_map_spd(i),gc_map_trq(j),gc_eff_map(i,j)];
     fprintf(fid,[num2str(data_row),'\n']);
  end
end
fclose (fid);

fid = fopen(gc_max_trq_file,'wt');
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
     fprintf(fid,[num2str((30/pi)*gc_map_spd(i)),'   ',num2str(gc_max_trq(i)),'\n']);
end

fclose (fid);




% disp(['Created: ', output_file]);
disp('Done converting generator file for cosim');