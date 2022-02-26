% ADVISOR data file:  PTC_CONVCVT.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, 
% and engine controls, for an advanced conventional vehicle using a CVT.
% 
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='CVT conventional-drivetrain control';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_CONVCVT - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize
clear cvt_locus_spd

% compute idle speed such that
% fc_max_trq(vc_idle_spd) >= 2 * accessory_torque(vc_idle_spd) AND
% vc_idle_spd >= 800 rpm
fc_max_pwr_vec=fc_map_spd.*fc_max_trq;
last_index=min(find(diff(fc_max_pwr_vec)<=0));%ss added '=' in '<=' spot on 7/9/99
if isempty(last_index)
   last_index=length(fc_max_pwr_vec);
end
temp=interp1(fc_max_pwr_vec(1:last_index),fc_map_spd(1:last_index),2*acc_mech_pwr);
if isnan(temp) % if 2*accessory power is off the map (too low)...
   vc_idle_spd=800*2*pi/60;  % (rad/s), engine's idle speed
else
   vc_idle_spd=max(temp,800*2*pi/60);
end

% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=1;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=0; % (--)
% speed at which engine spins while clutch slips during launch
vc_launch_spd=max(max(fc_map_spd)/5,1.5*vc_idle_spd); % (rad/s)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CVT CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute efficiency map
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_outpwr_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./(fc_outpwr_map_kW+eps)*3600;
% if zero speed is in map, replace associated data with nearest BSFC*4
if min(fc_map_spd)<eps
   fc_fuel_map_gpkWh(1,:)=fc_fuel_map_gpkWh(2,:)*4;
end
% if zero torque is in map, replace associated data with nearest BSFC*4
if min(fc_map_trq)<eps
   fc_fuel_map_gpkWh(:,1)=fc_fuel_map_gpkWh(:,2)*4;
end

% Define power vector
fc_max_pwr=max(fc_map_spd.*fc_max_trq);
cvt_locus_pwr=[min(fc_map_spd)*min(fc_map_trq):fc_max_pwr/20:fc_max_pwr]; % 5/10/00:tm change number of points from 10 to 20 for better resolution
% Loop on power
for pwr_index=2:length(cvt_locus_pwr-1)
   
   % consider every integer speed in the map
   spds=[ceil(min(fc_map_spd)):floor(max(fc_map_spd))];
   
   % determine corresponding torque to produce the current power
   trqs=cvt_locus_pwr(pwr_index)./(spds+eps);
   
   % make sure all torques are on the map
   trqs=min(trqs,interp1(fc_map_spd,fc_max_trq,spds)); % 5/10/00:tm replace line below - was allowing trqs outside of map to be used
   %trqs=min(trqs,max(fc_map_trq));
   trqs=max(trqs,min(fc_map_trq));
   
   % compute BSFCs corresponding to spd/trq points
   BSFCs=interp2(fc_map_spd,fc_map_trq,fc_fuel_map_gpkWh',spds,trqs);
   
   % correct BSFCs to disallow points beyond the engine's operating range
   BSFCs=(trqs >= interp1(fc_map_spd,fc_max_trq,spds)) * 10000 + BSFCs; % 5/10/00:tm changed > to >=, relates to new limits noted above 
   
   % pick index of best BSFC (choose minimum so that lowest speed will be
   % chosen for given power, leading to reduced losses in other components)
   best_index=min(find(min(BSFCs)==BSFCs));
   
   cvt_locus_spd(pwr_index)=spds(best_index);
   
end % for pwr_index=...

% make cvt_locus_spd=0 if cvt_locus_pwr=0
zero_indices=find(abs(cvt_locus_pwr)<1e-3);
if ~isempty(zero_indices)
   cvt_locus_spd(zero_indices)=zeros(size(zero_indices));
end

% insert max power point as last value
cvt_locus_pwr(length(cvt_locus_pwr))=fc_max_pwr;
cvt_locus_spd(length(cvt_locus_pwr))=fc_map_spd(min(find...
   ((fc_map_spd.*fc_max_trq)==fc_max_pwr))); %5/10/00:tm added min(... in case there's are more than one speed at which max power can be achieved

% insert min power point as first value
cvt_locus_pwr(1)=min(fc_map_spd)*min(fc_map_trq);
cvt_locus_spd(1)=min(fc_map_spd);

%%%%%%%%%%%%%%% START OF SPEED DEPENDENT SHIFTING INFORMATION %%%%%%%%%%%%%

% Data specific for SPEED DEPENDENT SHIFTING in the (PRE_TX) GEARBOX CONTROL 
% BLOCK in VEHICLE CONTROLS <vc>
% --implemented for all powertrains except CVT versions and Toyota Prius (JPN)
%
tx_speed_dep=0;	% Value for the switch in the gearbox control
% 			If tx_speed_dep=1, the speed dependent gearbox is chosen
% 			If tx_speed_dep=0, the engine load dependent gearbox is chosen
%
% Vehicle speed (m/s) where the gearbox has to shift
%tx_1_2_spd=24/3.6;	% converting from km/hr to m/s				
%tx_2_3_spd=40/3.6;
%tx_3_4_spd=64/3.6;
%tx_4_5_spd=75/3.6;
%tx_5_4_spd=75/3.6;
%tx_4_3_spd=64/3.6;
%tx_3_2_spd=40/3.6;
%tx_2_1_spd=tx_1_2_spd;

% first column is speed in m/s, second column is gear number
% note: lookup data should be specified as a step function
% ..... this can be done by repeating values of x (first column, speed)
% ..... for differing values of y (second column, )
% note: division by 3.6 to change from km/hr to m/s

% speeds to use for upshift transition (shifting while accelerating) 
tx_spd_dep_upshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];

% speeds to use for downshift transition (shifting while decelerating)
tx_spd_dep_dnshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];
%%%%%%%%%%%%%%% END OF SPEED DEPENDENT SHIFTING %%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear spds trqs BSFCs fc_max_pwr best_index T w last_index


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/10/98 (MC): adapted from PTC_CONV
% 07/20/98 (MC): updated locus-finding routine
% 08/19/98 (MC): removed condition on computation of fc_fuel_map_gpkWh
% 08/20/98 (MC): improved locus finding routine
% 08/21/98 (MC): introduced calculation of idle speed and launch speed
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/9/99: ss updated the last_index calculation.  Updated the last index to be where
%            the difference in the power vector was <=0 not just <0  if 0 it is not 
%            monotonically increasing which causes problems with interp1 in the next couple lines of code
% 5/10/00:tm modified limits such that trqs must be within the max trq envelope rather than trq map
% 5/10/00:tm modified limit flag (*10000) to correspond to above limit enforcement
% 5/10/00:tm added min(... to handle case when max power can be achieved at multiple speeds
% 5/10/00:tm change number of power divisions from 10 to 20 for better resolution
% 11/03/99:ss updated version from 2.2 to 2.21
% 7/31/01:mpo added variables for speed dependent shifting