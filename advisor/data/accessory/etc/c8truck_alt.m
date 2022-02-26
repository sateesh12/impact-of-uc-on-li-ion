% c8truck_alt.m
%
% Class 8 Truck 28 V Alternator
%
% the mechanical power required by an alternator in W given
% engine mechanical shaft speed in rad/s and alternator electrical load (W)
%
% ADVISOR data file:  c8truck_alt_func.m
%
% Data source: Schmidt, M., Isermann, R., Lenzen, B., Hohenberg, G. 
% "Potential of Regenerative Braking Using an Integrated Starter Alternator." SAE Paper No. 2000-01-1020.
%
% Data confirmation: None
%
% Notes:
% Assumed relevant for a 24 V heavy duty alternator efficiency
%
% Created on: 25 September 2001
% By:  MPO, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pulley_ratio=3; % assumed
map_spd = [0:1000:8000].*(pi/30)./pulley_ratio; % row, rad/s (of engine shaft)
max_pwr = 28.*[0 0 80 130 145 150 155 158 160]; % W, max alternator output (28 V times max. amp output by speed)
map_load = [0 0.25 0.5 0.75 1]; % col, fraction of max. load
% load_required = [1st column is lowest map_load and last column is highest load frac; 
% rows correspond to input speed with 1st row being lowest speed
pwr_map = [0 0 0 0 0
   0 0 0 0 0
   0 max_pwr(3)*map_load(2)./0.60 max_pwr(3)*map_load(3)./0.70 max_pwr(3)*map_load(4)./0.60 max_pwr(3)*map_load(5)./0.60
   0 max_pwr(4)*map_load(2)./0.60 max_pwr(4)*map_load(3)./0.69 max_pwr(4)*map_load(4)./0.65 max_pwr(4)*map_load(5)./0.60
   0 max_pwr(5)*map_load(2)./0.60 max_pwr(5)*map_load(3)./0.69 max_pwr(5)*map_load(4)./0.65 max_pwr(5)*map_load(5)./0.60
   0 max_pwr(6)*map_load(2)./0.62 max_pwr(6)*map_load(3)./0.65 max_pwr(6)*map_load(4)./0.62 max_pwr(6)*map_load(5)./0.58
   0 max_pwr(7)*map_load(2)./0.60 max_pwr(7)*map_load(3)./0.65 max_pwr(7)*map_load(4)./0.61 max_pwr(7)*map_load(5)./0.57
   0 max_pwr(8)*map_load(2)./0.58 max_pwr(8)*map_load(3)./0.60 max_pwr(8)*map_load(4)./0.58 max_pwr(8)*map_load(5)./0.53
   0 max_pwr(9)*map_load(2)./0.54 max_pwr(9)*map_load(3)./0.59 max_pwr(9)*map_load(4)./0.57 max_pwr(9)*map_load(5)./0.52];
% W at input required