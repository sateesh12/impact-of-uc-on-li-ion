% ADVISOR data file:  TEST_FTP_RW.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% This data represents the Federal Test Procedure driving cycle used by the
% US EPA for emissions certification of passenger vehicles in the US with a
% slight modification:  the user may specify the length of the cold soak 
% (currently 12-36 hours), and the user may specify the ambient temperature during 
% the test.
% 
% Created on: 29-Nov-1999
% By:  VHJ of NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear cyc* vc_key_on test*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='US EPA Federal Test Procedure, with user specified ambient temperature and cold soak time.';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TEST_FTP_RW - ',cyc_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulate the prep cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Simulating FTP prep cycle (UDDS)']);
CYC_UDDS;
%set initial conditions
init_conds_amb;      % cold temperatures
%reset the ambient temperature to user's setting
vinf.init_conds.amb_tmp=vinf.test.ambtmp;
amb_tmp=vinf.test.ambtmp;
gui_run_simulation(1,'trip');


%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulate the cold soak
%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Simulating FTP soak']);

soak_dur(i)=3600*vinf.test.soaktime;			% s     duration of soak   
cyc_mph=[0 0; soak_dur(i) 0];						% s,mph 2-colunm array of time & veh spd 
vc_key_on=cyc_mph;									% s,    engine on or off array

%reset initial conditions
init_conds_prev;		% set init conds for next cycle or soak = to final values of prev cycle or soak
%reset the ambient temperature to user's setting
vinf.init_conds.amb_tmp=vinf.test.ambtmp;
amb_tmp=vinf.test.ambtmp;

gui_run_simulation(1,'soak');

%reset initial conditions
init_conds_prev;		% set init conds for next cycle or soak = to final values of prev cycle or soak
%reset the ambient temperature to user's setting
vinf.init_conds.amb_tmp=vinf.test.ambtmp;
amb_tmp=vinf.test.ambtmp;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Simulating FTP cycle']);

% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_UDDS.mat

cyc_mph(1374:1973,2)=zeros(600,1);
cyc_mph(1974:2478,2)=cyc_mph(2:506,2);
cyc_mph(1:2478,1)=[0:2477]';
temp=[ones(1373,1);zeros(600,1);ones(505,1)];
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
cyc_cargo_mass=[0 0; 1 0]; % default non-variable cargo-mass, mpo 17-July-2001

global vinf
vinf.test.run='off';
drivetrain=vinf.drivetrain.name;
%if strcmp(drivetrain,'series')|strcmp(drivetrain,'parallel')|strcmp(drivetrain,'fuel_cell')
 if isfield(vinf,'energy_storage')&isfield(vinf,'fuel_converter') % tm:2/6/01 revised to allow custom to be a conventional vehicle
  vinf.cycle.soc='on';
   vinf.cycle.socmenu='zero delta'; %set zero delta SOC correct
else
   vinf.cycle.soc='off';
end

no_results_fig=1; %used to avoid pulling up results figure below
gui_run; %run the ftp-75 cycle

%results calculations
liters_p_gal=3.78541;

%redo emmissions calculations based on weighted equation.
index505=find(t==505);
index1373=find(t==1373);
index1974=find(t==1974);

dist1=trapz(t(1:index505),mpha(1:index505))/3600; %miles
dist2=trapz(t(index505+1:index1373),mpha(index505+1:index1373))/3600;
dist3=trapz(t(index1974:end),mpha(index1974:end))/3600;

