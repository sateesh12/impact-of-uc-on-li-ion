% ADVISOR data file:  CYC_COAST.m
%
% Data source: NREL
%
% Data confirmation: none
%
% Notes: This cycle was created to allow the user to model
% the coast down performance and provide an estimate of the 
% driveline losses.  You may change the initial speed.  The
% coast down event is modeled by essentially putting the gearbox
% into neutral (gb_shift_delay>length of cycle). 
% 
% Created on: 18-Nov-1998
% By:  VHJ of NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Coast Down Cycle';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_COAST - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vel=35; %speed in mph

cyc_mph=[0 vel
   5 vel
   50 vel];

% keep key in 'on' position throughout cycle ('1' in the 2nd column => 'on')
vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];

% overrride shift delay value and setup a way to restore gb_shift_delay
if ~exist('cyc_coast_gb_shift_delay')
    if exist('gb_shift_delay')
        cyc_coast_gb_shift_delay=gb_shift_delay; % save the original gb_shift_delay
    else
        cyc_coast_gb_shift_delay=0;
    end
end
gb_shift_delay=100*max(cyc_mph(:,1)); % set to max cycle time instead of infinity


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the trace.
% Used when cyc_filter_bool=1
cyc_elevation_init=0;  % initial elevation (m)
cyc_avg_time=1;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=[0 0; 1 0];	%no grade associated with this cycle

% A constant zero delta in cargo-mass:
% First column is distance (m) second column is mass (kg) 
cyc_cargo_mass=[0 0
   1 0]; 

if size(cyc_cargo_mass,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_cargo_mass=[0 cyc_cargo_mass; 1 cyc_cargo_mass]; % use this for a constant roadway grade
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 04-Oct-2000: automatically updated to version 3
% 10/4/00:tm updated grade info
% 10/4/00:tm added elevation info
% 8/20/01:tm updated text in notes section
% 8/20/01:mpo added a means to restore gb_shift_delay if another cycle chosen after cyc_coast