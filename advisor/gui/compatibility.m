function compatible_choice=compatibility(name,setting)

% this function created to prevent the user from picking components which are
% incompatible with each other.  Inputs are in pairs:
% example usage: compatible_choice=compatiblity('fc_ver','v01')  checks to see if 
%         'v01' for a fuel converter is a compatible choice with the current selections
%       output is 0 or 1 depending on compatibility

global vinf

compatible_choice=1;

drivetrain=vinf.drivetrain.name;

%get out of this function if drivetrain is custom because there are no limitations then
if strcmp(drivetrain,'custom')
    return
end

%map the drivetrain to ptc ver
drivetrain_list={'conventional';'parallel';'series';'ev';'prius_jpn';'insight';'fuel_cell';'parallel_sa'};
mapping.drivetrain2ptc_ver={'conv';'par';'ser';'ev';'prius_jpn';'insight';'fc';'par'};


%   Limiting "allowable lists" to be used in all drivetrains except custom
allowable.ess_ver={'rc';'rint';'fund';'nnet';'saber'}; % 'saber2' is not included because is only usable in custom

switch drivetrain
    
case 'conventional'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man';'auto';'cvt'};
    mapping.tx_ver2ptc_type={'man';'auto';'cvt'};
    allowable.ptc_ver={'conv'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'saber_conv_sv'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'sabSV'};
    allowable.ptc_ver={'sabSV'};
    allowable.acc_ver={'sabSV'};
    allowable.acc_type={'CONV'};
    allowable.gc_ver={'saber'};
    
case 'saber_conv_dv'
    allowable.ess_ver={'rint','saber2'};
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'sabDV'};
    allowable.ptc_ver={'sabDV'};
    allowable.acc_ver={'sabDV'};
    allowable.acc_type={'CONV'};
    allowable.gc_ver={'saber'};
    
case 'parallel'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man';'auto';'cvt'};
    mapping.tx_ver2ptc_type={'man';'auto';'cvt'};
    allowable.ptc_ver={'par'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'saber_par'
    allowable.ess_ver={'rint','saber2'};
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    allowable.ptc_ver={'sabPar'};
    allowable.acc_ver={'Const';'Var'};
    allowable.gc_ver={'reg'};
    
case 'series'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'man'};
    allowable.ptc_ver={'ser'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'saber_ser'
    allowable.ess_ver={'rint','saber2'};
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    allowable.ptc_ver={'sabSer'};
    allowable.acc_ver={'Const';'Var'};
    allowable.gc_ver={'reg'};
    
case 'ev'
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'man'};
    allowable.ptc_ver={'ev'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'prius_jpn'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'pgcvt'};
    mapping.tx_ver2ptc_type={'pgcvt'};
    allowable.ptc_ver={'prius_jpn'};
    allowable.acc_ver={'Const'}; % 18-April-2002[mpo] removed 'Var' as an option for prius. The models simply aren't there
    %.................................................in the Prius block diagram--this should be addressed later on.
    %allowable.ess_ver={'rint'}; 4/23/01 ss commented this line so any battery could be used with prius
    
case 'fuel_cell'
    allowable.fc_ver={'fc'};
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'man'};
    allowable.ptc_ver={'fc'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'insight'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man'};
    mapping.tx_ver2ptc_type={'man'};
    allowable.ptc_ver={'insight'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
case 'parallel_sa'
    allowable.fc_ver={'ic';'nn_ic'};
    allowable.tx_ver={'man';'auto'};
    mapping.tx_ver2ptc_type={'man';'auto'};
    allowable.ptc_ver={'par'};
    allowable.acc_ver={'Const';'Var';'Sinda'};
    allowable.gc_ver={'reg'};
    
end ; %switch drivetrain




switch name
    
case 'fc_ver'
    t=strmatch(setting,allowable.fc_ver);
    if isempty(t)
        compatible_choice=0;
    end
    
    
case 'fc_type'
    
    
case 'acc_ver'
    t=strmatch(setting,allowable.acc_ver);
    if isempty(t)
        compatible_choice=0;
        
    % BEGIN 29-April-2002:[mpo] checking for incompatibility issues with Sinda/Fluint cosim block
    %end
    elseif strmatch(setting,'Sinda')
        try
            question={'The accessory model you are attempting to select is used for';
                      'running a co-simulation with Sinda/Fluint. To properly run,';
                      'you will require Sinda/Fluint, a *.sin file (from a';
                      'Sinda/Fluint model), and the proper *.dll files required for';
                      'the ActiveX interface. If you do not have these files properly';
                      'setup on your computer, ADVISOR will be unable to run.';
                      ' ';
                      'Do you meet the minimum system requirements necessary for';
                      'running a Sinda/Fluint co-simulation with ADVISOR?'};
            buttonPressed=questdlg(question, 'Sinda/Fluint Co-Sim: Runability Check','Yes','No', 'Help', 'No');
            if strcmp(buttonPressed,'No')|strcmp(buttonPressed,'Help')
                compatible_choice=0;
                if strcmp(buttonPressed,'Help')
                    try
                        load_in_browser('sinda_cosim.html');
                    catch
                        disp('Error encountered while trying to launch user''s browser to help documentation')
                        disp(['[compatibility.m] ', lasterr])
                        dbstack
                    end
                end
            elseif strcmp(buttonPressed, 'Yes')
                compatible_choice=1;
            end
        catch
            disp(['[compatibility.m] ', lasterr])
            dbstack
            compatible_choice=0;
            return
        end
    end
    % END 29-April-2002:[mpo] checking for incompatibility issues with Sinda/Fluint cosim block
    
case 'ptc_ver'
    t=strmatch(setting,allowable.ptc_ver);
    if isempty(t)
        compatible_choice=0;
    end
    
    
case 'gc_ver'
    t=strmatch(setting,allowable.gc_ver);
    if isempty(t)
        compatible_choice=0;
    end
    
case 'ptc_type'
    compatible_choice=0; %for now don't let user pick ptc type
    
case 'ess_ver'
    if isfield(allowable,'ess_ver')
        t=strmatch(setting,allowable.ess_ver,'exact');
        if isempty(t)
            compatible_choice=0;
        end
    end
case 'ess_type'
    
case 'tx_ver'
    t=strmatch(setting,allowable.tx_ver);
    if isempty(t)
        compatible_choice=0;
    end
    if compatible_choice
        %set the ptc version and ptc type appropriately for chosen transmission.
        ptc_type=mapping.tx_ver2ptc_type{t};
        ptc_ver=mapping.drivetrain2ptc_ver{strmatch(drivetrain,drivetrain_list,'exact')};
        
        set(findobj('tag','ptc_ver'),'value',optionlist('value','ptc_ver',ptc_ver))
        vinf.powertrain_control.ver=ptc_ver;
        set(findobj('tag','ptc_type'),'value',optionlist('value','ptc_type',ptc_type,ptc_ver))
        vinf.powertrain_control.type=ptc_type;
        set(findobj('tag','powertrain_control'),'value',1)
        set(findobj('tag','powertrain_control'),'string',optionlist('get','powertrain_control','junk',ptc_ver,ptc_type))
        vinf.powertrain_control.name=gui_current_str('powertrain_control');
        
    end
    
    
case 'tx_type'
    
end ;% end switch name

% 8/21/00 ss updated tx_ver case and the allowable.tx_ver variable.
% 8/21/00 ss added setting of the ptc ver and type and name when tx_ver is the input name.
% 8/30/00 tm, ss allowed automatic transmission for parallel drivetrain
% 10/11/00 ss, updated versions of fc to be ic and fc instead of v01 and v02
% 10/11/00 ss, updated version of tx to be man,auto,cvt, and pgcvt
% 10/11/00 ss, updated version of ptc to be conv,par,ser,ev,prius,insight,fc
% 2/2/01: ss updated prius to prius_jpn
% 1/18/00:tm added auto trans as allowable for parallel SA configurations
% 2/9/01: ss only allowed rint for ess_ver for prius_jpn
% 4/23/01: ss commented out line in prius_jpn so any battery could be used.
% 4/10/02: mpo changed the compatibility to allow for usage of neural network internal combustion models
% 4/29/02: mpo added a confirmation dialogue box and help button for users trying Sinda/Fluint model
