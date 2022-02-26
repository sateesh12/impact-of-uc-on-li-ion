% ADVISOR data file:  ACC_HEAVY.m
%
% Data source: Byron Rapp at WVU
%
% Data confirmation:
%
% Notes:
% Defines standard accessory load data for use with an heavy vehicle in ADVISOR.
%
% Created on: 1/20/99
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='Standard heavy vehicle accessory loads';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_HEAVY - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_air_comp_pwr=5*745.7; % (W), estimate
%acc_alternator_pwr=10*745.7; % (W), tm:8/18/00 included in engine maps
%acc_cooling_fan_pwr=10*745.7; % (W), tm:8/18/00 included in engine maps
acc_air_cond_pwr=5*745.7; % (W), estimate

% total mechanical accessory load, drawn from the engine
%acc_mech_pwr=acc_air_comp_pwr+acc_alternator_pwr+acc_cooling_fan_pwr;  % (W), tm:8/18/00 revised below
acc_mech_pwr=acc_air_comp_pwr+acc_air_cond_pwr;  % (W) with A/C
%acc_mech_pwr=acc_air_comp_pwr;  % (W) without A/C
acc_elec_pwr=0; % (W), electrical acc. load, drawn from the voltage/power bus
acc_mech_eff=1; % efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1/20/99:tm created from ACC_CONV.m
% 3/15/99:ss updated acc_version to 2.1 from 2.0
% 11/3/99:ss updated version to 2.21
% 8/18/00:tm revised actual accessory loads, removed those that would be required for engine operation and added A/C
% 4/18/02:ab updated to load aux loads




