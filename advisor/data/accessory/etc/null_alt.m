% Null Alternator
% the power required by an alternator in W
%
% ADVISOR data file:  null_alt.m
%
% Data confirmation: None
%
% Notes:
% Assumed relevant for a null alternator
%
% Created on: 25 September 2001
% By:  MPO, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pulley_ratio=3; % assumed
map_spd = [0 10000].*(pi/30); % row, rad/s (of engine shaft)
max_pwr = 14.*[158 160]; % W, max alternator output (14 V times max. amp output by speed)
map_load = [0 1]; % col, fraction of max. load
% load_required = [1st column is lowest map_load and last column is highest load frac; 
% rows correspond to input speed with 1st row being lowest speed
pwr_map = [0 0
    0 0];
% W at input required