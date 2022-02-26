% default_par_suv_auto_in.m  ADVISOR 3.0 rev a  input file created: 21-Dec-2000 15:06:47

global vinf 

vinf.name='default_par_suv_auto_in';
vinf.drivetrain.name='parallel';
vinf.fuel_converter.name='FC_SI95';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.torque_coupling.name='TC_DUMMY';
vinf.motor_controller.name='MC_PM32ev';
vinf.energy_storage.name='ESS_NIMH28_OVONIC';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_AUTO4';
vinf.transmission.ver='auto';
vinf.transmission.type='auto';
vinf.wheel_axle.name='WH_SUV';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SUV_RWD';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_PAR_AUTO';
vinf.powertrain_control.ver='par';
vinf.powertrain_control.type='auto';
vinf.accessory.name='ACC_SUV';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fd_ratio';
vinf.variables.value(1)=1.6;
vinf.variables.default(1)=1;
vinf.variables.name{2}='cs_electric_launch_spd_hi';
vinf.variables.value(2)=6;
vinf.variables.default(2)=0;
vinf.variables.name{3}='cs_electric_launch_spd_lo';
vinf.variables.value(3)=2;
vinf.variables.default(3)=0;
vinf.variables.name{4}='cs_off_trq_frac';
vinf.variables.value(4)=0.1;
vinf.variables.default(4)=0;
vinf.variables.name{5}='cs_min_trq_frac';
vinf.variables.value(5)=0.2;
vinf.variables.default(5)=0.4;
