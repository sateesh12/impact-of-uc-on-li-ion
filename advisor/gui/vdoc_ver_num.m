function [version_number, demo_version]=vdoc_ver_num(vdoc_path)
% this function will determine what version of vdoc_matlab.exe is currently in the matlab path
% and whether it is a demo verson or full version

% store the current directory and move to the optimization directory
current_dir=evalin('base','pwd');
advisor_path=strrep(which('advisor.m'),'\advisor.m','');
opt_runs_path=[advisor_path,'\optimization'];
evalin('base',['cd ''',opt_runs_path,'''']);

state=0;
version_number=-1;
demo_version=-1;

%eval(['[state,msg]=dos(''vdoc_matlab.exe ver_test.dat'');'])
%eval(['[state,msg]=dos(''vdoc_matlab.exe -version ver_test'');'])
state=execute('vdoc_matlab.exe -version ver_test',[matlabroot,'\bin']);

%if ~state&findstr(msg,'Closed')
if ~state
   % open the file
   fid=fopen('ver_test.out','r');
   if fid>0
      demo_version=0;
      while ~feof(fid)
         str=fgetl(fid);
         limited=findstr(str,'LIMITED');
         if limited
            demo_version=1;
            found=[];
         else
            found=findstr(str,'VERSION');
         end
         if ~isempty(found)
            version_number=str2num(str(max(found+7):end));
            break  
         end
      end
      % close the file
      fclose(fid);
   end
   
   % remove ver_test files
   if exist('ver_test.res')
      fid=fopen('ver_test.res','w');
      fprintf(fid,'\n');
      fclose(fid);
   end
   if exist('ver_test.out')
      fid=fopen('ver_test.out','w');
      fprintf(fid,'\n');
      fclose(fid);
   end
   %eval(['!del ver_test.res'])
   %eval(['!del ver_test.out'])
   %state=execute('del ver_test.out');
   %state=execute('del ver_test.res');
end

% return to previous directory
evalin('base',['cd ''',current_dir,''''])

% tm:7/14/00 removed \gui from advisor path information due to updated path structure