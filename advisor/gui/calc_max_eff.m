function max_eff=calc_max_eff(component)

global vinf 

switch component
case 'fuel_converter'
    if strcmp(vinf.fuel_converter.ver,'fcell')%evalin('base','exist(''fc_fuel_cell_model'')')
        if strcmp(vinf.fuel_converter.type,'polar')%evalin('base','fc_fuel_cell_model')==1
            if evalin('base','exist(''fc_eff_map'')')
                max_eff=evalin('base','max(fc_eff_map)');
            else
                max_eff=evalin('base','max(fc_I_map.*fc_V_map*fc_cell_area./fc_fuel_map./fc_fuel_lhv)');
            end
        elseif strcmp(vinf.fuel_converter.type,'net')%evalin('base','fc_fuel_cell_model')==2
            max_eff=evalin('base','max(fc_pwr_map./fc_fuel_map./fc_fuel_lhv)');
        elseif strcmp(vinf.fuel_converter.type,'gctool')%evalin('base','fc_fuel_cell_model')==3
            max_eff=vinf.gctool.peak_eff; 
        elseif strcmp(vinf.fuel_converter.type,'KTH')%evalin('base','fc_fuel_cell_model')==4
            max_eff=evalin('base', 'max_eff1');
            %est_peak=evalin('base','fc_min_cell_volts*1103*fc_cell_dim_A*0.6');
                 % est_peak=evalin('base','fc_cell_stack_Pel');
                    %est_peak=fc_cell_stack_Pel;
           % pwr_map=[0.1:0.4/10:0.5]*est_peak;
           % tmp_map=[60:10:80];
           %[eta,pwr,tmp]=evalin('base',['build_fc_eff_curve_KTH(',mat2str(pwr_map),',',mat2str(tmp_map),')']);
           % max_eff=max(max(eta));
            
        elseif strcmp(vinf.fuel_converter.type,'VT')
            est_peak=evalin('base','fc_min_cell_volts*fc_cell_num*fc_cell_area*0.6');
            pwr_map=[0.1:0.4/10:0.5]*est_peak;
            tmp_map=[60:10:80];
            [eta,pwr,tmp]=evalin('base',['build_fc_eff_curve(',mat2str(pwr_map),',',mat2str(tmp_map),')']);
            max_eff=max(max(eta));
        end
    else
        trq=[];
        fc_map_trq=evalin('base','fc_map_trq');
        for x=1:length(fc_map_trq)
            if fc_map_trq(x)>0
                trq=[trq fc_map_trq(x)];
            end;
        end;
        spd=[];
        fc_map_spd=evalin('base','fc_map_spd');
        for x=1:length(fc_map_spd)
         if fc_map_spd(x)>0
            spd=[spd fc_map_spd(x)];
         end;
      end;
      diff_trq=length(fc_map_trq)-length(trq);
      diff_spd=length(fc_map_spd)-length(spd);
      [T,w]=meshgrid(trq,spd);
      fc_map_kW=T.*w/1000;
      fc_fuel_map=evalin('base','fc_fuel_map');
      fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),diff_trq+1:length(fc_map_trq))...
         *evalin('base','fc_fuel_lhv'));
      % determine the best efficiency within the allowable operating range
      good_trqs=[];
      fc_max_trq=evalin('base','fc_max_trq');
      for spd_index=1:length(spd)
         good_trqs=[good_trqs; T(spd_index,:)<=fc_max_trq(spd_index+diff_spd)];
      end
      max_eff=max(max(fc_eff_map.*good_trqs));
   end
case 'motor_controller'
   trq=[];
   mc_map_trq=evalin('base','mc_map_trq');
   for x=1:length(mc_map_trq)
      if mc_map_trq(x)>0
         trq=[trq mc_map_trq(x)];
      end;
   end;
   spd=[];
   mc_map_spd=evalin('base','mc_map_spd');
   for x=1:length(mc_map_spd)
      if mc_map_spd(x)>0
         spd=[spd mc_map_spd(x)];
      end;
   end;
   diff_trq=length(mc_map_trq)-length(trq);
   diff_spd=length(mc_map_spd)-length(spd);
   [T,w]=meshgrid(trq,spd);
   mc_map_kW=T.*w/1000;
   mc_inpwr_map=evalin('base','mc_inpwr_map');
   mc_eff_map=mc_map_kW*1000./(mc_inpwr_map(diff_spd+1:length(mc_map_spd),diff_trq+1:length(mc_map_trq)));
   % determine the best efficiency within the allowable operating range
   good_trqs=[];
   mc_max_trq=evalin('base','mc_max_trq');
   for spd_index=1:length(spd)
      good_trqs=[good_trqs; T(spd_index,:)<=mc_max_trq(spd_index+diff_spd)&T(spd_index,:)>0];
   end
   max_eff=max(max(mc_eff_map.*good_trqs));
