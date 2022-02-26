function recompute_mass
% masses in workspace are base masses without scaling effects, all scaling of masses takes place in this file only

global vinf
total_mass=0;

if isfield(vinf,'fuel_converter') 
    %fc_mass=round(evalin('base','fc_spd_scale*fc_trq_scale*fc_mass'));
    if strcmp(vinf.fuel_converter.ver,'fcell')&strcmp(vinf.fuel_converter.type,'VT')
        fc_bop_mass=round(evalin('base','fc_bop_mass_scale_fun(fc_bop_mass_scale_coef,fc_radiator_mass,fc_radiator_scale,fc_air_comp_mass,fc_air_comp_scale,fc_condenser_mass,fc_condenser_scale,fc_coolant_system_mass,fc_coolant_system_scale,fc_humidifier_mass,fc_humidifier_scale)'));
        assignin('base','fc_bop_mass',fc_bop_mass) % export to base workspace
        fc_mass=round(evalin('base','fc_mass_scale_fun(fc_mass_scale_coef,fc_cell_num,fc_cell_area,fc_stack_unit_mass/1000,fc_fuel_mass,fc_bop_mass)'));
        assignin('base','fc_mass',fc_mass) % export to base workspace
    else
        fc_mass=round(evalin('base','fc_mass_scale_fun(fc_mass_scale_coef,fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)'));
    end
    set(findobj('tag','fc_mass'),'string',num2str(fc_mass));
    total_mass=total_mass+fc_mass;
end
if isfield(vinf,'generator')
    if evalin('base','exist(''gc_trq_scale'')')==1 & evalin('base','exist(''gc_spd_scale'')')==1
        %gc_mass=round(evalin('base','gc_spd_scale*gc_trq_scale*gc_mass'))
        gc_mass=round(evalin('base','gc_mass_scale_fun(gc_mass_scale_coef,gc_spd_scale,gc_trq_scale,gc_mass)'));
        set(findobj('tag','gc_mass'),'string',num2str(gc_mass));
    elseif evalin('base','exist(''gc_user_imax93'')') & evalin('base','exist(''gc_user_imax12'')') & evalin('base','exist(''gc_mass_scale_coef'')')
        gc_mass=round(evalin('base','gc_mass_scale_fun(gc_mass_scale_coef,gc_user_imax93,gc_user_imax12)'));
        set(findobj('tag','gc_mass'),'string',num2str(gc_mass));
    elseif evalin('base','exist(''gc_mass'')')
        gc_mass=evalin('base','gc_mass');
        set(findobj('tag','gc_mass'),'string',num2str(gc_mass));
    end
    
    total_mass=total_mass+gc_mass;   
end
if isfield(vinf,'motor_controller')
    %mc_mass=round(evalin('base','mc_spd_scale*mc_trq_scale*mc_mass'));
    mc_mass=round(evalin('base','mc_mass_scale_fun(mc_mass_scale_coef,mc_spd_scale,mc_trq_scale,mc_mass)'));
    set(findobj('tag','mc_mass'),'string',num2str(mc_mass));
    total_mass=total_mass+mc_mass;
end
if isfield(vinf,'exhaust_aftertreat')
    %ex_mass=round(evalin('base','ex_mass*fc_pwr_scale'));
    ex_mass=round(evalin('base','ex_mass_scale_fun(ex_mass_scale_coef,fc_pwr_scale,ex_mass)'));
    set(findobj('tag','ex_mass'),'string',num2str(ex_mass));
    total_mass=total_mass+ex_mass;   
end
if isfield(vinf,'transmission')
    %tx_mass=evalin('base','round(gb_spd_scale*gb_trq_scale*tx_mass)');
    tx_mass=evalin('base','round(tx_mass_scale_fun(tx_mass_scale_coef,gb_spd_scale,gb_trq_scale,fd_mass,gb_mass))');
    set(findobj('tag','tx_mass'),'string',num2str(tx_mass));
    total_mass=total_mass+tx_mass;   
