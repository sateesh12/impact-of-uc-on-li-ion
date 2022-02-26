% ADVISOR data file:  EX_FUELCELL_NULL.m
%
%
% Data confirmation:
%
% Notes:
% File for FUEL CELL runs with ex_calc=0 (no ex sys calculations) 
% Sets ex system mass (ex_mass) to zero 
% 
% Created on: 14-JAN-99
% By:  SDB, NREL, steve_burch@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_description='Null exhaust system for fuel cells';
ex_version=2003; % version of ADVISOR for which the file was generated
ex_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ex_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: EX_FUELCELL_NULL - ',ex_description])

ex_mass=0;          % kg     mass of exhaust system:   assumes reformer ex sys incl'd in fc_mass

ex_calc=0;          % 0=> skip ex sys calc (if fc has no emis maps or no cat info avail)
                    % 1=> perform ex sys calcs including tailpipe emis
ex_ornl_bool=0;			%1->Use efficiencies from ORNL data
						%0->Use basic ADVISOR removal efficiencies
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EX SYS VARIABLES (Must be defined, but are not used since ex_calc=0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_tmp_range=[0 1];   % C
ex_cat_hc_frac=[0 0];     % (--)
ex_cat_co_frac=[0 0];     % (--)
ex_cat_nox_frac=[0 0];    % (--)
ex_cat_pm_frac=[0 0];     % (--)
ex_cat_lim= [1 1 1 1]';   % g/s    "break-thru" limit of converter (HC, CO, NOx)
 ex_cat_mass=1;           % kg     mass of catalytic converter (from 1994 OTA report, Table 3)
  ex_cat_mon_mass=1;      % kg     mass of cat monolith (ceramic)
  ex_cat_int_mass=1;      % kg     mass of cat internal SS shell 
  ex_cat_pipe_mass=1;     % kg     mass of cat inlet/outlet pipes
  ex_cat_ext_mass=1;      % kg     mass of cat ext shell (shield)
 ex_manif_mass=1;         % kg     mass of engine manifold & downpipe
 ex_muf_mass=1;           % kg     mass of muffler and other pipes downstream of cat
 ex_cat_pcm_mass=1;       % kg     mass of cat phase change mat'l heat storage 
ex_cat_mon_cp=1;          % J/kgK  ave cp of cat int: CERAMIC MON. (SAE #880282)
ex_cat_int_cp=1;          % J/kgK  ave cp of cat int: METAL MON. (SAE #890798)
ex_cat_pipe_cp=1;         % J/kgK  ave sens heat cap of cat i/o pipes (SAE #890798)
ex_cat_ext_cp=1;          % J/kgK  ave sens heat cap of cat ext (SAE #890798)
ex_manif_cp=1;            % J/kgK  ave sens heat cap of manifold & dwnpipe (SAE #890798)
ex_gas_cp=1;              % J/kgK  ave sens heat cap of exh gas (SAE #890798)
ex_cat_pcm_tmp=[0 1];    % C      temp range for cat pcm ecp vec
ex_cat_pcm_ecp=[0 0];     % J/kgK  ave eff heat cap of pcm (latent + sens)
ex_cat_mon_sarea=1;       % m^2    outer surface area of cat monolith
ex_cat_monf_sarea=1;      % m^2    surface area of cat monolith front face
ex_cat_moni_sarea=1;      % m^2    inner (honeycomb) surf area of cat monolith
ex_cat_int_sarea=1;       % m^2    surface area of cat interior
ex_cat_pipe_sarea=1;      % m^2    surface area of cat i/o pipes
ex_cat_ext_sarea=1;       % m^2    surface area of cat ext shield
ex_manif_sarea=1;         % m^2    surface area of manif & downpipe: pi*D*L
ex_cat_m2p_emisv=1;       %        emissivity x view factor from cat monolith to cat pipes
ex_cat_i2x_emisv=1;       %        emissivity from cat int to cat ext shield
ex_cat_pipe_emisv=1;      %        emissivity of cat i/o pipe
ex_cat_ext_emisv=1;       %        emissivity of cat ext shield
ex_manif_emisv=1;         %        emissivity of manif & dwnpipe
ex_cat_m2i_th_cond=[0 1]; % W/K   cond btwn CERAMIC mono & int (from SAE#880282)
ex_cat_m2i_tmp=[0 1];     % C     corresponding temperature vector
ex_cat_i2x_th_cond=1;     % W/K   conductance btwn cat int & ext
ex_cat_i2p_th_cond=1;     % W/K   conductance btwn cat int & pipe
ex_cat_p2x_th_cond=1;     % W/K   conductance btwn cat pipe & ext
ex_cat_max_tmp=1;         % C     maximum catalyst temperature 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% user definable mass scaling function
ex_mass_scale_fun=inline('(x(1)*fc_pwr_scale+x(2))*ex_mass','x','fc_pwr_scale','ex_mass');
ex_mass_scale_coef=[1 0]; % mass scaling function coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/01/99:tm renamed ex_fuelcell_null from ex_fuelcell
% 11/3/99:ss updated *_version to 2.21 from 2.2 
% 02/26/01: vhj added variable ex_abs_bool
% 02/28/01: vhj changed ex_abs_bool to ex_ornl_bool
% 7/30/01:tm added mass scaling relationship mass=f(ex_mass,fc_pwr_scale)
