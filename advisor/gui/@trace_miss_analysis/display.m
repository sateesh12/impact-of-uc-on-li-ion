function display(tm)

disp(' ');
disp('Trace Miss Analysis');
disp([' Number of data points: ', num2str(max(size(tm.time)))]);
disp([' Absolute average difference: ', num2str(abs_ave_diff(tm)), ' mph']);
disp([' Percent of time with trace miss greater than 2 mph (absolute): ', num2str(per_gr_2mph(tm)*100), '%']);
[grDiff, when] = gr_per_dev(tm);
disp([' Greatest percent difference based on max. cycle speed requested is ', num2str(grDiff*100), '% at ', num2str(when), ' seconds']);
[grDiff, when] = gr_per_dev_local(tm);
disp([' Greatest percent difference is ', num2str(grDiff*100), '% at ', num2str(when), ' seconds']);
[grDiff, when] = gr_dev(tm);
disp([' Greatest absolute difference is ', num2str(grDiff), ' mph at ', num2str(when), ' seconds']);
