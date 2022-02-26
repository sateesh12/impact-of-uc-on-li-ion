% SABER_CONV_DV_defaults_in.m  ADVISOR 2003  input file created: 17-Jan-2003 09:04:53

global vinf 

vinf.name='SABER_CONV_DV_defaults_in';
vinf.block_diagram.name='BD_CONV';
vinf.drivetrain.name='saber_conv_dv';
vinf.fuel_converter.name='FC_SI63_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.generator.name='GC_42VCP_CUSTOM';
vinf.generator.ver='saber';
vinf.generator.type='42v';
vinf.torque_coupling.name='TC_GC_TO_FC';
vinf.energy_storage.name='ESS_PB54_14V_saber';
vinf.energy_storage.ver='saber2';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_CONV_Saber_dv';
vinf.powertrain_control.ver='sabDV';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_CONV_DV_Saber';
vinf.accessory.ver='sabDV';
vinf.accessory.type='CONV';
vinf.energy_storage2.name='ESS2_PB54_14V_saber';
vinf.energy_storage2.ver='saber';
vinf.energy_storage2.type='pb';
vinf.variables.name{1}='tc_gc_to_fc_ratio';
vinf.variables.value(1)=3;
vinf.variables.default(1)=1;
vinf.variables.name{2}='ess_module_num';
vinf.variables.value(2)=16;
vinf.variables.default(2)=0;
