% ADVISOR data file:  GC_14VCP_CUSTOM.m
%
% Data source:
% 
%
% Data confidence level:  
%
% Notes: 
%
% Created on:  3/11/2002  
% 
% By:  AB, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_description='Lundell claw pole alternator (generator/controller)';
gc_version=2003; % version of ADVISOR for which the file was generated
gc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
gc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: GC_CP_CUSTOM - ',gc_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATOR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_cutin93=1300; % cutin rpm at 93 C  (no output below this rpm)
gc_user_imax93=90; % maximum current at 93 C
gc_cutin12=1300; %	cutin at rpm 12 C
gc_user_imax12=90; % maximum current at 12.8 C
gc_eff=.6; % generator efficiency (currently a fixed percentage for all speeds)
					
gc_tempalt=25; % Alternator Inlet Air Temperature Input			
gc_vehicletype=5; %  	1	large car
		    	%   	2	medium car
				%   	3	small car
				%   	4	SUV
                %       5   Custom (uses parameters specified by this file)
gc_t93=93; % 93 - this is the high end calibration temperature
gc_t12=12.8; % 12.8 - this is the low end calibration temperature
						%For all other temperatures, the model linearly
						%interpolates using t12 and t93.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gc_max_pwr=max(gc_user_imax93,gc_user_imax12)*max(gc_reg_volt1,gc_reg_volt2)/1000; % (kW) max generator power

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user definable mass scaling relationship
gc_mass_scale_coef=[.05 .42]; % mass scaling coefficiencts
gc_mass_scale_fun=inline('(x(1)*max(gc_user_imax93,gc_user_imax12)) - x(2)','x','gc_user_imax93','gc_user_imax12');

gc_mass=gc_mass_scale_fun(gc_mass_scale_coef,gc_user_imax93,gc_user_imax12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 03-15-2000: ab created
