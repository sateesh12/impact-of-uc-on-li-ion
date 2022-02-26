%init_conds_hot
%created 2/12/99 by sb based on init_conds.
%sets all temperature initial conditions to appropriate values for hot-start tests 
%currently used in TEST_CITY_HWY

global vinf
ic_description='Hot-Start initial conditions';
disp(['Data loaded: init_conds_hot - ',ic_description])

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
vinf.init_conds.amb_tmp=20;            	% deg. C, ambient temperature
vinf.init_conds.air_cp=1009;              % J/kgK  ave cp of air

% exhaust system thermal model
vinf.init_conds.ex_cat_mon_init_tmp=500;   % C   internal converter temp
vinf.init_conds.ex_cat_int_init_tmp=500;   % C   internal converter temp
vinf.init_conds.ex_cat_pipe_init_tmp=300;  % C   in/out converter pipe temp
vinf.init_conds.ex_cat_ext_init_tmp=150;   % C   external converter temp
vinf.init_conds.ex_manif_init_tmp=300;     % C   manifold temp

% engine thermal model
vinf.init_conds.fc_c_init_tmp=150;     % C      initial eng cyl temp
vinf.init_conds.fc_i_init_tmp=96;      % C      initial eng int temp
vinf.init_conds.fc_x_init_tmp=90;      % C      initial eng ext temp
vinf.init_conds.fc_h_init_tmp=35;      % C      initial hood temp

% battery thermal model
vinf.init_conds.ess_mod_init_tmp=35;   % C      initial eng cyl temp

% motor/controller thermal model
vinf.init_conds.mc_init_tmp=40;   % C      initial eng cyl temp

if strcmp(vinf.drivetrain.name,'ev')
	vinf.init_conds.ess_init_soc=1;%initial soc
    vinf.init_conds.ess2_init_soc=1;
else 
	vinf.init_conds.ess_init_soc=0.7;%initial soc
    vinf.init_conds.ess2_init_soc=0.7;
end

if isfield(vinf,'fuel_converter')
    if strcmp(vinf.fuel_converter.type,'VT')
        vinf.init_conds.fc_system_init_temp=340; % initial fuel cell system temperature (K)
    end
end

%evaluate all the initial conditions in the base workspace
tempnames=fieldnames(vinf.init_conds);%get all the names of the variables pertaining to initial conditions
for tempindex=1:max(size(tempnames))
   assignin('base',tempnames{tempindex},eval(['vinf.init_conds.',tempnames{tempindex}]));
end

%clear variables used only temporarily
clear tempnames tempindex

%12/17/98 ss,sb added 5 variables for new engine thermal model.
%12/21/98 ss made fc_coolant_init_temp(old) equal to fc_i_init_temp
%12/24/98 ss: changed the way this file works.  First assign to vinf. variable then eval in the base.
%09/08/99: vhj, added ess_init_soc
%10/25/99: vhj added check for ess_on existence
% 9/20/02:tm added fuel cell system initial temp definition
% 1/22/03: ss added if isfield(vinf,'fuel_converter') to allow vehicles
% without fuel_converters to run (ex. EV)