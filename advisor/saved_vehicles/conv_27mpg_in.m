% conv_27mpg_in.m  ADVISOR 3.2  input file created: 30-Jul-2001 17:00:48

global vinf 

vinf.name='conv_27mpg_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_SI102_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.transmission.name='TX_AUTO4';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_LGCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONVAT';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_CONV';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=1605;
vinf.variables.default(1)=1602;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.106;
vinf.variables.default(2)=1;
vinf.variables.name{3}='fc_eff_scale';
vinf.variables.value(3)=1.2069;
vinf.variables.default(3)=1;
vinf.variables.name{4}='acc_mech_pwr';
vinf.variables.value(4)=1000;
vinf.variables.default(4)=700;
