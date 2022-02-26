% c8truck_wp.m
%
% Class 8 Truck Water Pump
%
% the mechanical power required by a mechanical water pump in W given
% engine mechanical shaft speed in rad/s and power steering load fraction (0.0 [no load] --> 1.0 [full load]
% 
% DESCRIPTION:
% This file defines the accessory loading of componentry on a heavy class 8 truck by engine speed and load fraction.
% A load fraction of one means the device is on "full power" while a load fraction of zero means the device
% is idle, clutched, or otherwise "off".
%
% SOURCE: Presentation by Carl Vuc of John Deere Power Systems at Essential Power Systems Workshop in DC
%
% FILE Author: Michael Patrick O'Keefe, NREL, Michael_O'Keefe@nrel.gov

% returns the mechanical power required by an engine oil pump in W given
% engine mechanical shaft speed in rad/s and oil pump load fraction (0.0 [no load] --> 1.0 [full load]

% Note: this model is independent of oil pump loading--only speed matters; thus loadFracIn not used...
map_spd = [800 1000 1200 1400 1600 1800 2000 2200 2400 2600]*pi/30.0; % speeds for lookup in radians/s
map_load = [0 1];
pwr_map = [0 0
    0.21 0
    0.31 0
    0.46 0
    0.65 0
    0.92 0
    1.23 0
    1.5 0
    1.77 0
    2.0 0].*(-1000.0); % power draws in W
% Note: the power is negative because it is assumed the engine was tested with the water pump on and thus the
% energy draw is part and parcel of the actual engine map. When one "removes" the water pump, they get power
% back off of the map.