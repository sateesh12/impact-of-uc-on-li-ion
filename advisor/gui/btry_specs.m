function [energy_cap,dis_pwr,regen_pwr]=btry_specs(display_results,lo_soc,hi_soc,c_rate,v_min,v_max,dis_duration,regen_duration)

%
% calculates the max energy capacity, max regen power, and max discharge power 
% within the SOC and voltage limits of the module
%

% define defaults
if ~exist('display_results')
    display_results=1;
end
if ~exist('lo_soc')
    lo_soc=0.4;
end
if ~exist('hi_soc')
    hi_soc=0.6;
end
if ~exist('c_rate')
    c_rate=1;
end
if ~exist('v_min')
    %v_min=evalin('base','mean(ess_voc)*0.85');
    v_min=evalin('base','mean(mean(ess_voc))*0.85');
end
if ~exist('v_max')
    %v_max=evalin('base','mean(ess_voc)*1.10');
    v_max=evalin('base','mean(mean(ess_voc))*1.10');
end
if ~exist('dis_duration')
    dis_duration=18;
end
if ~exist('regen_duration')
    regen_duration=2;
end


%%%%%%%%%%%%%%%%%%%%%
% Store current workspace variables
%%%%%%%%%%%%%%%%%%%%%
% Store current workspace variables
store

% Override workspace variables
assignin('base','ess_module_num',1);
assignin('base','ess_min_volts',0);
assignin('base','ess_max_volts',inf);
assignin('base','mc_min_volts',0);
assignin('base','ess_th_calc',0);
assignin('base','cyc_mph',[0 1; 0 1])
assignin('base','amb_tmp',20)
assignin('base','air_cp',1009)
assignin('base','ess_mod_init_tmp',20)
assignin('base','enable_stop',0)

% set test parameters
default_lb=1; % lower bound of power request (W)
default_ub=100000; % upper bound of power request (W)

%%%%%%%%%%%%%%%%%%%%
% calculate the max energy capacity
%%%%%%%%%%%%%%%%%%%%

if hi_soc>lo_soc
    
    % Override workspace variables
    assignin('base','ess_init_soc',hi_soc);
    
    % Initialize
    index_v_min=[];
    index_lo_soc=[];
    iter=0;
    duration=3600/c_rate;
    time=[0:(duration+ceil(0.01*duration))]'; % cycle duration
    
    % set active bounds
    lb=default_lb;
    ub=default_ub;
    
    % test lower bound
    assignin('base','ess_pwr_req',[time lb*ones(size(time))]);
    evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
    
    index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
    index_lo_soc=min(find(evalin('base','ess_soc_hist')<=lo_soc));
    
    if (isempty(index_v_min)|index_v_min>duration)&(isempty(index_lo_soc)|index_lo_soc>duration)
        
        % test upper bound
        assignin('base','ess_pwr_req',[time ub*ones(size(time))]);
        evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
        
        index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
        index_lo_soc=min(find(evalin('base','ess_soc_hist')<=lo_soc));
        
        if (isempty(index_v_min)|index_v_min>duration)&(isempty(index_lo_soc)|index_lo_soc>duration)
            disp('ERROR: Upper bound too low.')
            failed_at_ub_e=1;
        else % loop to find power request that dicharges the module from hi soc to lo soc in duration
            loop=1;
            while loop 
                if (isempty(index_v_min)|index_v_min>duration)&(isempty(index_lo_soc)|index_lo_soc>duration)
                    lb=evalin('base','ess_pwr_req(1,2)');
                else
                    ub=evalin('base','ess_pwr_req(1,2)');
                end
                
                assignin('base','ess_pwr_req',[time 0.5*(lb+ub)*ones(size(time))]);
                evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
                
                index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
                index_lo_soc=min(find(evalin('base','ess_soc_hist')<=lo_soc));
                
                if (~isempty(index_v_min)&abs(index_v_min-duration)<0.5)|(~isempty(index_lo_soc)&abs(index_lo_soc-duration)<0.5)|(ub-lb)<0.001
                    loop=0;
                else
                    loop=1;
                end;
                %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
            end;
            %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
        end;
    else
        disp('ERROR: Lower bound too high.')
        failed_at_lb_e=1;
    end
    
    if ~exist('failed_at_ub_e')&~exist('failed_at_lb_e')
        if ~isempty(index_v_min)
            energy_cap=evalin('base',['trapz(ess_pwr_out_a(1:',num2str(index_v_min),...
                    '))/60/60*',num2str(max(time)/index_v_min)]);
        elseif ~isempty(index_lo_soc)
            energy_cap=evalin('base',['trapz(ess_pwr_out_a(1:',num2str(index_lo_soc),...
                    '))/60/60*',num2str(max(time)/index_lo_soc)]);
        end
    else 
        energy_cap=-1;
    end
    
else
    energy_cap=-1;
end


%%%%%%%%%%%%%%%%%%%%%%
% Calculate the max 18s pulse discharge power
%%%%%%%%%%%%%%%%%%%%%%

% Override workspace variables
assignin('base','ess_init_soc',lo_soc);

% Initialize
index_v_min=[];
index_lo_soc=[];
iter=0;
duration=dis_duration;
time=[0:(duration+ceil(0.01*duration))]'; % cycle duration

% set active bounds
lb=default_lb;
ub=default_ub;

% test lower bound
assignin('base','ess_pwr_req',[time lb*ones(size(time))]);
evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);

index_v_min=min(find(evalin('base','pb_voltage')<=v_min));

if (isempty(index_v_min)|index_v_min>duration)
    
    % test upper bound
    assignin('base','ess_pwr_req',[time ub*ones(size(time))]);
    evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
    
    index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
    
    if (isempty(index_v_min)|index_v_min>duration)
        disp('ERROR: Upper bound too low.')
        failed_at_ub_dis_pwr=1;
    else % loop to find power request that dicharges the module from lo soc to v_min in duration
        loop=1;
        while loop 
            if (isempty(index_v_min)|index_v_min>duration)
                lb=evalin('base','ess_pwr_req(1,2)');
            else
                ub=evalin('base','ess_pwr_req(1,2)');
            end
            
            assignin('base','ess_pwr_req',[time 0.5*(lb+ub)*ones(size(time))]);
            evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
            
            index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
            
            if ((ub-lb)<0.001)|(~isempty(index_v_min)&abs(index_v_min-duration)<0.5)
                loop=0;
            else
                loop=1;
            end;
            
            if loop==0&isempty(index_v_min)
                assignin('base','ess_pwr_req',[time (ub)*ones(size(time))]);
                evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
                
                index_v_min=min(find(evalin('base','pb_voltage')<=v_min));
            end
            
            %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
        end;
        %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
    end;
else
    disp('ERROR: Lower bound too high.')
    failed_at_lb_dis_pwr=1;
end;

if ~exist('failed_at_ub_dis_pwr')&~exist('failed_at_lb_dis_pwr')&~isempty(index_v_min)
    % return the max pwr at v min
    if ~isempty(index_v_min)
        dis_pwr=evalin('base',['ess_pwr_out_a(',num2str(index_v_min),')']);
    end
else
    dis_pwr=-1;
end

%%%%%%%%%%%%%%%%%%%%%%
% Calculate the max 2s regen power
%%%%%%%%%%%%%%%%%%%%%%

% Override workspace variables
assignin('base','ess_init_soc',hi_soc);

% Initialize
index_v_max=[];
index_lo_soc=[];
iter=0;
duration=regen_duration;
time=[0:(duration+ceil(0.01*duration))]'; % cycle duration

% set active bounds
lb=-default_lb;
ub=-default_ub;

% test lower bound
assignin('base','ess_pwr_req',[time lb*ones(size(time))]);
evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);

index_v_max=min(find(evalin('base','pb_voltage')>=v_max));

