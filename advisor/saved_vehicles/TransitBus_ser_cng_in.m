% TransitBus_ser_cng_in.m  ADVISOR 3.1  input file created: 13-Apr-2001 16:57:41

global vinf 

vinf.name='TransitBus_ser_cng_in';
vinf.drivetrain.name='series';
vinf.fuel_converter.name='FC_SI186';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.generator.name='GC_ETA95';
vinf.generator.ver='reg';
vinf.generator.type='reg';
vinf.motor_controller.name='MC_AC187';
vinf.energy_storage.name='ESS_PB85';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_1SPD_BUS';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_HEAVY';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_ORIONVI';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_SERFO';
vinf.powertrain_control.ver='ser';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='gc_spd_scale';
vinf.variables.value(1)=0.35;
vinf.variables.default(1)=1;
vinf.variables.name{2}='gc_trq_scale';
vinf.variables.value(2)=2.3386;
vinf.variables.default(2)=1;
vinf.variables.name{3}='veh_mass';
vinf.variables.value(3)=16610;
vinf.variables.default(3)=16027;
vinf.variables.name{4}='wh_1st_rrc';
vinf.variables.value(4)=0.00938;
vinf.variables.default(4)=0.008;
vinf.variables.name{5}='ess_module_num';
vinf.variables.value(5)=46;
vinf.variables.default(5)=0;
vinf.variables.name{6}='veh_front_wt_frac';
vinf.variables.value(6)=0.65;
vinf.variables.default(6)=0.45;
vinf.variables.name{7}='acc_mech_pwr';
vinf.variables.value(7)=23000;
vinf.variables.default(7)=7457;
vinf.variables.name{8}='mc_overtrq_factor';
vinf.variables.value(8)=1.2;
vinf.variables.default(8)=1.8;
vinf.variables.name{9}='acc_elec_pwr';
vinf.variables.value(9)=9000;
vinf.variables.default(9)=0;
vinf.variables.name{10}='veh_FA';
vinf.variables.value(10)=8.0516;
vinf.variables.default(10)=7.2413;
vinf.variables.name{11}='veh_wheelbase';
vinf.variables.value(11)=7.0612;
vinf.variables.default(11)=6.858;
vinf.variables.name{12}='fd_ratio';
vinf.variables.value(12)=6.34;
vinf.variables.default(12)=5.857;
vinf.variables.name{13}='cs_charge_pwr';
vinf.variables.value(13)=100000;
vinf.variables.default(13)=5000;
vinf.variables.name{14}='cs_fc_init_state';
vinf.variables.value(14)=1;
vinf.variables.default(14)=0;
vinf.variables.name{15}='cs_lo_soc';
vinf.variables.value(15)=0.6;
vinf.variables.default(15)=0.4;
vinf.variables.name{16}='cs_max_pwr';
vinf.variables.value(16)=189000;
vinf.variables.default(16)=103854.7836;
vinf.variables.name{17}='cs_max_pwr_fall_rate';
vinf.variables.value(17)=-10000;
vinf.variables.default(17)=-3000;
vinf.variables.name{18}='cs_max_pwr_rise_rate';
vinf.variables.value(18)=10000;
vinf.variables.default(18)=2000;
vinf.variables.name{19}='cs_min_off_time';
vinf.variables.value(19)=0;
vinf.variables.default(19)=90;
vinf.variables.name{20}='cs_min_pwr';
vinf.variables.value(20)=25000;
vinf.variables.default(20)=28324.0319;
vinf.variables.name{21}='vc_idle_spd';
vinf.variables.value(21)=68;
vinf.variables.default(21)=0;
