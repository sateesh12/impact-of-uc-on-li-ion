% ADVISOR file:  fuzzy_target_compute_emissions.m
%
% Notes:
% This file is accessed from the control block to determine the optimal
% IC Engine torque point, calculated based on minimizing a cost function
% based on emissions and fuel efficiency

% Created on: 28-Oct-2001
% By:  AR, OSU, rajagopalan.11@osu.edu
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET IC Engine operation parameters for FUZZY LOGIC Controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to calculate the peak efficiency line of the ICE
% First, calculate an efficiency matrix for the ICE

function [opt_torque]=fuzzy_target_compute_emissions(cold,motor_max,n)
global fc_map_spd fc_spd_scale fc_map_trq fc_trq_scale fc_max_trq flc_eff_map fc_nox_map fc_hc_map fc_co_map

% Define contending weights
% Now, conditions are fed in as inputs to this file

% If the motor has provided maximum torque in the previous time step, it 
% means that the ICE may have been supplying less torque than needed to meet
% the trace. To avoid this condition, the weights for emissions are reduced, 
% so as to allow the ICE to operate in higher efficieny/ higher torque regions.

if (motor_max==1)
   eff_wt=1;
   nox_wt=0.1;
   hc_wt=0.1;
   co_wt=0.1;
end

% Under Cold Start conditions, the primary aim is to curtail the emissions.
% This is achieved by increasing the weights for emissions.
if(cold==1) 
   eff_wt=0.25;
   nox_wt=0.25;
   hc_wt=0.25;
   co_wt=0.25;
end

% Base set of weights.
if(motor_max==0 & cold==0)
   eff_wt=0.7;
   nox_wt=0.3;
   hc_wt=0.1;
   co_wt=0.1;
end


% Define the various effs and emissions values at current speed
% efficiency
eff_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,flc_eff_map,fc_map_trq*fc_trq_scale,n);
eff_line=eff_line1/max(eff_line1);
%NOx
nox_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_nox_map,fc_map_trq*fc_trq_scale,n);
nox_line=nox_line1/max(nox_line1);
% HC
hc_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_hc_map,fc_map_trq*fc_trq_scale,n);
hc_line=hc_line1/max(hc_line1);
% CO
co_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_co_map,fc_map_trq*fc_trq_scale,n);
co_line=co_line1/max(co_line1);

% Calculate cost function (maximize eff, minimize emissions)
cost_J1=eff_wt*(1-eff_line) + nox_wt*nox_line + co_wt*co_line + hc_wt*hc_line;

[opt_value,opt_index] = min(cost_J1);
opt_torque=fc_map_trq(opt_index)*fc_trq_scale;

%Limit to max torque
trq_limit=interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,n,'cubic');

clear eff_line1 nox_line1 hc_line1 co_line1;

%%%% ADDENDUM %%%%%%%
% Must find minimum inside max_trq limit
% because saturation may limit torque, but max trq may not give the optimal torque

if opt_torque > trq_limit		% Optimum is found to be beyond max trq at current speed
   trq_line1=0:5:trq_limit;
   eff_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,flc_eff_map,trq_line1,n);
   eff_line2=eff_line1/max(eff_line1);
   %NOx
   nox_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_nox_map,trq_line1,n);
   nox_line2=nox_line1/max(nox_line1);
   % HC
   hc_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_hc_map,trq_line1,n);
   hc_line2=hc_line1/max(hc_line1);
   % CO
   co_line1=interp2(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale,fc_co_map,trq_line1,n);
   co_line2=co_line1/max(co_line1);
   
   % Calculate cost function (maximize eff, minimize emissions)
   cost_J2=eff_wt*(1-eff_line2) + nox_wt*nox_line2 + co_wt*co_line2 + hc_wt*hc_line2;
   
	[opt_value,opt_index] = min(cost_J2);
   opt_torque=trq_line1(opt_index);		% Don't use fc_trq_scale, since it has already been used
   												% to calculate trq_limit
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/28/01: ar created this file
% 12/04/01: ar modified this file to include all the emissions variables.


