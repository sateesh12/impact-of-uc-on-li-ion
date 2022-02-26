function adjust_config_bds(bd_name,list2check4subcons)
%set all the configurable subsystems to their proper choices for the current 
%block diagram

if nargin==0
    error('need bd_name as input argument')
end

global vinf

%only load system the first time through
if nargin==1
    %suppress warnings for now
    warning off
    adjust_config_bds_finished=0;
    load_system(bd_name)
    %find all subsystems in the block diagram
    sub=find_system(bd_name,'FollowLinks', 'on', 'LookUnderMasks','all','BlockType','SubSystem');

    %set the subcon variable to empty (this will hold all the names of the configurable subsystems)
    subcon=[];
    
    %select only those subsystems with length of BlockChoice not equal to 0 (configurable subsystems)
    for i=1:length(sub)
        if (length(get_param(sub{i},'BlockChoice')))~=0    
            subcon{end + 1}=sub{i};				
        end
    end
    
end

if nargin==2
    %find all subsystems below the list2check4subcons level
    sub=[];
    for i=1:length(list2check4subcons)
        subtemp=find_system(list2check4subcons{i},'FollowLinks', 'on', 'LookUnderMasks','all','BlockType','SubSystem');
        subtemp=subtemp(2:end);%remove the top block from the list
        if ~isempty(subtemp)
            sub=[sub;subtemp];
        end
    end
    %set the subcon variable to empty (this will hold all the names of the configurable subsystems)
    subcon=[];
    
    %select only those subsystems with length of BlockChoice not equal to 0 (configurable subsystems)
    if ~isempty(sub)
        for i=1:length(sub)
            if (length(get_param(sub{i},'BlockChoice')))~=0    
                subcon{end + 1}=sub{i};				
            end
        end
    end
end

%stop the recursion if no more configurable subsystems to set
if isempty(subcon)
    %turn warnings back on
    warning on
    
    return
end

%Make subcon only a list of "top" level config subsystems
index4removal=[];
for i=1:length(subcon)
    %introduce subcontemp which replaces current subcon with ' ' so it doesn't strmatch itself
    subcontemp=subcon;
    subcontemp(i)={' '};
    
    indextemp=strmatch(subcon{i},subcontemp);
    if ~isempty(indextemp)
        index4removal=[index4removal;indextemp];
    end
end    
%remove all unwanted subs
keepers={};
j=1;
for i=1:length(subcon)
    findindex=find(index4removal==i);
    if isempty(findindex)
       keepers(j)=subcon(i);
       j=j+1;
   end
end
subcon=keepers;

%this is for the next call to check for next level down configurable subsystems
list2check4subcons=subcon;

