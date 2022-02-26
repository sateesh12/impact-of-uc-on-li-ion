% ADVISOR data file:  ACC_SAEJ1343_short.m
%
% Data source: SAE J1343 Surface Vehicle Information Report: "Information Relating
%					to Duty Cycles and Average Power Requirements of Truck and Bus 
%					Engine Accessories" (numbers for line haul/long haul trucks) Aug2000
%					--this report gives representative aux. load values for heavy trucks by
%					  general duty cycle.
%
% Data confirmation: None
%
% Notes:
% Defines standard accessory load data for use with an heavy vehicle in ADVISOR. Duty
% cycle based on short haul tractor-trailer values from SAE J1343. An attempt has
% been made to change the periods on the duty cycles so that all combinations of
% accessory load on/off states occur (though these states do not necessarily get equal time).
%
% Created on: 07 January 2002
% By:  Michael Patrick O'Keefe, NREL, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='Variable heavy vehicle accessory loads--SAE J1343 Short Haul Duty Cycles';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_SAEJ1343_short - ',acc_description])
acc_mech_model_name='Mechanical Accessories: Speed Dependant and Variable Electrical'; % The mechanical acc model to be used
acc_elec_model_name='Electrical Accessories: Time Variable'; % The electrical acc model to be used

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total mechanical accessory load, drawn from the engine
acc_mech_pwr=0;  % (W), mechanical (usually belt-driven) load on engine
acc_elec_pwr=0; % (W), load on power bus
acc_mech_eff=1; % efficiency of accessory
acc_elec_eff=1; % efficiency of accessory
acc_mech_trq=0; % (Nm), constant torque load on engine

% Scripts for variable accessories (low-load files):
% A/C
acc_ac_init = 'c8truck_ac';
acc_ac_dutycycle = [0 1
   99 1
   100 0
   199 0]; % 50% duty cycle; two column matrix of time in column one and load in column two

% Power Steering
acc_ps_init = 'c8truck_ps';
acc_ps_dutycycle = [0 1
   49 1
   50 0
	249 0]; % 20% duty cycle; two column matrix of time in column one and load in column two

% Air Compressor
acc_abc_init = 'c8truck_abc';
acc_abc_dutycycle = [0 1
   9 1
   10 0
   99 0]; % 10% duty cycle; two column matrix of time in column one and load in column two

% Engine Fan
acc_ef_init = 'c8truck_ef';
acc_ef_dutycycle = [0 1
   29 1
   30 0
	399 0]; % 7.5% duty cycle; two column matrix of time in column one and load in column two

% Alternator
acc_alt_init = 'c8truck_alt';
acc_acdc_inverter_eff = 0.95;

% Engine Oil Pump
acc_op_init = 'c8truck_op'; % the init file that gives required power by speed and load fraction
acc_op_dutycycle= [0 1
   1 1]; % two column matrix of time in column one and load in column two

% Engine Water Pump
acc_wp_init = 'c8truck_wp';% the initialization file that gives req'd power by speed and load fraction
acc_wp_dutycycle= [0 1
    1 1]; % two column matrix of time in column one and load in column two

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 29-SEP-2001:mpo created file from ACC_CONV.m
% 09-OCT-2001:mpo updated file from ACC_HEAVY_ver_acc_g2.m
% 13-MAR-2002:mpo added water pump information
% 20-MAR-2002:mpo corrected the acc_*_init and acc_*_dutycycle tags to conform with new nomenclature
% 20-MAR-2002:mpo changed a type in the file description
% 4/18/02:ab updated to load aux loads
