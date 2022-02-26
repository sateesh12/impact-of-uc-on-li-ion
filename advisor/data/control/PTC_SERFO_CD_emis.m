% ADVISOR data file:  PTC_SERFO_emis.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a series hybrid using a follower control strategy.
% This file equally weights the importance of fuel economy and each emissions 
% element in determining the optimum operational design curve.
% To ensure proper operation, this file must be reloaded every time the FC or
% GC is rescaled.
% 
% Created on: 10/25/99
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ptc_version=2003; % version of ADVISOR for which the file was generated

if ~exist('update_cs_flag')
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Powertrain control for series hybrid w/ power follower cs including emissions';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_SERFO_emis - ',ptc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=0;  % (rad/s), engine's idle speed


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fractional engine load {=(torque)/(max torque at speed)} above which a
% downshift is called for, indexed by gb_gearN_dnshift_spd
gb_gear1_dnshift_load=[2 2];  % (--)
gb_gear2_dnshift_load=[2 2];  % (--)
% fractional engine load {=(torque)/(max torque at speed)} below which an
% upshift is called for, indexed by gb_gearN_upshift_spd
gb_gear1_upshift_load=[-1 -1];  % (--)
gb_gear2_upshift_load=[-1 -1];  % (--)
gb_gear1_dnshift_spd=[0 1000];  % (rad/s)
gb_gear2_dnshift_spd=[0 1000];  % (rad/s)
gb_gear1_upshift_spd=[0 1000];  % (rad/s)
gb_gear2_upshift_spd=[0 1000];  % (rad/s)

% convert old shift commands to new shift commands
gb_upshift_spd={gb_gear1_upshift_spd; ...
      gb_gear2_upshift_spd};  % (rad/s)
gb_upshift_load={gb_gear1_upshift_load; ...
      gb_gear2_upshift_load};  % (--)
gb_dnshift_spd={gb_gear1_dnshift_spd; ...
      gb_gear2_dnshift_spd};  % (rad/s)
gb_dnshift_load={gb_gear1_dnshift_load; ...
      gb_gear2_dnshift_load};  % (--)

clear gb_gear*shift* % remove unnecessary data

% fixes the difference between number of shift vectors and gears in gearbox
if length(gb_upshift_spd)<length(gb_ratio)
   start_pt=length(gb_upshift_spd);
   for x=1:length(gb_ratio)-length(gb_upshift_spd)
      gb_upshift_spd{x+start_pt}=gb_upshift_spd{1};
      gb_upshift_load{x+start_pt}=gb_upshift_load{1};
      gb_dnshift_spd{x+start_pt}=gb_dnshift_spd{1};
      gb_dnshift_load{x+start_pt}=gb_dnshift_load{1};
   end
end

% duration of shift during which no torque can be transmitted
gb_shift_delay=0;  % (s), no delay since no shifts; this is a 1-spd


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ess_init_soc=0.7;  % (--), initial battery SOC; this is inputed from the simulation screen now
cs_hi_soc=0.8;  % (--), highest desired battery state of charge
cs_lo_soc=0.1;  % (--), lowest desired battery state of charge
cs_fc_init_state=0;  % (--), initial FC state; 1=> on, 0=> off
% (W), minimum operating power for genset
cs_min_pwr=max(fc_max_trq.*fc_map_spd)*.15;
% (W), maximum operating power for genset (exceeded only if SOC<cs_lo_soc)
cs_max_pwr=max(fc_max_trq.*fc_map_spd)*.55;
% (W), extra power output by genset when (cs_lo_soc+cs_hi_soc)/2-SOC=1 
cs_charge_pwr=0;
% (s), minimum time genset remains off, enforced unless SOC<=cs_lo_soc
cs_min_off_time=0;
% (W/s), maximum rate of increase of genset power
cs_max_pwr_rise_rate=5000;
% (W/s), maximum rate of decrease of genset power
cs_max_pwr_fall_rate=-3000;

cs_charge_deplete_bool=1; % boolean 1=> use charge deplete strategy, 0=> use charge sustaining strategy

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute locus of best efficiency points
%

%
% compute engine efficiency map for use in genset control
%
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_outpwr_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./(fc_outpwr_map_kW+eps)*3600;
fc_co_map_gpkWh=fc_co_map./(fc_outpwr_map_kW+eps)*3600;
fc_hc_map_gpkWh=fc_hc_map./(fc_outpwr_map_kW+eps)*3600;
fc_nox_map_gpkWh=fc_nox_map./(fc_outpwr_map_kW+eps)*3600;
fc_pm_map_gpkWh=fc_pm_map./(fc_outpwr_map_kW+eps)*3600;
% if zero speed is in map, replace associated data with nearest BSFC*4
if min(fc_map_spd)<eps
   fc_fuel_map_gpkWh(1,:)=fc_fuel_map_gpkWh(2,:)*4;
   fc_co_map_gpkWh(1,:)=fc_co_map_gpkWh(2,:)*4;
   fc_hc_map_gpkWh(1,:)=fc_hc_map_gpkWh(2,:)*4;
   fc_nox_map_gpkWh(1,:)=fc_nox_map_gpkWh(2,:)*4;
   fc_pm_map_gpkWh(1,:)=fc_pm_map_gpkWh(2,:)*4;
