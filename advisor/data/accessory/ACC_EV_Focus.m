% ADVISOR data file:  ACC_EV_Focus.m
%
% Data source: Brian Andonian -  bandoman@umich.edu
% Data confirmation:  None
%
% Notes:
% Defines standard accessory load data for use with a Focus EV in ADVISOR.
% assumes 600W constant electrical load to power fans and other electrical devices in vehicle
%
% Created on: 12-Mar-01
% By:  Brian Andonian
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='600-W constant electric load';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_EV - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_mech_pwr=0;  % (W), mechanical accessory load, drawn from the engine
acc_elec_pwr=600; % (W), electrical acc. load, drawn from the voltage/power bus
acc_mech_eff=1.0; %efficiency of accessory
acc_elec_eff=0.85; %
acc_mech_trq=0; % (Nm), constant accessory torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial Release for school project - 3/12/01 - B. Andonian
% 4/18/02:ab updated to load aux loads


