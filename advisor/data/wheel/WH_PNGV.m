% ADVISOR data file:  WH_PNGV.m
%
% Data source: some data came from CSMI, remainder were assumptions
%
% Data confirmation: none
%
% Notes:
% Defines tire, wheel, and axle assembly parameters for use with ADVISOR 2, for
% PNGV-type vehicle (data provided by CSMI where noted).  Based on WH_P2000
%
% Created on: 22-oct-1998
% By:  SS, NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for PNGV type of vehicle';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_PNGV - ',wh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE AND MASS RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle test mass vector used in tandem with "wh_axle_loss_trq" to estimate
% wheel and axle bearing and brake drag
wh_axle_loss_mass=[0 2000];   % (kg)
% (tractive force on the front tires)/(weight on front axle), used in tandem
% with "wh_slip" to estimate tire slip at any time
wh_slip_force_coeff=[0 0.3913 0.6715 0.8540 0.9616 1.0212];  % (--) stickier tires for A2.1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drag torque applied at the front (drive) axle, used with "wh_axle_loss_mass"
wh_axle_loss_trq=[4 24]*.4;   % (Nm)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_radius=0.287;    % wheel radius from Toyota Prius was used here
						  % ss 5/5/1999,  (m), rolling radius of 165/65R15 tire from a
                    % Toyota Prius (0.287 m, from rolling test conducted at unique)
% wh_radius=0.260;    % (m), rolling radius provided by CSMI
% rotational inertia of all wheels, tires, and axles
wh_inertia=2.03;  % (kg*m^2) this is sum of data provided by csmi: 1 (front wheels)+1 (rear wheels)+.03 (axles) 
% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
wh_fa_dl_brake_frac=[0 0 0.5 0.8 0.8];  % (--)
% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
wh_fa_fric_brake_frac=[0.8 0.8 0.4 0.1 0.1];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

wh_mass=0;  % (kg) assumed included in veh_mass

wh_1st_rrc=0.007; % (--), rolling resistance coefficient, used to be in VEH_PNGV
wh_2nd_rrc=0; % (s/m)
%%%%%%%%%%%%%%%%%
% Error checking
%%%%%%%%%%%%%%%%%
% dl+fa_fric must add up to <= 1 for all speeds.  Give user warning if in error
temp_total_braking=wh_fa_dl_brake_frac+wh_fa_fric_brake_frac;
if any(temp_total_braking>1)
    disp('Warning: Driveline and Front Friction Braking need to add to less than or equal to 1 for')
    disp('         all speeds.  Please edit either wh_fa_dl_brake_frac or wh_fa_fric_brake_frac');
    disp('         in WH_*.m.  See Chapter 3.2.4, Braking of the documentation for more info.');
end
clear temp_total_braking

% front or rear or both axles driving?
wh_front_active_bool=1; % 0==> inactive; 1==> active
wh_rear_active_bool=0; % 0==> inactive; 1==> active

% braking force limits
wh_max_front_brake_force=-inf;% (N)
wh_max_rear_brake_force=-inf;% (N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9/17/98 ss created for csmi data analysis
% 9/08/99 KW cleaned up for public release
% 11/03/99:ss updated version from 2.2 to 2.21
%01/10/01: vhj added error checking (warning to user about incorrect braking numbers)
% 4/4/02: mpo added rolling resistance coefficient data to this file (from vehicle wh_1st_rrc wh_2nd_rrc)
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models