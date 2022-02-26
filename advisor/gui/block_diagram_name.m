function bd_name=block_diagram_name(drivetrain)
%function block_diagram_name outputs bd_name based on drivetrain and components
%selected.  Input is drivetrain name.

global vinf

switch drivetrain
case 'conventional'
    % %   if vinf.saber_cosim.run & strcmp(vinf.saber_cosim.type,'custom')
    % %       if strcmp(evalin('base','tx_type'),'cvt')
    % %           bd_name='BD_CONVCVT_Saber_custom';
    % %       elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
    % %           bd_name='BD_CONVAT_Saber_custom';
    %        else
    %            bd_name='BD_CONV_Saber_custom';
    %        end
    %    elseif vinf.saber_cosim.run & strcmp(vinf.saber_cosim.type,'SV')
    %        if strcmp(evalin('base','tx_type'),'cvt')
    %            bd_name='BD_CONVCVT_saber_sv';
    %        elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
    %            bd_name='BD_CONVAT_saber_sv';
    %        else
    %            bd_name='BD_CONV_saber_sv';
    %        end
    %    elseif vinf.saber_cosim.run & strcmp(vinf.saber_cosim.type,'DV')
    %        if strcmp(evalin('base','tx_type'),'cvt')
    %            bd_name='BD_CONVCVT_saber_dv';
    %        elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
    %            bd_name='BD_CONVAT_saber_dv';
    %        else
    %            bd_name='BD_CONV_saber_dv';
    %        end
    % elseif strcmp(evalin('base','tx_type'),'cvt')
    if strcmp(evalin('base','tx_type'),'cvt')
        bd_name='BD_CONVCVT';
    elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
        bd_name='BD_CONVAT';
    else
        bd_name='BD_CONV';
    end
case 'series'
    bd_name='BD_SER';
case 'parallel'
    if strcmp(vinf.torque_coupling.name,'TC_PTH')
        bd_name='BD_PTH';
    elseif strcmp(evalin('base','tx_type'),'cvt')
        bd_name='BD_PAR_CVT';
    elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
        bd_name='BD_PAR_AUTO';
    else
        bd_name='BD_PAR';
        if strcmp(vinf.powertrain_control.name,'PTC_PAR_Adapt')
            disp('Note: to turn off Adaptive Control plotting, set the variable plotalloutput (line 24)')
            disp('      or plotperformance (line 25) to 0 in \gui\minimum_energy9.m');
        end
    end
case 'parallel_sa'
    if strcmp(evalin('base','tx_type'),'cvt')
        bd_name='BD_PAR_SA_CVT';
    elseif strcmp(evalin('base','tx_type'),'auto 4 speed')
        bd_name='BD_PAR_SA_AUTO';
    else
        bd_name='BD_PAR_SA';
    end
case 'insight'
    bd_name='BD_INSIGHT';
case 'fuel_cell'
    bd_name='BD_FUELCELL';   
case 'ev'
    bd_name='BD_EV';
case 'prius_jpn'
    bd_name='BD_PRIUS_JPN'; %the toyota prius block diagram
case 'saber_conv_sv'
    bd_name='BD_CONV';
case 'saber_conv_dv'
    bd_name='BD_CONV';
case 'saber_ser'
    bd_name='BD_SER_saber_cosim';
case 'saber_par'
    bd_name='BD_PAR_saber_cosim';
case 'custom'
    bd_name=vinf.block_diagram.name;
end

%revision history
%1/31/01 ss created from replaced section of gui_run_simulation
% 1/31/01:tm updated reference for BD_PAR_balanced t BD_PAR_BAL
% 1/31/01:tm commented out statements for BD_PAR_SPLIT - to be used in a future release
% 2/2/01:ss changed prius to prius_jpn
%02/09/01: vhj updated note about Adaptive plotting
%02/15/01: vhj added saber custom for conventional
%02/20/01: vhj added saber custom for convcvt and convat
%05/31/01: vhj added saber single voltage for all conventional
%06/14/01: vhj added saber dual voltage for all conventional
%04/11/02: mpo commenting out the saber dual voltage stuff (this is no longer being implemented this way)