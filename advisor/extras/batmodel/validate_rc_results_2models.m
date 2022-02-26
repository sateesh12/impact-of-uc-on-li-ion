
%cut actual data to match simulation length (in case endtime<t_data(end))
endt=t(end);
endi=min(find(t_data>=endt));
t_data=t_data(1:endi);
volts_data=volts_data(1:endi);
current_data=current_data(1:endi);
pwr_data=pwr_data(1:endi);
ah_data=ah_data(1:endi);
temp_data=temp_data(1:endi);

%RC model
%model1=[t ess_current pb_voltage ess_pwr_out_a ess_soc_hist ess_temperature];
%model=model1;
%Rint model
%model2=[t ess_current pb_voltage ess_pwr_out_a ess_soc_hist ess_temperature];

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
    modelI1=interp1(model1(:,1),model1(:,2),t_data);
    modelI2=interp1(model2(:,1),model2(:,2),t_data);
    for i=5:length(modelI1)
        errorI1(i-4)=abs(mean(current_data(i-4:i))-mean(modelI1(i-4:i)));
    end
    for i=5:length(modelI2)
        errorI2(i-4)=abs(mean(current_data(i-4:i))-mean(modelI2(i-4:i)));
    end
    avgEI1=mean(errorI1);
    stdEI1=std(errorI1);
    avgEI2=mean(errorI2);
    stdEI2=std(errorI2);
    %plot I errors
    figure; 
    hold on; zoom on;
    plot(t_data(5:end),errorI1,'b');
    plot([0 t_data(end)],[avgEI1 avgEI1],'r');
    plot([0 t_data(end)],[avgEI1+stdEI1 avgEI1+stdEI1],'k');
    plot(t_data(5:end),errorI2,'b:');
    plot([0 t_data(end)],[avgEI2 avgEI2],'r:');
    plot([0 t_data(end)],[avgEI2+stdEI2 avgEI2+stdEI2],'k:');
    xlabel('Time (sec)');
    ylabel('Current Error abs(actual-model)');
    title(['Current error RC Avg: ', num2str(round(avgEI1*10)/10),' Std: ',num2str(round(stdEI1*10)/10),' Rint Avg: ', num2str(round(avgEI2*10)/10),' Std: ',num2str(round(stdEI2*10)/10)]);
    legend('RC error','RC avg','RC std','Rint error','Rint avg','Rint std');
end

%voltage error, mean, std
modelV=interp1(model(:,1),model(:,3),t_data);
modelV2=interp1(model2(:,1),model2(:,3),t_data);
if veplot
   errorV=abs(volts_data-modelV);
   for i=5:length(modelV)
      errorV(i-4)=abs(mean(volts_data(i-4:i))-mean(modelV(i-4:i)));
   end
   errorV=errorV(5:end);
   avgEV=mean(errorV);
   stdEV=std(errorV);
   %#2
   errorV2=abs(volts_data-modelV2);
   for i=5:length(modelV2)
      errorV2(i-4)=abs(mean(volts_data(i-4:i))-mean(modelV2(i-4:i)));
   end
   errorV2=errorV2(5:end);
   avgEV2=mean(errorV2);
   stdEV2=std(errorV2);
   %plot V errors
   figure; 
   %%subplot(2,2,2),
   hold on; zoom on;
   plot(t_data(5:end),errorV,'b');
   plot([0 t_data(end)],[avgEV avgEV],'r');
   plot([0 t_data(end)],[avgEV+stdEV avgEV+stdEV],'k');
   plot(t_data(5:end),errorV2,'b:');
   plot([0 t_data(end)],[avgEV2 avgEV2],'r:');
   plot([0 t_data(end)],[avgEV2+stdEV2 avgEV2+stdEV2],'k:');
   xlabel('Time (sec)');
   ylabel('Voltage Error abs(actual-model)');
   title(['Voltage error RC Avg: ', num2str(round(avgEV*10)/10),' Std: ',num2str(round(stdEV*10)/10),' Rint Avg: ', num2str(round(avgEV2*10)/10),' Std: ',num2str(round(stdEV2*10)/10)]);
   legend('RC error','RC avg','RC std','Rint error','Rint avg','Rint std');
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
   pavgEV=mean(perrorV(1:end-1));
   pstdEV=std(perrorV(1:end-1));
   %#2
   for i=5:length(modelV2)
      perrorV2(i-4)=abs(mean(volts_data(i-4:i))-mean(modelV2(i-4:i)))/abs(mean(volts_data(i-4:i)))*100;
   end
   pavgEV2=mean(perrorV2(1:end-1));
   pstdEV2=std(perrorV2(1:end-1));
   
   %plot V perror
   if subplots, figure;subplot(2,2,1),else    figure; end
   hold on; zoom on;
   plot(t_data(5:end),perrorV,'b');
   plot([0 t_data(end)],[pavgEV pavgEV+eps] ,'r');
   plot([0 t_data(end)],[pavgEV+pstdEV pavgEV+pstdEV+eps],'k');
   plot(t_data(5:end),perrorV2,'b:');
   plot([0 t_data(end)],[pavgEV2 pavgEV2+eps] ,'r:');
   plot([0 t_data(end)],[pavgEV2+pstdEV2 pavgEV2+pstdEV2+eps],'k:');
   xlabel('Time (sec)');
   ylabel('Voltage Error Percentage');
   title(['RC (Avg,Std,Max): ', num2str(round(pavgEV*10)/10),',',num2str(round(pstdEV*10)/10),',',num2str(round(max(perrorV)*10)/10),' Rint: ', num2str(round(pavgEV2*10)/10),',',num2str(round(pstdEV2*10)/10),',',num2str(round(max(perrorV2)*10)/10)]);
   legend('RC error','RC avg','RC std','Rint error','Rint avg','Rint std',-subplots);
