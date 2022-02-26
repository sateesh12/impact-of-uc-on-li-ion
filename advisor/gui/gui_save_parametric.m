function fig = gui_save_parametric()

global vinf

[newfile, newpath] = uiputfile('*.txt', 'Save As');
fullname=[newpath,newfile];
fid = fopen(fullname,'wt');

fprintf(fid,['%% ',newfile,'  ADVISOR Parametric Results File Created: ',datestr(now,0),'\n\n']);
fprintf(fid,'Parametric Variables \n\n');
fprintf(fid,'Name\t\tLow\tHigh\t#Points\n');
for i=1:vinf.parametric.number_variables
   fprintf(fid,'%s\t\t',vinf.parametric.var{i});
   fprintf(fid,'%.2e\t',vinf.parametric.low(i));
   fprintf(fid,'%.2e\t',vinf.parametric.high(i));
   fprintf(fid,'%d\t\n',vinf.parametric.number(i));
end
fprintf(fid,'\nU.S. units and metric units recorded.');
fprintf(fid,'\nFirst variable varies in the vertical direction and the second in the horizontal\n');

%create list of variable names
var_name=char('MilesPG','MPGGE','DeltaSOC','NOx','CO','HC','PM');
if strcmp(vinf.acceleration.run,'on')
   var_name=char(var_name,'Accel_0_60','Accel_40_60','Accel_0_85','Feet_5sec','Max_accel_ft_s2');
end
if strcmp(vinf.gradeability.run,'on')
   var_name=char(var_name,['Grade_',num2str(vinf.gradeability.speed),'mph']);
end

var_name=char(var_name,'Litersp100km','LpkmGE','NOx_gpkm','CO_gpkm','HC_gpkm','PM_gpkm');
if strcmp(vinf.acceleration.run,'on')
   var_name=char(var_name,'Accel_0_97','Accel_64_97','Accel_0_137','Meters_5sec','Max_accel_m_s2');
end
if strcmp(vinf.gradeability.run,'on')
   var_name=char(var_name,['Grade_',num2str(round(vinf.gradeability.speed/0.62137)),'kph']);
end

for k=1:max(size(var_name(:,1))) %loop through all variable names
   trimname=deblank(var_name(k,:)); %delete blanks from character array name
   
   if evalin('base',['exist(''',trimname,''')'])
      var=evalin('base',['eval(''',trimname,''')']);%evaluate the variable of choice
   
      fprintf(fid,['\n\n',trimname,'\n']);	%print variable name
      if vinf.parametric.number_variables==3   %3 variable case   
         for i1=1:vinf.parametric.number(1) 
            for i3=0:vinf.parametric.number(3)-1
               for i2=0:vinf.parametric.number(2)-1
                  fprintf(fid,'%.4f\t',var(i1+vinf.parametric.number(1)*i2+vinf.parametric.number(1)*vinf.parametric.number(2)*i3));
               end
               fprintf(fid,'\t');
            end
            fprintf(fid,'\n');
         end
      elseif vinf.parametric.number_variables==2	%2 variable case
         for i1=1:vinf.parametric.number(1) 
            for i2=0:vinf.parametric.number(2)-1
               fprintf(fid,'%.4f\t',var(i1+vinf.parametric.number(1)*i2));
            end
            fprintf(fid,'\n');
         end
      elseif vinf.parametric.number_variables==1	%1 variable case
         for i1=1:vinf.parametric.number(1) 
            fprintf(fid,'%.4f\t',var(i1));
            fprintf(fid,'\n');
         end
      end
   end
end

fclose(fid);

%revision history
%12/01/98 vh: changed vinf.gradeability to vinf.gradeability.run
%09/20/99: vhj updated for metric variables, grade, PM