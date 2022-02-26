% ADVISOR data file:  PTC_SER_Saber.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Created based on PTC_SER.  Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a series hybrid using a thermostat control strategy.
% To ensure proper operation, this file must be reloaded every time the FC, ESS or
% GC is rescaled.
% 
% Created on: 20-June-2002
% By:  AB, NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Powertrain control for series hybrid w/ pure thermostat cs';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_SER_Saber - ',ptc_description])


if ~exist('update_cs_flag')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CLUTCH & ENGINE CONTROL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vc_idle_spd=0;  % (rad/s), engine's idle speed
    vc_idle_bool=0; % 1=> idling allowed; 0=> engine shuts down rather than
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GEARBOX CONTROL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % fractional engine load {=(torque)/(max torque at speed)} above which a
    % downshift is called for, indexed by gb_gearN_dnshift_spd
    gb_gear1_dnshift_load=[2 2];  % (--)
    gb_gear2_dnshift_load=[2 2];  % (--)
    % fractional engine load {=(torque)/(max torque at speed)} below which an
    % upshift is called for, indexed by gb_gearN_upshift_spd
    gb_gear1_upshift_load=[-1 -1];  % (--)
    gb_gear2_upshift_load=[-1 -1];  % (--)
    gb_gear1_dnshift_spd=[0 1000];  % (rad/s)
    gb_gear2_dnshift_spd=[0 1000];  % (rad/s)
    gb_gear1_upshift_spd=[0 1000];  % (rad/s)
    gb_gear2_upshift_spd=[0 1000];  % (rad/s)
    
    % convert old shift commands to new shift commands
    gb_upshift_spd={gb_gear1_upshift_spd; ...
            gb_gear2_upshift_spd};  % (rad/s)
    gb_upshift_load={gb_gear1_upshift_load; ...
            gb_gear2_upshift_load};  % (--)
    gb_dnshift_spd={gb_gear1_dnshift_spd; ...
            gb_gear2_dnshift_spd};  % (rad/s)
    gb_dnshift_load={gb_gear1_dnshift_load; ...
            gb_gear2_dnshift_load};  % (--)
    
    clear gb_gear*shift* % remove unnecessary data
    
    % fixes the difference between number of shift vectors and gears in gearbox
    if length(gb_upshift_spd)<length(gb_ratio)
        start_pt=length(gb_upshift_spd);
        for x=1:length(gb_ratio)-length(gb_upshift_spd)
            gb_upshift_spd{x+start_pt}=gb_upshift_spd{1};
            gb_upshift_load{x+start_pt}=gb_upshift_load{1};
            gb_dnshift_spd{x+start_pt}=gb_dnshift_spd{1};
            gb_dnshift_load{x+start_pt}=gb_dnshift_load{1};
        end
    end
    
    % duration of shift during which no torque can be transmitted
    gb_shift_delay=0;  % (s), no delay since no shifts; this is a 1-spd
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % HYBRID CONTROL STRATEGY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cs_hi_soc=0.8;  % (--), highest desired battery state of charge
    cs_lo_soc=0.4;  % (--), lowest desired battery state of charge
    cs_fc_init_state=0;  % (--), initial FC state; 1=> on, 0=> off
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REGULATOR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reg_vreg_adj=0;  % set point voltage sensitivity parameter; user raises or lowers setpoint by this fixed amount

reg_tempreg=25; % generator operating temperature in C
reg_vsetmax=500; % upper limit for voltage setpoint; user may need to cap voltage setpoint due to battery issues

reg_vehicletype=5;	
%	1	large car		Pre-defined typical voltages & loads
%	2	medium car		Pre-defined typical voltages & loads
%	3	small car		Pre-defined typical voltages & loads
%	4	SUV			Pre-defined typical voltages & loads
%	5	user defined	User determines voltages & loads
reg_temp1=12.8; % the lower temperature for a user defined voltage regulation curve
reg_temp2=93; % the upper temperature for a user defined voltage regulation curve

