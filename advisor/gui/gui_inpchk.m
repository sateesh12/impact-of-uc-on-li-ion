% gui_inpchk.m
% Displays labelled fuel converter and/or motor efficiency map(s) and
% battery information.
% input_plot_name='fc_efficiency' or 'fc_fuel_use',etc
% these should already be initialized from the file
% Also, this file sets the block diagram name on the input figure.


%make sure current plot is ok 
compname=gui_current_str('input_plots_components');
short_compname=compo_name(compname);
str=['vinf.' compname];
if eval(['isfield(', str , ',''ver'')'])
    ver=eval(['vinf.' compname '.ver']);
    ver_index=strmatch(ver,optionlist('get',[short_compname '_ver'],''));
    input_plots=optionlist('get',[short_compname '_plot']);
    if iscell(input_plots{1})
        input_plots=input_plots{ver_index};
    end
else
    input_plots=optionlist('get',[short_compname '_plot']);
end

input_plot_name=gui_current_str('input_plots');

if isempty(strmatch(input_plot_name,input_plots,'exact'));
    set(findobj('tag','input_plots'),'string',input_plots,'value',1)
    input_plot_name=input_plots{1};
end

%make the input axes the current axes
axes(findobj('tag','input_axes'))

%clear the axes
delete(get(findobj('tag','input_axes'),'children'));%clear  the axes
set(findobj('tag','input_axes'),'xlimMode','auto','ylimMode','auto')

switch input_plot_name
    
