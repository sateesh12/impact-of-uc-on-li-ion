function [accel_time_0_60,accel_time_0_85,accel_time_40_60,max_accel_ft_s2,feet_5sec]=accel_test()

% This runs a maximum acceleration test to find the time
% required to reach 0-60 mph, 0-85 mph, and 40-60 mph by applying 
% a step function of 200 mph as the required speed.
% The function also finds the maximum acceleration, in ft/s^2
% and the distance traveled (feet) in 5 seconds.

global vinf
drivetrain=vinf.drivetrain.name;

% set display results variable, 1==> display results, 0==> don't display results
display=0;

% Speed required of vehicle is a step function to 200 mph for vinf.targets.accel_0_85+2 sec or a default of 45s
if vinf.autosize_run_status
   time_max=ceil(max([vinf.autosize.con.accel.goal.t0_18 vinf.autosize.con.accel.goal.t0_30...
         vinf.autosize.con.accel.goal.t0_60 vinf.autosize.con.accel.goal.t40_60 ...
         vinf.autosize.con.accel.goal.t0_85]))+10;
else
   time_max=45;
end;

% Build the drive cyle
eval('h=vinf.cycle.name; test4exist=1;','test4exist=0;')
if test4exist&strcmp(vinf.cycle.name,'CYC_ACCEL')&evalin('base','exist(''cyc_mph'')')
   % if cyc_accel selected from cycles menu use pre-defined trace 
   % (this allows user to modify of top speed and length in cyc_* file)
   cyc_mph=evalin('base','cyc_mph');
else 
   time=[0 5-eps 5 6:(5+time_max)];
   mph=[0 0 200*ones(1,(1+time_max))];
   cyc_mph=[time' mph'];
end

% Store original workspace variables
store % see subfunctions at end of file

% Override workspace variables
assignin('base','vc_key_on',[cyc_mph(:,1) ones(size(cyc_mph(:,1)))]);
assignin('base','cyc_mph',cyc_mph);
if strcmp(drivetrain,'series') | strcmp(drivetrain,'parallel') | strcmp(drivetrain,'conventional')
	assignin('base','gb_shift_delay',0.2); %shift delay of 0.2 sec
	evalin('base','vc_launch_spd=max(fc_map_spd)/2.5;'); %force the launch speed
		%launch speed is low so that initial conditions are no slip
end      
if strcmp(drivetrain,'parallel') % disable parallel control strategy parameters
   assignin('base','cs_electric_launch_spd',0);
   assignin('base','cs_min_trq_frac',0);
   assignin('base','cs_off_trq_frac',0);
   assignin('base','cs_charge_trq',0);
end
assignin('base','cyc_filter_bool', 0); % do not filter the requested cycle
assignin('base','cyc_avg_time', 1); % no averaging of the requested cycle
%assignin('base','cyc_grade',0); % zero % grade
assignin('base','cyc_grade',[0 0; 1 0]); % zero % grade
vinf.cycle.number=1; % run only one cycle
vinf.cycle.soc='off'; %do not run SOC correct for accel test
% set the initial state of charge equal to the control strategy 
% state of charge high value
if ~strcmp(drivetrain,'conventional')&~strcmp(drivetrain,'prius_jpn') 
%if exist('default_ess_init_soc')
   assignin('base','ess_init_soc',evalin('base','cs_hi_soc')); % initalize soc to hi state
end;
if exist('default_fc_cat_init_temp')
   assignin('base','fc_cat_init_temp',500); % catalyst warm
end;
if exist('default_fc_coolant_init_temp')
   assignin('base','fc_coolant_init_temp',95); % fuel convertor warm
end;
if exist('default_enable_stop_fc')
   assignin('base','enable_stop_fc',0); % don't end simulation if engine turns on
end;


% Run simulation with step function, time step = 0.1 sec
gui_run_simulation(.1);

%%%%%%%%
% Acceleration Times
%%%%%%%%
%find index to achieve 40, 60 and 85 mph
mpha=evalin('base','mpha');
t=evalin('base','t');

