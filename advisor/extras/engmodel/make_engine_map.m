%this file makes a fuel use map (g/s) from torque, speed, and fuel use data

global einf

%Data expected from text files (converted to mat files)
%fc_spd , fc_trq , fc_fuel , fc_hc , fc_nox , fc_co , ex_hc , ex_nox , ex_co  spd in rpm, trq in Nm, rest defined in workspace now in g/s
%if any of the emissions are not in workspace that is fine. an 'exist' statement later will take care of it.

%Throw out negative torques and Throw out zero fuel points
keep_conditions={'fc_trq>0','fc_fuel>.01'};
names1=who('fc*');
names2=who('ex*');
names=cellstr(strvcat(char(names1),char(names2)));
for j=1:length(keep_conditions)
   eval(['ind=find(',keep_conditions{j},');']);
   for i=1:length(names)
      eval([names{i},'=',names{i},'(ind);']);
   end
end

%sort all data based on increasing fc_spd
[temp indices]=sort(fc_spd);
for i=1:length(names)
   eval([names{i},'=',names{i},'(indices);'])
end
clear temp indices

%additional data needed
fc_lhv=einf.lhv; %e.g. 42.518*1000 (J/g), lower heating value of the fuel, converted from 33.4862 kWh/gal from Mike Duoba

%calculate efficiencies
fc_eff=fc_spd*pi/30.*fc_trq./(fc_fuel*fc_lhv);

%put speed in rad/sec and shorten names for ease of programming and visual inspection
spd=fc_spd*pi/30; %speed in rad/s
trq=fc_trq; %Nm 

%sort the available spd and trq data and use them for the interpolation functions such as griddata
x=sort(spd); %sorts in ascending order
y=sort(trq);

%remove repeated values and negative values in x and y___________
j=1;
for i=1:length(x)
   if j==1 & x(i)>0
      x_new(j)=x(i);
      j=j+1;
	elseif j~=1 & ~((x(i)-x_new(j-1))<=1) & (x(i)>0);
      %disp(['x(i)=',num2str(x(i)),' x_new(j-1)=',num2str(x_new(j-1))]);
      x_new(j)=x(i);
      j=j+1;
   end
end
j=1;
for i=1:length(y)
   if j==1 & y(i)>0
      y_new(j)=y(i);
      j=j+1;
   elseif j~=1 & ~((y(i)-y_new(j-1))<=1) & (y(i)>0)
      y_new(j)=y(i);
      j=j+1;
   end
end
x=x_new; y=y_new;  clear x_new y_new j i
%________________________________________________

x=[einf.minspd:einf.spdinc:einf.maxspd]*pi/30;	%spd
y=einf.mintrq:einf.trqinc:einf.maxtrq;	%trq
fc_map_spd=x;
fc_map_trq=y;

%create matrices from vectors x and y for use with griddata
[spd_matrix,trq_matrix] = meshgrid(x,y);

