function my_string = gr_per_dev_txt(tm)
% returns gr_per_dev() in text format

[grDiff, when, t_index] = gr_per_dev(tm);
my_string = [' Greatest percent difference based on max. cycle speed requested is ', num2str(grDiff*100), '% at ', num2str(when), ' seconds, (array index ', num2str(t_index),')'];