index18=min(find(mpha>18)); 
index30=min(find(mpha>30)); 
index40=min(find(mpha>40)); 
index60=min(find(mpha>60)); 
index85=min(find(mpha>85)); 

%find times for each of the speeds 
if ~isempty(index18)
   time18=interp1([mpha(index18-1) mpha(index18)],[t(index18-1) t(index18)],18);
end
if ~isempty(index30)
   time30=interp1([mpha(index30-1) mpha(index30)],[t(index30-1) t(index30)],30);
end
if ~isempty(index40)
   time40=interp1([mpha(index40-1) mpha(index40)],[t(index40-1) t(index40)],40);
end
if ~isempty(index60)
   time60=interp1([mpha(index60-1) mpha(index60)],[t(index60-1) t(index60)],60);
end
if ~isempty(index85)
   time85=interp1([mpha(index85-1) mpha(index85)],[t(index85-1) t(index85)],85);
end

%time to accelerate 0-18 mph
if isempty(index18)
   accel_time_0_18=-1; 
else
   accel_time_0_18=time18-5; %5 second delay of acceleration cycle
end;
%time to accelerate 0-30 mph
if isempty(index30)
   accel_time_0_30=-1; 
else
   accel_time_0_30=time30-5; %5 second delay of acceleration cycle
end;
%time to accelerate 0-60 mph
if isempty(index60)
   accel_time_0_60=-1; 
else
   accel_time_0_60=time60-5; %5 second delay of acceleration cycle
end;
%time to accelerate to 40-60 mph
if isempty(index40)|isempty(index60)
   accel_time_40_60=-1; 
else
   accel_time_40_60=time60-time40;
end;
%time to accelerate to 0-85 mph
if isempty(index85)
   accel_time_0_85=(-1); 
else
   accel_time_0_85=time85-5; %5 second delay of acceleration cycle 
end

%%%%%%%%%%
% Maximum Acceleration
%%%%%%%%%%
difference=diff(mpha); %vector containing differences in speed for .1 sec
max_accel=max(difference)/0.1; %units: miles per hour per second, 0.1 for 0.1 second time step
max_accel_ft_s2=max_accel*5280/3600; %conversion into ft/s^2

%%%%%%%%%%
% Distance Traveled in 5 seconds
%%%%%%%%%%
index_t5=max(find(t<=5)); %find the max index of times that are <= 5 seconds
index_t10=max(find(t<=10)); %index at t=10
for i=index_t5:1:index_t10
   t5(i)=t(i);			%record the times into a new vector
   mpha_5sec(i)=mpha(i); %record the mpha into a new vector
end
feet_5sec=trapz(t5,mpha_5sec)*5280/3600; %results in feet


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

%display results in command window
if display
   disp(' ')
   disp('<<< ACCELLERATION TEST RESULTS >>>')
   disp(['                 0-18 mph:  ', num2str(accel_time_0_18),' sec']);
   disp(['                 0-30 mph:  ', num2str(accel_time_0_30),' sec']);
   disp(['                 0-60 mph:  ', num2str(accel_time_0_60),' sec']);
   disp(['                40-60 mph:  ', num2str(accel_time_40_60),' sec']);
   disp(['                 0-85 mph:  ', num2str(accel_time_0_85),' sec']);
   disp(['     Maximum Acceleration: ',num2str(max_accel_ft_s2),' ft/s^2']);
   disp(['    Distance in 5 seconds: ',num2str(feet_5sec),' feet']);
   disp(' ');
end;


% restore original workspace variables
restore % see subfunction section

% end main function


% SubFunction Section
function store()
global vinf
% stores original workspace variables

% Control strategy variables
if evalin('base','exist(''cs_electric_launch_spd'')');
   assignin('caller','default_cs_electric_launch_spd',evalin('base','cs_electric_launch_spd'));
