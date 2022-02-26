% use to check energy storage system operation

%%%% plot Constant Current Discharge Performance
time_vec=[1/30 1/20 1/10 1/5 1/2 1 2 5 10 20]; % define time vector (hr)
I=meshgrid(ess_max_ah_cap,time_vec)'./meshgrid(time_vec,ess_max_ah_cap); % determine currents
figure
loglog(time_vec,I)
hold
ylabel('Current (amps)');
xlabel ('Time (hrs)');
set(gcf,'NumberTitle','off','Name','Discharge Performance')
h=title({'Constant Current Discharge Performance';ess_description});
set(h,'FontSize',7)
str=[];
for i=1:length(ess_tmp)
   str=[str, '''',num2str(ess_tmp(i)),' C'','];
end
eval(['legend(',str,'0)'])
clear time_vec I str

%%%%%% plot open circuit voltage
figure
plot(ess_soc,ess_voc);
ylabel('Voltage, volts');
xlabel ('State of Charge, (0-1)');
set(gcf,'NumberTitle','off','Name','Open Circuit Voltage')
h=title({'Open Circuit Voltage';ess_description});
set(h,'FontSize',7)
str=[];
for i=1:length(ess_tmp)
   str=[str, '''',num2str(ess_tmp(i)),' C'','];
end
eval(['legend(',str,'0)'])

%%%%%% plot battery resistance
figure;
hold on;
str=[];
linetype={'-v','-o','-s','-*','-x','-^'};
for i=1:length(ess_tmp)
   plot(ess_soc,ess_r_dis(i,:),['b',linetype{rem(i-1,6)+1}], ess_soc, ess_r_chg(i,:),['g',linetype{rem(i-1,6)+1}]);
   str=[str,'''Discharge - ',num2str(ess_tmp(i)),'C'',','''Charge - ',num2str(ess_tmp(i)),'C'','];   
end
if exist('cs_lo_soc')
   plot([cs_lo_soc cs_lo_soc],[min(min([ess_r_dis ess_r_chg])) max(max([ess_r_dis ess_r_chg]))],'c-.')
   str=[str,'''CS Low SOC'','];
end;
if exist('cs_hi_soc')
   plot([cs_hi_soc cs_hi_soc],[min(min([ess_r_dis ess_r_chg])) max(max([ess_r_dis ess_r_chg]))],'r:')
   str=[str,'''CS High SOC'','];
end;
ylabel('Resistance, Ohms');
xlabel('State Of Charge, (0-1)');
set(gcf,'NumberTitle','off','Name','Internal Resistance')
h=title({'Internal Resistance';ess_description});
set(h,'FontSize',7)
eval(['legend(',str,'0)'])
clear str linetype

%%%%%% plot battery round trip efficiency

% determine current limits
if exist('gc_max_crrnt')
   gc_crrnt=gc_max_crrnt;   
else
   gc_crrnt=[];   
end
if exist('mc_max_crrnt')
   mc_crrnt=mc_max_crrnt;   
else
   mc_crrnt=[];
end
max_crrnt=min([gc_crrnt mc_crrnt]);
if isempty(max_crrnt)
   max_crrnt=400;
end

% define discharge times
time_vec=[1/60 1/30 1/20 1/15 1/10 1/5 1/2 1 2 5 10 15 20 40]; % define time vector (hr)

% limit time vector to possible currents
t_index=find((time_vec<=(max(ess_max_ah_cap)*4))&(time_vec>=(min(ess_max_ah_cap)/max_crrnt)));
time_vec=time_vec(t_index);

% calculate round trip efficiency
for y=1:length(ess_tmp)
   for x=1:length(time_vec)
      eta_rt(:,x,y)=(ess_voc(y,:)-ess_max_ah_cap(y)/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_dis(y,:))./(ess_voc(y,:)+ess_max_ah_cap(y)/time_vec(x)*ones(size(ess_voc(y,:))).*ess_r_chg(y,:))*ess_coulombic_eff(y);
   end
end

% plot results
for i=1:length(ess_tmp)
   figure
   hold on
   c=contour(ess_soc,ess_max_ah_cap(i)./time_vec,eta_rt(:,:,i)');
   clabel(c)
   xlabel('State of Charge (--)')
   ylabel('Current (amps)')
   h=title({['Isothermal Roundtrip Efficiency at ',num2str(ess_tmp(i),3),' C'];ess_description});
   set(h,'FontSize',7)
   set(gcf,'NumberTitle','off','Name',['ESS Eff. at ',num2str(ess_tmp(i),3),' C'])
end

clear time_vec mc_crrnt gc_crrnt eta_rt t_index x y i c max_crrnt

%%%%%% plot peak power
v=max(max(0.5*ess_voc,mc_min_volts/ess_module_num),max(0.5*ess_voc,ess_min_volts));
ess_pwr=((ess_voc-v).*v)./(ess_r_dis);
figure
hold
plot(ess_soc,ess_pwr/1000);
ylabel('Instantaneous Power, kW');
xlabel ('State of Charge, (--)');
set(gcf,'NumberTitle','off','Name','Battery Module Discharge Power')
h=title({'Instantaneous Power';ess_description});
set(h,'FontSize',7)
str=[];
for i=1:length(ess_tmp)
   str=[str, '''',num2str(ess_tmp(i)),' C'','];
end
eval(['legend(',str,'0)'])

clear ess_pwr str v


%%%%%%%%%%%%%%%%%%%%
% revision history
%%%%%%%%%%%%%%%%%%%%
%12/31/98 tm: added plotting of cs_lo_soc and cs_hi_soc on battery resistance plot
%7/19/99:tm added plotting of constant current discharge information
%9/2/99:tm removed plotting of puekert relationship
%9/2/99:tm modified plottinf of constant current discharge because peukert info eliminated
%12/10/99:tm fixed ciruit to circuit spelling in labels
% 7/21/00:tm added plotting of isothermal roundtrip efficiency
% 8/8/00:tm updated calcs for rt eff and cosmetic changes to other sections
% 8/8/00:tm cosmetic changes to other sections