case 'generator'
    
    if evalin('base','exist(''gc_map_trq'')') & evalin('base','exist(''gc_map_spd'')')
        trq=[];
        gc_map_trq=evalin('base','gc_map_trq');
        for x=1:length(gc_map_trq)
            if gc_map_trq(x)>0
                trq=[trq gc_map_trq(x)];
            end;
        end;
        spd=[];
        gc_map_spd=evalin('base','gc_map_spd');
        for x=1:length(gc_map_spd)
            if gc_map_spd(x)>0
                spd=[spd gc_map_spd(x)];
            end;
        end;
        diff_trq=length(gc_map_trq)-length(trq);
        diff_spd=length(gc_map_spd)-length(spd);
        [T,w]=meshgrid(trq,spd);
        gc_map_kW=T.*w/1000;
        gc_outpwr_map=evalin('base','gc_outpwr_map');
        gc_eff_map=1./(gc_map_kW*1000./(gc_outpwr_map(diff_spd+1:length(gc_map_spd),diff_trq+1:length(gc_map_trq))));
        % determine the best efficiency within the allowable operating range
        good_trqs=[];
        gc_max_trq=evalin('base','gc_max_trq');
        for spd_index=1:length(spd)
            good_trqs=[good_trqs; T(spd_index,:)<=gc_max_trq(spd_index+diff_spd)&T(spd_index,:)>0];
        end
        max_eff=max(max(gc_eff_map.*good_trqs));
    elseif evalin('base','exist(''gc_eff'')')
        max_eff=evalin('base','gc_eff');
    else
        max_eff='na';
    end
case 'transmission'
   if evalin('base','exist(''gb_map_trq_in'')') % trans is a standard CVT
      ratio=evalin('base','gb_ratio');
      trq_in=evalin('base','gb_map_trq_in');
      trq_out=evalin('base','gb_map_trq_out');
      spd_out=evalin('base','gb_map_spd_out');
      trq_out_pos=trq_out(:,find(trq_in(1,:,1)>eps),:);
      trq_in_pos=trq_in(:,find(trq_in(1,:,1)>eps),:);
      for i=1:length(ratio)
         ratio_mat(:,:,i)=ones(size(trq_out_pos(:,:,i)))*ratio(i);
         trq_in_pos_mat(:,:,i)=meshgrid(trq_in_pos(1,:,i),spd_out(:,1,i));
      end
      eta=trq_out_pos./trq_in_pos_mat./ratio_mat;
      tx_peak_eff=max(max(max(eta)));
   %elseif evalin('base','exist(''htc_sr'')') % trans is a automatic
   %   tx_peak_eff=NaN; % tm:7/11/00 unsure how to calc eff today
   elseif evalin('base','exist(''tx_eff_map'')') % trans is a manual or automatic (i.e., non-CVT)
      tx_peak_eff=evalin('base','max(max(max(tx_eff_map)))'); % the three function calls needed to get scalar for 3D matrix
      %gear_ratio=evalin('base','gb_ratio(gb_gears_num)');
      
      %if isfield(vinf,'fuel_converter')&~strcmp(vinf.fuel_converter.type,'fc')%~strcmp(vinf.drivetrain.name,'ev')&~strcmp(vinf.drivetrain.name,'fuel_cell')
      %   spd=evalin('base','fc_map_spd*fc_spd_scale');
      %   trq=evalin('base','fc_map_trq*fc_trq_scale');
      %elseif evalin('base','exist(''mc_map_spd'')')
      %   spd=evalin('base','mc_map_spd*mc_spd_scale');
      %   trq=evalin('base','mc_map_trq*mc_trq_scale');
      %else
      %   spd=[];
      %   trq=[];
      %end
      
      %if ~isempty(spd)&~isempty(trq)
      %   input_shaft_torque=[max(trq)/10:max(trq)/10:max(trq)];%Nm
      %   input_shaft_speed=[max(spd)/10:max(spd)/10:max(spd)];%rad/s
      %   
      %   output_shaft_torque=input_shaft_torque*gear_ratio;
      %   output_shaft_speed=input_shaft_speed/gear_ratio;
      %   
      %   P_loss = (evalin('base','gb_loss_input_spd_coeff') * gear_ratio + evalin('base','gb_loss_output_spd_coeff'))...
      %      .* output_shaft_speed...
      %      + (evalin('base','gb_loss_input_trq_coeff') / gear_ratio + evalin('base','gb_loss_output_trq_coeff'))...
      %      .* output_shaft_torque...
      %      + evalin('base','gb_loss_output_pwr_coeff') .* output_shaft_torque .* output_shaft_speed +...
      %      + evalin('base','gb_loss_const');
      %   
      %   tx_peak_eff=min(1,max((input_shaft_torque.*input_shaft_speed-P_loss)./(input_shaft_torque.*input_shaft_speed)));
      %else
      %   tx_peak_eff=NaN
      %end
      
   else % unknown type
      tx_peak_eff=NaN;
   end
   max_eff=tx_peak_eff;
   
