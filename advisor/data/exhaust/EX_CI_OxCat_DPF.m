% ADVISOR data file:  EX_CI_OxCat_DPF.m
%
% Data source: ORNL testing
%
% Data confirmation:
%
% Masses, areas, etc. are scaled based on engine peak power (fc_pwr_max)
% 
% Created on: Feb 26,2001
% By:  VHJ, NREL, valerie_johnson@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_description='Oxidation catalyst with Diesel Particulate Filter, tested at ORNL';
ex_version=2003; % version of ADVISOR for which the file was generated
ex_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ex_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: EX_CI_OxCat_DPF - ',ex_description])

ex_calc=1;          % 0=> skip ex sys calc (if fc has no emis maps or no cat info avail)
                    % 1=> perform ex sys calcs including tailpipe emis
ex_ornl_bool=1;			%1->Use efficiencies from ORNL data
							%0->Use basic ADVISOR removal efficiencies

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAT EFF VS TEMPERATURE catalyst's temperature-dependent 
% conversion efficiencies indexed by ex_cat_tmp_range
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_tmp_range=[-100 1200]; % (deg. C)
% These removal efficiencies are hard-coded in the lib_exhaust for
% the NOx Absorber
ex_cat_hc_frac=zeros(size(ex_cat_tmp_range));
ex_cat_co_frac=zeros(size(ex_cat_tmp_range));
ex_cat_nox_frac=zeros(size(ex_cat_tmp_range));
ex_cat_pm_frac=[.98 .98];	%Diesel Particulate Filter (DPF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAT "BREAKTHROUGH" LIMITS (MAX g/s for each pollutant) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_lim= [1.25 17.0 2.0 0.4]';     % g/s  "break-thru" limit of converter (HC, CO, NOx, PM)
                                      % assumed to be ~5X the Tier 1 g/mi limits

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW CONVERTER, ETC DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVENTIONAL CONVERTER
ex_mass=0.3*fc_max_pwr/fc_pwr_scale;              % kg     mass of exhaust system assumes mass penalty of 0.3 kg/kW) 
%ex_mass=0.3*fc_max_pwr;              % kg     mass of exhaust system assumes mass penalty of 0.3 kg/kW) 
                                     %       (vs 0.26 for SI from 1994 OTA report, Table 3)
 ex_cat_mass=ex_mass*0.36;           % kg     mass of catalytic converter (from 1994 OTA report, Table 3)
  ex_cat_mon_mass=ex_cat_mass*0.22;   % kg     mass of cat monolith (ceramic)
  ex_cat_int_mass=ex_cat_mass*0.33;   % kg     mass of cat internal SS shell 
  ex_cat_pipe_mass=ex_cat_mass*0.17;  % kg     mass of cat inlet/outlet pipes
  ex_cat_ext_mass=ex_cat_mass*0.28;   % kg     mass of cat ext shell (shield)
 ex_manif_mass=ex_mass*0.20;         % kg     mass of engine manifold & downpipe, turbo (if applicable)
 ex_muf_mass=ex_mass-ex_cat_mass-ex_manif_mass;  % kg     mass of muffler and other pipes downstream of cat
 
ex_cat_pcm_mass=0;                  % kg     mass of cat phase change mat'l heat storage 
ex_mass=ex_mass+ex_cat_pcm_mass;    % kg     add mass of PCM (if any) to ex sys mass

ex_cat_mon_cp=1070;        % J/kgK  ave cp of cat mon: CERAMIC SAE #880282)
%ex_cat_mon_cp=636;        % J/kgK  ave cp of cat mon: METAL (SAE #890798)
ex_cat_int_cp=460;         % J/kgK  ave cp of cat int: SS (SAE #890798)
ex_cat_pipe_cp=460;        % J/kgK  ave sens heat cap of cat i/o pipes (SAE #890798)
ex_cat_ext_cp=460;         % J/kgK  ave sens heat cap of cat ext (SAE #890798)
ex_manif_cp=460;           % J/kgK  ave sens heat cap of manifold & dwnpipe (SAE #890798)
ex_gas_cp=1089;            % J/kgK  ave sens heat cap of exh gas (SAE #890798)
ex_cat_pcm_tmp=[-100 1200];  % C   temp range for cat pcm ecp vec
ex_cat_pcm_ecp=[0 0];      % J/kgK  ave eff heat cap of pcm (latent + sens)

ex_cat_mon_sarea=0.1*(fc_max_pwr/100)^0.67;        % m^2  outer surface area of cat monolith (approx. 0.1 m^2/100 kW)
ex_cat_monf_sarea=ex_cat_mon_sarea/4;    % m^2  surface area of cat monolith front face
ex_cat_moni_sarea=ex_cat_mon_sarea*50;   % m^2  inner (honeycomb) surf area of cat monolith
ex_cat_int_sarea=ex_cat_mon_sarea*1.3;   % m^2  surface area of cat interior
ex_cat_pipe_sarea=ex_cat_mon_sarea/2;    % m^2  surface area of cat i/o pipes
ex_cat_ext_sarea=ex_cat_mon_sarea*1.4;   % m^2  surface area of cat ext shield
ex_man2cat_length=0.7;                   % m    length of exhaust pipe between manifold and cat conv
ex_manif_sarea=(fc_max_pwr/600)*(0.3+ex_man2cat_length);    % m^2  surface area of manif & downpipe: pi*D*L

ex_cat_m2p_emisv=0.1;       %        emissivity x view factor from cat monolith to cat pipes
ex_cat_i2x_emisv=0.5;       %        emissivity from cat int to cat ext shield
ex_cat_pipe_emisv=0.7;      %        emissivity of cat i/o pipe
ex_cat_ext_emisv=0.7;       %        emissivity of cat ext shield
ex_manif_emisv=0.7;         %        emissivity of manif & dwnpipe

ex_cat_m2i_th_cond=[0.7 1.3 2.65 6.5]*0.1/0.003 ; % W/K   cond btwn CERAMIC mono & int (from SAE#880282)
ex_cat_m2i_tmp=[-40 97 344 1200];                % C     corresponding temperature vector
ex_cat_i2x_th_cond   =1.0;                        % W/K    conductance btwn cat int & ext
ex_cat_i2p_th_cond   =0.2;                        % W/K    conductance btwn cat int & pipe
ex_cat_p2x_th_cond   =0.02;                       % W/K    conductance btwn cat pipe & ext

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF FOR OLD CAT TEMP APPROACH 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_cat_max_tmp=400;                              % deg. C, maximum catalyst temperature 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% user definable mass scaling function
ex_mass_scale_fun=inline('(x(1)*fc_pwr_scale+x(2))*ex_mass','x','fc_pwr_scale','ex_mass');
ex_mass_scale_coef=[1 0]; % mass scaling function coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 02/26/01: vhj file created from EX_CI, added ex_abs_bool
% 02/27/01: vhj repalced NOx Abs with OxCat
% 02/28/01: vhj changed ex_abs_bool to ex_ornl_bool
% 7/30/01:tm added mass scaling relationship mass=f(ex_mass,fc_pwr_scale)
