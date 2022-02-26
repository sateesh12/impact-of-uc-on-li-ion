function max_grade=grade_test(mph,grade,lb,ub)
%
% This function finds the maximum grade at which
% the vehicle can maintain a constant speed. 
% If mph and grade are defined the script
% will only interate once to determine if the vehicle 
% can attain the grade at the specified speed or not and will either return 
% the grade if achieved or an empty set if not achieved. 
%
% Input arguments:
%		grade - grade the vehicle will try to achieve (%) [optional]
%		mph - the speed the vehicle is to achieve at the specified grade (mph)
%		lb - lower bound for bisection method [optional]
%		ub - upper bound for bisection method [optional]
% NOTES:
%	1) If no argument is given the vehicle will find the max grade achievable at 55 mph.
%  2) If only a speed argument is provided, grade test will find the max grade at the specified speed.
%	3) If an ub or lb is provided it will be used to reduce the number of iterations required
% Output arguments:
%		max_grade - grade achieved, if both grade and mph have been 
% 						defined and the vehicle is unable to achieve the 
% 						goals max_grade will return as an empty set.
%


% give the function access to all vehicle config info 
global vinf

% set display results variable, 1==> display results, 0==> don't display results
display=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORE CURRENT WORKSPACE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
store % see subroutines below


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD THE DRIVE CYCLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if no arguments given find max grade at 55 mph
if nargin<1 
   mph=55; % goal speed (mph)
end;

build_cycle(mph) % see subroutines below


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE TARGETS AND TOLERANCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolerances
mph_tol=0.01; % mph tolerance 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERRIDE VEHICLE DRIVETRAIN VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set gear to be used for climbing if
% CVT is not used
cvt_not_used=~strcmp(vinf.transmission.type,'cvt');
if cvt_not_used
   
   % determine the lowest gear that can meet the vehicle speed goal
   if strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'series')
      spds=mph*0.447.*evalin('base','gb_ratio*fd_ratio/wh_radius'); % estimate possible motor speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','mc_map_spd*mc_spd_scale'))); % limit to those speeds within the motor map
      trqs=evalin('base',['interp1(mc_map_spd*mc_spd_scale,mc_max_trq*mc_trq_scale,',mat2str(spds),')']); % determine max torque (continuous) at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
      
      %03/11/00:tm replaced with above lines; 
      %gear_number=min(find(evalin('base','max(mc_map_spd)./gb_ratio/fd_ratio*wh_radius/0.447')>=mph));
   else
      spds=mph*0.447.*evalin('base','gb_ratio*fd_ratio/wh_radius'); % estimate possible engine speeds corresponding to desired vehicle speed
      spds=spds.*(spds<=max(evalin('base','fc_map_spd*fc_spd_scale'))); % limit to those speeds within the engine map
      trqs=evalin('base',['interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,',mat2str(spds),')']); % determine max torque at possible speeds
      gear_number=min(find(max(spds.*trqs)==(spds.*trqs))); % determine gear that will provide the maximum power
      
      % 03/11/00:tm replaced with above lines; 
      %gear_number=min(find(evalin('base','0.85*max(fc_map_spd)./gb_ratio/fd_ratio*wh_radius/0.447')>=mph));
      % 02/22/00:tm 0.85* included so that gear is chosen to avoid sizing to a redline engine condition
   end;
   if isempty(gear_number)|(nnz(spds)<1)
      disp(' ')
      disp('WARNING: Vehicle cannot achieve goal speed with current drivetrain!!')
      disp(' ')
      grade_test_spd_limited=1;
   else      
      grade_test_spd_limited=0;
      % minimum gear number +1 forces the engine to run at a higher torque, lower speed point
      %gb_climbgear=min(gear_number+1,length(evalin('base','gb_ratio'))) % removed tm(11/12/99) as a result of 0.85* added above
      %gb_climbgear=min(gear_number,length(evalin('base','gb_ratio'))); 
      gb_climbgear=gear_number;
      % make all gear ratios same as climbgear ratio if not using CVT 
      assignin('base','gb_ratio',ones(size(default_gb_ratio))*default_gb_ratio(gb_climbgear)); 
   end;
