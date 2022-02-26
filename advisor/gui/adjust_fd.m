function adjust_fd(max_spd)

% adjust final drive ratio to allow max speed with current 
% motor/controller and gearbox if necessary accounting for 10% wheel slip

global vinf

if strcmp(vinf.drivetrain.name,'series')|strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')
   assignin('base','fd_ratio',round(evalin('base',...
      'max(mc_map_spd)*mc_spd_scale/min(gb_ratio)*wh_radius')/(max_spd*.4469*1.1)*1000)/1000);
else
   assignin('base','fd_ratio',round(evalin('base',...
      'max(fc_map_spd)*fc_spd_scale/min(gb_ratio)*wh_radius')/(max_spd*.4469*1.1)*1000)/1000);
end
%disp(['Final drive ratio set to ', num2str(evalin('base','fd_ratio')), ' to allow max speed of ',num2str(max_spd),' mph.']);
return
