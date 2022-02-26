% ADVISOR data file:  TEST_CITY_HWY_HYBRID.m
%
% Data source: EPA
%
% Data confirmation:
%
% Notes:
% This test runs an 2 UDDS cycles followed by a HWFET cycle.  This test was created 
% to account for the variable operating characteristics of an HEV, specifically
% series HEV's. The standard FTP-75 cycle calculations make an assumption that the 
% fourth bag results will be the same as those in the second bag.  This is a valid 
% assumption for conventional and most parallel hybrids.  However, for hybrids with
% large energy storage systems the SOC balanced operation over a 3 bag test vs. a
% 4 bag test can be significantly different.
% 
% FTP-75
% The FTP-75 is the standard federal exhaust emissions driving cycle, which uses the 
% Urban Dynamometer Driving Schedule (UDDS). This cycle has three separate phases: 
% a cold-start (505- second) phase known as bag 1, a hot-transient (870-second) phase
% known as bag 2, and a hot-start (505 second) phase known as bag 3. The three test
% phases are referred to as bag 1, bag 2, and bag 3 because exhaust samples are 
% collected in separate Tedlar bags during each phase. During a 10-minute cool-down 
% between the second and third phase, the engine is turned off. The 505-second driving
% trace for the first and third phase are identical. The total test time for the FTP
% is 2457 seconds (40.95 minutes), the top speed is 56.7 mph, and the average speed is
% 21.4 mph. The distance driven is approximately 11 miles.
%
% HWFET
% The Highway Fuel Economy Test (HWFET) driving cycle is used to simulate highway
% driving and estimate typical highway fuel economy. The official test consists of a
% warm-up phase followed by a test phase. The driver follows the same driving trace
% in both the warm-up and the test phase. In ADVISOR the warm up phase is replaced by
% starting the vehicle with hot initial conditions. A top speed of 59.9 mph is reached
% with an average speed of 47.6 mph. 
%
% Created on: 8/19/01
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear cyc* vc_key_on test*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test_description='Combined City-Highway for Hybrids';
test_version=2003;   % version of ADVISOR for which the file was generated
test_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
test_validation=0;  % 0=> no validation, 1=> data agrees with source data, 
                    % 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TEST_CITY_HWY_HYBRID - ',test_description])

global vinf
vinf.test.run='off';
drivetrain=vinf.drivetrain.name;
%if strcmp(drivetrain,'series')|strcmp(drivetrain,'parallel')|strcmp(drivetrain,'fuel_cell')|strcmp(drivetrain,'custom')
if isfield(vinf,'energy_storage')&isfield(vinf,'fuel_converter') % tm:2/6/01 revised to allow custom to be a conventional vehicle
   vinf.cycle.soc='on';
   vinf.cycle.socmenu='zero delta'; %set zero delta SOC correct
else
   vinf.cycle.soc='off';
end

%set initial conditions
init_conds_hot;      % hot start - all init temps to approx SS values        

CYC_HWFET; %load highway cycle
no_results_fig=1; %used to avoid pulling up results figure below
gui_run; %run the highway cycle
nox_hwy=nox_gpm; %store the nox from the highway cycle
mpg_hwy=mpg; %store the mpg from the highway cycle
mpgge_hwy=mpgge; %store the mpgge from the highway cycle

%if ~strcmp(drivetrain,'conventional')
if isfield(vinf,'energy_storage')&isfield(vinf,'fuel_converter') % tm:2/6/01 revised to allow custom to be a conventional vehicle
    delta_soc=ess_soc_hist(end)-ess_soc_hist(1);
    mean_soc=mean(ess_soc_hist);
end
delta_trace=max(abs(mpha-cyc_mph_r));

% 02/22/00:tm added these statements to allow easy access to component efficiency info
no_plots=1;
chkoutputs
comp_etas(1,:)=eta_storage;
%%% end added statements 02/22/00:tm

% run TEST_FTP_HYBRID
TEST_FTP_HYBRID;

%if ~strcmp(drivetrain,'conventional')
if isfield(vinf,'energy_storage')&isfield(vinf,'fuel_converter') % tm:2/6/01 revised to allow custom to be a conventional vehicle
    delta_soc=[delta_soc ess_soc_hist(end)-ess_soc_hist(1)];
    mean_soc=[mean_soc mean(ess_soc_hist)];
end
delta_trace=[delta_trace max(abs(mpha-cyc_mph_r))];

%results calculations
if nox_gpm>0
   nox_ratio=nox_hwy/nox_gpm; %calculate ratio of nox emissions (highway/urban)
else
   nox_ratio=NaN;
end;
%if ~strcmp(drivetrain,'ev')
if isfield(vinf,'fuel_converter')
    combined_mpg=1/((.55/mpg)+(.45/mpg_hwy)); %combined mpg: 1/(.55/urban+.45/highway)
else
    combined_mpg=0;
end
combined_mpgge=1/((.55/mpgge)+(.45/mpgge_hwy)); %combined mpgge

% 02/22/00:tm added these statements to allow easy access to component efficiency info
no_plots=1;
chkoutputs
comp_etas(2,:)=eta_storage;
%%% end added statements 02/22/00:tm

vinf.test.run='on';

if ~isfield(vinf,'run_without_gui')
    gui_cty_hwy_results; %run city/hwy results figure
    clear no_results_fig %nox_hwy mpg_hwy mpgge_hwy nox_ratio combined_mpg combined_mpgge;
end

% 02/22/00:tm added these statements to allow easy access to component efficiency info
clear no_plots
%%% end added statements 02/22/00:tm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 09/2/98 (SS): created from test_city_hwy
