function adjust_cs()

global vinf

assignin('base','update_cs_flag',1)

%if strcmp(vinf.drivetrain.name,'series')
%   fc_map_trq=evalin('base','fc_map_trq');
%   fc_map_spd=evalin('base','fc_map_spd');
%   fc_spd_scale=evalin('base','fc_spd_scale');
%   fc_trq_scale=evalin('base','fc_trq_scale');
%   fc_max_trq=evalin('base','fc_max_trq');
%   fc_fuel_map=evalin('base','fc_fuel_map');
%   gc_map_trq=evalin('base','gc_map_trq');
%   gc_map_spd=evalin('base','gc_map_spd');
%   gc_spd_scale=evalin('base','gc_spd_scale');
%   gc_trq_scale=evalin('base','gc_trq_scale');
%   gc_eff_map=evalin('base','gc_eff_map');
%   gc_max_trq=evalin('base','gc_max_trq');
%end

evalin('base',['run ',vinf.powertrain_control.name])

%if strcmp(vinf.drivetrain.name,'series')
%   assignin('base','cs_spd',cs_spd)
%   assignin('base','cs_pwr',cs_pwr)
%end

evalin('base','clear update_cs_flag')

% 5/20/99 tm created  7/2/99 ss added to shared files  