case 'fc_efficiency'   
    if exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Torque (Nm)')
        xlabel('Speed (rpm)')
        %%%%%% compute efficiency map ----------------
        trq=[];
        for x=1:length(fc_map_trq)
            if fc_map_trq(x)>0
                trq=[trq fc_map_trq(x)];
            end;
        end;
        spd=[];
        for x=1:length(fc_map_spd)
            if fc_map_spd(x)>0
                spd=[spd fc_map_spd(x)];
            end;
        end;
        diff_trq=length(fc_map_trq)-length(trq);
        diff_spd=length(fc_map_spd)-length(spd);
        [T,w]=meshgrid(trq,spd);
        fc_map_kW=T.*w/1000;
        fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),...
            diff_trq+1:length(fc_map_trq))*fc_fuel_lhv);
        %%%%%% plot efficiency map and torque envelope
        hold on
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
        c=contour(spd*30/pi*fc_spd_scale,trq*fc_trq_scale,(fc_eff_map*fc_eff_scale)');
        clabel(c)
        clear spd trq diff_spd diff_trq
    elseif strcmp(vinf.fuel_converter.ver,'fcell')%exist('fc_fuel_cell_model')  % vehicle uses a fuel cell
        if strcmp(vinf.fuel_converter.type,'polar')%evalin('base','fc_fuel_cell_model')==1;
            %plot efficiency vs. power curve
            if exist('fc_eff_map')
                plot(fc_pwr_map*fc_pwr_scale/1000,fc_eff_map*fc_eff_scale*100,'k-')
            else
                plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map/fc_fuel_lhv*fc_eff_scale*100,'k-')
            end
        elseif strcmp(vinf.fuel_converter.type,'net')%evalin('base','fc_fuel_cell_model')==2;
            %plot efficiency vs. power curve
            plot(fc_pwr_map*fc_pwr_scale/1000,fc_pwr_map./fc_fuel_map./fc_fuel_lhv*fc_eff_scale*100,'k-')
            
        elseif strcmp(vinf.fuel_converter.type,'VT')%evalin('base','fc_fuel_cell_model')==3;
            if ~exist('fc_plot_pwr_map')
                fc_plot_pwr_map=[fc_min_cell_volts*fc_cell_num*fc_cell_area*0.6/20:fc_min_cell_volts*fc_cell_num*fc_cell_area*0.6/20:fc_min_cell_volts*fc_cell_num*fc_cell_area*0.6];
            end
            
            if ~exist('fc_plot_tmp_map')
                fc_plot_tmp_map=[20:20:80];
            end
            
            [eta,pwr,tmp,volts,crrnt]=build_fc_eff_curve(fc_plot_pwr_map,fc_plot_tmp_map);
            
            % store results for later use
            vinf.fuel_converter.eta_map=eta(:,end)
            vinf.fuel_converter.pwr_map=pwr(:,end)
            vinf.fuel_converter.crrnt_map=crrnt(:,end)
            vinf.fuel_converter.voltage_map=volts(:,end)
            vinf.fuel_converter.temp_map=tmp(:,end)
            
            linecolor={'b','r','g','m','c','y'};
            legend_str='legend(';
            
            for i=1:length(tmp) 
                hold on;
                plot(pwr(:,i)/1000,eta(:,i)*100,['',linecolor{rem(i-1,length(linecolor))+1},'-'])
                legend_str=[legend_str,'''',mat2str(tmp(i)),''','];
            end
            
            legend_str=[legend_str,'0)'];
            eval(legend_str)
            
            clear legend_str i pwr eta tmp
        elseif strcmp(vinf.fuel_converter.type,'KTH')
            
            [eta,pwr_map]=build_fc_eff_curve_KTH(fc_cell_stack_N);
            
            
            plot(pwr_map/1000,eta*100)
            
            
            clear pwr_map eta 
            
            
        elseif strcmp(vinf.fuel_converter.type,'gctool')%evalin('base','fc_fuel_cell_model')==4;
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
        %add labels to the plot
        xlabel('Power (kW)')
        ylabel('Efficiency (%)')
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end
    % title
    if ~exist('fc_description')
        fc_description=' ';
    end
    if length(['Fuel Converter Operation - ',fc_description])>60
        ttl={'Fuel Converter Operation';fc_description};
        title(ttl,'Fontsize',7)
    else
        title(['Fuel Converter Operation - ',fc_description])
    end
    hold off
    set(gca,'tag','input_axes');
    
case 'fc_fuel_use_cold2hot'
    plot_fuel_map('cold2hot map')
case 'fc_fuel_use_cold'
    plot_fuel_map('cold map')
    
case 'fc_fuel_use_hot'   
    if exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        %%%%%% plot fuel use map and torque envelope
        hold on
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
        if exist('fc_fuel_map_gpkWh')
            value_median=median(median(fc_fuel_map_gpkWh));
            value_min=min(min(fc_fuel_map_gpkWh));
            c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,(fc_fuel_map_gpkWh/fc_eff_scale)',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);
            clear value_median value_min
        end
        clabel(c)
    elseif exist('fc_fuel_cell_model')  % vehicle uses a  fuel cell
        if fc_fuel_cell_model==1
            % create fuel consumption map (g/kWh)
            fc_fuel_map_gpkWh=(1./(fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map./fc_fuel_lhv)./fc_fuel_lhv*3600*1000); % used in gui_inpchk plots
            %plot efficiency vs. power curve
            plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_gpkWh,'k-')
        elseif fc_fuel_cell_model==2
            %plot efficiency vs. power curve
            plot(fc_pwr_map*fc_pwr_scale/1000,fc_fuel_map_gpkWh,'k-')
        elseif fc_fuel_cell_model==3
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        elseif fc_fuel_cell_model==4
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
        %add labels to the plot
        xlabel('Power (kW)')
        ylabel('Fuel Consumption (g/kWh)')
        
    else 
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end
    %title
    if ~exist('fc_description')
        fc_description=' ';
    end
    str='Brake Specific Fuel Consumption (g/kWh) - ';
    if length([str,fc_description])>60
        ttl={str;fc_description};
        title(ttl,'Fontsize',7)
    else
        title([str,fc_description])
    end
    set(gca,'tag','input_axes');
    hold off
    
    
    %cold emissions plots   
case 'fc_emissions_cold_CO'
    plot_emis_map('CO','cold map')
case 'fc_emissions_cold_HC'
    plot_emis_map('HC','cold map')
case 'fc_emissions_cold_NOx'
    plot_emis_map('NOx','cold map')
case 'fc_emissions_cold_PM'
    plot_emis_map('PM','cold map')
    
    %cold2hot emissions plots   
case 'fc_cold2hot_ratio_CO'
    plot_emis_map('CO','cold2hot map')
case 'fc_cold2hot_ratio_HC'
    plot_emis_map('HC','cold2hot map')
case 'fc_cold2hot_ratio_NOx'
    plot_emis_map('NOx','cold2hot map')
case 'fc_cold2hot_ratio_PM'
    plot_emis_map('PM','cold2hot map')
    
    
    
    
