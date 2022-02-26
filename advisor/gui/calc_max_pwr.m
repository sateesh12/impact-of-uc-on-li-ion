function max_pwr=calc_max_pwr(component)
% returns max_pwr in kW

global vinf

switch component
case 'fuel_converter'
    if strcmp(vinf.fuel_converter.ver,'fcell')%(evalin('base','exist(''fc_fuel_cell_model'')')
        if strcmp(vinf.fuel_converter.type,'polar')%evalin('base','fc_fuel_cell_model')==1
            max_pwr=evalin('base','(max(fc_I_map.*fc_V_map)/1000)*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num*fc_pwr_scale');
        elseif strcmp(vinf.fuel_converter.type,'net')%evalin('base','fc_fuel_cell_model')==2
            max_pwr=evalin('base','max(fc_pwr_map)/1000*fc_pwr_scale');
        elseif strcmp(vinf.fuel_converter.type,'gctool')%evalin('base','fc_fuel_cell_model')==3
            max_pwr=vinf.gctool.dv.value(1)/1000*evalin('base','fc_pwr_scale');
        elseif strcmp(vinf.fuel_converter.type,'KTH')%evalin('base','fc_fuel_cell_model')==4
            max_pwr=evalin('base','fc_cell_stack_Pel/1000')*evalin('base','fc_pwr_scale');
        elseif strcmp(vinf.fuel_converter.type,'VT')
            max_pwr=evalin('base','fc_cell_area*fc_cell_num*fc_min_cell_volts*0.6/1000'); % *evalin('base','fc_pwr_scale'); % assumes 0.6 A/cm^2 - includes the bop
        end
    else
        max_pwr=evalin('base','(max(fc_map_spd.*fc_max_trq)/1000)*fc_trq_scale*fc_spd_scale');
    end
case 'motor_controller'
    max_pwr=evalin('base','(max(mc_map_spd.*mc_max_trq)/1000)*mc_trq_scale*mc_spd_scale'); 
case 'generator'
    if evalin('base','exist(''gc_trq_scale'')') & evalin('base','exist(''gc_spd_scale'')')
        max_pwr=evalin('base','(max(gc_map_spd.*gc_max_trq)/1000)*gc_trq_scale*gc_spd_scale'); 
    elseif evalin('base','exist(''gc_max_pwr'')')
        max_pwr=evalin('base','gc_max_pwr');
    else
        max_pwr='na';
    end        
case 'energy_storage'
    % 4-14-2003, mpo: shouldn't ess_cap_scale enter into this calculation?
    ess_voc=evalin('base','ess_voc');
    ess_soc=evalin('base','ess_soc');
    ess_tmp=evalin('base','ess_tmp');
    ess_module_num=evalin('base','ess_module_num');
    ess_r_dis=evalin('base','ess_r_dis');
    mc_min_volts=evalin('base','mc_min_volts');
    ess_min_volts=evalin('base','ess_min_volts');
    v=max(max(0.5*ess_voc,mc_min_volts/ess_module_num),max(0.5*ess_voc,ess_min_volts));
    ess_pwr=((ess_voc-v).*v)./(ess_r_dis)*ess_module_num;
    for i=1:length(ess_tmp)
        max_pwr(i)=interp1(ess_soc,ess_pwr(i,:),0.5); % evaluate power at 50% depth of discharge
    end
    max_pwr=max(max_pwr)/1000;
    % 4-14-2003, mpo: added the following to returned max power before scaling. 
case 'fuel_converter_no_scale'
    % the maximum power before scaling
    if strcmp(vinf.fuel_converter.ver,'fcell')%(evalin('base','exist(''fc_fuel_cell_model'')')
        if strcmp(vinf.fuel_converter.type,'polar')%evalin('base','fc_fuel_cell_model')==1
            max_pwr=evalin('base','(max(fc_I_map.*fc_V_map)/1000)*fc_cell_area*fc_cell_num*fc_stack_num*fc_string_num');
        elseif strcmp(vinf.fuel_converter.type,'net')%evalin('base','fc_fuel_cell_model')==2
            max_pwr=evalin('base','max(fc_pwr_map)/1000');
        elseif strcmp(vinf.fuel_converter.type,'gctool')%evalin('base','fc_fuel_cell_model')==3
            max_pwr=vinf.gctool.dv.value(1)/1000;
        elseif strcmp(vinf.fuel_converter.type,'KTH')%evalin('base','fc_fuel_cell_model')==4
            max_pwr=evalin('base','fc_cell_stack_Pel/1000');
        elseif strcmp(vinf.fuel_converter.type,'VT')
            max_pwr=evalin('base','fc_cell_area*fc_cell_num*fc_min_cell_volts*0.6/1000'); % *evalin('base','fc_pwr_scale'); % assumes 0.6 A/cm^2 - includes the bop
        end
    else
        max_pwr=evalin('base','(max(fc_map_spd.*fc_max_trq)/1000)');
    end
case 'motor_controller_no_scale'
    max_pwr=evalin('base','(max(mc_map_spd.*mc_max_trq)/1000)'); 
case 'generator_no_scale'
    if evalin('base','exist(''gc_trq_scale'')') & evalin('base','exist(''gc_spd_scale'')')
        max_pwr=evalin('base','(max(gc_map_spd.*gc_max_trq)/1000)'); 
    elseif evalin('base','exist(''gc_max_pwr'')')
        max_pwr=evalin('base','gc_max_pwr');
    else
        max_pwr='na';
    end        
case 'energy_storage_no_scale'
    ess_voc=evalin('base','ess_voc');
    ess_soc=evalin('base','ess_soc');
    ess_tmp=evalin('base','ess_tmp');
    ess_module_num=evalin('base','ess_module_num');
    ess_r_dis=evalin('base','ess_r_dis');
    mc_min_volts=evalin('base','mc_min_volts');
    ess_min_volts=evalin('base','ess_min_volts');
    v=max(max(0.5*ess_voc,mc_min_volts/ess_module_num),max(0.5*ess_voc,ess_min_volts));
    ess_pwr=((ess_voc-v).*v)./(ess_r_dis)*ess_module_num;
    for i=1:length(ess_tmp)
        max_pwr(i)=interp1(ess_soc,ess_pwr(i,:),0.5); % evaluate power at 50% depth of discharge
    end
    max_pwr=max(max_pwr)/1000;
end

return

% revision notes
% 8/18/00:tm added case for energy storage system
% 4/9/02: kh added fuel cell model option #4, lines 15 & 16
% 3/27/03:tm converted the fuel cell case to reference the version and type infor
% 3/27/03:tm added calcs specific to the VT fuel cell model