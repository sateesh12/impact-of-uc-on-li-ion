%plot Temperature variation

%Files and path for .mat files at different temperatures
files=strrep(binf.Plot_T_Var.data_files,'.mat','');
path=binf.Plot_T_Var.path;
%sort files in order of ascending temperatures
for i=1:length(files)
   eval(['load ''',path files{i},'''']);
   tmp(i)=binf.VOC.temperature;
end
[temperature, index]=sort(tmp);
for i=1:length(files)
   files{i}=strrep(files{index(i)},'.mat','');
end

%Pick which plots to display
if isfield(binf,'RC')
    plotpeuk=0;
    plot_peuk_mod=0;
    plotVOC=1;
    plotRint=0;
    plotRC=1;
else
    plotpeuk=1;
    plot_peuk_mod=0;
    plotVOC=1;
    plotRint=1;
    plotRC=0;
end
name=files{1};
tmp=files{1};
nums={'0','1','2','3','4','5','6','7','8','9'};
for i=1:length(files{1})
   for j=1:length(nums)
      if eval(['strcmp(tmp(i),''',nums{j},''')'])
         eval(['name=strrep(name,''',nums{j},''','''');'])
      end
   end
end
name=strrep(name,'_','\_');

number=length(files);
for i=1:number
   eval(['load ''',path files{i},'''']);
   %find temperature for given test (binf.VOC.temperature)
   n(i)=round(binf.VOC.temperature);
   eval(['binf',num2str(n(i)),'=binf;']);
end

if plotpeuk
   %Plot peukert comparison
   figure;hold on;zoom on;
   title([name,' Peukert Curve-temperature comparison']);
   xlabel('Discharge Current (A)');
   ylabel('Capacity (Ah)');
   color1={'bs';'kd';'ro';'gv';'m^'};
   color2={'bx';'k*';'r+';'g.';'mx'};
   color3={'b';'k';'r';'g';'m'};
   legstr=[];
   %plot data
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.peukert.IC(:,1),binf',num2str(n(i)),'.peukert.IC(:,2),''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C'];
      legstr=strvcat(legstr, tmp);
   end
   %plot residual data
   for i=1:number
      try
         eval(['plot(binf',num2str(n(i)),'.peukert.ICresid(:,1),binf',num2str(n(i)),'.peukert.ICresid(:,2),''',color2{i},''');']);
         tmp=[num2str(n(i)) 'C resid'];
         legstr=strvcat(legstr, tmp);
      end
   end
   %plot peukert curve fit
   for i=1:number
      %plot peukert line
      mini=eval(['min(binf',num2str(n(i)),'.peukert.IC(:,1))']);
      maxi=eval(['max(binf',num2str(n(i)),'.peukert.IC(:,1))']);
      current=mini:(maxi-mini)/1000:maxi;
      eval(['plot(current,binf',num2str(n(i)),'.peukert.coefficient*current.^binf',num2str(n(i)),'.peukert.exponent,''',color3{i},''');']);
      tmp=[num2str(n(i)) 'C P.line'];
      if plot_peuk_mod, legstr=strvcat(legstr, tmp);end
   end
   legend(legstr,-1);
end

if plotVOC
   %Plot VOC comparison
   figure;hold on;zoom on;
   title([name,' VOC-temperature comparison']);
   xlabel('SOC (%)');
   ylabel('VOC (V)');
   color1={'bs';'kd';'ro';'gv';'m^'};
   color2={'bx';'k*';'r+';'g.';'mx'};
   color3={'b';'k';'r';'g';'m'};
   legstr=[];
   %plot data
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.VOC.SOC_OCV_data(:,1),binf',num2str(n(i)),'.VOC.SOC_OCV_data(:,2),''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C data'];
      legstr=strvcat(legstr, tmp);
   end
   %plot model
   for i=1:number
      %plot peukert line
      eval(['plot(binf',num2str(n(i)),'.VOC.ess_soc,binf',num2str(n(i)),'.VOC.ess_voc,''',color3{i},''');']);
      tmp=[num2str(n(i)) 'C model'];
      legstr=strvcat(legstr, tmp);
   end
   legend(legstr,-1);
end

if plotRint
   %Plot Rint comparison
   %Rchg
   figure;hold on;zoom on;
   title([name,' Rchg-temperature comparison']);
   xlabel('Voltage (V)');
   ylabel('Rchg (ohms)');
   color1={'bs';'kd';'ro';'gv';'m^'};
   color2={'bx';'k*';'r+';'g.';'mx'};
   color3={'b';'k';'r';'g';'m'};
   color4={'bx-';'k*-';'r+-';'g.-';'mx-'};
   legstr=[];
   %plot data
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.Rint.Rcharge_VOC,binf',num2str(n(i)),'.Rint.Rcharge_data,''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C data'];
      legstr=strvcat(legstr, tmp);
   end
   %plot model
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.VOC.ess_voc,binf',num2str(n(i)),'.Rint.ess_r_chg,''',color4{i},''');']);
      tmp=[num2str(n(i)) 'C model'];
      legstr=strvcat(legstr, tmp);
   end
   legend(legstr,-1);
   %Rdis
   figure;hold on;zoom on;
   title([name,' Rdis-temperature comparison']);
   xlabel('Voltage (V)');
   ylabel('Rdis (ohms)');
   color1={'bs';'kd';'ro';'gv';'m^'};
   color2={'bx';'k*';'r+';'g.';'mx'};
   color3={'b';'k';'r';'g';'m'};
   color4={'bx-';'k*-';'r+-';'g.-';'mx-'};
   legstr=[];
   %plot data
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.Rint.Rdischarge_VOC,binf',num2str(n(i)),'.Rint.Rdischarge_data,''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C data'];
      legstr=strvcat(legstr, tmp);
   end
   %plot model
   for i=1:number
      eval(['plot(binf',num2str(n(i)),'.VOC.ess_voc,binf',num2str(n(i)),'.Rint.ess_r_dis,''',color4{i},''');']);
      tmp=[num2str(n(i)) 'C model'];
      legstr=strvcat(legstr, tmp);
   end
   legend(legstr,-1);
end

if plotRC
    %Plot RC comparison
   %Resistances
   figure;hold on;zoom on;
   title([name,' Resistances-temperature comparison']);
   xlabel('SOC (-)');
   ylabel('Resistances (milliohms)');
   color1={'bs';'ks';'rs';'gs';'ms'};
   color2={'gx';'cx';'mx';'gx';'mx'};
   color3={'b*';'k*';'r*';'g*';'m*'};
   color4={'b-';'k-';'r-';'g-';'m-'};
   color5={'g-';'c-';'m-';'g-';'m-'};
   color6={'b--';'k--';'r--';'g--';'m--'};
   legstr=[];
   %plot data
   for i=1:number
      %Re
       eval(['plot(binf',num2str(n(i)),'.RC.SOC_data,binf',num2str(n(i)),'.RC.Re_data*1000,''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C data Re'];
      legstr=strvcat(legstr, tmp);
      %Rc
      eval(['plot(binf',num2str(n(i)),'.RC.SOC_data,binf',num2str(n(i)),'.RC.Rc_data*1000,''',color2{i},''');']);
      tmp=[num2str(n(i)) 'C data Rc'];
      legstr=strvcat(legstr, tmp);
      %Rt
      eval(['plot(binf',num2str(n(i)),'.RC.SOC_data,binf',num2str(n(i)),'.RC.Rt_data*1000,''',color3{i},''');']);
      tmp=[num2str(n(i)) 'C data Rt'];
      legstr=strvcat(legstr, tmp);
   end
   %plot model
   for i=1:number
      %Re
      eval(['plot(binf',num2str(n(i)),'.RC.ess_soc,binf',num2str(n(i)),'.RC.ess_re*1000,''',color4{i},''');']);
      tmp=[num2str(n(i)) 'C model Re'];
      legstr=strvcat(legstr, tmp);
      %Rc
      eval(['plot(binf',num2str(n(i)),'.RC.ess_soc,binf',num2str(n(i)),'.RC.ess_rc*1000,''',color5{i},''');']);
      tmp=[num2str(n(i)) 'C model Rc'];
      legstr=strvcat(legstr, tmp);
      %Rt
      eval(['plot(binf',num2str(n(i)),'.RC.ess_soc,binf',num2str(n(i)),'.RC.ess_rt*1000,''',color6{i},''');']);
      tmp=[num2str(n(i)) 'C model Rt'];
      legstr=strvcat(legstr, tmp);
      
   end
   legend(legstr,-1);

   %Capacitances
   figure;hold on;zoom on;
   title([name,' Capacitances-temperature comparison']);
   xlabel('SOC (-)');
   ylabel('Capacitances (kF)');
   legstr=[];
   %plot data
   for i=1:number
      %Cb
      eval(['plot(binf',num2str(n(i)),'.RC.SOC_data,binf',num2str(n(i)),'.RC.Cb_data/1000,''',color1{i},''');']);
      tmp=[num2str(n(i)) 'C data Cb'];
      legstr=strvcat(legstr, tmp);
      %Cc
      eval(['plot(binf',num2str(n(i)),'.RC.SOC_data,binf',num2str(n(i)),'.RC.Cc_data/1000,''',color2{i},''');']);
      tmp=[num2str(n(i)) 'C data Cc'];
      legstr=strvcat(legstr, tmp);
   end
   %plot model
   for i=1:number
      %Cb
      eval(['plot(binf',num2str(n(i)),'.RC.ess_soc,binf',num2str(n(i)),'.RC.ess_cb/1000,''',color4{i},''');']);
      tmp=[num2str(n(i)) 'C model Cb'];
      legstr=strvcat(legstr, tmp);
      %Cc
      eval(['plot(binf',num2str(n(i)),'.RC.ess_soc,binf',num2str(n(i)),'.RC.ess_cc/1000,''',color5{i},''');']);
      tmp=[num2str(n(i)) 'C model Cc'];
      legstr=strvcat(legstr, tmp);
   end
   legend(legstr,-1);
end

clear color1 color2 color3 color4 current i legstr maxi mini n number tmp;

%Revision history
% 7/22/99: vhj file created
%12/16/99: vhj now called from batmodel, files saved in binf variable
%03/17/00: vhj eliminated reference to Plot_T_Var when not there
%01/18/01: vhj updated loading of files to allow spaces in directories, allow underscores in name
%03/13/01: vhj added plotting of RC params
%03/16/01: vhj colors of RC plotting
%03/26/01: vhj/mz eliminate reference to peukert field