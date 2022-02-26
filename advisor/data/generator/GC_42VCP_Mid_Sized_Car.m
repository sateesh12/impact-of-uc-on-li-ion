% ADVISOR data file:  GC_42VCP_Mid_Sized_Car.m
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
disp(['Data loaded: GC_CP_Mid_Sized_Car - ',gc_description])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATOR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_vehicletype=2; %  	1	large car
		    	%   	2	medium car
				%   	3	small car
				%   	4	SUV
                %       5   Custom (uses parameters specified by this file)
                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUMMY GENERATOR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_cutin93=0; % cutin rpm at 93 C  (no output below this rpm)
gc_user_imax93=0; % maximum current at 93 C
gc_cutin12=0; %	cutin at rpm 12 C
gc_user_imax12=0; % maximum current at 12.8 C
					
gc_tempalt=0; % Alternator Inlet Air Temperature Input			
gc_t93=0; % 93 - this is the high end calibration temperature
gc_t12=0; % 12.8 - this is the low end calibration temperature
gc_eff=0; % generator efficiency (currently a fixed percentage for all speeds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gc_mass=6; % (kg), mass of machine and controller, estimate based on one 24V generator linearly scaled by power to zero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3/13/02 ab: created