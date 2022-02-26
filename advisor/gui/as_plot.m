function opt_plot
% creates the optimization summary plot

global vinf

units_flag=strcmp(vinf.units,'metric');

% design variables
subplot(2,2,1)

% calculate ess max pwr

if vinf.autosize.dv(1)&vinf.autosize.dv(2)&vinf.autosize.dv(3)
   evalin('base','plot(counter_log,dv_log(:,1),''rx-'',counter_log,dv_log(:,2)/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''go-'',counter_log,dv_log(:,3)*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000,''c^-'',counter_log,fc_max_pwr_init*ones(size(counter_log)),''b--'',counter_log,ess_module_num_init*ones(size(counter_log))/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''b--'',counter_log,mc_trq_scale_init*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000*ones(size(counter_log)),''b--'')')
   h=legend('Fuel Converter (kW)', 'Energy Storage (kW)','Motor Controller (kW)');
elseif vinf.autosize.dv(1)&vinf.autosize.dv(2)
   evalin('base','plot(counter_log,dv_log(:,1),''rx-'',counter_log,dv_log(:,2)/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''go-'',counter_log,fc_max_pwr_init*ones(size(counter_log)),''b--'',counter_log,ess_module_num_init*ones(size(counter_log))/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''b--'')')
   h=legend('Fuel Converter (kW)', 'Energy Storage (kW)');
elseif vinf.autosize.dv(2)&vinf.autosize.dv(3)
   evalin('base','plot(counter_log,dv_log(:,1)/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''rx-'',counter_log,dv_log(:,2)*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000,''go-'',counter_log,ess_module_num_init*ones(size(counter_log))/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''b--'',counter_log,mc_trq_scale_init*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000*ones(size(counter_log)),''b--'')')
   h=legend('Energy Storage (kW)','Motor Controller (kW)');
elseif vinf.autosize.dv(1)&vinf.autosize.dv(3)
   evalin('base','plot(counter_log,dv_log(:,1),''rx-'',counter_log,dv_log(:,2)*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000,''gx-'',counter_log,fc_max_pwr_init*ones(size(counter_log)),''b--'',counter_log,mc_trq_scale_init*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000*ones(size(counter_log)),''b--'')')
   h=legend('Fuel Converter (kW)','Motor Controller (kW)');
elseif vinf.autosize.dv(1)
   evalin('base','plot(counter_log,dv_log(:,1),''rx-'',counter_log,fc_max_pwr_init*ones(size(counter_log)),''b--'')')
   h=legend('Fuel Converter (kW)');
elseif vinf.autosize.dv(2)
   evalin('base','plot(counter_log,dv_log(:,1)/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''rx-'',counter_log,ess_module_num_init*ones(size(counter_log))/1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))),''b--'')');
   h=legend('Energy Storage (kW)');
elseif vinf.autosize.dv(3)
   evalin('base','plot(counter_log,dv_log(:,1)*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000,''rx-'',counter_log,mc_trq_scale_init*max(mc_map_spd.*mc_max_trq)*mc_spd_scale*mc_overtrq_factor/1000*ones(size(counter_log)),''b--'')')
   h=legend('Motor Controller (kW)');
end
set(findobj(h,'type','text'), 'FontUnits', 'points','FontSize', 10)
ylabel('Design Variables')
xlabel('Design Iteration')

% grade constraint
if vinf.autosize.constraints(1)
   subplot(2,2,2)
   evalin('base','plot(counter_log,con_log(:,1),''rx-'',counter_log,constraints(1)*ones(size(counter_log)),''b--'')')
   ylabel('Grade Constraint')
   xlabel('Design Iteration')
else
   %   text('Grade Constraint Not Enforced');
end

