% ADVISOR data file:  ACC_PRIUS_JPN.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines standard accessory load data for use with Prius_jpn in ADVISOR.
%
% Created on: 26-AUG-1999
% By:  ss, NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='700-W constant electric load';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_PRIUS_JPN - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_mech_pwr=0;  % (W), mechanical accessory load, drawn from the engine
acc_elec_pwr=700; % (W), electrical acc. load, drawn from the power bus
                  % this is avg from unique testing.
acc_mech_eff=1; %efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant accessory torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%8/26/99-ss created identical to ACC_HYBRID
% 9/1/99: ss changed accessory pwr to 350 Watts (avg from Unique Testing)
% 9/23/99:ss changed accessory pwr back to 700 Watts to include the a/c load.
% 11/3/99:ss updated version to 2.21
% 2/2/01: ss changed prius to prius_jpn
% 4/18/02:ab updated to load aux loads