end
% if zero torque is in map, replace associated data with nearest BSFC*4
if min(fc_map_trq)<eps
   fc_fuel_map_gpkWh(:,1)=fc_fuel_map_gpkWh(:,2)*4;
   fc_co_map_gpkWh(:,1)=fc_co_map_gpkWh(:,2)*4;
   fc_hc_map_gpkWh(:,1)=fc_hc_map_gpkWh(:,2)*4;
   fc_nox_map_gpkWh(:,1)=fc_nox_map_gpkWh(:,2)*4;
   fc_pm_map_gpkWh(:,1)=fc_pm_map_gpkWh(:,2)*4;
end

% Define the weighting algorithm to be used in defining the design curve
weight=[1 1 1 1 1]; % weighting factor for fc,co,hc,nox,pm in function
%weight=[1 0 0 0 0]; % weighting factor for fc,co,hc,nox,pm in function
%weight=[0 1 0 0 0]; % weighting factor for fc,co,hc,nox,pm in function
%weight=[0 0 1 0 0]; % weighting factor for fc,co,hc,nox,pm in function
%weight=[0 0 0 1 0]; % weighting factor for fc,co,hc,nox,pm in function
%weight=[0 0 0 0 1]; % weighting factor for fc,co,hc,nox,pm in function

%
% compute allowable genset torques and speeds
% (these are limited by the max torque envelopes of the FC and GC, and by the
% extents of their maps)
%
temp1=min([max(fc_map_trq)*fc_trq_scale max(gc_map_trq)*gc_trq_scale]);
temp2=max([min(fc_map_trq)*fc_trq_scale min(gc_map_trq)*gc_trq_scale]);
genset_map_trq=[temp2:(temp1-temp2)/10:temp1];

temp1=min([max(fc_map_spd)*fc_spd_scale max(gc_map_spd)*gc_spd_scale]);
temp2=max([min(fc_map_spd)*fc_spd_scale min(gc_map_spd)*gc_spd_scale]);
genset_map_spd=[temp2:(temp1-temp2)/10:temp1];

temp1=interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,genset_map_spd);
temp2=interp1(gc_map_spd*gc_spd_scale,gc_max_trq*gc_trq_scale,genset_map_spd);
genset_max_trq=min([temp1;temp2]);

