% ADVISOR data file:  WH_FOCUS_REGEN.m
%
% Data source: B. Andonian, published data
%
% Data confirmation: None
%
% Notes:
% Defines tire, wheel, and axle assembly parameters for use with ADVISOR 3.1, for
% a Ford Focus
%
% Created on: 03/12/01
% By:  Brian Andonian (bandoman@umich.edu)
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for Ford Focus';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_FOCUS_REGEN - ',wh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE AND MASS RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle test mass vector used in tandem with "wh_axle_loss_trq" to estimate
% wheel and axle bearing and brake drag
wh_axle_loss_mass=[0 2000];   % (kg), Advisor Default
% (tractive force on the front tires)/(weight on front axle), used in tandem
% with "wh_slip" to estimate tire slip at any time
% values below are ADVISOR defualts for small car
wh_slip_force_coeff=[0 0.3913 0.6715 0.8540 0.9616 1.0212];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drag torque applied at the front (drive) axle, used with "wh_axle_loss_mass"
wh_axle_loss_trq=[4 24]*.4;   % (Nm)  - Advisor Default (effects of bearings and friction)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
% values below are ADVISOR defaults
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%note:  rev/mile=809, P225/55R16  per B. Andonian calculations, therefore:
wh_radius=0.3166;    % (m), rolling radius of P225/55R16 tire from a Ford Mustang GT
%note: above rolling radius is very close to P215/45ZR17 tire which is desired tire size for this vehicle.
                    
% rotational inertia of all wheels and tires 
% below is the measured wheel and tire intertia of the P225/55 R16 tire used on the 
% Ford Mustang 4.6L GT
wh_inertia=4*0.8148;  % (kg*m^2) ;  Published data, internal source - B. Andonian
% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
%wh_fa_dl_brake_frac=[0 0 0 0.8 0.9 0.9];  % (--)
wh_fa_dl_brake_frac=[0 0 0.4 0.8 0.9 0.9];  % (--)  estimate, B. Andonian
% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
% Note: the following values are all ADVISOR Defaults
wh_fa_fric_brake_frac=[1 1 0.6 0.2 0.1 0.1];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 15 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

wh_1st_rrc=0.008630; % (--), 1st rolling resistance coefficient, from VEH_FOCUS
wh_2nd_rrc=0; % (s/m), 2nd rolling resistance coefficient

wh_mass=0;   %note - mass of wheel is included in vehicle file

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
%03/12/01 - initial release Brian Andonian 
% 4/4/02: mpo added rolling resistance coefficient data to this file (from vehicle wh_1st_rrc wh_2nd_rrc)
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models