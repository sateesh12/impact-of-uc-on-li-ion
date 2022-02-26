% ADVISOR data file:  CYC_VAIL2NREL.m
%
% Data source: Keith Wipke (NREL) 8/4/94
%
% Data confirmation: Data confirmed.
%
% Notes:
% This data was collected using an Apple Powerbook, a vehicle 
% speed sensor, and a pressure sensor during a trip from the city 
% of Vail, CO to NREL(Golden, CO).  The route is along Interstate 
% highway (I-70) with typical speed limits ranging from 45 - 65 MPH and 
% grades ranging from -6% to 6%.
% 
% Created on: 9/7/99
% By:  Tony Markel (tony_markel@nrel.gov) of NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Mountain Driving profile from Vail, CO to NREL';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=2; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_VAIL2NREL - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_info', 4 column matrix with time(s), speed(mph), dist(mi), elevation(ft) 
load CYC_VAIL2NREL.mat
cyc_info=[0 cyc_info(1,2) 0 cyc_info(1,4);cyc_info]; % define time = zero conditions

% define new distance vector
step_size=median(diff(cyc_info(:,3)))*2; % ~185ft
distance=[0:step_size:max(cyc_info(:,3)) max(cyc_info(:,3))];

% store the original distance vector
dist_tmp=cyc_info(:,3);

% fix non-monotonic areas of the dist_tmp vector
bad_indexes=find(diff(dist_tmp)<=0);
if ~isempty(bad_indexes)
   increment=eps*max(dist_tmp); % this is necessary due to Matlab limitation on number of significant digits
   for i=1:length(bad_indexes)
      dist_tmp(bad_indexes(i)+1)=dist_tmp(bad_indexes(i))+increment;
   end
   bad_indexes=find(diff(dist_tmp)<=0);
end

% define new elevation vector
elevation=interp1(dist_tmp,cyc_info(:,4),distance);
elevation(1)=cyc_info(1,4);

% calculate the decimal grade value
grade=tan(asin(diff(elevation)./diff(distance*5280)));

% pad with time=0 and time=(speed~=0)
grade=[grade(1) grade(1) grade];
distance=[0 eps distance(2:end)];
elevation=[cyc_info(1,4) cyc_info(1,4) elevation(2:end)];

if 0 % this if for debugging the above routine
   grade_new=interp1(distance,grade,cyc_info(2:end,3));
   elevation_delta=diff([cyc_info(:,3)]*5280).*grade_new;
   elevation_predicted=cyc_info(1,4);
   for i=1:length(elevation_delta)
      elevation_predicted(i+1)=elevation_predicted(i)+elevation_delta(i);
   end
   % plot difference between predicted and original data
   figure;
   plot((elevation_predicted'-cyc_info(:,4)))
   figure
   plot(distance,time)
   hold
   plot(cyc_info(:,3),cyc_info(:,1),'r-')
   figure
   plot(distance,speed)
   hold
   plot(cyc_info(:,3),cyc_info(:,2),'r-')
   figure
   plot(distance,elevation)
   hold
   plot(cyc_info(:,3),cyc_info(:,4),'r-')
   figure
   plot(distance,grade)
end

% define speed and grade traces for simulation
cyc_mph=[cyc_info(:,1) cyc_info(:,2)];
cyc_grade=[distance'*1609.344 grade'];

% keep key in 'on' position throughout cycle ('1' in the 2nd column => 'on')
vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the trace.
% Used when cyc_filter_bool=1
cyc_avg_time=3;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_elevation_init=8314.833*0.3048; % initial elevation in meters

% clean up workspace
clear grade distance time speed cyc_info dist_tmp bad_indexes i

% A constant zero delta in cargo-mass:
% First column is distance (m) second column is mass (kg) 
cyc_cargo_mass=[0 0
   1 0]; 

if size(cyc_cargo_mass,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_cargo_mass=[0 cyc_cargo_mass; 1 cyc_cargo_mass]; % use this for a constant roadway grade
end

if exist('cyc_coast_gb_shift_delay')
    gb_shift_delay=cyc_coast_gb_shift_delay; % restore the original gb_shift_delay which may have been changed by cyc_coast
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9/7/99:tm file created
% 9/10/99:tm modified grade calcs
% 9/14/99:tm cosmetic changes
% 9/23/99: ss updated name to vail2nrel instead of vail_nrel.
% 11/3/99:ss updated version to 2.21
% 7/21/00:tm revised step size of distance vector to improve smoothing
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
