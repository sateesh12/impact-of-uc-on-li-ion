% ADVISOR data file:  TX_CVT50_SUBARU.m
%
% Data source:
% Researchers in the University of Maryland's Mechanical Engineering Department,
% under the direction of Dr. David Holloway, working under subcontract to NREL
%
% Data confirmation:
% Data was processed in the Excel file CVT_MRC.xls
%
% Notes:
% This efficiency data represents the efficiency with which power is transmitted
% through the Subaru Justy's Electronic Continuously Variable Transmission
% pulley system and final drive.
%
% Created on: 8-July-1998
% By:  MRC, NREL, matthew_cuddy@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='cvt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gb_description='Subaru Justy ECVT, 95 N*m max. input, tested by Univ. of MD';
gb_version=2003;
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_CVT50_SUBARU - ',gb_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TORQUE AND SPEED ranges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT torque vector corresponding to columns of efficiency & loss maps
gb_map_trq=[10 20 30 40 50 60 70]*4.448/3.281; % (N*m)

% INPUT speed vector corresponding to rows of efficiency & loss maps
gb_map_spd=[1500 2000 2500 3000 3500 4000 4500 5000]*2*pi/60; % (rad/s)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), efficiency map that goes with the 1st largest pulley ratio
gb_map1_eff_raw=flipud([
0.8228	0.8228	0.8228	0.8228	0.8228	0.8243	0.8243	0.8243
0.8228	0.8228	0.8228	0.8228	0.8228	0.8243	0.8243	0.8243
0.8228	0.8228	0.8228	0.8228	0.8228	0.8243	0.8243	0.8243
0.8458	0.8458	0.8458	0.8507	0.8079	0.8325	0.8325	0.8325
0.8440	0.8509	0.8114	0.8465	0.8244	0.7807	0.7807	0.7807
0.8085	0.8177	0.7823	0.8248	0.7747	0.7747	0.7747	0.7747
0.7525	0.7525	0.7525	0.7525	0.7525	0.7525	0.7525	0.7525
])';

% map of actual data points, 0==> no data, 1==> test data
gb_map1_data_raw=flipud([
0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0
0	0	0	0	1	1	0	0
0	0	1	1	1	1	0	0
1	1	1	1	1	1	0	0
1	1	1	1	1	0	0	0
1	0	0	0	0	0	0	0
])'; 

% (--), efficiency map that goes with the 2nd largest pulley ratio
gb_map2_eff_raw=flipud([
0.8781	0.8781	0.8781	0.8844	0.8300	0.8300	0.8300	0.8300
0.8781	0.8781	0.8781	0.8844	0.8300	0.8300	0.8300	0.8300
0.8889	0.9078	0.8563	0.9003	0.8329	0.8717	0.8167	0.8167
0.8692	0.8606	0.8668	0.8654	0.8286	0.8351	0.8211	0.8211
0.8655	0.8694	0.8448	0.8655	0.8337	0.8002	0.8002	0.8002
0.8248	0.8451	0.8066	0.8425	0.8051	0.8051	0.8051	0.8051
0.7464	0.7464	0.7464	0.7464	0.7464	0.7464	0.7464	0.7464
])';

% map of actual data points, 0==> no data, 1==> test data
gb_map2_data_raw=flipud([
0	0	0	0	0	0	0	0
0	0	1	1	1	0	0	0
1	1	1	1	1	1	1	0
1	1	1	1	1	1	1	0
1	1	1	1	1	1	0	0
1	1	1	1	1	0	0	0
1	0	0	0	0	0	0	0
])'; 

% (--), efficiency map that goes with the 3rd largest pulley ratio
gb_map3_eff_raw=flipud([
0.8991	0.8991	0.8991	0.8917	0.8842	0.8768	0.8768	0.8768
0.9026	0.9026	0.9026	0.8943	0.8533	0.8747	0.8635	0.8635
0.9208	0.9208	0.8786	0.8886	0.8464	0.8415	0.8151	0.8151
0.8894	0.8894	0.8797	0.8752	0.8491	0.8438	0.8208	0.8208
0.8906	0.8906	0.8720	0.8789	0.8586	0.8200	0.8200	0.8200
0.8774	0.8774	0.8326	0.8558	0.8236	0.8236	0.8236	0.8236
0.8774	0.8774	0.8326	0.8558	0.8236	0.8236	0.8236	0.8236
])';

