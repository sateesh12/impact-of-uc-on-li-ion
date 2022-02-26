% ADVISOR Data file:  VEH_RTS06.M
%
%
% Data source:  Various company literature and spec sheets from Nova BUS (TMC)
%
% Data confidence level:  {provide details as to how well the data 
% represents the source data.}
%
% Notes:  {include any other comments pertaining to the data or use 
% the data} 
%
% Created on:  Oct 2000
% By:  Michael O'Keefe, NREL, Michael_O'Keefe@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Nova (TMC) RTS-06 40 foot Transit Bus'; % one line descriptor identifying the engine
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_RTS06.m - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.23; % kg/m^3


% Vehicle data
veh_CD=0.79; % for a transit bus (ref. SAE 931788)
veh_FA=85*9.290e-2;	% (m^2) width*height-clearance given in inches, from test data collected for actual bus
%veh_FA=6.52;	% (m^2) (ref. SAE 931788)
%veh_1st_rrc=0.01; % taken from SwRI report, 2000, McBroom, et. al.
% (2000) McBroom, et.al., "Roadmap to Obtain Vehicle Efficiency Goals for 21st Century
%									Truck", Southwest Research Institute
%veh_1st_rrc=0.00938; % for truck (ref. WVU test data)
%veh_2nd_rrc=0;	% unknown 
veh_cg_height=0.25*122/39.37; % unknown (m)
% The below variable is the "front" weight fraction but "front" is taken to mean the wheels
% that are being "driven". Thus, the value should represent the weight percent on the 
% rear axle since the bus is rear wheel drive...
veh_front_wt_frac=1-0.365; % from actual test data--weight on true front axle varies from 0.35 to 0.382 for curb weight to GVW
veh_wheelbase=292.8/39.37; % (m) from actual vehicle test data
veh_glider_mass = 12156; % (kg) the curb weight for actual vehicle
veh_cargo_mass=150/2.2046*27; % (kg) 27 people at 150 lbs/person (1/2 passenger load) (ref. SAE 931788)

%revision history
% 11/4/98:tm file created from veh_kent800.m
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 10/2000: mpo created from VEH_ORIONVI.m
% 01/19/2001: mpo updated version number to 3.1 from 3.0
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc