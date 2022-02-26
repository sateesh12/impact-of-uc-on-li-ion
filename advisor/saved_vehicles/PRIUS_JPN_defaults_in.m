% PRIUS_JPN_defaults_in.m  ADVISOR 3.1  input file created: 07-Feb-2001 10:58:37

global vinf 

vinf.name='PRIUS_JPN_defaults_in';
vinf.drivetrain.name='prius_jpn';
vinf.fuel_converter.name='FC_PRIUS_JPN';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.generator.name='GC_PRIUS_JPN';
vinf.generator.ver='reg';
vinf.generator.type='reg';
vinf.motor_controller.name='MC_PRIUS_JPN';
vinf.energy_storage.name='ESS_NIMH6';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_PRIUS_CVT_JPN';
vinf.transmission.ver='pgcvt';
vinf.transmission.type='pgcvt';
vinf.wheel_axle.name='WH_PRIUS_JPN';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_PRIUS_JPN';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_PRIUS_JPN';
vinf.powertrain_control.ver='prius_jpn';
vinf.powertrain_control.type='pg';
vinf.accessory.name='ACC_PRIUS_JPN';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=1368;
vinf.variables.default(1)=1286;
vinf.variables.name{2}='ess_module_num';
vinf.variables.value(2)=40;
vinf.variables.default(2)=0;
