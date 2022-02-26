% function eff_scaling(component)
% transforms, in the base workspace, the efficiency and loss maps of the
% designated component.  The amount by which the efficiency is scaled is
% determined by the values of the following base workspace variables:
% fc_eff_scale : fuel converter
% gb_eff_scale : gearbox
% mc_eff_scale : motor and controller
%
% The input parameter 'component' may have one of the following values:
% 'fc' = fuel converter
% 'gb' = gearbox (or CVT)
% 'mc' = motor and controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eff_scaling(component)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DETERMINE WHICH COMPONENT TO SCALE AND TRANSFORM IT
switch component
   
case 'fc'
   if evalin('base','~exist(''fc_fuel_cell_model'')')|evalin('base','fc_fuel_cell_model')~=3
      % transform fuel use map
      if evalin('base','exist(''fc_fuel_map'')')
         evalin('base','fc_fuel_map=fc_fuel_map/fc_eff_scale;')
      end
      % transform BSFC map
      if evalin('base','exist(''fc_fuel_map_gpkWh'')')
         evalin('base','fc_fuel_map_gpkWh=fc_fuel_map_gpkWh/fc_eff_scale;')
      end
   end
   
case 'gb'
   % transform gearbox efficiency map
   % manual or automatic:
   if evalin('base','exist(''tx_eff_map'')')
      evalin('base','tx_eff_map=tx_eff_map*gb_eff_scale;')
   end
   
   % cvt:
   if evalin('base','exist(''gb_map1_eff'')')
      evalin('base','gb_map1_eff=gb_map1_eff*gb_eff_scale;')
   end
   if evalin('base','exist(''gb_map2_eff'')')
      evalin('base','gb_map2_eff=gb_map2_eff*gb_eff_scale;')
   end
   if evalin('base','exist(''gb_map3_eff'')')
      evalin('base','gb_map3_eff=gb_map3_eff*gb_eff_scale;')
   end
   if evalin('base','exist(''gb_map4_eff'')')
      evalin('base','gb_map4_eff=gb_map4_eff*gb_eff_scale;')
   end
   if evalin('base','exist(''gb_map5_eff'')')
      evalin('base','gb_map5_eff=gb_map5_eff*gb_eff_scale;')
   end
   % transform gearbox loss parameters--no longer used as of ADVISOR 3.2 and later
   %if evalin('base','exist(''gb_loss_input_spd_coeff'')')
   %   evalin('base',...
   %      'gb_loss_input_spd_coeff=gb_loss_input_spd_coeff/gb_eff_scale;');
   %end
   %if evalin('base','exist(''gb_loss_output_spd_coeff'')')
   %   evalin('base',...
   %      'gb_loss_output_spd_coeff=gb_loss_output_spd_coeff/gb_eff_scale;');
   %end
   %if evalin('base','exist(''gb_loss_input_trq_coeff'')')
   %   evalin('base',...
   %      'gb_loss_input_trq_coeff=gb_loss_input_trq_coeff/gb_eff_scale;');
   %end
   %if evalin('base','exist(''gb_loss_output_trq_coeff'')')
   %   evalin('base',...
   %      'gb_loss_output_trq_coeff=gb_loss_output_trq_coeff/gb_eff_scale;');
   %end
   %if evalin('base','exist(''gb_loss_output_pwr_coeff'')')
   %   s1='gb_loss_output_pwr_coeff=gb_loss_output_pwr_coeff/gb_eff_scale ';
   %   s2='+ (1-gb_eff_scale)/gb_eff_scale;';
   %   evalin('base',[s1 s2])
   %end  
   %if evalin('base','exist(''gb_loss_const'')')
   %   evalin('base',...
   %      'gb_loss_const=gb_loss_const/gb_eff_scale;');
   %end
      
case 'mc'
   % transform input power map, taking care with regen
   if evalin('base','exist(''mc_inpwr_map'')')
      mc_string='mc_inpwr_map=mc_inpwr_map.*(mc_inpwr_map>0)/mc_eff_scale + ';
      mc_string2='mc_inpwr_map.*(mc_inpwr_map<0)*mc_eff_scale;';
      evalin('base',[mc_string mc_string2])
   end
   % transform efficiency map
   if evalin('base','exist(''mc_eff_map'')')
      evalin('base','mc_eff_map=mc_eff_map*mc_eff_scale;')
   end
  
otherwise
   error('Error in eff_scaling.m:  unknown input parameter')
   
end

% revision history
% 9/12/99:tm modified case fc for new fuel cell data format
% 19-July-2001:mpo adding code to handle efficiency changes in transmission (gearbox)

