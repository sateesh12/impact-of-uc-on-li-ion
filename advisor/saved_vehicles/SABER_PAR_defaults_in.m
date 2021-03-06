% SABER_PAR_defaults_in.m  ADVISOR 2003  input file created: 17-Jan-2003 09:52:41

global vinf 

vinf.name='SABER_PAR_defaults_in';
vinf.block_diagram.name='BD_PAR_saber_cosim';
vinf.drivetrain.name='saber_par';
vinf.fuel_converter.name='FC_SI41_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.torque_coupling.name='TC_DUMMY';
vinf.motor_controller.name='MC_AC75';
vinf.energy_storage.name='ESS_PB25';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_PAR_Saber';
vinf.powertrain_control.ver='sabPar';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_SMALL_CAR_AC';
vinf.accessory.ver='Var';
vinf.accessory.type='Spd';
vinf.energy_storage2.name='ESS2_PB54_14V_saber';
vinf.energy_storage2.ver='saber';
vinf.energy_storage2.type='pb';
vinf.variables.name{1}='veh_cargo_mass';
vinf.variables.value(1)=117;
vinf.variables.default(1)=136;
vinf.variables.name{2}='ess2_module_num';
vinf.variables.value(2)=5;
vinf.variables.default(2)=0;
vinf.variables.name{3}='fc_trq_scale';
vinf.variables.value(3)=0.945;
vinf.variables.default(3)=1;
vinf.variables.name{4}='mc_trq_scale';
vinf.variables.value(4)=0.751;
vinf.variables.default(4)=1;
vinf.variables.name{5}='ess_module_num';
vinf.variables.value(5)=19;
vinf.variables.default(5)=0;
vinf.variables.name{6}='fd_ratio';
vinf.variables.value(6)=1.3393;
vinf.variables.default(6)=1;
