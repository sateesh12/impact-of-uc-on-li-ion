function plot_emis_map(emis_type, map_type)
%emis_type = CO, HC, NOx, or PM
%map_type='cold map', 'hot map', or 'cold2hot map'

switch map_type
case 'cold map'
   if evalin('base','exist(''fc_fuel_cell_model'')')  % vehicle uses a  fuel cell
      if evalin('base',['fc_fuel_cell_model~=3&exist(''fc_' lower(emis_type) '_map_cold'')&nnz(fc_' lower(emis_type) '_map_cold)>0'])
         if evalin('base','fc_fuel_cell_model==2')
            if evalin('base',['exist(''fc_' lower(emis_type) '_map_cold_gpkWh'])
               %plot gpkwh vs. power curve
               evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_cold_gpkWh,''k-'')'])
               %add labels to the plot
               xlabel('Power (kW)')
               ylabel([emis_type ' Emissions Cold (g/kWh)'])
            else
               %plot g/s vs. power curve
               evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_cold,''k-'')'])
               %add labels to the plot
               xlabel('Power (kW)')
               ylabel([emis_type ' Emissions Cold (g/s)'])
            end
         elseif evalin('base','fc_fuel_cell_model==1')
            %plot gpkwh vs. power curve
            evalin('base',['plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_cold./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,''k-'')'])
            %add labels to the plot
            xlabel('Power (kW)')
            ylabel([emis_type ' Emissions Cold (g/kWh)'])
         end
      else 
         xlim([0 1]);
         ylim([0 1]);
         text(.5,.5,'Not Available');
      end
   elseif evalin('base','exist(''fc_map_spd'')') % not a fuel cell vehicle
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      if evalin('base',['exist(''fc_' lower(emis_type) '_map_cold'')&nnz(fc_' lower(emis_type) '_map_cold)>0'])
         hold on
         evalin('base','plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,''kx-'')')
         
         %calculate cold map in gpkWh
         [T,w]=meshgrid(evalin('base','fc_map_trq'), evalin('base','fc_map_spd'));
         fc_map_kW=T.*w/1000;
         fc_emis_map_cold_gpkWh=evalin('base',['fc_' lower(emis_type) '_map_cold'])./fc_map_kW*3600;
         assignin('base',['fc_' lower(emis_type) '_map_cold_gpkWh'] , fc_emis_map_cold_gpkWh);
         
         
         if evalin('base',['exist(''fc_' lower(emis_type) '_map_cold_gpkWh'')'])
            evalin('base',['value_median=median(median(fc_' lower(emis_type) '_map_cold_gpkWh));'])
            evalin('base',['value_min=min(min(fc_' lower(emis_type) '_map_cold_gpkWh));'])
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_' lower(emis_type) '_map_cold_gpkWh'',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);'])
            evalin('base','clear value_median value_min')
         else
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_' lower(emis_type) '_map_cold'');'])
         end
         evalin('base','clabel(c)')
      else
         xlim([0 1]);
         ylim([0 1]);
         text(.5,.5,'Not Available');
      end
   else
      xlim([0 1]);
      ylim([0 1]);
      text(.5,.5,'Not Available');
   end
   %title
   if evalin('base','~exist(''fc_description'')')
      evalin('base','fc_description='' '';')
   end
   if evalin('base','exist(''fc_co_map_cold_gpkWh'')')
      evalin('base',['str=''Brake Specifc ' emis_type ' Emissions Cold (g/kWh) - '';'])
   else      
      evalin('base',['str=''Engine Out ' emis_type ' Emissions Map Cold (g/s) - '';'])
   end      
   if evalin('base','length([str,fc_description])>60')
      evalin('base','ttl={str;fc_description};')
      evalin('base','title(ttl,''Fontsize'',7)')
   else
      evalin('base','title([str,fc_description])')
   end
   set(gca,'tag','input_axes');
   hold off
   
case 'cold2hot map'
   if evalin('base','exist(''fc_fuel_cell_model'')')  % vehicle uses a  fuel cell
      if evalin('base',['fc_fuel_cell_model~=3&exist(''fc_' lower(emis_type) '_map_c2h'')&nnz(fc_' lower(emis_type) '_map_c2h)>0'])
         if evalin('base','fc_fuel_cell_model==2')
            if evalin('base',['exist(''fc_' lower(emis_type) '_map_c2h_gpkWh'])
               %plot gpkwh vs. power curve
               evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_c2h_gpkWh,''k-'')'])
               %add labels to the plot
               xlabel('Power (kW)')
               ylabel([emis_type ' Emissions Cold/Hot ratio'])
            else
               %plot g/s vs. power curve
               evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_c2h,''k-'')'])
               %add labels to the plot
               xlabel('Power (kW)')
               ylabel([emis_type ' Emissions Cold/Hot ratio'])
            end
         elseif evalin('base','fc_fuel_cell_model==1')
            %plot gpkwh vs. power curve
            evalin('base',['plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_' lower(emis_type) '_map_c2h./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,''k-'')'])
            %add labels to the plot
            xlabel('Power (kW)')
            ylabel([emis_type ' Emissions Cold/Hot ratio'])
         end
      else 
         xlim([0 1]);
         ylim([0 1]);
         text(.5,.5,'Not Available');
      end
   elseif evalin('base','exist(''fc_map_spd'')') % not a fuel cell vehicle
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      if evalin('base',['exist(''fc_' lower(emis_type) '_map_c2h'')&nnz(fc_' lower(emis_type) '_map_c2h)>0'])
         hold on
         evalin('base','plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,''kx-'')')
         if evalin('base',['exist(''fc_' lower(emis_type) '_map_c2h_gpkWh'')'])
            evalin('base',['value_median=median(median(fc_' lower(emis_type) '_map_c2h_gpkWh));'])
            evalin('base',['value_min=min(min(fc_' lower(emis_type) '_map_c2h_gpkWh));'])
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_' lower(emis_type) '_map_c2h_gpkWh'',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);'])
            evalin('base','clear value_median value_min')
         else
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_' lower(emis_type) '_map_c2h'');'])
         end
         evalin('base','clabel(c)')
      else
         xlim([0 1]);
         ylim([0 1]);
         text(.5,.5,'Not Available');
      end
   else
      xlim([0 1]);
      ylim([0 1]);
      text(.5,.5,'Not Available');
   end
   %title
   if evalin('base','~exist(''fc_description'')')
      evalin('base','fc_description='' '';')
   end
   if evalin('base','exist(''fc_co_map_c2h_gpkWh'')')
      evalin('base',['str=''Brake Specifc ' emis_type ' Emissions Cold/Hot ratio - '';'])
   else      
      evalin('base',['str=''Engine Out ' emis_type ' Emissions Map Cold/Hot ratio - '';'])
   end      
   if evalin('base','length([str,fc_description])>60')
      evalin('base','ttl={str;fc_description};')
      evalin('base','title(ttl,''Fontsize'',7)')
   else
      evalin('base','title([str,fc_description])')
   end
   set(gca,'tag','input_axes');
   hold off
   
otherwise
end

% 2/9/01 ss: added calculations for gpkWh maps