%for all configurable subsystems, make sure the proper block choice is selected.
for i=1:length(subcon)
    
    x=get_param(subcon{i},'Handle');   %gets the handle of the configurable subsystem
    
    name=get_param(x,'Name'); %get just the name of the block, without complete hierarchy detail.
    
    memberblocks=get_param(x,'MemberBlocks');     %view all the block  choices for the first  conf. subsystem	
    
    switch name
    case 'rolling resistance force'
        BlockChoices={'force req''d to overcome rolling resistance (N)';
                      'force req''d to overcome rolling resistance (N) j2452'};
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
            
        if strcmp(vinf.wheel_axle.ver,'Crr')
            set_param(x,'BlockChoice',BlockChoices{1})
        elseif strcmp(vinf.wheel_axle.ver,'J2452')
            set_param(x,'BlockChoice',BlockChoices{2})    
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
    case 'vehicle speed'
        BlockChoices={'vehicle speed (m/s)';
                      'vehicle speed (m/s) j2452'};
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
            
        if strcmp(vinf.wheel_axle.ver,'Crr')
            set_param(x,'BlockChoice',BlockChoices{1})
        elseif strcmp(vinf.wheel_axle.ver,'J2452')
            set_param(x,'BlockChoice',BlockChoices{2})    
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
    case 'roll res interactive'
                BlockChoices={'roll res force req (N)';
                      'roll res force req (N) j2452'};
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
            
        if strcmp(vinf.wheel_axle.ver,'Crr')
            set_param(x,'BlockChoice',BlockChoices{1})
        elseif strcmp(vinf.wheel_axle.ver,'J2452')
            set_param(x,'BlockChoice',BlockChoices{2})    
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
    case 'config traction control'
        BlockChoices={'traction control 2 axle';
                      'traction control J2452 2 axle'};
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
            
        if strcmp(vinf.wheel_axle.ver,'Crr')
            set_param(x,'BlockChoice',BlockChoices{1})
        elseif strcmp(vinf.wheel_axle.ver,'J2452')
            set_param(x,'BlockChoice',BlockChoices{2})    
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
    case 'electrical accessories (W)'
        BlockChoices={'Electrical Accessories: Constant';
            'Electrical Accessories: Time Variable'};
        block_choice_default=2; % added 2-April-2002: mpo: setting the default choice
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if evalin('base','exist(''acc_elec_model_name'')') %mpo[7-MAR-2002] if acc_elec_model_name exists in the workspace...
            try
                acc_elec_model_name=evalin('base','acc_elec_model_name');
                block_choice=find(strcmp(acc_elec_model_name,BlockChoices));
            catch
                block_choice=block_choice_default;
                warning('acc_elec_model_name does not contain a valid electrical accessory library--see adjust_config_bds.m');
            end
        else
            block_choice=block_choice_default;   
        end
       
        % mpo 29-April-2002
        % added support for all the subcases: Var, Saber, and Sinda *could* use different elec load models while Const does not
        if strcmp(vinf.accessory.ver,'Var')|strcmp(vinf.accessory.ver,'Saber')|strcmp(vinf.accessory.ver,'Sinda')
            set_param(x,'BlockChoice',BlockChoices{block_choice})
        elseif strcmp(vinf.accessory.ver, 'Const') %08-MAR-2002[mpg] if not 'Var'...
            set_param(x,'BlockChoice',BlockChoices{block_choice_default}) %02-April-2002[mpo]: default block choice 
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'mechanical accessories (Nm)'
        BlockChoices={'Mechanical Accessories: Const Mech Var Elect';
            'Mechanical Accessories: Constant Mechanical & Electrical';
            'Mechanical Accessories: Speed Dependant and Variable Electrical';
            'Saber Dual Voltage Cosim';
            'Saber Single Voltage Cosim';
            'SindaTransAC'};
        block_choice_default=1;
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
            
        
        if evalin('base','exist(''acc_mech_model_name'')')
            try
                acc_mech_model_name=evalin('base','acc_mech_model_name');
                block_choice=find(strcmp(acc_mech_model_name,BlockChoices));
            catch
                block_choice=block_choice_default;
                warning('acc_mech_model_name does not contain a valid mechanical accessory library--see adjust_config_bds.m');
            end
        else
            block_choice=block_choice_default;
        end
        
        % 29-APRIL-2002:mpo added the "OR strcmp(vinf.accessory.ver, 'Sinda') line..."
        if strcmp(vinf.accessory.ver, 'Var')  | strcmp(vinf.accessory.ver, 'sabSV') | strcmp(vinf.accessory.ver, 'sabDV')| strcmp(vinf.accessory.ver, 'Sinda')
            set_param(x,'BlockChoice',BlockChoices{block_choice})
        elseif strcmp(vinf.accessory.ver, 'Const') %08-MAR-2002[mpg] if not 'Var'...
            set_param(x,'BlockChoice',BlockChoices{block_choice_default}) % 2-April-2002[mpo]: don't let blocks vary if version is Const
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'Series Cosim'
        BlockChoices={'Series Saber Cosim';
            'Series Simplorer Cosim';
            'Saber Text File Exchange'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.drivetrain.name,'saber_ser')
            set_param(x,'BlockChoice',BlockChoices{3})
        elseif strcmp(vinf.name,'SERIES_Saber_qCosim_in')
            set_param(x,'BlockChoice',BlockChoices{1})   
        elseif strcmp(vinf.name,'SERIES_Simpl_Cosim_in')
            set_param(x,'BlockChoice',BlockChoices{2})
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'Parallel Cosim'
        BlockChoices={'Par Saber Text File Exchange'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.drivetrain.name,'saber_par')
            set_param(x,'BlockChoice',BlockChoices{1})
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'ess param inputs'
        BlockChoices={'Saber lib pb';
            'Rint'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if isfield(vinf,'energy_storage') & strcmp(vinf.energy_storage.ver,'saber2') & strcmp(vinf.energy_storage.type,'pb')
            set_param(x,'BlockChoice',BlockChoices{1});
        elseif isfield(vinf,'energy_storage') & strcmp(vinf.energy_storage.ver,'rint')
            set_param(x,'BlockChoice',BlockChoices{2});
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'ess2 param inputs'
        BlockChoices={'Saber lib pb2';
            'Rint2'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if isfield(vinf,'energy_storage2') & strcmp(vinf.energy_storage2.ver,'saber') & strcmp(vinf.energy_storage2.type,'pb')
            set_param(x,'BlockChoice',BlockChoices{1});
        elseif isfield(vinf,'energy_storage2') & strcmp(vinf.energy_storage2.ver,'rint')
            set_param(x,'BlockChoice',BlockChoices{2});
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
        
    case 'Saber_ess_outputs'
        BlockChoices={'Saber_pb';
            'Saber_rint'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if isfield(vinf,'energy_storage') & strcmp(vinf.energy_storage.ver,'saber2') & strcmp(vinf.energy_storage.type,'pb')
            set_param(x,'BlockChoice',BlockChoices{1});
        elseif isfield(vinf,'energy_storage') & strcmp(vinf.energy_storage.ver,'rint')
            set_param(x,'BlockChoice',BlockChoices{2});
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'Saber_ess2_outputs'

        BlockChoices={'Saber_pb2';
                'Saber_rint2'};
            
            %make sure block choices exist in memberblocks
            CheckBlocks(BlockChoices,memberblocks,i)  
            
            if isfield(vinf,'energy_storage2') & strcmp(vinf.energy_storage2.ver,'saber') & strcmp(vinf.energy_storage2.type,'pb')
                set_param(x,'BlockChoice',BlockChoices{1});
            elseif isfield(vinf,'energy_storage2') & strcmp(vinf.energy_storage2.ver,'rint')
                set_param(x,'BlockChoice',BlockChoices{2});
            else
                error(['BlockChoice not set for ' subcon{i}])
            end
        
        
    case 'Interactive Graphics'
        BlockChoices={'off'
            'on'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if vinf.interactive_sim
            set_param(x,'BlockChoice',BlockChoices{2})
        elseif ~vinf.interactive_sim
            set_param(x,'BlockChoice',BlockChoices{1})
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'ess config'
        BlockChoices={'Ultracapacitor  System';
            'energy storage <ess>';
            'energy storage <ess> RC';
            'energy storage <ess> nnet';
            'energy storage <ess> Saber';
            'energy storage <ess> fundamental model';
            'energy storage <ess> optima fundamental model'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.energy_storage.ver,'rc') 
            
            if strcmp(vinf.energy_storage.type,'cap')
                %Ultra Cap RC model
                set_param(x,'BlockChoice',BlockChoices{1})
            else %all other types are assumed to be RC battery models
                %RC battery model
                set_param(x,'BlockChoice',BlockChoices{3})
            end
            
        elseif strcmp(vinf.energy_storage.ver,'rint') 
            %rint battery model
            set_param(x,'BlockChoice',BlockChoices{2})
            
        elseif strcmp(vinf.energy_storage.ver, 'nnet')
            %nnet battery model
            set_param(x,'BlockChoice',BlockChoices{4})
            
        elseif strcmp(vinf.energy_storage.ver,'saber') & ~strcmp(vinf.energy_storage.type,'ser_pb') & ~strcmp(vinf.energy_storage.type,'pb')
            %Saber co-simulation with batteries
            set_param(x,'BlockChoice',BlockChoices{5})
            
            
        elseif strcmp(vinf.energy_storage.name,'ESS_PB16_fund_generic_temp') 
            %Fundamental Battery Model, generic
            set_param(x,'BlockChoice',BlockChoices{6})
            
        elseif strcmp(vinf.energy_storage.name,'ESS_PB16_fund_optima_temp')
            %Fundamental Battery Model, optima hard coded parameters
            set_param(x,'BlockChoice',BlockChoices{7})
            
        else
            error(['BlockChoice not set for ' subcon{i}])
        end
        
    case 'fuel use and EO emis Configurable Subsystem'
        BlockChoices={'fuel use and EO emis';
            'fuel use and EO emis Neural Network Model'};
        block_choice_default=1;
        block_choice_neuralNet=2;
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.fuel_converter.ver, 'nn_ic')
            set_param(x,'BlockChoice',BlockChoices{block_choice_neuralNet})
        else
            set_param(x,'BlockChoice',BlockChoices{block_choice_default})
        end        
    case 'par <cs> config'
        BlockChoices={'Adaptive control strategy <cs>';
            'Fuzzy Logic control strategy <cs>';
            'Fuzzy Logic control strategy with Emissions <cs>';
            'electric assist control strategy <cs>';
            'electric assist control strategy bal <cs>'};
        block_choice_adapt=1;
        block_choice_fuzzy=2;
        block_choice_fuzzy_emis=3;
        block_choice_elec_assist=4;
        block_choice_elec_assist_bal=5;
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.powertrain_control.name,'PTC_PAR_Adapt')
            set_param(x,'BlockChoice',BlockChoices{block_choice_adapt})
        elseif (strcmp(vinf.powertrain_control.name,'PTC_FUZZY_EFF_MODE') | strcmp(vinf.powertrain_control.name,'PTC_FUZZY_FUEL_MODE'))
            set_param(x,'BlockChoice',BlockChoices{block_choice_fuzzy})
            % run the code to generate target ICE lines
            evalin('base','fuzzy_target_compute');
            
        elseif strcmp(vinf.powertrain_control.name,'PTC_FUZZY_EMISSIONS')
            set_param(x,'BlockChoice',BlockChoices{block_choice_fuzzy_emis})
        elseif strcmp(vinf.powertrain_control.name,'PTC_PAR_BAL')
            set_param(x,'BlockChoice',BlockChoices{block_choice_elec_assist_bal})
        else
            set_param(x,'BlockChoice',BlockChoices{block_choice_elec_assist})
        end        
        
    case 'par <vc> config'
        BlockChoices={'<vc> par';
            '<vc> par Adaptive';
            '<vc> par balanced'};
        block_choice_par=1;
        block_choice_par_adapt=2;
        block_choice_par_bal=3;
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.powertrain_control.name,'PTC_PAR_Adapt')
            set_param(x,'BlockChoice',BlockChoices{block_choice_par_adapt})
        elseif strcmp(vinf.powertrain_control.name,'PTC_PAR_BAL')
            set_param(x,'BlockChoice',BlockChoices{block_choice_par_bal})
        else
            set_param(x,'BlockChoice',BlockChoices{block_choice_par})
        end        
      
    case 'fuel cell config'
        BlockChoices={'fuel converter <fc> GCTool linkage';
            'fuel converter <fc> net model';
            'fuel converter <fc> polarization curve model';
            'fuel converter <fc>  KTH fc model';
            'fuel converter <fc> VT model'};
        block_choice_gctool=1;
        block_choice_net=2;
        block_choice_polar=3;
        block_choice_KTH=4;
        block_choice_VT=5;
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.fuel_converter.type,'gctool')
            set_param(x,'BlockChoice',BlockChoices{block_choice_gctool})
        elseif strcmp(vinf.fuel_converter.type,'net')
            set_param(x,'BlockChoice',BlockChoices{block_choice_net})
        elseif strcmp(vinf.fuel_converter.type,'polar')
            set_param(x,'BlockChoice',BlockChoices{block_choice_polar})
        elseif strcmp(vinf.fuel_converter.type,'KTH')
            set_param(x,'BlockChoice',BlockChoices{block_choice_KTH})
        elseif strcmp(vinf.fuel_converter.type,'VT')
            %clear bd_fuelcell.mdl
            %get_param(x,'MemberBlocks')
            set_param(x,'BlockChoice',BlockChoices{block_choice_VT})
        end        
        
     case 'fuel cell <cs> config'
        BlockChoices={'fuel cell adaptive <cs>';
            'fuel cell control strategy <cs>'};
        
        %make sure block choices exist in memberblocks
        CheckBlocks(BlockChoices,memberblocks,i)  
        
        if strcmp(vinf.powertrain_control.name,'PTC_FUELCELL_ADAPT')
            set_param(x,'BlockChoice',BlockChoices{1})
        else
            set_param(x,'BlockChoice',BlockChoices{2})
        end        
        
    otherwise
        error(['Configurable Subsystem: ' subcon{i} ' Not set properly'])
    end

