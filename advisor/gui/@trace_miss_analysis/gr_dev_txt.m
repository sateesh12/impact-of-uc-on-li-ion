function my_string = gr_dev_txt( tm )
% Returns the greatest deviation between actual and requested speeds and the elapsed time when this event occurred
% results figured as max(abs(actual_speed-requested_speed))

[grDiff, when, t_index] = gr_dev(tm);
my_string = [' Greatest absolute difference is ', num2str(grDiff), ' mph at ', num2str(when), ' seconds, (array index ', num2str(t_index),')'];