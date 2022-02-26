% c8truck_ac.m
%
% Class 8 Truck Air Condition
%
% the mechanical power required by the air condition in W given
% engine mechanical shaft speed in rad/s and air compressor load fraction (0.0 [no load] --> 1.0 [full load]
% 
% DESCRIPTION:
% This file defines the accessory loading of componentry on a heavy class 8 truck by engine speed and load fraction.
% A load fraction of one means the device is on "full power" while a load fraction of zero means the device
% is idle, clutched, or otherwise "off".
%
% SOURCE: Hnatczuk, W., Lasecki, M., Bishop, J., Goodell, J. (December 2000). "Parasitic Loss 
% 				Reduction for 21st Century Trucks." Presented at the 2000 SAE Truck and Bus Show in Portland, OR. 
%				SAE Paper No. 2001-01-3423. Warrendale, PA: SAE International. 9 pp.
%
% FILE Author: Michael Patrick O'Keefe, NREL, Michael_O'Keefe@nrel.gov
% 

map_spd = [500 1000 1500 2000 2500].*(pi/30); % angular input at belt driving the auxiliary 
%...(i.e., engine shaft angular speed)
map_load = [0 1];
% load_required row index is ang_input_spd, column index is load_frac  
pwr_map =...
   [0 1000 
    0 2416.5
    0 3833
    0 5249.5
    0 6666]; % units of W (on engine/Fuel Converter)
% right hand column of row i is -416.5+2.833*map_spd(i)

% file created: 11-Oct-2001