% SABER_CONV_SV_defaults_in.m  ADVISOR 2003  input file created: 17-Jan-2003 08:45:00

global vinf 

vinf.name='SABER_CONV_SV_defaults_in';
vinf.block_diagram.name='BD_CONV';
vinf.drivetrain.name='saber_conv_sv';
vinf.fuel_converter.name='FC_SI41_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.generator.name='GC_14VCP_CUSTOM';
vinf.generator.ver='saber';
vinf.generator.type='14v';
vinf.torque_coupling.name='TC_GC_TO_FC';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONV_Saber_sv';
vinf.powertrain_control.ver='sabSV';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_CONV_SV_Saber';
vinf.accessory.ver='sabSV';
vinf.accessory.type='CONV';
vinf.energy_storage2.name='ESS2_PB69_14V_saber';
vinf.energy_storage2.ver='saber';
vinf.energy_storage2.type='pb';
vinf.variables.name{1}='tc_gc_to_fc_ratio';
vinf.variables.value(1)=3;
vinf.variables.default(1)=1;
vinf.variables.name{2}='ess2_module_num';
vinf.variables.value(2)=5;
vinf.variables.default(2)=0;