case 'fc_emissions_hot_CO'
    %%%%%% plot engine out CO emissions map and torque envelope
    if exist('fc_fuel_cell_model')  % vehicle uses a  fuel cell
        if fc_fuel_cell_model~=3&exist('fc_co_map')&nnz(fc_co_map)>0
            if fc_fuel_cell_model==2
                if exist('fc_co_map_gpkWh')
                    %plot gpkwh vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_co_map_gpkWh,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('CO Emissions (g/kWh)')
                else
                    %plot g/s vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_co_map,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('CO Emissions (g/s)')
                end
            elseif fc_fuel_cell_model==1
                %plot gpkwh vs. power curve
                plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_co_map./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,'k-')
                %add labels to the plot
                xlabel('Power (kW)')
                ylabel('CO Emissions (g/kWh)')
            end
        else 
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
    elseif exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        if exist('fc_co_map')&nnz(fc_co_map)>0
            hold on
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
            if exist('fc_co_map_gpkWh')
                value_median=median(median(fc_co_map_gpkWh));
                value_min=min(min(fc_co_map_gpkWh));
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_co_map_gpkWh',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);
                clear value_median value_min
            else
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_co_map');
            end
            clabel(c)
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
    if ~exist('fc_description')
        fc_description=' ';
    end
    if exist('fc_co_map_gpkWh')
        str='Brake Specifc CO Emissions (g/kWh) - ';
    else      
        str='Engine Out CO Emissions Map (g/s) - ';
    end      
    if length([str,fc_description])>60
        ttl={str;fc_description};
        title(ttl,'Fontsize',7)
    else
        title([str,fc_description])
    end
    set(gca,'tag','input_axes');
    hold off
    
case 'fc_emissions_hot_HC'
    %%%%%% plot engine out HC emissions map and torque envelope
    if exist('fc_fuel_cell_model')  % vehicle uses a  fuel cell
        if fc_fuel_cell_model~=3&exist('fc_hc_map')&nnz(fc_hc_map)>0
            if fc_fuel_cell_model==2
                if exist('fc_hc_map_gpkWh')
                    %plot gpkwh vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_hc_map_gpkWh,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('HC Emissions (g/kWh)')
                else
                    %plot g/s vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_hc_map,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('HC Emissions (g/s)')
                end
            elseif fc_fuel_cell_model==1
                %plot gpkwh vs. power curve
                plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_hc_map./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,'k-')
                %add labels to the plot
                xlabel('Power (kW)')
                ylabel('HC Emissions (g/kWh)')
            end
        else 
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
    elseif exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        if exist('fc_hc_map')&nnz(fc_hc_map)>0
            hold on
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
            if exist('fc_hc_map_gpkWh')
                value_median=median(median(fc_hc_map_gpkWh));
                value_min=min(min(fc_hc_map_gpkWh));
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_hc_map_gpkWh',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);
                clear value_median value_min
            else
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_hc_map');
            end
            clabel(c)
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
    % title
    if ~exist('fc_description')
        fc_description=' ';
    end;
    if exist('fc_hc_map_gpkWh')
        str='Brake Specifc HC Emissions (g/kWh) - ';
    else
        str='Engine Out HC Emissions Map (g/s) - ';
    end
    if length([str,fc_description])>60
        ttl={str;fc_description};
        title(ttl,'Fontsize',7)
    else
        title([str,fc_description])
    end
    set(gca,'tag','input_axes');
    hold off
    
case 'fc_emissions_hot_NOx'
    %%%%%% plot engine out NOx emissions map and torque envelope
    if exist('fc_fuel_cell_model')  % vehicle uses a  fuel cell
        if fc_fuel_cell_model~=3&exist('fc_nox_map')&nnz(fc_nox_map)>0
            if fc_fuel_cell_model==2
                if exist('fc_nox_map_gpkWh')
                    %plot gpkwh vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_nox_map_gpkWh,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('NOx Emissions (g/kWh)')
                else
                    %plot g/s vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_nox_map,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('NOx Emissions (g/s)')
                end
            elseif fc_fuel_cell_model==1
                %plot gpkwh vs. power curve
                plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_nox_map./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,'k-')
                %add labels to the plot
                xlabel('Power (kW)')
                ylabel('NOx Emissions (g/kWh)')
            end
        else 
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
    elseif exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        if exist('fc_nox_map')&nnz(fc_nox_map)>0
            hold on
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
            if exist('fc_nox_map_gpkWh')
                value_median=median(median(fc_nox_map_gpkWh));
                value_min=min(min(fc_nox_map_gpkWh));
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_nox_map_gpkWh',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);
                clear value_median value_min
            else
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_nox_map');
            end
            clabel(c)
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
    % title
    if ~exist('fc_description')
        fc_description=' ';
    end;
    if exist('fc_nox_map_gpkWh')
        str='Brake Specific NOx Emissions (g/kWh) - ';
    else
        str='Engine Out NOx Emissions Map (g/s) - ';
    end
    if length([str,fc_description])>60
        ttl={str;fc_description};
        title(ttl,'Fontsize',7)
    else
        title([str,fc_description])
    end
    set(gca,'tag','input_axes');
    hold off
    clear value_min value_median value_max
    
