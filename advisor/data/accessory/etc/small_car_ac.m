% Small Car Air Conditioning Compressor Load
% 
% DESCRIPTION:
% This file defines a small car air conditioner's compressor load.
%
% SOURCE: Delphi Corporation public web site
%
% FILE Author: Aaron Brooker, NREL, aaron_brooker@nrel.gov
%
% Date: 18 December 2002
% 
%
pulley_ratio=1.3;

map_spd = ([0 1030 2065 2515 3515 5000 10000].*(pi/30))/pulley_ratio; % angular input at belt driving the auxiliary 
%...(i.e., engine shaft angular speed)
map_load = [0 1];
% load_required row index is ang_input_spd, column index is load_frac  
pwr_map =...
   [0   0
   62  2233
   124  3590
   154 4109
   235  5006
   403  7121
   806  14242]; % units of W (on engine/Fuel Converter)