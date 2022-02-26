
%cut actual data to match simulation length (in case endtime<t_data(end))
endt=t(end);
endi=min(find(t_data>=endt));
t_data=t_data(1:endi);
volts_data=volts_data(1:endi);
current_data=current_data(1:endi);
pwr_data=pwr_data(1:endi);
ah_data=ah_data(1:endi);
temp_data=temp_data(1:endi);

%ADV model
%model=[t ess_current pb_voltage ess_pwr_out_a ess_soc_hist ess_temperature];

%Pick plots to show
subplots=1;
ieplot=0; 	%plot current error
veplot=0; 	%plot voltage error
pveplot=1;	%plot percentage voltage error
iplot=1;		%plot current
vplot=1;		%plot voltage
pplot=1;		%plot power
actplot=0;	%plot actual and model
socplot=1;	%plot soc comparison

if ieplot
    %interpolate the model at the test evaluation points
    modelI=interp1(model(:,1),model(:,2),t_data);    
    for i=5:length(modelI)
        errorI(i-4)=abs(mean(current_data(i-4:i))-mean(modelI(i-4:i)));
    end
    avgEI=mean(errorI);
    stdEI=std(errorI);
    %plot I errors
    figure; 
    hold on; zoom on;
    plot(t_data(5:end),errorI,'b');
    plot([0 t_data(end)],[avgEI avgEI],'r');
    plot([0 t_data(end)],[avgEI+stdEI avgEI+stdEI],'k');
    xlabel('Time (sec)');
    ylabel('Current Error abs(actual-model)');
    title(['Current error Avg: ', num2str(avgEI),' Std: ',num2str(stdEI)]);
    legend('error','avg','std');
end

%voltage error, mean, std
modelV=interp1(model(:,1),model(:,3),t_data);
if veplot
    errorV=abs(volts_data-modelV);
    for i=5:length(modelV)
        errorV(i-4)=abs(mean(volts_data(i-4:i))-mean(modelV(i-4:i)));
    end
    errorV=errorV(5:end);
    avgEV=mean(errorV);
    stdEV=std(errorV);
    %plot V errors
    figure; 
    hold on; zoom on;
    plot(t_data(5:end),errorV,'b');
    plot([0 t_data(end)],[avgEV avgEV],'r--');
    plot([0 t_data(end)],[avgEV+stdEV avgEV+stdEV],'k:');
    xlabel('Time (sec)');
    ylabel('Voltage Error abs(actual-model)');
    title(['Voltage error Avg: ', num2str(avgEV),' Std: ',num2str(stdEV)]);
    legend('error','avg','std');
end

if pveplot
    lowPind=find(abs(pwr_data)<=300); %low power indices (<=300W)
    highPind=find(abs(pwr_data)>300); %high power indices (>300W)
    lowIV=[current_data(lowPind) volts_data(lowPind)];
    lowmodelV=modelV(lowPind);
    highIV=[current_data(highPind) volts_data(highPind)];
    highmodelV=modelV(highPind);
    %low Power percent error-voltage
    for i=5:length(lowmodelV)
        lPperrorV(i-4)=abs(mean(lowIV(i-4:i,2))-mean(lowmodelV(i-4:i)))/abs(mean(lowIV(i-4:i,2)))*100;
    end
    lPpavgEV=mean(lPperrorV);
    lPpstdEV=std(lPperrorV);
    disp(['Low Power (mag<300W) Error.  Avg: ',num2str(lPpavgEV),'%, Std: ',num2str(lPpstdEV),'%']);
    
    if highPind
        %high Power percent error-voltage
        if length(highPind)>5
            for i=5:length(highmodelV)
                hPperrorV(i-4)=abs(mean(highIV(i-4:i,2))-mean(highmodelV(i-4:i)))/abs(mean(highIV(i-4:i,2)))*100;
            end
            hPpavgEV=mean(hPperrorV);
            hPpstdEV=std(hPperrorV);
            disp(['High Power (mag>300W) Error.  Avg: ',num2str(hPpavgEV),'%, Std: ',num2str(hPpstdEV),'%']);
        end
    end
    
    %percent error-voltage
    for i=5:length(modelV)
        perrorV(i-4)=abs(mean(volts_data(i-4:i))-mean(modelV(i-4:i)))/abs(mean(volts_data(i-4:i)))*100;
    end
    pavgEV=mean(perrorV);
    pstdEV=std(perrorV);
    
    %plot V perror
    if subplots, figure;subplot(2,2,1),else    figure; end
    hold on; zoom on;
    plot(t_data(5:end),perrorV,'b');
    plot([0 t_data(end)],[pavgEV pavgEV+eps] ,'r--');
    plot([0 t_data(end)],[pavgEV+pstdEV pavgEV+pstdEV+eps],'k:');
    xlabel('Time (sec)');
    ylabel('Voltage Error Percentage');
    title(['Avg: ', num2str(round(pavgEV*100)/100),'% Std: ',num2str(round(pstdEV*100)/100),'% Max: ',num2str(max(round(perrorV*100)/100))]);
    legend('error','avg','std');
