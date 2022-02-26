% Motor controller logic
% 
% 

### Motor controller logic

*[Motor Controller logic block diagram](mc_cntBD.gif)*

**<u>Role of subsystem in vehicle</u>** \
This block implements some of the logical control functions of the
motor’s controller (a.k.a. inverter).  It prevents the controller from
requesting more current than it can handle, and shuts the motor off if
the vehicle is not moving or if the gearbox is in the process of
changing gears.

**<u>Description of modeling approach</u>** \
To enforce the motor/controller’s current limit, the maximum requested
power is computed as the product of the maximum current, mc\_max\_crrnt,
and the bus voltage at the previous time step.  This product is the
limiting absolute value that the power request will take on: the
motor/controller will ask to take no more power from nor give more power
to the bus.

Boolean logic enforces the required off conditions.

<p>
**<u>Variables used in subsystem</u>** \
mc\_max\_crrnt

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Motor/Controller)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
