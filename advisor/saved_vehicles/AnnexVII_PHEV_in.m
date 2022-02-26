% AnnexVII_PHEV_in.m  ADVISOR 3.1  input file created: 28-Mar-2002 14:14:43

global vinf 

vinf.name='AnnexVII_PHEV_in';
vinf.drivetrain.name='parallel';
vinf.fuel_converter.name='FC_CI171';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.torque_coupling.name='TC_DUMMY';
vinf.motor_controller.name='MC_AnnexVII_SerHyb';
vinf.energy_storage.name='ESS_AnnexVII_SHEV_NIMH28';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_AnnexVII_conv';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='veh_AnnexVII_HD_conv';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_PHEV_mv';
vinf.powertrain_control.ver='par';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='acc_mech_pwr';
vinf.variables.value(1)=8000;
vinf.variables.default(1)=7457;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.0293;
vinf.variables.default(2)=1;
vinf.variables.name{3}='ess_module_num';
vinf.variables.value(3)=84;
vinf.variables.default(3)=0;
vinf.variables.name{4}='mc_trq_scale';
vinf.variables.value(4)=5.9986e-005;
vinf.variables.default(4)=1;
vinf.variables.name{5}='veh_mass';
vinf.variables.value(5)=18000;
vinf.variables.default(5)=18933;
