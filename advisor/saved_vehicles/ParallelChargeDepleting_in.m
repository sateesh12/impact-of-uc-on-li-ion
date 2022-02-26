% ParallelChargeDepleting_in.m  ADVISOR 3.1 rev b  input file created: 12-Jan-2001 16:01:03

global vinf 

vinf.name='ParallelChargeDepleting_in';
vinf.drivetrain.name='parallel';
vinf.fuel_converter.name='FC_SI41_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.torque_coupling.name='TC_DUMMY';
vinf.motor_controller.name='MC_PM49';
vinf.energy_storage.name='ESS_NIMH45_OVONIC';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_PAR_CD';
vinf.powertrain_control.ver='par';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='mc_overtrq_factor';
vinf.variables.value(1)=1.5;
vinf.variables.default(1)=1;
