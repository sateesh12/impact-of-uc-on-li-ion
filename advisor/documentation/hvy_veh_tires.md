% Heavy Vehicle Tire Rolling Resistance Information (ADVISOR)
% 
% 

Heavy Vehicle Tire Rolling Resistance Information
=================================================

Introduction
------------

Michelin has provided NREL with the following data for low, high, and
mid-range rolling resistance numbers for heavy vehicle tires. The data
is taken by testing on a curved surface per SAE J2452. The flat surface
numbers are derived via [SAE
J2452](http://www.sae.org/servlets/productDetail?PROD_TYP=STD&PROD_CD=J2452_199906)
Eq. 22 ([Ref 2](#ref_2)). Rolling resistance coefficients are
dimensionless but are reported here as kg/T (kilograms of rolling
resistance per metric ton of axle load). Therefore, to arrive at the
dimensionless coefficient, divide by 1000.

Users should note that a new light duty tire rolling resistance model
has been added with the help of Michelin [click for documentation]. This
model takes into account such things as tire pressure, vehicle speed,
etc. However, for heavy vehicles, industry has claimed that rolling
resistance varies linearly with heavy vehicle load and varies only a
slightly with speed. Therefore, the existing model of ADVISOR 3.2 and
earlier is sufficient for heavy vehicles. The main benefit to be gained
is the additional rolling resistance data provided by Michelin (this
document).

The data presented here are given with a tractor trailer in mind. The
loading has not been explicitly defined for these data but it is assumed
the vehicle is fully loaded (total weight is 86000 lbs. [39040 kg]).
Tires are reported by tire size and tread design (e.g., steering tires,
drive tires, or trailer tires). 

Tire weights are mentioned for the 275/80 R22.5 XDA2 and 445/50 R22.5 X
One XDA tires in a recent SAE Paper ([Ref 1](#ref_1)). The breakdown is:

<div align="center">
<center>
<table border="1" width="100%">
<tr>
<th width="50%">
Wheel and Tire

</th>
<th width="50%">
Weight (lb. [kg])

</th>
</tr>
<tr>
<td width="50%" valign="middle" align="center">
(2)– Accuride (al)22.5" x 8.25" P/N 28548ANP, 

<p>
275/80 R22.5 XDA2

</td>
<td width="50%" valign="middle" align="center">
352  [160]

</td>
</tr>
<tr>
<td width="50%" valign="middle" align="center">
(1)–Accuride (al)22.5" x 14" P/N 29660AOP, 

<p>
445/50 R22.5 X One XDA

</td>
<td width="50%" valign="middle" align="center">
240  [109]

</td>
</tr>
</table>
</center>
</div>
Data
----

<div align="center">
<center>
<table border="1" width="100%">
<tr>
<th width="20%" valign="middle" align="center">
Tire Size

</th>
<th width="20%" valign="middle" align="center">
Tread Design

</th>
<th width="20%" valign="middle" align="center">
Curved Surface^\*\*^

rolling resistance value

<p>
[kg/T]

</th>
<th width="20%" valign="middle" align="center">
Flat Surface

rolling resistance value

<p>
[kg/T]

</th>
<th width="20%" valign="middle" align="center">
rolling radius\*

[m]

</th>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
315/80R22.5 (low RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
4.92

</td>
<td width="20%" valign="middle" align="center">
4.47

</td>
<td width="20%" valign="middle" align="center">
 all position 0.524

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
315/80R22.5 (medium RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
5.89

</td>
<td width="20%" valign="middle" align="center">
5.35

</td>
<td width="20%" valign="middle" align="center">
 all position 0.524

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
315/80R22.5 (high RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
6.89

</td>
<td width="20%" valign="middle" align="center">
6.26

</td>
<td width="20%" valign="middle" align="center">
 all position 0.524

</td>
</tr>
<tr>
<td width="100%" valign="middle" align="center" colspan="5">
 

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (low RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
5.20

</td>
<td width="20%" valign="middle" align="center">
4.72

</td>
<td width="20%" valign="middle" align="center">
 all position 0.494

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (medium RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
6.35

</td>
<td width="20%" valign="middle" align="center">
5.77

</td>
<td width="20%" valign="middle" align="center">
 all position 0.494

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (high RR)

</td>
<td width="20%" valign="middle" align="center">
Steer Tires

</td>
<td width="20%" valign="middle" align="center">
6.80

</td>
<td width="20%" valign="middle" align="center">
6.18

</td>
<td width="20%" valign="middle" align="center">
 all position 0.494

</td>
</tr>
<tr>
<td width="100%" valign="middle" align="center" colspan="5">
 

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (low RR)

</td>
<td width="20%" valign="middle" align="center">
Drive Tires

</td>
<td width="20%" valign="middle" align="center">
5.81

</td>
<td width="20%" valign="middle" align="center">
5.28

</td>
<td width="20%" valign="middle" align="center">
0.501

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (medium RR)

</td>
<td width="20%" valign="middle" align="center">
Drive Tires

</td>
<td width="20%" valign="middle" align="center">
7.15

</td>
<td width="20%" valign="middle" align="center">
6.50

</td>
<td width="20%" valign="middle" align="center">
 0.501

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (high RR)

</td>
<td width="20%" valign="middle" align="center">
Drive Tires

</td>
<td width="20%" valign="middle" align="center">
8.19

</td>
<td width="20%" valign="middle" align="center">
7.44

</td>
<td width="20%" valign="middle" align="center">
 0.501

</td>
</tr>
<tr>
<td width="100%" valign="middle" align="center" colspan="5">
 

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (low RR)

</td>
<td width="20%" valign="middle" align="center">
Trailer Tires

</td>
<td width="20%" valign="middle" align="center">
4.62

</td>
<td width="20%" valign="middle" align="center">
4.19

</td>
<td width="20%" valign="middle" align="center">
 0.489

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (medium RR)

</td>
<td width="20%" valign="middle" align="center">
Trailer Tires

</td>
<td width="20%" valign="middle" align="center">
5.31

</td>
<td width="20%" valign="middle" align="center">
4.82

</td>
<td width="20%" valign="middle" align="center">
 0.489

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
275/80R22.5 (high RR)

</td>
<td width="20%" valign="middle" align="center">
Trailer Tires

</td>
<td width="20%" valign="middle" align="center">
6.37

</td>
<td width="20%" valign="middle" align="center">
5.79

</td>
<td width="20%" valign="middle" align="center">
 0.489

</td>
</tr>
<tr>
<td width="100%" valign="middle" align="center" colspan="5">
 

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
445/50R22.5

</td>
<td width="20%" valign="middle" align="center">
Super Single Drive

</td>
<td width="20%" valign="middle" align="center">
5.00

</td>
<td width="20%" valign="middle" align="center">
4.54

</td>
<td width="20%" valign="middle" align="center">
 0.495

</td>
</tr>
<tr>
<td width="20%" valign="middle" align="center">
445/50R22.5

</td>
<td width="20%" valign="middle" align="center">
Super Single Trailer

</td>
<td width="20%" valign="middle" align="center">
3.77

</td>
<td width="20%" valign="middle" align="center">
3.43

</td>
<td width="20%" valign="middle" align="center">
 0.487

</td>
</tr>
</table>
</center>
</div>
\* Note: rolling radius determined from revolutions per mile data
available from Michelin website at <http://www.michelintruck.com/>
Steering tires are not explicitly called out. Therefore, the value for
“all position” tires is used for the steering tire.

\*\* Measured on a roadwheel with a diameter of 2.706 m

Usage within ADVISOR
--------------------

ADVISOR requires a single rolling resistance and wheel rolling radius
value to be specified. The wheel rolling radius for the drive wheel is
used (wh\_radius). The variable wh\_1st\_rrc is created via averaging
with weight fractions over the respective tire/wheel/axle types
(wh\_2nd\_rrc is assumed to be zero as speed dependence is considered
negligible for heavy vehicles).

wh\_1st\_rrc =
(rrc0\_steer\*wt\_frac\_steer)+(rrc0\_drive\*wt\_frac\_drive)+(rrc0\_trailer\*wt\_frac\_trailer)

Where wt\_frac\_steer is the weight fraction over all of the steering
tires, wt\_frac\_drive is the weight fraction over all of the drive
tires, and wt\_frac\_trailer is the weight fraction over all of the
trailer tires. All the weight fractions should sum to one. The rrc0\_\*
constants are then the rolling resistance coefficients for the given
tires taken from the data table above.

The above model is implemented in pre-processing in the wh\_\*.m file
for wheel and axle initialization.

References and Further Reading
------------------------------

<a name="ref_1">reference 1:</a>
:   M. Markstaller and A. Pearson and I. Janajreh. “On Vehicle Testing
    of Michelin New Wide Base Tire.” SAE 2000-01-3432. Society of
    Automotive Engineers. 2000.
<a name="ref_2">reference 2:</a>
:   SAE Specification J2452. “Stepwise Coastdown Methodology for
    Measuring Tire Rolling Resistance.” Society of Automotive Engineers.
    June 1999.
<a name="ref_3">reference 3:</a>
:   D. Hall and J. Moreland. “Fundamentals of Rolling Resistance.”
    Michelin Americas Research Corporation. ACS Rubber Division *Rubber
    Reviews*. 2001.

* * * * *

<center>
<p>
[Return to ADVISOR Documentation](advisor_doc.html)

</center>

* * * * *

<center>
<p>
Last revised: [04-April-2002] mpo \
Created: [03-April-2002] mpo

</center>
