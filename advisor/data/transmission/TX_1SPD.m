% ADVISOR data file:  TX_1SPD.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:
% This file defines a 1-speed gearbox by defining a gear ratio and gear number,
% and calling TX_VW to define loss characteristics.
%
% Created on: 24-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 1 speed';
tx_version=2003;
disp('Data loaded: TX_1SPD - 1-speed transmission')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_gears_num=1;  % (--), number of gears in gearbox
if exist('mc_map_spd')
   % gear ratio to allow 90 mph given the max. motor speed and 10% wheel slip
   target_ratio=max(mc_map_spd*mc_spd_scale)/(90*0.447/wh_radius*1.10);
else  % using a 1-spd tranny with a piston engine! - let it do 65 mph
   target_ratio=max(fc_map_spd*fc_spd_scale)/(65*0.447/wh_radius*1.10);
end
gb_ratio=ones(1,2)*target_ratio;
clear target_ratio


%TX_VW % FILE ID, LOSSES

gb_mass=0; % (kg), mass of the gearbox 

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input

% below, the loss map for this 1 speed transmission is calculated
gb_vars.gb_loss_input_spd_coeff=0.614307976;  % loss coefficiencts from old eff equation (TX_VW)
gb_vars.gb_loss_output_spd_coeff=5.530953616; % ""
gb_vars.gb_loss_input_trq_coeff=-0.861652506; % ""
gb_vars.gb_loss_output_trq_coeff=0.229546756; % ""
gb_vars.gb_loss_output_pwr_coeff=0.023981187; % ""
gb_vars.gb_loss_const=-92.07523029;           % ""
w.vals = [0:1:20,25:5:400]; % transmission output speeds to evaluate efficiency at
T.vals = [-1000:400:-200,-150,-100:10:-40,-36:2:-2,2:2:36,40:10:100,150,200:400:1000]; % transmission output torque to evaluate efficiency at
% Note: although a 1-spd gearbox is required to have gb_ratio of length two (where both elements are the same),
% ...there is no need to make two efficiency maps. Therefore, only one gb_ratio is fed into the below function.
[tx_eff_map, tx_map_spd, tx_map_trq] = tx_eff_mapper(gb_vars,w,T,gb_ratio(1)); % create efficiency map and T, w index

clear w T gb_vars;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=110/2.205; % (kg), mass of the final drive - 1990 Taurus, OTA report

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98:tm gb_mass added
%9/30/98:ss added fd variables and added tx_mass
%10/16/98:ss renamed to TX_1SPD was GB_1SPD
%12/22/98:ss added variable tx_type to determine what block diagram to run.
% 11/03/99:ss updated version from 2.2 to 2.21
% 9-July-2001:mpo updated to use lookup table method for transmission gearbox efficiency and
% ................made file self-sufficient (i.e., no longer calls tx_vw)
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)