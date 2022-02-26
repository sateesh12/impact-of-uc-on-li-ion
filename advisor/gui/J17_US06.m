% J17_US06a.M
%
% This script builds the speed/time trace that a vehicle must follow in the
% US06 section of the SAE J1711 draft dated 9/18/98.

clear cyc_mph vc_key_on;
cyc_us06

pause_durs=2*60;    % duration of pauses between consecutive cycles
pause_keys=1;       % position of key during each pause

%% PREPARE VEHICLE FOR TEST

init_conds_amb             %  load init temperature conds for cold start

if tst==2  % FCT-HEV (full charge test)
   
   ess_init_soc=1;
   
   if 1  % tm:1/13/00 to force vehicle to run complete cycles until engine on 
      
      speed_vec=[cyc_mph(:,2); zeros(pause_durs,1)];
      key_vec=[vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
      for i=1:35 %large number of cycles to run til fc on (will stop sim when fc turns on) (1+35+1)*8mi~300mi
         speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs,1)];
         key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
      end
      speed_vec=[speed_vec; cyc_mph(:,2)];
      key_vec=[key_vec; vc_key_on(:,2)];
      
   else % old method (tm:1/3/00)
      
      speed_vec=[cyc_mph(:,2)
         zeros(pause_durs,1)
         cyc_mph(:,2)
         zeros(pause_durs,1)
         cyc_mph(:,2)
         zeros(pause_durs,1)
         cyc_mph(:,2)];
      
      key_vec=  [vc_key_on(:,2)
         ones(pause_durs,1)*pause_keys
         vc_key_on(:,2)
         ones(pause_durs,1)*pause_keys
         vc_key_on(:,2)
         ones(pause_durs,1)*pause_keys
         vc_key_on(:,2)];
   end
   
elseif tst==4 % fct-ev
   ess_init_soc=1;
   
   speed_vec=[cyc_mph(:,2); zeros(pause_durs,1)];
   key_vec=[vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
   for i=1:35 %large cycle to run to zero SOC (will stop sim when SOC=0) (1+35+1)*8mi~300mi
      speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs,1)];
      key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
   end
   speed_vec=[speed_vec; cyc_mph(:,2)];
   key_vec=[key_vec; vc_key_on(:,2)];
   
else   % if PCT (partial-charge)
   if vinf.test.SOC_correctU==0	%specify SOC init only if SOC correct not checked
      ess_init_soc=vinf.test.ess_init_soc.US06; %user input of SOC init
   end
  
  speed_vec=[cyc_mph(:,2)
           zeros(pause_durs,1)
           cyc_mph(:,2)];

  key_vec=  [vc_key_on(:,2)
           ones(pause_durs,1)*pause_keys
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
%           a process similar to that specified by the j1711 recommended 
%           practice for the HWY - no recommended practice available for US06
%