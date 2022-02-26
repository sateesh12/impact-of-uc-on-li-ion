function saveToFile(em, fname)
% saveToFile(eng_map object, filename)
%
% saves the eng_map data in ascii format to the file of your choice
% the variables fc_map_spd, fc_map_trq, and fc_fuel_map are defined with comments
% this is compatible with ADVISOR format

fid=fopen(fname,'w');
fprintf(fid, 'fc_map_spd = [');
for i=1:length(em.map_spd)
   fprintf(fid, ' %6.3f ', em.map_spd(i));
end
fprintf(fid, ']; %% Map Speed in Radps\n');

fprintf(fid, 'fc_map_trq = [');
for j=1:length(em.map_trq)
   fprintf(fid, ' %6.3f ', em.map_trq(j));
end
fprintf(fid, ']; %% Map Torque in Nm\n');

fprintf(fid, 'fc_fuel_map = [');   
for i=1:length(em.map_spd)
   for j=1:length(em.map_trq)
      fprintf(fid, ' %6.3f ', em.map_fc(i,j));
   end
   if i == length(em.map_spd)
      fprintf(fid, ']; %% fuel consumption by spd and torque in grams per sec \n');
   else
      fprintf(fid, '\n');
   end
end
fprintf(fid, 'fc_fuel_lhv = %6.3f; %% lower heating value of fuel (J/g)\n', em.fuel_lhv);
fprintf(fid, 'fc_max_trq = [');
for k=1:length(em.max_trq)
   fprintf(fid, ' %6.3f ', em.max_trq(k));
end
fprintf(fid, ']; %% Maximum Torque of the Engine Map in Nm\n');
fclose(fid);
      