% map of actual data points, 0==> no data, 1==> test data
gb_map3_data_raw=flipud([
0	0	1	0	0	1	0	0
0	0	1	1	1	1	1	0
0	1	1	1	1	1	1	0
0	1	1	1	1	1	0	0
0	1	1	1	1	1	0	0
0	1	1	1	1	0	0	0
0	0	0	0	0	0	0	0
])'; 

% (--), efficiency map that goes with the 4th largest pulley ratio
gb_map4_eff_raw=flipud([
0.9227	0.9227	0.9227	0.9059	0.8891	0.8724	0.8768	0.8768
0.9241	0.9241	0.9241	0.9033	0.8840	0.8840	0.8882	0.8882
0.9177	0.9177	0.9002	0.9050	0.8699	0.8677	0.8344	0.8589
0.9194	0.9194	0.9043	0.8948	0.8872	0.8546	0.8315	0.8315
0.9227	0.9227	0.9103	0.8896	0.8702	0.8539	0.8539	0.8539
0.9169	0.9169	0.8907	0.8786	0.8619	0.8619	0.8619	0.8619
0.9169	0.9169	0.8907	0.8786	0.8619	0.8619	0.8619	0.8619
])';

% map of actual data points, 0==> no data, 1==> test data
gb_map4_data_raw=flipud([
0	0	1	0	0	1	1	0
0	0	1	1	1	1	1	0
0	1	1	1	1	1	1	1
0	1	1	1	1	1	0	0
0	1	1	1	1	1	0	0
0	1	1	1	1	0	0	0
0	0	0	0	0	0	0	0
])'; 

% (--), efficiency map that goes with the 5th largest pulley ratio
gb_map5_eff_raw=flipud([
0.9230	0.9230	0.9230	0.8907	0.8907	0.8907	0.8907	0.8907
0.9230	0.9230	0.9230	0.8907	0.8907	0.8907	0.8907	0.8907
0.9156	0.9156	0.8912	0.8757	0.8757	0.8757	0.8757	0.8757
0.9379	0.9379	0.9099	0.8573	0.8573	0.8573	0.8573	0.8573
0.9471	0.9471	0.9099	0.8529	0.8529	0.8529	0.8529	0.8529
0.9097	0.9097	0.8908	0.7952	0.7952	0.7952	0.7952	0.7952
0.9097	0.9097	0.8908	0.7952	0.7952	0.7952	0.7952	0.7952
])';

% map of actual data points, 0==> no data, 1==> test data
gb_map5_data_raw=flipud([
0	0	0	0	0	0	0	0
0	0	1	1	0	0	0	0
0	1	1	1	0	0	0	0
0	1	1	1	0	0	0	0
0	1	1	1	0	0	0	0
0	1	1	1	0	0	0	0
0	0	0	0	0	0	0	0
])'; 


% vector of gear ratios corresponding to the above efficiency maps
gb_ratio=[2.5 2 1.5 1 0.5]*5.83;

% build matrices of torque and speed such that the torque at (row,col) in Tin1
% and the speed at (row,col) in win1 correspond to the efficiency at (row,col)
% in gb_mapX_eff
[Tin1,win1]=meshgrid(gb_map_trq,gb_map_spd);

for i=1:length(gb_ratio)
   
   % build a matrix of output torques corresponding to the torques in Tin1, the
   % speeds in win1, and the efficiencies in gb_mapX_eff
   
   % output torque map
   Tout1=Tin1*gb_ratio(i);
   
   % loss torque maps
   eval(['Tloss_pos=(1-gb_map',num2str(i),'_eff_raw).*Tout1;']) % positive region
   eval(['Tloss_neg=(1./gb_map',num2str(i),'_eff_raw-1).*Tout1;']) % negative region
   
   % combined output torque map and loss torque map for both positive and negative values
   % -Tloss forces the input value corresponding to some output value to account for losses in CVT 
   gb_map_trq_out(:,:,i)=[-fliplr(Tout1) Tout1]+[-fliplr(Tloss_neg) -Tloss_pos];
   
   % compute & rename new torques and speeds to index new map
   gb_map_trq_in(1,:,i)=[-fliplr(gb_map_trq) gb_map_trq];
   gb_map_spd_out(:,1,i)=gb_map_spd/gb_ratio(i);
   
   
   %gb_map_eff_new(:,:,i)=[(-fliplr(Tin1)*gb_ratio(i))./gb_map_trq_out(:,1:end/2,i) gb_map_trq_out(:,end/2+1:end,i)./(Tin1*gb_ratio(i))];
   
