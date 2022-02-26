% J17_TPa.M 
% Runs a vehicle, which is already loaded in the Matlab workspace, over the
% tests (PCT-HEV, FCT-HEV, PCT-CV, and FCT-EV) of the SAE J1711 
%
% As a result of this test, the following will be defined:
%       mpha      achieved speed on the XX portion of the test
%       mphr      requested speed on the XX portion of the test
%       galpmi    equivalent fuel use in gal/mi on the XX
%               including the fuel equivalent of the energy req'd to recharge
%               the batteries as appropriate to the DPT
%       mi        distance traveled on XX portion of test, miles
%       gal       actual fuel use on XX portion of test
%       kWh       energy necessary to recharge the batteries for XX
%               portion of test
%       SOC       SOC vs. time trace for XX portion of test
%       emis      tailpipe pollutants vs. time for XX portion
%       HC_gpmi   HC grams per mile for XX portion
%       CO_gpmi   CO grams per mile for XX portion
%       NOx_gpmi  NOx grams per mile for XX portion
%       testtime_s   total duration of test in s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%K_E=38.322;     % kWh/gallon for gasoline
K_E=33.440;     % kWh/gallon for gasoline; revised 6/28/00 by tm based on published 3/99 SAE J1711 document
cycle=[ 'J17_UDDS '; 'J17_HFEDS'; 'J17_US06 '; 'J17_SC03 ' ];
tests=[' Partial Charge Test (PCT)-HEV' ;...
      ' Full Charge Test (FCT) - HEV ' ;...
      ' PCT-Conventional (CV)        ' ;...
      ' FCT-Electric Vehicle (EV)    '];
j_mi=zeros(4,4);
j_zev_mi=zeros(4,4);
j_galpmi=zeros(4,4);
j_HC_gpmi=zeros(4,4);
j_CO_gpmi=zeros(4,4);
j_NOx_gpmi=zeros(4,4);
j_PM_gpmi=zeros(4,4);
j_SOC_init=zeros(4,4);
j_SOC_pause=zeros(4,4);
j_SOC_end=zeros(4,4);
    
