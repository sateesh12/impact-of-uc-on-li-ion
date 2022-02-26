function build_dat(name)
% create *.dat file for optimization

global vinf;
drivetrain=vinf.drivetrain.name;

% calculate the minimum and maximum number of iterations
num_interactions=0;
for i=1:sum(vinf.control_strategy.dv.active)-1
   num_interactions=num_interactions+i;
end
min_iter=1+2*sum(vinf.control_strategy.dv.active)+num_interactions;
max_iter=3*min_iter;
min_iter=max(3*sum(vinf.control_strategy.dv.active),min_iter-length(vinf.control_strategy.cv));

fid=fopen([name,'_OPT.DAT'],'w');

fprintf(fid,'TITLE Control Strategy Optimization Using VisualDOC');
fprintf(fid,'\n');
fprintf(fid,'JOB T=AP P=1'); % use response surfaces
fprintf(fid,'\n');
fprintf(fid,['APP L=',num2str(min_iter),' M=',num2str(max_iter)]); 
%fprintf(fid,['APP L=',num2str(1),' M=',num2str(max_iter)]); 
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
      fprintf(fid,['VAR N=cs',num2str(i),' I=',num2str(vinf.control_strategy.dv.init_cond(i)),' L=',num2str(vinf.control_strategy.dv.lower_bound(i)),' U=',num2str(vinf.control_strategy.dv.upper_bound(i))]);
      fprintf(fid,'\n');
   end
end

% active constraints
if vinf.autosize.constraints(1)
   fprintf(fid,['CON N=grade L=',num2str(vinf.autosize.con.grade.goal.grade),'']);
   fprintf(fid,'\n');
end
if vinf.autosize.constraints(2)
   if vinf.autosize.con.accel.goal.t0_18>0
      fprintf(fid,['CON N=a0_18 U=',num2str(vinf.autosize.con.accel.goal.t0_18),'']);
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_30>0
      fprintf(fid,['CON N=a0_30 U=',num2str(vinf.autosize.con.accel.goal.t0_30),'']);
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_60>0
      fprintf(fid,['CON N=a0_60 U=',num2str(vinf.autosize.con.accel.goal.t0_60),'']);
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t40_60>0
      fprintf(fid,['CON N=a40_60 U=',num2str(vinf.autosize.con.accel.goal.t40_60),'']);
      fprintf(fid,'\n');
   end
   if vinf.autosize.con.accel.goal.t0_85>0
      fprintf(fid,['CON N=a0_85 U=',num2str(vinf.autosize.con.accel.goal.t0_85),'']);
      fprintf(fid,'\n');
   end
end

% misc
fprintf(fid,['CON N=dsoc L=0.05 U=1.0']);
fprintf(fid,'\n');
fprintf(fid,['CON N=trace U=0.9']);
fprintf(fid,'\n');
fprintf(fid,['CON N=soc U=0.9']);
fprintf(fid,'\n');

% active constraints 
if ~vinf.control_strategy.obj.active(1)&vinf.control_strategy.con.value(1)>0
   fprintf(fid,['CON N=co U=',num2str(vinf.control_strategy.con.value(1)),'']);
   fprintf(fid,'\n');
else
   fprintf(fid,['CON N=co U=1000']);
   fprintf(fid,'\n');
end
if ~vinf.control_strategy.obj.active(2)&vinf.control_strategy.con.value(2)>0
   fprintf(fid,['CON N=hc U=',num2str(vinf.control_strategy.con.value(2)),'']);
   fprintf(fid,'\n');
else
   fprintf(fid,['CON N=hc U=1000']);
   fprintf(fid,'\n');
end
if ~vinf.control_strategy.obj.active(3)&vinf.control_strategy.con.value(3)>0
   fprintf(fid,['CON N=nox U=',num2str(vinf.control_strategy.con.value(3)),'']);
   fprintf(fid,'\n');
else
   fprintf(fid,['CON N=nox U=1000']);
   fprintf(fid,'\n');
end
if ~vinf.control_strategy.obj.active(4)&vinf.control_strategy.con.value(4)>0
   fprintf(fid,['CON N=pm U=',num2str(vinf.control_strategy.con.value(4)),'']);
   fprintf(fid,'\n');
else
   fprintf(fid,['CON N=pm U=1000']);
   fprintf(fid,'\n');
