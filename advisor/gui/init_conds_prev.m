% init_conds_prev
% created 5/14/99 by sdb 
% sets the initial conditions equal to the corresponding values at the end of the previous cycle
% A PREVIOUS CYCLE OR SOAK MUST BE DEFINED IN THE WORK SPACE

global vinf;
ic_description='initial conditions = conditions at end of previous cycle or soak';
%disp(['Data loaded: INIT_CONDS_PREV - ',ic_description])

if evalin('base','~exist(''enable_stop'')')
   evalin('base','enable_stop=0;'); %if enabled, used by j1711 test procedure to stop simulation when SOC=0
end
if evalin('base','~exist(''fc_on'')')
   evalin('base','fc_on=1;'); %if =0, run in EV mode with j1711
end
if evalin('base','~exist(''ess_on'')')
   evalin('base','ess_on=1;'); %1=batteries enabled, (used by j1711 test procedure for conventional mode)
end

% generic values
vinf.init_conds.amb_tmp=vinf.test.ambtmp; % deg. C, ambient temperature
vinf.init_conds.air_cp=1009;              % J/kgK  ave cp of air

if ~strcmp(vinf.drivetrain.name,'ev')
   if ~isempty(ex_tmp)
      % exhaust system thermal model
      vinf.init_conds.ex_cat_mon_init_tmp=ex_tmp(end,1);   % C   internal converter temp
      vinf.init_conds.ex_cat_int_init_tmp=ex_tmp(end,2);   % C   internal converter temp
      vinf.init_conds.ex_cat_pipe_init_tmp=ex_tmp(end,3);  % C   in/out converter pipe temp
      vinf.init_conds.ex_cat_ext_init_tmp=ex_tmp(end,4);   % C   external converter temp
      vinf.init_conds.ex_manif_init_tmp=ex_tmp(end,5);     % C   manifold temp
   end
   
   % engine thermal model
   vinf.init_conds.fc_c_init_tmp=fc_tmp(end,1);     % C      initial eng cyl temp
   vinf.init_conds.fc_i_init_tmp=fc_tmp(end,2);      % C      initial eng int temp
   vinf.init_conds.fc_x_init_tmp=fc_tmp(end,3);      % C      initial eng ext temp
   vinf.init_conds.fc_h_init_tmp=fc_tmp(end,4);      % C      initial hood temp
end

if ~strcmp(vinf.drivetrain.name,'conventional')
   % battery thermal model
   vinf.init_conds.ess_mod_init_tmp=ess_mod_tmp(end);   % C      initial eng cyl temp
   
   % motor/controller thermal model
   vinf.init_conds.mc_init_tmp=mc_tmp(end);   % C      initial eng cyl temp
   
   % battery SOC
   vinf.init_conds.ess_init_soc=ess_soc_hist(end);          %initial soc
end

if isfield(vinf,'fuel_converter')
    if strcmp(vinf.fuel_converter.type,'VT')
        vinf.init_conds.fc_system_init_temp=fc_stack_coolant_outlet_temp(end); % initial fuel cell system temperature (K)
    end
end

%evaluate all the initial conditions in the base workspace
tempnames=fieldnames(vinf.init_conds);%get all the names of the variables pertaining to initial conditions
for tempindex=1:max(size(tempnames))
   assignin('base',tempnames{tempindex},eval(['vinf.init_conds.',tempnames{tempindex}]));
end

%clear variables used only temporarily
clear tempnames tempindex

%Revision history
% 9/8/99: vhj eliminate exhaust/fc IC's for EV
%10/25/99: vhj added check for ess_on existence
%11/29/99: vhj ambient temperature specified by user in variable vinf.test.ambtmp
%11/30/99: vhj fuel cell now works (added ~isempty for ex_tmp condition)
% 9/20/02:tm added fuel cell system initial temp definition
% 1/22/03: ss added if isfield(vinf,'fuel_converter') to allow vehicles
% without fuel_converters to run (ex. EV)