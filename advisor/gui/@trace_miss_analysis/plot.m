function plot(tm)
% Plots a custom figure depicting requested speeds, achieved speeds, trace+/- absolute average difference, 
% point of greatest deviation, point of greatest percent deviation based on max. requested cycle time, and
% point of greatest percent deviation based on local time

figure, plot(tm.time, tm.spd_req, 'b-', tm.time, tm.spd_act, 'g-'); % 1, 2
hold on;

aad = abs_ave_diff(tm); 
[gd, tgd, tigd] = gr_dev(tm); % return values: value (greatest deviation), time, time_index  
[gpd, tgpd, tigpd] = gr_per_dev(tm); % return values: value (greatest deviation), time, time_index
[gpdl, tgpdl, tigpdl] = gr_per_dev_local(tm); % return values: value (greatest deviation), time, time_index
pg2mph = per_gr_2mph(tm); % return values: value (greatest deviation), time, time_index

plot(tm.time, tm.spd_req+aad, 'k-',tm.time, tm.spd_req-aad, 'k-'); % 3, 4
plot(tgd, tm.spd_req(tigd), 'ro'); % 5
plot(tgpd, tm.spd_req(tigpd), 'ms'); % 6
plot(tgpdl, tm.spd_req(tigpdl), 'c*'); % 7
xlabel('time (seconds)'); ylabel('speed (mph)');
legend('Requested Speed (mph)', ... % 1
   'Achieved Speed (mph)',... % 2
   'Trace Plus Absolute Average Difference',... % 3
   'Trace Minus Absolute Average Difference',... % 4
   'Greatest Deviation', ... % 5
   'Greatest Percent Deviation Based on Max. Cycle Time', ... % 6
   'Greatest Percent Deviation', ... % 7
   0);