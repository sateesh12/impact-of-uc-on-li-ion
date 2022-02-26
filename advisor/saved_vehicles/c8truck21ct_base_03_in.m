% c8truck21ct_base_03_in.m  ADVISOR 3.2  input file created: 22-Mar-2002 11:53:46
% This is the baseline class 8 truck for the 21st Century Truck Program
% Targets based on 4/17/03 goals
global vinf 

vinf.name='c8truck21ct_base_03_in';
vinf.drivetrain.name='conventional';
vinf.fuel_converter.name='Fc_ci330_21ct';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='ci';
vinf.transmission.name='TX_21ct';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='Wh_heavy21ct';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_KENT400';
vinf.exhaust_aftertreat.name='EX_IC_NULL';
vinf.powertrain_control.name='PTC_HEAVY';
vinf.powertrain_control.ver='conv';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HEAVY';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='veh_mass';
vinf.variables.value(1)=36280;
vinf.variables.default(1)=7373;
vinf.variables.name{2}='wh_1st_rrc';
vinf.variables.value(2)=0.00493; %set based on older targets (51 kw loss on CYC_Const_65)
vinf.variables.default(2)=0.00938;
vinf.variables.name{3}='veh_CD';
vinf.variables.value(3)=0.625; %Baseline from 21CT Goals 4/17/03
vinf.variables.default(3)=0.7;
vinf.variables.name{4}='acc_mech_pwr';
vinf.variables.value(4)=15000;
vinf.variables.default(4)=7457;
vinf.variables.name{5}='fc_eff_scale';
/vinf.variables.value(5)=1.029; %42 percent eff on CYC_Const_65 target as of 4/17/03
vinf.variables.default(5)=1;
vinf.variables.name{6}='veh_FA';
vinf.variables.value(6)=9.02; %calculated from TT: 65 mph, CD=0.625, rho=1.23 kg/m^2, Pdrag=85kw
vinf.variables.default(6)=8.5502;
vinf.variables.name{6}='fd_ratio';
vinf.variables.value(6)=3.5; %chosen to give peak eff. @ 65 mph
vinf.variables.default(6)=4.33;


%modification list
%jl 11.4.03 added comments modified variables:
%jl 11.21.03 updated to new targets