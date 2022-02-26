% Lookup-Efficiency for Transmission Gearbox Model
% 
% 

New Lookup-Efficiency for Transmission Gearbox Model
====================================================

Previously in ADVISOR, an equation was used to calculate the torque lost
through the transmission. Although this technique is a valid way to
determine transmission efficiency, the equation-form suffers because
it’s coefficients are often-times non-conceptual. Furthermore,
customizing transmission gearbox efficiency is cumbersome using the
equation form.

<p>
Therefore, a lookup-table model for transmission gearbox efficiency is
now used. The model now determines transmission gearbox efficiency as a
function of transmission output torque (Nm), output speed (rad/s), and
current gear (e.g., 1st, 2nd, 3rd, etc.). This methodology is used with
both the manual and automatic transmission models.

<center>
<p>
**Note that due to interpolation error in the lookup table, slight
changes in fuel economy between vehicles in ADVISOR 3.1 and 3.2 should
be expected for vehicles that previously used the gearbox loss
equation.**

</center>
Within each (non-CVT) TX\_\* file, three variables are now specified in
place of the gearbox loss-equation coefficients (gb\_loss\_\* from
ADVISOR v3.1 and before). The new variables are tx\_map\_spd,
tx\_map\_trq, and tx\_eff\_map. ‘tx\_map\_trq’ and ‘tx\_map\_spd’ are
vectors while ‘tx\_eff\_map’ is a 3-dimensional matrix of efficiency
values. The variables ‘tx\_map\_spd’ and ‘tx\_map\_trq’ are used to
index the rows and columns of tx\_eff\_map for a given gear (the current
gear determines the “height” at which to access the rows and columns of
tx\_map\_trq).

In the current implementation, values of tx\_eff\_map must be between 0
and 1 (inclusive). Values above or below these limits will be cut to 0
and 1 in the algorithm. Efficiency values queried beyond the range
limits defined for gear (1 through height of tx\_map\_trq), tx\_map\_trq
(max(tx\_map\_trq) and min(tx\_map\_trq)), and tx\_map\_spd
(max(tx\_map\_spd) and min(tx\_map\_spd)) will be looked up after being
cut-down to the closest value. For example, if torque is specified up to
400 Nm and a value is requested at 500 Nm, the value will be looked up
as if the torque requested was 400 Nm. Similarly for gearing, if only
one gear is defined in tx\_eff\_map (i.e., if the height of tx\_eff\_map
is “1”), that same map will be used for all gears. Note that negative
torques should be defined in the tx\_map\_trq matrix to avoid using
efficiency values for the lowest positive torque defined to represent
all negative values. If the negative region is unknown, the positive
region efficiencies may be reflected about Torque=0 as a good first
estimate.

<p>
For user convenience, a function is available to automatically generate
tx\_map\_spd, tx\_map\_trq, and tx\_eff\_map using the previous
loss-equation. This function is called tx\_eff\_mapper and is in the
\<ADVISOR main directory\>/gui directory. The function tx\_eff\_mapper
has the following form:

<center>
<p>
[tx\_eff\_map, tx\_map\_spd, tx\_map\_trq] =
tx\_eff\_mapper(gb\_vars,w,T,gb\_ratio)

</center>
The arguments to the function are explained below: \
 

 gb\_vars
:   a structure with the following fields corresponding to the
    coefficients to the previous loss-equation:

</dl>
<dt>
w

</dt>
<dd>
a structure containing the transmission output angular speed values to
use for evaluating efficiency in the field “vals” (i.e., w.vals is an
array of speed values to evaluate [rad/s])

</dd>
<dt>
T

</dt>
<dd>
a structure containing the transmission output torque values to use for
evaluating efficiency in the field “vals” (i.e., T.vals is an array of
torque values to evaluate [Nm])

</dd>
<dt>
gb\_ratio

</dt>
<dd>
a listing of the gear ratios for the current gear box

</dd>
</dl>
Once tx\_eff\_mapper has been used, a simple contour plot may be made of
transmission gearbox efficiency by using the following:

figure, [c,h] = contour(tx\_map\_trq, tx\_map\_spd,
tx\_eff\_map(:,:,1),[0:0.05:1]); clabel(c,h), colorbar % plots
efficiency map for 1st gear \
 

Restoring the Old Equation Methodology for Transmission Efficiency
------------------------------------------------------------------

For those users who wish to continue using the previous equation form of
gearbox loss determination, a simple block diagram change is required.
For maximum safety, it is recommended that an original version of
***lib\_transmission*** be kept off of the ADVISOR path for restoration
purposes (for example, make a copy of ***lib\_transmission.mdl*** and
place it in a new folder \<ADVISOR directory\>/models/library/backup
created by the user).

Open ***lib\_transmission*** and **unlock library.**Delete the reference
to ***loss (Nm)*** appearing in ***lib\_transmission/gearbox \<gb\>***.
Also delete the FROM block for [gear\_number] as well as its
corresponding input line. Now go to ***lib\_transmission/SubLibraries***
and copy the block ***loss (Nm) old methodology***. Paste a reference to
***loss (Nm) old methodology*** back in ***lib\_transmission/gearbox
\<gb\>*** where the block ***loss (Nm)*** used to be and make sure that
all lines are connected. Save the library. It is recommended that matlab
be restarted to force Matlab/Simulink to recognize the new block diagram
changes (instead of using an old version which may be stored in memory).

Users should note that, although NREL will still be able to give advice
regarding the old equation model, it is no longer the “officially”
supported version.

* * * * *

<center>
[Return to ADVISOR Documentation Start Page](advisor_doc.html) \

* * * * *

</center>
Last revised [22-October-2001] mpo
