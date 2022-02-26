% conv_ci_in.m  ADVISOR 3.2  input file created: 07-Mar-2003 14:43:47

global vinf 

vinf.name='conv_ci_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_CI67_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_AUTO4';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_SMCAR';
vinf.vehicle.name='VEH_LGCAR';
vinf.exhaust_aftertreat.name='EX_CI';
vinf.powertrain_control.name='PTC_CONVAT';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_CONV';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=1605;
vinf.variables.default(1)=1602;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.6813;
vinf.variables.default(2)=1;
vinf.variables.name{3}='fc_eff_scale';
vinf.variables.value(3)=1.0;
vinf.variables.default(3)=1;
vinf.variables.name{4}='acc_mech_pwr';
vinf.variables.value(4)=1000;
vinf.variables.default(4)=700;
