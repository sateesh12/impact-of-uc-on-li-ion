% ADVISOR data file:  CYC_UKBUS_MASS_VAR1.m
%
% Data source:
%
% The main cycle data was recorded on a typical journey in London
% This cycle includes passenger mass variation as recorded by a head count
% and assuming 75kg per passenger.
%
% Data confirmation: Real data; passenger mass probably a little high as some
%                    children in sample.
% 
% Notes: Single route sample to prove new added mass feature
%
% 
% Created on: 27_07_01
%
% By:    P.J.Hainsworth, Cranfield University, UK
% For:   Newbus Technology Limited, UK
%
% Special thanks to Mike Kellaway of Newbus Technology Limited, UK for providing
% these data.
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='London bus route with varying passenger mass';
cyc_version=2003; % version of ADVISOR for which the file was generated

% Actually for pre-release version with variable mass feature

cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_UKBUS_MASS_VAR1- ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED: load variable 'cyc_mph', 2 column matrix with time in the first column, speed in mph
% in the second column.  Most cycle files load a *.mat file, which is a matlab file 
% you can creat by issuing the command 'save cyc_skeleton cyc_mph' 
% We use the *.mat file to conserve space and load the data quicker.
% If you save your data to a *.mat file, use this command to load: 'load CYC_SKELETON.mat'

% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_UKBUS6.mat
if cyc_mph(1,1)~=0 % all cyc_mph should begin at time zero
    cyc_mph=[0 cyc_mph(1,2);cyc_mph]; % define a time zero point if not already defined
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

% A non-constant road-grade can be defined, as shown below.
% First column is distance (m) second column is grade (decimal, or %/100) 
cyc_grade=[0 0
   5 0.0
   10 0.0
   15 0.0
   20 0.0
   25 0.0
   30 0.0
   35 0.0
   40 0.0
   50 0.0
   60 0.0
   70 0.0
   80 0.0
   90 0.0
   100 0
   200 0.0
   350 0.0
   500 0.0
   501 0.0
   600 0.0
   900 0]; 

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

% 2-July-2001 [MPO] added for variable cargo-mass
% A non-constant cargo-mass can be defined, as shown below.
% First column is distance (m) second column is mass (kg) 

load CYC_MEASURED_MASS1.mat

if size(cyc_cargo_mass,1)<2
   % if no data, convert cyc_cargo_mass to a two column matrix, mass vs. dist
   cyc_cargo_mass=[0 cyc_cargo_mass; 1 cyc_cargo_mass]; % use this for a constant mass
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
% 2-July-2001:mpo added variable cargo-mass functionality
% 28-Jul-2001: automatically updated to version 3.1
% 28-Jul-2001: automatically updated to version 3.1
% 28-Jul-2001:pjh added links to variable mass data
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
