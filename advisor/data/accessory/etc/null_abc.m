% Null Air Compressor Load
% 
% DESCRIPTION:
% This file defines null auxiliary loads.
%
% SOURCE: Hnatczuk, W., Lasecki, M., Bishop, J., Goodell, J. (December 2000). "Parasitic Loss 
% 				Reduction for 21st Century Trucks." Presented at the 2000 SAE Truck and Bus Show in Portland, OR. 
%				SAE Paper No. 2001-01-3423. Warrendale, PA: SAE International. 9 pp.
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