end; % ss added on 10/5/98 for max acceleration performance on parallels
if evalin('base','exist(''cs_min_trq_frac'')');
   assignin('caller','default_cs_min_trq_frac',evalin('base','cs_min_trq_frac'));
end; % tm added on 10/12/98 for max acceleration performance on parallels
if evalin('base','exist(''cs_off_trq_frac'')');
   assignin('caller','default_cs_off_trq_frac',evalin('base','cs_off_trq_frac'));
end; % tm added on 10/12/98 for max acceleration performance on parallels
if evalin('base','exist(''cs_charge_trq'')');
   assignin('caller','default_cs_charge_trq',evalin('base','cs_charge_trq'));
end; % tm added on 10/12/98 for max acceleration performance on parallels
if evalin('base','exist(''vc_key_on'')')
   assignin('caller','default_vc_key_on',evalin('base','vc_key_on')); 
end;
if evalin('base','exist(''gb_shift_delay'')')
   assignin('caller','default_gb_shift_delay',evalin('base','gb_shift_delay'));
end;
if evalin('base','exist(''vc_launch_spd'')')
   assignin('caller','default_vc_launch_spd',evalin('base','vc_launch_spd'));
end;

% Drive cycle variables
if evalin('base','exist(''cyc_mph'')')
   assignin('caller','default_cyc_mph',evalin('base','cyc_mph')); 
end;
if evalin('base','exist(''cyc_grade'')')
   assignin('caller','default_cyc_grade',evalin('base','cyc_grade'));
end;
if evalin('base','exist(''cyc_filter_bool'')')
   assignin('caller','default_cyc_filter_bool',evalin('base','cyc_filter_bool'));
end;
if evalin('base','exist(''cyc_avg_time'')')
   assignin('caller','default_cyc_avg_time',evalin('base','cyc_avg_time'));
end;
eval('h=vinf.cycle.number; test4exist=1;','test4exist=0;')
if test4exist & vinf.cycle.number>1
   assignin('caller','default_vinf_cycle_number',vinf.cycle.number);
end;
eval('h=vinf.cycle.soc; test4exist=1;','test4exist=0;')
if test4exist & strcmp(vinf.cycle.soc,'on')
   assignin('caller','default_vinf_cycle_soc',vinf.cycle.soc);
end;

% Initial conditions
if evalin('base','exist(''ess_init_soc'')')
   assignin('caller','default_ess_init_soc',evalin('base','ess_init_soc'));
end;
if evalin('base','exist(''enable_stop_fc'')')
   assignin('caller','default_enable_stop_fc',evalin('base','enable_stop_fc'));
end;
if evalin('base','exist(''ex_cat_mon_init_tmp'')')
   assignin('caller','default_ex_cat_mon_init_tmp',evalin('base','ex_cat_mon_init_tmp'));
   assignin('caller','default_ex_cat_int_init_tmp',evalin('base','ex_cat_int_init_tmp'));
   assignin('caller','default_ex_cat_pipe_init_tmp',evalin('base','ex_cat_pipe_init_tmp'));
   assignin('caller','default_ex_cat_ext_init_tmp',evalin('base','ex_cat_ext_init_tmp'));
   assignin('caller','default_ex_manif_init_tmp',evalin('base','ex_manif_init_tmp'));
end;
if evalin('base','exist(''fc_c_init_tmp'')')
   assignin('caller','default_fc_c_init_tmp',evalin('base','fc_c_init_tmp'));
   assignin('caller','default_fc_i_init_tmp',evalin('base','fc_i_init_tmp'));
   assignin('caller','default_fc_x_init_tmp',evalin('base','fc_x_init_tmp'));
   assignin('caller','default_fc_h_init_tmp',evalin('base','fc_h_init_tmp'));   
end;
if evalin('base','exist(''ess_mod_init_tmp'')')
   assignin('caller','default_ess_mod_init_tmp',evalin('base','ess_mod_init_tmp'));
end;
if evalin('base','exist(''mc_init_tmp'')')
   assignin('caller','default_mc_init_tmp',evalin('base','mc_init_tmp'));
end;

return
% end store subfunction

function restore()
global vinf

% restore original workspace variables

% Control strategy
if evalin('caller','exist(''default_cs_electric_launch_spd'')');
   assignin('base','cs_electric_launch_spd',evalin('caller','default_cs_electric_launch_spd'));
else
   evalin('base','clear cs_electric_launch_spd');
end % ss added on 10/5/98 for max acceleration performance on parallels
if evalin('caller','exist(''default_cs_min_trq_frac'')');
   assignin('base','cs_min_trq_frac',evalin('caller','default_cs_min_trq_frac'));
else
   evalin('base','clear cs_min_trq_frac');
end % tm added on 10/12/98 for max acceleration performance on parallels
if evalin('caller','exist(''default_cs_off_trq_frac'')');
   assignin('base','cs_off_trq_frac',evalin('caller','default_cs_off_trq_frac'));
else
   evalin('base','clear cs_off_trq_frac');
end % tm added on 10/12/98 for max acceleration performance on parallels
if evalin('caller','exist(''default_cs_charge_trq'')');
   assignin('base','cs_charge_trq',evalin('caller','default_cs_charge_trq'));
else
   evalin('base','clear cs_charge_trq');
end%tm added on 10/12/98 for max acceleration performance on parallels
if evalin('caller','exist(''default_vc_key_on'')')
   assignin('base','vc_key_on',evalin('caller','default_vc_key_on')); 
else
   evalin('base','clear vc_key_on');
end;
if evalin('caller','exist(''default_gb_shift_delay'')')
   assignin('base','gb_shift_delay',evalin('caller','default_gb_shift_delay'));  
else
   evalin('base','clear gb_shift_delay');
end;
if evalin('caller','exist(''default_vc_launch_spd'')')
   assignin('base','vc_launch_spd',evalin('caller','default_vc_launch_spd'));
else
   evalin('base','clear vc_launch_spd');
end;

% Drive Cycle
if evalin('caller','exist(''default_cyc_mph'')')
   assignin('base','cyc_mph',evalin('caller','default_cyc_mph'));
else
   evalin('base','clear cyc_mph');
end;
if evalin('caller','exist(''default_cyc_avg_time'')')
   assignin('base','cyc_avg_time',evalin('caller','default_cyc_avg_time'));
else
   evalin('base','clear cyc_avg_time');
end;
if evalin('caller','exist(''default_cyc_filter_bool'')')
   assignin('base','cyc_filter_bool',evalin('caller','default_cyc_filter_bool'));
else
   evalin('base','clear cyc_filter_bool');
end;
if evalin('caller','exist(''default_cyc_grade'')')
   assignin('base','cyc_grade',evalin('caller','default_cyc_grade')); 
else
   evalin('base','clear cyc_grade');
end;
if evalin('caller','exist(''default_vinf_cycle_number'')')
   vinf.cycle.number=evalin('caller','default_vinf_cycle_number');
end;
if evalin('caller','exist(''default_vinf_cycle_soc'')')
   vinf.cycle.soc=evalin('caller','default_vinf_cycle_soc');
end;

% Initial conditions
if evalin('caller','exist(''default_ess_init_soc'')')
   assignin('base','ess_init_soc',evalin('caller','default_ess_init_soc')); 
else
   evalin('base','clear ess_init_soc');
end;
if evalin('caller','exist(''default_enable_stop_fc'')')
   assignin('base','enable_stop_fc',evalin('caller','default_enable_stop_fc')); 
else
   evalin('base','clear enable_stop_fc');
end;
if evalin('caller','exist(''default_ex_cat_mon_init_tmp'')')
   assignin('base','ex_cat_mon_init_tmp',evalin('caller','default_ex_cat_mon_init_tmp')); 
   assignin('base','ex_cat_int_init_tmp',evalin('caller','default_ex_cat_int_init_tmp')); 
   assignin('base','ex_cat_pipe_init_tmp',evalin('caller','default_ex_cat_pipe_init_tmp')); 
   assignin('base','ex_cat_ext_init_tmp',evalin('caller','default_ex_cat_ext_init_tmp')); 
   assignin('base','ex_manif_init_tmp',evalin('caller','default_ex_manif_init_tmp')); 
end;
if evalin('caller','exist(''default_fc_c_init_tmp'')')
   assignin('base','fc_c_init_tmp',evalin('caller','default_fc_c_init_tmp'));
   assignin('base','fc_i_init_tmp',evalin('caller','default_fc_i_init_tmp'));
   assignin('base','fc_x_init_tmp',evalin('caller','default_fc_x_init_tmp'));
   assignin('base','fc_h_init_tmp',evalin('caller','default_fc_h_init_tmp'));
end;
if evalin('caller','exist(''default_ess_mod_init_tmp'')')
   assignin('base','ess_mod_init_tmp',evalin('caller','default_ess_mod_init_tmp'));
end;
if evalin('caller','exist(''default_mc_init_tmp'')')
   assignin('base','mc_init_tmp',evalin('caller','default_mc_init_tmp'));
end;

return 
% end of restore function

% REVISION HISTORY
% 07/28/98:vh file created
% 08/05/98:tm file converted to a function that returns the three acelleration times
% 8/6/98:ss a few modifications for vinf... variable and outputing to workspace
% 8/7/98:vh maximum acceleration and feet traveled in 5 seconds added
% 08/12/98:tm introduced default_vc_key_on variable to store original key_on data
% 08/14/98:tm set ess_init_soc to cs_lo_soc to force worse case scenario
% 8/14/98:tm override the number of cycles to run, set to 1
% 8/18/98:vh, set ess_init_soc to cs_hi_soc
% 8/20/98:vh, shift delay set to 0.2 sec
% 8/21/98:vh, vc_launch_speed set to a lower value
% 8/25/98:vh, added default setting/resetting for vinf.cycle.soc, adjust vinf.cycle.number settings
% 8/27/98:vh, changed cycle--delay start, adjust times accordingly
% 8/28/98:vh, adjusted 5 second distance travelled
% 8/30/98:matt, set vc_launch_spd=max(fc_map_spd)/2.5
% 10/5/98:sam added the variable cs_electric_launch_spd=0 for parallel case
%             so engine is allowed to come on right away for max acceleration effort
% 10/13/98:tm added statements to store, override, and restore parallel cs 
%             variables cs_min_trq_frac, cs_off_trq_frac, and cs_charge_trq
% 10/30/98:tm set the length of the cycle based on the 0 to 85 time plus 2 secs
% 11/3/98:tm length of cycle is based on target 0 to 85 time if autosize_run_status 
%					equals 1 otherwise the default is 45 sec.
% 11/3/98:tm introduced display variable, 1==> all results are displayed, 0==> no results displayed
% 12/10/98:ss added time40,time60,time85 and interp1 command to interpolate times rather than selecting
%       based on the nearest index.(very helpful for optimization runs)
%		  Also, read in t and mpha into function workspace for ease of coding
% 12/16/98: ss added global vinf to two subfunctions for vinf.cycle.soc to be restored properly
% 12/31/98: ss replaced line 53:if exist('default_ess_init_soc')
%									with if ~strcmp(drivetrain,'conventional') due to the fact that initial conditions
%									of ess_init_soc may exist even when a conventional is run.
% 2/25/99: vhj/sb changed initial condition variable for ex, fc, ess, and m
% 3/2/99:tm added 0-18 and 0-30 mph times for buses and heavy vehicles
% 8/23/99: tm modified all cyc_grade definitions so they are all 2 column matrices
% 8/26/99: ss prevented setting of ess_init_soc for Prius case
% 1/12/00:tm introduced save, restore and override of enable_stop_fc variable so that 
% 				accel test is unaffected by j1711 changes
% 2/2/01: ss updated prius to prius_jpn
