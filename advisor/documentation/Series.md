% Series Control Strategy
% 
% 

### **<font size="+1">Series Control Strategy</font>**

**<u>Role of subsystem in vehicle</u>** \
The control strategy determines at what torque and speed the engine
should operate, to generate electric power via the generator, given the
conditions of the motor, ESS pack, and/or the engine/fuel converter
itself.  Usually such a strategy is designed to minimize fuel use or
emissions or maximize ESS pack life.

**<u>Description of modeling approach</u>** \
The built-in series controls strategy offers flexibility in the fuel
converter (FC) operation:

-   <font color="#000000">The FC may be turned off if the ESS pack SOC
    gets too high.</font>
-   <font color="#000000">The FC may be turned on again if the power
    required by the bus gets high enough.</font>
-   <font color="#000000">The FC may be turned on again if the SOC gets
    too low.</font>

<font color="#000000">When the FC is on, its power output tends to
follow the power required by the bus, accounting for losses in the
generator so that the generator power output matches the bus power
requirement.  However,</font>

-   <font color="#000000">The FC output power may be adjusted by SOC,
    tending to bring the SOC back to the center of its operating
    range.</font>
-   <font color="#000000">The FC output power may be kept above some
    minimum value.</font>
-   <font color="#000000">The FC output power may be kept below some
    maximum value (which is enforced unless the SOC gets too
    low).</font>
-   <font color="#000000">The FC output power may be allowed to change
    no faster than a prescribed rate.</font>

**<u>Variables used in subsystem</u>** \
There are eleven variables that determine the control strategy.  Their
influence on the engine operation are shown in the schematics below, and
they are described in the following table.

<p>
*Determining FC State (on/off)*

<center>
![](seriesfo.gif)

</center>
The above figure indicates the commanded fuel converter (FC) state as a
function of ESS pack SOC, SOC-corrected fuel converter power required,
and the FC’s previous state.

SOC-corrected fuel converter power required is computed by:

1.  estimating the FC output power required to make the generator output
    as much electrical power as is required by the bus for propulsion
    and accessory loads, and
2.  adding an SOC-dependent correction factor,
    cs\_charge\_pwr\*fc\_spd\_scale\*fc\_trq\_scale\*((cs\_hi\_soc+cs\_lo\_soc)/2-SOC),
    that tends to bring the SOC to the middle of the range delimited by
    cs\_hi\_soc and cs\_lo\_soc.

The asterisked boundary, which refers to the minimum power requirement
to cause the FC to turn on when it was previously off,  has more
dimensions than could be included in this graphic.

In fact, if the FC was last on and SOC \< cs\_hi\_soc, the engine will
stay on regardless of power command.  It may be useful to imagine that
the yellow portion of the figure continues right of its current
position, filling the space SOC \> cs\_lo\_soc and (power command) \>
(1.2\*cs\_min\_pwr\*fc\_trq\_scale\*fc\_spd\_scale).

However, if the FC was previously off, and (the average of the last 5 s
of fuel converter power command) \>
(1.2\*cs\_min\_pwr\*fc\_trq\_scale\*fc\_spd\_scale), AND (the time since
the FC was last on) \> cs\_min\_off\_time, the FC will start.  This
temporal component of the logic isn’t displayed in the figure above.

Finally, regardless of all other conditions, if the power required by
the bus is greater than the ESS pack capability, the FC will turn/stay
on. \
 

*Determining FC Output Power* \
FC output power is as required by the generator to fulfill the bus
requirement, with the following exceptions:

1.  If the required SOC-corrected FC power is less than
    cs\_min\_pwr\*fc\_trq\_scale\*fc\_spd\_scale, the FC power is
    commanded to this minimum threshold.
2.  If the required SOC-corrected FC power is greater than
    cs\_max\_pwr\*fc\_trq\_scale\*fc\_spd\_scale AND the ESS pack SOC is
    greater than cs\_lo\_soc AND the power required by the bus
    (unadjusted by SOC or other factors) is less than the ESS pack
    capability , the FC power is commanded to this maximum threshold.
3.  The FC power command will increase no faster than cs\_max\_pwr\_rise
    rate and decrease no faster than cs\_max\_pwr\_fall\_rate (which is
    a number \< 0).

