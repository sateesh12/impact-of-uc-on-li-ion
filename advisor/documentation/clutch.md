% Clutch
% 
% 

### Clutch

*[Clutch block diagram](clutch.gif) – visible by right-clicking the
‘Clutch’ and selecting ‘Look Under Mask’*

**<u>Role of subsystem in vehicle</u>** \
The ‘clutch’ block generally transmits torque and speed requests from
the ‘gearbox’ or, in the case of the pre-transmission parallel hybrid,
the torque coupler, to the ‘ICE fuel converter.’ It also generally
transmits actual torque and speed from the ‘ICE fuel converter’ back to
the ‘gearbox’ or ‘torque coupler.’ This block is useful wherever the
vehicle control needs to interrupt torque transmission from one
component to another.

**<u>Description of modeling approach</u>** \
The clutch has three states: disengaged, slipping, and fully engaged.

When disengaged, the clutch requests and transmits no torque. It
requests the input speed be the same as the requested output speed
(‘request’ data path), and passes the requested output speed as the
output speed limit (‘actual’ data path).

When slipping, it requests that the output torque be the same as the
input torque, and passes the actual input torque as the actual output
torque. It requests that the input speed be the predefined, constant
slip speed, and passes the requested output speed as the speed limit.

When engaged, it passes torque and speed unchanged on both the ‘request’
and ‘actual’ data paths.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Clutch)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
