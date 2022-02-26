% chknewmc.m
%
% __Summary__
% This function performs all tests recommended before a new motor/controller
% file is added to the ADVISOR library.  Test results are dumped to the screen
% for the user's subjective evaluation.
%
% __Syntax__
% chknewmc('mc_ac130') <OR> chknewmc mc_ac130, for example
%
% __Outputs__
% This function returns no value, but produces plots and text results.
%
% __Inputs__
% The name of an MC file must be passed to this function, and the function must
% be executed with the current version of ADVISOR in the path.
function chknewmc(filename)

% initialize
latest_ver=2.21;   % latest ADVISOR version
test_cycles={'CYC_UDDS',...  
      'CYC_HWFET',...
      'CYC_SC03',...
      'CYC_US06',...
      'CYC_ACCEL'};
cv_filename='CV_EV';
bd_filename='BD_EV';
filename=upper(filename);
eval(filename)
label_filename=strrep(filename,'_','\_');
evalin('base',cv_filename)
evalin('base',filename)
evalin('base',...
   'gb_ratio=ones(size(gb_ratio))*max(mc_map_spd)/(90*.447/wh_radius);');
evalin('base','veh_mass=max(mc_map_spd.*mc_max_trq)/58.5;') % 0-60 in ~10 s
assignin('base','bd_filename',bd_filename)

% convert file if necessary
if mc_version~=latest_ver
   update_file(filename)
end

% develop motor specs (max torque, max speed, max power, specific power
max_trq_str=sprintf('%0.1f Nm',round(10*max(mc_max_trq))/10);
max_spd_str=sprintf('%0.0f rpm',max(mc_map_spd)*30/pi);
max_pwr_str=sprintf('%0.1f kW',round(max(mc_map_spd.*mc_max_trq)/100)/10);
sp_pwr_str=sprintf('%0.0f W/kg',round(max(mc_map_spd.*mc_max_trq)/mc_mass));
disp(' ')
disp(['                Specifications :  ',filename])
disp('----------------------------------------------')
disp(['                Max. cont. trq :  ',max_trq_str])
disp(['                Max. cont. pwr :  ',max_pwr_str])
disp(['                    Max. speed :  ',max_spd_str])
disp(['                Specific power :  ',sp_pwr_str])
disp(['Intermittent overtorque factor :  ',num2str(mc_overtrq_factor)])

% input power contour map
figure
max_lvl=5*round(max(mc_map_spd.*mc_max_trq)/1000/5);
interval=5*round(max(mc_map_spd.*mc_max_trq)/1000/10/5);
c=contour(mc_map_spd*30/pi,mc_map_trq,mc_inpwr_map'/1000,...
   [-max_lvl:interval:max_lvl]);
clabel(c)
hold on
plot(mc_map_spd*30/pi,mc_max_trq,'kx-')
ylabel('Motor torque (Nm)')
xlabel('Motor speed (rpm)')
title([label_filename,':  Input power (kW)'])
set(gcf,'Name','Input power map')

% efficiency contour map
if exist('mc_eff_map')
   figure
   c=contour(mc_map_spd*30/pi,mc_map_trq,mc_eff_map');
   clabel(c)
   hold on
   plot(mc_map_spd*30/pi,mc_max_trq,'kx-')
   ylabel('Motor torque (Nm)')
   xlabel('Motor speed (rpm)')
   title([label_filename,':  Efficiency map'])
   set(gcf,'Name','Efficiency map')
end

% put specific power on reference plot
ac_pwr=[25.4 74.6 82.9];
ac_sp_pwr=[337.9 820.1 754.0];
ac_pk_sp_pwr=ac_sp_pwr.*[1.5 1.8 1];
pm_pwr=[8.1 14.3 33 35.9 49.9];
pm_sp_pwr=[573.8 695 866.3 589.7 816.3];
pm_pk_sp_pwr=pm_sp_pwr.*[1.38 1.45 1.45 1.66 1];
figure
plot(ac_pwr,ac_sp_pwr,pm_pwr,pm_sp_pwr,ac_pwr,ac_pk_sp_pwr,pm_pwr,pm_pk_sp_pwr)
hold on
plot(max(mc_map_spd.*mc_max_trq)/1000,max(mc_map_spd.*mc_max_trq)/mc_mass,'k*')
plot(max(mc_map_spd.*mc_max_trq)/1000,...
   max(mc_map_spd.*mc_max_trq)/mc_mass*mc_overtrq_factor,'k+')
legend('AC cont.','PM cont.','AC peak','PM peak',[label_filename,' cont.'],...
   [label_filename,' peak'],4)
ylabel('Specific power (W/kg)')
title([label_filename,' specific power relative to those in A2.1.1 library'])
xlabel('Max. cont. power (kW)')
set(gcf,'Name','Specific power')

% cycle tests:  avg eta on driving & regen, s-by-s driving eta, s-by-s regen eta
figure
for i=1:length(test_cycles)
   evalin('base',test_cycles{i})
   if strcmp(test_cycles{i},'CYC_ACCEL')
      evalin('base',...
         'options=simset(''fixedstep'',0.1);,sim(bd_filename,50,options)')
   else
      evalin('base','sim(bd_filename)')
   end
      
   % compute average and second-by-second efficiencies
   P_out_driving=evalin('base',...
      'mc_ni_trq_out_a.*mc_spd_est.*(mc_ni_trq_out_a>0)');
   P_in_driving=evalin('base','mc_pwr_in_a.*(mc_ni_trq_out_a>0)');
   P_out_braking=-evalin('base','mc_pwr_in_a.*(mc_ni_trq_out_a<0)');
   P_in_braking=-evalin('base',...
      'mc_ni_trq_out_a.*mc_spd_est.*(mc_ni_trq_out_a<0)');
   eta_avg_driving=sum(P_out_driving)/sum(P_in_driving);
   eta_avg_braking=sum(P_out_braking)/sum(P_in_braking);
   eta_driving=P_out_driving./(P_in_driving+eps).*(P_in_driving~=0);
   eta_braking=P_out_braking./(P_in_braking+eps).*(P_in_braking~=0);
   t=evalin('base','t');
   
   % display results
   
   % text
   eta_driving_str=sprintf('%0.2f',eta_avg_driving*100);
   eta_braking_str=sprintf('%0.2f',eta_avg_braking*100);
   disp(' ')
   disp(['Cycle=',upper(test_cycles{i})])
   disp('--------------------')
   disp(['Average eff. while driving : ',eta_driving_str,'%'])
   disp(['Average eff. while braking : ',eta_braking_str,'%'])
   
   % plots
   subplot(length(test_cycles),2,2*i-1)
   plot(t,eta_driving),ylabel(strrep(upper(test_cycles{i}),'_','\_'))
   if i==1
      title([label_filename,':  Eff. while driving'])
   elseif i==length(test_cycles)
      xlabel('time (s)')
   end
   zoom on,grid on
   
   subplot(length(test_cycles),2,2*i)
   plot(t,eta_braking)
      if i==1
      title('Eff. while braking')
   elseif i==length(test_cycles)
      xlabel('time (s)')
   end
   x_limits=get(gca,'Xlim');
   y_max=max([1 max(eta_driving)]);
   axis([x_limits 0 y_max])
   zoom on,grid on
end

% 12/10/99:mc updated for ADVISOR 2.2.1:  latest_ver & changed 'mc_spd_out_a' to
%             mc_spd_est
% 12/10/99:mc use 0.1-s steps if running CYC_ACCEL