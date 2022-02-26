function [InputSaberParams,OutputSaberValues,ModelPath,SaberModelName]=SaberCosimIO_Template(TempPath)

%   1.  Names of Saber model variables
InputSaberParams={'radio.radio1 = loadcontrol = ',...
        'radio.radio1 = vehicletype = '};

%   2.  Names of Saber model variables to output back to Simulink
OutputSaberValues={'power(power_meter.generator)'
    'p_radio(radio.radio1)'
    'i(radio.radio1)'};

%   3.  Location of Saber model (put your path here if different)
ModelPath=strrep(which('advisor'),'advisor.m','models\Saber\'); 


%   4.  Name of Saber model (.sin file) to be used in the co-simulation
SaberModelName='Saber_Advisor_sv_cosim'; 
