% fc_vt_vehicle_w_ess_in.m  ADVISOR 2003  input file created: 04-Dec-2002 17:15:01

global vinf 

vinf.name='fc_vt_vehicle_w_ess_in';
vinf.drivetrain.name='fuel_cell';
vinf.fuel_converter.name='FC_VT';
vinf.fuel_converter.ver='fcell';
vinf.fuel_converter.type='VT';
vinf.motor_controller.name='MC_PM49';
vinf.energy_storage.name='ESS_PB25';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_1SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_PNGV';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_PNGV';
vinf.exhaust_aftertreat.name='EX_FUELCELL_NULL';
vinf.powertrain_control.name='PTC_FUELCELL';
vinf.powertrain_control.ver='fc';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='cs_charge_pwr';
vinf.variables.value(1)=0;
vinf.variables.default(1)=1000;
vinf.variables.name{2}='cs_min_pwr';
vinf.variables.value(2)=0;
vinf.variables.default(2)=7500;
vinf.variables.name{3}='cs_min_off_time';
vinf.variables.value(3)=0;
vinf.variables.default(3)=90;
vinf.variables.name{4}='cs_max_pwr_rise_rate';
vinf.variables.value(4)=20000;
vinf.variables.default(4)=2000;
vinf.variables.name{5}='cs_max_pwr_fall_rate';
vinf.variables.value(5)=-30000;
vinf.variables.default(5)=-3000;
