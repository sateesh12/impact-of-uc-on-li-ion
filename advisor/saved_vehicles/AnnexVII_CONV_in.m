% AnnexVII_CONV_in.m  ADVISOR 3.1  input file created: 19-Mar-2002 17:13:14

global vinf 

vinf.name='AnnexVII_CONV_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_CI171';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_AnnexVII_conv';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='veh_AnnexVII_HD_conv';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_HEAVY';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fc_trq_scale';
vinf.variables.value(1)=1.0293;
vinf.variables.default(1)=1;
vinf.variables.name{2}='veh_mass';
vinf.variables.value(2)=18000;
vinf.variables.default(2)=18594;
vinf.variables.name{3}='acc_mech_pwr';
vinf.variables.value(3)=8000;
vinf.variables.default(3)=7457;
vinf.variables.name{4}='veh_cargo_mass';
vinf.variables.value(4)=12206;
vinf.variables.default(4)=12800;