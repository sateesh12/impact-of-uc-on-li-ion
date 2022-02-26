function FtpResultsFigControl(option)
%This function controls the results figure.

global vinf

if ~isempty(findobj('tag','ftp_results_figure'))
    set(findobj('tag','ftp_results_figure'),'tag','ftp_results_figure_old') % rename tag of previous ftp figure
    set(findobj(findobj('tag','ftp_results_figure_old'),'style','text'),'tag','hidden_text') % rename tags of text strings of previous ftp figure so that following set statements don't overwrite data
end

open('FtpResultsFig.fig') %run the GUIDE editable file to setup figure

FtpResultsFigHandle=findobj('tag','ftp_results_figure'); % store figure handle

% set parameter values
% header
if strcmp(vinf.units,'metric')
    str='Fuel Consumption (L/100 km)';
else
    str='Fuel Economy (mpg)';
end
set(findobj('tag','header1'),'string',str);

% label
if strcmp(vinf.units,'metric')
    str='L/100 km';
else
    str='mpg';
end
set(findobj('tag','label1'),'string',str);

%fuel economy values
if strcmp(vinf.units,'metric')
    str=evalin('base','num2str(round(10*units(''gpm2lp100km'')/mpg)/10)');
    str2=evalin('base','num2str(round(10*units(''gpm2lp100km'')/mpgge)/10)');   
else
    str=evalin('base','num2str(round(10*mpg)/10)');
    str2=evalin('base','num2str(round(10*mpgge)/10)');
end
set(findobj('tag','mpg'),'string',str);
set(findobj('tag','gaseq'),'string',str2);

%Emissions Section title
if strcmp(vinf.units,'metric')
    str='Fuel and Emissions (grams/km)';
else
    str='Fuel and Emissions (grams/mile)';
end
set(findobj('tag','header2'),'string',str);

%result values
%BAG1
set(findobj('tag','bag1 hc'),'string',evalin('base','num2str(round(1000*hc_gpm1*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag1 co'),'string',evalin('base','num2str(round(1000*co_gpm1*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag1 nox'),'string',evalin('base','num2str(round(1000*nox_gpm1*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag1 pm'),'string',evalin('base','num2str(round(1000*pm_gpm1*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag1 fuel'),'string',evalin('base','num2str(round(1000*fuel_gpm1*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag1 dist'),'string',evalin('base','num2str(round(1000*dist1*units(''miles2km''))/1000)'));

%BAG2
set(findobj('tag','bag2 hc'),'string',evalin('base','num2str(round(1000*hc_gpm2*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag2 co'),'string',evalin('base','num2str(round(1000*co_gpm2*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag2 nox'),'string',evalin('base','num2str(round(1000*nox_gpm2*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag2 pm'),'string',evalin('base','num2str(round(1000*pm_gpm2*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag2 fuel'),'string',evalin('base','num2str(round(1000*fuel_gpm2*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag2 dist'),'string',evalin('base','num2str(round(1000*dist2*units(''miles2km''))/1000)'));

%BAG3
set(findobj('tag','bag3 hc'),'string',evalin('base','num2str(round(1000*hc_gpm3*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag3 co'),'string',evalin('base','num2str(round(1000*co_gpm3*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag3 nox'),'string',evalin('base','num2str(round(1000*nox_gpm3*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag3 pm'),'string',evalin('base','num2str(round(1000*pm_gpm3*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag3 fuel'),'string',evalin('base','num2str(round(1000*fuel_gpm3*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','bag3 dist'),'string',evalin('base','num2str(round(1000*dist3*units(''miles2km''))/1000)'));

%BAG4
if evalin('base','exist(''hc_gpm4'')') 
    set(findobj('tag','bag4 hc'),'string',evalin('base','num2str(round(1000*hc_gpm4*units(''gpm2gpkm''))/1000)'));
    set(findobj('tag','bag4 co'),'string',evalin('base','num2str(round(1000*co_gpm4*units(''gpm2gpkm''))/1000)'));
    set(findobj('tag','bag4 nox'),'string',evalin('base','num2str(round(1000*nox_gpm4*units(''gpm2gpkm''))/1000)'));
    set(findobj('tag','bag4 pm'),'string',evalin('base','num2str(round(1000*pm_gpm4*units(''gpm2gpkm''))/1000)'));
    set(findobj('tag','bag4 fuel'),'string',evalin('base','num2str(round(1000*fuel_gpm4*units(''gpm2gpkm''))/1000)'));
    set(findobj('tag','bag4 dist'),'string',evalin('base','num2str(round(1000*dist4*units(''miles2km''))/1000)'));
else
    set(findobj('tag','bag4 hc'),'string','n/a');
    set(findobj('tag','bag4 co'),'string','n/a');
    set(findobj('tag','bag4 nox'),'string','n/a');
    set(findobj('tag','bag4 pm'),'string','n/a');
    set(findobj('tag','bag4 fuel'),'string','n/a');
    set(findobj('tag','bag4 dist'),'string','n/a');
end

%weighted
set(findobj('tag','total hc'),'string',evalin('base','num2str(round(1000*hc_gpm*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','total co'),'string',evalin('base','num2str(round(1000*co_gpm*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','total nox'),'string',evalin('base','num2str(round(1000*nox_gpm*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','total pm'),'string',evalin('base','num2str(round(1000*pm_gpm*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','total fuel'),'string',evalin('base','num2str(round(1000*fuel_gpm*units(''gpm2gpkm''))/1000)'));
set(findobj('tag','total dist'),'string',evalin('base','num2str(round(1000*dist_total*units(''miles2km''))/1000)'));

% set figure size normalized and centered 
center_figure(FtpResultsFigHandle);
set(findobj(FtpResultsFigHandle,'style','text'),'units','normalized')
set(findobj(FtpResultsFigHandle,'style','pushbutton'),'units','normalized')

% set the figure back on after everything is drawn
set(FtpResultsFigHandle,'visible','on');

% Revision history
% 8/19/01:tm file created
