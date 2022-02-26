%--------------------------------------
% build_fc_eff_curve_KTH
%
% Kristina Haraldsson, NREL
% Date: 042503
%----------------------------------------
function [eta,pwr_map]=build_fc_eff_curve_KTH(N)


%if evalin('base','exist(''vinf.run_without_gui'')')&evalin('base','vinf.run_without_gui')==1
%    gui_flag=0;
%else
%    gui_flag=1;
%end

%if gui_flag
%   h = waitbar(0,'Please wait...');
%  set(h,'Windowstyle','modal');
%end

%Input
%------

format long

fcstackinit
Comp1050_2

pwr_map=[5000 10000 15000 20000 25000 30000 35000 40000 45000 50000];
clear eff
%pwr_map=[5000];

for i=1:length(pwr_map)
    assignin('base','fc_cell_stack_Pel',pwr_map(i)); 
    assignin('base','fc_cell_stack_N',N);
    evalin('base','sim(''fc_KTH_lib'')'); 
     eta(i)=evalin('base','eff(length(eff))');
     clear eff

    %end
    % if gui_flag    
    %     waitbar(i/(length(pwr_map),h);
    % end
end
%figure
%plot(pwr_map/1000,eta)










