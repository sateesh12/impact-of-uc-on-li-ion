function init_string(option)

global vinf;

drivetrain=vinf.drivetrain.name;
% tests are: 1) PCT-HEV 2) FCT-HEV 3) PCT-CV 4) FCT-EV
test=evalin('base','tst'); %current test being run
cycle=evalin('base','cyc'); %current cycle being run

switch option
case 'begin'
   if cycle==4 %add add'l AC load only for SC03 cycle
      evalin('base','acc_elec_pwr=acc_elec_pwr+vinf.test.AC.load;');
   end
   if strcmp(drivetrain, 'parallel')
      if test==1 | test==2 %don't need to change variables
         return;
      elseif test==3 %change variables to run in CV (conventional) mode
         evalin('base','old_cs_electric_launch_spd=cs_electric_launch_spd;');
         assignin('base','cs_electric_launch_spd',0); %launch spd-> 0mph
         evalin('base','old_cs_charge_trq=cs_charge_trq;');
         assignin('base','cs_charge_trq',0);
         evalin('base','old_cs_off_trq_frac=cs_off_trq_frac;');
         assignin('base','cs_off_trq_frac',0);
         evalin('base','old_cs_min_trq_frac=cs_min_trq_frac;');
         assignin('base','cs_min_trq_frac',0);
         evalin('base','old_ess_init_soc=ess_init_soc;');
         assignin('base','ess_init_soc',0);
      elseif test==4 %change variables to run in EV mode
         evalin('base','old_cs_electric_launch_spd=cs_electric_launch_spd;');
         assignin('base','cs_electric_launch_spd',200); %launch spd-> 200mph
         evalin('base','old_vc_idle_bool=vc_idle_bool;');
         assignin('base','vc_idle_bool',0); %no idling
         evalin('base','old_cs_lo_soc=cs_lo_soc;');
         assignin('base','cs_lo_soc',0); %no low soc limit
      end
   elseif strcmp(drivetrain, 'series') | strcmp(drivetrain,'fuel_cell') 
      if test==1 | test==2 %don't need to change variables
         return;
      elseif test==3 %change variables to run in CV (conventional) mode
         assignin('base','ess_on',0); %boolean to turn ess off always
      elseif test==4 %change variables to run in EV mode
         assignin('base','fc_on',0); %boolean to turn engine off always
      end
   end %drivetrains
   %accessory loads
   if test==3
      %move accessory loads to mechanical only
      evalin('base','old_acc_mech_pwr=acc_mech_pwr;');
      evalin('base','old_acc_elec_pwr=acc_elec_pwr;');
      evalin('base','acc_mech_pwr=acc_mech_pwr+acc_elec_pwr;');
      evalin('base','acc_elec_pwr=0;');
   elseif test==4
      %move accessory loads to electrical only
      evalin('base','old_acc_mech_pwr=acc_mech_pwr;');
      evalin('base','old_acc_elec_pwr=acc_elec_pwr;');
      evalin('base','acc_elec_pwr=acc_mech_pwr+acc_elec_pwr;');
      evalin('base','acc_mech_pwr=0;');
   end
   
case 'end' %reset variables to old values
   if test==3 | test==4
      %reassign accessory loads
      evalin('base','acc_mech_pwr=old_acc_mech_pwr;');
      evalin('base','acc_elec_pwr=old_acc_elec_pwr;');
      evalin('base','clear old_acc_elec_pwr old_acc_mech_pwr;');
   end
   if cycle==4 %remove add'l AC load (SC03 cycle)
      evalin('base','acc_elec_pwr=acc_elec_pwr-vinf.test.AC.load;');
   end
   if strcmp(drivetrain, 'parallel')
      if test==1 | test==2 %don't need to change variables
         return;
      elseif test==3 
         evalin('base','cs_electric_launch_spd=old_cs_electric_launch_spd;');
         evalin('base','cs_charge_trq=old_cs_charge_trq;');
         evalin('base','cs_off_trq_frac=old_cs_off_trq_frac;');
         evalin('base','cs_min_trq_frac=old_cs_min_trq_frac;');
         evalin('base','ess_init_soc=old_ess_init_soc;');
         evalin('base','clear old_cs_electric_launch_spd old_cs_charge_trq old_cs_off_trq_frac old_cs_min_trq_frac old_ess_init_soc;');
      elseif test==4 
         evalin('base','cs_electric_launch_spd=old_cs_electric_launch_spd;');
         evalin('base','vc_idle_bool=old_vc_idle_bool;');
         evalin('base','cs_lo_soc=old_cs_lo_soc;');
         evalin('base','clear old_cs_electric_launch_spd old_vc_idle_bool old_cs_lo_soc');
      end
      
   elseif strcmp(drivetrain, 'series') | strcmp(drivetrain,'fuel_cell') 
      if test==1 | test==2 %don't need to change variables
         return;
      elseif test==3 
         assignin('base','ess_on',1);
      elseif test==4
         assignin('base','fc_on',1); 
      end %tests for series/fuel cell
   end %drivetrains
   
end %switch cases

%Revision history
% 3/09/99: vhj file created
% 3/10/99: vhj added accessory load manipulation, extra AC load for SC03
% 9/17/99: vhj updated series ev vars-new variable ess_on;

