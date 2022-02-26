% Wheel/axle
% 
% 

### Wheel/axle

*[Wheel and Axle block diagram](wheel.gif)*

**<u>Role of subsystem in vehicle</u>** \
The ‘wheel and axle’ block transmits torque and speed requests from the
vehicle block, which represents the tire patch, to the final drive. It
also transmits actual torque and speed from the final drive back to the
tire patch.

**<u>Description of modeling approach</u>** \
The wheel and axle model includes the effects of losses in the axle
bearings, wheel and axle inertia, tire slip, and the action of friction
brakes in both the ‘request’ and ‘actual’ data flow paths. Torque losses
are handled as a lookup table indexed by vehicle test mass. Tire slip is
computed using a lookup table indexed by tractive force. Traction
control blocks outside the ‘wheel and axle’ ensure that the tires do not
break loose as a result of trying to provide too much force. Brake
control blocks outside the ‘wheel and axle’ implement the braking
strategy, apportioning required braking force among the driveline, front
friction brakes, and rear friction brakes.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Wheel/Axle) \
> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Wheel/Axle)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
