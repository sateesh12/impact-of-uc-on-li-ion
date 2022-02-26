function vdoc_cs_doe_plot
% creates summary plot for DOE

% make vinf global
global vinf

% plot design variables activity
lb=[];
ub=[];
active=vinf.control_strategy.dv.active;
for i=1:length(active)
   if active(i)
      lb=[lb vinf.control_strategy.dv.lower_bound(i)];
      ub=[ub vinf.control_strategy.dv.upper_bound(i)];
   end
end
x=evalin('base','dv_log');
m=2./(ub-lb); % slope of the line
m=meshgrid(m,x(:,1));
b=(2*lb./(lb-ub))-1; % y-intercept
b=meshgrid(b,x(:,1));
y=m.*x+b; % y=1 when x=ub, y=-1 when x=lb
linetype={'x-','o-','s-','^-','v-','*-'};
linecolor={'r','g','c','m','k'};
str='plot(';
%for i=1:length(vinf.control_strategy.dv.active)
%   if vinf.control_strategy.dv.active(i)
%      str=[str,'counter_log'',[',mat2str(y(:,i)'),'],''',linecolor{rem(i-1,length(linecolor))+1},linetype{rem(i-1,length(linetype))+1},''','];
%   end
%end
for i=1:size(y,2)
   str=[str,'counter_log'',[',mat2str(y(:,i)'),'],''',linecolor{rem(i-1,length(linecolor))+1},linetype{rem(i-1,length(linetype))+1},''','];
end
str=[str,'counter_log,zeros(size(counter_log)),''b--'')'];
evalin('base',str)
ylabel('Lower Bound                                 Upper Bound')
xlabel('Design Iteration')
str=[];
for i=1:length(vinf.control_strategy.dv.active)
   if vinf.control_strategy.dv.active(i)
      str=[str,'''',strrep(vinf.control_strategy.dv.name{i},'_',' '), ''','];
   end
end
eval(['legend(',str,'0)'])
drawnow

return