end
if ~vinf.control_strategy.obj.active(5)&vinf.control_strategy.con.value(5)>0
   fprintf(fid,['CON N=fe L=',num2str(vinf.control_strategy.con.value(5)),'']);
   fprintf(fid,'\n');
else
   fprintf(fid,['CON N=fe L=0']);
   fprintf(fid,'\n');
end

% active objectives 
fprintf(fid,'OBJ N=obj' );
fprintf(fid,'\n');

% candidate values and candidate responses
for i=1:length(vinf.control_strategy.cv)
   % candidate values
   str=['CV I=',num2str(i),' V= '];
   % include only those candidate values that are currently active
   for y=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(y)
         str=[str,' ',num2str(vinf.control_strategy.cv{i}(y))];
      end
   end
   % limit line length to 80 characters
   n=1;
   str_array={};
   while length(str)>80
      space_index=findstr(str,' ');   
      cut_index=max(find(space_index<=80));
      str_array{n}=str(1:space_index(cut_index));
      str=['& ',str(space_index(cut_index)+1:end)];
      n=n+1;
   end
   str_array{n}=str(1:end);
   % print string array to file
   for c=1:length(str_array)
      fprintf(fid,str_array{c});
      fprintf(fid,'\n');
   end
   % candidate responses
   str=['CR I=',num2str(i),' V= '];
   % determine starting point for user-modifiable responses
   offset=vinf.autosize.constraints(1); % grade constraint active
   if vinf.autosize.constraints(2) % accel constraint active
      offset=offset+sum([vinf.autosize.con.accel.goal.t0_18 ...
            vinf.autosize.con.accel.goal.t0_30 ...
            vinf.autosize.con.accel.goal.t0_60 ...
            vinf.autosize.con.accel.goal.t40_60 ...
            vinf.autosize.con.accel.goal.t0_85]>0); % which accel constraints active 
   end
   offset=offset+3; % dsoc, missed trace missed deltasoc -- these are always active
   % include the active constraints up to this point
   str=[str,' ',num2str(vinf.control_strategy.cr{i}(1:offset))]; 
   % include the user modifiable obj/con
   for y=1:length(vinf.control_strategy.obj.active)
      %if ~vinf.control_strategy.obj.active(y)
         str=[str,' ',num2str(vinf.control_strategy.cr{i}(offset+y))];
      %end
   end
   % include the normalized objective function
   str=[str,' ',num2str(vinf.control_strategy.cr{i}(offset+y+1))];
   % limit string length to 80 characters
   n=1;
   str_array={};
   while length(str)>80
      space_index=findstr(str,' ');   
      cut_index=max(find(space_index<=80));
      str_array{n}=str(1:space_index(cut_index));
      str=['& ',str(space_index(cut_index)+1:end)];
      n=n+1;
   end
   str_array{n}=str(1:end);
   % write string array to file
   for c=1:length(str_array)
      fprintf(fid,str_array{c});
      fprintf(fid,'\n');
   end
end
% include the current initial conditions as the starting point
str=['CV I=0 V= '];
% include only those candidate values that are currently active
for y=1:length(vinf.control_strategy.dv.active)
   if vinf.control_strategy.dv.active(y)
      str=[str,' ',num2str(vinf.control_strategy.dv.init_cond(y))];
   end
end
% write string to file
fprintf(fid,str);
fprintf(fid,'\n');

val=max([vinf.autosize.con.accel.goal.t0_18 vinf.autosize.con.accel.goal.t0_30 vinf.autosize.con.accel.goal.t0_60...
      vinf.autosize.con.accel.goal.t0_85 vinf.autosize.con.accel.goal.t40_60 vinf.autosize.con.grade.goal.grade]);
%val=max([val (~vinf.control_strategy.obj.active).*vinf.control_strategy.con.value])
val=floor((val+0.05)/val*10000)/10000-1;

%fprintf(fid,['DOT METHOD=3 FDCH=0.005 FDCHM=0.001 DABOBJ=0.001 CTMIN=',num2str(val),'']);
fprintf(fid,['DOT METHOD=3 FDCH=0.005 FDCHM=0.001 CTMIN=',num2str(val),'']);
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
% 8/17/99:tm file created from opt_dat.m
% 10/25/99:tm based minimum number of iterations on the difference
%             between the number of doe points and the length of vinf.control_strategy.cv
% 10/25/99:tm modified dot parameter definitions to be based on desired level of accuracy
% 10/29/99:tm changed the min_iter from 3 to 3* the number of active variables
%
