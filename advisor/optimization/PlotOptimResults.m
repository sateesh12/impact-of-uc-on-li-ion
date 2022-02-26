function resp=PlotOptimResults(data, plot_info)
%
% data is a structure with the following fields
% 	x  		matrix of design variables indexed vertically by design iteration
% 	f_min  	vector of function value indexed by design iterations
% 	c 	 	matrix of constraint values indexed vertically by design iteration
%
% plot_info is a structure with the following fields
% 	var_label  	cell array of design variable labels
% 	var_ub  		cell array of design variable upper bound
% 	var_lb  		cell array of design variable lower bound
% 	con_label  	cell array of constraint labels
% 	con_ub  		cell array of constraint upper bound
% 	con_lb  		cell array of constraint lower bound
% 	fun_label 	cell array of objective label
%

% initialize
resp=1;

% find existing or create new figure for results
h=findobj('tag','OptimResultsFig');
if isempty(h)
   h=figure;
   set(h,'tag','OptimResultsFig')
end
figure(h);

% store arrays of colors and symbols to cycle through
linecolor={'y','m','c','r','g','b'};
linesymbol={'o','x','+','*','s','d','v','^','<','>'};

% How many design iterations?
iter=size(data.x,1);

% Plot the design variables in the first plot (normalized not yet functional tm:5/10/01)
subplot(3,1,1); 
l_str=[];
for i=1:size(data.x,2)
   str=[linecolor{rem(i-1,length(linecolor))+1},'-',linesymbol{rem(i-1,length(linesymbol))+1}];
   %plot([1:iter],data.x(:,i),str)
   
   % plot normalized design variable data
   plot([1:iter],(data.x(:,i)-((plot_info.var_ub{i}+plot_info.var_lb{i})/2))/((plot_info.var_ub{i}-plot_info.var_lb{i})/2),str)
   
   % build legend str with info structure
   l_str=[l_str,'''',plot_info.var_label{i},' ',num2str(plot_info.var_lb{i}),'/',num2str(plot_info.var_ub{i}),''','];
   
   if i==1
      hold on
   end
end
l_str=strrep(l_str,'_','\_');
eval(['h1=legend(',l_str,'0);'])
ylabel('Design Variables')
hold off

% Plot the constraint values in the second plot (normalized not yet functional tm:5/10/01)
if ~isempty(plot_info.con_label) % only do this section if non-linear constraints are used
    subplot(3,1,2); 
    l_str=[];
    for i=1:size(data.c,2) 
        str=[linecolor{rem(i-1,length(linecolor))+1},'-',linesymbol{rem(i-1,length(linesymbol))+1}];
        %plot([1:iter],data.c(:,i),str) 
        
        % plot normalized constraint information
        plot([1:iter],(data.c(:,i)-((plot_info.con_ub{i}+plot_info.con_lb{i})/2))/((plot_info.con_ub{i}-plot_info.con_lb{i})/2),str)
        
        % build legend str with info structure
        l_str=[l_str,'''',plot_info.con_label{i},' ',num2str(plot_info.con_lb{i}),'/',num2str(plot_info.con_ub{i}),''','];
        
        if i==1
            hold on
        end
    end
    l_str=strrep(l_str,'_','\_');
    eval(['h2=legend(',l_str,'0);'])
    ylabel('Constraints')
    hold off
end

% Plot the objective value in the third plot 
subplot(3,1,3); 
plot([1:iter],data.f_min,'b-x')

% build legend str with info structure
legend(strrep(plot_info.fun_label{1},'_','\_'))
ylabel('Objective')
xlabel('Design Iteration')
hold off

% update the figure graphics
drawnow

return
