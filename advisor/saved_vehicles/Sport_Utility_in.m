% Sport_Utility_in.m  ADVISOR 3.1 rev b  input file created: 12-Jan-2001 16:01:33

global vinf 

vinf.name='Sport_Utility_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_SI102_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SUV';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SUV';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONV';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_SUV';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fc_trq_scale';
vinf.variables.value(1)=1.4118;
vinf.variables.default(1)=1;
vinf.variables.name{2}='fc_eff_scale';
vinf.variables.value(2)=1.1552;
vinf.variables.default(2)=1;
