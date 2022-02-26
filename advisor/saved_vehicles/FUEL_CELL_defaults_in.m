% FUEL_CELL_defaults_in.m  
% input file created: 21-Dec-2000 15:07:18
%---------------------------------------------
global vinf 

vinf.name='FUEL_CELL_defaults_in';
vinf.drivetrain.name='fuel_cell';
vinf.fuel_converter.name='FC_ANL50H2';
vinf.fuel_converter.ver='fcell';
vinf.fuel_converter.type='net';
vinf.motor_controller.name='MC_AC75';
vinf.energy_storage.name='ESS_PB25';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_1SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_FUELCELL';
vinf.powertrain_control.name='PTC_FUELCELL';
vinf.powertrain_control.ver='fc';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';

% Revision history:
% ADVISOR 3.0 rev a
% 4/4/02: kh Revised for ADVISOR 2002, added revision history
%4/21/02: ss changed ver and type for fuel converter