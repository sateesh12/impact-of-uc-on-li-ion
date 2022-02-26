function [ gpd, t, t_index ] = gr_per_dev(tm)
% greatest percent deviation between requested and achieved speeds as well as the time of occurance. 
% percentage difference is figured as abs(v_actual - v_requested)/v_max_requested_over_cycle
% RETURNS [ greatest_percent_deviation, time_of_greatest_percent_deviation ]

percentDeviation = abs(tm.spd_act-tm.spd_req)/max(tm.spd_req); % percentage deviation, method 2

[ gpd, t_index ] = max( percentDeviation );

t = tm.time(t_index);