% c8truck_ef.m 
%
% Class 8 Truck Engine Fan
%
% the mechanical power required by a mechanical engine fan in W given
% engine mechanical shaft speed in rad/s and engine fan load fraction (0.0 [no load] --> 1.0 [full load]
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

map_spd = ([500:50:2500].*(pi/30))'; % angular input at belt driving the auxiliary 
%...(i.e., engine shaft angular speed)
map_load = [0 1];
% load_required row index is ang_input_spd, column index is load_frac  
pwr_map(:,1) = map_spd*0; % units of W (on engine/Fuel Converter)
pwr_map(:,2) = [map_spd.^2 map_spd ones(size(map_spd))]*[0.693104076486784 -79.2166229179111 2842.58519322063]';

% file created: 11-Oct-2001