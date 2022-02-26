function my_string = gr_per_dev_local_txt(tm)
% returns string format of gr_per_dev_local()

[grDiff, when, t_index] = gr_per_dev_local(tm);
my_string = [' Greatest percent difference is ', num2str(grDiff*100), '% at ', num2str(when), ' seconds, (array index ', num2str(t_index),')'];