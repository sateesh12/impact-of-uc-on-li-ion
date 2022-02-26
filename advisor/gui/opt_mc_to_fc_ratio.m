function answer=opt_mc_to_fc_ratio()
%
% optimize mc to fc ratio to allow max engine speed while
% also trying to match max power points of the fc and mc
%

answer=[];

% get necessary variable values from workspace
fc_map_spd=evalin('base','fc_map_spd*fc_spd_scale');
fc_max_trq=evalin('base','fc_max_trq');
mc_map_spd=evalin('base','mc_map_spd*fc_spd_scale');
mc_max_trq=evalin('base','mc_max_trq');

% determine minimum ratio to match fc and mc top speeds
ratio_min=0.99*max(mc_map_spd)/max(fc_map_spd)

% find speed corresponding to the max power point
fc_max_pwr_index=find((fc_map_spd.*fc_max_trq)==max(fc_map_spd.*fc_max_trq));
mc_max_pwr_index=find((mc_map_spd.*mc_max_trq)==max(mc_map_spd.*mc_max_trq));

% determine ratio to match peak power speeds of mc and fc
ratio_max_pwr=mc_map_spd(mc_max_pwr_index)/fc_map_spd(fc_max_pwr_index)

% return the max of these two choices (i.e. do not limit the operation 
% range of the engine but match power points if possible)
answer=max(ratio_min,ratio_max_pwr);

return
