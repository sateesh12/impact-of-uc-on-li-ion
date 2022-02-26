% ADVISOR data file:  PTC_PAR_CVT.m
%
% Data source: NREL
%
% Data confirmation:
%
% Notes:
% 
% Created on: June 5,2000
% By:  Tony Markel, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Powertrain Control for CVT-equipped Parallel Hybrid';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_PAR_CVT - ',ptc_description])

if ~exist('update_cs_flag')
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % HYBRID CONTROL STRATEGY
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % engine's idle speed
   vc_idle_spd=0;  % (rad/s)
   % 1=> idling allowed; 0=> engine shuts down rather than
   vc_idle_bool=0;  % (--)
   % 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
   vc_clutch_bool=1; % (--)
   % speed at which engine spins while clutch slips during launch
   vc_launch_spd=max(max(fc_map_spd)/5,1.5*min(fc_map_spd)); % (rad/s)
   % fraction of engine thermostat temperature below which the engine will stay on once it is on
   vc_fc_warm_tmp_frac=0.85; % (--) 
   
   cs_hi_soc=0.7;  % (--), highest desired battery state of charge
   cs_lo_soc=0.5;  % (--), lowest desired battery state of charge
   
   % vehicle speed below which vehicle operates as ZEV
   % at low SOC
   cs_electric_launch_spd_lo=2;  % (m/s)
   % at and above high SOC
   cs_electric_launch_spd_hi=2;  % (m/s)
   
   % req'd torque as a fraction of max trq (at speed) below which engine shuts off,
   % when SOC > cs_lo_soc
   cs_off_trq_frac=0.2;
   
   % torque as a fraction of max trq (at speed) that engine puts out when req'd is
   % below this value, when SOC < cs_lo_soc
   cs_min_trq_frac=0.4;
   
   % engine power fraction above which engine would like to operate
   cs_fc_min_pwr_frac=0.2;
   
   % engine power fraction below which engine would like to operate
   cs_fc_max_pwr_frac=0.8;
   
   % accessory-like power load on engine that goes to recharging the batteries
   % whenever the engine is on and control mode is engine dominate
   cs_charge_pwr=3000; % (W)
   
   % boolean 1=> use charge deplete strategy, 0=> use charge sustaining strategy
   cs_charge_deplete_bool=0; 
   
   % speed above which no engine shut down occurs due to low torque requests
   cs_electric_decel_spd=0;  % (m/s)
   
end

% clean up workspace
clear best* fc_etas
clear best* mc_etas
clear ptc*
clear mc_gen_etas mc_mot_etas
clear sys* best* a b T w fc_outpwr_map mc_outpwr_map fc_mot_eff_map mc_mot_eff_map mc_gen_eff_map

% initialize parameters
resolution=15; % power range will be equally divided into this many pieces
resolution2=20; % speed range will be equally divided into this many pieces
mc_weight=1; % relative importance of motor efficiency (NOT ACTIVE, FUTURE FUNCTIONALITY tm:8/14/00)
fc_weight=1; % relative importance of engine efficiency (NOT ACTIVE, FUTURE FUNCTIONALITY tm:8/14/00)
disp_results=0; % 1==> generate plots, 0==> don't generate plots
manual=0; % 1==> use manually defined vectors, 0==> use automatically generated vectors

% Generate engine efficiency map
fc_pos_spds_index=find(fc_map_spd>eps);
fc_pos_trqs_index=find(fc_map_trq>eps);
[T,w]=meshgrid(fc_map_trq(fc_pos_trqs_index),fc_map_spd(fc_pos_spds_index));
fc_outpwr_map=T.*w;
fc_inpwr_map=fc_fuel_map(fc_pos_spds_index,fc_pos_trqs_index)*fc_fuel_lhv;
fc_mot_eff_map=fc_outpwr_map./fc_inpwr_map;

% Generate motor efficiency maps
%   motoring
mc_pos_spds_index=find(mc_map_spd>eps);
mc_pos_trqs_index=find(mc_map_trq>eps);
[T,w]=meshgrid(mc_map_trq(mc_pos_trqs_index),mc_map_spd(mc_pos_spds_index));
mc_outpwr_map=T.*w;
mc_mot_eff_map=mc_outpwr_map./mc_inpwr_map(mc_pos_spds_index,mc_pos_trqs_index);
%  generating
mc_pos_spds_index=find(mc_map_spd>eps);
mc_neg_trqs_index=find(mc_map_trq<-eps);
[T,w]=meshgrid(mc_map_trq(mc_neg_trqs_index),mc_map_spd(mc_pos_spds_index));
mc_outpwr_map=T.*w;
mc_gen_eff_map=mc_inpwr_map(mc_pos_spds_index,mc_neg_trqs_index)./mc_outpwr_map;

