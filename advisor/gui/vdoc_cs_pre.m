function opt_pre(name)
% Store the current vehicle parameters to be reopened in the new Matlab workspace

global vinf

gui_save_input(name)

disp(['Current vehicle params saved as ',[name,'_in.m'],'.']);

% store optimization parameters
evalin('base','params1=getfield(vinf,''control_strategy'');')
evalin('base','params2=getfield(vinf,''autosize'');')
evalin('base','params3=getfield(vinf,''units'');')
evalin('base',['save(''',name,'_OPT'',''params1'',''params2'',''params3'');'])
evalin('base','clear params1 params2 params3')
   
disp(['Current optimization params saved as ',name,'_OPT.mat.']);

return

% 7/17/00 ss replaced gui options with optionlist.
% 8/16/00:tm replaced lines of code to save vehicle parameters with call to standard function
