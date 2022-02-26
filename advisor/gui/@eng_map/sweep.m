function [fuel_gps, fuelSum_g] = sweep(em, spd_vals, trq_vals, time)
% [fuel_gps, fuelSum_g] = sweep(em, spd_vals, trq_vals, time)
% sweeps the engine map over spd and torque values at the given time points
% must have equally sized arrays of speed (rad/s), torques (Nm), and the times (s)
% ...when the speeds and torques are evaluated.
%
% Note: engine inertia is not taken into account...

if length(trq_vals)~= length(spd_vals)
   error('torque and speed arrays must be of same length')
elseif length(trq_vals)~=length(time)
   error('time array must be the same length as torque and speed arrays')
end

for i=1:length(trq_vals)
   [jnk1,jnk2,fuel_gps(i)]=interp(em, spd_vals(i), trq_vals(i));
end

plot(em);
hold on;
plot(spd_vals*30/pi, trq_vals, 'g*');
fuelSum_g = trapz(time,fuel_gps);
   