% Clutch control
% 
% 

### Clutch control

*[Clutch Control block diagram](cltcntBD.gif)*

**<u>Role of subsystem in vehicle</u>** \
The clutch control determines whether the clutch should be fully
engaged, fully disengaged, or slipping–transmitting torque while the two
sides of the clutch spin at different speeds.

**<u>Description of modeling approach</u>** \
The state of the clutch depends on the requirements of the drivetrain. \
If either:

1.  The gear is changing, for an upshift or downshift, OR
2.  No (positive) torque is required of the engine AND (the driver
    disengages the clutch during that situation OR the speed required of
    the engine is less than its idle speed)

then the clutch is disengaged. \
If:

1.  Positive torque is required of the engine AND
2.  The speed required of the engine is less than the engine launch
    speed AND
3.  The clutch was not fully engaged at the previous time step

then the clutch is slipping (meaning that the engine is required to
operate at its launch speed).

If the clutch is neither disengaged nor slipping, then it is engaged.

If the clutch is being used in a parallel hybrid and the engine is off,
the clutch is disengaged regardless of the above conditions.

<p>
**<u>Variables used in subsystem</u>** \
vc\_clutch\_bool    vc\_idle\_spd    vc\_launch\_spd

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Vehicle%20Control)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
