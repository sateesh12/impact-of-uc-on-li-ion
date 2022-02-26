function build_as_dat(name)
% create *.dat file for autosize optimization

global vinf;
drivetrain=vinf.drivetrain.name;

fid=fopen([name,'_OPT.DAT'],'w');

fprintf(fid,'TITLE Autosize Using VisualDOC');
fprintf(fid,'\n');
if vinf.autosize.params.resp
   fprintf(fid,'JOB T=APP P=1'); % use response surfaces
   fprintf(fid,'\n');
   fprintf(fid,['APP L=',num2str(vinf.autosize.params.iter.min),' M=',num2str(vinf.autosize.params.iter.max),'']);
else
   fprintf(fid,'JOB T=OP P=1'); % full optimization
end
%fprintf(fid,'JOB T=AN P=1'); % run one analysis
fprintf(fid,'\n');
fprintf(fid,'CAT N=fcts S=1 E=1 D=fc_trq_scale');
fprintf(fid,'\n');
fprintf(fid,'CAT N=essmn S=2 E=2 D=ess_module_num');
fprintf(fid,'\n');
fprintf(fid,'CAT N=mcts S=3 E=3 D=mc_trq_scale');
fprintf(fid,'\n');
fprintf(fid,'CAT N=losoc S=4 E=4 D=cs_lo_soc');
fprintf(fid,'\n');
fprintf(fid,'CAT N=hisoc S=5 E=5 D=cs_hi_soc');
fprintf(fid,'\n');
fprintf(fid,'CAT N=grade S=1000 E=1000 D=max_grade');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a1 S=1001 E=1001 D=accel_time1');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a2 S=1002 E=1002 D=accel_time2');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a3 S=1003 E=1003 D=accel_time3');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a4 S=1004 E=1004 D=dist_in_time');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a5 S=1005 E=1005 D=time_in_dist');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a6 S=1004 E=1004 D=max_accel');
fprintf(fid,'\n');
fprintf(fid,'CAT N=a7 S=1005 E=1005 D=max_speed');
fprintf(fid,'\n');
fprintf(fid,'CAT N=mass S=1006 E=1006 D=veh_mass');
fprintf(fid,'\n');
fprintf(fid,'CAT N=fe S=1007 E=1007 D=mpgge');
fprintf(fid,'\n');
if ~strcmp(drivetrain,'ev')&vinf.autosize.dv(1)
   fprintf(fid,['VAR N=fcts L=0.1 I=',num2str(vinf.autosize.cv.fc(1)),'']);
   fprintf(fid,'\n');
end
if ~strcmp(drivetrain,'conventional')&vinf.autosize.dv(2)
   %fprintf(fid,['VAR N=essmn L=',num2str(round(evalin('base','mc_min_volts\ess_min_volts'))),' I=',num2str(vinf.autosize.cv.ess(1)),' S=-1']);
   fprintf(fid,['VAR N=essmn L=',num2str(round(evalin('base','mc_min_volts\ess_min_volts'))),' I=',num2str(vinf.autosize.cv.ess(1)),'']);
   fprintf(fid,'\n');
end
if ~strcmp(drivetrain,'conventional')&vinf.autosize.dv(3)
   fprintf(fid,['VAR N=mcts L=0.1 I=',num2str(vinf.autosize.cv.mc(1)),'']);
   fprintf(fid,'\n');
end
if vinf.autosize.constraints(1)
   fprintf(fid,['CON N=grade L=',num2str(vinf.grade_test.param.grade),'']);
   fprintf(fid,'\n');
end
if vinf.autosize.constraints(2)
   if vinf.accel_test.param.active(3)
      fprintf(fid,['CON N=a1 U=',num2str(vinf.accel_test.param.accel_time1_con),'']);
      fprintf(fid,'\n');
   end
   if vinf.accel_test.param.active(4)
      fprintf(fid,['CON N=a2 U=',num2str(vinf.accel_test.param.accel_time2_con),'']);
      fprintf(fid,'\n');
   end
   if vinf.accel_test.param.active(5)
      fprintf(fid,['CON N=a3 U=',num2str(vinf.accel_test.param.accel_time3_con),'']);
      fprintf(fid,'\n');
   end
   if vinf.accel_test.param.active(6)
      fprintf(fid,['CON N=a4 U=',num2str(vinf.accel_test.param.dist_in_time_con),'']);
      fprintf(fid,'\n');
   end
   if vinf.accel_test.param.active(7)
      fprintf(fid,['CON N=a5 U=',num2str(vinf.accel_test.param.time_in_dist_con),'']);
      fprintf(fid,'\n');
   end 
   if vinf.accel_test.param.active(8)
      fprintf(fid,['CON N=a6 U=',num2str(vinf.accel_test.param.max_rate_con),'']);
      fprintf(fid,'\n');
   end
   if vinf.accel_test.param.active(9)
      fprintf(fid,['CON N=a7 U=',num2str(vinf.accel_test.param.max_speed_con),'']);
      fprintf(fid,'\n');
   end
end
if vinf.autosize.obj(1)
   if ~strcmp(drivetrain,'ev')&vinf.autosize.dv(1)
      fprintf(fid,'OBJ N=fcts');
      fprintf(fid,'\n');
   end
   if ~strcmp(drivetrain,'conventional')&vinf.autosize.dv(2)
      fprintf(fid,'OBJ N=essmn');
      fprintf(fid,'\n');
   end
   if ~strcmp(drivetrain,'conventional')&vinf.autosize.dv(3)
      fprintf(fid,'OBJ N=mcts');
      fprintf(fid,'\n');
   end
