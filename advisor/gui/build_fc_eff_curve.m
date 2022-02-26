function [eta,pwr,tmp,voltage,current]=build_fc_eff_curve(pwr_map,tmp_map)

init_conds_amb;

if evalin('base','exist(''vinf.run_without_gui'')')&evalin('base','vinf.run_without_gui')==1
    gui_flag=0;
else
    gui_flag=1;
end
    
if gui_flag
    h = waitbar(0,'Please wait...');
    set(h,'Windowstyle','modal');
end

for ii=1:length(tmp_map)
    
    assignin('base','fc_system_init_temp',tmp_map(ii)+273);
    
    for i=1:length(pwr_map) 
        assignin('base','pwr_profile',[[0:6]' ones(7,1)*pwr_map(i)]); 
        adjust_config_bds('FuelCellWorkBench');
        evalin('base','sim(''FuelCellWorkBench'')'); 
        %eta(i,ii)=evalin('base','mean(fc_net_pwr_out(:,1)./(fc_fuel_rate*fc_fuel_lhv))'); 
        eta(i,ii)=evalin('base','(fc_net_pwr_out(end)./(fc_fuel_rate(end)*fc_fuel_lhv))'); 
        pwr(i,ii)=evalin('base','fc_net_pwr_out(end)'); 
        voltage(i,ii)=evalin('base','fc_cell_voltage(end)'); 
        current(i,ii)=evalin('base','fc_cell_current(end)'); 
        tmp(ii)=evalin('base','fc_system_init_temp');

        if gui_flag    
            waitbar(i*ii/(length(tmp_map)*length(pwr_map)),h);
        end

    end
    
end

if gui_flag    
    close(h);
end

evalin('base','clear *init_tmp')

return

% 6/6/03:tm simplified input parameters to be a vector of powers and a vector of temperatures
% 10/2/03:tm removed mean from efficiency calc
