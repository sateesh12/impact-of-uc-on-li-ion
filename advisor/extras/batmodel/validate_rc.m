%validate_rc

evalin('base','clear all;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get the ADVISOR battery file
[f p]=uigetfile('*.m','ADVISOR RC battery file');
if f==0
    return
end

%load the battery file
evalin('base',['run ''' p f '''']);

%load the data file
%Data variables: t_data, volts_data, current_data, pwr_data, ah_data, temp_data
[f p]=uigetfile('*.mat','Test Data file');
if f==0
    return
end
%load the test data file
evalin('base',['load ''' p f ''''])

%adjust to begin at t=0
t_data=t_data-t_data(1);
%neg=discharge in test, pos=discharge in model
current_data=-1*current_data;
pwr_data=-1*pwr_data;

if 1    %just for validation of SOC, saft
    %evalin('base','ess_soc_old=[0 10 20 40 60 80 100]/100;  % (--)	');
    evalin('base','ess_tmp_old=[0 25 41];  % (C)');
    % Parameters vary by SOC horizontally, and temperature vertically
    evalin('base','ess_max_ah_cap_old=[5.943 7.035 7.405];');
    % (A*h), max. capacity at C/3 rate, indexed by ess_tmp
    % average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
    evalin('base','ess_coulombic_eff_old=[0.968 0.99 0.992];  % (--)');
    % module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
    %evalin('base','ess_voc_old=[3.44 3.473 3.496 3.568 3.637 3.757 3.896;3.124 3.349 3.433 3.518 3.616 3.752 3.898;3.128 3.36 3.44 3.528 3.623 3.761 3.899]; % (V)');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Setting Up initial conditions')
%Set parameters in workspace
%temperature
Temperature=temp_data(1);
%initial SOC 
[SOC_index,Tmp]=meshgrid(ess_soc,ess_tmp);
%Limit SOC and Temperature of inputs
if Temperature>max(ess_tmp)
    mod_tmp=max(ess_tmp);
elseif Temperature<min(ess_tmp)
    mod_tmp=min(ess_tmp);
else
    mod_tmp=Temperature;
end
voc4interp=griddata(Tmp,SOC_index,ess_voc,mod_tmp,ess_soc)';
Vmax=interp1(ess_soc,voc4interp,1);
Vmin=interp1(ess_soc,voc4interp,0);
if volts_data(1)/ess_module_num>Vmax, SOC=1;
elseif volts_data(1)/ess_module_num<Vmin, SOC=0;
else
    SOC=interp1(voc4interp,ess_soc,volts_data(1)/ess_module_num); %Evaluate SOC at volts_data(1)
end
init_soc=SOC;

assignin('base','ess_init_soc',SOC);
assignin('base','starttime',0);
assignin('base','endtime',t_data(end));
%assignin('base','endtime',1600);
%assignin('base','endtime',100);
%assignin('base','endtime',1500+3500);
%end_volts=volts_data(min(find(t_data>=(1500+3595))));
end_volts=volts_data(min(find(t_data>=(1500+3290))));
end_soc=interp1(voc4interp,ess_soc,end_volts);
disp(['Ending voltage: ',num2str(end_volts),' Ending SOC: ',num2str(end_soc)]);

mc_min_volts=0; %effectively zero-out this condition
cyc_mph(1,2)=3;
enable_stop=0;
ess_on=1;
%initial conditions
vinf.init_conds.amb_tmp=20;            	% deg. C, ambient temperature
vinf.init_conds.air_cp=1009;              % J/kgK  ave cp of air
vinf.init_conds.ess_mod_init_tmp=Temperature;   % C      initial eng cyl temp
%evaluate all the initial conditions in the base workspace
tempnames=fieldnames(vinf.init_conds);%get all the names of the variables pertaining to initial conditions
for tempindex=1:max(size(tempnames))
    assignin('base',tempnames{tempindex},eval(['vinf.init_conds.',tempnames{tempindex}]));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run the simulation
disp('Running RC simulation')
x=1;
sim('sim_validate_rc');
disp('Finished running ADVISOR RC model')
%save data to variable model 1 (RC model)
model1=[t ess_current pb_voltage ess_pwr_out_a ess_soc_hist ess_temperature];
model=model1;

%Compare to Rint model?
answer=questdlg('Compare to Rint model?');
if strcmp(answer, 'Yes')
    %Get the ADVISOR battery file
    [f p]=uigetfile('*.m','ADVISOR Rint battery file');
    if f==0
        return
    end
    %load the battery file
    evalin('base',['run ''' p f '''']);
    
    %run the simulation
    disp('Running Rint simulation')
    x=1;
    sim('sim_validate_rint');
    disp('Finished running ADVISOR Rint model')
    
    %Rint model
    model2=[t ess_current pb_voltage ess_pwr_out_a ess_soc_hist ess_temperature];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Post-process and plot
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    validate_rc_results_2models
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Post-process and plot
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    validate_rc_results
end


%Revision history
%03/13/01: vhj file created
%03/19/01: vhj working, call validate_rc.mdl, post-processing/plotting started from saftmodelfile
%03/07/02: vhj loading files with spaces in the directory corrected