hc_grams1=trapz(t(1:index505),emis(1:index505,1));
hc_grams2=trapz(t(index505+1:index1373),emis(index505+1:index1373,1));
hc_grams3=trapz(t(index1974:end),emis(index1974:end,1));
co_grams1=trapz(t(1:index505),emis(1:index505,2));
co_grams2=trapz(t(index505+1:index1373),emis(index505+1:index1373,2));
co_grams3=trapz(t(index1974:end),emis(index1974:end,2));
nox_grams1=trapz(t(1:index505),emis(1:index505,3));
nox_grams2=trapz(t(index505+1:index1373),emis(index505+1:index1373,3));
nox_grams3=trapz(t(index1974:end),emis(index1974:end,3));
pm_grams1=trapz(t(1:index505),emis(1:index505,4));
pm_grams2=trapz(t(index505+1:index1373),emis(index505+1:index1373,4));
pm_grams3=trapz(t(index1974:end),emis(index1974:end,4));
if exist('fc_fuel_den')
   fuel_grams1=(gal(index505)-gal(1))*fc_fuel_den*liters_p_gal;
   fuel_grams2=(gal(index1373)-gal(index505+1))*fc_fuel_den*liters_p_gal;
   fuel_grams3=(gal(end)-gal(index1974))*fc_fuel_den*liters_p_gal;
else
   fuel_grams1=0;
   fuel_grams2=0;
   fuel_grams3=0;
end

hc_gpm1=trapz(t(1:index505),emis(1:index505,1))/dist1;%grams
hc_gpm2=trapz(t(index505+1:index1373),emis(index505+1:index1373,1))/dist2;%grams/mile
hc_gpm3=trapz(t(index1974:end),emis(index1974:end,1))/dist3;%grams/mile
co_gpm1=trapz(t(1:index505),emis(1:index505,2))/dist1;%grams/mile
co_gpm2=trapz(t(index505+1:index1373),emis(index505+1:index1373,2))/dist2;%grams/mile
co_gpm3=trapz(t(index1974:end),emis(index1974:end,2))/dist3;%grams/mile
nox_gpm1=trapz(t(1:index505),emis(1:index505,3))/dist1;%grams/mile
nox_gpm2=trapz(t(index505+1:index1373),emis(index505+1:index1373,3))/dist2;%grams/mile
nox_gpm3=trapz(t(index1974:end),emis(index1974:end,3))/dist3;%grams/mile
pm_gpm1=trapz(t(1:index505),emis(1:index505,4))/dist1;%grams/mile
pm_gpm2=trapz(t(index505+1:index1373),emis(index505+1:index1373,4))/dist2;%grams/mile
pm_gpm3=trapz(t(index1974:end),emis(index1974:end,4))/dist3;%grams/mile
fuel_gpm1=fuel_grams1/dist1;
fuel_gpm2=fuel_grams2/dist2;
fuel_gpm3=fuel_grams3/dist3;

dist_total=.43*dist1+dist2+.57*dist3;
hc_gpm=(0.43*hc_grams1+hc_grams2+.57*hc_grams3)/dist_total;
co_gpm=(0.43*co_grams1+co_grams2+.57*co_grams3)/dist_total;
nox_gpm=(0.43*nox_grams1+nox_grams2+.57*nox_grams3)/dist_total;
pm_gpm=(0.43*pm_grams1+pm_grams2+.57*pm_grams3)/dist_total;
fuel_gpm=(0.43*fuel_grams1+fuel_grams2+0.57*fuel_grams3)/dist_total;

gas_lhv=42600;
gas_dens=749;

if fuel_gpm~=0 % for EVs don't use the weighted fuel calculation - mpgge already calculated in gui_post_process
   mpg=1/(fuel_gpm/fc_fuel_den/liters_p_gal);
   mpgge=mpg*gas_lhv/fc_fuel_lhv*gas_dens/fc_fuel_den;
end

if strcmp(vinf.test.name,'TEST_FTP')
   ResultsFig;
   gui_ftp_results; %run city/hwy results figure
   vinf.test.run='on';
   clear no_results_fig
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11/29/99:vhj created from TEST_FTP
% 3/21/00: ss updated call to results figure: ResultsFigControl was gui_results
% 7/10/99:ss now loads CYC_UDDS.mat instead of old name (CYC_FUDS.mat)
% 1/30/01:tm added calculations for weighted fuel economy based on same equations as emissions calculations
% 2/6/01:tm revised conditional on whether to do SOC correction to be based on ess field and not drivetrain
% 7/17/01:mpo added cyc_cargo_mass definition
% 2/15/02: ss changed ResultsFigControl to ResultsFig