function [resp,names]=get_sim_results()
%
% This function is used to collect simulation results and 
% store them in a format that can easily be exported to 
% EXCEL.
%
% as configured the following parameter values will be 
% return as appropriate to the vehicle configuration
%
% fc_mass
% gc_mass
% mc_mass
% ess_mass
% tx_mass
% ex_mass
% cargo_mass
% veh_glider_mass
% veh_mass
% vehicle CD
% vehicle FA
% vehicle rolling resistance
% fc_max_pwr
% gc_max_pwr
% mc_max_pwr
% ess_module_num
% ess_voltage
% city fuel economy
% hwy fuel economy
% combined fuel economy
% cycle fuel economy
% co emissions
% hc emissions
% nox emissions
% pm emissions
% gradeability
% 0-60 accel time
% 40-60 accel time
% 0-85 accel time
% delta soc on city
% delta soc on hwy
% delta soc on cycle
% mean soc on city
% mean soc on hwy
% mean soc on cycle
% delta trace on city
% delta trace on hwy
% delta trace on cycle
% fc peak efficiency
% gc peak eff
% mc peak motoring eff
% fc avg eff on city
% fc avg eff on hwy
% mc avg motoring eff on city
% mc avg motoring eff on hwy
% ess roundtrip eff city
% ess roundtrip eff hwy
%

% make vinf accessible to the function
global vinf

% initialize index
index=1;

% mass info
if ~strcmp(vinf.drivetrain.name,'ev')
   resp(index)=evalin('base','fc_mass*fc_trq_scale*fc_spd_scale');
   names{index}='fc_mass';
   index=index+1;
else
   names{index}='fc_mass';
   index=index+1;
end

if ~strcmp(vinf.drivetrain.name,'conventional')
   if strcmp(vinf.drivetrain.name,'series')
      resp(index)=evalin('base','gc_mass*gc_trq_scale*gc_spd_scale');
      names{index}='gc_mass';
      index=index+1;
   else
      names{index}='gc_mass';
      index=index+1;
   end
   resp(index)=evalin('base','mc_mass*mc_trq_scale*mc_spd_scale');
   names{index}='mc_mass';
   index=index+1;
   resp(index)=evalin('base','ess_module_mass*ess_module_num');
   names{index}='ess_mass';
   index=index+1;
else
   names{index}='gc_mass';
   index=index+1;
   names{index}='mc_mass';
   index=index+1;
   names{index}='ess_mass';
   index=index+1;
end
resp(index)=evalin('base','tx_mass');
names{index}='tx_mass';
index=index+1;
if ~strcmp(vinf.drivetrain.name,'ev')
   resp(index)=evalin('base','ex_mass*fc_trq_scale*fc_spd_scale');
   names{index}='ex_mass';
   index=index+1;
else
   names{index}='ex_mass';
   index=index+1;
end
resp(index)=evalin('base','veh_cargo_mass');
names{index}='cargo_mass';
index=index+1;
resp(index)=evalin('base','veh_glider_mass');
names{index}='glider_mass';
index=index+1;
resp(index)=evalin('base','veh_mass');
names{index}='veh_mass';
index=index+1;

% misc veh info
resp(index)=evalin('base','veh_CD');
names{index}='cd';
index=index+1;
resp(index)=evalin('base','veh_FA');
names{index}='fa';
index=index+1;
resp(index)=evalin('base','wh_1st_rrc');
names{index}='crr';
index=index+1;

% peak power info
if ~strcmp(vinf.drivetrain.name,'ev')
   resp(index)=calc_max_pwr('fuel_converter');
   names{index}='fc_pwr';
   index=index+1;
else
   names{index}='fc_pwr';
   index=index+1;
end
if ~strcmp(vinf.drivetrain.name,'conventional')
   resp(index)=calc_max_pwr('motor_controller');
   names{index}='mc_pwr';
   index=index+1;
   if strcmp(vinf.drivetrain.name,'series')
      resp(index)=calc_max_pwr('generator');
      names{index}='gc_pwr';
      index=index+1;
   else
      names{index}='gc_pwr';
      index=index+1;
   end