end % for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale gb_map_spd to simulate a faster or slower running gb 
gb_spd_scale=1.0;

% (--), used to scale gb_map_trq to simulate a higher or lower torque gb
gb_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
gb_inertia=0;	% (kg*m^2), input rotational inertia; unknown																		
gb_mass=127/2.205;% = 57.6 ~= 58 kg, mass of CVT and control boxes
gb_shift_delay=0; % time delay in which no torque can be transmitted during a shift  

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=110/2.205; % (kg), mass of the final drive - 1990 Taurus, OTA report

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

% plot gearbox efficiency maps
if 0
   for i=1:length(gb_ratio)
      figure
      eval(['c=contour(gb_map_spd*30/pi,gb_map_trq/4.448*3.281,gb_map',num2str(i),'_eff_raw'',[0.7:0.01:1.0]);'])
      clabel(c)
      if 1
         hold
         spds=[];
         trqs=[];
         for x=1:length(gb_map_spd)
            for y=1:length(gb_map_trq)
               if eval(['gb_map',num2str(i),'_data_raw(',num2str(x),',',num2str(y),')'])
                  spds=[spds gb_map_spd(x)];
                  trqs=[trqs gb_map_trq(y)];
               end
            end
         end
         plot(spds*30/pi,trqs/4.448*3.281,'kx')
      end
      xlabel('Input Speed (rpm)')
      ylabel('Input Torque (lbf-ft)')
      str=['Gearbox Performance - ',gb_description,' - Gear ratio=',num2str(gb_ratio(i))];
      title(str)
      
      if 0
         figure
         spds=[];
         trqs=[];
         for x=1:length(gb_map_spd)
            for y=1:length(gb_map_trq)
               if eval(['gb_map',num2str(i),'_data_raw(',num2str(x),',',num2str(y),')'])
                  spds=[spds gb_map_spd(x)];
                  trqs=[trqs gb_map_trq(y)];
               end
            end
         end
         plot(spds*30/pi,trqs/4.448*3.281,'kx')
         xlabel('Input Speed (rpm)')
         ylabel('Input Torque (lbf-ft)')
         str=['Raw Data Points - ',gb_description,' - Gear ratio=',num2str(gb_ratio(i))];
         title(str)
      end
   end
end


% clean up
clear Tin1 win1 i


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/19/98:mc changed variable names from cvt_* to gb_*
% 08/19/98:mc switched numbering so that gb_eff_map1 and gb_ratio(1) refer to
%             the pulley ratio causing the greatest speed reduction from the
%             engine to the front axle
% 08/19/98:mc changed gb_eff_mapX to gb_mapX_eff
% 08/19/98:mc transformed efficiency maps indexed by input torque and speed to
%             maps indexed by output torque and speed
%9/30/98:ss added fd variables and added tx_mass
%10/16/98:ss renamed to TX_CVT was GB_CVT
%12/22/98:ss added variable tx_type to determine what block diagram to run.
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 11/03/99:ss updated version from 2.2 to 2.21
% 1/18/00:tm renamed TX_CVT50_SUBARU since new CVT data is available
% 1/18/00:tm added statements to handle nan values
% 1/18/00:tm added statements for use with cvt test routine and ploting of eff maps
% 1/22/99:tm removed statements for interpolation of efficiency vs. torque out 
%				- block diagram now uses the map of trq out indexed by speed out and trq in
% 1/22/99:tm removed all statements refering to cvt*
% 7/23/01:tm added gb_shift_delay assignment to work with common sim_stop model blocks
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)