end
if vinf.autosize.obj(2)
   fprintf(fid,'OBJ N=mass');
   fprintf(fid,'\n');
end
if vinf.autosize.obj(3)
   fprintf(fid,'OBJ N=fe M=MA' );
   fprintf(fid,'\n');
end
if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.fc(1)),',',num2str(vinf.autosize.cv.ess(1)),',',num2str(vinf.autosize.cv.mc(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(min(vinf.autosize.cv.fc(2:end))),',',num2str(max(vinf.autosize.cv.ess(2:end))),',',num2str(max(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(max(vinf.autosize.cv.fc(2:end))),',',num2str(min(vinf.autosize.cv.ess(2:end))),',',num2str(min(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(2)&vinf.autosize.dv(3)
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.ess(1)),',',num2str(vinf.autosize.cv.mc(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(min(vinf.autosize.cv.ess(2:end))),',',num2str(min(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(max(vinf.autosize.cv.ess(2:end))),',',num2str(max(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(1)&vinf.autosize.dv(3)
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.fc(1)),',',num2str(vinf.autosize.cv.mc(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(min(vinf.autosize.cv.fc(2:end))),',',num2str(min(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(max(vinf.autosize.cv.fc(2:end))),',',num2str(max(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(1)&vinf.autosize.dv(2)
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.fc(1)),',',num2str(vinf.autosize.cv.ess(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(min(vinf.autosize.cv.fc(2:end))),',',num2str(max(vinf.autosize.cv.ess(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(max(vinf.autosize.cv.fc(2:end))),',',num2str(min(vinf.autosize.cv.ess(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(1)==1
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.fc(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(min(vinf.autosize.cv.fc(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(max(vinf.autosize.cv.fc(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(2)==1
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.ess(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(max(vinf.autosize.cv.ess(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(min(vinf.autosize.cv.ess(2:end))),'']);
   fprintf(fid,'\n');
elseif vinf.autosize.dv(3)==1
   fprintf(fid,['CV I=1 V=',num2str(vinf.autosize.cv.mc(1)),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=2 V=',num2str(max(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
   fprintf(fid,['CV I=3 V=',num2str(min(vinf.autosize.cv.mc(2:end))),'']);
   fprintf(fid,'\n');
end

val=max([[vinf.accel_test.param.accel_time1_con*vinf.accel_test.param.active(3),...
		vinf.accel_test.param.accel_time2_con*vinf.accel_test.param.active(4),...
		vinf.accel_test.param.accel_time3_con*vinf.accel_test.param.active(5),...
      vinf.accel_test.param.dist_in_time_con*vinf.accel_test.param.active(6),...
	  vinf.accel_test.param.time_in_dist_con*vinf.accel_test.param.active(7),...
      vinf.accel_test.param.max_accel_con*vinf.accel_test.param.active(8),...
	  vinf.accel_test.param.max_speed_con*vinf.accel_test.param.active(9)]*vinf.autosize.constraints(1),...
 vinf.grade_test.param.grade*vinf.autosize.constraints(1)]);

val=floor((val+0.05)/val*10000)/10000-1;

%fprintf(fid,['DOT METHOD=',num2str(vinf.autosize.params.method),' FDCH=0.05 FDCHM=0.005 CTMIN=0.0005']);
%fprintf(fid,['DOT METHOD=',num2str(vinf.autosize.params.method),' FDCH=0.05 FDCHM=0.005 CTMIN=0.002']);
%fprintf(fid,['DOT METHOD=',num2str(vinf.autosize.params.method),' FDCH=0.05 FDCHM=0.005 CTMIN=',num2str(val),'']);
fprintf(fid,['DOT METHOD=',num2str(vinf.autosize.params.method),' FDCH=0.005 FDCHM=0.001 CTMIN=',num2str(val),'']);
%fprintf(fid,['DOT METHOD=',num2str(vinf.autosize.params.method),' FDCH=0.005 FDCHM=0.001 DABOBJ=0.001 CTMIN=',num2str(val),'']);
% Comments on DOT parameters
% CTMIN - minimum constraint tolerance, allows the constraint to be violated by this value (default 0.003)
% FDCH - relative finite difference step size when calculating gradients (dv*fdch = step size) (default 0.001)
% FDCHM - absolute finite difference step size when calculating gradients (smallest absolute step size) (default 0.0001)
% DABOBJ - absolute convergence tolerance abs(obj(i)-obj(i-1))<DABOBJ (default max[0.001*obj(0),0.0001])

fprintf(fid,'\n');
fprintf(fid,'END');
fprintf(fid,'\n');

fclose(fid);

disp('VisualDOC *.dat file created.')

return

% Revision History
% 3/26/99 ss: added JTMAX=10 to DOT_METHOD line ; default is 50
% 9/15/99:tm modified ess module num assignment for new ess_soc matrix
% 10/25/99:tm modified dot parameters to improve convergence - all based on desired level of accuracy
% 1/29/01:tm updated parameter names for use with new acceleration and grade tests
% 1/31/01:tm changed ess_module_num from discrete to a continous variable
