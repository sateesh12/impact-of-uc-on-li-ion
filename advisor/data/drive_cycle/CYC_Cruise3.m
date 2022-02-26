% ADVISOR data file:  CYC_Cruise3.m
%
% Data source:
% Use this area to describe where the cyc data was obtained.
%
% Data confirmation:
% 
% Notes:
% This data represents 
% 
% Created on: 1_Jan_90
% By:  originator
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Cruise3';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_Cruise3- ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED: load variable 'cyc_mph', 2 column matrix with time in the first column, speed in mph
% in the second column.  Most cycle files load a *.mat file, which is a matlab file 
% you can creat by issuing the command 'save cyc_skeleton cyc_mph' 
% We use the *.mat file to conserve space and load the data quicker.
load CYC_Cruise3.mat 

if cyc_mph(1,1)~=0 % add a time equal to zero term if not present
    cyc_mph=[0 cyc_mph(1,2);cyc_mph];
end

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
cyc_elevation_init=1500; %the initial elevation in meters.

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

% 2-July-2001 [MPO] added for variable cargo-mass
% A non-constant cargo-mass can be defined, as shown below.
% First column is distance (m) second column is mass (kg) 
%cyc_cargo_mass=[0 68
%   40 68*2
%   50 68*3
%   200 68*2
%   900 68]; 

% A constant cargo-mass:
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
% 7/02/01:mpo added variable cargo-mass functionality
% 8/09/01:mpo added if..end statement to ensure cyc_mph is defined for elapsed time = 0 (i.e., initial conditions)
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast