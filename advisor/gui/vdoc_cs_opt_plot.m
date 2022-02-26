function vdoc_cs_opt_plot
% creates summary plot for optimization

% make vinf global
global vinf

% objective function
evalin('base','plot(counter_log,obj_log,''rx-'',counter_log,ones(size(counter_log)),''b--'')')
ylabel('Normalized Objective Function')
xlabel('Design Iteration')
evalin('base','drawnow')

return
