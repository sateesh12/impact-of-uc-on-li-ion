function [VarSaberParams,ConstSaberParams,OutputSaberValues,ModelPath,SaberModelName]=SaberCosimIO_Battery(TempPath)

%=========================================================================================
% THIS IS THE ONLY FILE THAT NEEDS TO BE CHANGED TO RUN ANY SABER CO-SIMULATION: MUST 
%   SPECIFY THIS FILE'S NAME AS THE LAST ARGUMENT IN THE COSIMULATION S-FUNCTION BLOCK 
% *** NOTE: The simulink block diagram must reflect the inputs and outputs in the
%           order of the corresponding list.  
%           Inputs: VarSaberParams first, then ConstSaberParams
%           Outputs: OutputSaberValues
%   Required steps to customize include:
%   1.  Define VarSaberParams: list of names of Saber model variables that change during the 
%       simulation (first section of inputs to S-function)
%   2.  Define ConstSaberParams: list of names of Saber model variables that do NOT change during
%       the simulation (second section of inputs to S-function)
%   3.  Define OutputSaberValues: list of names of Saber model variables to output back to Simulink 
%       (all outputs from S-function)
%   4.  Define ModelPath: location of Saber model 
%   5.  Define SaberModelName: name of Saber model to be used in the co-simulation
%
% *** NOTE: You can only use as many of these co-simulation s-functions at one time
%           as you have Saber licenses available to open Saber.  A different Saber 
%           session will be opened for each co-simulation s-function.  Although
%           multiple s-functions should be possible, it has not been tested



%   1.  a.  Names of Saber model variables that change during
%           the simulation (first section of inputs to S-function)
%           Format: 'primitive.ref = ParameterName = '
%           Example: VarSaberParams={'rear_defrost.rear_defrost1 = loadcontrol = '
%                                   'heated_seat.heated_seat1 = loadcontrol = '
%                                   'radio.radio1 = loadcontrol = '};
%
%       b.  For arrays, '...' is a place holder for the value:
%           Format: 'primitive.ref = ParameterName = [...,'
%                                                    ...]'
%           Example: VarSaberParams={'c_pwl.engine_rpm = pwl = [...,'
%                                   '...,'
%                                   '...,'
%                                   '...,'
%                                   '...,'
%                                   '...]'};
%
%       c.  For the indicated part of a specific element
%           Format: 'primitive.ref = ParameterName = ParameterName(primitive.ref)<-(SpecificElement = ...,'
%                                                                                   ...)'
%           Example: VarSaberParams = {'batt_pb_1.batt_14v = model = model(batt_pb_1.batt_14v)<-(ah_nom = ...,'
%                                       'inom = ...,'
%                                       'rnom = ...,'
%                                       'sg_full = ...,'
%                                       'sg_disc = ...,'
%                                       'fah_thi = ...,'
%                                       'fc = ...,'
%                                       'fah_max = ...,'
%                                       'self_disc = ...,'
%                                       'n_cell = ...,'
%                                       'v_flt = ...)'};

VarSaberParams={'c_pwl.ess_pwr_req = pwl = [...,'
    '...,'
    '...,'
    '...,'
    '...,'
    '...]'};

