% J17_SC03a.M %
% This script builds the speed/time trace that a vehicle must follow in the
% SC03 section of the SAE J1711 draft dated Dec-11-1997.

clear cyc_mph vc_key_on;
cyc_sc03

% 02/22/00:tm lines removed
%pause_durs=[10 10 10 30 10 10 10 30 10 10]*60;  % durations of pauses between consecutive cycles
%pause_keys=[0 0 0 0 0 0 0 0 0 0]; % position of key during each pause
%%% end lines removed

% 02/22/00:tm added to replace above lines
pause_durs=10*60;  % durations of pauses between consecutive cycles
pause_keys=0; % position of key during each pause
%%% end lines added

init_conds_amb             %  load init temperature conds for cold start

if tst==2  % FCT-HEV (full charge test)
   
   ess_init_soc=1;
   
   if 1  % tm:1/3/00 to force vehicle to run complete cycles until engine on 
      
      speed_vec=[cyc_mph(:,2); zeros(pause_durs,1)];
      key_vec=[vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
      for i=1:78 %large number of cycles to run til fc on (will stop sim when fc turns on) (1+78+1)*3.5mi~300mi
         speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs,1)];
         key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs,1)*pause_keys];
      end
      speed_vec=[speed_vec; cyc_mph(:,2)];
      key_vec=[key_vec; vc_key_on(:,2)];
      
   else % old method (tm:1/3/00)
      
      speed_vec=[cyc_mph(:,2)
         zeros(pause_durs(1),1)
         cyc_mph(:,2)
         zeros(pause_durs(2),1)
         cyc_mph(:,2)
         zeros(pause_durs(3),1)
         cyc_mph(:,2)
         zeros(pause_durs(4),1)
         cyc_mph(:,2)
         zeros(pause_durs(5),1)
         cyc_mph(:,2)
         zeros(pause_durs(6),1)
         cyc_mph(:,2)
         zeros(pause_durs(7),1)
         cyc_mph(:,2)];
      
      key_vec=  [vc_key_on(:,2)
         ones(pause_durs(1),1)*pause_keys(1)
         vc_key_on(:,2)
         ones(pause_durs(2),1)*pause_keys(2)
         vc_key_on(:,2)
         ones(pause_durs(3),1)*pause_keys(3)
         vc_key_on(:,2)
         ones(pause_durs(4),1)*pause_keys(2)
         vc_key_on(:,2)
         ones(pause_durs(5),1)*pause_keys(3)
         vc_key_on(:,2)
         ones(pause_durs(6),1)*pause_keys(2)
         vc_key_on(:,2)
         ones(pause_durs(7),1)*pause_keys(3)
         vc_key_on(:,2)];
   end
   
elseif tst==4 %EV
   ess_init_soc=1;
   
   if 1
      
      speed_vec=[cyc_mph(:,2); zeros(pause_durs,1);];
      key_vec=[vc_key_on(:,2); ones(pause_durs,1)*pause_keys;];
      for i=1:78 %large cycle to run to zero SOC (will stop sim when SOC=0) (1+78+1)*3.5mi~300mi
         speed_vec=[speed_vec; cyc_mph(:,2); zeros(pause_durs,1);];
         key_vec=[key_vec; vc_key_on(:,2); ones(pause_durs,1)*pause_keys;];
      end
      speed_vec=[speed_vec; cyc_mph(:,2)];
      key_vec=[key_vec; vc_key_on(:,2)];
      
   else % old method (tm:1/13/00)
      
      speed_vec=[cyc_mph(:,2)];
      key_vec=[vc_key_on(:,2)];
      for i=1:20 %large cycle to run to zero SOC (will stop sim when SOC=0)
         speed_vec=[speed_vec; zeros(pause_durs(1),1);cyc_mph(:,2);zeros(pause_durs(2),1);cyc_mph(:,2);
            zeros(pause_durs(3),1);cyc_mph(:,2);zeros(pause_durs(4),1);cyc_mph(:,2);];
         key_vec=[key_vec; ones(pause_durs(1),1)*pause_keys(1); vc_key_on(:,2);ones(pause_durs(2),1)*pause_keys(2); vc_key_on(:,2);
            ones(pause_durs(3),1)*pause_keys(3); vc_key_on(:,2);ones(pause_durs(4),1)*pause_keys(4); vc_key_on(:,2);];
      end
      
   end
   
else
   if vinf.test.SOC_correctS==0	%specify SOC init only if SOC correct not checked
      ess_init_soc=vinf.test.ess_init_soc.SC03; %user input of SOC init
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
%           for FCT-HEV and FCT-EV modes so that it correctly represents 
%           a process similar to that specified by the j1711 recommended 
%           practice for the UDDS - no recommended practice available for SCO3
% 7/10/99:ss all references to FUDS are now UDDS
