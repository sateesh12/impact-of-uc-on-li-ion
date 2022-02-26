% Use 'Hybrid Pulse Power Characterization' data to process model
% parameters for ADVISOR's RC model and PNGV Battery Model (same model as in PSAT)
% 
%
debugvhj=1;
plots=1;
proccess_rawdata=1;
saft_verify=0;
run_opt=1;

global binf

if proccess_rawdata
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Data
    time=binf.RC.data(:,1);
    current=-1*binf.RC.data(:,2); %use pos=charge, as ADVISOR convention (in data neg current=discharge)
    voltage=binf.RC.data(:,3);
    amphours=binf.RC.data(:,4);
    Temperature=mean(binf.RC.data(:,5));	%mean temperature
    power=current.*voltage; 
    
    if 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Find offset time in comparing current and voltage
        dV_dt_thresh=0.008; %change in voltage over time theshhold
        avgt=2; %seconds over which to average
        beginind=max(find(time<=avgt))+1;  %index at which to begin searching
        for i=1:length(voltage)-1
            not_chg_dis=abs(current(i))<thresh;
            chg_dis_next=current(i+1)<-thresh | current(i+1)>thresh;
            begincd=not_chg_dis & chg_dis_next; %begin a charge or discharge
            if begincd
                % Current indicated a beginning of a dis or charge
                % Backtrack on voltage to find where it began to change substantially,
                % then adjust current according to the difference in time
                for j=i:-1:1
                    prev_t_index=max(find(time<=time(j)-avgt));
                    dV_dt=(voltage(j)-voltage(prev_t_index))/avgt; %average dV/dt
                end
                %current=;
                break
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialization
    %Find start/stop points
    indb=[];    %begin index
    inde=[];    %end index
    beginind=1;%max(find(time<=avgt))+1;  %index at which to begin searching
    thresh=0.1; %current threshold for finding beginnings/endings
    
    for i=beginind:length(voltage)-1
        if ~mod(i,5000) %Display status every 2500 points
            disp(['Processing begin/end points: ',num2str(i),' of ',num2str(length(voltage))]);
        end
        
        %To be used in logic below to determine beginning and end points
        not_chg_dis=abs(current(i))<thresh;
        not_chg_dis_next=abs(current(i+1))<thresh;
        chg_dis_next=current(i+1)<-thresh | current(i+1)>thresh;
        chg_dis=current(i)<-thresh | current(i)>thresh;
        begincd=not_chg_dis & chg_dis_next; %begin a charge or discharge
        endcd=not_chg_dis_next & chg_dis;   %end a charge or discharge
        
        %beginning point
        if begincd
            % if adding a beginning, make sure an end has been reached, otherwise write over 
            % previous beginning
            if ~isempty(indb) & ~isempty(inde)
                if inde(end)<indb(end)
                    indb(end)= i; %find where discharge/charge current begins, overwriting last
                else
                    indb(end+1)=i; %find where discharge/charge current begins
                end
            else
                indb(1)=i; %find discharge/charge current
            end
        elseif endcd
            %ending point   
            if ~isempty(indb)	%begin point must exist (if try to end the charging before first begin point, don't use)
                if ~isempty(inde) & inde(end)>indb(end) %if two ends found before a beginning is found,
                    inde(end)=i; 				 %overwrite last (multiple ends)
                elseif isempty(inde)
                    inde(1)=i;  %case for first input in vector
                else
                    inde(end+1)=i; %find where discharge/charge current ends
                end
            end
        end
    end
    
    %Cleanup of begin/end points
    if indb(end)>inde(end)	%if 'begin' a charge but don't end it at the end, elim this begin point
        indb=indb(1:end-1);
    end
    assignin('base','indb',indb);   assignin('base','inde',inde);
    
    %Assign pulse time=first pulse time
    %tpulse=time(inde(1))-time(indb(1));	%time of first pulse (used to elminate shorter & longer pulses)
    tpulse=18;	%time of pulse (used to elminate shorter & longer pulses)
    %Additional pulse lengths
    extra_tpulses=[4 2 10];
    all_tpulses=[tpulse extra_tpulses];
    pulseind=[]; pulseind_new=[];
    binf.RC.badpulses=['Rint pulse lengths desired (+-10%): ', num2str(round(all_tpulses*100)/100),];
    binf.RC.badpulses=strvcat(binf.RC.badpulses,'The following points are thrown out:');
    
    %Find HPPC pulse begin/end indices
    for i=1:length(indb)
        %this eliminates the pulses which drop the SOC and are intended to simply drop the SOC
        tpactual=time(inde(i))-time(indb(i)); %actual pulse length
        %condition for a good pulse length
        tpulsegood=0;
        for j=1:length(all_tpulses)
            if tpactual<=1.10*all_tpulses(j) & tpactual>=0.9*all_tpulses(j)
                tpulsegood=1;
            end
        end
        if tpulsegood
            if isempty(pulseind), pulseind(1,:)=[indb(i) inde(i)]; %case of first entry
            else,pulseind(end+1,:)=[indb(i) inde(i)];end
        else
            %Document why the point was rejected (outside of pulselength)
            %Mark pulse at time of begin index, thrown out because out of +-10% of pulsewidth
            binf.RC.badpulses=strvcat(binf.RC.badpulses,['t begin: ',num2str(round(time(indb(i))/60*100)/100),...
                    ' tpulse actual: ',num2str(round(100*(time(inde(i))-time(indb(i))))/100)]);
        end
    end
    %Extract sections over which to determine RC parameters
    %For HPPC: go from beginning of 18 second pulse to end of last 4 sec charge pulse
    %colums=[start endofdis startchg end]
    for i=1:length(pulseind)-1
        tpactual=(time(pulseind(i,2))-time(pulseind(i,1)));
        if tpactual<=1.10*tpulse & tpactual>=0.9*tpulse    %e.g. 18 sec
            % go to the end (column 2) of the next begin/end point (e.g. i+1)
            if isempty(pulseind_new),pulseind_new(1,:)=[pulseind(i,1) pulseind(i,2) pulseind(i+1,1) pulseind(i+1,2)];%first entry
            else,pulseind_new(end+1,:)=[pulseind(i,1) pulseind(i,2) pulseind(i+1,1) pulseind(i+1,2)];end  
        end
    end
    
    if debugvhj
        figure;hold on; zoom on;
        plot(binf.RC.data(:,1),binf.RC.data(:,2),'b');						%current
        plot(binf.RC.data(:,1),binf.RC.data(:,4),'k');						%Ahrs
        plot(binf.RC.data(:,1),binf.RC.data(:,3),'g');						%voltage
        plot(binf.RC.data(indb,1),binf.RC.data(indb,3),'ro'); %indb on voltage
        plot(binf.RC.data(inde,1),binf.RC.data(inde,3),'ko'); %inde on voltage
        xlabel('Time (sec)');
        ylabel('Data');
        title('Beginning and Ending points')
        plot(binf.RC.data(pulseind_new(:,1),1),binf.RC.data(pulseind_new(:,1),3),'rx'); %indb
        plot(binf.RC.data(pulseind_new(:,4),1),binf.RC.data(pulseind_new(:,4),3),'kx'); %inde
        plot(binf.RC.data(indb,1),binf.RC.data(indb,2),'ro'); %indb on current
        plot(binf.RC.data(inde,1),binf.RC.data(inde,2),'ko'); %inde on current
        legend('Current','Ah','Voltage','begin','end','begin model','end model',-1)
    end
    
    binf.RC.pulseind_new=pulseind_new;
    waitbar(.25);
end   

%Constant inputs for simulations
%Thermal/limit/mass parameters as input from user are already in the workspace
%ess_min_volts,ess_max_volts,ess_module_mass, ess_mod_cp,
%ess_set_tmp,ess_mod_sarea,ess_mod_airflow,ess_mod_flow_area
%ess_mod_case_thk, ess_mod_case_th_cond
evalin('base','ess_th_calc=1;');  % --     0=no ess thermal calculations, 1=do calc's
%calculations with input data
evalin('base','ess_air_vel=binf.RC.ess_mod_airflow/(1.16*binf.RC.ess_mod_flow_area);'); % m/s  ave velocity of cooling air
evalin('base','ess_air_htcoef=30*(ess_air_vel/5)^0.8;');      % W/m^2K cooling air heat transfer coef.
evalin('base','ess_th_res_on=((1/ess_air_htcoef)+(binf.RC.ess_mod_case_thk/binf.RC.ess_mod_case_th_cond))/binf.RC.ess_mod_sarea;'); % K/W  tot thermal res key on
evalin('base','ess_th_res_off=((1/4)+(binf.RC.ess_mod_case_thk/binf.RC.ess_mod_case_th_cond))/binf.RC.ess_mod_sarea;'); % K/W  tot thermal res key off (cold soak)
% set bounds on flow rate and thermal resistance
evalin('base','ess_mod_airflow=max(binf.RC.ess_mod_airflow,0.001); ');
evalin('base','ess_th_res_on=min(ess_th_res_on,ess_th_res_off);'); 
%Other variables referenced in block diagram
assignin('base','amb_tmp',20);
assignin('base','air_cp',1009);
assignin('base','mc_min_volts',0);  %ignore this condition
evalin('base','cyc_mph(1,2)=3;');  %for thermal model
%SOC from data
ess_soc_data=binf.VOC.ess_soc/100;
ess_voc_data=binf.VOC.ess_voc;
ess_tmp=[1 1.01]*Temperature;
ess_soc=ess_soc_data;
ess_voc=[ess_voc_data;ess_voc_data];
assignin('base','ess_soc',ess_soc);
assignin('base','ess_tmp',ess_tmp);
assignin('base','ess_voc',ess_voc);

%evalin('base','ess_li7_temp_rc');   %load this for thermal params
if 1    %just for validation of SOC
    %evalin('base','ess_soc_old=[0 10 20 40 60 80 100]/100;  % (--)	');
    evalin('base','ess_tmp_old=[0 25 41];  % (C)');
    % Parameters vary by SOC horizontally, and temperature vertically
    evalin('base','ess_max_ah_cap_old=[5.943 7.035 7.405];');
    % (A*h), max. capacity at C/3 rate, indexed by ess_tmp
    % average coulombic (a.k.a. amp-hour) efficiency below, indexed by ess_tmp
    evalin('base','ess_coulombic_eff_old=[0.968 0.99 0.992];  % (--)');
    % module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
    %evalin('base','ess_voc_old=[3.44 3.473 3.496 3.568 3.637 3.757 3.896;3.124 3.349 3.433 3.518 3.616 3.752 3.898;3.128 3.36 3.44 3.528 3.623 3.761 3.899]; % (V)');
end

%Process points to find RC parameters
[a,b]=size(pulseind_new);
for i=1:a    %loop through each HPPC test
    disp(['Processing data to determine parameters, Set#',num2str(i),'/',num2str(a)]);
    %Get indices for start and end
    idx1=pulseind_new(i,1); %index of start point
    idx2=pulseind_new(i,2); %index of end of discharge point
    idx3=pulseind_new(i,3); %index of begin charge point
    idx4=pulseind_new(i,4); %index of end of charge point
    
    %Find SOC at beginning: use initial voltage point and previously determined
    %SOC-OCV relationship
    if voltage(idx1)>max(ess_voc_data), SOC=1;
    elseif voltage(idx1)<min(ess_voc_data), SOC=0;
    else
        SOC=interp1(ess_voc_data,ess_soc_data,voltage(idx1));
    end
    
    %Initial guesses for parameters
    offset2=3;
    Rbulk2=(voltage(idx2+offset2)-voltage(idx2))/(current(idx2));
    Rbulk1=(voltage(idx1)-voltage(idx1+offset2))/(current(idx1+offset2));
    %Rbulk=(Rbulk1+Rbulk2)/2;
    Rbulk=Rbulk1;
    factor=1;
    re=Rbulk/(1.244);
    rt=Rbulk/1.368*factor;
    rc=Rbulk/3.732*factor;
    offset=1;
    Vfinal=(2*voltage(idx1)+voltage(idx3))/3;
    tau=-1*(time(idx3)-time(idx2+offset))*log(1-(voltage(idx3)-voltage(idx2+offset))/(Vfinal-voltage(idx2+offset)));
    %cc=.5*tau/(re+rt);
    cc=tau/(re+rt);
    Vmax=max(max(ess_voc_data));
    Vmin=min(min(ess_voc_data));
    energy=binf.RC.ratedAh*Vmax*3600;    %energy of battery in J
    %energy=binf.RC.ratedAh*(Vmax+Vmin)/2*3600;    %energy of battery in J
    %energy=binf.RC.ratedAh*(Vmin)*3600;    %energy of battery in J
    %cb=0.4*energy/(0.5*(Vmax^2-Vmin^2));
    cb=energy/(0.5*(Vmax^2-Vmin^2));
        
    %Set parameters to be used for model simulation in the creation of parameters
    %Variables to specify to use create_rc_params.mdl:
    %Input: current_data, ess_init_soc, cc, cb, re, rc, rt

    %Variable inputs
    assignin('base','time_data',time(idx1:idx4));
    assignin('base','current_data',current(idx1:idx4));
    assignin('base','power_data',power(idx1:idx4));
    assignin('base','ess_init_soc',SOC);
    assignin('base','ess_mod_init_tmp',Temperature);
    assignin('base','starttime',time(idx1));
    assignin('base','endtime',time(idx4));
    %Output variables: pb_voltage, ess_soc_hist, ess_soc_hist_old, ess_pwr_out_a,
    %                   ess_current, ess_temperature

    if run_opt
        %Call to optimize and find best parameters
        [OptParams, ErrorAvgMax]=battery_params(re,rc,rt,cb,cc,time,voltage,idx1,idx4);
        [re]=OptParams(1);
        [rc]=OptParams(2);
        [rt]=OptParams(3);
        [cb]=OptParams(4);
        [cc]=OptParams(5);
        [avg_perror]=ErrorAvgMax(1);
        [max_perror]=ErrorAvgMax(2);
        
        disp(['Re: ',num2str(round(re*100000)/100),' mOhms, Rc: ',num2str(round(rc*100000)/100),...
                ', Rt: ',num2str(round(rt*100000)/100),...
                ' Cc: ',num2str(round(cc/100)/10),' kF, Cb:',num2str(round(cb/100)/10)])
    else,
        if i==1,disp('Note: Optimization turned off.  To turn on, set run_opt in process_HPPC to 1.');end
    end
    
    % rerun at optim points
    %Assign paremeters
    assignin('base','cb',cb);
    assignin('base','cc',cc);
    assignin('base','re',re);
    assignin('base','rt',rt);
    assignin('base','rc',rc);
    
    %Run a simulation
    disp(['Running Final Optimal Simulation, Set#',num2str(i),'/',num2str(a)]);
    evalin('base',['sim(''create_rc_params_Preq'');']);
    
    %Compute Error
    t=evalin('base','t'); pb_voltage=evalin('base','pb_voltage');
    pb_voltage4e=interp1(t,pb_voltage,time(idx1+1:idx4-1));   %voltage for error calculation
    perror=abs(voltage(idx1+1:idx4-1)-pb_voltage4e)./voltage(idx1+1:idx4-1)*100;
    avg_perror=mean(perror);
    max_perror=max(perror);
    
    %Compare predictions to data
    if plots
        %if i==1,
            figure;
            %end
        %Voltage plot
        subplot(2,1,1), hold on;
        %plot(time(idx1:idx4),current(idx1:idx4),'b');
        plot(time(idx1:idx4),voltage(idx1:idx4),'r');
        %plot(t,ess_current,'b:');
        plot(t,pb_voltage,'r:');
        title(['SOC: ',num2str(round(SOC*100)/100),' Re: ',num2str(round(re*100000)/100),' mOhms, Rc: ',num2str(round(rc*100000)/100),...
                ', Rt: ',num2str(round(rt*100000)/100),...
                ' Cc: ',num2str(round(cc/100)/10),' kF, Cb:',num2str(round(cb/100)/10)])
        %legend('Current Data','Voltage Data','Current Model','Voltage Model',-1)
        ylabel('Voltage');
        legend('Voltage Data','Voltage Model',-1)
        
        %Error Plot
        subplot(2,1,2);hold on;
        plot(time(idx1+1:idx4-1),perror,'b');   %error
        plot([time(idx1) time(idx4)],[avg_perror avg_perror*1.001],'r-');   %average error
        plot([time(idx1) time(idx4)],[max_perror max_perror*1.001],'k:');   %max error
        xlabel('Time (sec)');
        ylabel('Absolute Percentage Error');
        legstr={'% Abs Error',['Avg ',num2str(round(avg_perror*100)/100)],['Max: ',num2str(round(max_perror*100)/100)]};
        legend(legstr,-1)
    end
    
    SOC_data(i)=SOC;
    Re_data(i)=re;
    Rc_data(i)=rc;
    Rt_data(i)=rt;
    Cb_data(i)=cb;
    Cc_data(i)=cc;
    AvgPerror(i)=avg_perror;
    MaxPerror(i)=max_perror;
    
    waitbar(0.25+0.8*(i/a));

end

if debugvhj
    %Record parameter and SOC values
    %data
    binf.RC.SOC_data=SOC_data;
    binf.RC.Re_data=Re_data;
    binf.RC.Rc_data=Rc_data;
    binf.RC.Rt_data=Rt_data;
    binf.RC.Cb_data=Cb_data;
    binf.RC.Cc_data=Cc_data;
    binf.RC.temperature=Temperature;
    binf.RC.AvgPerror=AvgPerror;
    binf.RC.MaxPerror=MaxPerror;
end


%Sort the data in increasing SOC order
tmp_vec=[SOC_data' Re_data' Rc_data' Rt_data' Cb_data' Cc_data'];
tmp_vec=sortrows(tmp_vec,1);
SOC_data=tmp_vec(:,1);
for i=2:length(SOC_data)
    if SOC_data(i)==SOC_data(i-1)   %case where have >1 data point for same SOC
        SOC_data(i)=SOC_data(i)*1.0001; %increment slightly.  This is required for interp1 below
    end
end
Re_data=tmp_vec(:,2);
Rc_data=tmp_vec(:,3);
Rt_data=tmp_vec(:,4);
Cb_data=tmp_vec(:,5);
Cc_data=tmp_vec(:,6);

%Process data points for values in model
min_soc=round(min(SOC_data)*10)/10;
min_soc=max(min_soc,.2);
max_soc=round(max(SOC_data)*10)/10;
max_soc=min(max_soc,.8);
ess_soc=[0:.2:min_soc-.2 min_soc:.05:max_soc max_soc+.2:.2:1];
if ess_soc(end)<1, ess_soc(end+1)=1;end
%Recalculate ess_voc for ess_soc values determined here
new_ess_voc=interp1(binf.VOC.ess_soc./100,binf.VOC.ess_voc,ess_soc);
binf.VOC.ess_voc=new_ess_voc;
binf.VOC.ess_soc=ess_soc*100;
%ess_soc=binf.VOC.ess_soc/100;
ess_re=round(interp1(SOC_data,Re_data,ess_soc).*1000000)/1000000;   %3 sig figs
ess_rc=round(interp1(SOC_data,Rc_data,ess_soc).*1000000)/1000000;
ess_rt=round(interp1(SOC_data,Rt_data,ess_soc).*1000000)/1000000;
ess_cb=round(interp1(SOC_data,Cb_data,ess_soc));
ess_cc=round(interp1(SOC_data,Cc_data,ess_soc));

%Set NaN's to closest value
var_names={'ess_re','ess_rc','ess_rt','ess_cb','ess_cc'};
for j=1:length(var_names)
    eval(['x=',var_names{j},';'])
    for i=1:length(x), 
        if isnan(x(i))&i<length(x)/2,
            x(i)=x(min(find(~isnan(x))));
        elseif isnan(x(i))&i>=length(x)/2,
            x(i)=x(max(find(~isnan(x))));
        end
    end
    eval([var_names{j},'=x;'])
end

%Record parameter and SOC values
%data
binf.RC.SOC_data=SOC_data;
binf.RC.Re_data=Re_data;
binf.RC.Rc_data=Rc_data;
binf.RC.Rt_data=Rt_data;
binf.RC.Cb_data=Cb_data;
binf.RC.Cc_data=Cc_data;
binf.RC.temperature=Temperature;
binf.RC.AvgPerror=AvgPerror;
binf.RC.MaxPerror=MaxPerror;
%model
binf.RC.ess_soc=ess_soc;
binf.RC.ess_re=ess_re;
binf.RC.ess_rc=ess_rc;
binf.RC.ess_rt=ess_rt;
binf.RC.ess_cb=ess_cb;
binf.RC.ess_cc=ess_cc;

process_data('',1); %calls results fig (in turn calling rc_results)

%close the 'lost' waitbar
try,evalin('base','set(0,''showhiddenhandles'',''on'')');
evalin('base','close(findobj(''tag'',''TMWWaitbar''))');end

% Revision history
% 01/03/01: vhj file created
% 02/22/01: vhj adjust current to align with voltage measurements (don't need for now)
% 02/28/01: vhj added initial guesses for parameters, corrected soc from binf: ess_soc=binf.VOC.ess_soc/100
% 03/13/01: vhj call to rc_results, round model to 3 sig figs (milliohms and kFarads), binf.Rint->binf.RC
% 03/15/01: vhj new SOC limits, add 1 to end of VOC soc
% 03/22/01: vhj added power calculated from data