else
   names{index}='mc_pwr';
   index=index+1;
   names{index}='gc_pwr';
   index=index+1;
end

% misc ess info
if ~strcmp(vinf.drivetrain.name,'conventional')
   resp(index)=evalin('base','ess_module_num');
   names{index}='ess_mod_num';
   index=index+1;
   resp(index)=evalin('base','ess_module_num*mean(mean(ess_voc))');
   names{index}='ess_volts';
   index=index+1;
else
   names{index}='ess_mod_num';
   index=index+1;
   names{index}='ess_volts';
   index=index+1;
end

% fuel economy info
if strcmp(vinf.test.name,'TEST_CITY_HWY')&strcmp(vinf.test.run,'on')
   resp(index)=evalin('base','mpgge');
   names{index}='city_mpgge';
   index=index+1;
   resp(index)=evalin('base','mpgge_hwy');
   names{index}='hwy_mpgge';
   index=index+1;
   resp(index)=evalin('base','combined_mpgge');
   names{index}='comb_mpgge';
   index=index+1;
   names{index}='mpgge';
   index=index+1;
else
   names{index}='city_mpgge';
   index=index+1;
   names{index}='hwy_mpgge';
   index=index+1;
   names{index}='comb_mpgge';
   index=index+1;
   resp(index)=evalin('base','mpgge');
   names{index}='mpgge';
   index=index+1;
end

% emissions info
resp(index)=evalin('base','co_gpm');
names{index}='co';
index=index+1;
resp(index)=evalin('base','hc_gpm');
names{index}='hc';
index=index+1;
resp(index)=evalin('base','nox_gpm');
names{index}='nox';
index=index+1;
resp(index)=evalin('base','pm_gpm');
names{index}='pm';
index=index+1;

% performance info
eval('vinf.max_grade;test4exist=1;','test4exist=0;')
if test4exist
   resp(index)=evalin('base','vinf.max_grade');
   names{index}='grade';
   index=index+1;
else
   names{index}='grade';
   index=index+1;
end
eval('vinf.acceleration.time_0_60;test4exist=1;','test4exist=0;')
if test4exist
   resp(index)=evalin('base','vinf.acceleration.time_0_60');
   names{index}='0_60';
   index=index+1;
   resp(index)=evalin('base','vinf.acceleration.time_40_60');
   names{index}='40_60';
   index=index+1;
   resp(index)=evalin('base','vinf.acceleration.time_0_85');
   names{index}='0_85';
   index=index+1;
else
   names{index}='0_60';
   index=index+1;
   names{index}='40_60';
   index=index+1;
   names{index}='0_85';
   index=index+1;
end

% delta SOC info
if ~strcmp(vinf.drivetrain.name,'conventional')
   if strcmp(vinf.test.name,'TEST_CITY_HWY')&strcmp(vinf.test.run,'on')
      resp(index)=evalin('base','delta_soc(2)');
      names{index}='delta_soc_city';
      index=index+1;
      resp(index)=evalin('base','delta_soc(1)');
      names{index}='delta_soc_hwy';
      index=index+1;
      resp(index)=evalin('base','mean_soc(2)');
      names{index}='mean_soc_city';
      index=index+1;
      resp(index)=evalin('base','mean_soc(1)');
      names{index}='mean_soc_hwy';
      index=index+1;
      names{index}='delta_soc';
      index=index+1;
      names{index}='mean_soc';
      index=index+1;
   else
      names{index}='delta_soc_city';
      index=index+1;
      names{index}='delta_soc_hwy';
      index=index+1;
      names{index}='mean_soc_city';
      index=index+1;
      names{index}='mean_soc_hwy';
      index=index+1;
      if strcmp(vinf.cycle.soc,'on')
         resp(index)=evalin('base','DeltaSOC');
         names{index}='delta_soc';
         index=index+1;
         resp(index)=evalin('base','mean(ess_soc_hist)');
         names{index}='mean_soc';
         index=index+1;
      else
         names{index}='delta_soc';
         index=index+1;
         names{index}='mean_soc';
         index=index+1;
      end
      
   end
   
