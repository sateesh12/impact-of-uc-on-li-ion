% Torque Coupler
% 
% 

### Torque coupler

*[Torque coupler block diagram](tc.gif)*

**<u>Role of subsystem in vehicle</u>** \
Physically, a torque coupler is a three-sprocket belt or chain drive
whereby two torque sources combine their torques to provide to a
drivetrain component such as the gearbox or final drive. The torque
coupler block diagram processes a torque and speed request from the
downstream drivetrain component and apportions requests of the two
‘feeder’ torque sources.

**<u>Description of modeling approach</u>** \
The effects of torque loss and a gear ratio between the second of the
torque input devices and the output are modeled here. The torque loss is
a constant whenever the torque coupler is spinning.

The torque coupler first requests the sum of necessary output torque and
torque coupler loss from the first torque source. Using the
actual/available torque of the first source, it requests the balance of
the second torque source. The speeds of the two torque providers are in
constant proportion to the torque coupler output speed: the first input
speed equals the output speed, and the second input speed is greater by
a factor tc\_mc\_to\_fc\_ratio.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Torque%20Coupler)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
