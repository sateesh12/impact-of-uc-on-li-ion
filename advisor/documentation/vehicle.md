% Vehicle
% 
% 

### Vehicle

*[Vehicle block diagram](veh.gif)*

**<u>Role of subsystem in vehicle</u>** \
Calculations in the ‘vehicle’ block are representative of the force
balance at the tire patch. Given a speed required at the end of the time
step, the tractive force and required speed averaged over the time step
are requested of the wheel. And given an available tractive force and
speed limit, the actual/achieved speed is computed.

**<u>Description of modeling approach</u>** \
The classic equation for longitudinal vehicle dynamics is implemented in
this block: <font face="Symbol">S</font>F=ma, where among the forces are
rolling resistance, aerodynamic drag, and the force of gravity that must
be overcome to climb a grade. This equation is first used to compute
required tractive force given required acceleration, and then used to
compute achievable acceleration given available tractive force. The
average speed over the time step is taken to be the average of the speed
at the beginning of the time step (a.k.a. the speed at the end of the
previous time step) and the speed required at the end of the time step.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Vehicle) \
> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Vehicle)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
