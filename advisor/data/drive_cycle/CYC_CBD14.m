% ADVISOR data file:  CYC_CBD14.m
%
% Data source: Nigel Clark, West Virginia University
% 
% Data confirmation:
%
% Notes: The Central Business District test cycle. The CBD-14 is a 14 peak 
% cycle used to simulate the stop-and-go driving pattern of transit buses.
% The CBD-14 is also part of the Business-Arterial-Commuter (BAC) 
% composite test procedure. The BAC (which is supposed to represent a Transit
% Coach Operating Duty Cycle) was designed to measure heavy-duty vehicle
% fuel economy as part of recommended practice SAE J1376 (cancelled 1997).
% 
% This file is similar to CYC_CBDBUS. However, this file takes advantage of the
% new variable time step available in ADVISOR 3.1. The CBD-14, which specifies
% cruise and acceleration times to the 1/2 second, was only approximated in
% with CYC_CBDBUS--which is defined on a 1 sample per second basis. This drive 
% cycle is sampled with one data point per 0.1 second (i.e., use 0.1 second time
% step to take advantage of all data)
% 
% For those interested in performing the BAC composite cycle, it consists of the
% following:
% CBD, 300 second idle period, Arterial, CBD, Arterial, CBD, Commuter
% see http://www.dieselnet.com/standards/cycles/bac.html for further details
%
% Created on: 22-Jan-2001
% By:  mpok of NREL, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Central Business District (CBD) 14 peak Driving Schedule';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_CBD14 - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_CBD14.mat
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
cyc_grade=0;	%no grade associated with this cycle
cyc_elevation_init=0; %the initial elevation in meters.

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
% 10/23/98:tm file created
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/3/99:ss updated version to 2.21
% 01/22/01:mpo created file from CYC_CBDBUS and updated to version 3.1
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
