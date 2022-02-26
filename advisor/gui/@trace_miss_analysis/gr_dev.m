function [ gd, t, t_index ] = gr_dev( tm )
% Returns the greatest deviation between actual and requested speeds and the elapsed time when this event occurred
% results figured as max(abs(actual_speed-requested_speed))

absDeviation = abs(tm.spd_act-tm.spd_req); % absolute deviation

[ gd, t_index ] = max( absDeviation );

t = tm.time(t_index);