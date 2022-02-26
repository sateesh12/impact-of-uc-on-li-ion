function match_mc_to_ess(mc_lb,mc_ub)
% tm 10/9/98

% calculate battery max power
%ess_pwr=evalin('base','max((ess_voc.*ess_voc)./(4*ess_r_dis))');
ess_pwr=evalin('base','max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))');

% adjust motor size if necessary
mc_max_pwr=evalin('base','max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_trq_scale*mc_overtrq_factor');
mc_2_ess_pwr_ratio=mc_max_pwr/(ess_pwr*evalin('base','ess_module_num'));
assignin('base','mc_trq_scale',min(max(round(evalin('base',...
   'mc_trq_scale')/mc_2_ess_pwr_ratio*1000)/1000,mc_lb),mc_ub));
%disp(['Motor/controller torque scale set to ', num2str(evalin('base','mc_trq_scale')), '.']);

return


% revision history
% 7/17/00:tm added *mc_overtrq_factor to line 9
%
%
