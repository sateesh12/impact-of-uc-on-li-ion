function plot_prius_spds(time)

%create 8/17/99 by ss
%this function will plot up the vehicle speed vs. time and below it, in a seperate plot
%the speed of each component(gen,mot, fc) will be shown for the user selected time 
%selection of time is done by using the slider.
global gc_spd_out_a t mc_spd_out_a fc_spd_out_a mpha cyc_mph_r
global vinf

if nargin==0
   
%obtain the data necessary to plot
%load priusspddatafuds
mc_spd_out_a=evalin('base','mc_spd_out_a');
gc_spd_out_a=evalin('base','gc_spd_out_a');
t=evalin('base','t');
fc_spd_out_a=evalin('base','fc_spd_out_a');
mpha=evalin('base','mpha');
cyc_mph_r=evalin('base','cyc_mph_r');

h=findobj('tag','prius speeds');

if ~isempty(h)
   close(h)
end

h0 = figure('Color',[0.8 0.8 0.8], ...
		'Position',[15 209 584 482], ...
   	'Tag','prius speeds',...
      'name','Prius Component Speeds Plot',...
      'menubar','none');
   
adv_menu('prius speeds')
   
timeind=1;

h1=subplot(211);
plot(t,mpha*units('mph2kmph'),t,cyc_mph_r*units('mph2kmph'),'--')
title('Use Slider to Select Time for Speeds Plot')
xlabel('time')
if strcmp(vinf.units,'metric')
	ylabel('vehicle speed (km/h)')   
else
   ylabel('vehicle speed (mph)')
end

set(gca,'position',[0.1301 0.6203 0.7723 0.3050],'tag','mph axes');
legend('achieved','requested')
h2 = line([t(timeind) t(timeind)], [0 max(mpha)]);
set(h2,'Color',[1 0 0], ...
	'Tag','time line', ...
   'linewidth',2);


h1 = axes('Parent',h0, ...
	'Position',[0.1318 0.0996 0.7757 0.3444], ...
	'Tag','spd axes', ...
	'XColor',[0 0 0], ...
	'XLim',[0.9 2.18], ...
	'XLimMode','manual', ...
	'XTick',[1 1.78 2.08], ...
	'XTickLabel',{'gc';'fc';'mc'}, ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YLim',[-5000 6000], ...
	'YLimMode','manual', ...
	'ZColor',[0 0 0]);
h2 = line('Parent',h1, ...
	'Color',[0 0 1], ...
	'Tag','spd line', ...
   'linewidth',2,...
   'marker','o',...
   'XData',[1 1.78 2.08], ...
	'YData',60/(2*pi)*[gc_spd_out_a(timeind) fc_spd_out_a(timeind) mc_spd_out_a(timeind)]);

title(['Generator, Fuel Converter, and Motor speeds at t=',num2str(t(timeind))]);
ylabel('speed (rpm)')

grid on

uicontrol('parent',h0,...
   'style','slider',...
   'callback','plot_prius_spds(get(findobj(''tag'',''time slider''),''value''))',...
   'min',t(1),...
   'max',t(end),...
   'Position',[58 242 490 20],...
   'value',0,...
   'tag','time slider',...
   'sliderstep',[1/t(end) 10/t(end)]);
end

if nargin>0
   
   found=0;
   timeind=0;
   while ~found
      timeind=timeind+1;
      if t(timeind)>=time
         found=1;
      end
   end
	set(findobj('tag','time line'),'XData',[t(timeind) t(timeind)]);

	set(findobj('tag','spd line'),'YData',60/(2*pi)*[gc_spd_out_a(timeind) fc_spd_out_a(timeind) mc_spd_out_a(timeind)]);
   axes(findobj('tag','mph axes'));
   
   if strcmp(vinf.units,'metric')
      title(['Use Slider to Select Time for Speeds Plot.  speed=',num2str(mpha(timeind)*units('mph2kmph')),' km/h'])
   else   
      title(['Use Slider to Select Time for Speeds Plot.  speed=',num2str(mpha(timeind)),' mph'])
   end
   
   axes(findobj('tag','spd axes'))
   title(['Generator, Fuel Converter, and Motor speeds at t=',num2str(t(timeind))]);
   set(gca,'XTickLabel',{['gc=',num2str(gc_spd_out_a(timeind)*30/pi,'%4.0f')];['fc=',num2str(fc_spd_out_a(timeind)*30/pi,'%4.0f')];['mc=',num2str(mc_spd_out_a(timeind)*30/pi,'%4.0f')]})
   
end

%revisions
%8/17/99 ss created
%8/26/99 ss added cyc_mph_r to plot