function match_gc_to_fc(gc_lb,gc_ub)
% tm 11/2/98

% match gc spd and trq range to that of the fc 
assignin('base','gc_spd_scale',round(evalin('base','max(fc_map_spd*fc_spd_scale)/(max(gc_map_spd)*0.95)')*1000)/1000);
assignin('base','gc_trq_scale',min(max(round(evalin('base',...
   'max(fc_max_trq*fc_trq_scale)/interp1(gc_map_spd*gc_spd_scale,gc_max_trq,fc_map_spd(min(find(fc_max_trq==max(fc_max_trq))))*fc_spd_scale)')*1000)/1000,gc_lb),gc_ub));
%disp(['Generator/controller torque scale set to ', num2str(evalin('base','gc_trq_scale')), '.']);
%disp(['Generator/controller speed scale set to ', num2str(evalin('base','gc_spd_scale')), '.']);

return