% compute genset BSFC map
temp1=interp2(gc_map_trq*gc_trq_scale,gc_map_spd'*gc_spd_scale,gc_eff_map,...
   genset_map_trq,genset_map_spd');
temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
   fc_fuel_map_gpkWh,genset_map_trq,genset_map_spd');
genset_BSFC_map=temp2./(temp1+eps);
temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
   fc_co_map_gpkWh,genset_map_trq,genset_map_spd');
genset_BSCO_map=temp2./(temp1+eps);
temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
   fc_hc_map_gpkWh,genset_map_trq,genset_map_spd');
genset_BSHC_map=temp2./(temp1+eps);
temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
   fc_nox_map_gpkWh,genset_map_trq,genset_map_spd');
genset_BSNOX_map=temp2./(temp1+eps);
temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
   fc_pm_map_gpkWh,genset_map_trq,genset_map_spd');
genset_BSPM_map=temp2./(temp1+eps);

% Define power vector
genset_max_pwr=max(genset_map_spd.*...
   (min([genset_max_trq;ones(size(genset_max_trq))*max(genset_map_trq)])));
%genset_max_pwr=min(max(genset_map_spd.*genset_max_trq),...
  % max(genset_map_spd)*max(genset_map_trq));
genset_min_pwr=min(genset_map_spd)*min(genset_map_trq);
cs_pwr=[genset_min_pwr:(genset_max_pwr-genset_min_pwr)/10:genset_max_pwr];

% Loop on power
for pwr_index=2:length(cs_pwr-1)
   
   % consider every integer speed in the map
   spds=[ceil(min(genset_map_spd)):floor(max(genset_map_spd))];
   
   % determine corresponding torque to produce the current power
   trqs1=cs_pwr(pwr_index)./(spds+eps);
   
   % make sure all torques are on the map
   trqs2=min(trqs1,max(genset_map_trq));
   trqs2=max(trqs2,min(genset_map_trq));
   
   % compute BSFCs corresponding to spd/trq points
   BSFCs=interp2(genset_map_spd,genset_map_trq,genset_BSFC_map',spds,trqs2);
   BSCOs=interp2(genset_map_spd,genset_map_trq,genset_BSCO_map',spds,trqs2);
   BSNOXs=interp2(genset_map_spd,genset_map_trq,genset_BSNOX_map',spds,trqs2);
   BSHCs=interp2(genset_map_spd,genset_map_trq,genset_BSHC_map',spds,trqs2);
   BSPMs=interp2(genset_map_spd,genset_map_trq,genset_BSPM_map',spds,trqs2);
   
   % correct BSFCs to disallow points beyond the engine's or generator's
   % (continuous) operating range
   error_term=(trqs1 > interp1(fc_map_spd*fc_spd_scale,...
      fc_max_trq*fc_trq_scale,spds)) * 10000 ...
      + (trqs1 > interp1(gc_map_spd*gc_spd_scale,gc_max_trq*gc_trq_scale,...
      spds)) * 10000;
   BSFCs=BSFCs + error_term;
   BSCOs=BSCOs + error_term;
   BSHCs=BSHCs + error_term;
   BSNOXs=BSNOXs + error_term;
   BSPMs=BSPMs + error_term;
   
   if any(isnan(BSFCs))
      error('Error in PTC_SERFO: couldn''t compute genset eff. map')
   end
   
   % pick index of best BSFC (choose minimum so that lowest speed will be
   % chosen for given power, leading to reduced losses in other components)
   BSFCs=BSFCs/min(BSFCs);
   if nnz(fc_co_map)
      BSCOs=BSCOs/min(BSCOs);
   else
      BSCOs=zeros(size(BSCOs));
      weight(2)=0;
   end
   if nnz(fc_hc_map)
      BSHCs=BSHCs/min(BSHCs);
   else
      BSHCs=zeros(size(BSHCs));
      weight(3)=0;
   end
   if nnz(fc_nox_map)
      BSNOXs=BSNOXs/min(BSNOXs);
   else
      BSNOXs=zeros(size(BSNOXs));
      weight(4)=0;
   end
   if nnz(fc_pm_map)
      BSPMs=BSPMs/min(BSPMs);
   else
      BSPMs=zeros(size(BSPMs));
      weight(5)=0;
   end
   
   combined_function=(BSFCs*weight(1)+BSCOs*weight(2)+BSHCs*weight(3)+BSNOXs*weight(4)+BSPMs*weight(5))/sum(weight);
   
   best_index=min(find(min(combined_function)==combined_function));
   
   cs_spd(pwr_index)=spds(best_index);
   
end % for pwr_index=...

% make cvt_locus_spd=0 if cvt_locus_pwr=0
zero_indices=find(abs(cs_pwr)<1e-3);
if ~isempty(zero_indices)
   cs_spd(zero_indices)=zeros(size(zero_indices));
end

% insert max power point as last value
cs_pwr(length(cs_pwr))=genset_max_pwr;
if genset_max_pwr==max(genset_map_spd.*genset_max_trq)
   cs_spd(length(cs_pwr))=genset_map_spd(find...
      ((genset_map_spd.*genset_max_trq)==genset_max_pwr));
else
   cs_spd(length(cs_pwr))=max(genset_map_spd);
end

% insert min power point as first value
cs_pwr(1)=min(genset_map_spd)*min(genset_map_trq);
cs_spd(1)=min(genset_map_spd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT RESULTS OF LOCUS FINDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
   c=contour(genset_map_spd*30/pi,genset_map_trq,genset_BSFC_map',[200:20:400]);
   hold on
   plot(genset_map_spd*30/pi,genset_max_trq,'rx')
   plot(cs_spd*30/pi,cs_pwr./cs_spd,'.')
   plot(fc_map_spd*fc_spd_scale*30/pi,fc_max_trq*fc_trq_scale,'r')
   plot(gc_map_spd*gc_spd_scale*30/pi,gc_max_trq*gc_trq_scale)
   set(gca,'Ylim',[min(genset_map_trq) ...
         max([gc_max_trq*gc_trq_scale fc_max_trq*fc_trq_scale])])
end

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
clear T w fc_outpwr_map best_at_each_trq best_trq_index
clear best_at_each_spd best_spd_index
clear genset_max_pwr genset_max_trq genset_map_spd genset_map_trq
clear temp1 temp2 first_index last_index genset_BSFC_map
clear genset_min_pwr best_index
clear weight
%clear *map_gpkWh
clear BS*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 09/13/98:MC updated CLEAN UP section to remove leftover vars
% 09/14/98:MC set cs_fc_init_state to 0 (off)
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 10/16/99:tm added capability to include emissions criteria
% 11/03/99:ss updated version from 2.2 to 2.21
% 1/12/00:tm introduced cs_charge_deplete_bool
% 8/21/00:tm added statements to calculate the gpkWh data for all emissions
% 7/31/01:mpo added variables for speed dependent shifting