% accel contraints
if vinf.autosize.constraints(2)
   subplot(2,2,3)
   str=[];
   if vinf.accel_test.param.active(3)
      evalin('base','plot(counter_log,con_log(:,2),''c^-'')')
      hold on
      if units_flag
         str=[str,'''',num2str(vinf.accel_test.param.spds1(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds1(2)*units('mph2kmph')),' km/h (s)'','];
      else
         str=[str,'''',num2str(vinf.accel_test.param.spds1(1)),'-',num2str(vinf.accel_test.param.spds1(2)),' mph (s)'','];
      end
   end
   if vinf.accel_test.param.active(4)
      evalin('base','plot(counter_log,con_log(:,3),''rx-'')')
      hold on
      if units_flag
         str=[str,'''',num2str(vinf.accel_test.param.spds2(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds2(2)*units('mph2kmph')),' km/h (s)'','];
      else
         str=[str,'''',num2str(vinf.accel_test.param.spds2(1)),'-',num2str(vinf.accel_test.param.spds2(2)),' mph (s)'','];
      end
   end
   if vinf.accel_test.param.active(5)
      evalin('base','plot(counter_log,con_log(:,4),''m*-'')')
      hold on
      if units_flag
         str=[str,'''',num2str(vinf.accel_test.param.spds3(1)*units('mph2kmph')),'-',num2str(vinf.accel_test.param.spds3(2)*units('mph2kmph')),' km/h (s)'','];
      else
         str=[str,'''',num2str(vinf.accel_test.param.spds3(1)),'-',num2str(vinf.accel_test.param.spds3(2)),' mph (s)'','];
      end
   end
   if vinf.accel_test.param.active(6)
      evalin('base','plot(counter_log,con_log(:,5),''ks-'')')
      hold on
      if units_flag
         str=[str,'''Dist. in ',num2str(vinf.accel_test.param.dist_in_time),' sec. (m)'','];
      else
         str=[str,'''Dist. in ',num2str(vinf.accel_test.param.dist_in_time),' sec. (ft)'','];
      end
   end
   if vinf.accel_test.param.active(7)
      evalin('base','plot(counter_log,con_log(:,6),''gv-'')')
      hold on
      if units_flag
         str=[str,'''Time in ',num2str(vinf.accel_test.param.time_in_dist*units('mph2kmph')),' km (s)'','];
      else
         str=[str,'''Time in ',num2str(vinf.accel_test.param.time_in_dist),' mile (s)'','];
      end
   end
      if vinf.accel_test.param.active(8)
      evalin('base','plot(counter_log,con_log(:,7),''c*-'')')
      hold on
      if units_flag
         str=[str,'''Accel Rate (m/s^2)'','];
      else
         str=[str,'''Accel Rate (ft/s^2)'','];
      end
   end
      if vinf.accel_test.param.active(9)
      evalin('base','plot(counter_log,con_log(:,8),''rs-'')')
      hold on
      if units_flag
         str=[str,'''Max Speed (km/h)'','];
      else
         str=[str,'''Max Speed (mph)'','];
      end
   end

   
   if evalin('base','nnz(constraints(2:end)<0)')
      plot_constraints=evalin('base','constraints(2:end).*(constraints(2:end)>0)');
   else 
      plot_constraints=evalin('base','constraints(2:end)');
   end
   evalin('base',['plot(counter_log,meshgrid(',mat2str(plot_constraints),',counter_log''),''b--'')'])
   ylabel('Accel Constraints')
   xlabel('Design Iteration')
   eval(['h=legend(',str,'0);'])
   set(findobj(h,'type','text'), 'FontUnits', 'points','FontSize', 10)
   hold off
else
   %   text('Acceleration Constraints Not Enforced');
end

% objective function
subplot(2,2,4)
evalin('base','plot(counter_log,obj_log,''rx-'',counter_log,ones(size(counter_log)),''b--'')')
ylabel('Normalized Objective')
xlabel('Design Iteration')

return

% revision history
% 7/17/00:tm added *mc_overtrq_factor to all motor references
% 7/17/00:tm added /1000*(max(max((ess_voc.*ess_voc)./(4*ess_r_dis)))) to all ess references
% 7/17/00:tm updated ess labels
% 1/29/01:tm revised the grade and accel plots due to changes in grade and accel tests and autosize