%   Define ess voltage limits
if exist('ess_max_volts') & exist('ess_min_volts') 
    ess_max_volts_fun=inline('evalin(''base'',''(ess_module_num*ess_max_volts)'')');
    ess_min_volts_fun=inline('evalin(''base'',''(ess_module_num*ess_min_volts)'')');
else
    ess_max_volts_frac=1.3;
    ess_min_volts_frac=.7;
    ess_max_volts_fun=inline('evalin(''base'',''(ess_module_num*ess_voc*ess_max_volts_frac)'')');
    ess_min_volts_fun=inline('evalin(''base'',''(ess_module_num*ess_voc*ess_min_volts_frac)'')');
end

clear reg_volt1_fun reg_volt2_fun
%   Define regulator setpoint
reg_volt1_frac=1.167; % fraction of the mean ess_voc that the generator tries to run at for temperature 1
reg_volt1_fun=inline('evalin(''base'',''min(max((mean(mean(ess_voc))*ess_module_num*reg_volt1_frac),max(max(ess_voc))*ess_module_num),(ess_max_volts_fun(0)-eps))'')');
reg_volt2_frac=1.167; % fraction of ess_voc that the generator tries to run at for temperature 2
reg_volt2_fun=inline('evalin(''base'',''min(max((mean(mean(ess_voc))*ess_module_num*reg_volt2_frac),max(max(ess_voc))*ess_module_num),(ess_max_volts_fun(0)-eps))'')');