end

%call again to check next level
adjust_config_bds(bd_name,list2check4subcons)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function CheckBlocks(BlockChoices,memberblocks,i)
%   This function checks that the block choices exist in memberblocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CheckBlocks(BlockChoices,memberblocks,i)

for j=1:length(BlockChoices)
    if ~strmatch(BlockChoices{j},memberblocks)
        error(['Block Choices do not match for ' subcon{i}])
    end
end



% Change Log
% 06-MAR-2002[mpo]: added flag variables acc_mech_model_name and acc_elec_model_name that list the file to be used
% 08-MAR-2002[mpo]: added elseif statements to cover all conditions
% 28-MAR-2002[ab]:  added block choice for Saber cosimulation
% 29-MAR-2002[mpo]: removed the *no alternator' choices for Mechanical Accessory config subsystems (they were redundant)
% 29-MAR-2002[mpo]: added SindaTransAC as a Mechanical Accessory Model Option
% 02-APR-2002[mpo]: changed the handling of mech and elec acc loads blocks--if 'Const' version, they can't switch
% 10-APR-2002[mpo]: added the case for 'fuel use and EO emis Configurable Subsystem'
% 29-APR-2002[mpo]: added support for Sinda co-sim model1
% 2-MAY-2002 [kh]:  in case 'fuel cell config': added a 4th option in BlockChoices, replaced 'else' with 'elseif'
% 12-aug-2002 [tm]:  in case 'fuel cell config': added a 5th option in BlockChoices
% 12-DEC-2002 [bj tm]: added fuel cell <cs> config: choice between two control strategy config subsystems.
% 3/3/03:tm update the traction control section for 2 axle models