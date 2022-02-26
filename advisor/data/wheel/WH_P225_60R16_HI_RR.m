% ADVISOR data file
%
% Data source: Rolling resistance data provided by Michelin.
%
% Data confirmation: Michelin test data.
%
% Notes:
% Defines tire, wheel, and axle assembly parameters for use with ADVISOR 2002+
% This data is indicative of a higher rolling resistance production tire measured by Michelin.
% Rolling resistance data for use with the J2452 rolling resistance model provided by Michelin.
% Tire Size: P225/60R16
% Example Vehicle Application: Dodge Intrepid
% Note:  example vehicle is one possible vehicle that utilizes this tire
%
% Created on: March 26, 2002
% By:  SS,KK - NREL 
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for sport utility (SUV)';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_P225_60R16_HI_RR - ',wh_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rolling Resistance Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Higher rolling resistance tire parameters:

veh_rr_alpha = -0.5888;
veh_rr_beta = 1.0921;
veh_rr_a = 0.0793;
veh_rr_b = 1.18E-04;
veh_rr_c = 0.352E-06;

%   Fr=P^alpha*Z^beta*(a + b*V + c*V^2)

%   Fr = rolling resistance force (N)
%   P = Tire Pressure (kPa)
%   Z= Load on tire (N)
%   V = velocity (m/s)

%Rolling resistance coefficients are measured on a roadwheel
%Flat surface values will differ from curved surface values
%Adjustments are made using SAE J2452 Eq. 22

%This is the radius of the dynamometer road wheel used
%    for the curvature correction factor

veh_roadwheel_radius=0.85; %(m) 

wh_pressure = 240; %(kPa) Tire inflation pressure

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
wh_axle_loss_trq=[4 24]*.4;   % (Nm)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_radius=0.330;    % (m), tire rolling radius 
                    
% (m), Tire Size: P225/60R16 
% tire diameter = (2*225*0.60)+ 16"(25.4)= 676.4 mm
% average P205/60R15 tire spec's: 777 rev/mile at 45 mph loaded

% rotational inertia of all wheels, tires, and axles
% below uses OTA's '94 estimate of Taurus wheel, tire & tool mass as mass of
% solid cylinders of radius wh_radius, rotating at wheel speed in this vehicle
wh_inertia=181/2.205*wh_radius^2/2;  % (kg*m^2) 
% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
wh_fa_dl_brake_frac=[0 0 0.5 0.8 0.8];  % (--)
% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
wh_fa_fric_brake_frac=[0.8 0.8 0.4 0.1 0.1];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

% mass of tire alone is 8.23 (kg)
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
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models