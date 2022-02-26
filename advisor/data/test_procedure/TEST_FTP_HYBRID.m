% ADVISOR data file:  TEST_FTP_HYBRID.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:
% 
% Created on: 7/6/01
% By:  Tony Markel of NREL (tony_markel@nrel.gov)
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear cyc* vc_key_on test* *gpm4 *grams4 *dist4 dist_total

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='US EPA Federal Test Procedure For Hybrid Vehicles';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TEST_FTP_HYBRID - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_UDDS.mat
cyc_mph(1374:1973,2)=zeros(600,1);
cyc_mph(1974:3345,2)=cyc_mph(2:1373,2);
cyc_mph(1:3345,1)=[0:3344]';
temp=[ones(1373,1);zeros(600,1);ones(1372,1)];
vc_key_on=[cyc_mph(:,1),temp];
clear temp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the trace.
% Used when cyc_filter_bool=1
cyc_avg_time=3;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=[0 0; 1 0];	%no grade associated with this cycle
cyc_cargo_mass=[0 0; 1 0]; %no cargo mass associated with this cycle

global vinf
vinf.test.run='off';
drivetrain=vinf.drivetrain.name;
if isfield(vinf,'energy_storage')&isfield(vinf,'fuel_converter') % tm:2/6/01 revised to allow custom to be a conventional vehicle
   vinf.cycle.soc='on';
   vinf.cycle.socmenu='zero delta'; %set zero delta SOC correct
else
   vinf.cycle.soc='off';
end

%set initial conditions
init_conds_amb;      % cold start - all init temps to amb        
no_results_fig=1; %used to avoid pulling up results figure below
gui_run; %run the ftp cycle for a hybrid

%results calculations
liters_p_gal=3.78541;

%redo emmissions calculations based on weighted equation.
index505=find(t==505);
index1373=find(t==1373);
index1974=find(t==1974);
index2479=find(t==2479);

dist1=trapz(t(1:index505),mpha(1:index505))/3600; %miles
dist2=trapz(t(index505:index1373),mpha(index505:index1373))/3600;
dist3=trapz(t(index1974:index2479),mpha(index1974:index2479))/3600;
dist4=trapz(t(index2479:end),mpha(index2479:end))/3600;

hc_grams1=trapz(t(1:index505),emis(1:index505,1));
hc_grams2=trapz(t(index505:index1373),emis(index505:index1373,1));
hc_grams3=trapz(t(index1974:index2479),emis(index1974:index2479,1));
hc_grams4=trapz(t(index2479:end),emis(index2479:end,1));
co_grams1=trapz(t(1:index505),emis(1:index505,2));
co_grams2=trapz(t(index505:index1373),emis(index505:index1373,2));
co_grams3=trapz(t(index1974:index2479),emis(index1974:index2479,2));
co_grams4=trapz(t(index2479:end),emis(index2479:end,2));
nox_grams1=trapz(t(1:index505),emis(1:index505,3));
nox_grams2=trapz(t(index505:index1373),emis(index505:index1373,3));
nox_grams3=trapz(t(index1974:index2479),emis(index1974:index2479,3));
nox_grams4=trapz(t(index2479:end),emis(index2479:end,3));
pm_grams1=trapz(t(1:index505),emis(1:index505,4));
pm_grams2=trapz(t(index505:index1373),emis(index505:index1373,4));
pm_grams3=trapz(t(index1974:index2479),emis(index1974:index2479,4));
pm_grams4=trapz(t(index2479:end),emis(index2479:end,4));
if exist('fc_fuel_den')
   fuel_grams1=(gal(index505)-gal(1))*fc_fuel_den*liters_p_gal;
   fuel_grams2=(gal(index1373)-gal(index505))*fc_fuel_den*liters_p_gal;
   fuel_grams3=(gal(index2479)-gal(index1974))*fc_fuel_den*liters_p_gal;
   fuel_grams4=(gal(end)-gal(index2479))*fc_fuel_den*liters_p_gal;
