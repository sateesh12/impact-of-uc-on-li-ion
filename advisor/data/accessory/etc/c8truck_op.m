% c8truck_op.m
%
% Class 8 Truck Oil Pump
%
% the mechanical power required by a mechanical oil pump in W given
% engine mechanical shaft speed in rad/s and oil load fraction (0.0 [no load] --> 1.0 [full load]
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
% returns the mechanical power required by an engine oil pump in W given
% engine mechanical shaft speed in rad/s and oil pump load fraction (0.0 [no load] --> 1.0 [full load]
% Note: this model is independent of oil pump loading--only speed matters; thus loadFracIn not used...
map_spd = [600 800 1100 1250 1500 1750 2000 2500]*pi/30.0; % speeds for lookup in radians/s
map_load = [0 1];
pwr_map = [0.25 0
    0.7 0
    1.25 0
    1.4 0
    2.0 0
    2.5 0
    3.25 0
    5.0 0].*(-1000.0); % power draws in W