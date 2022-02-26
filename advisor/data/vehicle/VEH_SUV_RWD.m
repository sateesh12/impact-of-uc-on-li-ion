% ADVISOR data file:  VEH_SUV_RWD.m
%
% Data source: Road and Track, web, other publications
%
% Data confirmation: Input data agrees with sources
%
% Notes:  veh_cg_height and veh_front_wt_frac set to simulate a rear wheel drive vehicle.
%         Defines road load parameters for an average SUV.
%			 The data came from an average of the 1998 Ford Explorer, Jeep
%		    Grand Cherokee, and a Chevy Blazer
% Created on: 9/20/99 from VEH_SUV
% By:  SS of NREL, sam_sprik@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Average 1998 U.S. SUV';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_SUV - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual average vehicle mass of the 3 SUVs used to create this
%		vehicle file is 3997 pounds.  If you wish to accurately set your total
% 		vehicle mass to this value in the A2 GUI, you should use the mass override
%		checkbox and enter in the value 1949, which is (3997+300)/2.205 = 1949 kg, which comes from
%		adding on 300 lbs of EPA test mass, and then converting pounds to kilograms.
%		The glider mass below is just an estimate that gives 3997 pounds for a 144 kW
%		scaled SI102 engine in a conventional vehicle with 5-speed transmission.
veh_glider_mass=(3997/2.205)-633; % (kg), vehicle mass w/o propulsion system (fuel converter,
												% exhaust aftertreatment, drivetrain, motor, ESS, generator)
                                    % Note that this is an estimate, because it depends which
                                    % propulsion system is being used
veh_CD=0.44;  % (--), source: Keith Hardy (verbal), CSMI
veh_FA=2.66;    % (m^2), frontal area (mfg. data through DOT)
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.012;  % (--)   source: Keith Hardy (verbal), CSMI
%veh_2nd_rrc=0;		% (s/m)
% fraction of vehicle weight on front axle when standing still(set to rear weight fraction by subtracting from 1)
veh_front_wt_frac=(1-0.555); % ave SUV % wgt on front tires (from Consumer Reports)
% height of vehicle center-of-gravity above the road(set to negative for rear wheel drive)
veh_cg_height=-0.7;      % m, estimated for ave SUV (Saturn SL is 0.5 m)
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.75;     % m, ave SUV=108" from Consumer Reports (Saturn SL is 2.6, GM Impact is 2.51 m)

veh_cargo_mass=136; %kg  cargo mass

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created 9/20/99 SS from VEH_SUV.  Set veh_cg_height and veh_front_wt_frac appropriately for Rear Wheel Drive.
% 11/03/99:ss updated version from 2.2 to 2.21
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc