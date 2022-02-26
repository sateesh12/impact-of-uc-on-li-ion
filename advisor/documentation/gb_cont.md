% Brake control: achievable
% 
% 

### Gearbox control

*[Gearbox Control block diagram](gbcntBD.gif)*

**<u>Role of subsystem in vehicle</u>** \
The gearbox control block diagram generates a gear ratio command and
passes it to the gearbox, modeling a driver who chooses a gear based on
engine load and speed and moves the gearshift lever accordingly.

<p>
**<u>Description of modeling approach</u>** \
One-dimensional lookup tables, one for each gear, are used to implement
the dependence of the shift command (up, down, or no shift) upon current
gear, and engine speed and load assuming the current gear is maintained.

<center>
<p>
![](shift_space.gif)

</center>
Red lines in the figure above indicate upshift and downshift lines in
engine torque and speed space.  The black curve near the top indicates
the engine’s maximum torque envelope.  The numbered curves are
efficiency contours.  (Note that although the plot’s y-axis is engine
torque, the elbow points are in fact defined in terms of engine load,
which is defined here as the engine torque at a given speed divided by
its maximum torque at that speed.  So the actual red lines used by
ADVISOR are not straight in engine torque/speed space, since the maximum
engine torque depends on speed.  This is a subtle and generally not
critical point, so don’t think about it too much.)

The elbow points in the rightmost red line are defined using variables
named **gb\_gearX\_upshift\_spd** and **gb\_gearX\_upshift\_load**,
where X should be replaced with the appropriate gear number.  When the
engine torque/speed point would fall to the right of the rightmost red
curve, an upshift is commanded.

Likewise, **gb\_gearX\_dnshift\_spd** and **gb\_gearX\_dnshift\_load**
define the leftmost red line.  When the engine torque/speed point would
fall to the left of the leftmost red curve, a downshift is commanded.

For example values of these variables, see the file PTC\_CONV.m. \
 

<p>
**<u>Variables used in subsystem</u>** \
gb\_gear1\_dnshift\_spd    gb\_gear1\_dnshift\_load   
gb\_gear1\_upshift\_spd    gb\_gear1\_upshift\_load \
. \
. \
. \
gb\_gear5\_dnshift\_spd    gb\_gear5\_dnshift\_load   
gb\_gear5\_upshift\_spd    gb\_gear5\_upshift\_load

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Gearbox)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
