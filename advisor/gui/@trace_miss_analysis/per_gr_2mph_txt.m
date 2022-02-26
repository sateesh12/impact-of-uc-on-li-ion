function my_string = per_gr_2mph_txt(tm)
% returns a string display for per_gr_2mph()

my_string = [' Percent of time with trace miss greater than 2 mph (absolute): ', num2str(per_gr_2mph(tm)*100), '%'];