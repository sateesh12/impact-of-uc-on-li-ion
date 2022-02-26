% SABER_SER_defaults_in.m  ADVISOR 2003  input file created: 17-Jan-2003 09:51:21

global vinf 

vinf.name='SABER_SER_defaults_in';
vinf.block_diagram.name='BD_SER_saber_cosim';
vinf.drivetrain.name='saber_ser';
vinf.fuel_converter.name='FC_SI41_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.generator.name='GC_ETA95';
vinf.generator.ver='reg';
vinf.generator.type='reg';
vinf.motor_controller.name='MC_AC75';
vinf.energy_storage.name='ESS_PB25';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_1SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_SER_Saber';
vinf.powertrain_control.ver='sabSer';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_SMALL_CAR_AC';
vinf.accessory.ver='Var';
vinf.accessory.type='Spd';
vinf.energy_storage2.name='ESS2_PB54_14V_saber';
vinf.energy_storage2.ver='saber';
vinf.energy_storage2.type='pb';
vinf.variables.name{1}='gc_trq_scale';
vinf.variables.value(1)=0.51157;
vinf.variables.default(1)=1;
vinf.variables.name{2}='veh_cargo_mass';
vinf.variables.value(2)=117;
vinf.variables.default(2)=136;
