% Engine control
% 
% 

### Engine control (conventional vehicle)

*[Engine Control Block Diagram](engcntBD.gif)*

**<u>Role of subsystem in vehicle</u>** \
The engine control determines whether the engine should be on or off and
at what speed the engine crankshaft should be turning.  The command
signals it generates are used by the engine to determine fuel use,
torque delivered, and actual crankshaft speed.

**<u>Description of modeling approach</u>** \
There are two largely separate issues handled by the engine control: 
engine state (on/off) and speed command.

The engine is on if the key is on (**vc\_key\_on**) and the clutch is
not disengaged (meaning that torque is required) or if it is disengaged
and the engine idles rather than shutting down, as determined by
**vc\_idle\_bool**.  It is shut off if the ignition key is off, as
determined by **vc\_key\_on**.  And it will not shut down, even if the
engine is commanded not to idle, when transmission is shifting.

The speed command is identical to the speed required at the clutch input
*unless* the vehicle is about to launch:  if the clutch is disengaged
and the vehicle is not moving and it must be moving one second in the
future, the engine will spin up to **vc\_launch\_spd**.  Also, the
engine will spin at no less than **vc\_idle\_spd** if it is on.

<p>
**<u>Variables used in subsystem</u>** \
vc\_idle\_bool    vc\_idle\_spd    vc\_key\_on    vc\_launch\_spd

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Vehicle%20Control)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
