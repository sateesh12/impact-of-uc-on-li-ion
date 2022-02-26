% ADVISOR data file:  CYC_INRETS.m
%
% Data source: "Automotive test drive cycles for emission measurement 
%               and real-world emission levels - a review" Fig 10
%               D12401,IMechE 2002
%
% Data confirmation: Data taken from http://www.inrets.fr/index.e.html
%
% Notes:
% This cycle was derived by actual in-use vehicle measurement in European vehicles.
% INRETS: INSTITUT NATIONAL DE RECHERCHE SUR TRANSPORTS ET LEUR SECURITE 
% compiled a May 1998 report titled "Development of short drive cycles"
% This report (and project) was funded by the European Comission, Directorate Generals for:
% Environment (DGXI), Transport (DG VII) and Energy (XVII)
% 
% Summary of cycle derivation:
% Short transient driving cycles are built-up that could be used within a procedure of 
% inspection of the in-use vehicles as regards their pollutant emissions.  In order to 
% obtain a sufficient correlation between the emissions measured during such a procedure 
% and those measured during the European approval test (vehicle homologation), a first 
% driving cycle is based on the European standard driving cycle (NEDC).  Preliminary 
% emissions measurement have allowed to validate on a certain extent this cycle.  
% Dedicated to correlate more accurately with the on-the-road pollutant emissions, a 
% second driving cycle is built-up using the in-actual use data collected within the 
% DRIVE-modem European Research.  The analysis of distributions derived from this data 
% allows to determine statistically various parameters such as: duration, length, average 
% speed, stop rate, and idling relative duration.  Simulations enable the construction of
% a short driving cycle, representative of the European traffic and derived from real 
% driving data.  The same data and method are used to derive a set of reference driving 
% cycles to characterize the actual on-the-road pollutant emissions, and correspond 
% to four typical driving situations: 
%  - congested and free-flowing driving in urban areas
%  - road and motorway driving.  
% 
% Created on: 11-Aug-2003
% By:  JJC of Delphi
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_description='INRETS - New European Drive Cycle';
cyc_version=2003; % version of ADVISOR for which the file was generated
cyc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
cyc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: CYC_INRETS - ',cyc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED AND KEY POSITION vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load variable 'cyc_mph', 2 column matrix with time in the first column
load CYC_INRETS.mat
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
cyc_cargo_mass=0;  % [29-Jun-2001 mpo--] no change in cargo mass over this cycle 
cyc_elevation_init=0; %the initial elevation in meters.

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

if size(cyc_cargo_mass,1)<2 % [29-Jun-2001 mpo--] added for variable mass vs. distance functionality
   % convert cyc_cargo_mass to a two column matrix, additional cargo vs. dist
   cyc_cargo_mass=[0 cyc_cargo_mass; 1 cyc_cargo_mass]; % use this for a constant cargo-mass addition
end

if exist('cyc_coast_gb_shift_delay')
    gb_shift_delay=cyc_coast_gb_shift_delay; % restore the original gb_shift_delay which may have been changed by cyc_coast
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 29-Jun-2001 (MPO): added variable 'cyc_cargo_mass' which defines cargo mass on vehicle vs. distance
% 8/20/01: mpo added special case code to reset gb_shift_delay if changed by cyc_coast
