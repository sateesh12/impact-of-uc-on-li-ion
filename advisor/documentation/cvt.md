% Continuosly Variable Transmission
% 
% 

### Continuously Variable Transmission

*[Continuously variable transmission block diagram](cvt.gif)*

**<u>Role of subsystem in vehicle</u>** \
The ‘cvt’ accepts torque from the clutch or other upstream device, and
transmits it to the final drive after overcoming its own losses and
increasing the torque by the current pulley ratio.

**<u>Description of modeling approach</u>** \
The CVT block interacts with the CVT controller, which determines the
current pulley ratio. The CVT then uses this pulley ratio to estimate
input torque and speed, and in turn uses these along with a lookup table
to compute CVT efficiency. The efficiency is used to compute torque
losses as measured on the input side, and the torque required to
overcome the CVT’s inertia is also taken from the input side. The above
order of calculation applies to the ‘request’ data branch. For the
‘available/actual’ data branch, the pulley ratio and efficiency computed
in the ‘request’ branch are used to perform the necessary torque
multiplication and speed reduction.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20CVT) \
> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20CVT)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
