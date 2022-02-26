%------------------------------------------------------------------------------------ 
% ADVISOR data file:  CYC_IDLING.m
%
% Notes: Requests a constant speed of the vehicle for 50s.
% 
% Created on: 06/12/03
% By:  Kristina Haraldsson, NREL
%
% Revision history at end of file.
%----------------------------------------------------------------------------------

% FILE ID INFO
%-----------------------------------
%KH cyc_description='Constant speed cycle';
cyc_description='Idling';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_IDLING - ',cyc_description])

% SPEED AND KEY POSITION vs. time
%-------------------------------------
if ~exist('vel')
      vel=0; %speed in mph
end


cyc_mph=[0 0
  50 vel]; %[t speed], t in [s]


% keep key in 'on' position throughout cycle ('1' in the 2nd column => 'on')
vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the trace.
% Used when cyc_filter_bool=1
cyc_avg_time=1;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=0;	%no grade associated with this cycle
cyc_elevation_init=0; %the initial elevation in meters.

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

clear vel; % added 6 Feb 2001 by mpo: required so that CYC_CONSTANT does not interfere with other features
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
% 03/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version to 2.21
% 02/06/01:mpo added a line to clear vel so that features like Multiple Cycles and Trip Builder work properly
% 08/20/01:mpo added special case code to reset gb_shift_delay if changed by cyc_coast
