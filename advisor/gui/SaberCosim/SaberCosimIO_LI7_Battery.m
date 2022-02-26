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
    'lib_model.lib1/c.c1 = ic ='
    'lib_model.lib2/c.c1 = ic ='
    'lib_model.lib3/c.c1 = ic ='
    'lib_model.lib4/c.c1 = ic ='
    'lib_model.lib5/c.c1 = ic ='
    'lib_model.lib6/c.c1 = ic ='
    'lib_model.lib7/c.c1 = ic ='
    'lib_model.lib8/c.c1 = ic ='
    'lib_model.lib9/c.c1 = ic ='
    'lib_model.lib10/c.c1 = ic ='
    'lib_model.lib1/integ.integ1 = init ='
    'lib_model.lib2/integ.integ1 = init ='
    'lib_model.lib3/integ.integ1 = init ='
    'lib_model.lib4/integ.integ1 = init ='
    'lib_model.lib5/integ.integ1 = init ='
    'lib_model.lib6/integ.integ1 = init ='
    'lib_model.lib7/integ.integ1 = init ='
    'lib_model.lib8/integ.integ1 = init ='
    'lib_model.lib9/integ.integ1 = init ='
    'lib_model.lib10/integ.integ1 = init ='
    'lib_model.lib1/lib_rc.lib_rc1 = k ='
    'lib_model.lib2/lib_rc.lib_rc1 = k ='
    'lib_model.lib3/lib_rc.lib_rc1 = k ='
    'lib_model.lib4/lib_rc.lib_rc1 = k ='
    'lib_model.lib5/lib_rc.lib_rc1 = k ='
    'lib_model.lib6/lib_rc.lib_rc1 = k ='
    'lib_model.lib7/lib_rc.lib_rc1 = k ='
    'lib_model.lib8/lib_rc.lib_rc1 = k ='
    'lib_model.lib9/lib_rc.lib_rc1 = k ='
    'lib_model.lib10/lib_rc.lib_rc1 = k ='
    'lib_model.lib1/lib_re.lib_re1 = k ='
    'lib_model.lib2/lib_re.lib_re1 = k ='
    'lib_model.lib3/lib_re.lib_re1 = k ='
    'lib_model.lib4/lib_re.lib_re1 = k ='
    'lib_model.lib5/lib_re.lib_re1 = k ='
    'lib_model.lib6/lib_re.lib_re1 = k ='
    'lib_model.lib7/lib_re.lib_re1 = k ='
    'lib_model.lib8/lib_re.lib_re1 = k ='
    'lib_model.lib9/lib_re.lib_re1 = k ='
    'lib_model.lib10/lib_re.lib_re1 = k ='    
    'lib_model.lib1/lib_rt.lib_rt1 = k ='
    'lib_model.lib2/lib_rt.lib_rt1 = k ='
    'lib_model.lib3/lib_rt.lib_rt1 = k ='
    'lib_model.lib4/lib_rt.lib_rt1 = k ='
    'lib_model.lib5/lib_rt.lib_rt1 = k ='
    'lib_model.lib6/lib_rt.lib_rt1 = k ='
    'lib_model.lib7/lib_rt.lib_rt1 = k ='
    'lib_model.lib8/lib_rt.lib_rt1 = k ='
    'lib_model.lib9/lib_rt.lib_rt1 = k ='
    'lib_model.lib10/lib_rt.lib_rt1 = k ='        
    'lib_model.lib1/lib_cb.lib_cb1 = k ='
    'lib_model.lib2/lib_cb.lib_cb1 = k ='
    'lib_model.lib3/lib_cb.lib_cb1 = k ='
    'lib_model.lib4/lib_cb.lib_cb1 = k ='
    'lib_model.lib5/lib_cb.lib_cb1 = k ='
    'lib_model.lib6/lib_cb.lib_cb1 = k ='
    'lib_model.lib7/lib_cb.lib_cb1 = k ='
    'lib_model.lib8/lib_cb.lib_cb1 = k ='
    'lib_model.lib9/lib_cb.lib_cb1 = k ='
    'lib_model.lib10/lib_cb.lib_cb1 = k ='
    'lib_model.lib1/lib_cc.lib_cc1 = k ='
    'lib_model.lib2/lib_cc.lib_cc1 = k ='
    'lib_model.lib3/lib_cc.lib_cc1 = k ='
    'lib_model.lib4/lib_cc.lib_cc1 = k ='
    'lib_model.lib5/lib_cc.lib_cc1 = k ='
    'lib_model.lib6/lib_cc.lib_cc1 = k ='
    'lib_model.lib7/lib_cc.lib_cc1 = k ='
    'lib_model.lib8/lib_cc.lib_cc1 = k ='
    'lib_model.lib9/lib_cc.lib_cc1 = k ='
    'lib_model.lib10/lib_cc.lib_cc1 = k ='
    'lib_model.lib1/integ.integ1 = k ='
    'lib_model.lib2/integ.integ1 = k ='
    'lib_model.lib3/integ.integ1 = k ='
    'lib_model.lib4/integ.integ1 = k ='
    'lib_model.lib5/integ.integ1 = k ='
    'lib_model.lib6/integ.integ1 = k ='
    'lib_model.lib7/integ.integ1 = k ='
    'lib_model.lib8/integ.integ1 = k ='
    'lib_model.lib9/integ.integ1 = k ='
    'lib_model.lib10/integ.integ1 = k ='
    'lib_model.lib1/ctherm.ctherm1 = t_init='
    'lib_model.lib2/ctherm.ctherm1 = t_init='
    'lib_model.lib3/ctherm.ctherm1 = t_init='
    'lib_model.lib4/ctherm.ctherm1 = t_init='
    'lib_model.lib5/ctherm.ctherm1 = t_init='
    'lib_model.lib6/ctherm.ctherm1 = t_init='
    'lib_model.lib7/ctherm.ctherm1 = t_init='
    'lib_model.lib8/ctherm.ctherm1 = t_init='
    'lib_model.lib9/ctherm.ctherm1 = t_init='
    'lib_model.lib10/ctherm.ctherm1 = t_init='
    'lib_model.lib1/tempsrc.tempsrc1 = dc ='
    'lib_model.lib2/tempsrc.tempsrc1 = dc ='
    'lib_model.lib3/tempsrc.tempsrc1 = dc ='
    'lib_model.lib4/tempsrc.tempsrc1 = dc ='
    'lib_model.lib5/tempsrc.tempsrc1 = dc ='
    'lib_model.lib6/tempsrc.tempsrc1 = dc ='
    'lib_model.lib7/tempsrc.tempsrc1 = dc ='
    'lib_model.lib8/tempsrc.tempsrc1 = dc ='
    'lib_model.lib9/tempsrc.tempsrc1 = dc ='
    'lib_model.lib10/tempsrc.tempsrc1 = dc ='
    'lib_model.lib1/rtherm.rtherm2 = rth ='
    'lib_model.lib2/rtherm.rtherm2 = rth ='
    'lib_model.lib3/rtherm.rtherm2 = rth ='
    'lib_model.lib4/rtherm.rtherm2 = rth ='
    'lib_model.lib5/rtherm.rtherm2 = rth ='
    'lib_model.lib6/rtherm.rtherm2 = rth ='
    'lib_model.lib7/rtherm.rtherm2 = rth ='
    'lib_model.lib8/rtherm.rtherm2 = rth ='
    'lib_model.lib9/rtherm.rtherm2 = rth ='
    'lib_model.lib10/rtherm.rtherm2 = rth ='
    'lib_model.lib1/ctherm.ctherm1 = cth ='
    'lib_model.lib2/ctherm.ctherm1 = cth ='
    'lib_model.lib3/ctherm.ctherm1 = cth ='
    'lib_model.lib4/ctherm.ctherm1 = cth ='
    'lib_model.lib5/ctherm.ctherm1 = cth ='
    'lib_model.lib6/ctherm.ctherm1 = cth ='
    'lib_model.lib7/ctherm.ctherm1 = cth ='
    'lib_model.lib8/ctherm.ctherm1 = cth ='
    'lib_model.lib9/ctherm.ctherm1 = cth ='
    'lib_model.lib10/ctherm.ctherm1 = cth ='};


