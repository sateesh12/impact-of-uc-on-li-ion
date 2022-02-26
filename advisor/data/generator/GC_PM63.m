% ADVISOR data file:  GC_PM63.m
%
% Data source:
% D. Bauch-Banetzky, et al., "Permanent magneterregte Synchronmaschine mit Nd-Fe-B 
% Dauermagneten für den Einsatz in Personenkraftfahrzeugen"
% published in "VDI (Verein Deutscher Ingenieure) Berichte 1459: 
% Entwicklung Konstruktion Vertrieb HYBRIDANTRIEBE"
% VDI Verlag GmbH, Düsseldorf 1999; ISSN 0083-5560, ISBN 3-18-091459-9.
%
% Drive running as a generator tested by Mr. Berwind (Mannesmann Sachs AG, Schweinfurt, Germany).
%
% Data confidence level:  Good: data from a published paper.
%
% Notes: 230 V dc output. Mannesmann Sachs M260 RE L55 generator/controller. Adopting 
% higher voltages, peak efficiency greater than 93% can be achieved.
%
% Created on:  11/16/99  
% 
% By:  Marco Santoro,  Dresden University of Technology (Germany), 
%		 marco@eti.et.tu-dresden.de
%
% Revision history at end of file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='Mannesmann Sachs 63 kW permanent magnet generator/controller';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_PM63 - ',gc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque vector corresponding to columns of efficiency & loss maps
% this is INPUT torque (>0 => running as a generator)
gc_map_trq=[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160];

% (rad/s), speed vector corresponding to rows of efficiency & loss maps
gc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500]*(2*pi)/60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_eff_map=0.01*[...
50 50   50   50   50   50   50    50    50    50    50    50    50   50   50   50   50
50 50   55   58   60   60   58.5  60    59.9  59.8  59.5  59    58.8 58.7 58   56   55
50 55   65   72   79   79.5 79    78.5  78.3  78    72    70    70   68   67   65   63
50 55   63   81   83   83   83    83.5  82.9  82.3  81.3  81    80   79   78   76   74
54 60   72   82   84   85   85.5  85.6  85.5  84.7  84.2  84    83.5 83   81.5 80   78
54 60   72   82   84.3 85.8 86    86.5  86.4  86    85.8  85.2  84.8 84   83.5 82.5 80
54 59.9 73   82   85   86.1 86.9  87.2  87.3  87    86.6  86.2  85.9 85.2 84.2 83.2 83
54 59.8 73   82.5 85   86.2 87.1  87.6  87.7  87.45 87.25 87    86.4 85.9 85   84   83
54 59.6 70   82   84.5 86.1 87    87.8  88    87.81 87.52 87.25 86.8 86   85   84   83
54 59.6 70.5 81   84.7 86.3 87.25 87.82 88.11 87.9  87.6  87    86   85   84   83   83
54 59.5 69   80.6 84.5 86.2 87.12 87.6  87.7  87.4  86.5  85.5  85   84   84   83   83
54 59   67   80.2 84.1 86   86.9  87.1  87    86.4  85.3  85    84   84   83   83   83
];% (--), efficiency of the machine/inverter when run as a generator

%
% convert to losses
%
[T1,w1]=meshgrid(gc_map_trq,gc_map_spd);
gc_inpwr_map=T1.*w1; % (W), mechanical input power at each torque/speed combo
gc_loss_map=(1-gc_eff_map).*gc_inpwr_map; % (W) loss corresponding to each trq and spd

gc_outpwr_map=gc_inpwr_map-gc_loss_map; %(W) electrical power output




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_max_crrnt=270;	% maximum current draw for generator/controller set, estimated (A)
gc_min_volts=130;	% minimum voltage for generator/controller set, estimated (V)
% maximum continuous torque corresponding to speeds in gc_map_spd
gc_max_trq=[157 157 157 156 155 151 148 143 136 130 117 110]; % (N*m)
% factor by which motor torque can exceed maximum continuous torque for short
% periods of time
gc_overtrq_factor=63/63;  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
gc_spd_scale=1.0;
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
gc_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
gc_inertia=0.02; % (kg*m^2), rotor's rotational inertia, estimated																		
gc_mass=45; % (kg), mass of machine and controller, estimated


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear T1 w1 %gc_loss_map %gc_inpwr_map


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 04-Jan-2000:mc corrected computation of gc_outpwr_map
% 04-Jan-2000: automatically updated to version 2.21
% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
gc_mass_scale_coef=[1 0 1 0];

gc_mass_scale_fun=inline('(x(1)*gc_trq_scale+x(2))*(x(3)*gc_spd_scale+x(4))*gc_mass','x','gc_spd_scale','gc_trq_scale','gc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001