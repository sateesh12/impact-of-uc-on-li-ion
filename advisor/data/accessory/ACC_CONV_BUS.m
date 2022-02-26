% ADVISOR data file:  ACC_CONV_BUS.m
%
% Data source: word of mouth estimates
%
% Data confirmation: none
%
% Notes:
% Defines standard accessory load data for a conventional transit bus--default
% values are for A/C off but values with A/C on are given (commented out).
%
% Created on: 15 August 2001
% By:  MPO, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='Conventional transit bus vehicle accessory loads';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_CONV_BUS - ',acc_description])

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load breakdown (mechanical): 15 Aug 2001 [mpo] added new--aux. load breakdown assumed for bus
% air compressor =  ~1 kW
% alternator load =~ 1 kW
% engine fan =     ~14 kW
% HVAC load =      ~14 kW
% hydraulic pump =  ~1 kW

acc_mech_pwr=17000;  % (W) without Air Condition
%acc_mech_pwr=17000+14000; % (W) with Air Condition
%acc_mech_pwr=acc_air_comp_pwr;  % (W) without A/C

% load breakdown (electrical): 15 Aug 2001 [mpo] assumed to be taken care of in mechanical alternator
% --assuming daytime running with minimal lighting/electrical load
acc_elec_pwr=0; % (W), electrical acc. load, drawn from the voltage/power bus--accounted for w/alternator above
acc_mech_eff=1; % efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

clear acc_air_comp_pwr acc_alternator_pwr acc_cooling_fan_pwr acc_air_cond_pwr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1/20/99:tm created from ACC_CONV.m
% 3/15/99:ss updated acc_version to 2.1 from 2.0
% 11/3/99:ss updated version to 2.21
% 8/18/00:tm revised actual accessory loads, removed those that would be required for engine operation and added A/C
% 8/15/01:mpo created from ACC_HEAVY.m
% 4/18/02:ab updated to load aux loads



