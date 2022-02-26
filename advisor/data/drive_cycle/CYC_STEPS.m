% ADVISOR data file:  CYC_STEPS.m
%
% Data source: NREL     
%
% Data confirmation:
%
% Notes: This cycle was created to provide the ability to estimate
% vehicle loads at a variety of constant speed points.
%
% Created on: 3/24/00
% By:  TM, NREL, Tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='Step change from high speed to low speed to high speed';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_STEPS - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
duration=10;
spd_incr=5;
cyc_mph=[0 0];
for i=2:21
    if mod(i,2)
        cyc_mph(i,1)=cyc_mph(i-1,1)+duration;
        cyc_mph(i,2)=cyc_mph(i-1,2);
    else
        cyc_mph(i,1)=cyc_mph(i-1,1)+1;
        cyc_mph(i,2)=cyc_mph(i-1,2)+spd_incr;
    end
end
for i=22:40
    if mod(i,2)
        cyc_mph(i,1)=cyc_mph(i-1,1)+duration;
        cyc_mph(i,2)=cyc_mph(i-1,2);
    else
        cyc_mph(i,1)=cyc_mph(i-1,1)+1;
        cyc_mph(i,2)=cyc_mph(i-1,2)-spd_incr;
    end
end
cyc_mph=[cyc_mph; cyc_mph(end,1)+duration 0];

clear duration spd_incr

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
cyc_grade=0;	% (--) constant grade
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
% 3/24/00:tm file created
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
% 8/20/01:tm updated text in notes section
