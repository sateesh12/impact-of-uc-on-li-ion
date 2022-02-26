function bat_results(action)

if nargin==0
   global binf;
   
   figcolor=[.4 .7 1]; %blueish
   butcolor1=[1 1 .64]; %yellow
   butcolor2=[1 .5 .5]; %coral
   butcolor3=[.34 .67 .67]; %greenish
   butcolor4=[.85 .85 .85]; %grey
   
   
   % figure and title
   h0 = figure('Color',[1 1 1], ...
      'MenuBar','figure', ...
      'Name','Battery Modeling Program: Results', ...
      'NumberTitle','off', ...
      'PaperPosition',[18 180 576 432], ...
      'Position',[478 201 690 586], ...
      'ToolBar','none');
   %Frame
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[495 0 195 586], ...
      'Style','frame');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'FontSize',14, ...
      'FontWeight','bold', ...
      'Position',[504 532 174 40], ...
      'String','Results',...
      'Style','text');
   %chg/dis section
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[500 490 58 21], ...
      'String','SOC (%)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[560 490 58 21], ...
      'String','Discharge', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[620 490 58 21], ...
      'String','Charge', ...
      'Style','text');
   
   yinc=25;
   for i=1:length(binf.VOC.ess_soc)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figcolor, ...
         'Position',[500 460-(i-1)*yinc 55 21], ...
         'String',' ', ...
         'Style','text');
      set(h1,'string',num2str(binf.VOC.ess_soc(i)));
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Callback','bat_results(''redo discharge'')',...
         'Position',[565 465-(i-1)*yinc 55 21], ...
         'Style','edit', ...
         'Tag',['discharge' i]);
      set(h1,'string',num2str(round(binf.Rint.ess_r_dis(i)*10000)/10000));
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Callback','bat_results(''redo charge'')',...
         'Position',[630 465-(i-1)*yinc 55 21], ...
         'Style','edit', ...
         'Tag',['charge' i]);
      set(h1,'string',num2str(round(binf.Rint.ess_r_chg(i)*10000)/10000));
   end
   
   %Error
   dy=100;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[500 268-dy 75 21], ...
      'String','Avg error (%)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[585 268-dy 50 21], ...
      'String','2', ...
      'Style','text',...
      'Tag','avg dis error');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[635 268-dy 50 21], ...
      'String','4', ...
      'Style','text',...
      'Tag','avg chg error');
   
   %Check boxes
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Position',[500 240-dy 95 21], ...
      'String','Plot vs. current?', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Callback','bat_results(''plot dis'')',...
      'Position',[600 245-dy 20 20], ...
      'Value',1,...
      'Style','checkbox',...
      'Tag','dis box');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figcolor, ...
      'Callback','bat_results(''plot chg'')',...
      'Position',[655 245-dy 20 20], ...
      'Value',1,...
      'Style','checkbox',...
      'Tag','chg box');
   
   
   %Axes
   h1 = axes('Parent',h0, ...
      'Units','pixels', ...
      'CameraUpVector',[0 1 0], ...
      'CameraUpVectorMode','manual', ...
      'Color',[1 1 1], ...
      'Position',[55 335 420 220], ...
      'Tag','chg plot', ...
      'XColor',[0 0 0], ...
      'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   h1 = axes('Parent',h0, ...
      'Units','pixels', ...
      'CameraUpVector',[0 1 0], ...
      'CameraUpVectorMode','manual', ...
      'Color',[1 1 1], ...
      'Position',[55 54 420 220], ...
      'Tag','dis plot', ...
      'XColor',[0 0 0], ...
      'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   
   %exit
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',butcolor4, ...
      'Callback','bat_results(''exit'')', ...
      'Position',[630 12 48 24], ...
      'String','Close');
   
   %set everything normalized and set the figure size and center it
   
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   
   set([h; g],'units','normalized')
   
   
   bat_results('calculate chg error');
   bat_results('calculate dis error');
   bat_results('plot chg');
   bat_results('plot dis');
   bat_results('plot eval pts');
   
end

