% ADVISOR file:  fuzzy_target_compute.m
%
% Notes:
% This file is run if either of the 2 Fuzzy Logic modes is selected 
% and the "RUN" button is pressed in the 2nd input screen.
% This file is called from gui_run_simulation file.
% 
% Created on: 21-July-2001
% By:  AR, NREL, arun_rajagopalan@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch(cs_fuzzy_fuel_mode)
case 0
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % SET IC Engine operation parameters for FUZZY LOGIC Controller
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % code to calculate the peak efficiency line of the ICE
   % First, calculate an efficiency matrix for the ICE
   
   
   flc_eff_map=zeros(size(fc_fuel_map));
   for f1=1:length(fc_map_spd)
      for f2=1:length(fc_map_trq)
         flc_eff_map(f1,f2)=(fc_map_spd(f1)*fc_spd_scale*fc_map_trq(f2)*fc_trq_scale)/(fc_fuel_map(f1,f2)*fc_fuel_lhv);
      end
   end
   
   % [eff_value,eff_index] = max(flc_eff_map,[],2);
   [eff_value,eff_index] = max(flc_eff_map,[],2);
   clear flc_target;
   flc_target=fc_map_trq(eff_index);
   flc_size=size(fc_eff_map);
   
   % To limit to max torque envelope
   for i=1:flc_size(1)
      if flc_target(i) > fc_max_trq(i)
         flc_target(i) = fc_max_trq(i);
      end
   end
   
case 1
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % SET IC Engine operation parameters for FUZZY LOGIC Controller
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % code for determining x g/s fuel usage limiting line
   
   clear flc_temp1;
   flc_fuel_size=size(fc_fuel_map);
   flc_temp1=zeros(1,flc_fuel_size(1));
   clear flc_target;
   for i=1:flc_fuel_size(1)   
      for j=1:flc_fuel_size(2)
         if fc_fuel_map(i,j) <= cs_fuzzy_fuel_limit 
            flc_temp1(i)=j;
         end
      end
      if flc_temp1(i)==0
         flc_temp1(i)=1;
      end
      flc_target(i)=fc_map_trq(flc_temp1(i));
      if flc_target(i) > fc_max_trq(i)
         flc_target(i) = fc_max_trq(i);
      end
   end
end

% End of computation for Fuzzy Logic Algorithm
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/21/01: ar created this file
% 8/20/01: ar changed internal variable names to avoid conflict
   
   