for tst=1:4 %loop through tests
   
   if mode_run(tst)==1 %if desired mode needs to be run
      disp(' ');
      disp(tests(tst,:));
      if tst==3 | tst==1 % pct
         begin_t=[1 781 722 1190]; %times to begin counting (for emis, etc), fcn of cyc
      else 
         begin_t=[1 1 1 1]; %always begin fct at t=1sec
      end   
      
      for cyc=1:4 %loop through cycles
         disp(['  Running ',cycle(cyc,:)]);
         eval(cycle(cyc,:)); % loads appropriate cycle
         init_string('begin');
         %add AC accessory load
         
         % 02/22/00:tm added to setup run length parameters run complete cycles after minimum number of cycles if necessary
         if tst==2 % FCT-HEV run until engine comes on (tm:1/3/00)
            enable_stop_fc=1;
            j17_endtimes=[];
            if cyc~=2
               if cyc==1
                  cyc_length=1372; % length of UDDS
                  pause_length=10*60; % length of pause between UDDS cycles
                  min_cycles=4; % specified in J1711 4*7.5~30mi
                  max_cycles=40; % not specified in J1711 40*7.5~300mi
               elseif cyc==3
                  cyc_length=600; % length of USO6
                  pause_length=2*60; % length of pause between USO6 cycles
                  min_cycles=4; % not specified in J1711 4*8~30mi
                  max_cycles=37; % not specified in J1711 37*8~300mi
               elseif cyc==4
                  cyc_length=594; % length of SCO3
                  pause_length=10*60; % length of pause between UDDS cycles
                  min_cycles=8; % not specified in J1711 8*3.5~30mi
                  max_cycles=80; % not specified in J1711 80*3.5~300mi
               end 
               for x=min_cycles:max_cycles 
                  j17_endtimes=[j17_endtimes x*cyc_length+(x-1)*pause_length];
               end
            else % cyc==2
               cyc_length=765; % length of hwy
               pause_length=[0.25*60 10*60]; % length of pauses between hwy cycles
               min_cycles=3; % specified in J1711 3*10.3~30mi
               max_cycles=30; % not specified in J1711 30*10.3~300mi
               for x=min_cycles:max_cycles 
                  if rem(x,2)
                     j17_endtimes=[j17_endtimes x*cyc_length+(x-2)*pause_length(1)+(x-2)*pause_length(2)];
                  else
                     j17_endtimes=[j17_endtimes x*cyc_length+(x-1)*pause_length(1)+(x-2)*pause_length(2)];
                  end
               end
            end
            
            %%% start added 6/28/00:tm
            %j17_endtimes=[0 0]; % disables the settings above - don't enforce complete cycles
            % this is not specified in J1711 but was determined by HEV/WG to be an appropriate modification
            %%% end added 6/28/00:tm
            
         else
            enable_stop_fc=0;
            j17_endtimes=[inf inf]; % n/a
         end
         %%% end added 02/22/00:tm
         
         if tst==1 % pct-hev
            %run SOC correct if desired (checkbox was checked)
            if (vinf.test.SOC_correctF==1&cyc==1)|(vinf.test.SOC_correctH==1&cyc==2)|...
                  (vinf.test.SOC_correctU==1&cyc==3)|(vinf.test.SOC_correctS==1&cyc==4)
               assignin('base','soc_t',begin_t(cyc));
               vinf.cycle.soc='on';
               vinf.cycle.socmenu='zero delta'; %pct with zero delta soc correct
            end
            gui_run;
            vinf.cycle.soc='off';
         else
            if tst==3 %CV
               ess_init_soc=0.5;
            end
            gui_run;
         end   
         init_string('end');
         
         sim('bd_btyrc',100000)   % calc bat recharge
         
         %length(mpha) % tm:1/3/99 debug statement
         
         %check for failed trace
         chktrace
         if missed_trace
            last_good_index=first_miss_index-1;
         else
            last_good_index=length(mpha);
         end
         good_indices=[1:last_good_index];
         %Ah_used=Ah_used(good_indices); % adjust Ah-used to account for end of trace
         
         % Outputs of cycles and post processing
         j_mi(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),mpha(begin_t(cyc):last_good_index))/3600;
         j_mpha=mpha(begin_t(cyc):last_good_index);
         j_mphr=cyc_mph_r(begin_t(cyc):last_good_index);
         j_gal(cyc,tst)=gal(last_good_index)-gal(begin_t(cyc));
         j_kWh(cyc,tst)=recharge_kWh;
         j_SOC_init(cyc,tst)=ess_soc_hist(1);
         j_SOC_pause(cyc,tst)=ess_soc_hist(begin_t(cyc));
         j_SOC_end(cyc,tst)=ess_soc_hist(last_good_index);
         %j_galps(cyc,tst)=hpu_fuelrate_in_a(begin_t(cyc):last_good_index);
         j_emis=emis(begin_t(cyc):last_good_index,:);
         j_testtime_s(cyc,tst)=max(t(begin_t(cyc):last_good_index));
         %mpgge=mpg*42600/fc_fuel_lhv*749/fc_fuel_den, 42600=lhv of gasoline(J/g), 749=density of gasoline(g/l)
         j_galpmi(cyc,tst)=(j_gal(cyc,tst)*fc_fuel_lhv/42600*fc_fuel_den/749+j_kWh(cyc,tst)/K_E)/j_mi(cyc,tst);
         if ~tst==2 & cyc==1 % not fct-hev & UDDS cycle
            cold_HC_g=sum(j_emis(1:1372,1));
            cold_CO_g=sum(j_emis(1:1372,2));
            cold_NOx_g=sum(j_emis(1:1372,3));
            cold_PM_g=sum(j_emis(1:1372,4));
            cold_j_mi=trapz(t(1:1373),j_mpha(1:1373))/3600;
            hot_HC_g=sum(j_emis(1872:length(j_emis(:,1))));
            hot_CO_g=sum(j_emis(1872:length(j_emis(:,2))));
            hot_NOx_g=sum(j_emis(1872:length(j_emis(:,3))));
            hot_PM_g=sum(j_emis(1872:length(j_emis(:,4))));
            hot_j_mi=trapz(t(1872:length(t)),j_mpha(1872:length(t)))/3600;
            j_HC_gpmi(cyc,tst)=0.43*cold_HC_g/cold_j_mi+0.57*hot_HC_g/hot_j_mi;
            j_CO_gpmi(cyc,tst)=0.43*cold_CO_g/cold_j_mi+0.57*hot_CO_g/hot_j_mi;
            j_NOx_gpmi(cyc,tst)=0.43*cold_NOx_g/cold_j_mi+0.57*hot_NOx_g/hot_j_mi;
         else
            j_HC_gpmi(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),j_emis(:,1))/j_mi(cyc,tst);
            j_CO_gpmi(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),j_emis(:,2))/j_mi(cyc,tst);
            j_NOx_gpmi(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),j_emis(:,3))/j_mi(cyc,tst);
            j_PM_gpmi(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),j_emis(:,4))/j_mi(cyc,tst);
         end
         
         j_shortbool(cyc,tst)=( length(j_mpha) < length(j_mphr) ) | ...
            ( last_good_index < length(j_mphr) );
         
         if tst==3 % pct-cv
            j_Ah(cyc,tst)=0;  
         else 
            j_Ah(cyc,tst)=trapz(t(begin_t(cyc):last_good_index),ess_current(begin_t(cyc):last_good_index))/3600;
         end   
         if tst==2 % fct-hev
            j_zev_tm=min(find(gal>0));  
            if isempty(j_zev_tm), j_zev_tm=max(t); end	%if engine wasn't needed for cycle
            j_zev_mi(cyc,tst)=trapz(t(1:j_zev_tm),mpha(1:j_zev_tm))/3600;
         end   
         if tst==4 % fct-ev
            j_zev_mi(cyc,tst)=j_mi(cyc,tst);
         end   
         
      end
      j_mpg(tst)=1/(0.55*j_galpmi(1,tst)+0.45*j_galpmi(2,tst));
      
   end