end
if isfield(vinf,'wheel_axle')
    wh_mass=evalin('base','round(wh_mass)');
    set(findobj('tag','wh_mass'),'string',num2str(wh_mass));
    total_mass=total_mass+wh_mass;   
end
if isfield(vinf,'vehicle')
    veh_mass=evalin('base','round(veh_glider_mass)');
    set(findobj('tag','veh_mass'),'string',num2str(veh_mass));
    total_mass=total_mass+veh_mass;   
end
if isfield(vinf,'energy_storage')
    %ess_mass=evalin('base','round(ess_module_mass*ess_module_num)');
    if evalin('base','exist(''ess_parallel_mod_num'')')
        ess_mass=evalin('base','round(ess_mass_scale_fun(ess_mass_scale_coef,ess_module_num*ess_parallel_mod_num,ess_cap_scale,ess_module_mass))');
    else
        ess_mass=evalin('base','round(ess_mass_scale_fun(ess_mass_scale_coef,ess_module_num,ess_cap_scale,ess_module_mass))');
    end
    set(findobj('tag','ess_mass'),'string',num2str(ess_mass));
    total_mass=total_mass+ess_mass;
end
if isfield(vinf,'energy_storage2')
    ess2_mass=evalin('base','round(ess2_mass_scale_fun(ess2_mass_scale_coef,ess2_module_num,ess2_cap_scale,ess2_module_mass))');
    set(findobj('tag','ess2_mass'),'string',num2str(ess2_mass));
    total_mass=total_mass+ess2_mass;
end

%cargo mass
cargo_mass=evalin('base','round(veh_cargo_mass)');
set(findobj('tag','cargo_mass'),'string',num2str(cargo_mass));
total_mass=total_mass+cargo_mass;

set(findobj('tag','calc_mass'),'string',num2str(round(total_mass)));

if get(findobj('tag','override_mass_checkbox'),'value')
    evalin('base','veh_override_mass_bool=1;')
    override_mass=str2num(get(findobj('tag','override_mass_value'),'string'));
    assignin('base','veh_override_mass',override_mass)
else
    evalin('base','veh_override_mass_bool=0;')
end

if isfield(vinf, 'variables')
    ans=strmatch('veh_mass',vinf.variables.name,'exact');
else 
    ans=0;
end

if ans
    assignin('base','veh_mass',vinf.variables.value(ans));
else
    assignin('base','veh_mass',round(total_mass));
end

%9/23/98am-ss added scaling factors in gc_mass calculation
% 2/2/99 4pm-ss changed to use available veh_cargo_mass instead of using a constant of 136
%	for cargo mass in the no gui case.
% 9/21/99:tm modified fc_mass calc so that it no longer references fc_map_spd and fc_max_trq
% 11/3/99:ss updated calcs for mc and gc mass and rearranged the way cargo mass was done to 
%            be consistent with others.  
% 11/04/99:ss added ex_mass to fuel_cell calc and simplified the way in which mc and gc mass was calculated.
% 8/2/00 ss: changed  if statements to check if component field existed in the vinf structure.
% 8/21/00:tm updated all references tx_mass to include gb_spd_scale and gb_trq_scale
% 2/2/01: ss updated prius to prius_jpn
% 2/12/01:tm added parallel_sa and insight to parallel case when input fig does not exist to work with p-study and advisor no gui
% 5/7/01: ss changed the way the override mass is handled, now it just checks to see if there is a modified variable in vinf
%             named veh_mass and uses that value if it exists.
% 7/27/01:tm eliminated get_current_str calls
% 7/27/01:tm removed check for input figure - set statements do not cause errors if the object can not be found
% 7/27/01:tm added calls to inline functions for ability to use user defined mass scaling
% 7/31/01:mpo added a semicolon to gc_mass call to avoid printout to workspace
% 4/23/02:mdz added a special case for computing 'ess_mass' when you have parallel strings of UltraCaps.
% 3/27/03:tm added case in the fuel converter mass calc for the vt fuel cell model
% 6/6/03:tm revised the case in fuel converter mass calc to include bop scale factors

