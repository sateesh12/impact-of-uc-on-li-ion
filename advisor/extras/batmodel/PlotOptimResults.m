function resp=PlotOptimResults(data,plot_info)
%
% data is a structure with the following fields
% 	x  		matrix of design variables indexed vertically by iteration
% 	f_min  	vector of function value indexed by iterations
% 	c_k 	 	matrix of constraint values indexed vertically by iteration
%
% plot_info is a structure with the following fields
% 	dv_label  	cell array of design variable labels
% 	dv_init  	cell array of design variable initial values
% 	con_label  	cell array of constraint labels
% 	con_ub  		cell array of constraint upper bound
% 	con_lb  		cell array of constraint lower bound
% 	obj_label 	cell array of objective label
%

resp=1;

h=findobj('tag','OptimResultsFig');
if isempty(h)
   h=figure;
   set(h,'tag','OptimResultsFig')
end
figure(h);

linecolor={'y','m','c','r','g','b'};
linesymbol={'o','x','+','*','s','d','v','^','<','>'};

iter=size(data.x,1);

subplot(3,1,1); 
hold
for i=1:size(data.x,2)
   str=[linecolor{rem(i-1,length(linecolor))+1},'-',linesymbol{rem(i-1,length(linesymbol))+1}];
   plot([1:iter],data.x(:,i),str)
   
   % plot design variable initial value
   
   % build legend str with info structure
   
end
%legend(str)
ylabel('Design Variables')
hold

subplot(3,1,2); 
hold
for i=1:size(data.x,2)
%for i=1:size(data.c_k,2) % uncomment when data available tm:2/28/01
   str=[linecolor{rem(i-1,length(linecolor))+1},'-',linesymbol{rem(i-1,length(linesymbol))+1}];
   plot([1:iter],data.x(:,i),str)
   %plot([1:iter],data.c_k(:,i),str) % uncomment when data available tm:2/28/01
   
   % plot constraint upper and lower bounds

   % build legend str with info structure

end
%legend(str)
ylabel('Constraints')
hold

subplot(3,1,3); 
hold
plot([1:iter],data.f_min,'b-x')
% build legend str with info structure
%legend(str)
ylabel('Objective')
xlabel('Iteration')
hold

drawnow

return
