% ADVISOR data file:  ACC_AnnexVII_serHyb.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% 
%
% Created on: 09-Mar-2001
% By:  Jacob Eelkema TNO Automotive, eelkema@wt.tno.nl
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='Standard accessory loads AnnexVII series Hybrid';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_AnnexVII_serHyb - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_air_comp_pwr=5*745.7; % (W), estimate
%acc_alternator_pwr=10*745.7; % (W), tm:8/18/00 included in engine maps
%acc_cooling_fan_pwr=10*745.7; % (W), tm:8/18/00 included in engine maps
acc_air_cond_pwr=5*745.7; % (W), estimate

% total mechanical accessory load, drawn from the engine
%acc_mech_pwr=acc_air_comp_pwr+acc_alternator_pwr+acc_cooling_fan_pwr;  % (W), tm:8/18/00 revised below
acc_mech_pwr=0;  % (W) with A/C
%acc_mech_pwr=acc_air_comp_pwr;  % (W) without A/C
acc_elec_pwr=8000; % (W), electrical acc. load, drawn from the voltage/power bus
acc_mech_eff=1; % efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

clear acc_air_comp_pwr acc_alternator_pwr acc_cooling_fan_pwr acc_air_cond_pwr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 17-Apr-2002: automatically updated to version 2002
% 4/18/02:ab updated to load aux loads