%   3.  Names of Saber model variables to output back to Simulink
%       (all outputs from S-function)
%       Format: OutputParameterName(primitive.ref)
%       Example: OutputSaberValues={'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'gen_i(generatormonitor.generatormonitor)'
%                                   'pwr(power_load.starter_power_42v)'};
OutputSaberValues={'lib_model.lib1/out(i2var.i2var1)'
%    'current(lib_model.lib1)'
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
    'lib_model.lib1/out(tempc2var.tempc2var1)'
    'lib_model.lib2/out(tempc2var.tempc2var1)'
    'lib_model.lib3/out(tempc2var.tempc2var1)'
    'lib_model.lib4/out(tempc2var.tempc2var1)'
    'lib_model.lib5/out(tempc2var.tempc2var1)'
    'lib_model.lib6/out(tempc2var.tempc2var1)'
    'lib_model.lib7/out(tempc2var.tempc2var1)'
    'lib_model.lib8/out(tempc2var.tempc2var1)'
    'lib_model.lib9/out(tempc2var.tempc2var1)'
    'lib_model.lib10/out(tempc2var.tempc2var1)'
    'lib_model.lib1/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib2/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib3/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib4/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib5/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib6/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib7/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib8/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib9/pwr_flux(var2th_pwr.var2th_pwr1)'
    'lib_model.lib10/pwr_flux(var2th_pwr.var2th_pwr1)'};
%     'batt_temp(lib_model.lib1)'
%     'batt_temp(lib_model.lib2)'
%     'batt_temp(lib_model.lib3)'
%     'batt_temp(lib_model.lib4)'
%     'batt_temp(lib_model.lib5)'
%     'batt_temp(lib_model.lib6)'
%     'batt_temp(lib_model.lib7)'
%     'batt_temp(lib_model.lib8)'
%     'batt_temp(lib_model.lib9)'
%     'batt_temp(lib_model.lib10)'
%     'th_pwr(lib_model.lib1)'
%     'th_pwr(lib_model.lib2)'
%     'th_pwr(lib_model.lib3)'
%     'th_pwr(lib_model.lib4)'
%     'th_pwr(lib_model.lib5)'
%     'th_pwr(lib_model.lib6)'
%     'th_pwr(lib_model.lib7)'
%     'th_pwr(lib_model.lib8)'
%     'th_pwr(lib_model.lib9)'
%     'th_pwr(lib_model.lib10)'


%   4.  Location of Saber model (put your path here if different)
%       Format:  path\
%       Example: ModelPath='c:\ADVISOR\models\Saber\'
ModelPath=strrep(which('advisor'),'advisor.m','models\saber\battery\');


%   5.  Name of Saber model (.sin file) to be used in the co-simulation
%       Format: NameOnly  (don't include ".sin")
%       Example: SaberModelName='Saber_Advisor_dv_cosim'; 
SaberModelName='Lithium_Ion_Pack_10_Module'; 