case('energy_storage')
   ess_coulombic_eff=evalin('base','ess_coulombic_eff');
   ess_max_ah_cap=evalin('base','ess_max_ah_cap');
   ess_tmp=evalin('base','ess_tmp');
   ess_voc=evalin('base','ess_voc');
   ess_r_dis=evalin('base','ess_r_dis');
   ess_r_chg=evalin('base','ess_r_chg');
   % determine current limits
   if evalin('base','exist(''gc_max_crrnt'')')
      gc_crrnt=evalin('base','gc_max_crrnt');   
   else
      gc_crrnt=[];   
   end
   if evalin('base','exist(''mc_max_crrnt'')')
      mc_crrnt=evalin('base','mc_max_crrnt');   
   else
      mc_crrnt=[];
   end
   max_crrnt=min([gc_crrnt mc_crrnt]);
   if isempty(max_crrnt)
      max_crrnt=400;
   end
   
   % define discharge times
   %time_vec=[1/60 1/30 1/20 1/15 1/10 1/5 1/2 1 2 5 10 15 20 40]; % define time vector (hr)
   time_vec=[1]; % define time vector (hr)
   
   % limit time vector to possible currents
   t_index=find((time_vec<=(max(ess_max_ah_cap)*4))&(time_vec>=(min(ess_max_ah_cap)/max_crrnt)));
   time_vec=time_vec(t_index);
   
   % calculate round trip efficiency
   for y=1:length(ess_tmp)
      for x=1:length(time_vec)
         eta_rt(:,x,y)=(ess_voc(y,:)-ess_max_ah_cap(y)/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_dis(y,:))./(ess_voc(y,:)+ess_max_ah_cap(y)/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_chg(y,:))*ess_coulombic_eff(y);
      end
   end
   
   max_eff=max(max(eta_rt));
   
otherwise
   max_eff=NaN;
end

return

% Revision history:
% 7/11/00:tm added section to calculate tranmission efficiency
% 8/15/00:tm syntax error in assignment of fuel cell efficiency for model type 1 max_pwr to max_eff
% 8/16/00:tm updated efficiency calc for fuel cell model type 1 - it was incorrect
% 8/18/00:tm added case for energy storage system
% 2/9/01:tm revised trans case to work with custom selections
% 19-July-2001:mpo changed eff calculation to work with new transmission loss method
% 4/9/02: kh added fc model option #4, lines 14 & 15
% 4/29/02:tm added conditional to fuel_cell_model_type=1 case to use fc_eff_map if it exists
% 4/30/02:tm updated assignment of max efficiency for gctool model
% 3/27/03:tm converted the fuel cell case to reference the version and type infor
% 3/27/03:tm added calcs specific to the VT fuel cell model
% 6/6/03:tm updated to use simplified inputs to build_fc_eff_curve