% Null Engine Fan
% 
% DESCRIPTION:
% This file defines null auxiliary loads.
%
% FILE Author: Michael Patrick O'Keefe, NREL, Michael_O'Keefe@nrel.gov
%
% Date: 15 February 2002
% 
%

map_spd = [100 100000].*(pi/30); % angular input at belt driving the auxiliary 
%...(i.e., engine shaft angular speed)
map_load = [0 1];
% load_required row index is ang_input_spd, column index is load_frac  
pwr_map =...
   [0 0 
    0 0]; % units of W (on engine/Fuel Converter)