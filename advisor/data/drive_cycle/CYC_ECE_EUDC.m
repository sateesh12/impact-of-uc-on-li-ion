% ADVISOR data file:  CYC_ECE_EUDC.m
%
% Data source: Diesel.net website www.diesel.net
%  
% Data confirmation:
%
% Notes: (from www.diesel.net)
% The ECE+EUDC test cycle is performed on a chassis dynamometer. The cycle 
% is used for emission certification of light duty vehicles in Europe. It is 
% also known as the MVEG-A cycle. The cycle definition can be found in the 
% EEC Directive 90/C81/01.
% The entire cycle includes four ECE segments, Figure 1, repeated without 
% interruption, followed by one EUDC segment, Figure 2. Before the test, 
% the vehicle is allowed to soak for at least 6 hours at a test temperature
% of 20-30°C. It is then started and allowed to idle for 40s.
% Effective year 2000, that idling period has been eliminated, i.e., 
% engine starts at 0s and the emission sampling begins at the same time. 
% This modified cold-start procedure is sometimes referred to as the 
% "new European driving cycle".
% Emissions are sampled during the cycle according the the "Constant 
% Volume Sampling" technique, analyzed, and expressed in g/km for 
% each of the pollutants.
% The ECE cycle is an urban driving cycle, also known as UDC. It was 
% devised to represent city driving conditions, e.g. in Paris or Rome. 
% It is characterized by low vehicle speed, low engine load, and low 
% exhaust gas temperature.
% The above urban driving cycle represents Type I test, as defined 
% by the original ECE 15 emissions procedure. Type II test is a warmed-up 
% idle tailpipe CO test conducted immediately after the fourth cycle of 
% the Type I test. Type III test is a two-mode (idle and 50 km/h) chassis 
% dynamometer procedure for crankcase emission determination.
% The EUDC (Extra Urban Driving Cycle) segment has been added after the
% fourth ECE cycle to account for more aggressive, high speed driving modes. 
% The maximum speed of the EUDC cycle is 120 km/h. An alternative EUDC 
% cycle for low-powered vehicles has been also defined with a maximum 
% speed limited to 90 km/h (Figure 3).
% The following table includes a summary of the parameters for both 
% the ECE and EUDC cycles.
%
% Characteristics	Unit	ECE 15					EUDC 
%  Distance			km		4×1.013=4.052			6.955 
%  Duration 		s		4×195=780 				400 
%  Average Speed 	km/h 	18.7 (with idling)	62.6 
%  Maximum Speed 	km/h 	50 						120 
% 
% Created on: 8/15/00
%
% By:  Tony Markel, NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='ECE+EUDC Drive Cycle';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_ECE_EUDC - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_ECE.mat
cyc_mph_ece=cyc_mph;
load CYC_EUDC.mat
cyc_mph=[cyc_mph_ece;...
      cyc_mph_ece;...
      cyc_mph_ece;...
      cyc_mph_ece;...
      cyc_mph];
cyc_mph(:,1)=[0:length(cyc_mph)-1]';
cyc_mph(:,1)=cyc_mph(:,1)+41;
cyc_mph=[0 0; 40 0; cyc_mph];

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
% 8/15/00:tm file created
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast