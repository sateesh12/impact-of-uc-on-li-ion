% chknewmc.m
%
% __Summary__
% This function performs all tests recommended before a new generator/controller
% file is added to the ADVISOR library.  Test results are dumped to the screen
% for the user's subjective evaluation.
%
% __Syntax__
% chknewmc('gc_pm32') <OR> chknewmc mc_pm32, for example
%
% __Outputs__
% This function returns no value, but produces plots and text results.
%
% __Inputs__
% The name of a GC file must be passed to this function, and the function must
% be executed with the current version of ADVISOR in the path.
function chknewmc(filename)

% initialize
latest_ver=2.21;   % latest ADVISOR version
test_cycles={'CYC_UDDS',...  
      'CYC_HWFET',...
      'CYC_SC03',...
      'CYC_US06',...
      'CYC_ACCEL'};
cv_filename='CV_SERFO';
bd_filename='BD_SER';
filename=upper(filename);
eval(filename)
% convert file if necessary
if gc_version~=latest_ver
   update_file(filename)
end
label_filename=strrep(filename,'_','\_');
evalin('base',cv_filename)
evalin('base',filename)
evalin('base',...
   'gb_ratio=ones(size(gb_ratio))*max(mc_map_spd)/(90*.447/wh_radius);');
evalin('base','veh_mass=max(mc_map_spd.*mc_max_trq)/58.5;') % 0-60 in ~10 s
% scale generator to match engine:
% highest generator speed at which max torque is positive matches highest
%   engine speed at which max torque is positive
% at speed at which engine reaches its max torque, generator can absorb exactly
%   this max torque
evalin('base','i_gc_last_pos_trq=max(find(gc_max_trq>eps));')
evalin('base','i_fc_last_pos_trq=max(find(fc_max_trq>eps));')
evalin('base','gc_spd_scale=fc_map_spd(i_fc_last_pos_trq)*fc_spd_scale/gc_map_spd(i_gc_last_pos_trq);')
evalin('base','spd_fc_max_trq=fc_spd_scale*fc_map_spd(min(find(fc_max_trq==max(fc_max_trq))));')
evalin('base','gc_trq_scale=fc_trq_scale*max(fc_max_trq)/interp1(gc_map_spd*gc_spd_scale,gc_max_trq,spd_fc_max_trq);')
evalin('base','PTC_SERFO') % recompute locus of best eff. points
assignin('base','bd_filename',bd_filename)

% develop gc specs (max torque, max speed, max power, specific power
max_trq_str=sprintf('%0.1f Nm',round(10*max(gc_max_trq))/10);
max_spd_str=sprintf('%0.0f rpm',max(gc_map_spd)*30/pi);
max_pwr_str=sprintf('%0.1f kW',round(max(gc_map_spd.*gc_max_trq)/100)/10);
sp_pwr_str=sprintf('%0.0f W/kg',round(max(gc_map_spd.*gc_max_trq)/gc_mass));
disp(' ')
disp(['                Specifications :  ',filename])
disp('----------------------------------------------')
disp(['                Max. cont. trq :  ',max_trq_str])
disp(['                Max. cont. pwr :  ',max_pwr_str])
disp(['                    Max. speed :  ',max_spd_str])
disp(['                Specific power :  ',sp_pwr_str])
disp(['Intermittent overtorque factor :  ',num2str(gc_overtrq_factor)])

% output power contour map
figure
max_lvl=5*round(max(gc_map_spd.*gc_max_trq)/1000/5);
interval=max([1,5*round(max(gc_map_spd.*gc_max_trq)/1000/10/5)]);
c=contour(gc_map_spd*30/pi,gc_map_trq,gc_outpwr_map'/1000,...
   [-max_lvl:interval:max_lvl]);
clabel(c)
hold on
plot(gc_map_spd*30/pi,gc_max_trq,'kx-')
ylabel('Generator torque (Nm)')
xlabel('Generator speed (rpm)')
title([label_filename,':  Output power (kW)'])
set(gcf,'Name','Output power map')

% efficiency contour map
if exist('gc_eff_map')
   figure
   c=contour(gc_map_spd*30/pi,gc_map_trq,gc_eff_map');
   clabel(c)
   hold on
   plot(gc_map_spd*30/pi,gc_max_trq,'kx-')
   ylabel('Generator torque (Nm)')
   xlabel('Generator speed (rpm)')
   title([label_filename,':  Efficiency map'])
   set(gcf,'Name','Efficiency map')
end

% put specific power on reference plot
%ac_pwr=[];
%ac_sp_pwr=[];
%ac_pk_sp_pwr=ac_sp_pwr.*[1.5 1.8 1];
pm_pwr=[33];
pm_sp_pwr=[866.3];
pm_pk_sp_pwr=pm_sp_pwr.*[1.45];
figure
%plot(ac_pwr,ac_sp_pwr,pm_pwr,pm_sp_pwr,ac_pwr,ac_pk_sp_pwr,pm_pwr,pm_pk_sp_pwr)
plot(pm_pwr,pm_sp_pwr,'b.',pm_pwr,pm_pk_sp_pwr,'g.')
hold on
plot(max(gc_map_spd.*gc_max_trq)/1000,max(gc_map_spd.*gc_max_trq)/gc_mass,'k*')
plot(max(gc_map_spd.*gc_max_trq)/1000,...
   max(gc_map_spd.*gc_max_trq)/gc_mass*gc_overtrq_factor,'k+')
legend('PM cont.','PM peak',[label_filename,' cont.'],...
   [label_filename,' peak'],4)
ylabel('Specific power (W/kg)')
title([label_filename,' specific power relative to those in A',num2str(latest_ver),' library'])
xlabel('Max. cont. power (kW)')
set(gcf,'Name','Specific power')

% cycle tests:  avg eta on driving & regen, s-by-s driving eta, s-by-s regen eta
fig_sbys=figure;
fig_conts=figure;
for i=1:length(test_cycles)
   evalin('base',test_cycles{i})
   if strcmp(test_cycles{i},'CYC_ACCEL')
      evalin('base',...
         'options=simset(''fixedstep'',0.1);,sim(bd_filename,50,options)')
   else
      evalin('base','sim(bd_filename)')
   end
      
   % compute average and second-by-second efficiencies
   P_in=evalin('base',...
      'gc_trq_in_a.*gc_spd_in_a.*(gc_trq_in_a>0)');
   P_out=evalin('base','gc_pwr_out_a.*(gc_trq_in_a>0)');
   eta_avg=sum(P_out)/sum(P_in);
   eta=P_out./(P_in+eps).*(P_in~=0);
   t=evalin('base','t');
   
   % display results
   
   % text
   eta_str=sprintf('%0.2f',eta_avg*100);
   disp(' ')
   disp(['Cycle=',upper(test_cycles{i})])
   disp('--------------------')
   disp(['Average eff. : ',eta_str,'%'])
   
   % plots of s-by-s eff
   figure(fig_sbys)
   subplot(length(test_cycles),1,i)
   plot(t,eta),ylabel(strrep(upper(test_cycles{i}),'_','\_'))
   if i==1
      title([label_filename,': ~Efficiency (=out/in, where ''in'' includes inertial effects)'])
   elseif i==length(test_cycles)
      xlabel('time (s)')
   end
   zoom on,grid on
   
   % contour plots
   if exist('gc_eff_map')
      figure(fig_conts)
      gc_spd_in_a=evalin('base','gc_spd_in_a');
      gc_trq_in_a=evalin('base','gc_trq_in_a');
      gc_pwr_out_a=evalin('base','gc_pwr_out_a');
      gc_trq_scale=evalin('base','gc_trq_scale');
      gc_spd_scale=evalin('base','gc_spd_scale');
      subplot(floor(length(test_cycles)+1)/2,2,i)
      c=contour(gc_map_spd*gc_spd_scale*30/pi,gc_map_trq*gc_trq_scale,...
         gc_eff_map);
      clabel(c)
      hold on
      plot(gc_map_spd*gc_spd_scale*30/pi,gc_max_trq*gc_trq_scale,'kx-')
      plot(gc_spd_in_a*30/pi,gc_trq_in_a,'.')
      title(strrep(upper(test_cycles{i}),'_','\_'))
      xlabel('Spd (rpm)')
      ylabel('Trq (N*m)')
   end

end

% 12/10/99:mc updated for ADVISOR 2.2.1:  latest_ver & changed 'mc_spd_out_a' to
%             mc_spd_est
% 12/10/99:mc use 0.1-s steps if running CYC_ACCEL
% 1/4/2000:mc created from chknewmc.m
% 7/10/99:ss all references to FUDS are now UDDS