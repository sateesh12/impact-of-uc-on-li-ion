% ADVISOR data file:  TX_CVT50_FOLSOM.m
%
% Data source:
% Data was provided by Clive Tucker of Folsom Technologies, the CVT's
% manufacturer, on August 4, 1999.
%
% Data confirmation:
% The implementation of the manufacturer's data in ADVISOR has been confirmed.
%
% Notes:
% Final drive and differential are integral to the hydromechanical CVT.  The
% ratios quoted are overall ratios, and the efficiencies are inclusive of the 
% final drive losses.  Rated input speed = 5000 rpm. Rated input torque = 95 Nm.
%
% Created on: 5-Aug-1999
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
gb_description='Folsom Technologies CVT, 50kW max. input';
gb_version=2003;
gb_proprietary=0;  % 0=> public data, 1=> restricted access, see comments above
gb_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TX_CVT50_FOLSOM - ',gb_description]);


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
gb_map1_eff_raw=[
0.7288	0.7486	0.7605	0.7685	0.7741	0.7784	0.7817	0.7843
0.7917	0.8161	0.8307	0.8404	0.8474	0.8526	0.8567	0.8599
0.8053	0.8330	0.8496	0.8607	0.8687	0.8746	0.8792	0.8829
0.8065	0.8373	0.8558	0.8681	0.8769	0.8835	0.8886	0.8927
0.8028	0.8366	0.8568	0.8703	0.8800	0.8872	0.8928	0.8973
0.7967	0.8333	0.8553	0.8699	0.8804	0.8883	0.8944	0.8992
0.7417	0.7770	0.7982	0.8120	0.8220	0.8300	0.8360	0.8410
]';

% (--), efficiency map that goes with the 2nd largest pulley ratio
gb_map2_eff_raw=[
0.7419	0.7538	0.7609	0.7656	0.7690	0.7716	0.7736	0.7751
0.8228	0.8370	0.8456	0.8513	0.8554	0.8584	0.8608	0.8627
0.8467	0.8625	0.8720	0.8783	0.8829	0.8862	0.8889	0.8910
0.8565	0.8736	0.8839	0.8908	0.8956	0.8993	0.9022	0.9045
0.8605	0.8789	0.8899	0.8973	0.9025	0.9065	0.9096	0.9120
0.8617	0.8813	0.8931	0.9009	0.9065	0.9107	0.9140	0.9166
0.8613	0.8821	0.8945	0.9028	0.9088	0.9132	0.9167	0.9195
]';

% (--), efficiency map that goes with the 3rd largest pulley ratio
gb_map3_eff_raw=[
0.7372	0.7455	0.7506	0.7539	0.7563	0.7581	0.7595	0.7607
0.8304	0.8404	0.8464	0.8504	0.8533	0.8554	0.8571	0.8584
0.8598	0.8708	0.8774	0.8818	0.8849	0.8873	0.8891	0.8906
0.8733	0.8851	0.8921	0.8968	0.9002	0.9027	0.9047	0.9062
0.8805	0.8929	0.9004	0.9054	0.9090	0.9116	0.9137	0.9154
0.8844	0.8975	0.9054	0.9107	0.9144	0.9173	0.9195	0.9212
0.8865	0.9003	0.9086	0.9141	0.9181	0.9210	0.9233	0.9252
]';

% (--), efficiency map that goes with the 4th largest pulley ratio
gb_map4_eff_raw=[
0.7242	0.7312	0.7353	0.7381	0.7401	0.7416	0.7427	0.7436
0.8278	0.8361	0.8411	0.8444	0.8468	0.8486	0.8500	0.8511
0.8611	0.8702	0.8756	0.8793	0.8819	0.8838	0.8853	0.8866
0.8769	0.8866	0.8924	0.8963	0.8990	0.9011	0.9027	0.9040
0.8856	0.8959	0.9020	0.9061	0.9090	0.9112	0.9129	0.9143
0.8909	0.9016	0.9081	0.9124	0.9154	0.9177	0.9195	0.9210
0.8941	0.9054	0.9121	0.9166	0.9198	0.9222	0.9241	0.9256
]';

% (--), efficiency map that goes with the 5th largest pulley ratio
gb_map5_eff_raw=[
0.7091	0.7152	0.7188	0.7212	0.7229	0.7242	0.7253	0.7261
0.8224	0.8298	0.8342	0.8371	0.8392	0.8408	0.8420	0.8430
0.8592	0.8672	0.8720	0.8752	0.8775	0.8792	0.8806	0.8816
0.8769	0.8854	0.8906	0.8940	0.8964	0.8982	0.8996	0.9008
0.8870	0.8959	0.9013	0.9049	0.9075	0.9094	0.9109	0.9121
0.8932	0.9026	0.9082	0.9120	0.9146	0.9167	0.9182	0.9195
0.8972	0.9070	0.9129	0.9168	0.9196	0.9217	0.9233	0.9246
]';

% vector of gear ratios corresponding to the above efficiency maps
gb_ratio=[15 7.5 5 3.75 3]; % includes a final drive ratio of ??

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
gb_mass=127/2.205; % same as Subaru Justy, TX_CVT
gb_shift_delay=0; % time delay in which no torque can be transmitted during a shift

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;

%final drive portion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), all losses included in efficiency map


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
      eval(['c=contour(gb_map_spd*30/pi,gb_map_trq/4.448*3.281,gb_map',num2str(i),'_eff_raw'',[0.3:0.05:0.65 0.7:0.02:1.0]);'])
      clabel(c) 
      xlabel('Input Speed (rpm)')
      ylabel('Input Torque (lbf-ft)')
      str=['Gearbox Performance - ',gb_description,' - Gear ratio=',num2str(gb_ratio(i))];
      title(str)
   end
end


% clean up
clear Tin1 win1 i 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%08/05/99:mc created starting from TX_CVT
%11/24/99:mc prevented gb_map_trq and gb_map_spd from being cleared
%            added '_raw' to original efficiency matrices
% 1/14/00:tm changed name from TX_CVTfolsom to TX_CVT50_FOLSUM where 50 represents the max power input
% 1/14/00:tm additional note information reqarding rated values included in comments
% 7/23/01:tm added gb_shift_delay assignment to work with common sim_stop model blocks
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)