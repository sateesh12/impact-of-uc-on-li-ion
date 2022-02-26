% J17_HFEDSa.M  - 

% This script builds the speed/time trace that a vehicle must follow in the
% HFEDS section of the SAE J1711 draft dated Sep-18-98.

clear cyc_mph vc_key_on;
CYC_HWFET

pause_durs=[0.25 10.0]*60;   % durations of pauses between consecutive cycles
pause_keys=[1 0];     % position of key during each pause

%% PREPARE VEHICLE FOR TEST
init_conds_amb             %  load init temperature conds for cold start

if tst==2 % FCT-HEV (full charge test)
   ess_init_soc=1;
   
   if 1 % tm:1/3/99 to force engine to run until engine on
      speed_vec=[cyc_mph(:,2); zeros(pause_durs(1),1); cyc_mph(:,2); zeros(pause_durs(2),1)];
      key_vec=[vc_key_on(:,2); ones(pause_durs(1),1)*pause_keys(1); vc_key_on(:,2); ones(pause_durs(2),1)*pause_keys(2)];
      for i=1:13 %large cycle to run til fc on (will stop sim when fc turns on) (3+2*13+1)*10.3mi>300mi
         speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs(1),1); cyc_mph(:,2); zeros(pause_durs(2),1)];
         key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs(1),1)*pause_keys(1); vc_key_on(:,2);ones(pause_durs(2),1)*pause_keys(2)];
      end
      speed_vec=[speed_vec; cyc_mph(:,2)];
      key_vec=[key_vec; vc_key_on(:,2)];
   else % old method tm:1/13/00
      speed_vec=[cyc_mph(:,2)
         zeros(pause_durs(1),1)
         cyc_mph(:,2)
         zeros(pause_durs(2),1)
         cyc_mph(:,2)];
      
      key_vec=  [vc_key_on(:,2)
         ones(pause_durs(1),1)*pause_keys(1)
         vc_key_on(:,2)
         ones(pause_durs(2),1)*pause_keys(2)
         vc_key_on(:,2)];
   end
   
   
elseif tst==4 % fct-ev
   ess_init_soc=1;
   
   speed_vec=[cyc_mph(:,2); zeros(pause_durs(1),1); cyc_mph(:,2); zeros(pause_durs(2),1)];
   key_vec=[vc_key_on(:,2); ones(pause_durs(1),1)*pause_keys(1); vc_key_on(:,2); ones(pause_durs(2),1)*pause_keys(2)];
   for i=1:14 %large cycle to run to zero SOC (will stop sim when SOC=0) 3+2*14*10.3mi>300mi
      speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs(1),1); cyc_mph(:,2); zeros(pause_durs(2),1)];
      key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs(1),1)*pause_keys(1); vc_key_on(:,2); ones(pause_durs(2),1)*pause_keys(2)];
   end
   speed_vec=[speed_vec; cyc_mph(:,2)];
   key_vec=[key_vec; vc_key_on(:,2)];
   
else
   if vinf.test.SOC_correctH==0	%specify SOC init only if SOC correct not checked
      ess_init_soc=vinf.test.ess_init_soc.HWFET; %user input of SOC init
   end
  
  speed_vec=[cyc_mph(:,2)
           zeros(pause_durs(1),1)
           cyc_mph(:,2)];

  key_vec=  [vc_key_on(:,2)
           ones(pause_durs(1),1)*pause_keys(1)
           vc_key_on(:,2)];
end

time_vec=[0:length(speed_vec)-1]';
cyc_mph=[time_vec speed_vec];
vc_key_on=[time_vec key_vec];
cyc_avg_time=1;
% accelbool=1;

%%%% CLEAN UP
clear speed_vec time_vec key_vec pause_durs pause_keys

%4/12/99 vhj: added SOC correct initialization
% 1/13/00:tm revised the definition of the cycle 
%           for FCT-HEV and FCT_EV modes so that it correctly represents 
%           the process specified by the j1711 recommended practice
%