% RW_execute.m
%					 This runs the thru the 2 or 16-day "real-world" drive cycle
%               created by NREL to match CARB 1985 driving behaviour data
%               See SAE paper # 1999-01-0461


global vinf

waithandle=waitbar(0,'Running real world test.  See command prompt for details.');
try %this try is necessary if more than one waitbar is open in matlab 5.2 version, not necessary for 5.3
   waitbar(.01);%this is waitbar for  loading input figure
end

disp(['*** RUNNING REAL WORLD TEST PROCEDURE ***']);

%Initializations
no_results_fig=1;
drivetrain=vinf.drivetrain.name;
clear ndays t_start dayind RW_starts tmp trip_dur soak_dur trip_init;
clear trip_mi trip_gal trip_tot_emis;

% Set init temps & times
tmp_init_soc=ess_init_soc;
init_conds_hot               % start first cold soak from hot vehicle conditions
%reset the ambient temperature and ess_init_soc to user's setting
vinf.init_conds.amb_tmp=vinf.test.ambtmp;
amb_tmp=vinf.test.ambtmp;
vinf.init_conds.ess_init_soc=tmp_init_soc;%initial soc
ess_init_soc=tmp_init_soc;

soak_init(1)=0;              % s   initial time 
t_vec=[];                    % s   continuous time vector
for i=1:length(vinf.test.vars)
   eval([vinf.test.contvars{i},'=[];']);	%continuous variable vectors
end

% Load CARB UCC cycle matrix and summary info matrix
load cyc_ucc3.txt             % col 1 = time [s], cols 2-18 = veh speed [mph] for UCC 1,5,...75 (UCC75 split)
load ucc_info3.txt            % cols=UCC1,5,...75; ROW 1=label, ROW2=cyc time [s]; ROW3=distance [mi]; ROW4=ave speed [mph]

% Load drive cycle
if vinf.test.days==2
   load cyc_rw_2d.txt           % load file that specifies 1st 2 days of cold soaks and UCCs for "real-world" driving
   cyc=cyc_rw_2d;               % C1=TRIP#, C2=SOAK HRS, C3=SOAK MIN, C4=UCC# (1-15)
elseif vinf.test.days==16
   load cyc_rw_16d.txt           % load file that specifies sequence of cold soaks and UCCs for "real-world" driving
   cyc=cyc_rw_16d;               % C1=TRIP#, C2=SOAK HRS, C3=SOAK MIN, C4=UCC# (1-15)
end

tot_trip=max(cyc(:,1));       % total number of trips            
% Set standard run parameters
cyc_avg_time=3;              % (s)
cyc_filter_bool=1;	        % 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=[0 0; 1 0];	              %no grade associated with this cycle