case 'fc_emissions_hot_PM'
    %%%%%% plot engine out PM emissions map and torque envelope
    if exist('fc_fuel_cell_model')  % vehicle uses a  fuel cell
        if fc_fuel_cell_model~=3&exist('fc_pm_map')&nnz(fc_pm_map)>0
            if fc_fuel_cell_model==2
                if exist('fc_pm_map_gpkWh')
                    %plot gpkwh vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_pm_map_gpkWh,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('PM Emissions (g/kWh)')
                else
                    %plot g/s vs. power curve
                    plot(fc_pwr_map*fc_pwr_scale/1000,fc_pm_map,'k-')
                    %add labels to the plot
                    xlabel('Power (kW)')
                    ylabel('PM Emissions (g/s)')
                end
            elseif fc_fuel_cell_model==1
                %plot gpkwh vs. power curve
                plot(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale/1000,fc_pm_map./(fc_I_map.*fc_V_map*fc_cell_area*fc_cell_num/1000)*3600,'k-')
                %add labels to the plot
                xlabel('Power (kW)')
                ylabel('PM Emissions (g/kWh)')
            end
        else 
            xlim([0 1]);
            ylim([0 1]);
            text(.5,.5,'Not Available');
        end
    elseif exist('fc_map_spd') % not a fuel cell vehicle
        ylabel('Engine Torque (Nm)')
        xlabel('Engine Speed (rpm)')
        if exist('fc_pm_map')&nnz(fc_pm_map)>0
            hold on
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
            if exist('fc_pm_map_gpkWh')
                value_median=median(median(fc_pm_map_gpkWh));
                value_min=min(min(fc_pm_map_gpkWh));
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_pm_map_gpkWh',[[0:.4:2]*(value_median-value_min)+value_min*1.01]);
                clear value_median value_min
            else
                c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_pm_map');
            end
            clabel(c)
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
    % title
    if ~exist('fc_description')
        fc_description=' ';
    end;
    if exist('fc_pm_map_gpkWh')
        str='Brake Specific PM Emissions (g/kWh) - ';
    else
        str='Engine Out PM Emissions Map (g/s) - ';
    end
    if length([str,fc_description])>60
        ttl={str;fc_description};
        title(ttl,'Fontsize',7)
    else
        title([str,fc_description])
    end
    set(gca,'tag','input_axes');
    hold off
    