end


%Plot comparison
if iplot
   %current
    if subplots, subplot(2,2,2),else    figure; end
   hold on;zoom on;
   xlabel('Time (sec)');
   ylabel('Current (A)');
   %title('Current comparison over Modified US06 cycle');
   plot(t_data,current_data,'b');
   plot(model(:,1),model(:,2),'k:');
   plot(model2(:,1),model2(:,2),'r-.');
   legend('Experiment','RC model','Rint model',-subplots);
end

if vplot
   %voltage
    if subplots, subplot(2,2,3),else    figure; end
   hold on;zoom on;
   xlabel('Time (sec)');
   ylabel('Volts (V)');
   %title('Voltage comparison over Modified US06 cycle');
   plot(t_data,volts_data,'b');
   plot(model(:,1),model(:,3),'k:');
   plot(model2(:,1),model2(:,3),'r-.');
   legend('Experiment','RC model','Rint model',-subplots);
end

if pplot
   %power
    if subplots, subplot(2,2,4),else    figure; end
   hold on;zoom on;
   xlabel('Time (sec)');
   ylabel('Power (W)');
   %title('Power comparison over Modified US06 cycle');
   plot(t_data,pwr_data,'b');
   if 0 %actual
      plot(t_data,current_data.*volts_data,'r:');
   end
   plot(model(:,1),model(:,4),'k:');
   plot(model2(:,1),model2(:,4),'r-.');
   if 0
      legend('actual cmd','actual ach','RC model','Rint model',-subplots);
   else
      legend('Experiment','RC model','Rint model',-subplots);
   end   
end

if actplot
   %actual
   figure;
   subplot(3,1,1),
   hold on;zoom on;
   %xlabel('Time (sec)');
   title('Actual');
   plot(t_data,pwr_data/100,'b');
   plot(t_data,current_data/10,'k');
   plot(t_data,volts_data,'r');
   legend('P/100','I/10','V',0);
   
   %model
   %figure;
   subplot(3,1,2),
   hold on;zoom on;
   xlabel('Time (sec)');
   title('RC Model');
   plot(model(:,1),model(:,4)/100,'b');
   plot(model(:,1),model(:,2)/10,'k');
   plot(model(:,1),model(:,3),'r');
   legend('P/100','I/10','V',0);
   
   %model2
   subplot(3,1,3),
   hold on;zoom on;
   xlabel('Time (sec)');
   title('Rint Model');
   plot(model2(:,1),model2(:,4)/100,'b');
   plot(model2(:,1),model2(:,2)/10,'k');
   plot(model2(:,1),model2(:,3),'r');
   legend('P/100','I/10','V',0);
end

if socplot
    SOC(1)=ess_init_soc;
    ah_calc(1)=6.67*(1-ess_init_soc);
    for i=2:length(t_data)
        ah_calc(i)=ah_calc(i-1)+current_data(i)*(t_data(i)-t_data(i-1))/3600;
    end
    SOC=(6.67-ah_calc)/6.67;

    %SOC
   figure;hold on;zoom on;
   xlabel('Time (sec)');
   ylabel('SOC (-)');
   %title('SOC comparison over Modified US06 cycle');
   plot(t_data,SOC,'b');
   plot(model(:,1),model(:,5),'k:');
   plot(model2(:,1),model2(:,5),'r-.');
   if model(end,1)>=1500
       text(model(end,1)*0.8,end_soc*1.05,{'Experimental SOC','after 1 hr rest:' num2str(round(end_soc*1000)/1000)})
       plot(model(end,1)+50,end_soc,'r*')
       legend('Expmt Est','RC model','Rint model','End SOC',0);
   else
       legend('Expmt Est','RC model','Rint model',0);
   end
end

%Revision history
%03/21/01: vhj created from validate_rc_results