% limit solution space of motor to defined space
if max(mc_max_trq.*mc_overtrq_factor)>=max(mc_map_trq)
   mc_ot_factor=1;
else
   mc_ot_factor=mc_overtrq_factor;
end

% define max generating torque - can be eliminated in the future when block diagram can use unique gen trq curve tm:7/13/00
mc_max_gen_trq=-mc_max_trq*mc_ot_factor; 

% Generate IOL vectors
if manual % if manual==1 then use manually defined vectors else use automatically generated curves
   %
   % Guidelines for Manually Generated IOL's
   % 1) Model requres that all pwr and spd vectors be defined, plus the ptc_fc_mc_iol_trq_vec
   %    (all other vectors are required for plotting purposes)
   % 2) All pwr vectors MUST be monotonically increasing
   % 3) All vectors should be generated to account for any scale factors since they are 
   %    not accounted for in the block diagram.
   % 
   
   % Mode 1: Motor Only - Regen
   ptc_mc_gen_iol_pwr_vec=[0 -2839.3 -7728 -12617 -17505 -22394 -27282 -32171 -37060 -41948 -46837 -51726 -56614 -61503 -66391 -71280 -76169]
   ptc_mc_gen_iol_spd_vec=[373.04 373.04 373.04 373.04 373.04 373.04 448.28 373.04 205.84 230.92 189.12 214.2 230.92 189.12 155.68 172.4 164.04]
   ptc_mc_gen_iol_trq_vec=[0 -61.006 -61.006 -61.006 -61.006 -61.006 -61.006 -86.24 -180.04 -181.66 -247.66 -241.48 -245.17 -325.2 -426.46 -413.46 -464.33]
   
   % Mode 2: Motor Only - Motoring
   ptc_mc_iol_pwr_vec=-1*ptc_mc_gen_iol_pwr_vec;
   ptc_mc_iol_spd_vec=ptc_mc_gen_iol_spd_vec;
   ptc_mc_iol_trq_vec=-1*ptc_mc_gen_iol_trq_vec;
   
   % Mode 3: Engine Only
   ptc_fc_iol_pwr_vec=[0 567.9 5009.6 9451.3 13893 18335 22776 27218 31660 36102 40543 44985 49427 53868 58310 62752 67193]
   ptc_fc_iol_spd_vec=[99.04 99.04 144.16 159.2 136.64 159.2 144.16 166.72 174.24 174.24 189.28 196.8 196.8 196.8 196.8 196.8 407.36]
   ptc_fc_iol_trq_vec=[0 6.7788 34.75 59.367 101.68 115.17 157.99 163.26 181.7 204.71 212.61 216.14 216.14 216.14 216.14 216.14 164.95]
   
   % Mode 4: Engine and Motor
   ptc_fc_mc_iol_pwr_vec=[0 5110.8 14237 23363 32490 41616 50742 59868 68994 78121 87247 96373 1.055e+005 1.1463e+005 1.2375e+005 1.3288e+005 1.42e+005]
   ptc_fc_mc_iol_spd_vec=[84 84 84 84 91.52 91.52 91.52 106.56 121.6 144.16 159.2 151.68 166.72 189.28 241.92 294.56 407.36]
   ptc_fc_mc_iol_trq_vec=[0 7 14 13 13 13 13 14 14 21 70 136 177 212 208 197 164.95]
   ptc_fc_mc_iol_trq_mc_vec=[0 61.006 155.49 265.13 342 441.72 541.44 547.83 553.39 520.9 478.03 499.37 455.79 393.59 303.54 254.11 183.65]
   