%   2.  Names of Saber model variables that do NOT change during
%       the simulation (second section of inputs to S-function)
%       Follow same format as VarSaberParams
ConstSaberParams={'ten_module_voltage_soc_error.tmvse1 = v_hi_limit ='
    'ten_module_voltage_soc_error.tmvse1 = v_low_limit ='
    'ten_module_voltage_soc_error.tmvse1 = soc_hi_limit ='
    'ten_module_voltage_soc_error.tmvse1 = soc_lo_limit ='
    'nimh_model.nimh1/c.c1 = ic ='
    'nimh_model.nimh2/c.c1 = ic ='
    'nimh_model.nimh3/c.c1 = ic ='
    'nimh_model.nimh4/c.c1 = ic ='
    'nimh_model.nimh5/c.c1 = ic ='
    'nimh_model.nimh6/c.c1 = ic ='
    'nimh_model.nimh7/c.c1 = ic ='
    'nimh_model.nimh8/c.c1 = ic ='
    'nimh_model.nimh9/c.c1 = ic ='
    'nimh_model.nimh10/c.c1 = ic ='
    'nimh_model.nimh1/integ.integ1 = init ='
    'nimh_model.nimh2/integ.integ1 = init ='
    'nimh_model.nimh3/integ.integ1 = init ='
    'nimh_model.nimh4/integ.integ1 = init ='
    'nimh_model.nimh5/integ.integ1 = init ='
    'nimh_model.nimh6/integ.integ1 = init ='
    'nimh_model.nimh7/integ.integ1 = init ='
    'nimh_model.nimh8/integ.integ1 = init ='
    'nimh_model.nimh9/integ.integ1 = init ='
    'nimh_model.nimh10/integ.integ1 = init ='
    'nimh_model.nimh1/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh2/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh3/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh4/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh5/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh6/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh7/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh8/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh9/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh10/nimh_rc.nimh_rc1 = k ='
    'nimh_model.nimh1/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh2/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh3/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh4/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh5/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh6/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh7/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh8/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh9/nimh_re.nimh_re1 = k ='
    'nimh_model.nimh10/nimh_re.nimh_re1 = k ='    
    'nimh_model.nimh1/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh2/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh3/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh4/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh5/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh6/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh7/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh8/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh9/nimh_rt.nimh_rt1 = k ='
    'nimh_model.nimh10/nimh_rt.nimh_rt1 = k ='        
    'nimh_model.nimh1/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh2/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh3/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh4/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh5/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh6/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh7/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh8/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh9/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh10/nimh_cb.nimh_cb1 = k ='
    'nimh_model.nimh1/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh2/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh3/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh4/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh5/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh6/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh7/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh8/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh9/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh10/nimh_cc.nimh_cc1 = k ='
    'nimh_model.nimh1/integ.integ1 = k ='
    'nimh_model.nimh2/integ.integ1 = k ='
    'nimh_model.nimh3/integ.integ1 = k ='
    'nimh_model.nimh4/integ.integ1 = k ='
    'nimh_model.nimh5/integ.integ1 = k ='
    'nimh_model.nimh6/integ.integ1 = k ='
    'nimh_model.nimh7/integ.integ1 = k ='
    'nimh_model.nimh8/integ.integ1 = k ='
    'nimh_model.nimh9/integ.integ1 = k ='
    'nimh_model.nimh10/integ.integ1 = k ='
    'nimh_model.nimh1/ctherm.ctherm1 = t_init='
    'nimh_model.nimh2/ctherm.ctherm1 = t_init='
    'nimh_model.nimh3/ctherm.ctherm1 = t_init='
    'nimh_model.nimh4/ctherm.ctherm1 = t_init='
    'nimh_model.nimh5/ctherm.ctherm1 = t_init='
    'nimh_model.nimh6/ctherm.ctherm1 = t_init='
    'nimh_model.nimh7/ctherm.ctherm1 = t_init='
    'nimh_model.nimh8/ctherm.ctherm1 = t_init='
    'nimh_model.nimh9/ctherm.ctherm1 = t_init='
    'nimh_model.nimh10/ctherm.ctherm1 = t_init='
    'nimh_model.nimh1/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh2/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh3/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh4/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh5/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh6/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh7/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh8/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh9/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh10/tempsrc.tempsrc1 = dc ='
    'nimh_model.nimh1/rtherm.rtherm2 = rth ='
    'nimh_model.nimh2/rtherm.rtherm2 = rth ='
    'nimh_model.nimh3/rtherm.rtherm2 = rth ='
    'nimh_model.nimh4/rtherm.rtherm2 = rth ='
    'nimh_model.nimh5/rtherm.rtherm2 = rth ='
    'nimh_model.nimh6/rtherm.rtherm2 = rth ='
    'nimh_model.nimh7/rtherm.rtherm2 = rth ='
    'nimh_model.nimh8/rtherm.rtherm2 = rth ='
    'nimh_model.nimh9/rtherm.rtherm2 = rth ='
    'nimh_model.nimh10/rtherm.rtherm2 = rth ='
    'nimh_model.nimh1/ctherm.ctherm1 = cth ='
    'nimh_model.nimh2/ctherm.ctherm1 = cth ='
    'nimh_model.nimh3/ctherm.ctherm1 = cth ='
    'nimh_model.nimh4/ctherm.ctherm1 = cth ='
    'nimh_model.nimh5/ctherm.ctherm1 = cth ='
    'nimh_model.nimh6/ctherm.ctherm1 = cth ='
    'nimh_model.nimh7/ctherm.ctherm1 = cth ='
    'nimh_model.nimh8/ctherm.ctherm1 = cth ='
    'nimh_model.nimh9/ctherm.ctherm1 = cth ='
    'nimh_model.nimh10/ctherm.ctherm1 = cth ='};


