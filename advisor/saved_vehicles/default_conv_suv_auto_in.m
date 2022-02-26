% default_conv_suv_auto_in.m  ADVISOR 3.0 rev a  input file created: 21-Dec-2000 15:06:24

global vinf 

vinf.name='default_conv_suv_auto_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_SI95';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.transmission.name='TX_AUTO4';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_SUV';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SUV_RWD';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONVAT';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_SUV';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fd_ratio';
vinf.variables.value(1)=1.6;
vinf.variables.default(1)=1;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.5146;
vinf.variables.default(2)=1;
