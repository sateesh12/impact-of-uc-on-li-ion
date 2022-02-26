% ADVISOR data file:  WH_CYCLE.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
%
% Created on: 6/19/01
% By:  tony_markel@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for motorcycle';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_CYCLE - ',wh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE AND MASS RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle test mass vector used in tandem with "wh_axle_loss_trq" to estimate
% wheel and axle bearing and brake drag
wh_axle_loss_mass=[0 2000];   % (kg)
% (tractive force on the front tires)/(weight on front axle), used in tandem
% with "wh_slip" to estimate tire slip at any time
wh_slip_force_coeff=[0 0.3913 0.6715 0.8540 0.9616 1.0212];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drag torque applied at the front (drive) axle, used with "wh_axle_loss_mass"
wh_axle_loss_trq=[4 24]*.1;   % (Nm)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_radius=23.8/39.37/2; % bridgestone and ecycle websites, Front Tire:  MT 75, 110/70-17 Rear Tire:  MT 75, 130/70-17 
wh_inertia=0;  % (kg*m^2) 
% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
wh_fa_dl_brake_frac=[0 0 0.7 0.8 0.8];  % (--)
% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
wh_fa_fric_brake_frac=[0.6 0.6 0.3 0.2 0.1];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

wh_1st_rrc=0.009; % (--), rolling resistance coefficient, estimate
wh_2nd_rrc=0; % (s/m)

wh_mass=0;

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
% 6/19/01:tm file created
% 4/4/02: mpo added rolling resistance coefficient data to this file (from vehicle wh_1st_rrc wh_2nd_rrc)
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models