%   3.  Names of Saber model variables to output back to Simulink
%       (all outputs from S-function)
%       Format: OutputParameterName(primitive.ref)
%       Example: OutputSaberValues={'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'gen_i(generatormonitor.generatormonitor)'
%                                   'pwr(power_load.starter_power_42v)'};
OutputSaberValues={'nimh_model.nimh1/out(i2var.i2var1)'
%    'current(nimh_model.nimh1)'
    'v1(ten_module_voltage_soc_error.tmvse1)'
    'v2(ten_module_voltage_soc_error.tmvse1)'
    'v3(ten_module_voltage_soc_error.tmvse1)'
    'v4(ten_module_voltage_soc_error.tmvse1)'
    'v5(ten_module_voltage_soc_error.tmvse1)'
    'v6(ten_module_voltage_soc_error.tmvse1)'
    'v7(ten_module_voltage_soc_error.tmvse1)'
    'v8(ten_module_voltage_soc_error.tmvse1)'
    'v9(ten_module_voltage_soc_error.tmvse1)'
    'v10(ten_module_voltage_soc_error.tmvse1)'
    's1(ten_module_voltage_soc_error.tmvse1)'
    's2(ten_module_voltage_soc_error.tmvse1)'
    's3(ten_module_voltage_soc_error.tmvse1)'
    's4(ten_module_voltage_soc_error.tmvse1)'
    's5(ten_module_voltage_soc_error.tmvse1)'
    's6(ten_module_voltage_soc_error.tmvse1)'
    's7(ten_module_voltage_soc_error.tmvse1)'
    's8(ten_module_voltage_soc_error.tmvse1)'
    's9(ten_module_voltage_soc_error.tmvse1)'
    's10(ten_module_voltage_soc_error.tmvse1)'
    'nimh_model.nimh1/out(tempc2var.tempc2var1)'
    'nimh_model.nimh2/out(tempc2var.tempc2var1)'
    'nimh_model.nimh3/out(tempc2var.tempc2var1)'
    'nimh_model.nimh4/out(tempc2var.tempc2var1)'
    'nimh_model.nimh5/out(tempc2var.tempc2var1)'
    'nimh_model.nimh6/out(tempc2var.tempc2var1)'
    'nimh_model.nimh7/out(tempc2var.tempc2var1)'
    'nimh_model.nimh8/out(tempc2var.tempc2var1)'
    'nimh_model.nimh9/out(tempc2var.tempc2var1)'
    'nimh_model.nimh10/out(tempc2var.tempc2var1)'
    'nimh_model.nimh1/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh2/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh3/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh4/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh5/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh6/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh7/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh8/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh9/pwr_flux(var2th_pwr.var2th_pwr1)'
    'nimh_model.nimh10/pwr_flux(var2th_pwr.var2th_pwr1)'};
%     'batt_temp(nimh_model.nimh1)'
%     'batt_temp(nimh_model.nimh2)'
%     'batt_temp(nimh_model.nimh3)'
%     'batt_temp(nimh_model.nimh4)'
%     'batt_temp(nimh_model.nimh5)'
%     'batt_temp(nimh_model.nimh6)'
%     'batt_temp(nimh_model.nimh7)'
%     'batt_temp(nimh_model.nimh8)'
%     'batt_temp(nimh_model.nimh9)'
%     'batt_temp(nimh_model.nimh10)'
%     'th_pwr(nimh_model.nimh1)'
%     'th_pwr(nimh_model.nimh2)'
%     'th_pwr(nimh_model.nimh3)'
%     'th_pwr(nimh_model.nimh4)'
%     'th_pwr(nimh_model.nimh5)'
%     'th_pwr(nimh_model.nimh6)'
%     'th_pwr(nimh_model.nimh7)'
%     'th_pwr(nimh_model.nimh8)'
%     'th_pwr(nimh_model.nimh9)'
%     'th_pwr(nimh_model.nimh10)'


%   4.  Location of Saber model (put your path here if different)
%       Format:  path\
%       Example: ModelPath='c:\ADVISOR\models\Saber\'
ModelPath=strrep(which('advisor'),'advisor.m','models\saber\battery\');

%   5.  Name of Saber model (.sin file) to be used in the co-simulation
%       Format: NameOnly  (don't include ".sin")
%       Example: SaberModelName='Saber_Advisor_dv_cosim'; 
SaberModelName='NiMH_Ten_Modules'; 
