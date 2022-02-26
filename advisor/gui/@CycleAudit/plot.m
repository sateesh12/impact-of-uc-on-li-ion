function plot(cyc)

figure, plot(cyc.t, cyc.v, 'b-');
hold on
plot(cyc.t, cyc.h, 'r*-');

xlabel('Elapsed Time (seconds)')
ylabel('Blue-- Velocity [m/s], Red-- Elevation [m]')
title(['Drive Cycle: ',cyc.name])

figure, plot(cyc.t, cyc.v*2.236936,'b-');
hold on
plot(cyc.t, cyc.h, 'r*-');

xlabel('Elapsed Time (seconds)')
ylabel('Blue-- Velocity [mph], Red-- Elevation [m]')
title(['Drive Cycle: ',cyc.name])