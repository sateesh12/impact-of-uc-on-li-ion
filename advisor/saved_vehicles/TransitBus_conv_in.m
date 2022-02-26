% TRANS_BUS_conv_new_in.m  ADVISOR 3.0  input file created: 08-Jan-2001 16:04:33
% file name changed to replace TransitBus_conv_in: 19-Jan-2001 14:30:12

global vinf 

vinf.name='TransitBus_conv_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_CI205';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_ZF4HP590';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_RTS06';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_HEAVY';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=14515;
vinf.variables.default(1)=15232;
vinf.variables.name{2}='wh_1st_rrc';
vinf.variables.value(2)=0.00938;
vinf.variables.default(2)=0.01;
vinf.variables.name{3}='veh_FA';
vinf.variables.value(3)=7.2413;
vinf.variables.default(3)=7.8965;
vinf.variables.name{4}='acc_mech_pwr';
vinf.variables.value(4)=20000;
vinf.variables.default(4)=7457;
vinf.variables.name{5}='fd_ratio';
vinf.variables.value(5)=3.55;
vinf.variables.default(5)=5.34;
