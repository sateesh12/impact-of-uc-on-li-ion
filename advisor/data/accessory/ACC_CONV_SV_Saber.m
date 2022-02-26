% ADVISOR data file:  ACC_CONV_SV_Saber.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines standard accessory load data for use with an advanced conventional-
% drivetrain vehicle in ADVISOR 2.
%
% Created on: 30-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='Single voltage electrical loads';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_CONV_SV_Saber - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_mech_pwr=0;  % (W), mechanical accessory load, drawn from the engine
acc_elec_pwr=0; % (W), electrical acc. load, drawn from the voltage/power bus
acc_mech_eff=1; %efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_mech_model_name='Saber Single Voltage Cosim';

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 03/28/02 ab:created based on conv


