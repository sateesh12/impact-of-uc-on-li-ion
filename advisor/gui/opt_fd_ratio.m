function answer=opt_fd_ratio(varargin)
%
% adjust final drive ratio to allow max speed with current 
% motor/controller and gearbox if necessary accounting for 10% wheel slip while
% matching the peak power output to the desired gradeability speed
% INPUTS:
% 		grade_spd	- desired gradeability speed [optional]
%		max_spd 		- desired top speed [optional]
%
% all inputs must be entered as pairs in the form ParameterName, ParameterValue,...
%

answer=[];

if isempty(varargin)|mod(length(varargin),2)
   disp('Error: Unmatched or no input arguements')
else
   
   global vinf
   
   % get necessary variable values from workspace
   wh_radius=evalin('base','wh_radius');
   gb_ratio=evalin('base','gb_ratio');
   fd_ratio=evalin('base','fd_ratio');
   
   if strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')
      map_spd=evalin('base','mc_map_spd*mc_spd_scale');
      max_trq=evalin('base','mc_max_trq');
   else
      map_spd=evalin('base','fc_map_spd*fc_spd_scale');
      max_trq=evalin('base','fc_max_trq');
   end
   
   % assign input parameters
   for i=1:2:length(varargin)-1
      eval([varargin{i},'=',num2str(varargin{i+1}),';']);
   end
   
   if exist('max_spd')
      % calculate the minimum fd ratio to meet the max speed constraint
      fd_ratio_max=max(map_spd)/min(gb_ratio)/(1.05*max_spd*0.447/wh_radius);
   else
      fd_ratio_max=inf;
   end
   
   if exist('grade_spd')
      
      if fd_ratio_max~=inf;
         fd_ratio_new=fd_ratio_max;
      else
         fd_ratio_new=fd_ratio;
      end
      
      
      % find speed corresponding to the max power point
      max_pwr_index=min(find((map_spd.*max_trq)==max(map_spd.*max_trq)));
      
      if max_pwr_index==length(map_spd)
         factor=0.98;
      else 
         factor=1.0;
      end
      
      % calculate the possible component speeds for each gear ratio
      spds=grade_spd*0.447/wh_radius*fd_ratio_new.*gb_ratio;
      
      % find gear ratio above and below max power point
      gear_lo_index=max(find(spds>=map_spd(max_pwr_index)));
      gear_hi_index=min(find(spds<=map_spd(max_pwr_index)));
      
      if isempty(gear_lo_index)
         gear_lo_index=1;
      end
      if isempty(gear_hi_index)
         gear_hi_index=length(gb_ratio);
      end
      
      % find speeds associated with selected gear ratios
      lo_spd=grade_spd*0.447/wh_radius*fd_ratio_new*gb_ratio(gear_lo_index);
      hi_spd=grade_spd*0.447/wh_radius*fd_ratio_new*gb_ratio(gear_hi_index);
      
      % find final drive ratio that will shift operation to max power point 
      fd_ratio_lo=fd_ratio_new*map_spd(max_pwr_index)*factor/lo_spd;
      fd_ratio_hi=fd_ratio_new*map_spd(max_pwr_index)*factor/hi_spd;
      
      % limit to final drive ratio that also provides top speed requirement
      fd_ratio=max([fd_ratio_lo fd_ratio_hi].*([fd_ratio_lo fd_ratio_hi]<=fd_ratio_max));
      
      if fd_ratio==0
         fd_ratio=fd_ratio_max;
      end
      
   end
   
   if ~exist('fd_ratio_lo')&~exist('fd_ratio_hi')
      fd_ratio=fd_ratio_max;      
   end
   
   answer=fd_ratio;
   top_spd=max(map_spd)/min(gb_ratio)/fd_ratio/(0.447/wh_radius);
   
end

return

% revision history
% 5/19/00:tm file created
% 5/19/00:tm added 1.05* to fd_ratio_max calc to prevent use of absolute max map speed - required for slip effects
% 8/21/00:tm added min(..) to the find max pwr (line 68) to prevent errors when two equal max power points exist
%
