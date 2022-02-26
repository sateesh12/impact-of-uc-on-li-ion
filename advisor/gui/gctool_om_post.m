function resp=gctool_post(advisor_path,name,inputs)
% scan the GCtool output file for results
% resp=[power_available,fuel_use,emis info]
%

% print parameter for debugging
debug=0; % 1==> writes additional output to command window, 0==> no debug printing

if evalin('base',['exist(''',advisor_path,'\gctool\',name,'.out'')'])
   
   fid=fopen([advisor_path,'\gctool\',name,'.out'],'r');
   
   % scan results file for variable updates
   while ~feof(fid)
      str=fgetl(fid);
      advisor_results_section=findstr(str,'ADVISOR')&findstr(str,'RESULTS'); 
      if advisor_results_section
         loop=1;
         while loop
            str=fgetl(fid);
            if findstr(str,'fuel_m')
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               fuel_flow=str2num(str(x1:x2));
            elseif findstr(str,'pwr_out_a')
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               power_net=str2num(str(x1:x2));
            end
            if exist('fuel_flow')&exist('power_net')
               loop=0;
            end
         end
      end
   end
   
   fclose(fid);
end

% debug print statements
if debug
   %disp(' ')
   % add desired print statements here
end

emis=[0 0 0 0 0 0]; 
fc_cond=[0 0 0];

% build response vector
resp=[power_net,emis*1000,fc_cond,fuel_flow*1000];

return

% revision history
% 9/8/99:tm file created

