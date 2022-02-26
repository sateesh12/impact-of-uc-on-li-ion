function [InputSaberParams,OutputSaberValues,ModelPath,SaberModelName]=SaberCosimIO_PAR(TempPath,t)

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

convert_motor_tables;

%   Determine if using rint or Saber pb ess for 14v side
if evalin('base','isfield(vinf,''energy_storage'')') &...
        evalin('base','strcmp(vinf.energy_storage.ver,''saber2'')')
    EssType='Saber pb';
elseif evalin('base','isfield(vinf,''energy_storage'')') &...
        evalin('base','strcmp(vinf.energy_storage.ver,''rint'')')
    EssType='rint';
    convert_battery_tables;
end

%   Determine if using rint or Saber pb ess for 42v side
if evalin('base','isfield(vinf,''energy_storage2'')') &...
        evalin('base','strcmp(vinf.energy_storage2.ver,''saber'')')
    Ess2Type='Saber pb';
elseif evalin('base','isfield(vinf,''energy_storage2'')') &...
        evalin('base','strcmp(vinf.energy_storage2.ver,''rint'')')
    Ess2Type='rint';
    convert_battery_tables2;
end

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


%   Get list of Saber parameters
MCParams=GetIOParamList('in','mc');
AuxLoadV14Params=GetIOParamList('in','AuxLoads','V14');
AuxLoadHiVParams=GetIOParamList('in','AuxLoads','HiV');
DCDCParams=GetIOParamList('in','dcdc');
EssParams=GetIOParamList('in','ess',EssType);
Ess2Params=GetIOParamList('in','ess2',Ess2Type);
RegParams=GetIOParamList('in','reg','HiV');
MotorParams=GetIOParamList('in','motor');

InputSaberParams={MCParams{:},...
        'constant.engine_spd = const = ',...
        'power_load.acc_elec_pwr = power_load = ',...
        AuxLoadV14Params{:},...
        AuxLoadHiVParams{:},...
        DCDCParams{:},...
        EssParams{:},...
        Ess2Params{:},...
        RegParams{:},...
        MotorParams{:},...
    }';


%   3.  Names of Saber model variables to output back to Simulink
%       (all outputs from S-function)
%       Format: OutputParameterName(primitive.ref)
%       Example: OutputSaberValues={'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'mech_pwr(generator_generic.generator_generic_42v)'
%                                   'gen_i(generatormonitor.generatormonitor)'
%                                   'pwr(power_load.starter_power_42v)'};

GCOutParams=GetIOParamList('out','gc_ind');
EssOutParams=GetIOParamList('out','ess',EssType);
Ess2OutParams=GetIOParamList('out','ess2',Ess2Type);
DCDCOutParams=GetIOParamList('out','dcdc');
AuxLoadV14OutParams=GetIOParamList('out','AuxLoads','V14');
AuxLoadHiVOutParams=GetIOParamList('out','AuxLoads','HiV');
MCOutParams=GetIOParamList('out','mc');


OutputSaberValues={EssOutParams{:},...
        Ess2OutParams{:},...
        DCDCOutParams{:},...
        'pwr(power_load.acc_elec_pwr)',...
        'i(power_load.acc_elec_pwr)',...
        AuxLoadV14OutParams{:},...
        AuxLoadHiVOutParams{:},...
        MCOutParams{:},...
    }';

                
%   4.  Location of Saber model (put your path here if different)
%       Format:  path\
%       Example: ModelPath='c:\ADVISOR\models\Saber\'
ModelPath=strrep(TempPath,'tmp\','models\Saber\'); 


%   5.  Name of Saber model (.sin file) to be used in the co-simulation
%       Format: NameOnly  (don't include ".sin")
%       Example: SaberModelName='Saber_Advisor_dv_cosim'; 
if strcmp(EssType,'Saber pb') & strcmp(Ess2Type,'Saber pb')
    SaberModelName='Saber_Advisor_parallel_cosim'; 
elseif strcmp(EssType,'rint') & strcmp(Ess2Type,'Saber pb')
    SaberModelName='Saber_Advisor_parallel_rint_cosim'; 
elseif strcmp(EssType,'rint') & strcmp(Ess2Type,'rint')
    SaberModelName='Saber_Advisor_parallel_2rint_cosim';
elseif strcmp(EssType,'Saber pb') & strcmp(Ess2Type,'rint')
    SaberModelName='Saber_Advisor_parallel_rint2nd_cosim';
end




% END OF SECTION THAT NEEDS TO BE CHANGED TO RUN ANY SABER CO-SIMULATION %%%%%%%%%%%%%%%%%%
%==========================================================================================
