% ADVISOR data file:  TX_5SPD_CI.m
%
% Data source: Mass was taken from "Automotive Technologies 
% to Improve Fuel Economy to 2015" prepared for the Office 
% of Technology Assessment by Energy and Environmental 
% Analysis, Inc. Draft report Dec. 1994.
% Gear ratios from VW brochure for Jetta.
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
disp('Data Loaded: TX_5SPD_CI - manual 5-speed transmission especially for CI engines');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The tested transmission had four gears, with the gear ratios listed
% as the first four entries in 'gb_ratio,' below.

gb_ratio=[3.78 2.12 1.35 0.97 0.76]*3.24; % '97 Jetta 90-hp 1.9-L TDI
gb_gears_num=5;


%TX_VW % FILE ID, LOSSES
load tx_97jetta_26_50_5; % loads the efficiency map and information for this transmission 
% ...with above stated gear ratios

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
%04/01/99:mc started w/ TX_5SPD, updated gb_ratio to TDI-powered Jetta values
% 11/03/99:ss updated version from 2.2 to 2.21
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)