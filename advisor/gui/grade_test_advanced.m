function [cyc_grade_max_a,gear_ratio_a]=grade_test(varargin)
%
% This function finds the maximum grade at which
% the vehicle can maintain a constant speed for the specified duration. 
% All input parameters are optional.  Inputs must be defined in 
% pairs {i.e. grade_test(Parameter_Name1, Parameter_Value1,...Parameter_NameN, Parameter_ValueN)}.
%
% Input arguments:
%		disp_status		(boolean), 1==>0 display status in command window, 0==> do not display status [optional]
%		grade				(%), grade the vehicle will try to achieve  [optional]
%		duration			(s), duration over which the vehicle must maintain speed and grade [optional]
%		speed				(mph), the speed the vehicle is to achieve at the specified grade [optional]
%		gear_num			(--), user specified gear ratio in which test is to be performed [optional]
%		ess_init_soc	(--), user specified initial SOC of the ESS [optional]
%		ess_min_soc		(--), user specified minimum SOC of the ESS [optional]
%		grade_lb			(%), grade lower bound for search [optional]
%		grade_ub			(%), grade upper bound for search [optional]
%		grade_init_step(%), grade initial step size [optional]
%		speed_tol		(mph), convergence tolerance on speed [optional]
%		max_iter			(--), maximum number of interations [optional]
%		grade_tol		(%), convergence tolerance on grade [optional]
%		disable_systems(--), flag to disable systems 1=disable ess, 2=disable fc [optional]
%		override_mass	(kg), override the current vehicle mass with specified mass [optional]
%		add_mass			(kg), add specified mass to current vehicle mass [optional]
%
% NOTES:
%	1) If neither grade nor speed is specified, the script will find the max 
%		grade achievable at 55 mph.
%  2) If a speed argument is provided, the script will find the max grade 
%		at the specified speed.
%  3) If both a speed and a grade argument is provided, the script will only 
%		test that one point and return an empty set if unsuccessful or the grade 
%		if successful.
%
% Output arguments:
%		cyc_grade_max_a	(%), grade achieved, empty set if unsuccessful
%		gb_ratio_a			(--), gear ratio in which vehicle performed grade test
%


% give the function access to all vehicle config info 
global vinf

% set of default input parameters
defaults={'speed',55,...
      'duration',10,...
      'grade',[],...
      'grade_lb',0,...
      'grade_ub',10,...
      'grade_init_step',1,...
      'disp_status',0,...
      'ess_init_soc',[],...
      'ess_min_soc',[],...
      'max_iter',25,...
      'speed_tol',0.01,...
      'grade_tol',0.05,...
      'gear_num',[],...
      'disable_systems',0,...
      'override_mass',[],...
      'add_mass',[]};

% list of variables to be stored and restored because 
% their value will be overriden
variables={'mc_overtrq_factor',...
      'gb_num_init',...
      'ess_init_soc',...
      'acc_elec_pwr',...
      'acc_mech_pwr',...
      'enable_stop_fc',...
      'cs_fc_init_state',...
      'gb_shift_delay',...
      'gb_ratio',...
      'cyc_mph',...
      'fc_on',...
      'ess_on',...
      'veh_mass',...
      'vc_key_on',...
      'cyc_grade',...
      'cyc_cargo_mass',...
      'cyc_filter_bool',...
      'cs_fc_init_state',...
      'cyc_avg_time',...
      'cs_max_pwr_rise_rate',...
      'cs_electric_launch_spd',...
      'cs_off_trq_frac',...
      'cs_min_trq_frac',...
      'cs_charge_trq',...
      'cs_charge_pwr'};

cyc_grade_max_a=[];
gb_ratio_a=[];

% initialize user-defined input parameter and values
if exist('varargin') % any parameters given?
   if (mod(length(varargin),2)==0) % parameters in pairs?
      for i=1:2:length(varargin)-1
         eval([varargin{i},'=',num2str(varargin{i+1}),';']);
      end
   else
      disp('Error: unmatched input arguments.')
      cyc_grade_max_a=[];
      gb_ratio_a=[];
      return
   end
end

% set default display properties, 1==> display results, 0==> don't display results
if ~exist('disp_status')
   disp_status=defaults{find(strcmp(defaults,'disp_status'))+1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORE CURRENT WORKSPACE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
store(variables) % see subroutines below

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD THE DRIVE CYCLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('speed')
   speed=defaults{find(strcmp(defaults,'speed'))+1};
end
if ~exist('duration')
   duration=defaults{find(strcmp(defaults,'duration'))+1};
end
build_cycle(speed,duration) % see subroutines below

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE TARGETS AND TOLERANCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tolerances
if ~exist('grade_tol')
   grade_tol=defaults{find(strcmp(defaults,'grade_tol'))+1};
end
if ~exist('speed_tol')
   speed_tol=defaults{find(strcmp(defaults,'speed_tol'))+1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERRIDE VEHICLE DRIVETRAIN VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if evalin('base','exist(''gb_ratio'')') % if not prius
   
   % get current gear ratios
   ratios=evalin('base','gb_ratio');
   
   % if gear number provided use it
   if exist('gear_num')
      ratios=ones(size(ratios))*ratios(min([gear_num length(ratios)]));
   end
   
   % check for speed limited case and assign ratio conditions
   if strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'series')
      spds=speed*0.447.*ratios*evalin('base','fd_ratio/wh_radius'); % estimate possible motor speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','mc_map_spd*mc_spd_scale'))); % limit to those speeds within the motor map
      trqs=evalin('base',['interp1(mc_map_spd*mc_spd_scale,mc_max_trq*mc_trq_scale,',mat2str(spds),')']); % determine max torque (continuous) at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
   else
      spds=speed*0.447.*ratios*evalin('base','fd_ratio/wh_radius'); % estimate possible engine speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','fc_map_spd*fc_spd_scale'))); % limit to those speeds within the engine map
      trqs=evalin('base',['interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,',mat2str(spds),')']); % determine max torque at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
   end
   if isempty(gear_number)|(nnz(spds)<1)
      disp(' ')
      disp('WARNING: Vehicle cannot achieve goal speed with current drivetrain!!')
      disp(' ')
      grade_test_spd_limited=1;
   else % not speed limited     
      grade_test_spd_limited=0;
      gb_climbgear=gear_number;
      if ~evalin('base','exist(''gb_map_trq_out'')') % cvt in use?
         if exist('gear_num') % if gear number provided fix gearbox to that ratio
            assignin('base','gb_ratio',ones(size(default_gb_ratio))*ratios(gb_climbgear));
         else
            assignin('base','gb_ratio',ones(size(default_gb_ratio))*default_gb_ratio(gb_climbgear));
         end
         assignin('base','gb_num_init',gb_climbgear) % setup initial gear ratio
      end
   end
else
   grade_test_spd_limited=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERRIDE VEHICLE CONTROL VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All vehicles
%if exist('default_gb_shift_delay')
%   assignin('base','gb_shift_delay',0); % no delay between shifts
%end;
%if exist('default_cs_fc_init_state')
%   assignin('base','cs_fc_init_state',1); % engine initially ON
%end;

% Series vehicles
if exist('default_cs_max_pwr_rise_rate')
   assignin('base','cs_max_pwr_rise_rate',Inf);  % do not limit response time of the engine
end
if exist('default_cs_fc_init_state')
   assignin('base','cs_fc_init_state',1);  % engine initially on for max power capability
end
%if exist('default_cs_charge_pwr')
%   assignin('base','cs_charge_pwr',0); % do not request additional power to charge ess
%end;
if exist('default_mc_overtrq_factor')&(strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'series'))
   assignin('base','mc_overtrq_factor',1); % do not allow operation outside of the continuous range
end

% Parallel vehicles
%if exist('default_cs_electric_launch_spd')
%   assignin('base','cs_electric_launch_spd',0); % do not suppress the engine during launch from zero spd
%end;
%if exist('default_cs_min_trq_frac')
%   assignin('base','cs_min_trq_frac',0); % do not enforce a minimum engine torque output
%end;
%if exist('default_cs_off_trq_frac')
%   assignin('base','cs_off_trq_frac',0); % do not turn engine off for low torque events
%end;
%if exist('default_cs_charge_trq')
%   assignin('base','cs_charge_trq',0); % do not request additional trq to charge ess
%end;

% non-conventional vehicles
% tm:041802 updated conditional, custom vehicles may or may not have a battery  
%if ~strcmp(vinf.drivetrain.name,'conventional')&exist('default_ess_init_soc')
if isfield(vinf,'energy_storage')&exist('default_ess_init_soc')
    if exist('ess_init_soc')
        % assign user-defined energy storage system initial state
        assignin('base','ess_init_soc',ess_init_soc); 
    else
        if evalin('base','exist(''cs_lo_soc'')')
            % assign energy storage system initial state to 1/2 the usable range
            evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); 
        else
            evalin('base','ess_init_soc=1;');
        end
    end
    if ~exist('ess_min_soc') % if not provided initialize to lower set point
        if evalin('base','exist(''cs_lo_soc'')')
            ess_min_soc=evalin('base','cs_lo_soc');
        else
            ess_min_soc=0;
        end
    end
end

% misc
if exist('default_enable_stop_fc')
   assignin('base','enable_stop_fc',0); % don't end simulation if engine turns on
end

% apply user specified system disable parameters
if exist('disable_systems')
   if disable_systems==1
      assignin('base','ess_on',0); 
   elseif disable_systems==2
      assignin('base','fc_on',0); 
   end
end

%%% *** Note: do not change the order of the next two if statements ***
% apply user specified additional mass parameters
if exist('add_mass')
   assignin('base','veh_mass',evalin('base','veh_mass')+add_mass); 
end

% apply user specified override mass parameters
if exist('override_mass')
   assignin('base','veh_mass',override_mass); 
end
%%% ********

% disable cycle varying aux loads
% if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
% 	AuxLoadsFigControl('LoadAuxVars');
% end
% vinf.AuxLoadsOn=0; % no cycle varying aux loads
vinf.saber_cosim.run=0; % no saber cosimulation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cyc_grade_max_a=[]; % stores the max grade achieved
veh_mph_a=[]; % stores the speed at which the max grade was achieved
gb_ratio_a=[]; % stores the gear ratio in which the test was completed
achieved=0; % flag to signal sucessful test

if disp_status disp(' '); end

try
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % TEST VEHICLE
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if ~grade_test_spd_limited
      if ~exist('grade') % FIND MAX GRADE AT SPEED FOR DURATION
         % set default max number of interations
         if ~exist('max_iter')
            max_iter=defaults{find(strcmp(defaults,'max_iter'))+1};
         end
         % set default lower bound
         if ~exist('grade_lb')
            grade_lb=defaults{find(strcmp(defaults,'grade_lb'))+1};
         end
         % set default grade_init_step
         if ~exist('grade_init_step')
            grade_init_step=defaults{find(strcmp(defaults,'grade_init_step'))+1};
         end
         
         % test the lower bound
         assignin('base','cyc_grade',[0 grade_lb/100; 1 grade_lb/100])
         achieved=get_resp(speed,speed_tol,disp_status);
         
         if achieved % find upper bound
            iter=0;
            while achieved 
               if exist('grade_ub')&iter==0
                  assignin('base','cyc_grade',[0 grade_ub/100; 1 grade_ub/100])
               else
                  incr=0;
                  for i=0:iter
                     incr=incr+grade_init_step/100*(1.618^i);
                  end
                  grade_lb=evalin('base','cyc_grade(1,2)')*100;
                  assignin('base','cyc_grade',[0 grade_lb/100+incr; 1 grade_lb/100+incr])
               end
               achieved=get_resp(speed,speed_tol,disp_status);
               iter=iter+1;
            end
         end
         
         if ~achieved
            grade_ub=evalin('base','cyc_grade(1,2)')*100;
         end
         
         if (grade_ub-grade_lb)>grade_tol
            iter=0;
            loop=1;
            while loop
               if achieved
                  grade_lb=evalin('base','cyc_grade(1,2)')*100;
               else                  
                  grade_ub=evalin('base','cyc_grade(1,2)')*100;
               end
               %03/27/00:tm assignin('base','cyc_grade',[0 grade_lb+0.382*(grade_ub-grade_lb); 1 grade_lb+0.382*(grade_ub-grade_lb)])
               assignin('base','cyc_grade',[0 0.5*(grade_ub+grade_lb)/100; 1 0.5*(grade_ub+grade_lb)/100])
               achieved=get_resp(speed,speed_tol,disp_status);
               iter=iter+1;
               
               if iter>=max_iter|(grade_ub-grade_lb)<=grade_tol 
                  if disp_status
                     if iter>=max_iter
                        disp('    *** Maximum number of iterations exceeded. ***')
                     end
                     if (grade_ub-grade_lb)<=grade_tol 
                        disp('    *** Upper and lower bounds have converged. ***')
                     end
                  end
                  
                  loop=0; % set flag to exit loop
                  
                  if ~achieved
                     % test at last successful point
                     assignin('base','cyc_grade',[0 grade_lb/100; 1 grade_lb/100]);
                     achieved=get_resp(speed,speed_tol,disp_status);
                  end
               else
                  loop=1; % set flag to continue search
               end % if convergence or max iterations...
            end % while...
         end % if convergence tolerance   
         
      else % CAN VEHICLE ACHIEVE x GRADE AT y SPEED??
         % test at the goal grade
         assignin('base','cyc_grade',[0 grade/100; 1 grade/100]);
         achieved=get_resp(speed,speed_tol,disp_status);
      end
   end
catch
    disp('Error: Unable to execute grade test.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETURN RESULTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if grade was achieved or the upper bound was reached 
% return the last grade tested else return an empty set
if achieved
   cyc_grade_max_a=evalin('base','cyc_grade(1,2)')*100; 
   gear_ratio_a=evalin('base','gear_ratio(end)'); 
else
   cyc_grade_max_a=[]; 
   gear_ratio_a=[]; 
end

% return results to the GUI
vinf.max_grade=cyc_grade_max_a;

% return results to the screen
if ~grade_test_spd_limited&disp_status
   disp(' ')
   disp('    <<< GRADE TEST RESULTS >>> ')
   if achieved
      if ~strcmp(varargin,'speed')
         disp(['    At ', num2str(speed), ' mph for ', num2str(duration),' seconds, maximum grade = ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
      elseif strcmp(varargin,'speed')&~strcmp(varargin,'grade')
         if ~exist('loop')
            disp(['    At ', num2str(speed), ' mph for ', num2str(duration),' seconds, maximum grade >= ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
         else
            disp(['    At ', num2str(speed), ' mph for ', num2str(duration),' seconds, maximum grade = ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
         end
      else
         disp(['    Maintained ', num2str(speed), ' mph on a ', num2str(evalin('base','cyc_grade(1,2)')*100), ' % grade for ', num2str(duration),' seconds.'])
      end
   else
      disp(['    Unable to maintain ', num2str(speed), ' mph on a ', num2str(evalin('base','cyc_grade(1,2)')*100), ' % grade for ', num2str(duration),' seconds.'])
   end
   disp(' ')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESTORE ORIGINAL WORKSPACE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
restore(variables) % see subroutines below

%%%%%%%%%%%%%%%%%%%
% END OF MAIN BODY
%%%%%%%%%%%%%%%%%%%
return


%%%%%%%%%%%%%%%%%%%
% SUBROUTINES
%%%%%%%%%%%%%%%%%%%
function build_cycle(speed,duration)
%
% Build the driving schedule for the grade test
%

global vinf

% Build the driving schedule
time=[0:duration]; % cycle is duration seconds long
mph_r=[ones(1,length(time))*speed]; 
cyc_mph=[time' mph_r'];
assignin('base','cyc_mph', cyc_mph);
assignin('base','vc_key_on', [cyc_mph(:,1) ones(size(cyc_mph(:,1)))]);
assignin('base','cyc_filter_bool', 0); % do not filter the requested cycle
assignin('base','cyc_avg_time', 1); % no averaging of the requested cycle
assignin('base','cyc_cargo_mass', [0 0; 1 0]); % no cycle varying cargo mass
vinf.cycle.number=1; % run only one cycle
return

function achieved=get_resp(speed,speed_tol,disp_status)
% 
% test the vehicle at the specified grade
% 

% info to user
if disp_status
   fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, speed)
end

% run simulation
gui_run_simulation % run simulation using a default time step (1 sec)

% check results  
mpha=evalin('base','mpha'); % store the speed achieved
% calculate the difference between adjacent speeds to ensure
% that it is within a specified tolerance and ensure that the 
% actual speed is also within in a specified tolerance
% consider only last three speeds
if (abs(diff(mpha(end-2:end))<speed_tol)&(abs(mpha(end-1:end)-speed)<speed_tol))&(evalin('caller','~exist(''ess_min_soc'')')|(evalin('caller','exist(''ess_min_soc'')')&(min(evalin('base','ess_soc_hist'))>=evalin('caller','ess_min_soc'))))
   achieved=1; % set flag that grade was achieved
   if disp_status
      fprintf(1,' ... achieved\n')
   end
else
   achieved=0; % set flag that grade was not achieved
   if disp_status
      fprintf(1,' ... not achieved\n')
   end
end

return


function store(variables)
%
% This function stores all of the current workspace variables 
% that will be changed by the grade test function
%

global vinf

for i=1:length(variables)
   if evalin('base',['exist(''',variables{i},''')'])
      assignin('caller',['default_',variables{i}],evalin('base',variables{i}));
   end
end

% special case
eval('h=vinf.cycle; test4exist=1;','test4exist=0;')
if test4exist 
   assignin('caller','default_vinf_cycle',vinf.cycle);
end

% special cases
eval('h=vinf.AuxLoads; test4exist=1;','test4exist=0;')
if test4exist
   assignin('caller','default_vinf_AuxLoads',vinf.AuxLoads);
end

% special cases
if isfield(vinf,'saber_cosim')
   assignin('caller','default_vinf_saber_cosim',vinf.saber_cosim);
end

return


function restore(variables)
%
% This function restores all of the current workspace variables 
% to their original values that were be changed by the grade test function
%

global vinf

for i=1:length(variables)
   if evalin('caller',['exist(''default_',variables{i},''')'])
      assignin('base',variables{i},evalin('caller',['default_',variables{i}]));
   else
      evalin('base',['clear ',variables{i}])
   end
end

% special case
if evalin('caller','exist(''default_vinf_cycle'')')
   vinf.cycle=evalin('caller','default_vinf_cycle');
else
   vinf=rmfield(vinf,'cycle');
end

% special cases
if evalin('caller','exist(''default_vinf_saber_cosim'')')
   vinf.saber_cosim=evalin('caller','default_vinf_saber_cosim');
else
   vinf=rmfield(vinf,'saber_cosim');
end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 03/27/00:tm file created from grade_test
% 6/30/00:tm disabled shift of elec acc load to mech acc load - caused other problems, now handled in block diagram
% 7/14/00:tm added new input variable called ess_min_soc and added conditional 
%            to get_resp function to ensure that soc is always greater than ess_min_soc
% 7/14/00:tm rearranged the gear selection section to make it more logical and simpler
% 7/20/00:tm revised variable names to correlate with gui structure
% 8/14/00:tm added conditional to only perform initial gear selection for non-prius vehicles
% 8/14/00:tm updated handling of grade, grade_lb, grade_ub, grade_step_size, grade_tol so that they all work in % grade
% 8/14/00:tm fixed gear ratio assignment statements so that if gear_num provided it is actually used
% 11/16/00:tm encased the actually simulation runs inside of a try statement to prevent block diagram errors from crashing optimization runs
% 1/24/01:tm added fc_on, ess_on, veh_mass to list of params to be stored and restored
% 1/24/01:tm updated list of inputs to include override_mass, add_mass, disable_systems
% 1/24/01:tm added statements to assign parameters for override_mass, add_mass, and disable_systems parameters
% 1/29/01:tm removed conditional to store vinf.cycle.number only when it is greater than one - it needs to be stored so that the restore function works correctly
% 1/29/01:tm added statements to remove the vinf.cycle field if it did not exist before
%8/1/01:tm added cyc_cargo_mass definition
% 8/1/01:tm added statements to handle override of vinf.AuxLoads.On flag
% 8/17/01:tm updated to include statements to override saber_cosim run flag
% 8/17/01:tm added catch statement to display error message when something fails inside of the try statement
% 4/18/02:tm added cs_fc_init_state to the list of variables to be overwritten and added line to set initial state to 1
% 4/18/02:tm changed conditional to set ess_init_soc and added conditionals to handle case when cs_lo_soc does not exist
% 4/26/02:tm commented out AuxLoad default definitions - this allows user to specify variable auxloads





