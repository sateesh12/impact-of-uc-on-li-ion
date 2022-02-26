% use to check generator operation

figure;
plot(gc_map_spd*30/pi*gc_spd_scale,gc_max_trq*gc_trq_scale,'k-');
hold;
if exist('gc_spd_in_a')
   plot(gc_spd_in_a*30/pi,gc_trq_in_a,'rx');
   legend('max torque curve', 'actual operating points')
elseif exist('gc_spd_out_a')% prius
   plot(gc_spd_out_a*30/pi,gc_trq_out_a,'rx');
   legend('max torque curve', 'actual operating points')
else 
   legend('max torque curve')
end;


if nnz(diff(gc_eff_map))
   c=contour(gc_map_spd*30/pi*gc_spd_scale,gc_map_trq*gc_trq_scale,gc_eff_map');
   clabel(c);
else
   axis([0 1.1*max(gc_map_spd)*30/pi*gc_spd_scale 0 1.1*max(gc_max_trq)*gc_trq_scale])
   text(.4*max(gc_map_spd)*30/pi*gc_spd_scale,.5*max(gc_map_trq)*gc_trq_scale,...
      ['Constant Efficiency of ',num2str(max(max(gc_eff_map))*100),'%.']);
end;
xlabel('Speed (rpm)');
ylabel('Torque (Nm)');
if length(['Generator/Controller Operation - ',gc_description])>75
   ttl={'Generator/Controller Operation';gc_description};
   title(ttl,'Fontsize',7);
else
   title(['Generator/Controller Operation - ',gc_description]);
end;
set(gcf,'NumberTitle','off','Name','Generator/Controller Operation')

%9/3/99 ss: added statements for prius operating points.