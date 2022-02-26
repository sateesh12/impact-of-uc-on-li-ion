% FCell_Highlander_r6_in.m  ADVISOR 2003  input file created: 07-Apr-2003 16:42:40

global vinf 

vinf.name='FCell_Highlander_r6_in';
vinf.drivetrain.name='fuel_cell';
vinf.fuel_converter.name='FC_ANL50H2';
vinf.fuel_converter.ver='fcell';
vinf.fuel_converter.type='net';
vinf.motor_controller.name='MC_AC83';
vinf.energy_storage.name='ESS_NiMH7_rc_temp';
vinf.energy_storage.ver='rc';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_1SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_P225_60R16_MED_RR';
vinf.wheel_axle.ver='J2452';
vinf.wheel_axle.type='J2452';
vinf.vehicle.name='VEH_Highlander';
vinf.exhaust_aftertreat.name='EX_FUELCELL_NULL';
vinf.powertrain_control.name='PTC_FUELCELL';
vinf.powertrain_control.ver='fc';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='fc_pwr_scale';
vinf.variables.value(1)=1.8;
vinf.variables.default(1)=1;
vinf.variables.name{2}='fc_trq_scale';
vinf.variables.value(2)=1.8;
vinf.variables.default(2)=1;
vinf.variables.name{3}='veh_mass';
vinf.variables.value(3)=1986;
vinf.variables.default(3)=1951;
vinf.variables.name{4}='veh_CD';
vinf.variables.value(4)=0.326;
vinf.variables.default(4)=0.34;
vinf.variables.name{5}='mc_spd_scale';
vinf.variables.value(5)=0.9;
vinf.variables.default(5)=1;
vinf.variables.name{6}='mc_trq_scale';
vinf.variables.value(6)=1.3;
vinf.variables.default(6)=1;
vinf.variables.name{7}='mc_max_crrnt';
vinf.variables.value(7)=600;
vinf.variables.default(7)=385;
vinf.variables.name{8}='mc_min_volts';
vinf.variables.value(8)=150;
vinf.variables.default(8)=200;
vinf.variables.name{9}='cs_max_pwr_fall_rate';
vinf.variables.value(9)=-40000;
vinf.variables.default(9)=-3000;
vinf.variables.name{10}='cs_max_pwr_rise_rate';
vinf.variables.value(10)=40000;
vinf.variables.default(10)=2000;
vinf.variables.name{11}='cs_charge_pwr';
vinf.variables.value(11)=5000;
vinf.variables.default(11)=1000;
vinf.variables.name{12}='cs_min_pwr';
vinf.variables.value(12)=1000;
vinf.variables.default(12)=7500;
vinf.variables.name{13}='cs_min_off_time';
vinf.variables.value(13)=0;
vinf.variables.default(13)=90;
vinf.variables.name{14}='cs_fc_on';
vinf.variables.value(14)=1;
vinf.variables.default(14)=0;
vinf.variables.name{15}='ess_module_num';
vinf.variables.value(15)=38;
vinf.variables.default(15)=0;
