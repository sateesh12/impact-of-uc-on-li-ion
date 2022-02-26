% ADVISOR data file:  CYC_MANHATTAN.m
%
% Data source:
% This cycle data was obtained from West Virginia University (Prof. Nigel Clark and his team).
%
% Data confirmation:
% 
% Notes:
% [The following direct quote from  Clark et. al. "Emissions Results from 
%  Hybrid-Electric and Conventional Transit Buses in New York City", -draft report- 
%  West Virginia University, Dept. of Mechanical and Aerospace Engineering, 2000]:
%  The Manhattan Cycle is a drive cycle "...developed from recent in-use transit 
%  bus operation in Manhattan. Data were logged from both hybrid-electric and 
%  conventional bus operation over several different NY Metropolitan Transit Authority
%  bus routes. Each data set was broken into micro-trips, each micro-trip being a start from 
%  idle, acceleration to speed, and deceleration to idle. The data set consisted of 287 
%  micro-trips from conventional transit buses and 112 micro-trips from Orion-LMCS 
%  hybrid-electric buses. Average speed and standard deviation of speed over the data set 
%  from both the hybrid-electric and convetional data were determined after excluding idle
%  points. A computer program was then developed and used to combine five micro-trips
%  randomly from the conventional data and five micro-trips from the hybrid electric data
%  set, determine their statistical makeup, and compare that to the overall data sets. This 
%  process was repeated 500,000 times per data set until two sets of five micro-trips with 
%  average speed and standard deviation of speed most closely matching that  from the overall 
%  set was found. The micro-trips were then combined to form the Manhattan cycle. Idle time
%  between micro-trips was set to the average idle time (19 seconds) from the overall data sets.
%  To increase the amount of energy demanded by the cycle, the 10 micro-trips were repeated
%  with the final cycle containing 20 micro-trips..."
%
%
% Created on: 28_Sept_2000
% By:  Michael O'Keefe
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Manhattan Bus Drive Cycle';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_MANHATTAN- ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED: load variable 'cyc_mph', 2 column matrix with time in the first column, speed in mph
% in the second column.  Most cycle files load a *.mat file, which is a matlab file 
% you can creat by issuing the command 'save cyc_skeleton cyc_mph' 
% We use the *.mat file to conserve space and load the data quicker.
% If you save your data to a *.mat file, use this command to load: 'load CYC_SKELETON.mat'

load CYC_MANHATTAN.mat;

% KEY ON: keep key in 'on' position throughout cycle ('1' in the 2nd column => 'on')
% The key on is set to 'off' if you want to do a vehicle soak, such as in the 
% Federal Test Procedure between bags 2 and 3.  It should be defined at the same time
% steps as the vehicle speed.
vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the trace.
% Used when cyc_filter_bool=1
cyc_avg_time=3;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=0;	%(decimal, ex. 0.01 would be used if a 1% grade is desired)
%if a constant grade is wanted then cyc_grade can be set to that grade
%if a variable grade is desired then cyc_grade has to contain distance and grade info.
%the first column of cyc_grade would be the distance in meters and the second column would
%be the grade at that distance.
cyc_elevation_init=0; %the initial elevation in meters.

% A non-constant road-grade can be defined, as shown below.
% First column is distance (m) second column is grade (decimal, or %/100) 

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

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
% 8/26/99:ss created for users to have an example of a cycle file
% 11/3/99:ss updated version to 2.21
% 8/11/00:kw modified to be more useful for users to create their own cycle files
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast