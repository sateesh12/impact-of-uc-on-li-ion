function [accel_resp]=accel_test(varargin)
%
% This function runs a maximum acceleration test to find the time
% required to reach the user specified speeds by applying 
% a step function of 200 mph as the required speed.
% The function can also provide the maximum accel rate, the maximum 
% distance traveled over a period of time, and the maximum time 
% for a specified distance.
%
% Inputs:
% spds				(mph), matrix of initial speeds in first column and final speeds in second column
% dist_in_time		(s), time over which to measure max distance traveled (e.g. distance traveled in 5s)
% time_in_dist		(mi), distance over which to measure time (e.g. 1/4 mi time)
% ess_init_soc		(--), initial state of charge of the ess
% gb_shift_delay	(s), delay time during a shift in which no torque can be transmitted
% disp_results		(--), boolean flag 1==> display results, 0 ==> don't display
% max_rate_bool	(--), boolean flag 1==> calc max accel rate, 0 ==> don't calc
% max_speed_bool	(--), boolean flag 1==> calc max speed, 0 ==> don't calc
% override_mass	(kg), override vehicle mass to be used for the accel test only
% add_mass			(kg), additional mass to be added to current vehicle mass for accel test only
% disable_systems	(--), flag to disable power systems 1==> disable ess, 2 ==> disable fc
% 
% Responses:
% accel_resp.times			(s), vector of accel times associated with input speed ranges
% accel_resp.dist				(mi), distance traveled in specified time
% accel_resp.time				(s), time to travel specified distance
% accel_resp.max_rate		(ft/s^2), maximum rate of acceleration
% accel_resp.max_speed		(m/s), vehicle top speed
%

% make vinf accessible
global vinf

% get drivetrain type
drivetrain=vinf.drivetrain.name;

% set of default input parameters
defaults={'spds',[0 60; 40 60; 0 85],...
      'dist_in_time',5,...
      'time_in_dist',0.25,...
      'max_rate_bool',0,...
      'max_speed_bool',0,...
      'ess_init_soc',[],...
      'gb_shift_delay',0.2,...
      'override_mass',[],...
      'add_mass',0,...
      'disable_systems',0,...
      'disp_results',0};

% default simulation time step size
time_step=0.1; % s

% initialize user-defined input parameter and values
if exist('varargin') % any parameters given?
   if (mod(length(varargin),2)==0) % parameters in pairs?
      for i=1:2:length(varargin)-1
         eval([varargin{i},'=',mat2str(varargin{i+1}),';']);
      end
   else
      disp('Error: unmatched input arguments.')
      accel_resp=[];
      return
   end
end

% list of variables to be stored and restored because 
% their value will be overriden
variables={'enable_sim_stop_time',...
      'sim_stop_time',...
      'enable_sim_stop_distance',...
      'sim_stop_distance',...
      'enable_sim_stop_speed',...
      'sim_stop_speed',...
      'enable_stop_fc',...
      'enable_sim_stop_max_spd',...
      'cyc_mph',...
      'cyc_cargo_mass',...
      'vc_key_on',...
      'fc_on',...
      'ess_on',...
      'veh_mass',...
      'cyc_grade',...
      'cyc_filter_bool',...
      'cyc_avg_time',...
      'ess_init_soc',...
      'gb_shift_delay',...
      'fc_cat_init_temp',...
      'fc_coolant_init_temp'};

% Handled as special cases
% 'vinf.cycle.number',...
% 'vinf.cycle.soc',...
% 'vinf.AuxLoads.On'

% extra varialbes - currently not used tm:7/18/00
variables_extra={'mc_overtrq_factor',...
      'acc_elec_pwr',...
      'acc_mech_pwr',...
      'cs_fc_init_state',...
      'cs_max_pwr_rise_rate',...
      'cs_electric_launch_spd',...
      'cs_off_trq_frac',...
      'cs_min_trq_frac',...
      'cs_charge_trq',...
      'cs_charge_pwr'};

% Store original workspace variables
store(variables) % see subfunctions at end of file

% set display results variable, 1==> display results, 0==> don't display results
if ~exist('disp_results')
   disp_results=defaults{find(strcmp(defaults,'disp_results'))+1};
end

% set default spds 
%if ~exist('spds')
%   spds=defaults{find(strcmp(defaults,'spds'))+1};
%end

% set default time
%if ~exist('dist_in_time')
%   dist_in_time=defaults{find(strcmp(defaults,'dist_in_time'))+1};
%end

% if a time is specified set parameters
if exist('dist_in_time')
   assignin('base','enable_sim_stop_time',1)
   assignin('base','sim_stop_time',dist_in_time+5)
end

% if a distance is specified set parameters
if exist('time_in_dist')
   miles2m=1609;
   assignin('base','enable_sim_stop_distance',1)
   assignin('base','sim_stop_distance',time_in_dist*miles2m)
end

% if a speed is specified set parameters
if exist('spds')
   assignin('base','enable_sim_stop_speed',1)
   assignin('base','sim_stop_speed',max(max(spds)))
end

if exist('default_enable_stop_fc')
   assignin('base','enable_stop_fc',0); % don't end simulation if engine turns on
end;

if exist('default_enable_sim_stop_max_spd')
   if exist('max_speed_bool')
      assignin('base','enable_sim_stop_max_spd',max_speed_bool); % run simulation until max speed achieved if enabled
   else
      assignin('base','enable_sim_stop_max_spd',0); 
   end
end;

% Build the drive cyle
if exist('dist_in_time')
   cycle_length=max(100,dist_in_time); % default length
else
   cycle_length=100; % default length
end
if exist('spds')
   cycle_speed=max(200,max(max(spds))); % default speed
else
   cycle_speed=200; % default speed
end
time=[0 5-eps 5 6:(5+cycle_length)]; % include 5s pause for system stabilization
mph=[0 0 cycle_speed*ones(1,(1+cycle_length))]; % speed request step function
cyc_mph=[time' mph'];

% assign cycle variables to workspace
assignin('base','cyc_mph',cyc_mph);
assignin('base','vc_key_on',[cyc_mph(:,1) ones(size(cyc_mph(:,1)))]); % key always on
assignin('base','cyc_filter_bool', 0); % do not filter the requested cycle
assignin('base','cyc_avg_time', 1); % no averaging of the requested cycle
assignin('base','cyc_grade',[0 0; 1 0]); % zero grade
assignin('base','cyc_cargo_mass',[0 0; 1 0]); % no cycle varying cargo mass
% % disable cycle varying aux loads
% if ~isfield(vinf,'AuxLoads') | length(fieldnames(vinf.AuxLoads)) < length(GetLoadNames('All'))
% 	AuxLoadsFigControl('LoadAuxVars');
% end
% vinf.AuxLoads.On=0; % no cycle varying aux loads
vinf.cycle.number=1; % run only one cycle
vinf.cycle.soc='off'; % do not run SOC correct for accel test

% Override of control parameters disabled tm:7/18/00
% Override control parameters
%if strcmp(drivetrain,'series') | strcmp(drivetrain,'parallel') | strcmp(drivetrain,'conventional')
%	assignin('base','gb_shift_delay',0.2); %shift delay of 0.2 sec
%evalin('base','vc_launch_spd=max(fc_map_spd)/2.5;'); %force the launch speed
%		%launch speed is low so that initial conditions are no slip
%end      
%if strcmp(drivetrain,'parallel') % disable parallel control strategy parameters
%   assignin('base','cs_electric_launch_spd',0);
%   assignin('base','cs_min_trq_frac',0);
%   assignin('base','cs_off_trq_frac',0);
%   assignin('base','cs_charge_trq',0);
%end

% set user-defined shift delay
if exist('gb_shift_delay')
   assignin('base','gb_shift_delay',gb_shift_delay);
else
   assignin('base','gb_shift_delay',defaults{find(strcmp(defaults,'gb_shift_delay'))+1});
end

% Set initial conditions
if 0 % Note: if using init_conds_hot some values can not be returned to initial settings tm:8/15/00
   init_conds_hot % load default hot initial conditions
else
   if exist('default_fc_cat_init_temp')
      assignin('base','fc_cat_init_temp',500); % catalyst warm
   end;
   if exist('default_fc_coolant_init_temp')
      assignin('base','fc_coolant_init_temp',95); % fuel convertor warm
   end
end

if isfield(vinf,'energy_storage')
    if exist('ess_init_soc')
        % set user-defined init soc if provided
        assignin('base','ess_init_soc',ess_init_soc) 
    elseif evalin('base','exist(''cs_lo_soc'')') % if not provided initalize soc to avg of hi and lo state
        assignin('base','ess_init_soc',evalin('base','mean([cs_lo_soc cs_hi_soc])'));    
    else
        assignin('base','ess_init_soc',1)
    end
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

% Run simulation with step function, time step = 0.1 sec
gui_run_simulation(time_step);

% Process results
% accel times
if exist('spds')
      mpha=evalin('base','mpha');
   t=evalin('base','t');
for i=1:size(spds,1)
      index2=min(find(mpha>spds(i,2)));
      index1=min(find(mpha>spds(i,1)));
      if ~isempty(index2)
         spd2_index(i)=index2;
      else
         spd2_index(i)=length(mpha);
      end
      if ~isempty(index1)
         spd1_index(i)=index1;
      else
         spd1_index(i)=length(mpha);
      end
      %only do the following if data abscissae is distinct and monotonically increasing
      %caused problems with very heavy vehicle and small components before
      if mpha( spd2_index(i)-1 ) < mpha( spd2_index(i) ) & mpha( spd1_index(i)-1 ) < mpha( spd1_index(i) )
          accel_times(i)=interp1([mpha(spd2_index(i)-1) mpha(spd2_index(i))],...
              [t(spd2_index(i)-1) t(spd2_index(i))],spds(i,2))...
              -interp1([mpha(spd1_index(i)-1) mpha(spd1_index(i))],...
              [t(spd1_index(i)-1) t(spd1_index(i))],spds(i,1));
      else
          accel_times(i)=-1;
      end
      
      if isnan(accel_times(i))
         accel_times(i)=-1;
      end
   end
   accel_resp.times=accel_times;
end

% distance in time
if exist('dist_in_time')
         mpha=evalin('base','mpha');
dist=evalin('base','distance');
   t=evalin('base','t');
   t_index=min(find(dist>0));
   if isempty(t_index)
      t_index=length(mpha);
   end
   m2ft=1/0.3048;
   accel_resp.dist=interp1(t(t_index-1:end)-t(t_index-1),dist(t_index-1:end),dist_in_time)*m2ft;   
end

% time in distance
if exist('time_in_dist')
         mpha=evalin('base','mpha');
dist=evalin('base','distance');
   t=evalin('base','t');
   t_index=min(find(dist>0))-1;
   miles2m=1609;
   dist_index=min(find(dist>time_in_dist*miles2m));
   if isempty(dist_index)
      dist_index=length(mpha);
   end
   accel_resp.time=interp1([dist(dist_index-1) dist(dist_index)],[t(dist_index-1) t(dist_index)],time_in_dist*miles2m)-t(t_index);
end

% accel rate
if exist('max_rate_bool')&max_rate_bool
   mpha=evalin('base','mpha');
   miles2ft=5280;
   hrs2sec=3600;
   accel_resp.max_rate=max(diff(mpha))/0.1*miles2ft/hrs2sec; % ft/s^2
end

% max speed
if exist('max_speed_bool')&max_speed_bool
   mpha=evalin('base','mpha');
   accel_resp.max_speed=max(mpha); % mph
end

if 0 % results now stored in structure tm:8/14/00
   % assign variables in workspace--used with parametric plot variables
   assignin('base','accel_time_0_18',accel_time_0_18);
   assignin('base','accel_time_0_30',accel_time_0_30);
   assignin('base','accel_time_0_60',accel_time_0_60);
   assignin('base','accel_time_0_85',accel_time_0_85);
   assignin('base','accel_time_40_60',accel_time_40_60);
   assignin('base','max_accel_ft_s2',max_accel_ft_s2);
   assignin('base','feet_5sec',feet_5sec);
   
   % need this for results gui
   vinf.acceleration.time_0_18=accel_time_0_18;
   vinf.acceleration.time_0_30=accel_time_0_30;
   vinf.acceleration.time_0_60=accel_time_0_60;
   vinf.acceleration.time_0_85=accel_time_0_85;
   vinf.acceleration.time_40_60=accel_time_40_60;
   vinf.acceleration.max_accel=max_accel_ft_s2;
   vinf.acceleration.feet_5sec=feet_5sec;
end

%display results in command window
if disp_results
   disp(' ')
   disp('<<< ACCELLERATION TEST RESULTS >>>')
   if exist('spds')
      for i=1:size(spds,1)
         if strcmp(vinf.units,'metric')
            disp(['                 ',num2str(spds(i,1)*units('mph2kmph'),3),'-',num2str(spds(i,2)*units('mph2kmph'),3),' kmph:  ', num2str(accel_resp.times(i),3),' sec']);
         else
            disp(['                 ',num2str(spds(i,1)*units('mph2kmph'),3),'-',num2str(spds(i,2)*units('mph2kmph'),3),' mph:  ', num2str(accel_resp.times(i),3),' sec']);
         end
      end
   end
   if exist('dist_in_time')
      if strcmp(vinf.units,'metric')
         disp(['          Distance in ',num2str(dist_in_time,3),' s:  ', num2str(accel_resp.dist*units('ft2m'),3),' m']);
      else
         disp(['          Distance in ',num2str(dist_in_time,3),' s:  ', num2str(accel_resp.dist*units('ft2m'),3),' ft']);
      end
   end
   if exist('time_in_dist')
      if strcmp(vinf.units,'metric')
         disp(['                 Time in ',num2str(time_in_dist*units('miles2km'),3),' km:  ', num2str(accel_resp.time,3),' s']);
      else
         disp(['                 Time in ',num2str(time_in_dist*units('miles2km'),3),' mi:  ', num2str(accel_resp.time,3),' s']);
      end
   end
   if exist('max_rate_bool')&max_rate_bool
      if strcmp(vinf.units,'metric')
         disp(['     Maximum Acceleration: ',num2str(accel_resp.max_rate*units('ft2m'),3),' m/s^2']);
      else
         disp(['     Maximum Acceleration: ',num2str(accel_resp.max_rate*units('ft2m'),3),' ft/s^2']);
      end
   end
   if exist('max_speed_bool')&max_speed_bool
      if strcmp(vinf.units,'metric')
         disp(['     Maximum Speed: ',num2str(accel_resp.max_speed*units('mph2kmph'),3),' kmph']);
      else
         disp(['     Maximum Speed: ',num2str(accel_resp.max_speed*units('mph2kmph'),3),' mph']);
      end
   end
   
   disp(' ');
end


% restore original workspace variables
restore(variables) % see subfunction section

% end main function

% SubFunction Section
function store(variables)
%
% This function stores all of the current workspace variables 
% that will be changed by the accel test function
%

global vinf

for i=1:length(variables)
   if evalin('base',['exist(''',variables{i},''')'])
      assignin('caller',['default_',variables{i}],evalin('base',variables{i}));
   end
end

% special cases
eval('h=vinf.cycle; test4exist=1;','test4exist=0;')
if test4exist
   assignin('caller','default_vinf_cycle',vinf.cycle);
end

% special cases
eval('h=vinf.AuxLoads; test4exist=1;','test4exist=0;')
if test4exist
   assignin('caller','default_vinf_AuxLoads',vinf.AuxLoads);
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

% special cases
if evalin('caller','exist(''default_vinf_cycle'')')
   vinf.cycle=evalin('caller','default_vinf_cycle');
else
   vinf=rmfield(vinf,'cycle');
end

% special cases
if evalin('caller','exist(''default_vinf_AuxLoads'')')
   vinf.AuxLoads=evalin('caller','default_vinf_AuxLoads');
else
   vinf=rmfield(vinf,'AuxLoads');
end

return

% REVISION HISTORY
% 7/18/00:tm created from accel_test
% 8/8/00 : ss removed references to prius
% 8/15/00:tm added gb_shift_delay as a input parameter
% 8/15/00:tm updated indexes assignments for interpolation to guarantee that they are defined
% 8/15/00:tm updated list of variables that should be stored and restored
% 8/15/00:tm added units to header info
% 8/15/00:tm fixed errors related to dist_in_time and time_in_dist flip flop
% 8/15/00:tm made the time_step a variable that is defined at the top of the file to make it more accessible - maybe input param in the future
% 8/17/00:tm updated all units info so that inputs always in mixed units while gui handles metric units conversion
% 9/13/00:tm fixed time in dist calc - forgot to subtract initial 5 sec pause
% 11/16/00:tm introduced max speed as a new measure - updated stop simulation block for this functionality
% 11/16/00:tm updated max rate calc implementation
% 1/25/00:tm added override mass and disable systems options
% 1/25/00:tm disabled setting of defaults for speeds and dist in time to work with new autosize
% 1/29/01:tm added evalin base statements for mpha in for specs other than accel times
% 8/1/01:tm added definition of cyc_cargo_mass
% 8/1/01:tm added else statement to shift delay definition - if user does not specify shift delay then use default value to be consistent with GUI defaults
% 8/1/01:tm added statements to handle override of vinf.AuxLoads.On flag
% 8/19/01:tm fixed syntax error associated with assigning default gb_shift_delay
% 10/19/01:mpo added extra line to if statement for SOC to facilitate custom drivetrains
% 4/18/02:tm changed conditional on ess_init_soc initialization to be based on fields rather than drivetrain name
% also added conditional around value for case when cs_lo_soc doesn't exist
% 4/18/02:tm commented out AuxLoad default definitions - now defined in input file
%

