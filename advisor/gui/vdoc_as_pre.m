function opt_pre(name)
% Store the current vehicle parameters to be reopened in the new Matlab workspace

global vinf

gui_save_input(name)

disp(['Current vehicle params saved as ',[name,'_in.m'],'.']);

% store optimization parameters
%evalin('base','params=getfield(vinf,''autosize'');')
%evalin('base','params2=getfield(vinf,''units'');')

vehicle_info=vinf;

save([name,'_OPT'],'vehicle_info')

%evalin('base',['save(''',name,'_OPT'',''params'',''params2'');'])
%evalin('base',['save(''',name,'_OPT'',''params'',''params2'');'])
%evalin('base','clear params params2')
   
disp(['Current optimization params saved as ',name,'_OPT.mat.']);

return

% 7/17/00 ss replaced gui options with optionlist.
% 8/16/00:tm replaced lines of code to save vehicle parameters with call to standard function
% 1/31/01:tm revised to save entire vinf structure rather than just the autosize and units sections
%