else      
   grade_test_spd_limited=0;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERRIDE VEHICLE CONTROL VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All vehicles
if exist('default_gb_shift_delay')
   assignin('base','gb_shift_delay',0); % no delay between shifts
end;
if exist('default_cs_fc_init_state')
   assignin('base','cs_fc_init_state',1); % engine initially ON
end;

% Series vehicles
if exist('default_cs_max_pwr_rise_rate')
   assignin('base','cs_max_pwr_rise_rate',Inf);  % do not limit response time of the engine
end;
if exist('default_cs_charge_pwr')
   assignin('base','cs_charge_pwr',0); % do not request additional power to charge ess
end;
if exist('default_mc_overtrq_factor')&(strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'fuel_cell')|strcmp(vinf.drivetrain.name,'series'))
   assignin('base','mc_overtrq_factor',1); % do not allow operation outside of the continuous range
end

% Non-conventional vehicles %tm:06/30/00 this section moved ahead of parallel section
if exist('default_ess_init_soc')
   if (strcmp(vinf.drivetrain.name,'ev')|strcmp(vinf.drivetrain.name,'prius_jpn'))
      % initialize the energy storage system to 1/2 its useable range (ev and prius cannot operate without some SOC)
      evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); 
   else
      assignin('base','ess_init_soc',0); % disable the energy storage system (worse case)
   end
end;

% Parallel vehicles
if exist('default_cs_electric_launch_spd')
   assignin('base','cs_electric_launch_spd',0); % do not suppress the engine during launch from zero spd
end;
if exist('default_cs_min_trq_frac')
   assignin('base','cs_min_trq_frac',0); % do not enforce a minimum engine torque output
end;
if exist('default_cs_off_trq_frac')
   assignin('base','cs_off_trq_frac',0); % do not turn engine off for low torque events
end;
if exist('default_cs_charge_trq')
   assignin('base','cs_charge_trq',0); % do not request additional trq to charge ess
end;

% tm:06.30.00 section disabled - now handled within block diagram
if 0%evalin('base','ess_init_soc')<eps&strcmp(vinf.drivetrain.name,'parallel')&exist('default_acc_mech_pwr')&exist('default_acc_elec_pwr')
   % add electrical accessory loads to the engine load
   % estimate engine speed
   eng_spd=mph*0.447*evalin('base',['1/wh_radius*fd_ratio*gb_ratio(',num2str(gb_climbgear),')']); 
   % estimate motor speed
   mc_spd=eng_spd*evalin('base','tc_mc_to_fc_ratio');
   % interpolate input power vector at motor speed as a function of output torque
   mc_inpwr=evalin('base',['interp2(mc_map_spd*mc_spd_scale,mc_map_trq*mc_trq_scale,mc_inpwr_map''*mc_spd_scale*mc_trq_scale,',num2str(mc_spd),',mc_map_trq*mc_trq_scale)']);
   % sort the input power vector and the output torque vector in ascending order based on input power vector
   sorted=sortrows([mc_inpwr evalin('base','mc_map_trq''*mc_trq_scale')],1);
   % interpolate output torque to provide the required accessory load
   mc_out_trq=interp1(sorted(:,1),sorted(:,2),evalin('base','-acc_elec_pwr/acc_elec_eff'));
   % add required mc output power to the acc mechanical load applied to the engine
   evalin('base',['acc_mech_pwr=acc_mech_pwr+',num2str(-mc_spd*mc_out_trq),'*acc_mech_eff;'])
   % override the electrical accessory loads
   assignin('base','acc_elec_pwr',0)
end

% misc
if exist('default_enable_stop_fc')
   assignin('base','enable_stop_fc',0); % don't end simulation if engine turns on
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_grade=[]; % stores the max grade achieved
veh_mph=[]; % stores the speed at which the max grade was achieved
achieved=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST VEHICLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~grade_test_spd_limited
   if (nargin<2)|(grade<0) % FIND MAX GRADE AT SPEED
      
      % limit the number of iterations of the while loop to 10
      max_iter=25;
      
      % set active bounds
      if nargin>2
         if nargin==3
            grade_lb=lb;
         elseif nargin==4
            grade_lb=lb/100;
            grade_ub=ub/100;
         end;
      else
         grade_lb=0.0;
         grade_ub=0.10;
      end;
      
      % Test the upper bound
      %assignin('base','cyc_grade',grade_ub);
      assignin('base','cyc_grade',[0 grade_ub; 1 grade_ub])
      if display
         disp(' ')
         fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, mph)
      end;
      % run simulation
      gui_run_simulation; % run simulation using a default time step (1 sec)
      
      % check results
      mpha=evalin('base','mpha'); % store the speed achieved
      % calculate the difference between adjacent speeds to ensure
      % that it is within a specified tolerance and ensure that the 
      % actual speed is also within in a specified tolerance
      % consider only last three speeds
      if (abs(diff(mpha(end-2:end))<0.01)&(abs(mpha(end-1:end)-mph)<mph_tol))
         achieved=1; % set flag that grade was achieved
         if display
            fprintf(1,' ... achieved\n')
            disp(' ')
         end;
      else
         achieved=0;
         if display
            fprintf(1,' ... not achieved\n')
         end;
         % Test lower bound
         %assignin('base','cyc_grade',grade_lb);
         assignin('base','cyc_grade',[0 grade_lb; 1 grade_lb])
         if display
            fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, mph)
         end;
         
         % run simulation
         gui_run_simulation; % run simulation using a default time step (1 sec)
         
         % check results 
         mpha=evalin('base','mpha'); % store the speed achieved
         % calculate the difference between adjacent speeds to ensure
         % that it is within a specified tolerance and ensure that the 
         % actual speed is also within in a specified tolerance
         % consider only last three speeds
         if (abs(diff(mpha(end-2:end))<0.01)&(abs(mpha(end-1:end)-mph)<mph_tol))
            achieved=1; % set flag that grade was achieved
            if display
               fprintf(1,' ... achieved\n')
            end;
         else
            achieved=0;
            if display
               fprintf(1,' ... not achieved\n')
               disp(' ')   
            end;
         end;
         
         if achieved   
            % loop between upper and lower bounds
            iter=0;
            loop=1;
            while loop
               if achieved
                  grade_lb=evalin('base','cyc_grade(1,2)');
               else                  
                  grade_ub=evalin('base','cyc_grade(1,2)');
               end;
               assignin('base','cyc_grade',[0 round(0.5*(grade_lb+grade_ub)*1000000)/1000000; 1 round(0.5*(grade_lb+grade_ub)*1000000)/1000000]); % for visdoc
               %assignin('base','cyc_grade',[0 round(0.5*(grade_lb+grade_ub)*10000)/10000; 1 round(0.5*(grade_lb+grade_ub)*10000)/10000]); % for matlab
               if display
                  fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, mph)
               end;
               % run simulation
               gui_run_simulation; % run simulation using a default time step (1 sec)
               
               % check results  
               mpha=evalin('base','mpha'); % store the speed achieved
               % calculate the difference between adjacent speeds to ensure
               % that it is within a specified tolerance and ensure that the 
               % actual speed is also within in a specified tolerance
               % consider only last three speeds
               if (abs(diff(mpha(end-2:end))<0.01)&(abs(mpha(end-1:end)-mph)<mph_tol))
                  achieved=1; % set flag that grade was achieved
                  if display
                     fprintf(1,' ... achieved\n')
                  end;
               else
                  achieved=0;
                  if display
                     fprintf(1,' ... not achieved\n')
                  end;
               end;
               iter=iter+1;
               if iter>=max_iter|(grade_ub-grade_lb)<=0.000005 % for visdoc
               %if iter>=max_iter|(grade_ub-grade_lb)<=0.0005 % for matlab
                  if display
                     disp(' ')
                     if iter>=max_iter
                        disp('    *** Maximum number of iterations exceeded. ***')
                     end;
                     if (grade_ub-grade_lb)<=0.000005 % for visdoc
                     %if (grade_ub-grade_lb)<=0.0005 % for matlab
                        disp('    *** Upper and lower bounds have converged. ***')
                     end;
                     disp(' ')
                  end;
                  loop=0;
                  if ~achieved
                     % test at last successful point
                     assignin('base','cyc_grade',[0 grade_lb; 1 grade_lb]);
                     if display
                        fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, mph)
                     end;
                     % run simulation
                     gui_run_simulation % run simulation using a default time step (1 sec)
                     
                     % check results  
                     mpha=evalin('base','mpha'); % store the speed achieved
                     % calculate the difference between adjacent speeds to ensure
                     % that it is within a specified tolerance and ensure that the 
                     % actual speed is also within in a specified tolerance
                     % consider only last three speeds
                     if (abs(diff(mpha(end-2:end))<0.01)&(abs(mpha(end-1:end)-mph)<mph_tol))
                        achieved=1; % set flag that grade was achieved
                        if display
                           fprintf(1,' ... achieved\n')
                        end;
                     else
                        achieved=0;
                        if display
                           fprintf(1,' ... not achieved\n')
                        end;
                     end;
                     if display
                        disp(' ')
                     end;
                  end;
               else
                  loop=1;
               end;
            end;
         end;
      end;
      
   else % CAN VEHICLE ACHIEVE x GRADE AT y SPEED??
      
      % set the goal grade
      assignin('base','cyc_grade',[0 grade/100; 1 grade/100]);
      if display 
         disp(' ')
         fprintf(1,'    Trying %g %% grade at %g mph.', evalin('base','cyc_grade(1,2)')*100, mph)
      end;
      
      % run simulation
      gui_run_simulation; % run simulation using a default time step (1 sec)
      
      % check results 
      mpha=evalin('base','mpha'); % store the speed achieved
      % calculate the difference between adjacent speeds to ensure
      % that it is within a specified tolerance and ensure that the 
      % actual speed is also within in a specified tolerance
      % consider only last three speeds
      if (abs(diff(mpha(end-2:end))<0.01)&(abs(mpha(end-1:end)-mph)<mph_tol))
         achieved=1; % set flag that grade was achieved
         if display
            fprintf(1,' ... achieved.\n')
         end;
      else
         achieved=0;
         if display
            fprintf(1,' ... not achieved.\n')
         end;
      end;
      if display
         disp(' ')
      end;
   end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETURN RESULTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if grade was achieved or the upper bound was reached 
% return the last grade tested else return an empty set
if achieved
   max_grade=evalin('base','cyc_grade(1,2)')*100; 
end;

% return results to the GUI
vinf.max_grade=max_grade/100;

% return results to the screen
if ~grade_test_spd_limited&display
   disp('    <<< GRADE TEST RESULTS >>> ')
   if achieved
      if nargin<1
         disp(['    At ', num2str(mph), ' mph, maximum grade = ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
      elseif nargin<2
         if ~exist('loop')
            disp(['    At ', num2str(mph), ' mph, maximum grade >= ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
         else
            disp(['    At ', num2str(mph), ' mph, maximum grade = ', num2str(evalin('base','cyc_grade(1,2)')*100), ' %.'])
         end;
      else
         disp(['    Maintained ', num2str(mph), ' mph on a ', num2str(evalin('base','cyc_grade(1,2)')*100), ' % grade.'])
      end;
   else
      disp(['    Unable to maintain ', num2str(mph), ' mph on a ', num2str(evalin('base','cyc_grade(1,2)')*100), ' % grade.'])
   end;
   disp(' ')
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESTORE ORIGINAL WORKSPACE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
restore % see subroutines below


%%%%%%%%%%%%%%%%%%%
% END OF MAIN BODY
%%%%%%%%%%%%%%%%%%%
return; 


%%%%%%%%%%%%%%%%%%%
% SUBROUTINES
%%%%%%%%%%%%%%%%%%%
function build_cycle(mph)
%
% Build the driving schedule for the grade test
%

global vinf

% Build the driving schedule
time=[0:10]; % cycle is 10 seconds long
mph_r=[ones(1,length(time))*mph]; 
cyc_mph=[time' mph_r'];
assignin('base','cyc_mph', cyc_mph);
assignin('base','vc_key_on', [cyc_mph(:,1) ones(size(cyc_mph(:,1)))]);
assignin('base','cyc_filter_bool', 0); % do not filter the requested cycle
assignin('base','cyc_avg_time', 1); % no averaging of the requested cycle
vinf.cycle.number=1; % run only one cycle
return;


function store()
%
% This function stores all of the current workspace variables 
% that will be changed by the grade test function
%

global vinf

% Store current workspace variables
if evalin('base','exist(''mc_overtrq_factor'')')
   assignin('caller','default_mc_overtrq_factor',evalin('base','mc_overtrq_factor'));
end;
if evalin('base','exist(''ess_init_soc'')')
   assignin('caller','default_ess_init_soc',evalin('base','ess_init_soc'));
end;
if evalin('base','exist(''acc_elec_pwr'')')
   assignin('caller','default_acc_elec_pwr',evalin('base','acc_elec_pwr'));
end;
if evalin('base','exist(''acc_mech_pwr'')')
   assignin('caller','default_acc_mech_pwr',evalin('base','acc_mech_pwr'));
end;
if evalin('base','exist(''enable_stop_fc'')')
   assignin('caller','default_enable_stop_fc',evalin('base','enable_stop_fc'));
end;
if evalin('base','exist(''cs_fc_init_state'')')
   assignin('caller','default_cs_fc_init_state',evalin('base','cs_fc_init_state'));
end;
if evalin('base','exist(''gb_shift_delay'')')
   assignin('caller','default_gb_shift_delay',evalin('base','gb_shift_delay'));
end;
if evalin('base','exist(''gb_ratio'')')
   assignin('caller','default_gb_ratio',evalin('base','gb_ratio'));
end;
if evalin('base','exist(''cyc_mph'')')
   assignin('caller','default_cyc_mph',evalin('base','cyc_mph'));
end;
if evalin('base','exist(''vc_key_on'')')
   assignin('caller','default_vc_key_on',evalin('base','vc_key_on'));
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
if evalin('base','exist(''cs_max_pwr_rise_rate'')')
   assignin('caller','default_cs_max_pwr_rise_rate',evalin('base','cs_max_pwr_rise_rate'));
end;
if evalin('base','exist(''cs_electric_launch_spd'')')
   assignin('caller','default_cs_electric_launch_spd',evalin('base','cs_electric_launch_spd'));
end;
if evalin('base','exist(''cs_min_trq_frac'')')
   assignin('caller','default_cs_min_trq_frac',evalin('base','cs_min_trq_frac'));
end;
if evalin('base','exist(''cs_off_trq_frac'')')
   assignin('caller','default_cs_off_trq_frac',evalin('base','cs_off_trq_frac'));
end;
if evalin('base','exist(''cs_charge_trq'')')
   assignin('caller','default_cs_charge_trq',evalin('base','cs_charge_trq'));
end;
if evalin('base','exist(''cs_charge_pwr'')')
   assignin('caller','default_cs_charge_pwr',evalin('base','cs_charge_pwr'));
end;
eval('h=vinf.cycle.number; test4exist=1;','test4exist=0;')
if test4exist & vinf.cycle.number>1
   assignin('caller','default_vinf_cycle_number',vinf.cycle.number);
end;
return;


function restore()
%
% This function restores all of the current workspace variables 
% to their original values that were be changed by the grade test function
%

global vinf

% Restore current workspace variables
if evalin('caller','exist(''default_vinf_cycle_number'')')
   vinf.cycle.number=evalin('caller','default_vinf_cycle_number');
end
if evalin('caller','exist(''default_cyc_mph'')')
   assignin('base','cyc_mph',evalin('caller','default_cyc_mph'));
else
   evalin('base','clear cyc_mph');
end;
if evalin('caller','exist(''default_mc_overtrq_factor'')')
   assignin('base','mc_overtrq_factor',evalin('caller','default_mc_overtrq_factor'));
else
   evalin('base','clear mc_overtrq_factor');
end;
if evalin('caller','exist(''default_acc_mech_pwr'')')
   assignin('base','acc_mech_pwr',evalin('caller','default_acc_mech_pwr'));
else
   evalin('base','clear acc_mech_pwr');
end;
if evalin('caller','exist(''default_acc_elec_pwr'')')
   assignin('base','acc_elec_pwr',evalin('caller','default_acc_elec_pwr'));
else
   evalin('base','clear acc_elec_pwr');
end;
if evalin('caller','exist(''default_cyc_grade'')')
   assignin('base','cyc_grade',evalin('caller','default_cyc_grade'));
else
   evalin('base','clear cyc_grade');
end;
if evalin('caller','exist(''default_enable_stop_fc'')')
   assignin('base','enable_stop_fc',evalin('caller','default_enable_stop_fc'));
else
   evalin('base','clear enable_stop_fc');
end;
if evalin('caller','exist(''default_vc_key_on'')')
   assignin('base','vc_key_on',evalin('caller','default_vc_key_on'));
else
   evalin('base','clear vc_key_on');
end;
if evalin('caller','exist(''default_gb_ratio'')')
   assignin('base','gb_ratio',evalin('caller','default_gb_ratio'));
else
   evalin('base','clear gb_ratio');
end;
if evalin('caller','exist(''default_gb_shift_delay'')')
   assignin('base','gb_shift_delay',evalin('caller','default_gb_shift_delay'));
else
   evalin('base','clear gb_shift_delay');
end;
if evalin('caller','exist(''default_ess_init_soc'')')
   assignin('base','ess_init_soc',evalin('caller','default_ess_init_soc'));
else
   evalin('base','clear ess_init_soc');
end;
if evalin('caller','exist(''default_cs_fc_init_state'')')
   assignin('base','cs_fc_init_state',evalin('caller','default_cs_fc_init_state'));
else
   evalin('base','clear cs_fc_init_state');
end;
if evalin('caller','exist(''default_cyc_filter_bool'')')
   assignin('base','cyc_filter_bool',evalin('caller','default_cyc_filter_bool'));
else
   evalin('base','clear cyc_filter_bool');
end;
if evalin('caller','exist(''default_cyc_avg_time'')')
   assignin('base','cyc_avg_time',evalin('caller','default_cyc_avg_time'));
else
   evalin('base','clear cyc_avg_time');
end;
if evalin('caller','exist(''default_cs_electric_launch_spd'')')
   assignin('base','cs_electric_launch_spd',evalin('caller','default_cs_electric_launch_spd'));
else
   evalin('base','clear cs_electric_launch_spd');
end;
if evalin('caller','exist(''default_cs_min_trq_frac'')')
   assignin('base','cs_min_trq_frac',evalin('caller','default_cs_min_trq_frac'));
else
   evalin('base','clear cs_min_trq_frac');
end;
if evalin('caller','exist(''default_cs_off_trq_frac'')')
   assignin('base','cs_off_trq_frac',evalin('caller','default_cs_off_trq_frac'));
else
   evalin('base','clear cs_off_trq_frac');
end;
if evalin('caller','exist(''default_cs_charge_trq'')')
   assignin('base','cs_charge_trq',evalin('caller','default_cs_charge_trq'));
else
   evalin('base','clear cs_charge_trq');
end;
if evalin('caller','exist(''default_cs_charge_pwr'')')
   assignin('base','cs_charge_pwr',evalin('caller','default_cs_charge_pwr'));
else
   evalin('base','clear cs_charge_pwr');
end;
if evalin('caller','exist(''default_cs_max_pwr_rise_rate'')')
   assignin('base','cs_max_pwr_rise_rate',evalin('caller','default_cs_max_pwr_rise_rate'));
else
   evalin('base','clear cs_max_pwr_rise_rate');
end;
return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/28/98:tm file created
% 08/04/98:tm file fully commented, cleaned up, and working with 
%				  all block diagrams
% 08/10/98:tm added "global vinf" and vinf.grade.max assignment 
%				  so that results can be reported by the GUI
% 08/11/98:tm statements added to Storage and Restore sections 
%				  so that file can be run from the vehicle setup screen.
% 08/19/98:vh added an 'or tooflat' onto the return variable section
% 08/19/98:vh changed decrement values to converge more quickly: mpha(5),0.5,5*cyc_delta
% 08/21/98:vh cosmetic display changes
% 08/24/98:tm removed line to display current gear ratio
% 08/24/98:tm added lines to store, override, and restore parallel control strategy variables
% 08/25/98:vh number of cycles default assignment corrected
% 08/28/98:tm added lines to store, override, and restore series control strategy variables
% 08/31/98:mc made 'achieved' a function of performance on last three time steps only
% 08/31/98:tm changed trace mph from [goal-0.001 goal+0.001] to [goal], no need for 
%				  adjusted trace anymore
% 09/10/98:tm disabled energy storage system for parallel and series vehicles
% 09/11/98:tm changed max grade to 10% to reduce number of needless interations
% 09/11/98:tm added override for cs_max_pwr_rise_rate
% 9/16/98:tm changed input arguments to include speed and grade
% 9/16/98:tm moved storage and restoration of workspace to subroutines
% 10/6/98:ss corrected method to store and restore the number of cycles in vinf.cycle.number
% 10/26/98:tm revised climbgear assignment statements if no gear will provide the goal 
%             speed the function will return an empty set.
% 10/27/98:tm bisection method applied to grade_test function
% 11/3/98:tm introduced display variable, 1==> display results, 0==> don't display results
% 11/3/98:tm revised display messages to use less screen space
% 8/20/99:tm updated to use cyc_grade as a 2-column matrix of dist vs. grade
% 1/12/00:tm revised the selection of the climbgear such that the only constraint is that 
% 				the engine speed is less than 85% of the max 
%				- this leads to significant changes in grade performance!!!
%				previous method found the minimum gear and increased it by one to ensure 
% 				that the engine could maintain the state indefinitely
% 1/12/00:tm introduced save, restore and override of enable_stop_fc variable so that 
% 				 grade test is unaffected by j1711 changes
% 2/10/00:tm revised the selection of the climbgear such that the climb gear will be chosen 
%				 such that it provides the maximum amount of power 
%				 while staying within the speed range of the map
% 3/14/00:tm added statements to exclude the prius when disabling the ess (prius cannot operate without an ESS)
% 2/2/01: ss updated prius to prius_jpn
% 3/14/00:tm for parallel hybrid include the electrical accessory with the mechanical accessory so 
%            that the accessory loads are accounted for by the engine otherwise electrical accesories are 
%            pulled from an ESS that can not provide any power.
% 3/15/00:tm additional comments added to override statements
% 3/15/00:tm included statements to store, override, and restore the mc_overtrq_factor for ev-like vehicles
% 				 note: this will likely have no effect since the motor has always been matched to the 
%            fc based on its continuous range
% 6/30/00:tm moved overrides for non-conventional vehicles ahead of overrides for parallel hybrids required for handling of init soc
% 6/30/00:tm disabled shift of electrical accessories to mechanical accessories - now handled in block diagram
%

