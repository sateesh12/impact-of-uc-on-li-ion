% ADVISOR data file:  EX_SI_VICC.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Vacuum-insulated CONVERTER FOR AN SI ENGINE
% Defines exhaust aftertreatment catalyst parameters for use with ADVISOR 2, for
% a hypothetical vehicle equipped with a gasoline-powered SI engine.
% Masses, areas, etc. are scaled based on engine peak power (fc_pwr_max)
% 
% Created on: 14-JAN-99
% By:  SDB, NREL, steve_burch@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_description='Vacuum-insulated catalyst for ~stoichiometric SI engine';
ex_version=2003;     % version of ADVISOR for which the file was generated
ex_proprietary=0;   % 0=> non-proprietary, 1=> proprietary, do not distribute
ex_validation=0;    % 1=> no validation, 1=> data agrees with source data, 
                    % 2=> data matches source data and data collection methods verified
disp(['Data loaded: EX_SI_VICC - ',ex_description])

ex_calc=1;          % 0=> skip ex sys calc (if fc has no emis maps or no cat info avail)
                    % 1=> perform ex sys calcs including tailpipe emis
ex_ornl_bool=0;			%1->Use efficiencies from ORNL data
						%0->Use basic ADVISOR removal efficiencies

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAT EFF VS TEMPERATURE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_tmp_range=[-40 0 220 240 310 415 475 550 650 1200]; % (deg. C)
ex_cat_hc_frac=[0 0 0 0 0.6 0.84 0.92 1 1 1]*0.85;  % (--) data from MC SAE paper
ex_cat_co_frac=[0 0 0 0.48 0.82 0.93 0.96 1 1 1]*0.95; % (--)
ex_cat_nox_frac=[0 0 0.09 0.2 0.89 0.99 0.99 1 1 1]*0.91; % (--)
ex_cat_pm_frac=[     0 0 0    0    0    0    0    0    0    0];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAT "BREAKTHROUGH" LIMITS (MAX g/s for each pollutant) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_lim= [1.25 17.0 2.0 0.4]';     % g/s  "break-thru" limit of converter (HC, CO, NOx)
                                      % assumed to be ~5X the Tier 1 g/mi limits

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW CONVERTER, ETC DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVENTIONAL CONVERTER
ex_scale=fc_max_pwr/fc_pwr_scale/144;            % --     base ex scaling on 144 kW SI engine
ex_cat_mon_mass=2.2*ex_scale;       % kg    ! mass of cat monolith (ceramic)
ex_cat_int_mass=3.3*ex_scale;       % kg    ! mass of cat internal SS shell
ex_cat_pipe_mass=2.0*ex_scale;      % kg    ! mass of cat inlet/outlet pipes
ex_cat_ext_mass=2.0*ex_scale;       % kg    ! mass of cat ext shell (shield)
ex_manif_mass=4.0*ex_scale;         % kg     mass of engine manifold & downpipe
ex_cat_pcm_mass=4.3*ex_scale;         % kg     mass of cat phase change mat'l heat storage 
ex_muf_mass=4.0*ex_scale;             % kg     mass of muffler and other pipes downstream of cat
ex_mass = ex_cat_mon_mass+ex_cat_int_mass+ex_cat_pipe_mass+ex_cat_ext_mass+ex_manif_mass+ex_cat_pcm_mass+ex_muf_mass;

