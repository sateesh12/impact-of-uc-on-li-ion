function ess2fuel_ratio=calc_ess2fuel()
% function calc_ess2fuel calculates the absolute value of the energy ratio (in percent) of delta ess stored energy to
% fuel energy used.
global vinf

try
    %Added to work with J1711: zero delta between 'pause' and end
    if evalin('base','~exist(''soc_t'')')
        evalin('base','soc_t=1;'); 
    end
    
    deltaSOC=evalin('base','ess_soc_hist(end)-ess_soc_hist(soc_t)'); %record Delta SOC
    
catch
    ess2fuel_ratio=NaN;
    return
end

try
    soc1=evalin('base','ess_soc_hist(soc_t)');
    soc2=evalin('base','ess_soc_hist(end)');
    
    %rint model
    if strcmp(vinf.energy_storage.ver,'rint')
        Ess_Delta_Energy_Stored=deltaSOC*evalin('base','max(ess_max_ah_cap)*mean(mean(ess_voc))*ess_module_num')*3600; %Joules
        
        %rc model
    elseif strcmp(vinf.energy_storage.ver,'rc')
        if strcmp(vinf.energy_storage.type,'cap') % if an ultracapacitor model:
            ess_voc=evalin('base','ess_voc');
            ess_cap=evalin('base','ess_cap');
            numCaps=evalin('base','ess_parallel_mod_num*ess_module_num'); % the number of ultracaps
            
            V_oc_max = max(max(ess_voc));
            V_oc_min = min(min(ess_voc));
            % Q = V C (charge = voltage * capacitance), E = 0.5 C V^2 (energy = 1/2 capacitance * oc voltage squared)
            V_init   = soc1*(V_oc_max-V_oc_min)+V_oc_min; % transforming from SOC to V initial (open circuit)
            V_final  = soc2*(V_oc_max-V_oc_min)+V_oc_min; % transforming from SOC to V final
            
            C_ave    = mean(mean(ess_cap)); % the average capacitance over both SOC and temperature
            E1       = numCaps*0.5*C_ave*V_init^2; % energy at initial state
            E2       = numCaps*0.5*C_ave*V_final^2;% energy at final state
            
            Ess_Delta_Energy_Stored=E2-E1;
        else % if a li-ion or NiMH etc. RC model then use below code:
            [ess_tmp,ess_soc]=meshgrid(evalin('base','ess_tmp'),evalin('base','ess_soc'));
            ess_voc=evalin('base','ess_voc');
            
            temp1=evalin('base','ess_mod_tmp(soc_t)');
            temp2=evalin('base','ess_mod_tmp(end)');
            
            
            Volt1_2=interp2(ess_tmp,ess_soc,ess_voc',[temp1 temp2], [soc1 soc2]).*evalin('base','ess_module_num');
            
            % get ess_cb and ess_cc from workspace (29-April-2002 mpo)
            ess_cb=evalin('base','ess_cb');
            ess_cc=evalin('base','ess_cc');
            ess_tmp=evalin('base','ess_tmp');
            
            if 0 % debug statement--use a find/replace for "if 0" <--> "if 1"
                keyboard
            end
            
            Cb1_2=interp1(ess_tmp,ess_cb,[temp1, temp2]);
            Cc1_2=interp1(ess_tmp,ess_cc,[temp1, temp2]);
            
            Ess_Delta_Energy_Stored=0.5*(Cb1_2(2)+Cc1_2(2))*Volt1_2(2)^2 - 0.5*(Cb1_2(1)+Cc1_2(1))*Volt1_2(1)^2;
        end
        %nnet model
    elseif strcmp(vinf.energy_storage.ver,'nnet')
        Ess_Delta_Energy_Stored=deltaSOC*evalin('base','max(ess_max_ah_cap)*mean(ess_voc)*ess_module_num')*3600; %Joules
        
        %fund model
    elseif strcmp(vinf.energy_storage.ver,'fund')
        Ess_Delta_Energy_Stored=deltaSOC*evalin('base','ess_cap)*ess_voc*ess_module_num')*3600; %Joules
        
    elseif strcmp(vinf.energy_storage.ver,'saber2')
        Ess_Delta_Energy_Stored=deltaSOC*evalin('base','ess_ah_nom_fun(ess_cap_scale)*mean(mean(ess_voc))*ess_module_num')*3600; %Joules
        
        
        %otherwise return NaN   
    else
        ess2fuel_ratio=NaN;
        return
    end
    
catch
    ess2fuel_ratio=NaN;
    disp(['Error in calc_ess2fuel calculating ess delta energy stored for ',vinf.energy_storage.ver ,' energy storage'])
    disp(lasterr)
    dbstack
    return
end

try
    fuel_gal=evalin('base','max(gal)');
    if fuel_gal==0
        ess2fuel_ratio=NaN;
        return
    end
catch
    ess2fuel_ratio=NaN;
    return
end

try
    Fuel_Energy_Used=fuel_gal*3.785*evalin('base','fc_fuel_lhv*fc_fuel_den'); %Joules
catch
    ess2fuel_ratio=NaN;
    disp('Error in calc_ess2fuel: fc_fuel_lhv or fc_fuel_den does not exist in base')
    return
end

ess2fuel_ratio=abs(Ess_Delta_Energy_Stored/Fuel_Energy_Used)*100;

% updates
% 2002-04-29 [mpo] broke rc section into 'ultracaps' and 'other'--fixed bugs with rc algorithm and added ultracap algorithm with help of mz
