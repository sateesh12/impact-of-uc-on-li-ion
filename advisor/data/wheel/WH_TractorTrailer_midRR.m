% ADVISOR data file:  WH_TractorTrailer_midRR.m
%
% Data source: Michelin testing.
%
% Data confirmation: Michelin experiments.
%
% Notes:
% Defines tire, wheel, and axle assembly parameters for use with ADVISOR. For
% a heavy vehicle with low rolling resistance conventional tires.
% Data provided as low/medium/high rolling resistance values by Michelin for representative tires
% Data is specified by tread design for a tractor trailer (i.e., steering tires, drive tires, trailer tires)
%
% Created on: 02-April-2002
% By: Michael O'Keefe, NREL, Michael_OKeefe@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for a Tractor Trailer Truck (mid-range rolling resistance tires)';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_TractorTrailer_midRR - ',wh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE AND MASS RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle test mass vector used in tandem with "wh_axle_loss_trq" to estimate
% wheel and axle bearing and brake drag
wh_axle_loss_mass=[0 5000 10000 15000 30000];   % (kg)
% (tractive force on the front tires)/(weight on front axle), used in tandem
% with "wh_slip" to estimate tire slip at any time
wh_slip_force_coeff=[0 0.3913 0.6715 0.8540 0.9616 1.0212];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drag torque applied at the front (drive) axle, used with "wh_axle_loss_mass"
%wh_axle_loss_trq=[4 24 48 72 144]*.4;   % (Nm)
wh_axle_loss_trq=[0 500 1000 1500 3000]*0.03;   % (Nm)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIRE DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for a listing of heavy vehicle tire data, type
% "load_in_browser('hvy_veh_tires.html')" on the command line.
wh_radius=0.501;    % (m), rolling radius of the drive tires, 275/80R22.5 (mid RR) assumed

% rotational inertia of all wheels, tires, and axles
% below uses OTA's '94 estimate of Taurus wheel, tire & tool mass as mass of
% solid cylinders of radius wh_radius, rotating at wheel speed in this vehicle
wh_inertia=181*2/2.205*wh_radius^2/2;  % (kg*m^2) unknown, default value

% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
wh_fa_dl_brake_frac=[0 0 0.5 0.8 0.8];  % (--)
% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
wh_fa_fric_brake_frac=[0.8 0.8 0.4 0.1 0.1];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

wh_mass=80*18; % (kg), assume 80 kg/ea. tire&wheel assembly times 18 tires [ref. SAE 2000-01-3432]

% the source for the rolling resistance data is in hvy_veh_tires.html of the advisor/documentation directory
rrc0_steer=0.00535; % (N/N) Force of rolling resistance per force of loading (wheel/axle loading/weighting), 315/80R22.5 (mid RR)
rrc0_drive= 0.00650;% (N/N) Force of rolling resistance per force of loading (wheel/axle loading/weighting), 275/80R22.5 (mid RR)
rrc0_trailer= 0.00482;% (N/N) Force of rolling resistance per force of loading (wheel/axle loading/weighting), 275/80R22.5 (mid RR)

% the following is the assumed weight distribution over the steer, drive, and trailer tires/axles
% note that the weight fraction over each category is the total weight over that category (i.e., not just one tire)
% total wt_frac should sum to 1.0
% it is assumed that the vehicle is a tractor trailer with total mass around 39040 kg
wt_frac_steer=0.1; % unknown, this is an educated guess assuming fully loaded trailer...
wt_frac_drive=0.4; % ...with roughly half of mass on front (drive and steer with drive being 80%) and remaining 50% at rear
wt_frac_trailer=1.0-wt_frac_steer-wt_frac_drive; % constrain to sum to 1.0
% (N/N) Force of rolling resistance per force of loading (wheel/axle loading/weighting)
wh_1st_rrc = (rrc0_steer*wt_frac_steer)+(rrc0_drive*wt_frac_drive)+(rrc0_trailer*wt_frac_trailer);
wh_2nd_rrc = 0; % assumption is that rrc dependence on speed can be neglected for heavy vehicle tires

clear wt* rrc0*; % we don't need to send these variables to the workspace--just preprocessing
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
% 03-APR-2002 [mpo]: file first created
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models