% gearbox
% 
% 

<!DOCTYPE html public "-//w3c//dtd html 4.0 transitional//en">

### Gearbox

[*Gearbox block diagram*](gb.gif)

**<u>**

Role of subsystem in vehicle</b></u> \
 The gearbox of a multi-speed transmission houses gears of different
gear ratios that are used to transmit torque from the engine or tractive
motor to the final drive and on to the wheels. It thereby allows a
number of discrete speed reduction and torque multiplication factors.
Inclusion of a gearbox is critical to the drivetrain of conventional and
parallel hybrid vehicles, and generally less important for series
hybrids.

**<u>**

Description of modeling approach</b></u> \
 The gearbox model in ADVISOR usually communicates physics (torque,
speed, and power) information to and from the final drive submodel and
engine, torque converter, and/or motor model. Control information as
might be sensed or commanded by a CPU in the vehicle, such as gear
number, is passed to and from the transmission control submodel.

Effects on torque and speed in the gearbox include:

-   torque multiplication and speed reduction via the gear ratio,
-   torque loss due to the acceleration of rotational inertia, and
-   torque loss due to the friction of the turning gears.

These effects are modeled empirically. Data files such as \<ADVISOR
directory\>/data/transmission/TX\_5SPD.M are required to supply
necessary physical parameters.

The equations represented by the Simulink block diagram in the picture
corresponding to the link above are as follows.

**<u>**

Equations used in subsystem</b></u> \
 TORQUE AND SPEED REQUIRED

(torque req’d into gearbox) = (torque req’d out of gearbox) / (current
gear ratio) +(torque req’d to accelerate rotational inertia) + (torque
loss due to friction),

where

(torque req’d out of gearbox) is a Simulink input (\#1, in the top left
of the above figure)

(current gear ratio) is computed from (current gear number), which is
provided by the “gearbox controller interface” block, using the look-up
vector **gb\_ratio**

(torque req’d to accelerate rotational inertia) = **gb\_inertia** \*
d(speed req’d into gearbox)/dt

(torque loss at transmission input due to friction) = function of
[torque at output-side of gearbox, angular speed at output side of
gearbox, gear (e.g., 1^st^, 2^nd^, etc.)]–this is implemented with a
lookup-table

(speed req’d into gearbox) = (speed req’d out of gearbox) \* (current
gear ratio)

TORQUE AND SPEED AVAILABLE

(torque avail. at output side of gearbox) = { (torque avail. at input
side of gearbox) \* [(output side power) / (input side power)]required -
(torque req’d to accelerate rotational inertia) } \* (current gear
ratio)

where

(torque avail. at input side of gearbox) is a Simulink input (\#2, in
the bottom left of the above figure)

[(output side power) / (input side power)]~required~ is computed from
the input and output torques and speeds of the REQUIRED calculations

(speed avail. at output side of gearbox) = (speed avail. at input side
of gearbox) / (current gear ratio)

All Matlab variables that must be defined in the workspace for the
gearbox submodel are mentioned above in **bold** font.

**<u>**

Variables used in subsystem</b></u>

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Gearbox) \
>  [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Gearbox)

* * * * *

</p>
[Back to Chapter 3](advisor_ch3.html)
