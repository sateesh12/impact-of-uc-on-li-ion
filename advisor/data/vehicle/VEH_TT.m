% ADVISOR Data file:  VEH_TT.m
%
% Data source:  
% 
% Data confidence level:  
%
% Notes:  This file loads the specified vehicle file and 
% adjusts the vehicle level parameters to match the user defined technical targets
%
% Created on:  02/17/99  
% By:  Tony Markel, NREL, Tony_Markel@nrel.gov
%
% Revision history at end of file.

eval('vinf.tt.vehicle; test4exist=1;','test4exist=0;')

if ~test4exist
   
   % setup defaults
   vinf.tt.vehicle.filename='VEH_SMCAR';
   vinf.tt.vehicle.params.description{1}='Glider mass (kg)';
   vinf.tt.vehicle.params.value(1)=995;
   vinf.tt.vehicle.params.description{2}='Drag coefficient (--)';
   vinf.tt.vehicle.params.value(2)=0.335;
   vinf.tt.vehicle.params.description{3}='Frontal area (m^2)';
   vinf.tt.vehicle.params.value(3)=2.0;
   
end

vinf.tt.comp_name='vehicle';

% prompt user for inputs
tt_setup

if eval(['~strcmp(vinf.',vinf.tt.comp_name,'.name,vinf.',vinf.tt.comp_name,'.prev_name)'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Technical Targets based Vehicle';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_TT - ',veh_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE TECHNICAL TARGETS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (kg) mass of the vehicle minus the powertrain
tt_veh_glider_mass=vinf.tt.vehicle.params.value(1); 

% (--) coefficient of drag
tt_veh_CD=vinf.tt.vehicle.params.value(2); 

% (m^2) frontal area
tt_veh_FA=vinf.tt.vehicle.params.value(3); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD BASE DATA FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save current veh_description
str=veh_description;

eval(vinf.tt.vehicle.filename)

% build new vehicle description
veh_description=['Tech Target Vehicle based on ',veh_description]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADJUST DATA TO SATISFY TECHNICAL TARGETS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set vehicle shell mass to the tech target value
veh_glider_mass=tt_veh_glider_mass;

% set vehicle coefficient of drag to the tech target value
veh_CD=tt_veh_CD;

% set vehicle frontal area to the tech target value
veh_FA=tt_veh_FA;


disp([' ** vehicle glider mass set to ', num2str(tt_veh_glider_mass), ' kg. ']);
disp([' ** vehicle coefficient of drag set to ', num2str(tt_veh_CD), '. ']);
disp([' ** vehicle frontal area set to ', num2str(tt_veh_FA), ' m^2. ']);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 02/17/99 (tm): file created 
% 3/11/99:tm enclosed code in an if statement so that it is conditionally executed 
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 11/03/99:ss updated version from 2.2 to 2.21