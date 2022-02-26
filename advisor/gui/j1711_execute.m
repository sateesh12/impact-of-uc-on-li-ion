%j1711_execute: Executes the SAE J1711 test procedure for hybrids

% booleans defined in vinf (and desired AC load)
% vinf.test.OVC vinf.test.EV vinf.test.CV vinf.test.AC.bool vinf.test.AC.load
%
% Created on 2-26-99 by VHJ of NREL
% 
% Revision history found at end of file.

global vinf;

%%%%%%%%%%%%%%%%%
% Classification 
%%%%%%%%%%%%%%%%%
mode_run=[0;0;0;0];
mode_run(1)=1; %always, run PTC-HEV (partial charge test, charge sustaining)
if vinf.test.OVC
   mode_run(2)=1; %run FCT-HEV (full charge test, charge sustaining)
end
if vinf.test.CV
   mode_run(3)=1;	%run an EOT (engine only test, or CV conventional)
end
if vinf.test.EV
   mode_run(4)=1; %run an EVT (electric vehicle test)
end

%%%%%%%%%%%%
% Run tests
%%%%%%%%%%%%
disp(['*** RUNNING J1711 TESTS ***']);
vinf.test.run='off'; %need to call gui_run
no_results_fig=1;
enable_stop=1;
J17_tp;

%%%%%%%%%%%%%%%%
%Weight results
%%%%%%%%%%%%%%%%
disp(['*** WEIGHTING RESULTS ***']);
J17_wt;

%%%%%%%%%%%%%%%%%%
% Results Figure
%%%%%%%%%%%%%%%%%%
vinf.test.run='on'; 
clear no_results_fig;
enable_stop=0;
J17_results;

% Revision history
% 2/26/99 vhj file created
% 3/9/99 vhj changed EO to CV