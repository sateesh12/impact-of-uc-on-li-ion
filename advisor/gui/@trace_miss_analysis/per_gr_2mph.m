function result = per_gr_2mph(tm)
% returns the percent (as a fraction between 0 and 1) of total cycle 
% ...time where the trace miss is greater than 2 mph
% results figured as sum(     ( abs(requested_speed-actual_speed)>2.0 ).* del_time  )/total_time;

del_time = conv([0.5 0.5], diff(tm.time)); % the "delta time" represented by each 
% ...data point--del time is symmetric between the given data point and its two neighbors (with end points only
% ...having one neighbor and thus usually only 1/2 of a delta time). For instance
% ...if we have 4 data points sampled at 0 0.5 2 and 4 seconds, the delta times would be
% ...0.25, 0.25+0.75=1, 0.75+1=1.75, and 1
total_time = tm.time(end); % total elapsed time on the cycle
result = sum(     ( abs(tm.spd_req-tm.spd_act)>2.0 ).* del_time  )/total_time;