%   Uncomment to specify setpoints
%reg_volt1_fun=inline('290');
%reg_volt2_fun=inline('290');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a list of components that when run, require this file (ptc) to run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_dep_comps={'energy_storage','energy_storage2'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC/DC Converter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess2_dcdc_eff=.8;
ess2_dcdc_vminout_frac=.83;
ess2_dcdc_vminout_fun=inline('evalin(''base'',''(ess2_module_num*mean(mean(ess2_voc)))*ess2_dcdc_vminout_frac'')');% the min voltage out from the DC/DC converter
ess2_dcdc_vmaxout_frac=1.167;
ess2_dcdc_vmaxout_fun=inline('evalin(''base'',''(ess2_module_num*mean(mean(ess2_voc))) * ess2_dcdc_vmaxout_frac'')');% the max voltage out from the DC/DC converter
ess2_dcdc_curroutmax=60;
ess2_dcdc_vminin_frac=.8;
ess2_dcdc_vminin_fun=inline('evalin(''base'',''ess2_dcdc_vminin_frac*(mean(mean(ess_voc)))*ess_module_num'')'); % the min voltage that the DC/DC converter passes through current

%   Uncomment to specify
% ess2_dcdc_vminout_fun=inline('9.545');
% ess2_dcdc_vmaxout_fun=inline('13.42');
% ess2_dcdc_vminin_fun=inline('246.65');

if exist('ess_min_volts')
    ess_min_volts_fun=inline('evalin(''base'',''(ess_min_volts*ess_module_num)'')');
elseif exist('ess_voc')
    ess_min_volts_fun=inline('evalin(''base'',''(ess2_dcdc_vminin_frac*(mean(mean(ess_voc))))*ess_module_num'')');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute locus of best efficiency points
%
if ~exist('fc_fuel_map_gpkWh')
    %
    % compute engine efficiency map for use in genset control
    %
    [T,w]=meshgrid(fc_map_trq,fc_map_spd);
    fc_outpwr_map_kW=T.*w/1000;
    fc_fuel_map_gpkWh=fc_fuel_map./(fc_outpwr_map_kW+eps)*3600;
    % if zero speed is in map, replace associated data with nearest BSFC*4
    if min(fc_map_spd)<eps
        fc_fuel_map_gpkWh(1,:)=fc_fuel_map_gpkWh(2,:)*4;
    end
    % if zero torque is in map, replace associated data with nearest BSFC*4
    if min(fc_map_trq)<eps
        fc_fuel_map_gpkWh(:,1)=fc_fuel_map_gpkWh(:,2)*4;
    end
end

%   Set fc spd and trq setpoints and the tc ratio between the fc and gc
cs_fc_spd_setpt_prescale=315;
cs_fc_spd_setpt_fun=inline('evalin(''base'',''cs_fc_spd_setpt_prescale*fc_spd_scale'')');

cs_fc_trq_setpt_prescale=60;
cs_fc_trq_setpt_fun=inline('evalin(''base'',''cs_fc_trq_setpt_prescale*fc_trq_scale'')');

%   To turn on plotting, change the comma separated "0" in the following line to "1"
tc_gc_to_fc_ratio=(GetMostEffSpd(cs_fc_trq_setpt_fun(0)*cs_fc_spd_setpt_fun(0),gc_map_spd*gc_spd_scale,gc_map_trq*gc_trq_scale,gc_eff_map,gc_max_trq*gc_trq_scale,0))/cs_fc_spd_setpt_fun(0);
% tc_gc_to_fc_ratio=1; uncomment to specify tc_gc_to_fc_ratio.  This parameter is not directly used.  It is part of tc_gc_to_fc_ratio_fun.

tc_gc_to_fc_ratio_fun=inline('evalin(''base'',''tc_gc_to_fc_ratio*((fc_trq_scale/fc_spd_scale))'')');
disp(['tc_gc_to_fc_ratio_fun has been changed to: ',num2str(tc_gc_to_fc_ratio_fun(0))])
% tc_gc_to_fc_ratio_fun=inline('evalin(''base'',''tc_gc_to_fc_ratio'')'); uncomment to specify tc_gc_to_fc_ratio_fun.


cs_fc_off2regen_pwr=0; % Turn fc off when potential regen pwr exeeds this value.  Current Saber model requires this to be 0.
                       % It doesn't know that that it should get max power from motor before looking to generator for help
                       % meeting the voltage setpoint.


%%%%%%%%%%%%%%% START OF SPEED DEPENDENT SHIFTING INFORMATION %%%%%%%%%%%%%

% Data specific for SPEED DEPENDENT SHIFTING in the (PRE_TX) GEARBOX CONTROL 
% BLOCK in VEHICLE CONTROLS <vc>
% --implemented for all powertrains except CVT versions and Toyota Prius (JPN)
%
tx_speed_dep=0;	% Value for the switch in the gearbox control
% 			If tx_speed_dep=1, the speed dependent gearbox is chosen
% 			If tx_speed_dep=0, the engine load dependent gearbox is chosen
%
% Vehicle speed (m/s) where the gearbox has to shift
%tx_1_2_spd=24/3.6;	% converting from km/hr to m/s				
%tx_2_3_spd=40/3.6;
%tx_3_4_spd=64/3.6;
%tx_4_5_spd=75/3.6;
%tx_5_4_spd=75/3.6;
%tx_4_3_spd=64/3.6;
%tx_3_2_spd=40/3.6;
%tx_2_1_spd=tx_1_2_spd;

% first column is speed in m/s, second column is gear number
% note: lookup data should be specified as a step function
% ..... this can be done by repeating values of x (first column, speed)
% ..... for differing values of y (second column, )
% note: division by 3.6 to change from km/hr to m/s

% speeds to use for upshift transition (shifting while accelerating) 
tx_spd_dep_upshift = [
    0/3.6, 1
    24/3.6, 1
    24/3.6, 2
    40/3.6, 2
    40/3.6, 3
    64/3.6, 3
    64/3.6, 4
    75/3.6, 4
    75/3.6, 5
    1000/3.6, 5];

% speeds to use for downshift transition (shifting while decelerating)
tx_spd_dep_dnshift = [
    0/3.6, 1
    24/3.6, 1
    24/3.6, 2
    40/3.6, 2
    40/3.6, 3
    64/3.6, 3
    64/3.6, 4
    75/3.6, 4
    75/3.6, 5
    1000/3.6, 5];
%%%%%%%%%%%%%%% END OF SPEED DEPENDENT SHIFTING %%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear T w fc_outpwr_map best_at_each_trq best_trq_index
clear best_at_each_spd best_spd_index
clear genset_max_pwr genset_max_trq genset_map_spd genset_map_trq
clear temp1 temp2 first_index last_index genset_BSFC_map

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06/20/2002:ab created based on PTC_SER