else
   names{index}='delta_soc_city';
   index=index+1;
   names{index}='delta_soc_hwy';
   index=index+1;
   names{index}='mean_soc_city';
   index=index+1;
   names{index}='mean_soc_hwy';
   index=index+1;
   names{index}='delta_soc';
   index=index+1;
   names{index}='mean_soc';
   index=index+1;
end

% trace info
if strcmp(vinf.test.name,'TEST_CITY_HWY')&strcmp(vinf.test.run,'on')
   resp(index)=evalin('base','delta_trace(2)');
   names{index}='delta_trace_city';
   index=index+1;
   resp(index)=evalin('base','delta_trace(1)');
   names{index}='delta_trace_hwy';
   index=index+1;
   names{index}='delta_trace';
   index=index+1;
else
   names{index}='delta_trace_city';
   index=index+1;
   names{index}='delta_trace_hwy';
   index=index+1;
   resp(index)=evalin('base','max(abs(trace_miss))');
   names{index}='delta_trace';
   index=index+1;
end


% efficiency info
if ~strcmp(vinf.drivetrain.name,'ev')
   resp(index)=calc_max_eff('fuel_converter');
   names{index}='fc_peak_eff';
   index=index+1;
else
   names{index}='fc_peak_eff';
   index=index+1;
end
if ~strcmp(vinf.drivetrain.name,'conventional')
   if strcmp(vinf.drivetrain.name,'series')
      resp(index)=calc_max_eff('generator');
      names{index}='gc_peak_eff';
      index=index+1;
   else
      names{index}='gc_peak_eff';
      index=index+1;
   end
   resp(index)=calc_max_eff('motor_controller');
   names{index}='mc_peak_eff';
   index=index+1;
else
   names{index}='gc_peak_eff';
   index=index+1;
   names{index}='mc_peak_eff';
   index=index+1;
end

if strcmp(vinf.test.name,'TEST_CITY_HWY')&strcmp(vinf.test.run,'on')
   comp_efficiency=evalin('base','comp_etas');
   if ~strcmp(vinf.drivetrain.name,'ev')
      resp(index)=comp_efficiency(2,1);
      names{index}='fc_eff_city';
      index=index+1;
      resp(index)=comp_efficiency(1,1);
      names{index}='fc_eff_hwy';
      index=index+1;
   else
      names{index}='fc_eff_city';
      index=index+1;
      names{index}='fc_eff_hwy';
      index=index+1;
   end
   if ~strcmp(vinf.drivetrain.name,'conventional')
      resp(index)=comp_efficiency(2,3);
      names{index}='mc_eff_city';
      index=index+1;
      resp(index)=comp_efficiency(1,3);
      names{index}='mc_eff_hwy';
      index=index+1;
      resp(index)=comp_efficiency(2,end);
      names{index}='ess_eff_city';
      index=index+1;
      resp(index)=comp_efficiency(1,end);
      names{index}='ess_eff_hwy';
      index=index+1;
   else
      names{index}='mc_eff_city';
      index=index+1;
      names{index}='mc_eff_hwy';
      index=index+1;
      names{index}='ess_eff_city';
      index=index+1;
      names{index}='ess_eff_hwy';
      index=index+1;
   end
else
   names{index}='fc_eff_city';
   index=index+1;
   names{index}='fc_eff_hwy';
   index=index+1;
   names{index}='mc_eff_city';
   index=index+1;
   names{index}='mc_eff_hwy';
   index=index+1;
   names{index}='ess_eff_city';
   index=index+1;
   names{index}='ess_eff_hwy';
   index=index+1;
end


%%%%% INCLUDE ADDITIONAL ITEMS HERE USING SAME FORMAT
% if vehicle condtional
%resp(index)=evalin('base','param_name');
%names{index}='param_name';
%index=index+1;
%else
%names{index}='param_name';
%index=index+1;
%end
%%%%% END of ADDITIONAL ITEMS

resp=resp';
names=names';

return
