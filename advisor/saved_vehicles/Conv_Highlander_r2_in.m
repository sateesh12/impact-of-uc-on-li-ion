% Conv_Highlander_r2_in.m  ADVISOR 2003  input file created: 07-Apr-2003 12:32:59

global vinf 

vinf.name='Conv_Highlander_r2_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='FC_SI95_fuel_shutoff';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.transmission.name='TX_AUTO4';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_P225_60R16_MED_RR';
vinf.wheel_axle.ver='J2452';
vinf.wheel_axle.type='J2452';
vinf.vehicle.name='VEH_Highlander';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONVAT';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_CONV';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fc_trq_scale';
vinf.variables.value(1)=1.7144;
vinf.variables.default(1)=1;
vinf.variables.name{2}='veh_mass';
vinf.variables.value(2)=1796;
vinf.variables.default(2)=2032;
