function [dsoc]=j17_dsoc(cyc)

j_gal=evalin('base','j_gal');
gallons=j_gal(cyc,1); %PCT_HEV only
fc_fuel_den=evalin('base','fc_fuel_den');
fc_fuel_lhv=evalin('base','fc_fuel_lhv');
voc=evalin('base','interp1(ess_soc,ess_voc(1,:),0.5)');
ess_max_ah_cap=evalin('base','ess_max_ah_cap(1)');
ess_module_num=evalin('base','ess_module_num');

dsoc=gallons/.264172*fc_fuel_den*fc_fuel_lhv*.01/(voc*ess_module_num*3600*ess_max_ah_cap);

%Revision history
% 9/17/99: vhj changed ess_voc to ess_voc(1,:) for new battery model
% 9/22/99: vhj max_ah_cap(1,:)