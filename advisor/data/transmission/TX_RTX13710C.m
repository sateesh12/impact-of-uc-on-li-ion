% ADVISOR Data file:  TX_RTX13710C.M
%
% Data source:  Data was obtained from the Eaton/Fuller website
% http://truck.eaton.com.
%
% Data confidence level:  no comparison has been performed
%
% Notes:  This is the stock transmission for the Kenworth T800
%
% Created on: 10/23/98
% By:  Tony Markel, National Renewable Energy Laboratory, Tony_Markel@nrel.gov
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_description='Eaton Fuller RTX-13710C 10-Speed Transmission'; 
% one line descriptor identifying the engine
gb_version=2003; % version of ADVISOR for which the file was generated
gb_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gb_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_RTX13710C.M - ',gb_description]);

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 5 speed';

% Final drive variables
% this information pertians to a Eaton Fuller DS-404 rear axle
% data obtained from Eaton Fuller website
fd_ratio = 3.25; % rear axle differential gear ratio 
fd_inertia=0; % unknown (kg*m^2)
fd_loss=0; % unknown (N*m)

% Transmission information
gb_ratio = [12.8 9.25 6.76 4.90 3.58 2.61 1.89 1.38 1.00 0.73];  % transmisson gear ratios
gb_gears_num = max(size(gb_ratio));

%TX_HEAVY % FILE ID, LOSSES
% 92% efficienct gearbox
% NOTES: (6 July 2001, mpo) changing from equation form of transmission efficiency to lookup method
tx_map_spd=[0 10000]; % speed of transmission shaft output (wheel-side of transmission) in rad/s
tx_map_trq=[-10000 10000]; % torque of transmission shaft output (wheel-side of transmission) in Nm
tx_eff_map=[0.92 0.92;0.92 0.92]; % transmission efficiency; row index is tx_map_spd, col index is tx_map_trq

gb_mass = 600/2.2046; % nominal transmission mass w/o fluids (kg)
fd_mass = 0; % (kg) unknown

% the following variable is not used directly in modelling and should always be equal to one
% it's used for initialization purposes
gb_eff_scale=1;
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/23/98:tm file created
% 2/24/99:tm updated for march 99 release
% 3/15/99:ss updated *_version to 2.1 from 2.0


% 11/03/99:ss updated version from 2.2 to 2.21
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)