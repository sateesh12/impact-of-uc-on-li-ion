%
% This script weights the test results as appropriate to compute the final
% SAE J1711 fuel economy and g/mi pollutants:
%       j1711_mpg       overall fuel economy
%       j1711_gpmi_HC   overall g/mi HC/NMOG/NMHC
%       j1711_gpmi_CO   overall g/mi CO
%       j1711_gpmi_NOx  overall g/mi NOx
%       j1711_gpmi_PM  overall g/mi PM



% 5 - utility factor weighting with FCT_HEV
if mode_run(2)==1
   tst=2; %FCT-HEV
   for cyc=1:4 % loop through all cycles
      miles=max(j_mi(cyc,tst),j_zev_mi(cyc,tst));
      if cyc==3 | cyc==4
         miles=2/3*j_zev_mi(cyc,tst);
      end
      util=J17_util(miles);
      j_galpmi(cyc,5)=util*j_galpmi(cyc,2)+(1-util)*j_galpmi(cyc,1);
      j_HC_gpmi(cyc,5)=util*j_HC_gpmi(cyc,2)+(1-util)*j_HC_gpmi(cyc,1);
      j_CO_gpmi(cyc,5)=util*j_CO_gpmi(cyc,2)+(1-util)*j_CO_gpmi(cyc,1);
      j_NOx_gpmi(cyc,5)=util*j_NOx_gpmi(cyc,2)+(1-util)*j_NOx_gpmi(cyc,1);
      j_PM_gpmi(cyc,5)=util*j_PM_gpmi(cyc,2)+(1-util)*j_PM_gpmi(cyc,1);
   end
end

%PCT average
for cyc=1:4
   if mode_run(3)==1 % if have CV mode
      ind=3;
   else
      ind=1;
   end
   j_galpmi_pct(cyc)=(j_galpmi(cyc,1)+j_galpmi(cyc,ind))/2;
   j_HC_gpmi_pct(cyc)=(j_HC_gpmi(cyc,1)+j_HC_gpmi(cyc,ind))/2;
   j_CO_gpmi_pct(cyc)=(j_CO_gpmi(cyc,1)+j_CO_gpmi(cyc,ind))/2;
   j_NOx_gpmi_pct(cyc)=(j_NOx_gpmi(cyc,1)+j_NOx_gpmi(cyc,ind))/2;
   j_PM_gpmi_pct(cyc)=(j_PM_gpmi(cyc,1)+j_PM_gpmi(cyc,ind))/2;
end

% 6 - utility factor weighting with FCT_EV
if mode_run(4)==1
   tst=4; %FCT-EV
   for cyc=1:4 % loop through all cycles
      util=J17_util(j_mi(cyc,tst));
      j_galpmi(cyc,6)=util*j_galpmi(cyc,4)+(1-util)*j_galpmi_pct(cyc);
      j_HC_gpmi(cyc,6)=util*j_HC_gpmi(cyc,4)+(1-util)*j_HC_gpmi_pct(cyc);
      j_CO_gpmi(cyc,6)=util*j_CO_gpmi(cyc,4)+(1-util)*j_CO_gpmi_pct(cyc);
      j_NOx_gpmi(cyc,6)=util*j_NOx_gpmi(cyc,4)+(1-util)*j_NOx_gpmi_pct(cyc);
      j_PM_gpmi(cyc,6)=util*j_PM_gpmi(cyc,4)+(1-util)*j_PM_gpmi_pct(cyc);
   end
end

%FCT average
if mode_run(2)==1
   for cyc=1:4
      if mode_run(4)==1 % if have EV mode
         ind=6;
      else
         ind=5;
      end
      j_galpmi_fct(cyc)=(j_galpmi(cyc,5)+j_galpmi(cyc,ind))/2;
      j_HC_gpmi_fct(cyc)=(j_HC_gpmi(cyc,5)+j_HC_gpmi(cyc,ind))/2;
      j_CO_gpmi_fct(cyc)=(j_CO_gpmi(cyc,5)+j_CO_gpmi(cyc,ind))/2;
      j_NOx_gpmi_fct(cyc)=(j_NOx_gpmi(cyc,5)+j_NOx_gpmi(cyc,ind))/2;
      j_PM_gpmi_fct(cyc)=(j_PM_gpmi(cyc,5)+j_PM_gpmi(cyc,ind))/2;
   end
end

%Final average for each cycle
for cyc=1:4
   if mode_run(2)==1
      j_galpmi_final(cyc)=(j_galpmi_pct(cyc)+j_galpmi_fct(cyc))/2;
      j_HC_gpmi_final(cyc)=(j_HC_gpmi_pct(cyc)+j_HC_gpmi_fct(cyc))/2;
      j_CO_gpmi_final(cyc)=(j_CO_gpmi_pct(cyc)+j_CO_gpmi_fct(cyc))/2;
      j_NOx_gpmi_final(cyc)=(j_NOx_gpmi_pct(cyc)+j_NOx_gpmi_fct(cyc))/2;
      j_PM_gpmi_final(cyc)=(j_PM_gpmi_pct(cyc)+j_PM_gpmi_fct(cyc))/2;
   else
      j_galpmi_final(cyc)=j_galpmi_pct(cyc);
      j_HC_gpmi_final(cyc)=j_HC_gpmi_pct(cyc);
      j_CO_gpmi_final(cyc)=j_CO_gpmi_pct(cyc);
      j_NOx_gpmi_final(cyc)=j_NOx_gpmi_pct(cyc);
      j_PM_gpmi_final(cyc)=j_PM_gpmi_pct(cyc);
   end
end

% Combined cycle final
j1711_mpg=1/(.55*j_galpmi_final(1)+.45*j_galpmi_final(2));
if vinf.test.AC.bool
   j1711_HC_gpmi=0.35*j_HC_gpmi_final(1)+0.28*j_HC_gpmi_final(3)+0.37*j_HC_gpmi_final(4);
   j1711_CO_gpmi=0.35*j_CO_gpmi_final(1)+0.28*j_CO_gpmi_final(3)+0.37*j_CO_gpmi_final(4);
   j1711_NOx_gpmi=0.35*j_NOx_gpmi_final(1)+0.28*j_NOx_gpmi_final(3)+0.37*j_NOx_gpmi_final(4);
   j1711_PM_gpmi=0.35*j_PM_gpmi_final(1)+0.28*j_PM_gpmi_final(3)+0.37*j_PM_gpmi_final(4);
else
   j1711_HC_gpmi=0.72*j_HC_gpmi_final(1)+0.28*j_HC_gpmi_final(3);
   j1711_CO_gpmi=0.72*j_CO_gpmi_final(1)+0.28*j_CO_gpmi_final(3);
   j1711_NOx_gpmi=0.72*j_NOx_gpmi_final(1)+0.28*j_NOx_gpmi_final(3);
   j1711_PM_gpmi=0.72*j_PM_gpmi_final(1)+0.28*j_PM_gpmi_final(3);
end

%Revision history
% J17_WT.M -- modified 5/12/98 by sdb to redo weighting per S Poulus (GM)
%            -- modified 4/07/98 by sdb to remove US06 & SC03 from IFT
%            -- modified 3/23/98 by sdb to calc util factors for IFT
%            -- modified 3/20/98 by sdb to include fhds cycle emissions
% 3/9/99: vhj//sdb condensed calculations, modified for use with Advisor 2.0 