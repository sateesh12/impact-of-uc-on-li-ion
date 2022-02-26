function result = abs_ave_diff(tm)
% returns the absolute average difference over a trace miss
% result figured as mean(abs(actual_speed-requested_speed))

abs_diff = abs(tm.spd_act-tm.spd_req);
result = mean(abs_diff);
