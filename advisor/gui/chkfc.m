% use to check fuel converter operation

str=[];

if isfield(vinf,'fuel_converter')
    
    figure
    
    if strcmp(vinf.fuel_converter.ver,'fcell') % vehicle uses a  fuel cell
        
        if strcmp(vinf.fuel_converter.type,'polar') 
            %if exist('fc_fuel_cell_model')&fc_fuel_cell_model~=3  % vehicle uses a  fuel cell
            %   if fc_fuel_cell_model==1
            if ~exist('fc_eff_map')
                if exist('fc_gross_pwr_map')
                    fc_eff_map=fc_gross_pwr_map./(fc_fuel_map*fc_cell_num*fc_fuel_lhv);
                else
                    fc_eff_map=fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map./fc_fuel_lhv;
                end
            end
            plot(fc_pwr_map*fc_pwr_scale/1000,fc_eff_map*fc_eff_scale*100,'k-')
            str=[str,'''eff vs. power curve'''];
            hold
        elseif strcmp(vinf.fuel_converter.type,'net')
            %    elseif fc_fuel_cell_model==2
            fc_eff_map=fc_pwr_map./fc_fuel_map./fc_fuel_lhv;
            plot(fc_pwr_map*fc_pwr_scale/1000,fc_eff_map*fc_eff_scale*100,'k-')
            str=[str,'''eff vs. power curve'''];
            hold
        elseif strcmp(vinf.fuel_converter.type,'VT')   
            plot(vinf.fuel_converter.pwr_map/1000,vinf.fuel_converter.eta_map*100,'k-')
            str=[str,'''eff vs. power curve'''];
            hold
        end
        
        % plot series follower control strategy
        if exist('cs_pwr')
            plot(cs_pwr/1000,interp2(fc_map_spd,fc_map_trq,fc_map_eff'*100,cs_spd,cs_pwr./cs_spd),'b--');
            str=[str,',''design curve'''];
        end;
        
        % plot actual data if it exists
        if exist('fc_pwr_out_a')
            %galps=diff([gal])./diff(t);
            %fc_pwr_in_a=[galps;galps(end)]*3.785*fc_fuel_lhv*fc_fuel_den;
            fc_pwr_in_a=fc_fuel_rate*fc_fuel_lhv;
            fc_eff_out_a=fc_pwr_out_a./(fc_pwr_in_a+eps);
            plot(fc_pwr_out_a/1000,fc_eff_out_a*100,'rx')
            str=[str, ',''actual operating points'''];
        end;
        
        % add labels to the plot
        xlabel('Power (kW)')
        ylabel('Efficiency (%)')
        eval(['legend(',str,',4)'])
        
        if strcmp(vinf.fuel_converter.type,'polar') %fc_fuel_cell_model==1
            
            str=[];
            figure;
            plot(fc_I_map/100/100,fc_V_map,'k-');
            hold
            str=[str,'''polarization curve'''];
            
            %plot actual data if it exists
            if exist('fc_cell_I_out_a')
                plot(fc_cell_I_out_a/fc_cell_area/100/100,fc_cell_V_out_a,'rx')
                str=[str, ',''operating points'''];
            end;
            
            % add labels to the plot
            xlabel('Current Density (A/cm^2)')
            ylabel('Voltage (V)')
            eval(['legend(',str,',4)'])
            
        end
        
        if strcmp(vinf.fuel_converter.type,'VT') %fc_fuel_cell_model==1
            
            str=[];
            figure;
            
            % plot polarizatin curve if it exists
            if isfield(vinf.fuel_converter,'crrnt_map')
                plot(vinf.fuel_converter.crrnt_map,vinf.fuel_converter.voltage_map,'k-');
                hold
                str=[str,'''polarization curve'''];
            end
            
            %plot actual data if it exists
            if exist('fc_cell_current')
                plot(fc_cell_current,fc_cell_voltage,'rx')
                str=[str, ',''operating points'''];
            end;
            
            % add labels to the plot
            xlabel('Current Density (A/cm^2)')
            ylabel('Voltage (V)')
            eval(['legend(',str,',4)'])
            
        end
        
    else % not a fuel cell vehicle
        
        %plot max torque envelope
        if exist('fc_max_trq')
            plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-');
            str=[str,'''max torque curve'''];
        end;
        hold
        
        % plot generator max trq envelope
        if exist('gc_max_trq')
            plot(gc_map_spd*30/pi*gc_spd_scale,gc_max_trq*gc_trq_scale,'k-.');
            str=[str,',''gc max torque curve'''];
        end
        
        %plot prius max eff line if exist
        if exist('fc_spd_opt')
            plot(fc_spd_opt*30/pi,fc_trq_opt,'b-')
            str=[str,',''design curve'''];
        end
        
        % plot series follower control strategy
        if exist('cs_pwr')
            if nnz(cs_spd<eps)
                plot([0 cs_spd(:,2:length(cs_spd))*30/pi],[0 cs_pwr(:,2:length(cs_pwr))./cs_spd(:,2:length(cs_spd))],'b--');
            else
                plot(cs_spd*30/pi,cs_pwr./cs_spd,'b--');
                str=[str,',''design curve'''];
            end;
        end;
        
        % plot cvt control strategy
        if exist('cvt_locus_pwr')
            if nnz(cvt_locus_spd<eps)
                plot([0 cvt_locus_spd(:,2:length(cvt_locus_spd))*30/pi],[0 cvt_locus_pwr(:,2:length(cvt_locus_pwr))./cvt_locus_spd(:,2:length(cvt_locus_spd))],'b--');
            else
                plot(cvt_locus_spd*fc_spd_scale*30/pi,cvt_locus_pwr*fc_trq_scale./cvt_locus_spd,'b--');
                str=[str,',''design curve'''];
            end;
        end;
        
        % plot parallel control strategy
        if exist('cs_trq')
            plot(cs_spd*30/pi,cs_trq,'b--');
            str=[str,',''design curve'''];
        end;
        if exist('cs_off_trq_frac')
            plot(fc_map_spd*fc_spd_scale*30/pi,cs_off_trq_frac*fc_max_trq*fc_trq_scale,'m:');
            str=[str,',''CS Off Torque Fraction'''];
        end;
        if exist('cs_min_trq_frac')
            plot(fc_map_spd*fc_spd_scale*30/pi,cs_min_trq_frac*fc_max_trq*fc_trq_scale,'g:');
            str=[str,',''CS Minimum Torque Fraction'''];
        end;
        
        % plot actual data if it exists
        if exist('fc_trq_out_a')
            plot(fc_spd_est*30/pi,fc_trq_out_a,'rx')  % fc_trq_out_a includes inertia effects
            str=[str,',''output shaft'''];
        end;
        if exist('fc_brake_trq')
            plot(fc_spd_est*30/pi,fc_brake_trq,'g^')  % fc_brake_trq does not include inertia effects
            str=[str,',''op. pts(includes inertia & accessories)'''];
        end;
        if exist('acc_trq_out_a')
            plot(fc_spd_est*30/pi,fc_brake_trq-acc_trq_out_a,'bo')  % fc_trq_out_a includes inertia effects
            str=[str,',''op. pts(includes inertia)'''];
        end;
        
        % overlay efficiency contour map
        if nnz(fc_map_trq<eps)
            trq=[];
            for x=1:length(fc_map_trq)
                if fc_map_trq(x)>0
                    trq=[trq fc_map_trq(x)];
                end;
            end;
        else 
            trq=fc_map_trq;
        end;
        if nnz(fc_map_spd<eps)
            spd=[];
            for x=1:length(fc_map_spd)
                if fc_map_spd(x)>0
                    spd=[spd fc_map_spd(x)];
                end;
            end;
        else
            spd=fc_map_spd;
        end;
        
        % create efficiency map
        diff_trq=length(fc_map_trq)-length(trq);
        diff_spd=length(fc_map_spd)-length(spd);
        [T,w]=meshgrid(trq,spd);
        fc_map_kW=T.*w/1000;
        fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),...
            diff_trq+1:length(fc_map_trq))*fc_fuel_lhv);
        
        % plot efficiency map
        % determine the best brake thermal efficiency within the allowable operating range
        good_trqs=[];
        for i=1:length(spd)
            good_trqs=[good_trqs; T(i,:)<=fc_max_trq(i+diff_spd)];
        end
        fc_map_eff_good=(fc_eff_map*fc_eff_scale).*good_trqs;
        fc_bte=max(max(fc_map_eff_good));
        temp=fc_bte*100;
        levels=[temp-16 temp-12 temp-8 temp-4 temp-2 temp-1];
        
        c=contour(spd*30/pi*fc_spd_scale,trq*fc_trq_scale,(fc_eff_map*fc_eff_scale)'*100,levels);
        clabel(c)
        
        % plot OSU Fuzzy Logic parallel control strategy
        if strcmp(vinf.powertrain_control.name,'PTC_FUZZY_FUEL_MODE')
            plot(fc_map_spd*fc_spd_scale*30/pi,flc_target*fc_trq_scale,'b--');
            str=[str,',''Fuel-Limited ICE Torque'''];
        end;
        
        if strcmp(vinf.powertrain_control.name,'PTC_FUZZY_EFF_MODE')
            plot(fc_map_spd*fc_spd_scale*30/pi,flc_target*fc_trq_scale,'b--')
            str=[str,',''Peak-Efficiency ICE Torque'''];
        end;
        
        %plot from 0 on up
        xaxislimits=get(gca,'xlim');
        xaxislimits(1)=0;
        set(gca,'xlim',xaxislimits );
        clear xaxislimits
        
        % add labels to the plot
        xlabel('Speed (rpm)')
        ylabel('Torque (Nm)') % for use with fc_brake_trq
        eval(['legend(',str,',4)'])
        
    end;
    
    if length(['Fuel Converter Operation - ',fc_description])<75
        title(['Fuel Converter Operation - ',fc_description]);
    elseif length(fc_description)<75
        ttl={'Fuel Converter Operation';fc_description};
        title(ttl,'Fontsize',7);
    else
        ttl_str=['Fuel Converter Operation - ',fc_description];
        space_index=findstr(ttl_str,' ');   
        cut_index=max(find(space_index<=75));
        ttl={ttl_str(1:space_index(cut_index));ttl_str(space_index(cut_index)+1:end)};
        title(ttl,'Fontsize',7);
    end
    set(gcf,'NumberTitle','off','Name','Fuel Converter Operation')
end

%12/31/98: tm added plot parallel  control strategy section
%1/20/99:ss changed ylabel to Torque(Nm) was Brake Torque(Nm) [not including inertia]
%8/17/99: ss added axis limits to keep it above 0 speed
% 8/26/99 ss: added design curve for Prius
% 9/7/99 tm: updated linetypes for b&w printing
% 10/1/99 mc changed to use fc_spd_est instead of fc_spd_out_a for plotting
% 10/25/99:tm added lines to plot new parallel control strategy if it exists
%	5/10/00:tm added lines to plot cvt design curve if it exists
% 4/10/02: kh added fuel cell model option #4, lines 12 & 13
% 4/26/02:tm updated fc_pwr in calc for fuel cells to be based on fuel rate not gal
%4/29/02:tm added code to plot polarization curve and efficiency curve for polarization model
% 5/23/02: kh added code to plot polarization curve and efficiency curve for KTH model (fc model 4)
% 10/2/03:tm added section to plot VT efficiency and polarization data
