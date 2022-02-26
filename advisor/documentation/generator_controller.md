% Generator Controller
% 
% 

### Generator/controller

*[Generator/controller block diagram](gc.gif)*

**<u>Role of subsystem in vehicle</u>** \
The ‘generator/controller’ block translates torque and speed supplied,
usually by a heat engine, into electric power supplied usually to the
power bus.

**<u>Description of modeling approach</u>** \
The generator/controller model includes the effects of losses in the
generator and controller, generator inertia, the generator’s torque
speed-dependent torque capability, and the controller’s current limit.
Power losses are handled as a 2-D lookup table indexed by rotor speed
and input torque. The generator’s maximum torque is enforced using a
lookup table indexed by rotor speed; this limits electric power
production but does not feedback to the torque provider.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Generator/Controller) \
> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Generator/Controller)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
