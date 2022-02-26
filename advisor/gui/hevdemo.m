
% Call to prohev() function, which exports an HEV data file.
% Created by ljl, 23 Nov 1999.

% For electric vehicles.
if (exist('fc_fuel_mass') == 0)
  fc_fuel_mass = 0;
  fc_fuel_den = 1;
end

% For conventional vehicles.
if exist('ess_module_num') == 0
  ess_module_num = 0;
  ess_max_ah_cap = 0;
end

prohev(veh_wheelbase, wh_radius, fc_fuel_mass, fc_fuel_den, ...
   ess_module_num, ess_max_ah_cap);

