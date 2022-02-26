% grocery_delivery_truck_in.m  ADVISOR 2002  input file created: 07-Mar-2002 08:16:52

global vinf 

vinf.name='grocery_delivery_truck_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_CI205';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_RTLO12610B';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_ralphs_grocery';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_HEAVY';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_SAEJ1343_local';
vinf.accessory.ver='Var';
vinf.accessory.type='Spd';
vinf.saber_cosim.run=[0];
vinf.variables.name{1}='fc_trq_scale';
vinf.variables.value(1)=1.5605;
vinf.variables.default(1)=1;
vinf.variables.name{2}='veh_mass';
vinf.variables.value(2)=19090;
vinf.variables.default(2)=7633;