%%%%%%%%%%%%%%%%%%%%%%
% Run the simulation
%%%%%%%%%%%%%%%%%%%%%%
for i = 1:tot_trip
   disp(['Cycle #',num2str(i),' of ',num2str(tot_trip),': soak']);
   
   % Simulate the soak of trip i
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   soak_dur(i)=3600*cyc(i,2)+60*cyc(i,3);                  % s     duration of soak   
   cyc_mph=[0 0; soak_dur(i) 0];                           % s,mph 2-colunm array of time & veh spd 
   vc_key_on=cyc_mph;                                      % s,    engine on or off array
   
   gui_run_simulation(1,'soak');
   %define vars that are calc normally in gui_post_process
   kpha=mpha*1.6093;
   liters=gal*3.785;
   cyc_kph_r=cyc_mph_r*1.6093;
   waitbar((2*i-1)/(2*tot_trip)-.1)
   
   % save variables 
   % User variables are in vinf.test.vars{1} e.g. veh_spd_r and vinf.test.contvars{1} e.g. Cveh_spd_r
   for j=1:length(vinf.test.vars)
      %lower the memory requirements by recording data every n time steps
      if strcmp(vinf.drivetrain.name,'conventional')
         n=1;
      elseif i==1
         n=360;
      else
         n=10; 
      end	%take data points every n indices
      tmp=eval(vinf.test.vars{j});	%variable for given test run
      ind=[];
      for k=1:length(tmp)/n
         ind(k)=n*k;
      end
      tmp=tmp(ind,:);
      
      if i==1
         eval([vinf.test.contvars{j},'=[tmp];']);
      else
         eval([vinf.test.contvars{j},'=[eval(vinf.test.contvars{j}); tmp];']);
      end
   end
   if length(vinf.test.vars)~=0
      t=t(ind);												% s 	record the lower-memory req. time
   end
   ta=t+soak_init(i);                           % s   convert "relative" time to "absolute" 
   t_vec=[t_vec ta'];                           % s   continuous time vector
   
   init_conds_prev               % set init conds for next cycle or soak = to final values of prev cycle or soak
   trip_init(i)=max(t_vec);                      % s   update start time of next sim
   
   % Simulate the driving of trip i
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   disp(['Cycle #',num2str(i),' of ',num2str(tot_trip),': trip']);
   ucc_no=cyc(i,4);
   trip_dur(i)=ucc_info3(2,ucc_no);                     % s  duration of trip i
   cyc_mph=  [ [1:trip_dur(i)]' cyc_ucc3(1:trip_dur(i),ucc_no+1) ];
   vc_key_on=[ [1:trip_dur(i)]' ones(trip_dur(i),1) ];
   gui_run_simulation(1,'trip');
   %define vars that are calc normally in gui_post_process
   kpha=mpha*1.6093;
   liters=gal*3.785;
   cyc_kph_r=cyc_mph_r*1.6093;
   waitbar((2*i)/(2*tot_trip)-.1)
   % save vars & emis results
   trip_tot_emis(i,:)=sum(emis);                   % g   tot emis for trip
   trip_gal(i)=gal(length(t));                     % gal save gallons of fuel used for trip
   trip_mi(i)=trapz(t,mpha)/3600;                  % mi  trip distance in miles
   
   for j=1:length(vinf.test.vars)
      %lower the memory requirements by recording data every n seconds
      n=3;	%take data points every n seconds
      tmp=eval(vinf.test.vars{j});	%variable for given test run
      ind=[];
      for k=1:length(tmp)/n
         ind(k)=n*k;
      end
      tmp=tmp(ind,:);
      eval([vinf.test.contvars{j},'=[eval(vinf.test.contvars{j}); tmp];']);
   end
   if length(vinf.test.vars)~=0
      t=t(ind);												% s 	record the lower-memory req. time
   end
   ta=t+trip_init(i);                         		% s   convert "relative" time to "absolute" 
   t_vec=[t_vec ta'];         	                  % s   continuous time vector
   
   init_conds_prev                   % set init conds for next cycle or soak = to final values of prev cycle or soak
   soak_init(i+1)=max(t_vec);                    % s   update start time of next sim
   
end  

%Post processing of results
tot_soak_h=sum(soak_dur)/3600;                   	% h    total soak time
tot_trip_h=sum(trip_dur)/3600;                   	% h    total soak time
tot_time_h=tot_soak_h+tot_trip_h;                	% h    total time
trip_mph=(trip_mi./trip_dur)*3600;               	% mph  ave speed of trip
for i=1:length(trip_gal)
   if trip_gal(i)>0
      trip_mpg(i)=trip_mi(i)/trip_gal(i);        	% mpg  trip fuel economy
   else
      trip_mpg(i)=0;		           						% mpg  trip fuel economy
   end
end
trip_HC_gpmi=trip_tot_emis(:,1)./trip_mi';       	% g/mi HC emissions for trip
trip_CO_gpmi=trip_tot_emis(:,2)./trip_mi';       	% g/mi CO emissions for trip
trip_NOx_gpmi=trip_tot_emis(:,3)./trip_mi';      	% g/mi NOx emissions for trip
trip_PM_gpmi=trip_tot_emis(:,4)./trip_mi';       	% g/mi PM emissions for trip
tot_gal=sum(trip_gal);                           	% gal   total gallons of fuel used
tot_mi=sum(trip_mi);                             	% mi   total miles traveled
ave_mpg=tot_mi/tot_gal;                           	% mpg  ave fuel economy
ave_mph=tot_mi/tot_trip_h;                        	% mph  ave RW cyc mph
tot_emis=sum(trip_tot_emis);                     	% g    total g of emis
ave_gpmi=tot_emis./tot_mi;                        	% g/mi ave g/mi emis
cum_soak_dur=sort(soak_dur)/3600;                	% hrs  cumulative soak time dist
pct_trips=(1:tot_trip)*(100/tot_trip);           	%    cum % of trips
cum_trip_mi=sort(trip_mi);                       	% mi   cum miles/trip
cum_trip_km=cum_trip_mi/.62137;							% km cumulative kilometers/trip
cum_trip_mph=sort(trip_mph);                     	% mph  cum ave trip speed
cum_trip_kph=cum_trip_mph/.62137;						%kph cumulative kilometers/hour/trip.
ndays=tot_time_h/24;
ave_mi_day=tot_mi/ndays;

t_start=[];
for i=1:tot_trip
   %soak
   if i==1
      t_start=[
         1 0
         soak_dur(i) 0];
   else
      t_start=[
         t_start
         t_start(end,1)+soak_dur(i) 0];
   end
   %trip
   t_start=[
      t_start
      t_start(end,1)+1 1
      t_start(end,1)+trip_dur(i) 0 ];   
end
for i=1:floor(ndays)
   dayind(i)=min(find(t_start(:,1)/60/60/24>=i));	%indices for vector for day separations
end
for i=1:floor(ndays)
   if i==1
      RW_starts(i)=sum(t_start(1:dayind(i),2));	%number of starts in day i
   else
      RW_starts(i)=sum(t_start(dayind(i-1):dayind(i),2));	%number of starts in day i
   end
end
pct_days=(1:ndays)*(100/round(ndays));           % %    cum % of days
cum_starts_perday=sort(RW_starts);								%cumulative starts per day
   
cum_HC=sort(trip_tot_emis(:,1));            % g    cum trip emis
cum_CO=sort(trip_tot_emis(:,2));
cum_NOx=sort(trip_tot_emis(:,3));
cum_PM=sort(trip_tot_emis(:,4));

rw_miles=tot_mi;
rw_mpgge=ave_mpg*42600/fc_fuel_lhv*749/fc_fuel_den;%gasoline equivalent
rw_hc=ave_gpmi(1);
rw_co=ave_gpmi(2);
rw_nox=ave_gpmi(3);
rw_pm=ave_gpmi(4);
trip_tot_emis_hc=trip_tot_emis(:,1);
trip_tot_emis_co=trip_tot_emis(:,2);
trip_tot_emis_nox=trip_tot_emis(:,3);
trip_tot_emis_pm=trip_tot_emis(:,4);
%Metric
trip_tot_emis_hc_gpkm=trip_tot_emis_hc*.62137;
trip_tot_emis_co_gpkm=trip_tot_emis_co*.62137;
trip_tot_emis_nox_gpkm=trip_tot_emis_nox*.62137;
trip_tot_emis_pm_gpkm=trip_tot_emis_pm*.62137;

waitbar(.95)
%Run FTP for comparison
if vinf.test.FTP
   disp(['*** RUNNING FTP COMPARISON ***']);
   vinf.run_without_gui=1; %avoids waitbar
   if vinf.test.FTPsoak
      TEST_FTP_RW;
   else
      TEST_FTP;
   end
   %results are: dist_total, hc_gpm, co_gpm,nox_gpm,pm_gpm,mpgge
   vinf.test.run='on';
   vinf=rmfield(vinf,'run_without_gui');
end

waitbar(1)
close(waithandle); 	%close the waitbar   

no_results_fig=0;

%Pull up RW results figure
RW_results;

%Revision history
%6/17/99: vhj file created
%6/23/99: vhj cum_trip_starts
%9/09/99: vhj reduced memory requirents: records data every n seconds (10 s) now, added waitbar
%9/15/99: vhj cyc_grade now a matrix
%9/16/99: vhj no t(ind) if no continuous variables desired
%9/20/99: adjust waitbar, remove run_without_gui field, reset no_results_fig, reduce time req for 1st soak
%9/23/99: vhj metric emissions
%9/24/99: vhj cleared some variables at beginning (dayind RW_starts etc). define vars that are calc normally in gui_post_process
%9/24/99: vhj i==1 for reducing memory for variables, not j==1
%10/11/99: vhj trip_mpg=0 if no gallons used
%11/29/99: vhj ambient temperature specified by user in variable vinf.test.ambtmp, TEST_FTP_RW for soaks
%01/13/00: vhj allows user to set initial SOC from IC menu on sim setup screen