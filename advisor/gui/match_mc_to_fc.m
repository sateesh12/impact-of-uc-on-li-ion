function match_mc_to_fc(mc_lb,mc_ub)
% tm 11/2/98

global vinf

% adjust motor size if necessary (includes generator efficiency)
fc_max_pwr=calc_max_pwr('fuel_converter');
mc_max_pwr=calc_max_pwr('motor_controller');
if ~strcmp(vinf.drivetrain.name,'fuel_cell')
   fc_2_mc_pwr_ratio=fc_max_pwr/mc_max_pwr*evalin('base',...
      'sum(sum(gc_eff_map))/length(gc_map_spd)/length(gc_map_trq)');
else
   fc_2_mc_pwr_ratio=fc_max_pwr/mc_max_pwr;
end;
assignin('base','mc_trq_scale',min(max(round(evalin('base',...
   'mc_trq_scale')*fc_2_mc_pwr_ratio*1000)/1000,mc_lb),mc_ub));
%disp(['Motor/controller torque scale set to ', num2str(evalin('base','mc_trq_scale')), '.']);

return
