function build_dat(name)
% create *.dat file for optimization

global vinf;
drivetrain=vinf.drivetrain.name;

fid=fopen([name,'_DOE.DAT'],'w');

fprintf(fid,'TITLE Control Strategy Design of Experiments Using VisualDOC');
fprintf(fid,'\n');
fprintf(fid,'JOB T=DOE P=1'); % use design of experiments 
fprintf(fid,'\n');

% design variables
for i=1:length(vinf.control_strategy.dv.name)
   fprintf(fid,['CAT N=cs',num2str(i),' S=',num2str(i),' E=',num2str(i),' D=',vinf.control_strategy.dv.name{i}]);
   fprintf(fid,'\n');
end

% responses
fprintf(fid,'CAT N=grade S=1001 E=1001 D=max_grade');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a0_18 S=1002 E=1002 D=accel_time_0_18');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a0_30 S=1003 E=1003 D=accel_time_0_30');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a0_60 S=1004 E=1004 D=accel_time_0_60');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a40_60 S=1005 E=1005 D=accel_time_40_60');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a0_85 S=1006 E=1006 D=accel_time_0_85');
fprintf(fid,'\n');
fprintf(fid,'CAT N=dsoc S=1007 E=1007 D=cs_hi_soc-cs_lo_soc');
fprintf(fid,'\n');
fprintf(fid,'CAT N=trace S=1008 E=1008 D=missed_trace');
fprintf(fid,'\n');
fprintf(fid,'CAT N=soc S=1009 E=1009 D=missed_deltasoc');
fprintf(fid,'\n');
fprintf(fid,'CAT N=co S=1010 E=1010 D=co_gpm');
fprintf(fid,'\n');
fprintf(fid,'CAT N=hc S=1011 E=1011 D=hc_gpm');
fprintf(fid,'\n');
fprintf(fid,'CAT N=nox S=1012 E=1012 D=nox_gpm');
fprintf(fid,'\n');
fprintf(fid,'CAT N=pm S=1013 E=1013 D=pm_gpm');
fprintf(fid,'\n');
fprintf(fid,'CAT N=fe S=1014 E=1014 D=mpgge');
fprintf(fid,'\n');
fprintf(fid,'CAT N=obj S=1015 E=1015 D=objective function');
fprintf(fid,'\n');

% active design variables 
for i=1:length(vinf.control_strategy.dv.name)
   if vinf.control_strategy.dv.active(i)
      fprintf(fid,['VAR N=cs',num2str(i),' L=',num2str(vinf.control_strategy.dv.lower_bound(i)),' U=',num2str(vinf.control_strategy.dv.upper_bound(i))]);
      fprintf(fid,'\n');
   end
end

% active constraints
if vinf.autosize.constraints(1)
   fprintf(fid,'CON N=grade DOEM=21');
   fprintf(fid,'\n');
end
if vinf.autosize.constraints(2)
   if vinf.autosize.con.accel.goal.t0_18>0
      fprintf(fid,'CON N=a0_18 DOEM=21');
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_30>0
      fprintf(fid,'CON N=a0_30 DOEM=21');
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_60>0
      fprintf(fid,'CON N=a0_60 DOEM=21');
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t40_60>0
      fprintf(fid,'CON N=a40_60 DOEM=21');
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_85>0
      fprintf(fid,'CON N=a0_85 DOEM=21');
      fprintf(fid,'\n');
   end
end

% misc 
fprintf(fid,'CON N=dsoc DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=trace DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=soc DOEM=21');
fprintf(fid,'\n');

% active objectives 
fprintf(fid,'CON N=co DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=hc DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=nox DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=pm DOEM=21');
fprintf(fid,'\n');
fprintf(fid,'CON N=fe DOEM=21' );
fprintf(fid,'\n');

% normalized objective function
fprintf(fid,'CON N=obj DOEM=21' );
fprintf(fid,'\n');

% DOE parameters
fprintf(fid,['DOE TYPDES=6 TYP2DES=21']); 
fprintf(fid,'\n');
fprintf(fid,'END');
fprintf(fid,'\n');

fclose(fid);

disp('VisualDOC *.dat file created.')

return

% Revision History
% 8/17/99:tm file created from vdoc_cs_opt_dat.m
%
