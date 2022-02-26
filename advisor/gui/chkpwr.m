% tm 12/31/98
% use to plot energy usage
if strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'fuelcell')
   state=[];
   for x=1:length(mc_pwr_in_a)
      if mc_pwr_in_a(x)==0 % stationary
         state(x)=1; 
      elseif mc_pwr_in_a(x)>0 % driving
         if gc_pwr_out_a(x)==0 
            state(x)=2; % fc off, ess only
         else
            if ess_pwr_out_a(x)==0 
               state(x)=3; % fc_on, no ess
            elseif ess_pwr_out_a(x)>0 
               state(x)=4; % ess and fc driving
            else
               state(x)=5; % fc driving, ess recharging
            end;
         end;
      else % regen
         if gc_pwr_out_a(x)==0
            if ess_pwr_out_a(x)==0
               state(x)=6; % fc off, ess fully charged
            else
               state(x)=7; % fc off, ess recharging
            end;
         else
            if ess_pwr_out_a(x)==0
               state(x)=8; % fc on, ess fully charged
            else 
               state(x)=9; % fc on, ess recharging
            end;
         end;
      end;
   end;
   state=state';
   
   mc_frac=(state==1).*(0)+...
      (state==2).*(-1)+...
      (state==3).*(-1)+...
      (state==4).*(-1)+...
      (state==5).*(mc_pwr_in_a./(gc_pwr_out_a-acc_elec_pwr)).*(-1)+...
      (state==6).*(0)+...
      (state==7).*(1)+...
      (state==8).*(mc_pwr_in_a./(gc_pwr_out_a-mc_pwr_in_a)).*(-1)+...
      (state==9).*(mc_pwr_in_a./(gc_pwr_out_a-mc_pwr_in_a)).*(-1);
   ess_frac=(state==1).*(0)+...
      (state==2).*(1)+...
      (state==3).*(0)+...
      (state==4).*(ess_pwr_out_a./(mc_pwr_in_a+acc_elec_pwr))+...
      (state==5).*(ess_pwr_out_a./(gc_pwr_out_a-acc_elec_pwr))+...
      (state==6).*(0)+...
      (state==7).*(ess_pwr_out_a./(mc_pwr_in_a+acc_elec_pwr)).*(-1)+...
      (state==8).*(0)+...
      (state==9).*(ess_pwr_out_a./(gc_pwr_out_a-mc_pwr_in_a));
   gc_frac=(state==1).*(0)+...
      (state==2).*(0)+...
      (state==3).*(1)+...
      (state==4).*(gc_pwr_out_a./(mc_pwr_in_a+acc_elec_pwr))+...
      (state==5).*(1)+...
      (state==6).*(0)+...
      (state==7).*(0)+...
      (state==8).*(gc_pwr_out_a./(gc_pwr_out_a-mc_pwr_in_a))+...
      (state==9).*(gc_pwr_out_a./(gc_pwr_out_a-mc_pwr_in_a));
   
   figure
   hold
   plot(mc_frac,'r-')
   plot(gc_frac,'b-')
   plot(ess_frac,'g-')
   title('Fractional Energy Flows')
   legend('Motor/Controller Fraction','Genset Fraction','ESS Fraction')
   xlabel('Time (s)')
   ylabel('Fractional Power (+ ==> providing, - ==> consuming')
   set(gcf,'NumberTitle','off','Name','frac pwr')

   figure
   plot(ess_frac+gc_frac+mc_frac)      
   title('Summation of Fractional Energy Flows')
   xlabel('Time (s)')
   ylabel('Fractional Power')
   set(gcf,'NumberTitle','off','Name','frac pwr sum')

end;

if strcmp(vinf.drivetrain.name,'parallel')
   figure
   hold
   plot((tc_pwr_in_a-(fc_trq_out_a.*fc_spd_out_a))./tc_pwr_in_a,'r--')
   plot((tc_pwr_in_a-(mc_trq_out_a.*mc_spd_out_a))./tc_pwr_in_a,'g-')
   title('Fractional Energy Flows')
   legend('Fuel Convertor Fraction','ESS/Motor Fraction')
   xlabel('Time (s)')
   ylabel('Fraction of Power Delivered to the Torque Coupler')
end;
