% ADVISOR data file:  TX_1SPD_BUS.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:
% This file defines a 1-speed gearbox meant to simulate a series hybrid bus single-reduction
% transmission.
%
% Created on: 08-August-2001
% By:  MPO, NREL, michael_o'keefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 1 speed';
tx_description='1-speed gearbox--especially for hybrid transit bus applications';
tx_version=2003;
disp(['Data loaded: TX_1SPD_BUS - ',tx_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_gears_num=1;  % (--), number of gears in gearbox
%if exist('mc_map_spd')
%   % gear ratio to allow 90 mph given the max. motor speed and 10% wheel slip
%   target_ratio=max(mc_map_spd*mc_spd_scale)/(90*0.447/wh_radius*1.10);
%else  % using a 1-spd tranny with a piston engine! - let it do 65 mph
%   target_ratio=max(fc_map_spd*fc_spd_scale)/(65*0.447/wh_radius*1.10);
%end
%gb_ratio=ones(1,2)*target_ratio;  
gb_ratio = [4.66 4.66]; % ratio provided by Nova Bus in a phone conversation
%clear target_ratio


%TX_VW % FILE ID, LOSSES
gb_inertia=0;

tx_eff_map=[0.96 0.96;0.96 0.96]; % constant 96% efficiency assumed, low estimate?
tx_map_spd=[0 1];
tx_map_trq=[-1 1];
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
%fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_ratio=5.857; % info from Nova Bus 19 March 2001
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input

gb_mass=0; % (kg), mass of the gearbox, estimated; assuming no significant gearbox weight for 1-spd
fd_mass=(200)/2.205; % (kg), mass of final drive estimated

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% Begin added by ADVISOR 3.2 converter: 08-Aug-2001
gb_spd_scale=1;

gb_trq_scale=1;

tx_mass_scale_coef=[1 0 1 0];

tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
% End added by ADVISOR 3.2 converter: 08-Aug-2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98:tm gb_mass added
%9/30/98:ss added fd variables and added tx_mass
%10/16/98:ss renamed to TX_1SPD was GB_1SPD
%12/22/98:ss added variable tx_type to determine what block diagram to run.
% 11/03/99:ss updated version from 2.2 to 2.21
% 08/08/01:mpo created from TX_1SPD and update from 3.1 to 3.2
% 08/10/01:mpo changed mass of transmission to more reflect that of a bus