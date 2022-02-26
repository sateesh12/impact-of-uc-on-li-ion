
figure; 
c=contour(compressor_mass_flow_map*fc_comp_slpm_air_max/51/1000*fc_air_comp_scale,compressor_pressure_map,CC'*fc_comp_adeff_max);
clabel(c);
hold on
plot(fc_m_dot_air,fc_pressure_ratio,'rx')
xlabel('Mass Flow Rate (kg/s)')
ylabel('Pressure Ratio (--)')
