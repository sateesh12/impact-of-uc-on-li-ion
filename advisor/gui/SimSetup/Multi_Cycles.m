function Multi_Cycles
% Runs Multiple Cycles with same initial conditions
% in a 'batch' mode.  You can then view all the cycle runs from the 
% results figure using a pulldown menu.

global vinf

%save the setup file(all of workspace) in the \gui\simsetup directory

%make sure that all the results names are saved in the setup file
for i=1:length(vinf.multi_cycles.name)
   vinf.multi_cycles.result_name{i}=['r',num2str(i),'_' vinf.multi_cycles.name{i}];
end

%select path for saving and save
p=strrep(which('Multi_Cycles.m'),'Multi_Cycles.m','');
evalin('base',['save(''' p 'simsetup_file.mat'')']);

for i=1:length(vinf.multi_cycles.name)
   %run the cycle file in the base workspace
   vinf.cycle.name=vinf.multi_cycles.name{i};
   evalin('base',vinf.multi_cycles.name{i})
   
   %number of times to repeate the cycle
   vinf.cycle.number=vinf.multi_cycles.number{i};
   
   %keep the gui's off until the end
   evalin('base','no_results_fig=1;')
   vinf.run_without_gui=1;
   
   %run the simulation
   evalin('base','gui_run')
  
   % don't save the no gui variables
   vinf=rmfield(vinf,'run_without_gui');
   evalin('base','clear no_results_fig');

	% the save command
	evalin('base',['save(''' p , vinf.multi_cycles.result_name{i},''')']);
   
   %if it isn't the last cycle run then clear and get ready for the next run by 
   %loading the setup file that was previously saved
   if i~=length(vinf.multi_cycles.name)
      evalin('base','clear')
      evalin('base','global vinf');
      evalin('base',['load(''' p 'simsetup_file.mat'')'])
   end
end

%after running and saving all the different cycles
% call up ResultsFig with the last set of results
% The results figure has to know to set the multi_cycles to the last one.
evalin('base','ResultsFig');

%Revision History
% 1/24/01 ss created 
% 1/26/01 ss added the code
% 2/15/02: ss replaced ResultsFigControl with ResultsFig