% AnnexVII_SHEV_in.m  ADVISOR 3.1  input file created: 22-Mar-2002 16:15:02

global vinf 

vinf.name='AnnexVII_SHEV_in';
vinf.drivetrain.name='series';
vinf.fuel_converter.name='FC_CI171';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.generator.name='gc_AnnexVII_serHyb';
vinf.generator.ver='reg';
vinf.generator.type='reg';
vinf.motor_controller.name='MC_AnnexVII_SerHyb';
vinf.energy_storage.name='ESS_AnnexVII_SHEV_NIMH28';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_AnnexVII_SerHyb';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='veh_AnnexVII_HD_conv';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_shev_mv';
vinf.powertrain_control.ver='ser';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_AnnexVII_serHyb';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=18000;
vinf.variables.default(1)=19168;
vinf.variables.name{2}='veh_cargo_mass';
vinf.variables.value(2)=12000;
vinf.variables.default(2)=12800;
vinf.variables.name{3}='mc_trq_scale';
vinf.variables.value(3)=0.8698;
vinf.variables.default(3)=1;
vinf.variables.name{4}='fc_trq_scale';
vinf.variables.value(4)=0.83888;
vinf.variables.default(4)=1;
vinf.variables.name{5}='ess_module_num';
vinf.variables.value(5)=84;
vinf.variables.default(5)=0;
vinf.variables.name{6}='gc_trq_scale';
vinf.variables.value(6)=1.0144;
vinf.variables.default(6)=1;