if (isempty(index_v_max)|index_v_max>duration)
    
    % test upper bound
    assignin('base','ess_pwr_req',[time ub*ones(size(time))]);
    evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
    
    index_v_max=min(find(evalin('base','pb_voltage')>=v_max));
    
    if (isempty(index_v_max)|index_v_max>duration)
        disp('ERROR: Upper bound too low.')
        failed_at_ub_regen_pwr=1;
    else % loop to find power request that charges the module from hi soc to v_max in duration
        loop=1;
        while loop 
            if (isempty(index_v_max)|index_v_max>duration)
                lb=evalin('base','ess_pwr_req(1,2)');
            else
                ub=evalin('base','ess_pwr_req(1,2)');
            end
            
            assignin('base','ess_pwr_req',[time -0.5*(abs(lb)+abs(ub))*ones(size(time))]);
            evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
            
            index_v_max=min(find(evalin('base','pb_voltage')>=v_max));
            
            if ((abs(ub-lb))<0.001)|(~isempty(index_v_max)&abs(index_v_max-duration)<0.5)
                loop=0;
            else
                loop=1;
            end;
            
            if loop==0&isempty(index_v_max)
                assignin('base','ess_pwr_req',[time (lb)*ones(size(time))]);
                evalin('base',['sim(''bd_ess_test'',',num2str(max(time)),')']);
                
                index_v_max=min(find(evalin('base','pb_voltage')>=v_max));
            end
            %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
        end;
        %disp(['pwr_req=',num2str(evalin('base','ess_pwr_req(1,2)'))])
    end;
else
    disp('ERROR: Lower bound too high.')
    failed_at_lb_regen_pwr=1;
end;

if ~exist('failed_at_ub_regen_pwr')&~exist('failed_at_lb_regen_pwr')&~isempty(index_v_max)
    % return the max pwr at v min
    if ~isempty(index_v_max)
        regen_pwr=evalin('base',['ess_pwr_out_a(',num2str(index_v_max),')']);
    end
else
    regen_pwr=-1;
end

%%%%%%%%%%%%%
%% Display results
%%%%%%%%%%%
if display_results
    disp(' ')
    disp('*** Battery Specifications ***')
    disp(' ')
    disp(['    ',num2str(dis_duration),'s Pulse Discharge Power..........: ', num2str(dis_pwr),' W'])
    disp(['    ',num2str(regen_duration),'s Pulse Regen Power...............: ', num2str(-regen_pwr),' W'])
    disp(['    C/',num2str(c_rate),' Energy Capacity................: ', num2str(energy_cap),' Wh'])
    disp(['    ',num2str(dis_duration),'s Discharge Power/Energy Ratio...: ', num2str(dis_pwr/energy_cap),' W/Wh'])
    disp(['    ',num2str(regen_duration),'s Regen Power/Energy Ratio........: ', num2str(-regen_pwr/energy_cap),' W/Wh'])
    disp(['    Specific Energy Capacity...........: ', num2str(energy_cap/evalin('base','ess_module_mass')),' Wh/kg'])
    disp(' ')
    disp(['    Low SOC.....................: ', num2str(lo_soc),' '])
    disp(['    High SOC....................: ', num2str(hi_soc),' '])
    %disp(['    Nom Voltage.................: ', num2str(evalin('base','mean(ess_voc)')),' V'])
    disp(['    Nom Voltage.................: ', num2str(evalin('base','mean(mean(ess_voc))')),' V'])
    disp(['    Min Voltage.................: ', num2str(v_min),' V'])
    disp(['    Max Voltage.................: ', num2str(v_max),' V'])
    disp(' ')
end


%%%%%%%%%%%%%%%%%%%%%
% RESTORE WORKSPACE
%%%%%%%%%%%%%%%%%%%%%
restore

return

%%%%%%%%%%
% subfunction section
%%%%%%%%%%

function store()
% Store current workspace variables
if evalin('base','exist(''ess_module_num'')')
    assignin('caller','default_ess_module_num',evalin('base','ess_module_num'));
