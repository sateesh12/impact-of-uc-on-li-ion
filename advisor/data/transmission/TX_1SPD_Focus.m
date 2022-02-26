% ADVISOR data file:  TX_1SPD_Focus.m
%
% Data source: Brian Andonian (bandoman@umich.edu)
%
% Data confirmation:  None
%
% Notes:
% This file defines a 1-speed gearbox by defining a gear ratio and gear number
% Assumption is original 5-spd gearbox with only 2nd gear enganged, other gears are disabled,
% and calling TX_VW to define loss characteristics.
%
% Created on: 24-Jun-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
% Modified on:  02-Apr-2001 by:  Brian Andonian 
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
   % gear ratio to allow 100 mph given the max. motor speed and 10% wheel slip
   target_ratio=max(mc_map_spd*mc_spd_scale)/(100*0.447/wh_radius*1.10);
else  % using a 1-spd tranny with a piston engine! - let it do 65 mph
   target_ratio=max(fc_map_spd*fc_spd_scale)/(65*0.447/wh_radius*1.10);
end
%gb_ratio=ones(1,2)*target_ratio;  
%it is assumed that the EV Focus will use 2nd gear and the final drive  ratio of 3.82
%the other gears in the gearbox will be removed
gb_ratio=ones(1,2)*7.4171;  %manually set the overall Gearbox ratio to 7.4171 - determined by team
clear target_ratio


%TX_VW % FILE ID, LOSSES  - RUN TX_VW routine to estimate losses from trans.  ADVISOR Default.
load tx_focus; % load the *.mat file that defines tx_eff_map, tx_map_trq, and tx_map_spd

gb_trq_scale=1;
gb_spd_scale=1;
gb_mass=0; % (kg), Note: mass of the gearbox is included in veh_glider_mass

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;
gb_inertia=0;

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=1.0;   % (--), =(final drive input speed)/(f.d. output speed) - accounted for in gb_ratio, above
fd_inertia=0.060; % (kg*m^2), rotational inertia of final drive, estimated - BJA
fd_mass=0; % (kg), mass of the final drive is included in veh_glider_mass

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

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
% 04/02/01; bja modifed for class project, ece546, University of Michigan, Dearborn
% 08/15/01: mpo updated for advisor 3.2