case 'mc_efficiency'
    %%%%%% motor map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ylabel('Motor Torque (Nm)')
    xlabel('Motor Speed (rpm)')
    
    %title
    if ~exist('mc_description')
        mc_description=' ';
    end
    if length(['Motor/Inverter Efficiency and Continuous Torque Capability - ',mc_description])>60
        ttl={'Motor/Inverter Efficiency and Continuous Torque Capability - ';mc_description};
        title(ttl,'Fontsize',7)
    else
        title(['Motor/Inverter Efficiency and Continuous Torque Capability - ',mc_description])
    end;
    
    if exist('mc_eff_map') | exist('mc_inpwr_map')
        %%%%%% compute efficiency map ----------------
        if ~exist('mc_eff_map')
            [T,w]=meshgrid(mc_map_trq,mc_map_spd);
            outpwr=T.*w*mc_trq_scale*mc_spd_scale;
            mc_eff_map_pos=outpwr./(mc_inpwr_map+eps).*(mc_inpwr_map>0);
            mc_eff_map_neg=mc_inpwr_map./(outpwr+eps).*(outpwr~=0);
            mc_eff_map=mc_eff_map_pos+mc_eff_map_neg;
        end
        %%%%%% plot efficiency map and torque envelope
        hold on
        plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale,'k-')
        plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale,'kx')
        c=contour(mc_map_spd*30/pi*mc_spd_scale,mc_map_trq*mc_trq_scale,(mc_eff_map*mc_eff_scale)');
        clabel(c)
    else 
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end
    set(gca,'tag','input_axes');
    hold off
    
case 'ess Voc'   
    ylabel('Voltage, volts');
    xlabel ('State of Charge, (0-1)');
    
    %title
    if ~exist('ess_description')
        ess_description=' ';
    end
    if length(['Battery Open Ciruit Voltage: ',ess_description])>60
        ttl={'Battery Open Ciruit Voltage: ';ess_description};
        title(ttl,'Fontsize',7)
    else
        title(['Battery Open Ciruit Voltage: ',ess_description])
    end
    
    %%%%%% plot open circuit voltage
    if exist('ess_voc')&exist('ess_soc')
        hold on
        plot(ess_soc,ess_voc);
        str=[];
        for i=1:length(ess_tmp)
            str=[str,'''',num2str(ess_tmp(i)),'C'','];
        end
        eval(['legend(',str,'0)']);
        clear str i
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end	
    set(gca,'tag','input_axes');
    hold off
    
case 'ess Rint'   
    ylabel('Resistance, Ohms');
    xlabel('State Of Charge, (0-1)');
    
    %title
    if ~exist('ess_description')
        ess_description=' ';
    end
    if length(['Battery Resistance: ',ess_description])>60
        ttl={'Battery Resistance: ';ess_description};
        title(ttl,'Fontsize',7)
    else
        title(['Battery Resistance: ',ess_description])
    end
    
    %%%%%% plot open circuit voltage
    if exist('ess_r_dis')&exist('ess_soc')
        hold on
        plot(ess_soc',[ess_r_dis' ess_r_chg']*ess_res_scale_fun(ess_res_scale_coef,1,ess_cap_scale));
        str=[];
        for i=1:length(ess_tmp)
            str=[str,'''',num2str(ess_tmp(i)),'C Discharge'','];
        end
        for i=1:length(ess_tmp)
            str=[str,'''',num2str(ess_tmp(i)),'C Charge'','];
        end
        eval(['legend(',str,'0)']);
        clear str i
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end	
    set(gca,'tag','input_axes');
    hold off
    
case 'upshift table'   
    xlabel('Output shaft speed (RPM)');
    ylabel('Throttle position (fraction of max trq)');
    title('Upshift Table');
    %%%%%% upshift table
    %if ~strcmp(vinf.transmission.name,'TX_CVT')
    %try
    if ~((exist('gb_map1_spd')&exist('gb_map1_trq'))|(exist('tx_pg_s')&exist('tx_pg_r'))|exist('fc_fuel_cell_model'))&~strcmp(vinf.drivetrain.name,'ev') % not PRIUS_CVT or CVT or EV
        hold on
        %   plot(gb_gear1_upshift_spd*30/pi,gb_gear1_upshift_load,...
        %      gb_gear2_upshift_spd*30/pi,gb_gear2_upshift_load,...
        %      gb_gear3_upshift_spd*30/pi,gb_gear3_upshift_load,...
        %      gb_gear4_upshift_spd*30/pi,gb_gear4_upshift_load);
        %   legend('1->2','2->3','3->4','4->5');
        %else
        %catch
        %%%%%% plot upshift table
        if exist('gb_upshift_spd')
            line_type={'y:','m:','r:','g:','c:'};
            str=[];
            for i=1:length(gb_upshift_spd)-1
                plot(gb_upshift_spd{i}*30/pi, gb_upshift_load{i},line_type{rem(i-1,length(line_type))+1})
                str=[str,'''',num2str(i),'->',num2str(i+1),''','];
            end
        end
        eval(['legend(',str,'0)'])
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end	
    set(gca,'tag','input_axes');
    hold off
    
case 'downshift table'   
    xlabel('Fuel Converter Speed (RPM)');
    ylabel('Throttle position (fraction of max trq)');
    title('Downshift Table');
    %%%%%% plot downshift table
    %if ~strcmp(vinf.transmission.name,'TX_CVT')
    %try
    if ~((exist('gb_map1_spd')&exist('gb_map1_trq'))|(exist('tx_pg_s')&exist('tx_pg_r'))|exist('fc_fuel_cell_model'))&~strcmp(vinf.drivetrain.name,'ev') % not PRIUS_CVT or CVT or EV
        %%%%%% plot downshift table
        if exist('gb_dnshift_spd')
            line_type={'y--','m--','r--','g--','c--'};
            str=[];
            hold on
            for i=2:length(gb_dnshift_spd)
                plot(gb_dnshift_spd{i}*30/pi, gb_dnshift_load{i},line_type{rem(i-1,length(line_type))+1})
                str=[str,'''',num2str(i),'->',num2str(i-1),''','];
            end
        end
        eval(['legend(',str,'0)'])
        %plot(gb_gear2_dnshift_spd*30/pi,gb_gear2_dnshift_load,...
        %   gb_gear3_dnshift_spd*30/pi,gb_gear3_dnshift_load,...
        %   gb_gear4_dnshift_spd*30/pi,gb_gear4_dnshift_load,...
        %   gb_gear5_dnshift_spd*30/pi,gb_gear5_dnshift_load);
        %legend('2->1','3->2','4->3','5->4');
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end	
    set(gca,'tag','input_axes');
    hold off
    
case 'shift table'   
    xlabel('Fuel Converter Speed (RPM)');
    %ylabel('Throttle position (fraction of max trq)');
    ylabel('Fuel Converter Torque (Nm)');
    title('Shift Table');
    hold on
    if ~((exist('gb_map1_spd')&exist('gb_map1_trq'))|(exist('tx_pg_s')&exist('tx_pg_r'))|exist('fc_fuel_cell_model'))&~strcmp(vinf.drivetrain.name,'ev') % not PRIUS_CVT or CVT or EV
        %%%%%% plot downshift table
        if exist('gb_dnshift_spd')
            line_type={'y--','m--','r--','g--','c--'};
            str=[];
            for i=2:length(gb_dnshift_spd)
                plot(gb_dnshift_spd{i}*30/pi, gb_dnshift_load{i}.*interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,gb_dnshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
                str=[str,'''',num2str(i),'->',num2str(i-1),''','];
            end
        end
        eval(['legend(',str,'0)'])
        
        %%%%%% plot upshift table
        if exist('gb_upshift_spd')
            line_type={'y:','m:','r:','g:','c:'};
            %str=[];
            for i=1:length(gb_upshift_spd)-1
                plot(gb_upshift_spd{i}*30/pi, gb_upshift_load{i}.*interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,gb_upshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
                str=[str,'''',num2str(i),'->',num2str(i+1),''','];
            end
        end
        eval(['legend(',str,'0)'])
        
        %%%%%plot efficieny contours
        trq=[];
        for x=1:length(fc_map_trq)
            if fc_map_trq(x)>0
                trq=[trq fc_map_trq(x)];
            end;
        end;
        spd=[];
        for x=1:length(fc_map_spd)
            if fc_map_spd(x)>0
                spd=[spd fc_map_spd(x)];
            end;
        end;
        diff_trq=length(fc_map_trq)-length(trq);
        diff_spd=length(fc_map_spd)-length(spd);
        [T,w]=meshgrid(trq,spd);
        fc_map_kW=T.*w/1000;
        fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),...
            diff_trq+1:length(fc_map_trq))*fc_fuel_lhv);
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx')
        c=contour(spd*30/pi*fc_spd_scale,trq*fc_trq_scale,(fc_eff_map*fc_eff_scale)');
        clabel(c)
        clear spd trq diff_spd diff_trq
    else
        xlim([0 1]);
        ylim([0 1]);
        text(.5,.5,'Not Available');
    end	
    set(gca,'tag','input_axes');
    hold off
    
case 'ess_rt_eff'
    %v=max(max(0.5*ess_voc,mc_min_volts/ess_module_num),max(0.5*ess_voc,ess_min_volts));
    v=max(0.5*ess_voc,ess_min_volts);
    ess_pwr=max(((ess_voc-v).*v)./(ess_r_dis*ess_res_scale_fun(ess_res_scale_coef,1,ess_cap_scale)),0);
    i=ess_pwr./v;
    max_crrnt=max(max(i));
    
    % define discharge times
    time_vec=[1/60 1/30 1/20 1/15 1/10 1/5 1/2 1 2 5 10 15 20 40]; % define time vector (hr)
    
    % limit time vector to possible currents
    t_index=find((time_vec<=(max(ess_max_ah_cap*ess_cap_scale)*4))&(time_vec>=(min(ess_max_ah_cap*ess_cap_scale)/max_crrnt)));
    time_vec=time_vec(t_index);
    
    % calculate round trip efficiency
    for y=1:length(ess_tmp)
        for x=1:length(time_vec)
            eta_rt(:,x,y)=(ess_voc(y,:)...
                -ess_max_ah_cap(y)*ess_cap_scale/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_dis(y,:)*ess_res_scale_fun(ess_res_scale_coef,1,ess_cap_scale))./(ess_voc(y,:)...
                +ess_max_ah_cap(y)*ess_cap_scale/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_chg(y,:)*ess_res_scale_fun(ess_res_scale_coef,1,ess_cap_scale))*ess_coulombic_eff(y);
        end
    end
    
    % plot results
    %for i=1:length(ess_tmp)
    for i=round(length(ess_tmp)/2):round(length(ess_tmp)/2)
        %figure
        hold on
        c=contour(ess_soc,ess_max_ah_cap(i)*ess_cap_scale./time_vec,eta_rt(:,:,i)',[0.3:0.1:0.8 0.85:0.05:1.0]);
        clabel(c)
        xlabel('State of Charge (--)')
        ylabel('Current (amps)')
        h=title({['Isothermal Roundtrip Efficiency at ',num2str(ess_tmp(i),3),' C'];ess_description});
        set(h,'FontSize',7)
        %set(gcf,'NumberTitle','off','Name',['ESS Eff. at ',num2str(ess_tmp(i),3),' C'])
    end
    
    clear time_vec mc_crrnt gc_crrnt eta_rt t_index x y i c max_crrnt
    hold off
    set(gca,'tag','input_axes');
case 'ess_pwr'
    
    %%%%%% plot peak power
    %v=max(max(0.5*ess_voc,mc_min_volts/ess_module_num),max(0.5*ess_voc,ess_min_volts));
    v=max(0.5*ess_voc,ess_min_volts);
    ess_pwr=max(((ess_voc-v).*v)./(ess_r_dis*ess_res_scale_fun(ess_res_scale_coef,1,ess_cap_scale)),0); % saturate to 0 kW
    %figure
    hold
    plot(ess_soc,ess_pwr*ess_module_num/1000);
    ylabel('Instantaneous Power, kW');
    xlabel ('State of Charge, (--)');
    %set(gcf,'NumberTitle','off','Name','Battery Module Discharge Power')
    h=title({'Instantaneous Power';ess_description});
    set(h,'FontSize',7)
    str=[];
    for i=1:length(ess_tmp)
        str=[str, '''',num2str(ess_tmp(i)),' C'','];
    end
    eval(['legend(',str,'0)'])
    
    clear ess_pwr str v
    hold off
    set(gca,'tag','input_axes');
    
case 'ess_pulse_pwr'
    adjust_config_bds('bd_ess_test') % tm 4/26/02: updates the model to use the correct ess config sys
    soc_idx=find((ess_soc~=0)&(ess_soc~=1));
    h = waitbar(0,'Please wait...');
    set(h,'Windowstyle','modal');
    for i=1:length(soc_idx)
        [e,dp_dm(i),cp_dm(i)]=btry_specs(0,ess_soc(soc_idx(i)),ess_soc(soc_idx(i)),1,ess_min_volts,ess_max_volts,12,10);
        waitbar(((i/length(soc_idx))*50)/100,h);
    end
    for i=1:length(soc_idx)
        [e,dp_pa(i),cp_pa(i)]=btry_specs(0,ess_soc(soc_idx(i)),ess_soc(soc_idx(i)),1,ess_min_volts,ess_max_volts,18,2);
        waitbar((50+(i/length(soc_idx))*50)/100,h);
    end
    close(h);
    hold;
    plot((1-ess_soc(soc_idx))*100,dp_pa*ess_module_num/1000,'bd-',(1-ess_soc(soc_idx))*100,dp_dm*ess_module_num/1000,'r^-',(1-ess_soc(soc_idx))*100,-1*cp_pa*ess_module_num/1000,'gs-',(1-ess_soc(soc_idx))*100,-1*cp_dm*ess_module_num/1000,'mo-');
    ylabel('Pulse Power Capability, kW');
    xlabel ('Depth of Discharge, (%)');
    h=title({'PNGV Pulse Power Test';ess_description});
    set(h,'FontSize',7);
    legend('18s Discharge','12s Discharge','2s Charge','10s Charge');
    
    clear i e dp_pa cp_pa dp_dm cp_dm h soc_idx
    hold off
    set(gca,'tag','input_axes');
    
otherwise
    xlim([0 1]);
    ylim([0 1]);
    text(.5,.5,'Not Available');
    title('')
    xlabel('')
    ylabel('')
end

%set the block diagram name on the input figure and the motor position
try %try is used here because sometimes gui_inpchk is called before all necessary files are run
    %for the following
    set(findobj('tag','block diagram'),'string',block_diagram_name(vinf.drivetrain.name))
    if strcmp(vinf.drivetrain.name,'parallel')
        if strcmp(block_diagram_name('parallel'),'BD_PTH')
            set(findobj('tag','motor position'),'string','post transmission')
        else
            set(findobj('tag','motor position'),'string','pre transmission')
        end
        set(findobj('tag','motor position'),'visible','on')
        set(findobj('string','Motor Position:'),'visible','on')
        
    else
        set(findobj('tag','motor position'),'visible','off')
        set(findobj('string','Motor Position:'),'visible','off')
    end
end

%REVISIONS
%9/03/98:tm fixed fuel converter efficiency calculation to prevent divide by zero warning
% 3/22/99:ss fixed titles (font and double line) for the plots if they 
%            were too long to fit on input figure.
% 7/2/99:tm updated emissions and fuel use displays to use gpkWh data if available
% 7/6/99:tm updated fuel cell statements to use fc_**_gpkWh data
% 7/6/99:tm added contour range definitions to the gpkWh plots to highlight likely operating range
% 7/6/99:tm minor cosemtic changes
% 8/6/99: ss removed peukert plotting case(not used in model anymore)
% 8/17/99: ss replaced if and else statements with try and catch inside shifting plots.
% 8/23/99: tm modified plots to properly plot fuel cell data.
% 9/23/99:tm updated all fc_* plots to fuel cell data
% 9/23/99: vhj added & exist('ess_soc') for battery plots
% 10/4/99:tm added case shift table to display both the upshift and the downshift data 
%            on the fuel converter efficiency contour plots
% 10/7/99: ss updated the plotting of the fuel use plot to account for fc_spd_scale and moved the 
%            fuel cell x & y labels to make sure that the labels were correct for fuel cell vs. si engine plotting.
% 1/25/00:tm removed value_max calcs - not used
% 1/25/00:tm fixed label errors in plots of fuel cell emissions for model type = 1
% 6/14/00:ss multiplied by fc_spd_scale where appropriate per Marco's email.
% 8/15/00:tm updated efficiency plot for fuel_cell_model==1 missing cell number
% 8/15/00:tm added plots of ess_pwr and ess_rt_eff
% 8/16/00:tm updated efficiency calc for fuel cell model type 1 - it was incorrect
% 8/18/00:ss added statements to remember object tag in ess_pwr and ess_rt_eff cases
% 8/18/00:tm added *ess_module_num to provide pack power rather than module power
% 1/30/01:tm in ess rt eff case added max current calc based on peak power and added specific contour line plots 
% 1/31/01:ss added setting the block diagram name on the input figure.
% 2/2/01:tm removed references to mc and gc currnts from battery calcs
% 2/8/01: ss under 'otherwise' statement, plotted text that says not available
% 2/8/01: ss added code to manage the motor position text display
% 7/23/01:tm added case for ess_pulse_pwr to display pngv pulse power characteristics
% 7/24/01:tm revised ess_pulse_pwr case to include both dual mode and power assist tests and to provide a waitbar
% 7/27/01:tm added ess_cap_scale relationships for ess_max_ah_cap
% 7/30/01:tm added resistance=base_resistance*f(ess_module_num,ess_cap_scale) for ess_r_dis and ess_r_chg
% tm 4/26/02: added adjust_config_bds statment to ess_pulse_pwr case to update the model to use the correct ess config sys
% 4/29/02:tm added conditional to use fc_eff_map if it exists for polarization type fuel cell model
% 4/29/02:tm added *fc_pwr_scale and *fc_eff_scale to the fuel cell model =1 plots
% 5/23/02: kh adjusted for fuel cell model option # 4
% 6/6/03:tm revised VT model efficiency plots to use user defined plot params if they exist other wise use some defaults
%
