% Brake control: achievable
% 
% 

### Brake control: achievable

*[Brake Control (achievable) block diagram](brake.gif)*

**<u>Role of subsystem in vehicle</u>** \
The ‘front and rear brake controller (achievable)’ block determines how
much braking force will be supplied by the front and rear brakes taking
into account what total braking force is required and how much braking
the drivetrain is able to do.

**<u>Description of modeling approach</u>** \
The fraction of braking done by the front friction brakes are chosen so
as to keep their fraction of total braking (from all friction brakes and
driveline) the same as specified, and are subject to their maximum
braking force limits. The rear brakes do whatever required braking
remains, up to their limits. Consider this hypothetical example: the
braking strategy says that at 60 mph, 40% of braking should be done by
the drivetrain, 30% by the front friction brakes, and 30% by the rear
brakes. In one instance, the drivetrain is able to provide only 20% of
the total braking requirement, leaving 80% for the friction brakes. The
front brakes try to do half of the remaining braking, 40%, since they
are supposed to do as much braking as the rear friction brakes, but are
only capable of, say, 25% because they are hot. That leaves 100 – 20 –
25 = 55% for the rear brakes, which they provide if they can.

**<u>Equations used in subsystem</u>**

(braking force required at tire patch from front friction brakes) =
(braking force required from all friction brakes) \* (fraction of
braking supposed to be done by front friction brakes) / [ 1 – (fraction
of braking supposed to be done by driveline) ]

unless (fraction of braking supposed to be done by driveline)=1, in
which case

(braking force required at tire patch from front friction brakes) = 0.6.

(braking force supplied at tire patch by front friction brakes) = max(
(braking force required at tire patch from front friction brakes), (most
negative braking force front brakes can supply) )

(braking force required at tire patch required from rear friction
brakes) = (braking force required from all friction brakes) – (braking
force supplied at tire patch by front friction brakes)

(braking force supplied at tire patch by rear friction brakes) = max(
(braking force required at tire patch from rear friction brakes), (most
negative braking force rear brakes can supply) )

All braking forces are negative by convention.

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Appendix%20A.2%20Input)

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
