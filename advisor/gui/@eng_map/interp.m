function [eff, bsfc, fuel_gps] = interp(em, spd, trq)
% [eff, bsfc, fuel_gps] = interp(em, spd, trq)
% Returns the efficiency, bsfc [g/kWh], and fuel use [g/s] looked up at a specific speed [rad/s] and torque [Nm]
% of an engine map object, em

% implement "edge extention"--attempts to lookup off the map give you the appropriate edge values
if spd>max(em.map_spd)
   spd=max(em.map_spd);
elseif spd<min(em.map_spd)
   spd=min(em.map_spd);
end

if trq>max(em.map_trq)
   trq=max(em.map_trq);
elseif trq<min(em.map_trq);
   trq=min(em.map_trq);
end

eff = interp2(em.map_spd, em.map_trq, em.map_eff', spd, trq); 
bsfc= interp2(em.map_spd, em.map_trq, em.map_bsfc', spd, trq); % g/kW/h
fuel_gps=bsfc*(spd*trq/1000)*(1/3600);