end
assignin('base','soc_t',1);

% 02/22/00:tm added to reset cycle run parameters to defaults
enable_stop_fc=0; % disable stop for fc
j17_endtimes=[inf inf]; % n/a
%%%% end added 02/22/00:tm 

%Revision history
% 2/25/99: vhj/sb file created
% 2/26/99: vhj added test names, eliminated unneeded vectors
% 3/10/99: vhj no soc correct now (user specified initial conds)
% 3/15/99: vhj added SOC correct functionality for UDDS only
% 4/12/99: vhj added SOC correct functionality for rest of cycles
% 5/10/99: vhj mpgge instead of mpg
% 9/17/99: vhj record mi as zev mi for fct-ev mode
% 9/22/99: vhj assignin('base','soc_t',begin_t(cyc)); reset soc_t to one after test
%11/23/99: vhj if engine wasn't needed for cycle on FCT-HEV, count zev miles to the end of cycle
% 1/12/00:tm introduced j17_endtimes and enable_stop_fc vars to correctly implement 
%				j1711 for high zev mileage capable vehicles
% 6/28/00:tm revised kWh/gallon for gasoline based on published 3/99 SAE J1711 document
% 6/28/00:tm revised j17_endtimes such that minimum cycle length is not enforce - FCT ends once engine turns on
% 7/10/99:ss all references to FUDS are now UDDS
% 8/21/00:tm enabled j17_endtimes - to represent recommended practice as published