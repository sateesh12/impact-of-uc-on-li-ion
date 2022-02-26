% FuelCell_no_ess_in.m  
% input file created: 12-Jan-2001 15:29:43
%-------------------------------------------------------------
global vinf 

vinf.name='FuelCell_no_ess_in';
vinf.drivetrain.name='fuel_cell';
vinf.fuel_converter.name='FC_ANL50H2';
vinf.fuel_converter.ver='fcell';
vinf.fuel_converter.type='net';
vinf.motor_controller.name='MC_PM49';
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
vinf.exhaust_aftertreat.name='EX_FUELCELL_NULL';
vinf.powertrain_control.name='PTC_FUELCELL';
vinf.powertrain_control.ver='fc';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fc_pwr_scale';
vinf.variables.value(1)=1.2;
vinf.variables.default(1)=1;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.2;
vinf.variables.default(2)=1;
vinf.variables.name{3}='ess_on';
vinf.variables.value(3)=0;
vinf.variables.default(3)=1;
vinf.variables.name{4}='ess_module_mass';
vinf.variables.value(4)=0.01;
vinf.variables.default(4)=11;
vinf.variables.name{5}='cs_charge_pwr';
vinf.variables.value(5)=0;
vinf.variables.default(5)=1000;
vinf.variables.name{6}='cs_min_pwr';
vinf.variables.value(6)=0;
vinf.variables.default(6)=7500;
vinf.variables.name{7}='cs_max_pwr';
vinf.variables.value(7)=50000;
vinf.variables.default(7)=47500;
vinf.variables.name{8}='cs_max_pwr_rise_rate';
vinf.variables.value(8)=20000;
vinf.variables.default(8)=2000;
vinf.variables.name{9}='cs_max_pwr_fall_rate';
vinf.variables.value(9)=-30000;
vinf.variables.default(9)=-3000;
vinf.variables.name{10}='cs_min_off_time';
vinf.variables.value(10)=0;
vinf.variables.default(10)=90;


% Revision history:
% ADVISOR 3.1 rev b  
% 4/4/02: kh Revised for ADVISOR 2002
%4/21/02: ss changed ver and type for fuel converter