% ADVISOR data file:  CYC_REP05.m
%
% Data source:
% Downloaded from www.epa.gov.
%
% Data confirmation:
%
% Notes: based on Section 3.1.2 of Final Technical Report on Aggressive 
% Driving Behavior for the Revised Federal Test Procedure Notice of 
% Proposed Rulemaking (http://www.epa.gov/OMS/regs/ld-hwy/ftp-rev/ftp-us06.pdf)
% 
% This cycle characterizes aggressive driving of Representative Non-LA4 cycle 
% (REP05). {LA4 is also refered to as UDDS} This cycle targeted speeds
% and accelerations, as well as microtransient effects, not covered
% by the current LA4. The in-use data points used in developing
% the REP05 target surface were those with combinations of speed
% and acceleration that were not represented on the LA4 cycle (non-LA4)
% and, in addition, were not part of the ST01 target surfaces. {STO1 is also
% documented in this reference and represents typical start transients}
% These points tended to be either high-speed or high-acceleration
% (or both). By assembling the cycle from actual idle-to-idle
% driving segments, however, the cycle necessarily included some
% speed/acceleration combinations that were represented on the LA4,
% amounting to about 30 percent of the cycle's 1400 seconds. The
% average speed of REP05 is 51.5 mph, the maximum speed is 80.3
% mph, and the maximum acceleration rate is 8.5 mph/sec.
% 
% Created on: 12-Jun-1998
% By:  SS of NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='REP05 driving cycle';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_REP05 - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_REP05.mat
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
% 30-Jun-1998 (MRC):  cosmetic changes
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 9/15/99:tm updated *_version to 2.2 from 2.1
% 11/3/99:ss updated version to 2.21
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
% 8/20/01:tm updated text in notes section