else
   fuel_grams1=0;
   fuel_grams2=0;
   fuel_grams3=0;
   fuel_grams4=0;
end

hc_gpm1=trapz(t(1:index505),emis(1:index505,1))/dist1;%grams
hc_gpm2=trapz(t(index505:index1373),emis(index505:index1373,1))/dist2;%grams/mile
hc_gpm3=trapz(t(index1974:index2479),emis(index1974:index2479,1))/dist3;%grams/mile
hc_gpm4=trapz(t(index2479:end),emis(index2479:end,1))/dist4;%grams/mile
co_gpm1=trapz(t(1:index505),emis(1:index505,2))/dist1;%grams/mile
co_gpm2=trapz(t(index505:index1373),emis(index505:index1373,2))/dist2;%grams/mile
co_gpm3=trapz(t(index1974:index2479),emis(index1974:index2479,2))/dist3;%grams/mile
co_gpm4=trapz(t(index2479:end),emis(index2479:end,2))/dist4;%grams/mile
nox_gpm1=trapz(t(1:index505),emis(1:index505,3))/dist1;%grams/mile
nox_gpm2=trapz(t(index505:index1373),emis(index505:index1373,3))/dist2;%grams/mile
nox_gpm3=trapz(t(index1974:index2479),emis(index1974:index2479,3))/dist3;%grams/mile
nox_gpm4=trapz(t(index2479:end),emis(index2479:end,3))/dist4;%grams/mile
pm_gpm1=trapz(t(1:index505),emis(1:index505,4))/dist1;%grams/mile
pm_gpm2=trapz(t(index505:index1373),emis(index505:index1373,4))/dist2;%grams/mile
pm_gpm3=trapz(t(index1974:index2479),emis(index1974:index2479,4))/dist3;%grams/mile
pm_gpm4=trapz(t(index2479:end),emis(index2479:end,4))/dist4;%grams/mile
fuel_gpm1=fuel_grams1/dist1;
fuel_gpm2=fuel_grams2/dist2;
fuel_gpm3=fuel_grams3/dist3;
fuel_gpm4=fuel_grams4/dist4;

dist_total=.43*dist1+0.43*dist2+.57*dist3+0.57*dist4;
hc_gpm=(0.43*hc_grams1+0.43*hc_grams2+.57*hc_grams3+.57*hc_grams4)/dist_total;
co_gpm=(0.43*co_grams1+0.43*co_grams2+.57*co_grams3+.57*co_grams4)/dist_total;
nox_gpm=(0.43*nox_grams1+0.43*nox_grams2+.57*nox_grams3+.57*nox_grams4)/dist_total;
pm_gpm=(0.43*pm_grams1+0.43*pm_grams2+.57*pm_grams3+.57*pm_grams4)/dist_total;
fuel_gpm=(0.43*fuel_grams1+0.43*fuel_grams2+0.57*fuel_grams3+0.57*fuel_grams4)/dist_total;

gas_lhv=42600;
gas_dens=749;

if fuel_gpm~=0 % for EVs don't use the weighted fuel calculation - mpgge already calculated in gui_post_process
   mpg=1/(fuel_gpm/fc_fuel_den/liters_p_gal);
   mpgge=mpg*gas_lhv/fc_fuel_lhv*gas_dens/fc_fuel_den;
end

eval('vinf.run_without_gui;test4exist=1;','test4exist=0;')
if strcmp(vinf.test.name,'TEST_FTP_HYBRID')&(~test4exist) % tm:7/6/00 added &~test4exist to prevent results fig when used with advisor_no_gui
   ResultsFig; % open standard results figure
   FtpResultsFigControl; % open FTP results figure
%   gui_ftp_results; %run city/hwy results figure
   vinf.test.run='on';
   clear no_results_fig
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/6/01:tm file created from TEST_FTP to simulate the normally assumed 4th bag of the standard FTP
% 8/1/01:tm added cyc_cargo_mass definition
% 8/19/01:tm revised call to open newly created FTP results figure
% 2/15/02: ss changed ResultsFigControl to ResultsFig