*Determining FC Torque and Speed* \
The current version of the control strategy is designed for heat engines
characterized by torque and speed.<font size="-2">^1^  </font>In a
control script executed before the simulation is run, the locus of
highest efficiency torque/speed points is computed over the range of
genset (the combination of the engine and mated generator) powers.  The
control strategy keeps the FC torque and speed on this locus using a
lookup table defined by cs\_pwr and cs\_spd.

<p>
[Control Strategy Tips](cs_tips.html#Series) \
 

<center>
  -------------------------- ----------- ---------------------------------------------------------------------------------------------------------------------------------------------------------
  **Variable**               **Units**   **Description**
  cs\_hi\_soc                –           highest desired battery state of charge
  cs\_lo\_soc                –           lowest desired battery state of charge
  cs\_charge\_pwr            W           cs\_charge\_pwr\*fc\_spd\_scale\*fc\_trq\_scale\*((cs\_soc\_hi+ cs\_soc\_lo)/2-SOC) is the SOC-stabilizing adjustment made to the bus power requirement
  cs\_fc\_init\_state        –            1=\>fuel converter (FC) is initially on; 0=\>FC initially off
  cs\_max\_pwr               W           cs\_max\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the maximum power commanded of the fuel converter unless SOC\<cs\_lo\_soc
  cs\_min\_pwr               W           cs\_min\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the minimum power commanded of the fuel converter
  cs\_max\_pwr\_fall\_rate   W/s         cs\_max\_pwr\_fall\_rate\*fc\_spd\_scale\*fc\_trq\_scale is the fastest the fuel converter power command can decrease (this number \< 0)
  cs\_max\_pwr\_rise\_rate   W/s         cs\_max\_pw\_rise\_rate\*fc\_spd\_scale\*fc\_trq\_scale is the fastest the fuel converter power command can increase
  cs\_min\_off\_time         s           the shortest allowed duration of a FC-off period; after this time has passed, the FC may restart if high enough powers are required by the bus
  cs\_pwr                    W           cs\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the vector of FC powers that define the locus of best efficiency points throughout the genset map
  cs\_spd                    rad/s       cs\_spd\*fc\_spd\_scale is the vector of FC speeds in locus of best efficiency points, indexed by cs\_pwr\*fc\_spd\_scale\*fc\_trq\_scale
  -------------------------- ----------- ---------------------------------------------------------------------------------------------------------------------------------------------------------

  : **Series Control Strategy Variables**

</center>
<u>Example:</u> \
*Pure Thermostat as a Special Case of the General Control Strategy* \
To implement a pure thermostat control strategy, use something like the
following values of the control strategy parameters: \
cs\_hi\_soc=0.8;  <font color="#00CC00">% FC shuts off at 80% SOC</font>
\
cs\_lo\_soc=0.4;  <font color="#00CC00">% FC turns on at 40% SOC</font>
\
cs\_fc\_init\_state=0;  <font color="#00CC00">% FC initially off</font>
\
cs\_min\_pwr=max(fc\_max\_trq.\*fc\_map\_spd)\*.5; 
<font color="#00CC00">% FC operates at no less than 50% max power when
on</font> \
cs\_max\_pwr=max(fc\_max\_trq.\*fc\_map\_spd)\*.5;
<font color="#00CC00">% FC operates at no more than 50% max power when
on</font> \
cs\_charge\_pwr=0;  <font color="#00CC00">% FC output power, when on, is
independent of SOC</font> \
cs\_min\_off\_time=inf; <font color="#00CC00">% FC never restarts before
SOC falls below cs\_lo\_soc</font> \
cs\_max\_pwr\_rise\_rate=0; <font color="#00CC00">% FC output power
doesn’t increase while on</font> \
cs\_max\_pwr\_fall\_rate=0; <font color="#00CC00">% FC output power
doesn’t decrease while on</font> \
 

* * * * *

\
^<font size="-2">1</font>^<font size="-1">It is possible to use it,
however, to control other types of fuel converters such as fuel cells. 
The fuel cell vehicle model included with ADVISOR 2.0 gives an example
of this workaround.</font> \

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
