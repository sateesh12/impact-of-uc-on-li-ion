% update the matlab path for use with advisor
updatepath('advisor','advisor')

% load the simulation workspace
load mySimWks.mat

% set run without gui flag
vinf.run_without_gui=1;

% disable run with condor on the host machine
vinf.condor.run='off';

% run the analysis
SimSetupFig('run_pushbutton_Callback');

% reset the run without gui flag
vinf=rmfield(vinf,'run_without_gui');

% reset the run with condor flag
vinf.condor.run='on';

% save the workspace
save myResultsWks.mat

% close matlab
exit

