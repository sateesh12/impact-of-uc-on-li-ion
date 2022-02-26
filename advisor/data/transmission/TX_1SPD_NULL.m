% ADVISOR data file:  TX_1SPD_NULL.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:
%
% Created on: 7/24/00
% By:  TM, NREL, tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 1 speed';
tx_version=2003;

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
TX_NULL % FILE ID, LOSSES

gb_mass=0; % (kg), mass of the gearbox 

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
%fd_mass=110/2.205; % (kg), mass of the final drive - 1990 Taurus, OTA report
fd_mass=0; % (kg), mass of the final drive - 1990 Taurus, OTA report

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7/24/00:tm file created from TX_1SPD
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)