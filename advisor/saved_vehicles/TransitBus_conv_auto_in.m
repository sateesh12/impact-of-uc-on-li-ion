% TransitBus_conv_auto_in.m  ADVISOR 3.1  input file created: 11-Apr-2001 11:52:20

global vinf

vinf.name='TransitBus_conv_auto_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_CI205';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_ZF5HP590AT';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_ORIONVI';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_CONVAT5spd';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=14515;
vinf.variables.default(1)=15232;
vinf.variables.name{2}='acc_mech_pwr';
vinf.variables.value(2)=31000;
vinf.variables.default(2)=7457;
vinf.variables.name{3}='wh_1st_rrc';
vinf.variables.value(3)=0.00938;
vinf.variables.default(3)=0.008;
vinf.variables.name{4}='veh_front_wt_frac';
vinf.variables.value(4)=0.65;
vinf.variables.default(4)=0.45;
vinf.variables.name{5}='veh_wheelbase';
vinf.variables.value(5)=7.0612;
vinf.variables.default(5)=6.858;
vinf.variables.name{6}='veh_FA';
vinf.variables.value(6)=8.0516;
vinf.variables.default(6)=7.2413;