%Names of variables to process and their advisor variable counterparts
vars={'fc_fuel','fc_hc','fc_co','fc_nox','fc_pm','fc_extmp'};
adv_vars={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map','fc_extmp_map'};
index=[];
for i=1:length(vars)
   if exist(vars{i})
      index=[index; i];
   end
end
vars=vars(index);
adv_vars=adv_vars(index);
einf.vars=adv_vars;
for i=1:length(vars)
   %create a fuel use map for the engine
   %default interpolation is 'linear'
   eval([adv_vars{i},'_nearest=griddata( spd , trq ,',vars{i},' , spd_matrix, trq_matrix ,''nearest'');']); 
   eval([adv_vars{i},'=griddata( spd , trq ,',vars{i},' , spd_matrix, trq_matrix );']); 
   
   if strcmp(einf.algorithm,'polynomial')
      %Regression fitting to y=a0+a1x1+a2x2+a3x1x2+a4x1^2+a5x2^2+a6x1^2x2+a7x1*ln(x1)+a8*x2ln(x2)+a9ln(x1)+a10ln(x2)
      eval(['y=',vars{i},';']);
      x1=spd;
      x2=trq;
      X=[ones(size(x1)) x1 x2 x1.*x2 x1.^2 x2.^2 x1.^2.*x2 x1.*log(x1) x2.*log(x2) log(x1) log(x2)];
      a=X\y; %perform least squares regression fit
      Y=X*a;
      
      index=find(abs(Y-y)./y==max(abs(Y-y)./y));
      max_error=(Y(index)-y(index));	%maximum error
      error=(Y(index)-y(index))/y(index)*100; 	%max error as a percentage
      avg_error=mean(abs(Y-y)./y*100);
      
      %Generate points for fit over large range of Trq/Spd
      for k=1:1:max(size(fc_map_spd))
         for j=1:1:max(size(fc_map_trq))
            x1=fc_map_spd(k);
            x2=fc_map_trq(j);
            X2=[1 x1 x2 x1*x2 x1^2 x2^2 x1^2*x2 x1*log(x1) x2*log(x2) log(x1) log(x2)];
            Y2(k,j)=X2*a;
            if Y2(k,j)<0, Y2(k,j)=eps; end
         end
      end
      eval([adv_vars{i},'_fit=Y2'';']); 
      
      %Replace NaN's with curve fit approach
      eval(['indices=find(isnan(',adv_vars{i},'));'])
      eval([adv_vars{i},'(indices)=',adv_vars{i},'_fit(indices);']);	%replace NaN values with fit values
      
   elseif strcmp(einf.algorithm,'nearest')
      %Replace NaN's with nearest neighbor approach
      eval(['indices=find(isnan(',adv_vars{i},'));'])
      eval([adv_vars{i},'(indices)=',adv_vars{i},'_nearest(indices);']);	%replace NaN values with nearest values
   end
   
   %Error checking
   eval(['Y=interp2(fc_map_spd,fc_map_trq,'adv_vars{i},',spd,trq);'])
   indices=find(~isnan(Y));
   Y=Y(indices);
   eval(['y=',vars{i},';'])
   y=y(indices);
   index=find(abs(Y-y)./y==max(abs(Y-y)./y));
   max_error=(Y(index)-y(index));	%maximum error
   error=(Y(index)-y(index))/y(index)*100; 	%max error as a percentage
   avg_error=mean(abs(Y-y)./y*100);
   
   disp(['Map: ',num2str(adv_vars{i})]);
   disp(['Average error: ',num2str(avg_error),'%']);
   disp(['Maximum error: ',num2str(max_error),' or ',num2str(error),'%']);
   disp(['Max error at ',num2str(spd(index)*30/pi),' rpm and ',num2str(round(trq(index))),' Nm']);
   %%%%%
   %record errors for display later
   eval(['einf.',adv_vars{i},'.avgerror=avg_error;']);
   eval(['einf.',adv_vars{i},'.maxerror=max_error;']);
   eval(['einf.',adv_vars{i},'.maxerrorspd=spd(index)*30/pi;']);
   eval(['einf.',adv_vars{i},'.maxerrortrq=trq(index);']);
end

%Maximum torque curve
% take maximum torque for given speeds
j=1;max_trq(1)=fc_trq(1); spd4max_trq(1)=fc_spd(1);
for i=2:length(fc_spd)
   if fc_spd(i)>fc_spd(i-1)
      j=j+1;
      max_trq(j)=fc_trq(i);
      spd4max_trq(j)=fc_spd(i);
   end
   if fc_trq(i)>max_trq(j)   %fc_trq(i-1)
      max_trq(j)=fc_trq(i);
      spd4max_trq(j)=fc_spd(i);
   end
end
fc_max_trq=interp1(spd4max_trq*pi/30,max_trq,fc_map_spd);
fc_max_trq_nearest=interp1(spd4max_trq*pi/30,max_trq,fc_map_spd,'nearest');
ind=find(isnan(fc_max_trq));
fc_max_trq(ind)=fc_max_trq_nearest(ind);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%
if einf.plot
   for i=1:length(vars)
      %plot up fuel use plot
      figure
      %plot contour lines
      eval(['c = contour ( spd_matrix.*30/pi , trq_matrix , ',adv_vars{i},');'])
      clabel(c)
      xlabel('Speed (rpm)')
      ylabel('Torque (Nm)')
      Title(strrep([strrep(einf.filename,'.mat',''), ' ',adv_vars{i} ' g/s'],'_','\_'))
      
      %plot max trq curve
      hold on
	   plot( fc_map_spd*30/pi , fc_max_trq )
      
      eval(['h=plot3(spd.*30/pi,trq,',vars{i},',''b.'');']);	%initial data points
      xd=get(h,'XData');
      yd=get(h,'YData');
      zd=get(h,'ZData');
      for i=1:length(xd)			%place labels next to data points
         t(i)=text(xd(i)+10,yd(i)+2,[sprintf('%4.2g',zd(i))],'color','b','fontsize',7);
      end  
      
      axis auto
   end
   
   %create a fuel use map in gpkWh
   pwr_matrix=spd_matrix.*trq_matrix;
   fuel_use_map_gpkwh=fc_fuel_map.*3600./(pwr_matrix./1000); %grams/kWhr 
   
   %plot up fuel use plot
   figure
   %plot contour lines
   v=[50:100:800];
   c = contour ( spd_matrix.*30/pi , trq_matrix , fuel_use_map_gpkwh , v);
   %c = contour ( spd_matrix.*30/pi , trq_matrix , fuel_use_map_gpkwh);
   clabel(c)
   xlabel('Speed (rpm)')
   ylabel('Torque (Nm)')
   Title(strrep([strrep(einf.filename,'.mat',''),'  fuel use g/kWh'],'_','\_'))
   
   %plot max trq curve
   hold on
   plot( fc_map_spd*30/pi , fc_max_trq )
   
   axis auto
   
   %create an efficiency map
   eff_map=pwr_matrix./(fc_fuel_map*fc_lhv); %decimal efficiency 
   
   figure
   %plot contour lines
   v=[.1 .2 .25 .275 .3 .325 .35 .375 .4];
   %v=[.1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2];
   c = contour ( spd_matrix.*30/pi , trq_matrix , eff_map,v);
   clabel(c)
   xlabel('Speed (rpm)')
   ylabel('Torque (Nm)')
   Title(strrep([strrep(einf.filename,'.mat',''),'  eff_map'],'_','\_'))
  %plot up fuel use plot
    
   %plot max trq curve
   hold on
   plot( fc_map_spd*30/pi , fc_max_trq )
   
   eval(['h=plot3(spd.*30/pi,trq,fc_eff,''b.'');']);	%initial data points
   xd=get(h,'XData');
   yd=get(h,'YData');
   zd=get(h,'ZData');
   for i=1:length(xd)			%place labels next to data points
      t(i)=text(xd(i)+10,yd(i)+2,[sprintf('%4.2g',zd(i))],'color','b','fontsize',7);
   end  
   
   axis auto
end

disp('Processing complete');

%Revision history
%12/09/99: print transpose of matrices (spd=rows, trq=columns now), eliminated negative torques from variables
%12/17/99: vhj now works with einf variables, engmodel, picks max trq
%12/22/99: vhj picks variables that exist to process
%01/03/00: ss/vhj sorted data in increasing speed, max engine torque algorithm corrected
%08/03/00: vhj plot last data point
%03/14/01: vhj added to variables 'fc_extmp_map' (input: 'fc_extmp')