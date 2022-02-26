% Final Drive
% 
% 

### Final drive

*[Final Drive block diagram](fd.gif)*

**<u>Role of subsystem in vehicle</u>** \
The ‘final drive’ block transmits torque and speed requests from the
‘wheel and axle’ to the ‘gearbox’ or whatever physically inputs torque
to the final drive. It also transmits actual torque and speed from the
‘gearbox’ back to the ‘wheel and axle.’

**<u>Description of modeling approach</u>** \
The final drive model includes the effects of losses, inertia, and gear
ratio in both the ‘request’ and ‘actual’ data flow paths. Torque loss is
assumed to be constant. The gear ratio reduces the speed input by
‘gearbox’ or whatever other input exists, and increases torque. Inertia
is measured and losses are applied at the input side of the gear
reduction.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Final%20Drive)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