end


%Plot comparison
if iplot
    %current
    if subplots, subplot(2,2,2),else    figure; end
    hold on;zoom on;
    xlabel('Time (sec)');
    ylabel('Current (A)');
    plot(t_data,current_data,'b');
    plot(model(:,1),model(:,2),'k');
    legend('actual','model',0);
end

if vplot
    %voltage
    if subplots, subplot(2,2,3),else    figure; end
    hold on;zoom on;
    xlabel('Time (sec)');
    ylabel('Volts (V)');
    plot(t_data,volts_data,'b');
    plot(model(:,1),model(:,3),'k');
    legend('actual','model',0);
end

if pplot
    %power
    if subplots, subplot(2,2,4),else    figure; end
    hold on;zoom on;
    xlabel('Time (sec)');
    ylabel('Power (W)');
    plot(t_data,pwr_data,'b');
    plot(model(:,1),model(:,4),'k');
    legend('cmd','model',0);
end

if actplot
    %actual
    figure;
    subplot(2,1,1),
    hold on;zoom on;
    %xlabel('Time (sec)');
    title('Actual');
    plot(t_data,pwr_data/100,'b');
    plot(t_data,current_data/10,'k');
    plot(t_data,volts_data,'r');
    legend('P/100','I/10','V',0);
    
    %model
    %figure;
    subplot(2,1,2),
    hold on;zoom on;
    xlabel('Time (sec)');
    title('Model');
    plot(model(:,1),model(:,4)/100,'b');
    plot(model(:,1),model(:,2)/10,'k');
    plot(model(:,1),model(:,3),'r');
    legend('P/100','I/10','V',0);
end

if socplot
    %create SOC based on Ah data
    %SOC=(6.67+ah_data)/6.67;   %for 25C ah data
    %SOC=(6.67+ah_data)/6.67-.535;   %for 0C ah dat
    %SOC=(6.67+ah_data)/6.67-.4575;   %for 40C ah dat
    max_cap=6.5;    %6.5 Panasonic, 6.67 Saft
    SOC(1)=ess_init_soc;
    ah_calc(1)=max_cap*(1-ess_init_soc);
    for i=2:length(t_data)
        %ah_calc(i)=ah_calc(i-1)+current_data(i)*(t_data(i)-t_data(i-1))/3600;
        if current_data(i)<0
            ah_calc(i)=ah_calc(i-1)+(current_data(i)*(t_data(i)-t_data(i-1))/3600)*0.9;
        else
            ah_calc(i)=ah_calc(i-1)+current_data(i)*(t_data(i)-t_data(i-1))/3600;
        end
    end
    SOC=(max_cap-ah_calc)/max_cap;
    %SOC
    figure;hold on;zoom on;
    xlabel('Time (sec)');
    ylabel('SOC (-)');
    plot(t_data,SOC,'b');
    plot(model(:,1),model(:,5),'k');
    text(model(end,1)*0.8,end_soc*1.05,{'Experimental SOC','after 1 hr rest:' num2str(round(end_soc*1000)/1000)})
    plot(model(end,1)+50,end_soc,'r*')
    legend('Expmt Est','Model','End SOC',0);
end

%Revision history
%03/19/01: vhj created from validate_rc