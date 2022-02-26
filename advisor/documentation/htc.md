% Hydraulic Torque Converter
% 
% 

<!DOCTYPE html public "-//w3c//dtd html 4.0 transitional//en">

### Hydraulic Torque Converter

[Creation and Validation of a New Automatic Transmission Model in
ADVISOR, August 2000](NewAutoTX.html)

[*Hydraulic Torque Converter \<htc\>*](htc_fig1.gif)

**<u>**

Role of subsystem in vehicle</b></u> \
 The hydraulic torque converter is an enclosed pump/turbine pair that
transmits torque through the intermediate fluid.  It sits between the
engine and the gearbox in vehicles equipped with conventional automatic
transmissions, and acts to increase the engine’s output torque, decrease
the output speed, and also dampen vibrations.  In the ADVISOR vehicle
model, the torque converter accepts torque and speed requests from the
gearbox, makes requests of the engine, accepts actual torque and speed
from the engine, (transforms them) and transmits torque and speed to the
gearbox.

**<u>**

Description of modeling approach</b></u> \
 [See the new description here](NewAutoTX.html#ModelDescription).

**<u>**

Variables used in subsystem</b></u> \
 In the above description of the (positive) driving torque situation,
the relationship between SR and K is defined by the vectors **htc\_sr**
and **htc\_k**.  The analogous vector for TR is **htc\_tr**.

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20HTC) \
>  [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20HTC)

* * * * *

</p>
[Back to Chapter 3](advisor_ch3.html)

Last Revised: 8/10/00: vhj
