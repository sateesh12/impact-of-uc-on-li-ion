function error_code=vdoc_cs_doe_post(name)
% scan the optimization output files for results 

% make vinf global 
global vinf

% initialize error_code
error_code=0; % no errors

if evalin('base',['exist(''',name,'_DOE.ddb'')'])
   fid=fopen([name,'_DOE.ddb'],'r');
   if fid
      % scan results file for candidate variables and candidate responses
      i=0;
      loop=1;
      while ~feof(fid)&loop
         str=fgetl(fid);
         mat=str2num(str);
         i=i+1;
         if mat(1)==i
            vinf.control_strategy.cv{i}=mat(2:end);
         else
            loop=0;
         end
      end
      vinf.control_strategy.cr{1}=mat(2:end);
      for i=2:length(vinf.control_strategy.cv)
         str=fgetl(fid);
         mat=str2num(str);
         vinf.control_strategy.cr{i}=mat(2:end);
      end
      
      % plot results of doe
      evalin('base','load(''VDOC_CS_OUT'')')
      figure
      set(gcf,'NumberTitle','off','Name','VisualDOC Control Stategy Optimization Summary')
      vdoc_cs_doe_plot
      
   else
      disp(['Unable to open file ',name,'_DOE.ddb'])
      error_code=1;
   end
else
   disp(['Unable to find file ',name,'_DOE.ddb'])
   error_code=1;
end

