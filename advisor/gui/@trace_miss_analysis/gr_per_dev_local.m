function [ gpd, t, t_index ] = gr_per_dev_local(tm)
% greatest percent deviation between requested and achieved speeds as well as the time of occurance. 
% percentage difference is figured as abs(v_actual - v_requested)/v_requested
% RETURNS [ greatest_percent_deviation, time_of_greatest_percent_deviation ]

percentDeviation=[];
for i=1:max(size(tm.spd_req))
   if tm.spd_req(i)~=0
      percentDeviation(i) = abs(tm.spd_act(i)-tm.spd_req(i))./tm.spd_req(i); % percentage deviation
   else
      percentDeviation(i) = 0;
   end
end

[ gpd, t_index ] = max( percentDeviation );

t = tm.time(t_index);