function plot_fuel_map(map_type)
%map_type='cold map', or 'cold2hot map'

switch map_type
case 'cold map'
    type='cold';
    
    if evalin('base','exist(''fc_map_spd'')') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        %%%%%% plot fuel use map and torque envelope
        hold on
        evalin('base','plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,''kx-'')')
        
        %calculate cold map in gpkWh
        [T,w]=meshgrid(evalin('base','fc_map_trq'), evalin('base','fc_map_spd'));
        fc_map_kW=T.*w/1000;
        fc_fuel_map_cold_gpkWh=evalin('base',['fc_fuel_map_' lower(type)])./fc_map_kW*3600;
        assignin('base',['fc_fuel_map_' lower(type) '_gpkWh'] , fc_fuel_map_cold_gpkWh);
    
        if evalin('base',['exist(''fc_fuel_map_' type '_gpkWh'')']) & ~isempty(evalin('base',['find(fc_fuel_map_' type '_gpkWh>0)'] ))
            evalin('base',['value_median=median(median(fc_fuel_map_' type '_gpkWh));'])
            evalin('base',['value_min=min(min(fc_fuel_map_' type '_gpkWh));'])
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_fuel_map_' type '_gpkWh'',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);'])
            %evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_fuel_map_' type '_gpkWh'');'])
            evalin('base','clear value_median value_min')
            evalin('base','clabel(c)')
        else
            text_x=mean(get(gca, 'xlim'));
            text_y=mean(get(gca,'ylim'));
            text(text_x,text_y,'Not Available');
        end
        
    elseif evalin('base','exist(''fc_fuel_cell_model'')')  % vehicle uses a  fuel cell
        if evalin('base','fc_fuel_cell_model==1')
            % create fuel consumption map (g/kWh)
            evalin('base',['fc_fuel_map_gpkWh=(1./(fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map_' type './fc_fuel_lhv)./fc_fuel_lhv*3600*1000);']) % used in gui_inpchk plots
            %plot efficiency vs. power curve
            evalin('base' ,['plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_' type '_gpkWh,''k-'')'])
        elseif evalin('base','fc_fuel_cell_model==2')
            %plot efficiency vs. power curve
            evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_' type '_gpkWh,''k-'')'])
        elseif evalin('base','fc_fuel_cell_model==3')
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
        %add labels to the plot
        xlabel('Power (kW)')
        if strcmp(type,'cold')
            ylabel('Fuel Consumption Cold (g/kWh)')
        elseif strcmp(type,'c2h')
            ylabel('Fuel Consumption Cold/Hot ratio')
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
    
    evalin('base','str=''Brake Specific Fuel Consumption Cold (g/kWh) - '';')
    
    if evalin('base','length([str,fc_description])>60')
        evalin('base','ttl={str;fc_description};')
        evalin('base','title(ttl,''Fontsize'',7)')
    else
        evalin('base','title([str,fc_description])')
    end
    set(gca,'tag','input_axes');
    hold off
    
case 'cold2hot map'
    type='c2h';
    
    if evalin('base','exist(''fc_map_spd'')') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        %%%%%% plot fuel use map and torque envelope
        hold on
        evalin('base','plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,''kx-'')')
        if evalin('base',['exist(''fc_fuel_map_' type ''')']) & evalin('base',['nnz(fc_fuel_map_' type ')'])
            evalin('base',['value_median=median(median(fc_fuel_map_' type '));'])
            evalin('base',['value_min=min(min(fc_fuel_map_' type '));'])
            evalin('base',['c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_fuel_map_' type ''',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);'])
            evalin('base','clear value_median value_min')
            evalin('base','clabel(c)')
        else
            text_x=mean(get(gca, 'xlim'));
            text_y=mean(get(gca,'ylim'));
            text(text_x,text_y,'Not Available');
        end
        
    elseif evalin('base','exist(''fc_fuel_cell_model'')')  % vehicle uses a  fuel cell
        if evalin('base','fc_fuel_cell_model==1')
            % create fuel consumption map (g/kWh)
            evalin('base',['fc_fuel_map_gpkWh=(1./(fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map' type './fc_fuel_lhv)./fc_fuel_lhv*3600*1000);']) % used in gui_inpchk plots
            %plot efficiency vs. power curve
            evalin('base' ,['plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_' type '_gpkWh,''k-'')'])
        elseif evalin('base','fc_fuel_cell_model==2')
            %plot efficiency vs. power curve
            evalin('base',['plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_' type '_gpkWh,''k-'')'])
        elseif evalin('base','fc_fuel_cell_model==3')
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
        %add labels to the plot
        xlabel('Power (kW)')
        if strcmp(type,'cold')
            ylabel('Fuel Consumption Cold (g/kWh)')
        elseif strcmp(type,'c2h')
            ylabel('Fuel Consumption Cold/Hot ratio')
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
 
    evalin('base','str=''Fuel Consumption Cold/Hot Ratio - '';')
    
    if evalin('base','length([str,fc_description])>60')
        evalin('base','ttl={str;fc_description};')
        evalin('base','title(ttl,''Fontsize'',7)')
    else
        evalin('base','title([str,fc_description])')
    end
    set(gca,'tag','input_axes');
    hold off
    
end; %switch map_type

% 2/8/01 ss: updated cold2hot case