else % generate IOL's automatically
   
   % Mode 1: Motor Only - Regen
   sys_max_spd=min(max(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,inf);
   sys_min_spd=max(min(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,-inf);
   %sys_map_spd=[ceil(sys_min_spd):floor(sys_max_spd)];
   sys_map_spd=[ceil(sys_min_spd):(floor(sys_max_spd)-ceil(sys_min_spd))/resolution2:floor(sys_max_spd)];
   mc_max_trq_sys=interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_gen_trq(mc_pos_spds_index)*mc_trq_scale*tc_mc_to_fc_ratio,sys_map_spd);
   sys_max_pwr=(zeros(size(mc_max_trq_sys))+mc_max_trq_sys).*sys_map_spd;
   sys_min_pwr=sys_min_spd*max(mc_map_trq(mc_neg_trqs_index))*mc_trq_scale*tc_mc_to_fc_ratio;
   sys_map_pwr=[sys_min_pwr:(min(sys_max_pwr)-sys_min_pwr)/resolution:min(sys_max_pwr)];
   for a=1:(length(sys_map_pwr)-1)
      sys_trqs=sys_map_pwr(a)./sys_map_spd;
      sys_trqs=min(sys_trqs,max(mc_map_trq(mc_neg_trqs_index))*mc_trq_scale*tc_mc_to_fc_ratio); 
      sys_trqs=max(sys_trqs,interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_gen_trq(mc_pos_spds_index)*mc_trq_scale*tc_mc_to_fc_ratio,sys_map_spd));
      for b=1:length(sys_map_spd)
         mc_etas(b)=interp2(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_map_trq(mc_neg_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_gen_eff_map',sys_map_spd(b),sys_trqs(b));
      end
      mc_eta_max=max(mc_etas);
      mc_etas_norm=mc_eta_max./mc_etas;
      best_spd_index=min(find(mc_etas_norm==min(mc_etas_norm)));
      best_sys_trq_pwr(a)=sys_trqs(best_spd_index);
      best_sys_spd_pwr(a)=sys_map_spd(best_spd_index);
   end
   
   sys_max_pwr_index=min(find(sys_max_pwr==min(sys_max_pwr)));
   
   ptc_mc_gen_iol_pwr_vec=[0 sys_map_pwr(1:end-1) sys_max_pwr(sys_max_pwr_index)];
   ptc_mc_gen_iol_spd_vec=[best_sys_spd_pwr(1) best_sys_spd_pwr sys_map_spd(sys_max_pwr_index)];
   ptc_mc_gen_iol_trq_vec=[0 best_sys_trq_pwr mc_max_trq_sys(sys_max_pwr_index)];
   
   clear best* mc_etas
   
   % Mode 2: Motor Only - Motoring
   sys_max_spd=min(max(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,inf);
   sys_min_spd=max(min(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,-inf);
   %sys_map_spd=[ceil(sys_min_spd):floor(sys_max_spd)];
   sys_map_spd=[ceil(sys_min_spd):(floor(sys_max_spd)-ceil(sys_min_spd))/resolution2:floor(sys_max_spd)];
   mc_max_trq_sys=interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_trq(mc_pos_spds_index)*mc_ot_factor*mc_trq_scale*tc_mc_to_fc_ratio,sys_map_spd);
   sys_max_pwr=(zeros(size(mc_max_trq_sys))+mc_max_trq_sys).*sys_map_spd;
   sys_min_pwr=sys_min_spd*min(mc_map_trq(mc_pos_trqs_index))*mc_trq_scale*tc_mc_to_fc_ratio;
   sys_map_pwr=[sys_min_pwr:(max(sys_max_pwr)-sys_min_pwr)/resolution:max(sys_max_pwr)];
   for a=1:(length(sys_map_pwr)-1)
      sys_trqs=sys_map_pwr(a)./sys_map_spd;
      sys_trqs=min(sys_trqs,interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_trq(mc_pos_spds_index)*mc_ot_factor*mc_trq_scale*tc_mc_to_fc_ratio,sys_map_spd)); 
      sys_trqs=max(sys_trqs,min(mc_map_trq(mc_pos_trqs_index))*mc_trq_scale*tc_mc_to_fc_ratio);
      for b=1:length(sys_map_spd)
         mc_etas(b)=interp2(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_map_trq(mc_pos_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_mot_eff_map',sys_map_spd(b),sys_trqs(b));
      end
      mc_eta_max=max(mc_etas);
      mc_etas_norm=mc_eta_max./mc_etas;
      best_spd_index=min(find(mc_etas_norm==min(mc_etas_norm)));
      best_sys_trq_pwr(a)=sys_trqs(best_spd_index);
      best_sys_spd_pwr(a)=sys_map_spd(best_spd_index);
   end
   
   sys_max_pwr_index=min(find(sys_max_pwr==max(sys_max_pwr)));
   
   ptc_mc_iol_pwr_vec=[0 sys_map_pwr(1:end-1) sys_max_pwr(sys_max_pwr_index)];
   ptc_mc_iol_spd_vec=[best_sys_spd_pwr(1) best_sys_spd_pwr sys_map_spd(sys_max_pwr_index)];
   ptc_mc_iol_trq_vec=[0 best_sys_trq_pwr mc_max_trq_sys(sys_max_pwr_index)];
   
   clear best* mc_etas
   
   % Mode 3: Engine Only
   sys_max_spd=min(max(fc_map_spd(fc_pos_spds_index))*fc_spd_scale,inf);
   sys_min_spd=max(min(fc_map_spd(fc_pos_spds_index))*fc_spd_scale,-inf);
   %sys_map_spd=[ceil(sys_min_spd):floor(sys_max_spd)];
   sys_map_spd=[ceil(sys_min_spd):(floor(sys_max_spd)-ceil(sys_min_spd))/resolution2:floor(sys_max_spd)];
   fc_max_trq_sys=interp1(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_max_trq(fc_pos_spds_index)*fc_trq_scale,sys_map_spd);
   sys_max_pwr=(zeros(size(fc_max_trq_sys))+fc_max_trq_sys).*sys_map_spd;
   sys_min_pwr=sys_min_spd*min(fc_map_trq(fc_pos_trqs_index))*fc_trq_scale;
   sys_map_pwr=[sys_min_pwr:(max(sys_max_pwr)-sys_min_pwr)/resolution:max(sys_max_pwr)];
   for a=1:(length(sys_map_pwr)-1)
      sys_trqs=sys_map_pwr(a)./sys_map_spd;
      sys_trqs=min(sys_trqs,interp1(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_max_trq(fc_pos_spds_index)*fc_trq_scale,sys_map_spd)); 
      sys_trqs=max(sys_trqs,min(fc_map_trq(fc_pos_trqs_index)*fc_trq_scale));
      for b=1:length(sys_map_spd)
         fc_etas(b)=interp2(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_map_trq(fc_pos_trqs_index)*fc_trq_scale,fc_mot_eff_map',sys_map_spd(b),sys_trqs(b));
      end
      fc_eta_max=max(fc_etas);
      fc_etas_norm=fc_eta_max./fc_etas;
      best_spd_index=min(find(fc_etas_norm==min(fc_etas_norm)));
      best_sys_trq_pwr(a)=sys_trqs(best_spd_index);
      best_sys_spd_pwr(a)=sys_map_spd(best_spd_index);
   end
   
   sys_max_pwr_index=min(find(sys_max_pwr==max(sys_max_pwr)));
   
   ptc_fc_iol_pwr_vec=[0 sys_map_pwr(1:end-1) sys_max_pwr(sys_max_pwr_index)];
   ptc_fc_iol_spd_vec=[best_sys_spd_pwr(1) best_sys_spd_pwr sys_map_spd(sys_max_pwr_index)];
   ptc_fc_iol_trq_vec=[0 best_sys_trq_pwr fc_max_trq_sys(sys_max_pwr_index)];
   
   clear best* fc_etas
   
   % Mode 4: Engine and Motor
   mc_max_gen_trq=-mc_max_trq*mc_ot_factor; % placeholder until model updated to use max generating curve tm:6/4/00
   sys_max_spd=min(max(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,max(fc_map_spd(fc_pos_spds_index))*fc_spd_scale);
   sys_min_spd=max(min(mc_map_spd(mc_pos_spds_index))*mc_spd_scale/tc_mc_to_fc_ratio,min(fc_map_spd(fc_pos_spds_index))*fc_spd_scale);
   %sys_map_spd=[ceil(sys_min_spd):floor(sys_max_spd)];
   sys_map_spd=[ceil(sys_min_spd):(floor(sys_max_spd)-ceil(sys_min_spd))/resolution2:floor(sys_max_spd)];
   fc_max_trq_sys=interp1(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_max_trq(fc_pos_spds_index)*fc_trq_scale,sys_map_spd);
   mc_max_trq_sys=interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_trq(mc_pos_spds_index)*mc_ot_factor*tc_mc_to_fc_ratio*mc_trq_scale,sys_map_spd);
   mc_max_gen_trq_sys=interp1(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio,mc_max_gen_trq(mc_pos_spds_index)*tc_mc_to_fc_ratio*mc_trq_scale,sys_map_spd);
   sys_max_pwr=(fc_max_trq_sys+mc_max_trq_sys).*sys_map_spd;
   sys_min_pwr=sys_min_spd*max(min(fc_map_trq(fc_pos_trqs_index))*fc_trq_scale,min(mc_map_trq(mc_pos_trqs_index))*mc_trq_scale*tc_mc_to_fc_ratio);
   sys_map_pwr=[sys_min_pwr:(max(sys_max_pwr)-sys_min_pwr)/resolution:max(sys_max_pwr)];
   for a=1:(length(sys_map_pwr)-1)
      for b=1:length(sys_map_spd)
         sys_trq=sys_map_pwr(a)./sys_map_spd(b);
         sys_trq=min(sys_trq,fc_max_trq_sys(b)+mc_max_trq_sys(b)); 
         sys_trq=max(sys_trq,min(fc_map_trq(fc_pos_trqs_index)*fc_trq_scale));
         fc_trqs=[ceil(min(fc_map_trq(fc_pos_trqs_index))*fc_trq_scale):floor(fc_max_trq_sys(b))];
         mc_trqs=sys_trq-fc_trqs;
         mc_trqs_neg_ltd=max(min(mc_trqs,max(mc_map_trq(mc_neg_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio)),mc_max_gen_trq_sys(b)).*(mc_trqs<0);
         mc_trqs_pos_ltd=max(min(mc_trqs,mc_max_trq_sys(b)),min(mc_map_trq(mc_pos_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio)).*(mc_trqs>=0);
         mc_trqs_ltd=mc_trqs_neg_ltd+mc_trqs_pos_ltd;
         valid_trqs=(mc_trqs==mc_trqs_ltd);
         mc_trqs=mc_trqs_ltd;
         fc_etas=interp2(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_map_trq(fc_pos_trqs_index)*fc_trq_scale,fc_mot_eff_map',sys_map_spd(b),fc_trqs);
         %fc_eta_max=max(fc_etas);
         %fc_etas_norm=fc_eta_max./fc_etas;
         mc_trqs_pos=find(mc_trqs>=0);
         mc_trqs_neg=find(mc_trqs<0);
         mc_mot_etas=zeros(size(mc_trqs));
         mc_gen_etas=zeros(size(mc_trqs));
         if ~isempty(mc_trqs_pos)
            mc_mot_etas(mc_trqs_pos)=interp2(mc_map_spd(mc_pos_spds_index)/tc_mc_to_fc_ratio*mc_spd_scale,mc_map_trq(mc_pos_trqs_index)*tc_mc_to_fc_ratio*mc_trq_scale,mc_mot_eff_map',sys_map_spd(b),mc_trqs(mc_trqs_pos));
         end
         if ~isempty(mc_trqs_neg)
            mc_gen_etas(mc_trqs_neg)=interp2(mc_map_spd(mc_pos_spds_index)/tc_mc_to_fc_ratio*mc_spd_scale,mc_map_trq(mc_neg_trqs_index)*tc_mc_to_fc_ratio*mc_trq_scale,mc_gen_eff_map',sys_map_spd(b),mc_trqs(mc_trqs_neg));
         end
         %mc_etas=[mc_mot_etas; mc_gen_etas];
         %mc_mot_etas=[mc_mot_etas; zeros(size(mc_trqs_neg))'];
         %mc_gen_etas=[zeros(size(mc_trqs_pos))'; mc_gen_etas];
         %mc_eta_max=max(mc_etas);
         %mc_etas_norm=mc_eta_max./mc_etas;
         sys_outpwr=sys_map_spd(b)*(fc_trqs+mc_trqs-mc_trqs.*mc_gen_etas.*(mc_trqs<0));
         sys_inpwr=sys_map_spd(b)*(fc_trqs./fc_etas'+mc_trqs.*(mc_trqs>=0)./(mc_mot_etas+eps));
         sys_shaft_pwr=sys_map_spd(b)*(fc_trqs+mc_trqs);
         sys_etas=sys_outpwr./sys_inpwr.*(sys_shaft_pwr>=sys_map_pwr(a)).*(valid_trqs);
         %sys_etas=mc_weight*mc_mot_etas+fc_weight*fc_etas.*(mc_trqs'>=0)+mc_weight*mc_gen_etas.*fc_etas*fc_weight;
         sys_eta_max=max(sys_etas);
         sys_etas_norm=sys_eta_max./(sys_etas+eps);
         %sys_etas_norm=sys_eta_max./sys_etas*(fc_weight+mc_weight);
         %sys_etas_norm=(mc_weight*mc_etas_norm+fc_weight*fc_etas_norm)/(fc_weight+mc_weight);
         best_fc_trq_index(b)=min(find(sys_etas_norm==min(sys_etas_norm)));
         best_fc_trq(b)=fc_trqs(best_fc_trq_index(b));
         best_mc_trq(b)=mc_trqs(best_fc_trq_index(b));
         best_fc_eff_spd(b)=interp2(fc_map_spd(fc_pos_spds_index)*fc_spd_scale,fc_map_trq(fc_pos_trqs_index)*fc_trq_scale,fc_mot_eff_map',sys_map_spd(b),best_fc_trq(b));
         if best_mc_trq(b)>eps
            best_mc_eff_spd(b)=interp2(mc_map_spd(mc_pos_spds_index)/tc_mc_to_fc_ratio*mc_spd_scale,mc_map_trq(mc_pos_trqs_index)*tc_mc_to_fc_ratio*mc_trq_scale,mc_mot_eff_map',sys_map_spd(b),best_mc_trq(b));
         else
            best_mc_eff_spd(b)=interp2(mc_map_spd(mc_pos_spds_index)/tc_mc_to_fc_ratio*mc_spd_scale,mc_map_trq(mc_neg_trqs_index)*tc_mc_to_fc_ratio*mc_trq_scale,mc_gen_eff_map',sys_map_spd(b),best_mc_trq(b));
         end
         clear mc_gen_etas mc_mot_etas
      end
      sys_outpwr=sys_map_spd.*(best_fc_trq+best_mc_trq-best_mc_trq.*best_mc_eff_spd.*(best_mc_trq<0));
      sys_inpwr=sys_map_spd.*(best_fc_trq./best_fc_eff_spd+best_mc_trq.*(best_mc_trq>=0)./(best_mc_eff_spd+eps));
      sys_shaft_pwr=sys_map_spd.*(best_fc_trq+best_mc_trq);
      sys_etas=sys_outpwr./sys_inpwr.*(sys_shaft_pwr>=sys_map_pwr(a));
      %sys_etas=mc_weight*mc_mot_etas+fc_weight*fc_etas.*(mc_trqs'>=0)+mc_weight*mc_gen_etas.*fc_etas*fc_weight;
      sys_eta_max=max(sys_etas);
      sys_etas_norm=sys_eta_max./(sys_etas+eps);
      %fc_eta_max=max(best_fc_eff_spd);
      %fc_etas_norm=fc_eta_max./best_fc_eff_spd;
      %mc_eta_max=max(best_mc_eff_spd);
      %mc_etas_norm=mc_eta_max./best_mc_eff_spd;
      %sys_etas_norm=(mc_weight*mc_etas_norm+fc_weight*fc_etas_norm)/(fc_weight+mc_weight);
      best_spd_index=min(find(sys_etas_norm==min(sys_etas_norm)));
      best_fc_trq_pwr(a)=best_fc_trq(best_spd_index);
      best_mc_trq_pwr(a)=best_mc_trq(best_spd_index);
      best_sys_spd_pwr(a)=sys_map_spd(best_spd_index);
   end
   
   sys_max_pwr_index=min(find(sys_max_pwr==max(sys_max_pwr)));
   
   ptc_fc_mc_iol_pwr_vec=[0 sys_map_pwr(1:end-1) sys_max_pwr(sys_max_pwr_index)];
   ptc_fc_mc_iol_spd_vec=[best_sys_spd_pwr(1) best_sys_spd_pwr sys_map_spd(sys_max_pwr_index)];
   ptc_fc_mc_iol_trq_vec=[0 best_fc_trq_pwr fc_max_trq_sys(sys_max_pwr_index)];
   ptc_fc_mc_iol_trq_mc_vec=[0 best_mc_trq_pwr mc_max_trq_sys(sys_max_pwr_index)];
   
end % if manual...

if disp_results
   
   figure
   plot(ptc_mc_gen_iol_spd_vec*30/pi,ptc_mc_gen_iol_trq_vec,'bx-.')
   hold
   plot(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_max_gen_trq(mc_pos_spds_index)*mc_trq_scale*tc_mc_to_fc_ratio,'k-')
   c=contour(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_map_trq(mc_neg_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_gen_eff_map');
   clabel(c)
   xlabel('Speed (RPM)')
   ylabel('Torque (Nm)')
   legend('IOL')
   title('Motor Only - Generating')
   
   figure
   plot(ptc_mc_iol_spd_vec*30/pi,ptc_mc_iol_trq_vec,'bx-.')
   hold
   plot(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_max_trq(mc_pos_spds_index)*mc_ot_factor*tc_mc_to_fc_ratio*mc_trq_scale,'k-')
   c=contour(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_map_trq(mc_pos_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_mot_eff_map');
   clabel(c)
   xlabel('Speed (RPM)')
   ylabel('Torque (Nm)')
   legend('IOL')
   title('Motor Only - Motoring')
   
   figure
   plot(ptc_fc_iol_spd_vec*30/pi,ptc_fc_iol_trq_vec,'bx-.')
   hold
   plot(fc_map_spd(fc_pos_spds_index)*fc_spd_scale*30/pi,fc_max_trq(fc_pos_spds_index)*fc_trq_scale,'k-')
   c=contour(fc_map_spd(fc_pos_spds_index)*fc_spd_scale*30/pi,fc_map_trq(fc_pos_trqs_index)*fc_trq_scale,fc_mot_eff_map');
   clabel(c)
   xlabel('Speed (RPM)')
   ylabel('Torque (Nm)')
   legend('IOL')
   title('Engine Only - Motoring')
   
   figure
   plot(ptc_fc_mc_iol_spd_vec*30/pi,ptc_fc_mc_iol_trq_vec,'bx-.')
   hold
   plot(fc_map_spd(fc_pos_spds_index)*fc_spd_scale*30/pi,fc_max_trq(fc_pos_spds_index)*fc_trq_scale,'k-')
   c=contour(fc_map_spd(fc_pos_spds_index)*30/pi*fc_spd_scale,fc_map_trq(fc_pos_trqs_index)*fc_trq_scale,fc_mot_eff_map');
   clabel(c)
   xlabel('Speed (RPM)')
   ylabel('Torque (Nm)')
   legend('IOL')
   title('Engine and Motor - Engine')
   
   figure
   plot(ptc_fc_mc_iol_spd_vec*30/pi,(ptc_fc_mc_iol_pwr_vec./ptc_fc_mc_iol_spd_vec-ptc_fc_mc_iol_trq_vec),'bx-.')
   hold
   plot(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_max_trq(mc_pos_spds_index)*mc_trq_scale*mc_ot_factor*tc_mc_to_fc_ratio,'k-')
   plot(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_max_gen_trq(mc_pos_spds_index)*mc_trq_scale*tc_mc_to_fc_ratio,'k-')
   c=contour(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_map_trq(mc_pos_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_mot_eff_map');
   c=contour(mc_map_spd(mc_pos_spds_index)*mc_spd_scale/tc_mc_to_fc_ratio*30/pi,mc_map_trq(mc_neg_trqs_index)*mc_trq_scale*tc_mc_to_fc_ratio,mc_gen_eff_map');
   clabel(c)
   xlabel('Speed (RPM)')
   ylabel('Torque (Nm)')
   legend('IOL')
   title('Engine and Motor - Motor')
   
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

   
end % if disp_results ...

% clean-up workspace
clear sys* best* a b T w fc_outpwr_map mc_outpwr_map fc_mot_eff_map 
clear mc_mot_eff_map mc_gen_eff_map mc_ot_factor
clear resolution resolution2 mc_weight fc_weight disp_results manual

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06/04/00 (TM): adapted from PTC_CONVCVT
% 7/12/00:tm added section to override use of mc_overtrq_factor if 
% 				it forces operation outside of defined region
% 8/14/00:tm added ability to switch between manually and automatically generated IOL's
% 8/14/00:tm added ability to disable informational plots
% 8/14/00:tm reduced the speed resolution from 50 to 20 points to speed data processing
% 8/14/00:tm removed cs_charge_trq variable - not used in this strategy
% 8/16/00:tm removed cs_offset_soc - no longer used in block diagram
% 8/16/00:tm introduced cs_electric_launch_spd_lo and _hi to replace cs_electric_launch_spd
% 8/16/00:tm introduced vc_fc_warm_tmp_frac to control engine on state based on coolant temperature

% 11/1/00:tm introduced cs_electric_decel_spd to prevent engine shutdown at high speeds
% 7/31/01:mpo added variables for speed dependent shifting