end
if evalin('base','exist(''mc_min_volts'')')
    assignin('caller','default_mc_min_volts',evalin('base','mc_min_volts'));
end
if evalin('base','exist(''ess_min_volts'')')
    assignin('caller','default_ess_min_volts',evalin('base','ess_min_volts'));
end
if evalin('base','exist(''ess_max_volts'')')
    assignin('caller','default_ess_max_volts',evalin('base','ess_max_volts'));
end
if evalin('base','exist(''ess_init_soc'')')
    assignin('caller','default_ess_init_soc',evalin('base','ess_init_soc'));
end
if evalin('base','exist(''ess_th_calc'')')
    assignin('caller','default_ess_th_calc',evalin('base','ess_th_calc'));
end;
if evalin('base','exist(''cyc_mph'')')
    assignin('caller','default_cyc_mph',evalin('base','cyc_mph'));
end;
if evalin('base','exist(''amb_tmp'')')
    assignin('caller','default_amb_tmp',evalin('base','amb_tmp'));
end;
if evalin('base','exist(''air_cp'')')
    assignin('caller','default_air_cp',evalin('base','air_cp'));
end;
if evalin('base','exist(''ess_mod_init_tmp'')')
    assignin('caller','default_ess_mod_init_tmp',evalin('base','ess_mod_init_tmp'));
end;
if evalin('base','exist(''enable_stop'')')
    assignin('caller','default_enable_stop',evalin('base','enable_stop'));
end

return

function restore()
% restore workspace variables
if evalin('caller','exist(''default_ess_module_num'')')
    assignin('base','ess_module_num',evalin('caller','default_ess_module_num'));
else
    evalin('base','clear ess_module_num')
end
if evalin('caller','exist(''default_mc_min_volts'')')
    assignin('base','mc_min_volts',evalin('caller','default_mc_min_volts'));
else
    evalin('base', 'clear mc_min_volts')
end
if evalin('caller','exist(''default_ess_min_volts'')')
    assignin('base','ess_min_volts',evalin('caller','default_ess_min_volts'));
else
    evalin('base', 'clear ess_min_volts')
end
if evalin('caller','exist(''default_ess_max_volts'')')
    assignin('base','ess_max_volts',evalin('caller','default_ess_max_volts'));
else
    evalin('base', 'clear ess_max_volts')
end
if evalin('caller','exist(''default_ess_init_soc'')')
    assignin('base','ess_init_soc',evalin('caller','default_ess_init_soc'));
else
    evalin('base','clear ess_init_soc')
end
if evalin('caller','exist(''default_ess_th_calc'')')
    assignin('base','ess_th_calc',evalin('caller','default_ess_th_calc'));
else
    evalin('base','clear ess_th_calc')
end;
if evalin('caller','exist(''default_cyc_mph'')')
    assignin('base','cyc_mph',evalin('caller','default_cyc_mph'));
else
    evalin('base','clear cyc_mph')
end;
if evalin('caller','exist(''default_amb_tmp'')')
    assignin('base','amb_tmp',evalin('caller','default_amb_tmp'));
else
    evalin('base','clear amb_tmp')
end;
if evalin('caller','exist(''default_ess_mod_init_tmp'')')
    assignin('base','ess_mod_init_tmp',evalin('caller','default_ess_mod_init_tmp'));
else
    evalin('base','clear ess_mod_init_tmp')
end;
if evalin('caller','exist(''default_air_cp'')')
    assignin('base','air_cp',evalin('caller','default_air_cp'));
else
    evalin('base','clear air_cp')
end;
if evalin('caller','exist(''default_enable_stop'')')
    assignin('base','enable_stop',evalin('caller','default_enable_stop'));
else
    evalin('base','clear enable_stop')
end;

return

% revision history
% tm 7/23/01: added if statement around energy capicity section to only run if hi_soc greater than lo_soc - skips this step when your not interested in the energy capacity
