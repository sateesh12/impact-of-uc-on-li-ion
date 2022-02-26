function display(em)
if length(em)>1
    for i=1:length(em)
        display(['EM ',num2str(i),':'])
        display(em(i));
    end
    return;
end
disp(' ');
disp([inputname(1),' = '])
disp(' ');
disp(['   engine map object'])
disp(' ');
disp(['torques:  ', num2str(length(em.map_trq))]);
disp(['speeds:   ', num2str(length(em.map_spd))]);
[maxim,spdi]=max(em.map_eff);
[maxim,trqi]=max(maxim);
disp(['peak eff: ', num2str(maxim*100),'% at speed ', num2str(em.map_spd(spdi(trqi))),' rad/s (',...
      num2str(em.map_spd(spdi(trqi))*30/pi),' rpm) and ', num2str(em.map_trq(trqi)),' Nm']);