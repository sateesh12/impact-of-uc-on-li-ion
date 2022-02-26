% ADVISOR data file:  TX_5SPD.m
%
% Data source: Mass was taken from "Automotive Technologies 
% to Improve Fuel Economy to 2015" prepared for the Office 
% of Technology Assessment by Energy and Environmental 
% Analysis, Inc. Draft report Dec. 1994.
%
% Data confirmation:
%
% Notes:
% This file defines a 5-speed gearbox by defining gear ratios and gear number,
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
tx_type='manual 5 speed';
tx_version=2003;
disp('Data loaded: TX_5SPD - manual 5-speed transmission')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The tested transmission had four gears, with the gear ratios listed
% as the first four entries in 'gb_ratio,' below.

gb_ratio=[13.45 7.57 5.01 3.77 3.77*3.77/5.01];
gb_gears_num=5;


%TX_VW % FILE ID, LOSSES
load tx_vw_eff_map_26_50_5; % loads the efficiency map for this transmission
% ...three variables are loaded--tx_eff_map, tx_map_spd, tx_map_trq
% note: the function tx_eff_mapper.m from <ADVISOR directory>/gui is used to generate efficiency values

gb_mass=141/2.205; % (kg), mass of the gearbox - 1990 Taurus, OTA Report

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

%final drive variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=110/2.205; % (kg), mass of the final drive - 1990 Taurus, OTA report

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/28/98:tm gb_mass added
%9/30/98:ss added fd variables and added tx_mass
%10/16/98:ss renamed to TX_5SPD, was GB_5SPD
%12/22/98:ss added variable tx_type to determine what block diagram to run.
% 11/03/99:ss updated version from 2.2 to 2.21
% 9-July-2001:mpo added functionality for transmission efficiency by lookup-table
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)