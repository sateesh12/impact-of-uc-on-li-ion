% ADVISOR data file:  TX_PRIUS_CVT_JPN.m
%
% Data source: 
%
% Data confirmation:
%
% Notes:
% This file defines a CVT gearbox(planetary gear set) for the PRIUS_JPN
% 
%
% Created on: 25-Jun-1999
% By:  SS, NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='prius_jpn cvt';
tx_version=2003;
tx_description='Prius_jpn CVT';
gb_description='Prius_jpn CVT';
tx_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
tx_validated=0;    % 0=> no validation, 1=> confirmed agreement with source data,
% 2=> agrees with source data, and data collection methods have been verified
disp(['Data loaded: TX_PRIUS_CVT_JPN - ',tx_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prius japanese planetary gear numbers
tx_pg_s=30; %number of teeth in sun gear
tx_pg_r=78; %number of teeth in ring gear

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=3.93;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=0; % (kg), mass of the final drive - 1990 Taurus, OTA report
gb_mass=0;
tx_mass=0; % (kg), mass of the transmission 

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

% these are default values and will have no impact in block diagram
% they will impact mass calculations
gb_spd_scale=1;
gb_trq_scale=1;
gb_eff_scale=1;

% required to be defined for use in block diagram however value has no impact on results
gb_shift_delay=0; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 06/25/99:ss created
% 9/23/99:ss removed unnecessary variables.
% 11/03/99:ss updated version from 2.2 to 2.21
% 8/21/00:tm added gb_spd_scale, gb_trq_scale, gb_eff_scale
% 1/26/01:tm added gb_shift_delay for use with default block diagrams
% 2/2/01: ss updated prius to prius_jpn
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)