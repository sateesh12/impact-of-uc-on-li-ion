%   1.  Run any custom routines ---------------------------------------------------------------


%   2.  Assign variables (**Note:  must do step 2a) -------------------------------------------
%       a. Variables required for all simulations
% t=;% time

%       b. General list
% mpha=;%  your miles per hour achieved variable (mph)
% ess_soc_hist=;% battery state of charge 
% gear_number=;% gear number 
% grade=;% grade (%)
% gal=;% fuel used (gal)
% fc_fuel_rate=;% fuel converter fuel rate (g/s)
% trace_miss=;% amount of speed that the vehicle missed the trace (mph)
% fc_pwr_out_a=;% fuel converter power out (W)
% fc_eff_out_a=;% fuel converter operating efficiency (%)
% gc_pwr_out_a=;% generator power out (W)
% ess_pwr_out_a=;% battery power out (W)
% veh_pwr_accel_a=;% power to acceleration (W)
% veh_pwr_drag_a=;% power to air drag (W)
% veh_pwr_ascent_a=;% power to ascent (W)
% veh_pwr_rr_a=;% power to over come rolling resistance
% cyc_mph_r=;% cycle miles per hour

%       c. Inputs required for engine operating map
% fc_spd_est=;%  fuel converter operating speed (rad/s)
% fc_brake_trq=;%  fuel converter operating torque (Nm)
% fc_eff_map=;%  fuel converter efficiency map
% fc_map_spd=;%  fuel converter map speed vector (Nm)
% fc_map_trq=;%  fuel converter map torque vector (Nm)
% fc_trq_scale=1;%  fuel converter torque map scaling term (assign 1 if it doesn't exist)
% fc_spd_scale=1;%  fuel converter speed map scaling term (assign 1 if it doesn't exist)
% fc_max_trq=;%  fuel converter max torque curve

%       d. Inputs required for fuel cell operating map
% fc_eff_map=;% fuel cell efficiency map
% fc_pwr_map=;% fuel cell power map (W)
% fc_eff_scale=1;% fuel cell efficiency map scaling term (assign 1 if it doesn't exist)
% fc_pwr_scale=1;% fuel cell power map scaling term (assign 1 if it doesn't exist)

%       f. Motor operating map: required inputs
% mc_spd_out_a=;%  motor operating speed (rad/s)
% mc_trq_out_a=;% motor operating torque (Nm)
% mc_eff_map=;% motor efficiency map
% mc_map_spd=;% motor map speed vector (Nm)
% mc_map_trq=;% motor map torque vector (Nm)
% mc_trq_scale=1;% motor torque map scaling term (assign 1 if it doesn't exist)
% mc_spd_scale=1;% motor speed map scaling term (assign 1 if it doesn't exist)
% mc_max_trq;% motor max torque curve
