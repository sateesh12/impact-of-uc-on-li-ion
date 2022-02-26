function [InputSaberParams,OutputSaberValues,ModelPath,SaberModelName]=SaberCosimIO_Template(TempPath)

%=========================================================================================
% *** NOTE: The simulink block diagram must reflect the inputs and outputs in the
%           order of the corresponding list.  
%           Inputs: InputSaberParams
%           Outputs: OutputSaberValues
%   Required steps to customize include:
%   1.  Make list of names of Saber model variables to input from Simulink
%       (all inputs to S-function)
%   2.  Make list of names of Saber model variables to output back to Simulink 
%       (all outputs from S-function)
%   3.  Identify location of Saber model if different than "sinpath" 
%       (or vinf.saber_cosim.sinpath in Matlab workspace)
%   4.  Idenfity name of Saber model to be used in the co-simulation
%
% *** NOTE: You can only use as many of these co-simulation s-functions at one time
%           as you have Saber licenses available to open Saber.  A different Saber 
%           session will be opened for each co-simulation s-function.  Although
%           multiple s-functions may be possible, it has not been tested



%   1.  a.  Names of Saber model variables (inputs to S-function)
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

InputSaberParams={''};


%   2.  Names of Saber model variables to output back to Simulink
%       (all outputs from S-function)
%       Format: OutputParameterName(primitive.ref)
%       Example: OutputSaberValues={'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'gen_i(generatormonitor.generatormonitor)'
%                                   'pwr(power_load.starter_power_42v)'};
OutputSaberValues={''};


%   3.  Location of Saber model (put your path here if different)
%       Format:  path\
%       Example: ModelPath='c:\ADVISOR\models\Saber\'
ModelPath=''; 


%   4.  Name of Saber model (.sin file) to be used in the co-simulation
%       Format: NameOnly  (don't include ".sin")
%       Example: SaberModelName='Saber_Advisor_dv_cosim'; 
SaberModelName=''; 