if nargin>0
   switch action
   case 'calculate chg error'
      global binf
      h=findobj('tag','avg chg error');
      modelC=interp1(binf.VOC.ess_voc,binf.Rint.ess_r_chg,binf.Rint.Rcharge_VOC);
      errorC=abs(modelC-binf.Rint.Rcharge_data)./binf.Rint.Rcharge_data*100;
      pavgerrorC=mean(errorC(~isnan(errorC)));
      set(h,'string',num2str(round(pavgerrorC*10)/10));
   case 'calculate dis error'
      global binf
      h=findobj('tag','avg dis error');
      modelD=interp1(binf.VOC.ess_voc,binf.Rint.ess_r_dis,binf.Rint.Rdischarge_VOC);
      errorD=abs(modelD-binf.Rint.Rdischarge_data)./binf.Rint.Rdischarge_data*100;
      pavgerrorD=mean(errorD(~isnan(errorD)));
      set(h,'string',num2str(round(pavgerrorD*10)/10));
   case 'redo discharge'
      global binf
      for i=1:length(binf.VOC.ess_soc)
         binf.Rint.ess_r_dis(i)=str2num(get(findobj(gcf,'tag',['discharge' i]),'string'));
      end
      bat_results('calculate dis error');
      bat_results('plot dis');
   case 'redo charge'
      global binf
      for i=1:length(binf.VOC.ess_soc)
         binf.Rint.ess_r_chg(i)=str2num(get(findobj(gcf,'tag',['charge' i]),'string'));
      end
      bat_results('calculate chg error');
      bat_results('plot chg');
   case 'plot eval pts'
      global binf;
      pulseind=binf.Rint.pulseind;
      figure;
      hold on; zoom on;
      plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,2),'b');						%current
      plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,4),'k');						%Ahrs
      plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,3),'g');						%voltage
      %Current
      plot(binf.Rint.data(pulseind(:,1),1)/60,binf.Rint.data(pulseind(:,1),2),'r*'); %V1
      plot(binf.Rint.data(pulseind(:,2),1)/60,binf.Rint.data(pulseind(:,2),2),'kx'); %V2
      plot(binf.Rint.data(pulseind(:,3),1)/60,binf.Rint.data(pulseind(:,3),2),'kd'); %V3
      %Voltage
      plot(binf.Rint.data(pulseind(:,1),1)/60,binf.Rint.data(pulseind(:,1),3),'r*'); %V1
      plot(binf.Rint.data(pulseind(:,2),1)/60,binf.Rint.data(pulseind(:,2),3),'kx'); %V2
      plot(binf.Rint.data(pulseind(:,3),1)/60,binf.Rint.data(pulseind(:,3),3),'kd'); %V3
      xlabel('Time (min)');
      ylabel('Data');
      title('Points chosen for evaluation: Rint')
      legend('Current','Ah','Voltage','V1','V2','V3',-1)
      
   case 'plot chg'
      h=findobj(gcf,'tag','chg plot');
      tag='chg plot';
      axes(h);
      global binf;
      zoom on; hold off;
      plot(binf.Rint.Rcharge_VOC,binf.Rint.Rcharge_data,'kd')
      hold on;
      plot(binf.Rint.Rcharge_VOC,binf.Rint.chg_fit,'g');
      plot(binf.VOC.ess_voc,binf.Rint.ess_r_chg,'bx');
      title(['Rchg vs Voc at T=',num2str(round(binf.Rint.temperature*10)/10),'C']);
      xlabel('Voc');
      ylabel('Rint (ohms)');
      legend('Chg data','Chg poly fit','Chg model',-1);
      set(gca,'tag',tag);
      if get(findobj(gcf,'tag','chg box'),'value')
         bat_results('plot Rchg & current')
      end
   case 'plot Rchg & current'
      h=findobj(gcf,'tag','chg plot');
      axes(h);
      tag='chg plot';
      global binf
      tmpcurr=sort(binf.Rint.Ichg);
      curr=[tmpcurr(1)];
      %find different currents data taken over
      for i=2:length(binf.Rint.Rcharge_data) 
         if tmpcurr(i)~=tmpcurr(i-1)
            curr=[curr; tmpcurr(i)];
         end
      end
      for i=1:length(curr)
         eval(['curr_data.c',num2str(i),'=[];']);
         eval(['volt_data.c',num2str(i),'=[];']);
         for j=1:length(binf.Rint.Rcharge_data)
            if binf.Rint.Ichg(j)==curr(i)
               eval(['curr_data.c' num2str(i) '=[curr_data.c' num2str(i) '; binf.Rint.Rcharge_data(',num2str(j),')];']);
               eval(['volt_data.c' num2str(i) '=[volt_data.c' num2str(i) '; binf.Rint.Rcharge_VOC(',num2str(j),')];']);
            end
         end
      end
      colorselection={'m:';'g:';'c:';'b:';'k:';'r:';'y:';'m--';'g--';'c--';'b--';'k--';'r--';'y--';'m-.';'g-.';'c-.';'b-.';'k-.';'r-.';'y-.';'m-';'g-';'c-';'b-';'k-';'r-';'y-'};
      legend off;
      legstr=strvcat('Chg data','Chg poly fit','Chg model');
      for i=1:length(curr)
         tmp=[num2str(curr(i)) ' Amps'];
         legstr=strvcat(legstr, tmp);
         OCV=eval(['volt_data.c',num2str(i)]);
         Rchg=eval(['curr_data.c',num2str(i)]);
         plot(OCV,Rchg,colorselection{i});
      end
      legend(legstr,-1);
      set(gca,'tag',tag);
      
   case 'plot dis'
      h2=findobj(gcf,'tag','dis plot'); 
      tag='dis plot';
      axes(h2);
      global binf;
      zoom on; hold off;
      plot(binf.Rint.Rdischarge_VOC,binf.Rint.Rdischarge_data,'ko')
      hold on;
      plot(binf.Rint.Rdischarge_VOC,binf.Rint.dis_fit,'r');
      plot(binf.VOC.ess_voc,binf.Rint.ess_r_dis,'b*');
      title(['Rdis vs Voc at T=',num2str(round(binf.Rint.temperature*10)/10),'C']);
      xlabel('Voc');
      ylabel('Rint (ohms)');
      legend('Dis data','Dis poly fit','Dis model',-1);
      set(h2,'tag',tag);
      if get(findobj(gcf,'tag','dis box'),'value')
         bat_results('plot Rdis & current')
      end
      
   case 'plot Rdis & current'
      h2=findobj(gcf,'tag','dis plot');
      axes(h2);
      tag='dis plot';
      global binf
      tmpcurr=sort(binf.Rint.Idis);
      curr=[tmpcurr(1)];
      %find different currents data taken over
      for i=2:length(binf.Rint.Rdischarge_data) 
         if tmpcurr(i)~=tmpcurr(i-1)
            curr=[curr; tmpcurr(i)];
         end
      end
      for i=1:length(curr)
         eval(['curr_data.d',num2str(i),'=[];']);
         eval(['volt_data.d',num2str(i),'=[];']);
         for j=1:length(binf.Rint.Rdischarge_data)
            if binf.Rint.Idis(j)==curr(i)
               eval(['curr_data.d' num2str(i) '=[curr_data.d' num2str(i) '; binf.Rint.Rdischarge_data(',num2str(j),')];']);
               eval(['volt_data.d' num2str(i) '=[volt_data.d' num2str(i) '; binf.Rint.Rdischarge_VOC(',num2str(j),')];']);
            end
         end
      end
      colorselection={'m:';'g:';'c:';'b:';'k:';'r:';'y:';'m--';'g--';'c--';'b--';'k--';'r--';'y--';'m-.';'g-.';'c-.';'b-.';'k-.';'r-.';'y-.';'m-';'g-';'c-';'b-';'k-';'r-';'y-'};
      legstr=strvcat('Dis data','Dis poly fit','Dis model');
      for i=1:length(curr)
         tmp=[num2str(curr(i)) ' Amps'];
         legstr=strvcat(legstr, tmp);
         OCV=eval(['volt_data.d',num2str(i)]);
         Rdis=eval(['curr_data.d',num2str(i)]);
         plot(OCV,Rdis,colorselection{i});
      end
      legend off;
      legend(legstr,-1);
      set(h2,'tag',tag);
      
         
   case 'exit'
      close(gcbf);
   end
end


%Revision history
%6/28/99: vhj file created
%7/1/99: vhj plots vs. current now
%7/14/99: vhj SOC range 0,10,20:20:100
%09/26/00: vhj adjusted to deal w/ SOC range 0:10:100
%09/27/00: vhj/mz expanded color selection
%01/18/01: vhj auto check plot vs. current