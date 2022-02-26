% Traction Control
% 
% 

### Traction control

*[Traction Control block diagram](tract.gif)*

*[Traction Control Setup on Input Figure](tract_input_fig.gif)*

**<u>Role of subsystem in vehicle</u>** \
The traction control block ensures that the tractive force and linear
speed required at the tire patch are consistent with the traction limit
of the tires. That is, no more force, either positive (accelerating) or
negative, will be requested than can be provided by the tire without its
‘peeling out’ or skidding. Also, no greater change in speed, either
positive or negative, will be requested than can be caused by the
limited force requirement.

**<u>Relationship to other component/subsystem models</u>** \
The traction control block interacts only with the ‘wheel and axle’
block and other control blocks that operate on the ‘wheel and axle.’

**<u>Description of modeling approach</u>** \
The maximum attainable speed is computed by solving
<font face="Symbol">S</font>F=ma for max. speed, by discretizing a in
terms of speeds at the beginning and end of the time step, and
accounting for the fact that the maximum force at the tire patch is a
function of weight on the axle, which is turn a function of
acceleration. The minimum speed is likewise computed, with a sign
reversal or two. The maximum force is then computed by using the limited
requested speed to compute the requested acceleration, going on to
compute the weight on the front (drive) axle

**<u>Equations used in model</u>**

(max. speed at end of time step) = [ max(**wh\_slip\_force\_coeff) \*
veh\_mass \* veh\_gravity \* veh\_front\_wt\_frac - veh\_mass \*
veh\_gravity \* (wh\_1st\_rrc** + sin(atan(**cyc\_grade**))) - 1/2
\***veh\_mass \* veh\_gravity \*wh\_2nd\_rrc** \* (speed at beginning of
time step) - 1/8 \* **veh\_air\_density \* veh\_CD \* veh\_FA** \*
(speed at beginning of time step)\^2 + max(**wh\_slip\_force\_coeff) \*
veh\_mass \* veh\_cg\_height / veh\_wheelbase** \* (speed at beginning
of time step) / (time step duration) + **veh\_mass** \* (speed at
beginning of time step) / (time step duration) ]  / [ 3/8 \*
**veh\_air\_density \* veh\_CD \* veh\_FA** \* (speed at beginning of
time step) + ½ \* **veh\_mass \* veh\_gravity \* wh\_2nd\_rrc +
veh\_mass** / (time step duration) + max(**wh\_slip\_force\_coeff) \*
veh\_mass \* veh\_cg\_height / veh\_wheelbase** ]

(speed at beginning of time step) = (speed at end of previous time step)

The (min. speed at end of time step) is computed using an equation
similar to the above, with some sign changes, and is applicable in
braking situations.

(maximum force) = max(**wh\_slip\_force\_coeff) \* [ veh\_mass \*
veh\_gravity \* veh\_front\_wt\_frac - veh\_mass \* veh\_cg\_height /
veh\_wheelbase** \* 2 \* ( (requested average vehicle speed) – (speed at
beginning of time step) ) / (time step duration) ]

In braking situations, the maximum force computed above is negative and
is the most negative value that the tractive force can take.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Appendix%20A.2%20Input)
>
> Beginning with the ADVISOR 2003 model there is now the availability to
> run front, rear or both axles for traction.  The new variables in the
> wheel data files are in the code as follows:
>
> % front or rear or both axles driving?\
>  wh\_front\_active\_bool=1; % 0==\> inactive; 1==\> active\
>  wh\_rear\_active\_bool=0; % 0==\> inactive; 1==\> active\
>
>  

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