%ex_cat_mon_cp=1070;        % J/kgK  ave cp of cat int: CERAMIC MON. (SAE #880282)
ex_cat_mon_cp=636;        % J/kgK  ave cp of cat int: METAL MON. (SAE #890798)
ex_cat_int_cp=460;         % J/kgK  ave cp of cat int: METAL MON. (SAE #890798)
ex_cat_pipe_cp=460;        % J/kgK  ave sens heat cap of cat i/o pipes (SAE #890798)
ex_cat_ext_cp=460;         % J/kgK  ave sens heat cap of cat ext (SAE #890798)
ex_manif_cp=460;           % J/kgK  ave sens heat cap of manifold & dwnpipe (SAE #890798)
ex_gas_cp=1089;            % J/kgK  ave sens heat cap of exh gas (SAE #890798)
ex_cat_pcm_cp=1100;        % J/kgK  sens heat cap of cat pcm Mg/48%Zn/3%Al
ex_cat_pcm_lh=191e3;       % J/kg   latent heat of cat pcm Mg/48%Zn/3%Al
ex_cat_pcm_mp=320;         % C      melting point of cat pcm Mg/48%Zn/3%Al
cpmh=ex_cat_pcm_mp+5;     % C      upper range of PCM melting
cpml=ex_cat_pcm_mp-5;     % C      lower range of PCM melting
cecp=ex_cat_pcm_lh/(cpmh - cpml) + ex_cat_pcm_cp;  % J/kgK  - equiv cp of PCM in MP range
ex_cat_pcm_tmp=[-100 0.999*cpml cpml cpmh 1.001*cpmh 1200];
ex_cat_pcm_ecp=[0.73*ex_cat_pcm_cp ex_cat_pcm_cp cecp cecp ex_cat_pcm_cp ex_cat_pcm_cp];
clear cpmh cpml cecp

ex_cat_mon_sarea=0.10*ex_scale^0.67;     % m^2    outer surface area of cat monolith
ex_cat_monf_sarea=0.025*ex_scale^0.67;   % m^2    surface area of cat monolith front face
ex_cat_moni_sarea=0.10*20*ex_scale^0.67; % m^2    inner (honeycomb) surf area of cat monolith
ex_cat_int_sarea=0.14*ex_scale^0.67;     % m^2    surface area of cat interior
ex_cat_pipe_sarea=0.05*ex_scale^0.67;    % m^2    surface area of cat i/o pipes
ex_cat_ext_sarea=0.20*ex_scale^0.67;     % m^2   !surface area of cat ext shield
ex_man2cat_length=1.0;     % m      length of pipe from manifold to cat
ex_manif_sarea=pi*0.06*(6*0.15 + ex_man2cat_length);    % m^2  surface area of manif & downpipe: pi*D*L

ex_cat_m2p_emisv=0.009;      %       !emissivity x view factor from cat monolith to cat pipes
ex_cat_i2x_emisv=0.0035;     %       !emissivity from cat int to cat ext shield
ex_cat_pipe_emisv=0.8;      %        emissivity of cat i/o pipe
ex_cat_ext_emisv=0.8;       %        emissivity of cat ext shield
ex_manif_emisv=0.8;         %        emissivity of manif & dwnpipe

ex_cat_mon_th_res=0.005./[0.5 0.857 1.1 2.25] ; % m^2K/W    x/k th res of outer row of monolith cells (SAE#890798)
ex_cat_mat_th_res=0 ;       % m^2K/W    x/k th res of mat or extra sleeve (NO MAT w/METAL MONO) 
ex_cat_m2i_th_cond=ex_cat_mon_sarea./(ex_cat_mon_th_res+ex_cat_mat_th_res); 
									 % W/K   net effective th cond btwn CERAMIC mono & int (kA/x)
ex_cat_m2i_tmp=[-40 97 344 1200];                % C     corresponding temperature vector
ex_cat_i2x_th_cond   =0.04; % W/K   !conductance btwn cat int & ext
ex_cat_i2p_th_cond   =0.07; % W/K   !conductance btwn cat int & pipe
ex_cat_p2x_th_cond   =0.10; % W/K    conductance btwn cat pipe & ext

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF FOR OLD CAT TEMP APPROACH 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_max_tmp=550;                              % deg. C, maximum catalyst temperature 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% user definable mass scaling function
ex_mass_scale_fun=inline('(x(1)*fc_pwr_scale+x(2))*ex_mass','x','fc_pwr_scale','ex_mass');
ex_mass_scale_coef=[1 0]; % mass scaling function coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2/4/99: ss,sb changed ex_cat_mon_sarea=0.1*(fc_max_pwr/100)^0.67  it was fc_max_pwr/1000
%		it now takes into account that surface area increases based on mass to the 2/3 power 
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/3/99:ss updated *_version to 2.21 from 2.2 and divided fc_max_pwr by fc_pwr_scale 
%                  since it is scaled back up in block diagram
% 02/26/01: vhj added variable ex_abs_bool
% 02/28/01: vhj changed ex_abs_bool to ex_ornl_bool
% 7/30/01:tm added mass scaling relationship mass=f(ex_mass,fc_pwr_scale)