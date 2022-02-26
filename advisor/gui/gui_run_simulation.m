function gui_run_simulation(time_step,option)

%function gui_run_simulation() runs the appropriate simulation depending on the 
%type of drivetrain selected

global vinf

evalin('base','if ~exist(''cyc_elevation_init'');cyc_elevation_init=0;end;');

if nargin==0
    time_step=vinf.time_step;
end
assignin('base','time_step',time_step);
evalin('base','replay_length=max(cyc_mph(:,1));'); %outputs info for interactive sim BD

drivetrain=vinf.drivetrain.name;

%simulink block diagram names
bd_name=block_diagram_name(drivetrain);

%Adjust block diagram
flag=0;

%Determine length of simulation
eval('h=vinf.cycle.name; test4exist=1;','test4exist=0;')
if test4exist & (strcmp(vinf.cycle.name,'CYC_ACCEL')|strcmp(vinf.cycle.name,'CYC_5PEAK'))& time_step<1
    durstr=num2str(vinf.cycle.number*evalin('base','cyc_mph(end,1)-0.1'));
    
else
    durstr=num2str(vinf.cycle.number*evalin('base','cyc_mph(end,1)'));
end

%Set default options for simulation
evalin('base',['options=simset(''FixedStep'',',num2str(time_step),');']);

%Options for real world test procedure
eval('h=vinf.test.name; test4exist=1;','test4exist=0;')
if test4exist
    if strcmp(vinf.test.name,'TEST_REAL_WORLD') & strcmp(vinf.test.run,'on')
        dur=str2num(durstr);
        if strcmp(option,'soak')	%variable time step solver	
            durstr=['[1 ' num2str(vinf.cycle.number*evalin('base','cyc_mph(end,1)')) ']'];
            if strcmp(drivetrain,'conventional')
                evalin('base',['options=simset(''Solver'',''ode23tb'',''MaxStep'',',num2str(dur/10),');']);
            else
                %diable variable time step for other than conventional
                evalin('base',['options=simset(''Solver'',''ode1'',''FixedStep'',',num2str(5),');']);
            end
        elseif strcmp(option,'trip')	%fixed step solver
            evalin('base',['options=simset(''Solver'',''ode1'',''FixedStep'',',num2str(time_step),');']);
        end
    end
end


% Setup Altia
if vinf.interactive_sim==1
    % store the current directory and move to the interactive directory
    current_dir=evalin('base','pwd');
    advisor_path=strrep(which('advisor.m'),'\advisor.m','');
    interactive_path=[advisor_path,'\gui\DynamicGraphics'];
    evalin('base',['cd ''',interactive_path,'''']);
else % define constants that altia_off block needs
    assignin('base','fc_plot_axis',[0 1 0 1]);
    assignin('base','mc_plot_axis',[0 1 0 1]);
end

% %Saber cosim, run from /models/Saber so that S-function can delete intermediate files
% if vinf.saber_cosim.run
%     % store the current directory and move to the saber directory
%     current_dir=evalin('base','pwd');
%     advisor_path=strrep(which('advisor.m'),'\advisor.m','');
%     saber_path=[advisor_path,'\models\Saber'];
%     evalin('base',['cd ''',saber_path,'''']);
% end    

adjust_config_bds(bd_name)

%Run the simulation
evalin('base',['sim(''',bd_name,''',',durstr,',options)'])

% Create .mat file for real-time replay
%evalin('base','ReplaySetup(recorded_interactive)');

%Returns path to original path if interactive sim is run and closes altia invoked block diagrams
if vinf.interactive_sim==1
    evalin('base',['cd ''',current_dir,'''']);
%     adjust_BD('close',bd_name,bd_already_open);
end

% %Return to orig path for Saber cosim
% if vinf.saber_cosim.run
%     evalin('base',['cd ''',current_dir,'''']);
% end    


%Choose to keep or delete newly created block diagram
if flag	%flag=1 denotes that a new bd was created
    ans=questdlg(['Do you want to save the block diagram ' bd_name ' for future use?'],'Save BD?','Yes','No','Yes');
    if strcmp(ans,'No')
        close_system(bd_name,0); % 17-Aug-2001 mpo, the 0 indicates that the system should be closed with no save
        %Delete the bd
        i_junk=0;
        while ~exist([bd_name,'.mdl']) % wait for matlab to recognize the existance of bd_name
            i_junk=i_junk+1;
            if i_junk>1000
                break
            end
        end
        clear i_junk;
        file2delete = eval(['which([''',bd_name,'.mdl''','])']);
        eval(['delete(''',file2delete, ''')']);
        clear file2delete;
    end
end

%%%%%%%%%%%%%%%%%%%
% Revision history
%%%%%%%%%%%%%%%%%%%
% 8/28/98: vh added ev simulation call
% 9/03/98: tm added fuelcell simulation call
% 9/30/98: ss replaced gearbox with transmission
%12/22/98: ss replaced strcmp(vinf.transmission.name,'******')  with strcmp(evalin('base','tx_type'),'***')
% 7/02/99: tm added |strcmp(vinf.cycle.name,'CYC_5PEAK') to testing for CYC_ACCEL 
% 6/17/99: vhj real world additions--options, soak cycles are variable time step simulations (changed durstr)
% 6/24/99: vhj RW-variable time step (ode23tb solver) for all drivetrains
% 7/06/99: ss changed ode23tb to ode45 for now so that simulation works.
% 7/09/99: ss added test4exist for real world test.
% 7/14/99: vhj ode45 back to ode23tb for conventional only, fixed step for others
% 7/16/99: ss added prius
% 8/23/99: tm added new fuel cell name
% 9/07/99: ss added new parallel block diagram BD_PTH if tc_pth was picked ('post transmission hybrid')
% 9/13/99: ss added lines to define cyc_elevation_init if not already defined.
% 9/14/99: vhj general bd_name, changed general structure, ask user if want to save new bd (nnet)
% 9/16/99: vhj disabled nnet model for conventional, prius, and fuel cell for now
% 9/20/99: vhj fundamental battery model (2 cases)
% 9/21/99: references full fund batt'y name
% 9/23/99: vhj ode1 for hybrid
% 9/23/99: vhj ode1 with 5 second time step for hybrid
% 12/14/99: tm added a case to the block diagram selection routine to include the 'custom' model
% 7/11/00:tm added block diagram selection conditionals for insight, parallel_sa, and cvt options with parallel hybrids
% 7/28/00:tm added link to bd_par_auto if automatic and parallel selected
% 7/28/00:tm updated link to bd_insight for case insight
% 8/22/00; ss added isfield(vinf,'energy_storage') for running custom without batteries.
%10/30/00: ab added time_step=vinf.time_step
%11/1/00:tm made link to bd_par_auto active
%01/18/01:ab added lines to switch lib_inteactive Altia_on and Altia_off in and out of 'base' BD
% 1/19/01:tm added link to bd_par_split.mdl 
%01/22/01:ab changed altia bd adjusting to call a function; also made current directory adjusting for altia interactive runs% 1/19/01:tm added link to bd_par_sa_auto.mdl
% 1/24/01:ab changed altia on-off adjusting technique
% 1/24/01:ab moved code to adjust_BD
%01/25/01: vhj added case to call Adaptive CS block diagram
%01/29/01: vhj updated line #'s for removing plotting with Adaptive control
% 2/2/01: ss updated prius to prius_jpn
%02/09/01: vhj allow nnet and fund with fuel cell, updated fund names
%03/27/01: vhj create BD for RC battery model, auto save the BD
%05/31/01: vhj save RC model in models directory
%06/01/01: vhj for saber cosim, change to models/saber directory
%07/08/01: mpo changed the selection for nnet model to look at vinf.*.ver instead of the file name (to support users adding custom files)
%08/17/01: mpo changed the close_system command such that file can be closed without save if user desires
%01/02/02: vhj create BD for Saber battery cosim