% APPENDICES--ADVISOR Documentation
% 
% 

<center>
<a name="Appendices A, A.1"></a>Appendices:
===========================================

</center>

* * * * *

<p>
[A. ADVISOR’s variables](#Appendices%20A,%20A.1)

> [A.1 Variable naming convention](#Appendices%20A,%20A.1) \
> [A.2 ADVISOR Input Variables](#Appendix%20A.2%20Input) \
> [A.3 ADVISOR Output Variables](#Appendix%20A.3%20Output)

[B. ADVISOR’s data files](#Appendix%20B) \
[C. Commonly used Matlab commands](#Appendix%20C) \
[D. Conventions for Goto tag use](#Appendix%20D) \
[E. Glossary](#Appendix%20E)

* * * * *

A. ADVISOR’s variables
----------------------

A.1 Variable naming convention
------------------------------

ADVISOR variable names use only lower-case letters.

All ADVISOR variables use prefixes except the three main output
variables: emis-tailpipe emissions, gal-total fuel use, and mpha-the
actual vehicle speed. The other input and output variables use the same
prefixes used for the component data file names, which are also enclosed
in ‘\<’ in the appropriate Simulink block on the main level of ADVISOR’s
block diagrams.

  ------------- -----------------------------------------------
  **cs\_\***    Hybrid control strategy variables
  **cvt\_\***   Continuously variable transmission variables
  **cyc\_\***   Driving cycle variables
  **ess\_\***   Energy storage system variables
  **fc\_\***    Fuel converter variables
  **fd\_\***    Final drive variables
  **gb\_\***    Gearbox variables
  **gc\_\***    Generator/controller variables
  **mc\_\***    Motor/controller variables
  **tx\_\***    Transmission variables
  **vc\_\***    Vehicle control variables (engine and clutch)
  **veh\_\***   Vehicle (coastdown-related) variables
  ------------- -----------------------------------------------

ADVISOR variable names with prefixes always use the word indicating the
units or value of the variable last. For example, the initial
state-of-charge of the energy storage system is stored in the variable
**ess\_init\_soc**.

<a name="Appendix A.2 Input"></a>A.2 ADVISOR Input Variables
------------------------------------------------------------

<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Drive Cycle </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
one line description of the drive cycle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_filter\_bool

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
1=not a max acceleration test (filter), 0=max acceleration test (don’t
filter)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_avg\_time

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
Dt over which to smooth drive cycle requests

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_mph

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
s, mph

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time in first column vs. vehicle speed in second column defining drive
cycle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_grade

</td>
<td valign="CENTER" width="10%">
matrix(nx2)

</td>
<td valign="CENTER" width="10%">
m,decimal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
distance in first column, decimal representation of road grade, i.e. 6%
grade=0.06 in second column

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_cargo\_mass

</td>
<td valign="CENTER" width="10%">
matrix(nx2)

</td>
<td valign="CENTER" width="10%">
m, kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
distance in first column, vehicle cargo mass in second column (this is
mass added to or subtracted from veh\_mass as a function of
distance–represents loading/unloading of vehicle)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cyc\_elevation\_init</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the initial elevation at the start of the drive
cycle</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Energy Storage System"></a>**<font size="+2">Energy
Storage System–Rint </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
text string description of the ESS

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_coulombic\_eff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
average Coulombic efficiency of the energy storage system (ESS)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_init\_soc

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
initial state of charge of the ESS

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_max\_ah\_cap

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
Ah

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
maximum A-h capacity the ESS can have, no matter how slowly it is
drained

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_module\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
mass of one energy storage module

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_module\_num

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
number of modules in a pack; ASSUMED TO BE STRUNG IN SERIES

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_min\_volts

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
V

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
minimum battery operating voltage, not to be exceeded during discharge

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_max\_volts

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
V

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
maximum battery operating voltage, not to be exceeded during charge

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_r\_chg

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
ohms

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
module’s resistance to being charged; indexed by ess\_soc and ess\_tmp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_r\_dis

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
ohms

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
module’s resistance to being discharged; indexed by ess\_soc and
ess\_tmp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_soc

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
vector of SOCs used to index other ESS variables

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
vector of temperatures used to index other ESS variables

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_voc

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
volts

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
module’s open-circuit voltage; indexed by ess\_soc and ess\_tmp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_calc

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0=no ess thermal calculations, 1=do calculations

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kgK

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave heat capacity of module

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_set\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermostat temp of module when cooling fan comes on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
total module surface area exposed to cooling air 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_airflow

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cooling air mass flow rate across module 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_flow\_area

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cross-sec flow area for cooling air per module 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_case\_thk

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thickness of module case (typ from Optima)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_case\_th\_cond

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/mK

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermal conductivity of module case material 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_vel

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave velocity of cooling air

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_htcoef

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/m\^2K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cooling air heat transfer coef.

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_res\_on

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
K/W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tot thermal res key on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_res\_off

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
K/W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tot thermal res key off (cold soak)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">battery\_mass</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Insight</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the mass of the batteries</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_mod\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the initial temperature of the energy storage
system module</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Energy Storage System RC"></a>**<font size="+2">Energy
Storage System–RC </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
text string description of the ESS

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_init\_soc

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
initial state of charge of the ESS

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_max\_ah\_cap

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
Ah

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
maximum A-h capacity the ESS can have, no matter how slowly it is
drained

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_module\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
mass of one energy storage module

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_module\_num

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
number of modules in a pack; ASSUMED TO BE STRUNG IN SERIES

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_min\_volts

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
V

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
minimum battery operating voltage, not to be exceeded during discharge

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_max\_volts

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
V

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
maximum battery operating voltage, not to be exceeded during charge

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_cb

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
Farads

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
module’s main capacitance, represents the ample capability of the
battery to store charge chemically; indexed by ess\_tmp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_cc

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
Farads

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
module’s secondary capacitance, represents the surface effects of a
spiral-wound cell, e.g. the limiting behavior of a battery to deliver
current based on time constants associated with the diffusion of
materials and chemical reactions; indexed by ess\_tmp

</td>
</tr>
<tr>
<td>
ess\_re

</td>
<td>
matrix

</td>
<td>
ohms

</td>
<td>
par/ser

</td>
<td>
resistance Re (see schematic in documentation), resistance associated
with capacitor Cb; indexed by ess\_soc and ess\_tmp

</td>
</tr>
<tr>
<td>
ess\_rc

</td>
<td>
matrix

</td>
<td>
ohms

</td>
<td>
par/ser

</td>
<td>
resistance Rc (see schematic in documentation), resistance associated
with capacitor Cc; indexed by ess\_soc and ess\_tmp

</td>
</tr>
<tr>
<td>
ess\_rt

</td>
<td>
matrix

</td>
<td>
ohms

</td>
<td>
par/ser

</td>
<td>
resistance Rt (see schematic in documentation), represents terminal
resistance; indexed by ess\_soc and ess\_tmp

</td>
</tr>
<tr>
<td>
ess\_voc

</td>
<td>
matric

</td>
<td>
volts

</td>
<td>
par/ser

</td>
<td>
module’s open-circuit voltage; indexed by ess\_soc and ess\_tmp.  Used
to correlate voltage on Cb to SOC

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_soc

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
vector of SOCs used to index other ESS variables

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
vector of temperatures used to index other ESS variables

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_calc

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0=no ess thermal calculations, 1=do calculations

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kgK

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave heat capacity of module

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_set\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermostat temp of module when cooling fan comes on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
total module surface area exposed to cooling air 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_airflow

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cooling air mass flow rate across module 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_flow\_area

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cross-sec flow area for cooling air per module 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_case\_thk

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thickness of module case (typ from Optima)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_case\_th\_cond

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/mK

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermal conductivity of module case material 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_vel

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave velocity of cooling air

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_htcoef

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/m\^2K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cooling air heat transfer coef.

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_res\_on

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
K/W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tot thermal res key on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_th\_res\_off

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
K/W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tot thermal res key off (cold soak)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">battery\_mass</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Insight</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the mass of the batteries</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_mod\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the initial temperature of the energy storage
system module</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Energy Storage System NNet Model"></a>**<font size="+2">Energy
Storage System–Neural Network Battery Model Variables </font>**(Input
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_max\_p</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector (2 units long)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ nnet battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">power corresponding to SOC values supplied in
ess\_max\_p\_soc. Used for maximum power calculation in neural network
battery model (see block diagram advisor\_ess\_options/energy storage
\<ess\> nnet/max pack pwr (W) in the ‘max power’ block)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_max\_p\_soc</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector (2 units long)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ nnet battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">minimum and maximum state of charge used for
maximum power calculation in neural network battery model (see block
diagram advisor\_ess\_options/energy storage \<ess\> nnet/max pack pwr
(W) in the ‘max power’ block)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_MMi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">matrix (2x2)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">[W,W;–;–]</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ nnet battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">minimum and maximum input values for power
requested and SOC:</font> \
<font color="#000000">[min power requested, max power requested;</font>
\
<font color="#000000">corresponding SOC for min power, corresponding SOC
for max power]</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_MMo</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">matrix (2x2)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">[A,A;V,V]</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ nnet battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">minimum and maximum outputs: current, voltage
(same layout as ess\_MMi)</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Energy Storage System Fund Model"></a>**<font size="+2">Energy
Storage System–Fundamental Battery Model Variables </font>**(Input
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aao2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">anodic charge transfer coefficient for O~2~
evolution at positive electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aapb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">anodic charge transfer coefficient for Pb
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aapbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">anodic charge transfer coefficient for PbO~2~
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ach2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">cathodic charge transfer coefficient for H~2~
evolution at negative electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aco2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">cathodic charge transfer coefficient for O~2~
reaction at positive electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_acpb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">cathodic charge transfer coefficient for Pb
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_acpbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">cathodic charge transfer coefficient for PbO~2~
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aopb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm-1)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial internal surface area for Pb
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_aopbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm-1)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial internal surface area for PbO~2~
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_c2ref</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">mole/cm3</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">reference acid concentration</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_cacid</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">M</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial concentration of sulfuric acid in the
cell</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_cap</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A\*hr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">rated capacity of the cell</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_dUdT</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">temperature coefficient for cell potential</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ech2rf</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A/cm\^2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">reference exchange current density, H~2~ electrode
at 25^o^C</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ecnref</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A/cm\^2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">reference exchange current density, Pb electrode
at 25^o^ C</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_eco2rf</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A/cm\^2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">reference exchange current density, O~2~ at 25^o^
C</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ecpref</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A/cm\^2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">reference exchange current density, PbO~2~
electrode at 25^o^ C</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_egass</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">volume fraction of gas in separator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_elgel</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">length of the unrolled electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_elpb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">thickness of the negative electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_elpbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">thickness of the positive electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_elsep</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">thickness of the separator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_epb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">volume fraction of active material in negative
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_epbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">volume fraction of active material in positive
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_esep</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">separator volume fraction</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_fc</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C/equiv</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">Faraday’s constant</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_fo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">fraction of O2 that recombines at negative
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_gexn</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">expansion coefficient for nodes in the negative
electrode (ratio of adjacent cells, number greater than 1 concentrates
nodes at electrode front)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_gexp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">expansion coefficient for nodes in the positive
electrode (ratio of adjacent cells; number greater than 1 concentrates
nodes at electrode front)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_gvoln</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">volume fraction of supporting grid in the negative
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_gvolp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">volume fraction of supporting grid in the positive
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_htel</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">height of the unrolled electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_n</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of coupled equations</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ncpmod</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of cells per module</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_nmppk</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of modules per pack</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_npb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of computational nodes in negative
electrode(lead)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_npbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of computational nodes in positive
electrode (lead oxide)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_nsep</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">number of computational nodes in separator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_pneg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exponent for area correction, Pb electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ppos</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exponent for area correction, PbO~2~
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_qneg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C/cm\^3</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">theoretical capacity of negative electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_qpos</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C/cm\^3</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">theoretical capacity of positive electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ratio</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">ratio of gas to liquid volume fractions in the
electrodes</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_relax</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">relaxation factor for iterative solution of
coupled equations (0=no update, 1 = no relaxation)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_rgas</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">J/mole/K</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">gas constant</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_rkcsatn</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">mass transfer parameter for negative
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_rkcsatp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">mass transfer parameter for positive
electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_rtop</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">ohms</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">resistance to account for current collection and
tab</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_spb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">S/cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">electronic conductivity of lead</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_spbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">S/cm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">electronic conductivity of lead dioxide</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tcurmx</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">A</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">maximum motor current</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_theta</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">factor used to determine time averaging (0 = fully
explicit, 0.5 = Crank-Nicholson, 1= fully implicit)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tpb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exponent on volume fraction for tortuosity
correction in negative electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tpbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exponent on volume fraction for tortuosity
correction in positive electrode</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tplus</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">transference number for hydrogen ion</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tsep</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exponent on volume fraction for tortuosity
correction in separator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_tstep</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial value for time step (not needed-remove
later) </font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_uh2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">V</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">equilibrium voltage for H~2~ vs. Pb</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_uo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">V</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">equilibrium voltage for O~2~ vs. Pb</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_ve</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm\^3)/mole</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">partial molar volume of acid</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vmax</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">V</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">maximum voltage</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vmin</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">V</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">minimum voltage</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vo</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm\^3)/mole</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">partial molar volume of water</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vpb</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm\^3)/mole</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">molar volume of Pb</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vpbo2</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm\^3)/mole</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">molar volume of PbO~2~</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_vpbso4</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">(cm\^3)/mole</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">veh w/ fund. battery ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">molar volume of PbSO~4~</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Fuel Converter"></a>**<font size="+2">Fuel Converter
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
text string description of the fuel converter

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_proprietary

</td>
<td valign="CENTER">
boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_type

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
description of fuel type

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_disp

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
L

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
engine size (cyl displacement)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_emis

</td>
<td valign="CENTER">
boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no emissions data available 1= emissions data available

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_map\_spd

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
engine speed range

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_map\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
engine torque range

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
fuel use indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_co\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine out CO indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_hc\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine out HC indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_nox\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine out NOx indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_pm\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine out PM indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_extmp\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
C

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine-out exhaust gas temperature indexed by fc\_map\_spd and
fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_exflow\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
exhaust gas mass flow rate indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_co2map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
exhaust carbon dioxide flow rate indexed by fc\_map\_spd and
fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_ct\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
closed throttle torque indexed by fc\_map\_spd

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_den

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
g/L

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
fuel density

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_lhv

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
J/g

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
lower heating value of the fuel

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_inertia

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg\*m\^2

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
rotational inertia of the engine

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_max\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all(\~fuel cell)

</td>
<td valign="CENTER">
maximum torque output indexed by fc\_map\_spd

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_spd\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
scaling factor for speed range

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_trq\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
scaling factor for torque range

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_pwr\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
scaling factor for power=fc\_trq\_scale\*fc\_spd\_scale

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_max\_pwr

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kW

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine peak power in kW

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_coolant\_init\_tmp

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
C

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
initial coolant temperature

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of the fuel converter and fuel system

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_base\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of the base engine (block)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_acc\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of engine accessories such as turbo, radiator, SLI battery, etc.

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of fuel and fuel tank

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_ex\_pwr\_frac

</td>
<td valign="CENTER">
1x2 vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
[ low speed fraction    high speed fraction]  \
frac of waste heat that goes to exhaust(used to estimate fc\_extmp\_map
if not provided)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_tstat

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
C

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
engine coolant thermostat set temperature (typically 95 +/- 5 C)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_cp

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
J/kg/K

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ave cp of engine (iron=500, Al or Mg=1000)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_h\_cp

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
J/kg/K

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_ext\_sarea

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m\^2

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
exterior surface area of engine

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_hood\_sarea

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m\^2

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
surface area of hood/eng. compartment

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_emisv

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
eff emissivity of engine ext surface to hood int surface

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_hood\_emisv

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
emissivity hood ext

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_h\_air\_flow

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
heater air flow rate (140 cfm=0.07)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_cl2h\_eff

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ave cabin heater HX eff (based on air side)

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_c2i\_th\_cond

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
W/K

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
conductance btwn engine cycl & int

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_i2x\_th\_cond

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
W/K

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
conductance btwn engine int & ext

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_h2x\_th\_cond

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
W/K

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
conductance btwn engine & engine compartment

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_eff\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
scale factor for engine efficiency

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_pwr\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
net power out of the fuel cell used to index fc\_fuel\_map for power vs
efficiency fuel cell model

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_I\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
amps/m\^2

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
cell current density of the fuel cell used to index the fc\_fuel\_map
for the polarization curve fuel cell model

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_V\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
volts

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
cell voltage indexed by current density for the polarization curve fuel
cell model

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_pump\_pwr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
fuel pump power required indexed by fuel flow (fc\_fuel \_pump\_map) for
the polarization curve model when using liquid fuels

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_pump\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
fuel pump fuel flow  for the polarization curve model when using liquid
fuels

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_air\_comp\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
air compressor  flow for the polarization curve model when using
pressurized systems

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_air\_comp\_pwr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
air compressor power required indexed by air flow (fc\_air comp\_map)
for the polarization curve model when using pressurized systems

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_water\_pump\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
water pump flow for the polarization curve model when using liquid fuels

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_water\_pump\_pwr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
water pump power required indexed by water flow (fc\_water\_pump\_map)
for the polarization curve model when using liquid fuels

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_coolant\_pump\_pwr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
coolant pump power required indexed by coolant flow (fc\_coolant
\_pump\_map) for the polarization curve model 

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_coolant\_pump\_map

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
g/s

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
coolant flow (fc\_fuel \_pump\_map) for the polarization curve model 

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_cell\_num

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
number of cells per stack

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_stack\_num

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
number of stacks per parallel string

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_string\_num

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
number of parallel strings

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_cell\_area

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m\^2

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
active area per cell

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_cell\_model

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
model type identifier 1== polarization model, 2== power vs efficiency
model, 3== GCTool-based model

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_air\_ratio

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
g/g

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
mass based fuel to air ratio used in polarization curve model to
determine air flow requirement based on fuel requirement

</td>
</tr>
<tr>
<td valign="CENTER">
fc\_fuel\_water\_ratio

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
g/g

</td>
<td valign="CENTER">
fuel cell

</td>
<td valign="CENTER">
mass based fuel to water ratio used in polarization curve model to
determine water flow requirement based on fuel requirement

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_c\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with fc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial temperature of the engine cylinder</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_h\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with fc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial hood temperature</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_i\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with fc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial engine interior temperature</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_x\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with fc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial engine exterior temperature</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_coolant\_cp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">J/(g\*K)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">fuel cell</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">coolant specific heat capacity</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_coolant\_flow\_rate</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">g/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">fuel cell</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">fixed coolant flow rate</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Powertrain Control </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
ptc\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
one line description for the ptc

</td>
</tr>
<tr>
<td valign="CENTER">
ptc\_proprietary

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
ptc\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
ptc\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Transmission </font>**(Input Variables)  \
The transmission includes the gearbox and the final drive axle.

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
tx\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of the transmission=gb\_mass+fd\_mass

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
tx\_pg\_r

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
prius\_jpn

</td>
<td valign="CENTER" width="50%">
number of teeth on ring gear of planetary gear system

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
tx\_pg\_s

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
prius\_jpn

</td>
<td valign="CENTER" width="50%">
number of teeth on sun gear of planetary gear system

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_validated</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">flag: 0=\> no validation, 1=\> data agrees with
source data, 2=\> data matches source data and data collection methods
have been verified</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_validation</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">flag: 0=\> no validation, 1=\> data agrees with
source data, 2=\> data matches source data and data collection methods
have been verified</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_type</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">char</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the type of transmission: e.g., ‘manual 1 speed’,
‘manual 5 speed’, ‘cvt’, ‘auto 4 speed’</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_version</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">ADVISOR version number for which data file was
created</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_eff\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">another term for gb\_eff\_scale</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_proprietary</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">0=\> non-proprietary, 1=\> proprietary, do not
distribute</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_description</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">char</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">text string description of transmission</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_map\_spd</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">rad/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">an array indexing rows of tx\_eff\_map with
transmisison output speed</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_map\_trq</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Nm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">an array indexing columns of tx\_eff\_map with
transmisison output torque</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">tx\_eff\_map</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">3d matrix</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">efficiency map of transmission efficiency by
output speed, output torque, and gear number</font>

</td>
</tr>
<tr>
<td>
tx\_spd\_dep\_upshift

</td>
<td>
2d matrix \
(n x 2)

</td>
<td>
[m/s, \
gear num]

</td>
<td>
all except \
CVT and \
Prius

</td>
<td>
a two column matrix with speed (m/s) in the first column and gear number
in the second column. This matrix is used as a lookup table for gear
duing upshifting. Note: the information should be presented as a
step-function (e.g., [0 1; 10 1; 10 2; 20 2])

</td>
</tr>
<tr>
<td>
tx\_spd\_dep\_dnshift

</td>
<td>
2d matrix \
(n x 2)

</td>
<td>
[m/s, \
gear num]

</td>
<td>
all except \
CVT and \
Prius

</td>
<td>
Similar to tx\_spd\_dep\_upshift. This matrix is used as a lookup table
for gear duing downshifting. Note: the information should be presented
as a step-function (e.g., [0 1; 10 1; 10 2; 20 2])

</td>
</tr>
<tr>
<td>
tx\_speed\_dep

</td>
<td>
Boolean

</td>
<td>
–

</td>
<td>
all except \
CVT and \
Prius

</td>
<td>
a flag which indicates if speed-dependent shifting or default Advisor
control strategy based shifting should be used. a ‘1’ indicates speed
dependent shifting while a ‘0’ indicates default control strategy. 

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Final Drive"></a>**<font size="+2">Final Drive Axle
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
text string description of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_proprietary

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_inertia

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg\*m\^2

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
rotational inertia of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_loss

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque loss of final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_ratio

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
gear ratio of final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of final drive - 1990 Taurus, OTA report

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Gearbox"></a>**<font size="+2">Gearbox </font>**(Input
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
text description of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_validation

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_version

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which gearbox data was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_gearX\_dnshift\_load

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
fraction of max load at current speed at which downshift is requested in
gear X

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_gearX\_dnshift\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
speed at which downshift is requested in gear X

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_gearX\_upshift\_load

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
fraction of max load at current speed at which upshift is requested in
gear X

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_gearX\_upshift\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
speed at which upshift is requested in gear X

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_gears\_num

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
number of gears in gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_inertia

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg\*m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
rotational inertia of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_const

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_input\_spd\_coeff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/rad

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_input\_trq\_coeff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/(N\*m)

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_output\_pwr\_coeff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_output\_spd\_coeff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/rad

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_loss\_output\_trq\_coeff

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/(N\*m)

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
used in [equation 1](#Equation%201)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_ratio

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
available gear ratios of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_shift\_delay

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
duration of a shift, no torque is transmitted

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_eff\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">gb\_eff\_scale is not used directly in modeling
and should always be equal to one. It is a variable used for default
scaling and is used for initialization purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_mass</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">mass of the gearbox (transmission and control
boxes without fluids)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_spd\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">speed scaling parameter; used to scale
gb\_map\_spd to simulate a faster or slower running gear box</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_trq\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">torque scaling parameter; used to scale
gb\_map\_trq to simulate a higher or lower torque gb</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_dnshift\_load</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all non-CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of loads (0 to 1) for down-shifting
commands (see lib\_controls block diagram). (the first element is for
1st gear, etc.)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_dnshift\_spd</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">rad/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all non-CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of speeds (rad/s) for down-shifting
commands (see lib\_controls block diagram). (the first element is for
1st gear, etc.)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_upshift\_load</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all non-CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of loads (0 to 1) for up-shifting
commands (see lib\_controls block diagram). (the first element is for
1st gear, etc.)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_upshift\_spd</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">rad/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all non-CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of speeds (rad/s) for up-shifting
commands (see lib\_controls block diagram). (the first element is for
1st gear, etc.)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gb\_validated</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar (flag)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">0=\> no validation, 1=\> confirmed agreement with
source data, 2=\> agrees with source data, and data collection methods
have been verified</font>

</td>
</tr>
</table>
<a name="Equation 1"></a>Equation (1): P\_loss =
(gb\_loss\_input\_spd\_coeff \* gear\_ratio +
gb\_loss\_output\_spd\_coeff)\*output\_shaft\_speed +
(gb\_loss\_input\_trq\_coeff / gear\_ratio +
gb\_loss\_output\_trq\_coeff) \* output\_shaft\_torque +
gb\_loss\_output\_pwr\_coeff \* output\_shaft\_power + gb\_loss\_const \
  \
 

<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input HTC"></a>**<font size="+2">Hydraulic Torque Converter
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_k

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s/(N\*m)\^0.5

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque converter’s K-factor

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_k\_coast</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">rad/s/(N\*m)\^0.5</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">K factor of the hydraulic torque converter for
coasting, w~in~/(T~in~)^0.5^; only needs be defined for
auto-transmission</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_k\_adv</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">rad/s/(N\*m)\^0.5</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">advisor K factor for the hydraulic torque
converter defined as w~out~/(T~out~)^0.5^, only needs be defined for
auto-transmission</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_k\_adv\_coast</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">rad/s/(N\*m)\^0.5</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">advisor K factor defined as w~out~/(T~out~)^0.5^,
for coasting, only needs be defined for auto-transmission</font>

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_sr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque converter speed ratio, indexed by htc\_k

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_tr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque converter torque ratio, indexed by htc\_k

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_inertia</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">N\*m-s\^2</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">inertia of the hydraulic torque converter, used
for automatic transmissions</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_lockup</font>

</td>
<td valign="CENTER">
<font color="#000000">vector</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">htc\_lockup(i)==’when in gear i, lock up HTC’;
only needs be defined for auto-transmission</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_max\_coast\_tr</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">maximum torque ratio while coasting</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_min\_coast\_tr</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the minimum torque ratio while coasting</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_sr\_coast</font>

</td>
<td valign="CENTER">
<font color="#000000">vector</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the speed ratio of the hydraulic torque converter
for coasting. sr = w~out~/w~in~</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_tr\_coast</font>

</td>
<td valign="CENTER">
<font color="#000000">vector</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the torque ratio of the hydraulic torque converter
for coasting. tr=T~out~/T~in~ where T is torque</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input CVT"></a>**<font size="+2">Continuously Variable
Transmission </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_eff\_mapX

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
efficiency map for pulley ratio \#X, (X goes from 1 to 5 currently)
indexed by cvt\_map\_spd and cvt\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_inertia

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg\*m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
rotational inertia of CVT, measured at input shaft

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_map\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
range of CVT INPUT speeds

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_map\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
range of CVT INPUT torques

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_ratio

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
range of pulley ratios

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_spd\_scale

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
compresses or stretches (values1) speed range for map

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cvt\_trq\_scale

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
compresses or stretches (values1) torque range for map

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Vehicle Control"></a>**<font size="+2">Vehicle Control
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
vc\_clutch\_bool

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
conv

</td>
<td valign="CENTER" width="50%">
1 = engine is clutched out to avoid compression braking, 0= compression
braking is allowed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
vc\_idle\_bool

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
conv

</td>
<td valign="CENTER" width="50%">
1 = engine idles, 0= engine turns off when it would otherwise idle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
vc\_idle\_spd

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
conv/ser

</td>
<td valign="CENTER" width="50%">
idle speed of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
vc\_key\_on

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
s, –

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time in first column and corresponding key position in second column,
0=key off, 1=key on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
vc\_launch\_spd

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
conv

</td>
<td valign="CENTER" width="50%">
clutch input speed during clutch slip at vehicle launch

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Vehicle"></a>**<font size="+2">Vehicle Definition
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_proprietary

</td>
<td valign="CENTER">
Boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
text string description of the vehicle

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_1st\_rrc

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
1st coefficient of rolling resistance (no longer used as of version
2002)

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_2nd\_rrc

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
s/m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
2nd coefficient of rolling resistance (no longer used as of version
2002)

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_CD

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
coefficient of aerodynamic drag

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_FA

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m\^2

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
vehicle frontal area

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_cg\_height

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
height of the vehicle center of gravity

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_front\_wt\_frac

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
fraction of total vehicle mass supported by front axle when vehicle is
not moving

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_wheelbase

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
distance between front and rear axle

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_glider\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
mass of the vehicle without components

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
test mass, including fluids, passengers, and cargo

</td>
</tr>
<tr>
<td valign="CENTER">
veh\_cargo\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
cargo mass

</td>
</tr>
</table>
<table border="1" cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Wheel Axle"></a>**<font size="+2">Wheel/Axle
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
text string description of the wheels

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_proprietary

</td>
<td valign="CENTER">
Boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_axle\_loss\_mass

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
vehicle test mass, used to index wh\_axle\_loss\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_axle\_loss\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
front brake and axle bearing drag torque

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_fa\_dl\_brake\_frac

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
fraction of braking done by driveline via front axle

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_fa\_dl\_brake\_mph

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
mph

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
vehicle speed, used to index wh\_fa\_dl\_brake\_frac

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_fa\_fric\_brake\_frac

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
fraction of braking done by front axle friction brakes

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_fa\_fric\_brake\_mph

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
mph

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
vehicle speed, used to index wh\_fa\_fric\_brake\_frac

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_inertia

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg\*m\^2

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
rotational inertia of the wheels

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
total mass of all wheels 

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_radius

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
radius of the wheel

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_slip

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel slip of drive wheels

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_slip\_force\_coeff

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
(tractive force on front tires)/(vehicle weight on front tires), used to
index wh\_slip

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_1st\_rrc

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
1st coefficient of rolling resistance such that force of rolling
resistance is (wh\_1st\_rrc+v\*wh\_2nd\_rrc)\*M\*g\*cos(theta) [where
Mgcos(theta) is the weight normal over the axle

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_2nd\_rrc

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
s/m

</td>
<td valign="CENTER">
 

</td>
<td valign="CENTER">
2nd coefficient of rolling resistance

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Accessories-Related </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
text string description of the accessories

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_mech\_pwr

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
accessories mechanical load

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
acc\_elec\_pwr

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
accessories electrical load

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Exhaust System (& Catalyst) Variables </font>**(Input
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
text string description of the exhaust system

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_calc

</td>
<td valign="CENTER" width="10%">
boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
=0= skip ex sys calc (if fc has no emis maps or no cat info available) 
1= perform ex sys calcs including tailpipe emis

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_tmp\_range

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cat temperature range used with frac vectors

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_hc\_frac

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
catalyst HC conversion efficiency indexed by ex\_cat\_temp\_range

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_co\_frac

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
catalyst CO conversion efficiency indexed by ex\_cat\_temp\_range

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_nox\_frac

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
catalyst NOx conversion efficiency indexed by ex\_cat\_temp\_range

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pm\_frac

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
catalyst PM conversion efficiency indexed by ex\_cat\_temp\_range

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_lim

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
“break-thru” limit of converter (HC, CO, NOx, PM), max g/s for each
pollutant

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_mon\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of catalyst monolith (ceramic)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_int\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of catalyst internal SS shell

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pipe\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of catalyst inlet/outlet pipes

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_ext\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of cat ext shell (shield)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_manif\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of engine manifold & downpipe

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pcm\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of cat phase change mat’l heat storage

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_muf\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
mass of muffler and other pipes downstream of cat

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
total mass of the exhaust system

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_mass</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">mass of catalytic converter</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_mon\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of catalyst monolith

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_int\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of catalyst internal SS shell

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pipe\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of catalyst i/o pipes

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_ext\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of catalyst ext

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_manif\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of manifold & dwnpipe

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_gas\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
average cp of exh gas

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pcm\_tmp

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
temp range for cat pcm ecp vec

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pcm\_ecp

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave eff heat cap of pcm (latent + sens)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_mon\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
outer surface area of cat monolith

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_monf\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
surface area of cat monolith front face

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_moni\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
inner (honeycomb) surf area of cat monolith

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_int\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
surface area of cat interior

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pipe\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
surface area of cat i/o pipes

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_ext\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
surface area of cat ext shield

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_man2cat\_length

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
length of exhaust pipe between manifold and cat conv

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_manif\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
surface area of manif & downpipe: pi\*D\*L

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_m2p\_emisv

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissivity x view factor from cat monolith to cat pipes

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_i2x\_emisv

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissivity from cat int to cat ext shield

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pipe\_emisv

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissivity of cat i/o pipe

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_ext\_emisv

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissivity of cat ext shield

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_manif\_emisv

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissivity of manif & dwnpipe

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_m2i\_th\_cond

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
W/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cond btwn CERAMIC mono & int

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_m2i\_tmp

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
corresponding temperature vector

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_i2x\_th\_cond

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
conductance btwn cat int & ext

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_i2p\_th\_cond

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
conductance btwn cat int & pipe

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_p2x\_th\_cond 

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
conductance btwn cat pipe & ext

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_max\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
maximum catalyst temperature(only used in old calc method)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_mon\_init\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
INIT CONDITION:monolith converter temp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_int\_init\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
INIT CONDITION:internal converter temp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_pipe\_init\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
INIT CONDITION:in/out converter pipe temp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_ext\_init\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
INIT CONDITION:external converter temp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_manif\_init\_tmp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
INIT CONDITION:manifold temp

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_mat\_th\_res</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">m\*m\*K/W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">x/k th res of mat or extra sleeve (NO MAT w/METAL
MONO) or expanding paper mat (SAE\#880282)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_mon\_th\_res</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">m\*m\*K/W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with close coupled converters</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">x/k th res of outer row of monolith cells</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_pcm\_cp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">J/kg/K</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with vacuum insulated converters</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">sens heat cap of cat pcm (LiNO3)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_pcm\_lh</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">J/kg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with vacuum insulated converters</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">latent heat of cat pcm</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_cat\_pcm\_mp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with vacuum insulated converters</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">melting point of cat pcm</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ex\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">scaling factor for the exhaust system</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Miscellaneous </font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
filename

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
name of the block diagram to be used

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_gravity

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m/s\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
gravitational acceleration

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
amb\_temp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ambient temperature

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_air\_density

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg/m\^3

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
density of air

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">pwr\_index</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">an index variable in a FOR loop in some of the
PTC\_\*.m files. This variable should not appear on the workspace in
future versions of ADVISOR.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">air\_cp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">J/kg/K</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">specific heat of air</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">deltaSOC\_tol</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">tolerance for zero delta SOC correction, given by
user in the GUI</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ic\_description</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">char</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">description of initial conditions, e.g., ‘Standard
initial conditions’ or ‘Hot-Start initial conditions’</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">max\_zero\_delta\_iter</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">maximum number of zero delta SOC iterations</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Generator Controller"></a>**<font size="+2">Generator/Controller
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
text string description of the generator

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_proprietary

</td>
<td valign="CENTER">
Boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_map\_spd

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
speed range of the generator

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_map\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
torque range of the generator

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_eff\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
generator efficiency map indexed by gc\_map\_spd and gc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_inertia

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg\*m\^2

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
rotational inertia of the generator

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_mass

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
kg

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
mass of the generator

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_max\_crrnt

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
A

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
max. current allowed in generator/controller

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_max\_trq

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
maximum torque output of the generator indexed by gc\_map\_spd

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_min\_volts

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
V

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
min. voltage allowed in generator/controller

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_outpwr\_map

</td>
<td valign="CENTER">
matrix

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
electric output power map, indexed by gc\_map\_spd and gc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_overtrq\_factor

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
factor by which absorbed input torque can exceed max continuous for
short periods

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_spd\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
speed scaling factor

</td>
</tr>
<tr>
<td valign="CENTER">
gc\_trq\_scale

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
ser

</td>
<td valign="CENTER">
torque scaling factor

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_cp</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">J/kg/K</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">used in the prius\_jpn thermal model. Average heat
capacity of motor/controller (estimate: ave of SS & Cu)</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_eff\_scale</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">generator/controller efficiency scaling. This
variable is not used directly in modelling and should always be equal to
one–it’s used for initialization purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_inpwr\_map</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">W</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">used in the prius\_jpn block diagram generator
controller model. The input power for each torque and speed for the
generator/controller</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_sarea</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">m\^2</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">the surface area of the generator/controller. used
in the prius\_jpn block diagram (lib\_electric\_machine/Prius gen/
controller \<gc\>)</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_th\_calc</font>

</td>
<td valign="CENTER">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">a flag. 0=no mc thermal calculations, 1=do
calc’s</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_tstat</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">C</font>

</td>
<td valign="CENTER">
<font color="#000000">prius\_jpn</font>

</td>
<td valign="CENTER">
<font color="#000000">thermostat temp of motor/controler when cooling
pump comes on</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Torque Coupler"></a>**<font size="+2">Torque Coupler
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_description

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
text string description of the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_proprietary

</td>
<td valign="CENTER">
Boolean

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_validation

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_version

</td>
<td valign="CENTER">
char

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_loss

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
loss parameter

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_mc\_to\_fc\_ratio

</td>
<td valign="CENTER">
scalar

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
constant ratio of speed at motor torque input to speed at engine torque
input

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Motor Controller"></a>**<font size="+2">Motor/Controller
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_description

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
text string description of the motor/controller

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_proprietary

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= public data, 1= restricted access

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_validation

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= no validation, 1= confirmed agreement with source data, 2= agrees
with source data, and source data collection methods have been verified

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_version

</td>
<td valign="CENTER" width="10%">
char

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
ADVISOR version number for which data file was created

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_map\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
speed range of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_map\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
torque range of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_eff\_map

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
efficiency map of the motor indexed by mc\_map\_spd and mc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_inertia

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg\*m\^2

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
rotational inertia of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_inpwr\_map

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
input power map, indexed by mot\_map\_spd and mot\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_mass

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
mass of the motor/controller

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_max\_crrnt

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
A

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
max. current allowed in motor/controller

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_max\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
maximum torque curve of the motor indexed by mc\_map\_spd

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_min\_volts

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
V

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
min. voltage allowed in motor/controller

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_overtrq\_factor

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
factor by which output torque can exceed max continuous for short
periods

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_spd\_scale

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
speed scaling factor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_trq\_scale

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
torque scaling factor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_th\_calc

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
0=no mc thermal calculations, 1=do calc’s

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_cp

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
J/kg/K

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave heat capacity of motor/controller 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_tstat

</td>
<td valign="CENTER" width="10%">
Scalar

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermostat temp of motor/controller when cooling pump comes on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_sarea

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
total module surface area exposed to cooling fluid

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_area\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">area scaling factor for the
motor/controller</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_eff\_scale</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">not used directly in modeling, this variable
should always be equal to one as it is used for initialization
purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_max\_cont\_trq</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">N\*m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">maximum continuous torque curve of the motor
indexed by mc\_map\_spd</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_outpwr\_map</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">matrix</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">used to compute mc\_inpwr\_map as mc\_inpower\_map
= mc\_outpwr\_map + mc\_losspwr\_map</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_init\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">initial temperature of the motor/controller</font>

</td>
</tr>
</table>
<table border width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
<a name="Input Control Strategy"></a>**<font size="+2">Control Strategy
</font>**(Input Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_charge\_trq

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par

</td>
<td valign="CENTER" width="50%">
hybrid\_chargetrq\*(SOCinit-SOC) = an alternator-like torque loading on
the engine to recharge the battery pack; negative recharge is never
requested

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_electric\_launch\_spd

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
m/s

</td>
<td valign="CENTER" width="10%">
par

</td>
<td valign="CENTER" width="50%">
vehicle speed threshold; below this speed, the fuel converter is turned
off

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_min\_trq\_frac

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par

</td>
<td valign="CENTER" width="50%">
cs\_min\_trq\_frac\*(torque capability of engine at current speed) =
minimum torque threshold; when commanded at a lower torque, the engine
will operate at the threshold torque and the motor acts as a generator

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_off\_trq\_frac

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par

</td>
<td valign="CENTER" width="50%">
cs\_off\_trq\_frac\*(torque capability of engine at current speed) =
minimum torque threshold; when commanded at a lower torque, the engine
will SHUT OFF

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_fc\_init\_state

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
1=fuel converter (FC) is initially on; 0=FC initially off

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_charge\_pwr

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_charge\_pwr\*fc\_spd\_scale\*fc\_trq\_scale\*((cs\_soc\_hi+
cs\_soc\_lo)/2-SOC) is the SOC-stabilizing adjustment made to the bus
power requirement

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_max\_pwr

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_max\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the maximum power
commanded of the fuel converter unless SOC\<cs\_lo\_soc

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_min\_pwr

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_min\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the minimum power
commanded of the fuel converter

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_max\_pwr\_fall\_rate

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_max\_pwr\_fall\_rate\*fc\_spd\_scale\*fc\_trq\_scale is the fastest
the fuel converter power command can decrease (this number \< 0)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_max\_pwr\_rise\_rate

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
W/s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_max\_pw\_rise\_rate\*fc\_spd\_scale\*fc\_trq\_scale is the fastest
the fuel converter power command can increase

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_min\_off\_time

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
the shortest allowed duration of a FC-off period; after this time has
passed, the FC may restart if high enough powers are required by the bus

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_pwr\*fc\_spd\_scale\*fc\_trq\_scale is the vector of FC powers that
define the locus of best efficiency points throughout the genset map

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
cs\_spd\*fc\_spd\_scale is the vector of FC speeds in locus of best
efficiency points, indexed by cs\_pwr\*fc\_spd\_scale\*fc\_trq\_scale

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_hi\_soc

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
highest state of charge allowed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_lo\_soc

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
lowest state of charge allowed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_fc\_spd\_opt

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
prius\_jpn

</td>
<td valign="CENTER" width="50%">
optimum speed points for fc operation used along with cs\_fc\_trq\_opt
and cs\_fc\_pwr\_opt

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_fc\_trq\_opt

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
prius\_jpn

</td>
<td valign="CENTER" width="50%">
optimum torque points for fc operation used along with cs\_fc\_spd\_opt
and cs\_fc\_pwr\_opt

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cs\_fc\_pwr\_opt

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
Watts

</td>
<td valign="CENTER" width="10%">
prius\_jpn

</td>
<td valign="CENTER" width="50%">
power values for which cs\_fc\_trq\_opt and cs\_fc\_spd\_opt are
defined.

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_charge\_deplete\_bool</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">1=\> use charge deplete strategy, 0=\> use charge
sustaining strategy</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_fc\_max\_pwr\_frac</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par with CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">engine power fraction below which engine would
like to operate</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_fc\_min\_pwr\_frac</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par with CVT</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">engine power fraction above which engine would
like to operate</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_hi\_trq\_frac</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">load/ SOC balanced par</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">highest desired engine load fraction</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_lo\_trq\_frac</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">load/ SOC balanced par</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">lowest desired engine load fraction</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_offset\_soc</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">x-intercept of electric launch speed vs. SOC -
ONLY active if cs\_charge\_deplete\_bool=1</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_trq\_to\_soc\_factor</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">load/ SOC balanced par</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">weighting factor for the relative importance of
engine operation near the goal to the SOC operation near the goal ==\>
low values mean that SOC is more important, large values mean engine is
more important</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cs\_tstat\_init\_state</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">EV</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">used in EV PTC, initial FC state; 1=\> on, 0=\>
off</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#CCFFFF">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Simulation Control Variables</font>** (Input
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">sim\_stop\_distance</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">used in the \<vc\> block (see lib\_controls.mdl),
when enable\_sim\_stop\_distance is non-zero, to stop the simulation
after a desired distance has been traversed. Used in control logic for
events such as acceleration test.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">sim\_stop\_speed</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">mi/hr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">used in the \<vc\> block when
enable\_sim\_stop\_speed is non-zero to stop the simulation if a desired
speed is exceeded. Used in control logic for events such as the
acceleration test.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">sim\_stop\_time</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">used in the \<vc\> block when
enable\_sim\_stop\_time is non-zero to stop the simulation when
sim\_stop\_time has elapsed. Used in control logic for events such as
the acceleration test.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_sim\_stop\_distance</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">GUI/simulation related variable used with the
acceleration test. See \<vc\> /sim stop sub-system in the block
diagrams.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_sim\_stop\_speed</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">GUI/simulation related variable used with the
acceleration test. See \<vc\> /sim stop sub-system in the block
diagrams.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_sim\_stop\_time</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">GUI/simulation related variable used with the
acceleration test. See \<vc\> /sim stop sub-system in the block
diagrams. </font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_speed\_scope</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">GUI/simulation related variable used with the
J1711 test</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_stop\_fc</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">if set to 1, then the simulation will end when the
engine (fc) is turned on. Else, if set to 0, the simulation will run
regardless of whether the engine is on or not.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_on</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">simulation control parameter; 1 = fuel converter
on, 0 = fuel converter off. If =0, run in EV mode with J1711 test</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">enable\_stop</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">if enabled, used by J1711 test procedure to stop
simulation when SOC=0</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_on</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">Boolean simulation parameter used to show if the
batteries are enabled (=1) or disabled (=0). Used by J1711 test
procedure for conventional mode</font>

</td>
</tr>
</table>

* * * * *

<center>
<a name="Appendix A.3 Output"></a><u>A.3 ADVISOR output variables</u>
---------------------------------------------------------------------

</center>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Accessories </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_elec\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the efficiency of the electrical accesories</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_elec\_pwr\_in\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the achieved electrical power input to
accesories</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_elec\_pwr\_out\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the achieved electrical power out from
accesories</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_mech\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the efficiency of the accessory
(mechanical)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_mech\_pwr\_in\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the achieved mechanical power input to the
mechanical accesories for each time step of the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_mech\_pwr\_out\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the achieved useful mechanical power output from
the mechanical accesories for each time step of the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">acc\_mech\_trq</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">N\*m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">constant torque load on engine</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Drive Cycle </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
cyc\_mph\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
mph

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
requested vehicle speed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">cyc\_kph\_r</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kph</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">requested vehicle speed in units of kilometer per
hour</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
t

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector defining the drive cycle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_key\_off

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector for key off; 0=key on 1=key off

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
elevation

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector containing vehicle elevation above sea level

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
grade

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
decimal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector of the grade of the road during the simulation in
decimal(ex. 0.02 is a 2% grade)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_cargo\_mass\_vs\_time

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
kg

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector of the added (subtracted) mass of the vehicle vs.
time–available to plot in post-processing

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
distance

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
m

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
time vector containing the distance the vehicle has traveled

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Energy_Storage_System"></a>**<font size="+2">Energy
Storage System </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_pwr\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
power out of ess available

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_pwr\_out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
power out of ess requested

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_soc\_hist

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
state of charge history

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_current

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
A

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
current output of the battery

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_mod\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave temperature of battery module

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave temperature of battery cooling air

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ess\_air\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
heat removed from battery by cooling air 

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_ess\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= ess not power limited, 1= ess power limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_ess\_minV

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0=ess not limited by minimum voltage, 1=ess min voltage limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_ess\_maxV

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0=ess not limited by maximum voltage, 1=ess max voltage limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">dE\_dt\_stored</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess.</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">vector of the energy stored in the energy storage
system by time step.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_pwr\_loss\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the actual power loss for the energy storage
system</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">lim\_ess\_soc\_hi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the energy storage system state of charge upper
limit (see block diagram in the \<sdo\> block)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">lim\_ess\_soc\_low</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the energy storage system state of charge upper
limit (see block diagram in the \<sdo\> block)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">round-trip efficiency</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_in\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">total energy into energy storage system over the
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">total energy into the energy storage system not
stored or used as output over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">useful energy leaving the batteries over the drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_stored\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">energy stored in the energy storage system over
the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">useful energy leaving the batteries over the drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">ess\_stored\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the difference between the energy into storage and
the useful energy out of storage</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">eta\_ess\_chg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">recharge efficiency</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">eta\_ess\_dis</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">discharge efficiency</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">into\_storage\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">useful energy coming into the batteries over the
drive cycle.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">out\_of\_storage\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vehicles with ess</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">energy leaving the batteries when power is flowing
out (useful out+losses out)</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Generator_Controller"></a>**<font size="+2">Generator/Controller
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gc\_pwr\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
available power out of generator

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gc\_spd\_in\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
available speed into the generator

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gc\_trq\_in\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
ser

</td>
<td valign="CENTER" width="50%">
available torque into the generator

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">genset\_min\_pwr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the minimum power of the generator/controller
set</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">all with gc</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the generator/controller</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all with gc</font>

</td>
<td valign="CENTER">
<font color="#000000">total energy into the generator/controller over
the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all with gc</font>

</td>
<td valign="CENTER">
<font color="#000000">the loss of the generator/controller over the
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">gc\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all with gc</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy output of the
generator/controller over the drive cycle</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Motor_Controller"></a>**<font size="+2">Motor/Controller
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_mc\_crrnt

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
amps

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= motor/controller not current limited, 1= motor/controller current
limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_mc\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= motor/controller not speed limited, 1= motor/controller current
limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_mc\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= motor/controller not torque limited, 1= motor/controller current
limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_mc\_voltage

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
volts

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
0= motor/controller not voltage limited, 1= motor/controller current
limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_pwr\_in\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
available power into the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_pwr\_in\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
power requested from the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_spd\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
available speed out of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_spd\_out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
requested speed out of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_trq\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
available torque out of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_trq\_out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
par/ser

</td>
<td valign="CENTER" width="50%">
requested torque out of the motor

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
ave temperature of motor and controller

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mc\_clt\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
heat removed from motor/ctrl by coolant

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_max\_trq\_vec</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">N\*m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">vector of maximum torques. See motor/controller
block diagram \<mc\>, motor/controller \<mc\> par, and motor/controller
\<mc\> prius, under ‘enforce torque limit’ sub-block for details of
use.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_ni\_trq\_out\_a</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">N\*m</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">rotor drive torque available (see motor controller
block diagram)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_pwr\_loss</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">power lost by the motor/controller</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_spd\_est</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">rad/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">par/ser</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">motor’s rotor speed during previous time
step</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the efficiency of the motor/controller</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_in\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the total energy into the motor during a drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the difference between the total energy into and
the total useful energy out of the motor/controller during a drive
cycle.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mc\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the total useful energy out of the
motor/controller during a drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mot\_as\_gen\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">motor efficiency when acting as a generator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mot\_as\_gen\_in\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">input to the motor as a generator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mot\_as\_gen\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">difference between the input and the useful output
of the motor as a generator</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mot\_as\_gen\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all with mc</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the useful output of the motor as a
generator</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Power Bus </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
pb\_pwr\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
par/ser

</td>
<td valign="CENTER">
available power out of the power bus

</td>
</tr>
<tr>
<td valign="CENTER">
pb\_pwr\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
W

</td>
<td valign="CENTER">
par/ser

</td>
<td valign="CENTER">
requested power out of the power bus

</td>
</tr>
<tr>
<td valign="CENTER">
pb\_voltage

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
volts

</td>
<td valign="CENTER">
par/ser

</td>
<td valign="CENTER">
voltage of the power bus

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Torque_Coupler"></a>**<font size="+2">Torque Coupler
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_spd\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
available speed out of the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_spd\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
requested speed out of the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_trq\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
available torque out of the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_trq\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
requested torque out of the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
tc\_pwr\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m/s

</td>
<td valign="CENTER">
par

</td>
<td valign="CENTER">
available power into the torque coupler

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the torque coupler over the
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the torque coupler over the
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_in\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the torque coupler during
regenerative breaking events for the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the difference between the total power into the
torque coupler and the total useful power out of the torque
coupler</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the total useful energy output of the torque
coupler over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_out\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the total useful energy output of the torque
coupler over the drive cycle that is associated with regenerative
breaking</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_regen\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the torque coupler with regard
to transmitting energy for regenerative breaking</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">tc\_regen\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">par</font>

</td>
<td valign="CENTER">
<font color="#000000">the cumulative energy lost over the drive cycle
during regenerative breaking events</font>

</td>
</tr>
</table>
<table border width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Vehicle"></a>**<font size="+2">Vehicle </font>**(Output
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
emis

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tailpipe out HC, CO, NOx and PM emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
emis\_old

</td>
<td valign="CENTER" width="10%">
matrix 

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
tailpipe HC, CO, NOx, and PM emissions using old method (catalyst
temperature dependent on time only)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
emis\_ppm

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
ppm

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
emissions in parts-per-million (1=HC, 2=CO, 3=NOx, 4=PM)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gal

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
gal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
cumulative gallons of fuel consumed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">liters</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">liters</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">cumulative liters of fuel consumed</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mpha

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
mi/hr

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
achieved vehicle speed

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">kpha</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kilometer/hr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">achieved vehicle speed (kph)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_force\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
force achieved by the vehicle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_force\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
force requested by the vehicle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_spd\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
m/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
speed achieved by the vehicle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
veh\_spd\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
m/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
speed requested by the vehicle

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ar1

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
m/s\^2

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
vehicle acceleration rate requested

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_key\_off

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
boolean

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
specifies if ignition key is off (1=off, 0=on)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">aero\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">loss due to aerodynamic drag on the vehicle in
kilo-joules</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Wheel_Axle"></a>**<font size="+2">Wheel/Axle
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
lim\_wh\_brake

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel brake limited Boolean: 1= wheel brakes were force limited, 0=
wheel brakes were not force limited

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_spd\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel speed achieved

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_spd\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel speed requested

</td>
</tr>
<tr>
<td valign="CENTER">
lim\_wh\_traction

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel traction limited Boolean: 1= wheel was slip limited, 0= wheel was
not slip limited

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_trq\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel torque achieved

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_trq\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
wheel torque requested

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_slip\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
amount of slip requested at wheels

</td>
</tr>
<tr>
<td valign="CENTER">
wh\_brake\_loss\_pwr

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
amount of power loss from braking

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the wheel during the drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy transmitted in through the wheel
(from the power train) during the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_in\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy transmitted in through the wheel
for purposes of regenerative breaking</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the difference between the total energy into the
wheel and the useful energy transmitted by the wheel over the drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the useful energy output of the wheel during the
drive cycle–used to maintain the achieved force and speed</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_out\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the useful energy transmitted up the drive train
by the wheel for regeneration during the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_regen\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the wheel with respect to
regeneration</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">wh\_regen\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the difference between the total kinetic energy
into the wheel and the useful energy transmitted up the drive train by
the wheel for regenerative breaking over the drive cycle</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Final Drive Axle </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_spd\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved into the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_spd\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested into the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_spd\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved out of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_spd\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested out of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_trq\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved into the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_trq\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested into the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_trq\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved out of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
fd\_trq\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested out of the final drive

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the average efficiency over the drive cycle for
the final drive</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the final drive over the
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_in\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the final drive over the
drive cycle for the purpose of regeneration</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy lost through the final drive
during the drive cycle. Equal to the difference between the total energy
into the final drive minus the useful energy output from the final
drive</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total useful energy output from the final
drive during the drive cycle.</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_out\_regen\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy transmitted up the drive train by
the final drive for purposes of regeneration.</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_regen\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy transmitted up the drive train by
the final drive for purposes of regeneration.</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">fd\_regen\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the cumulative loss through the final drive during
regeneration events in a drive cycle</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Gearbox"></a>**<font size="+2">Gearbox </font>**(Output
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_spd\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_spd\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_spd\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_spd\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_trq\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_trq\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_trq\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gb\_trq\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER">
gear\_number

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
current gear number

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_HTC"></a>**<font size="+2">Hydraulic Torque Converter
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_spd\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
speed achieved into the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_spd\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
speed requested into the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_spd\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
speed achieved out of the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_spd\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
speed requested out of the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_trq\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque achieved into the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_trq\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque requested into the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_trq\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque achieved out of the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
htc\_trq\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
conv

</td>
<td valign="CENTER">
torque requested out of the torque converter

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the hydraulic torque
converter</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the hydraulic tourque
converter over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the net loss through the hydraulic torque
converter over the drive cycle in kJ</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the total useful energy out of the hydraulic
torque converter over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_regen\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the hydraulic torque converter
with respect to regeneration</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_regen\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the hydraulic torque
converter over the drive cycle that is to be used for regeneration
purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_regen\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the total loss of energy during the drive cycle
associated with regeneration events</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">htc\_regen\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">conv</font>

</td>
<td valign="CENTER">
<font color="#000000">the total useful energy output of the hydraulic
torque converter for purpose of regeneration</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_CVT"></a>**<font size="+2">Continuously Variable
Transmission </font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_spd\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved into the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_spd\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested into the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_spd\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed achieved out of the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_spd\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
rad/s

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
speed requested out of the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_trq\_in\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved into the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_trq\_in\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested into the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_trq\_out\_a

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque achieved out of the CVT

</td>
</tr>
<tr>
<td valign="CENTER">
cvt\_trq\_out\_r

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
N\*m

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
torque requested out of the CVT

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Clutch"></a>**<font size="+2">Clutch </font>**(Output
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER">
lim\_clutch\_dis

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
clutch disengaged Boolean, 1= disengaged, 0= engaged or partially
engaged

</td>
</tr>
<tr>
<td valign="CENTER">
clutch\_state

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
clutch state: 1= clutch disengaged, 2= clutch slipping, 3= clutch
engaged

</td>
</tr>
<tr>
<td valign="CENTER">
shifting

</td>
<td valign="CENTER">
vector

</td>
<td valign="CENTER">
–

</td>
<td valign="CENTER">
all

</td>
<td valign="CENTER">
0= not shifting gears, 1= shifting gears

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the clutch</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy into the clutch over a drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the difference between the energy into the clutch
and the energy out of the clutch in kJ over a drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy out of the clutch in kJ over a
drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_regen\_eff</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">–</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the efficiency of the clutch over the drive cycle
with regard to regeneration</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_regen\_in\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy over the drive cycle entering
into the clutch for regeneration purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_regen\_loss\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the difference between the energy into the clutch
for regeneration purposes and the energy leaving the clutch for
regeneration purposes</font>

</td>
</tr>
<tr>
<td valign="CENTER">
<font color="#000000">clutch\_regen\_out\_kj</font>

</td>
<td valign="CENTER">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER">
<font color="#000000">all</font>

</td>
<td valign="CENTER">
<font color="#000000">the total energy over the drive cycle that leaves
the clutch for regeneration purposes (kJ)</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
<a name="Output_Fuel_Converter"></a>**<font size="+2">Fuel Converter
</font>**(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_spd\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
speed achieved by the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_spd\_out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
rad/s

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
speed requested of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_trq\_ out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
torque output achieved by the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_fc\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
engine torque limited Boolean, 1= engine was torque limited, 0= engine
was not torque limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_fc\_spd

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
engine speed limited Boolean, 1= engine was torque limited, 0= engine
was not torque limited

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_trq\_ out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
torque output requested of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_inertia\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
inertial torque of the fuel converter

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
lim\_engine\_off

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
1= engine off, 0= engine on

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_brake\_trq

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
N\*m

</td>
<td valign="CENTER" width="10%">
all(\~fuel cell)

</td>
<td valign="CENTER" width="50%">
torque output requested of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_coolant\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermal power (heat) from fc into coolant

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_emis\_eo

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
engine-out HC, CO, NOx, and PM emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_ex\_gas\_flow

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
exhaust gas mass flow rate

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_fuel\_in\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
fuel converter input (fuel) power

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_fuel\_rate

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
g/s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
fuel converter fuel use in grams per second

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_mech\_out\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
fuel converter output (mechanical) power

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
waste heat from combustion to engine mass

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_r\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
heat removed from engine mass by radiator

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_h\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
heat extracted from engine coolant for cabin heating

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_pwr\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
fuel cell

</td>
<td valign="CENTER" width="50%">
electrical power out of the fuel cell system achieved

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_pwr\_out\_r

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
fuel cell

</td>
<td valign="CENTER" width="50%">
electrical power out of the fuel cell system requested

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_spd\_est</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">rad/s</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the estimated angular speed of the fuel converter
(see block diagrams)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">matrix (n x 4)</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">fuel converter temperatures with time.
Temperatures are: cylinder temperature, engine interior temperature
(block), engine exterior temperature (engine accessories), and hood
temperature.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_eff\_avg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the average efficiency of the fuel converter over
the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_ex\_gas\_tmp</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">C</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the temperature of the exhaust gasses out of the
fuel converter over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_ex\_th\_pwr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">W</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">exhaust heat expelled during the drive
cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the difference between the fuel energy into the
fuel converter and the useful energy created by the fuel converter over
the drive cycle in kJ</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the useful energy out of the fuel converter over
the drive cycle in kJ</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">fc\_retard\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the total negative work (i.e., retardation) on the
fuel converter over the drive cycle</font>

</td>
</tr>
</table>
<table border cellpadding="2" width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Exhaust System (& Catalyst) Variables</font>**(Output
Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_eff

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
HC, CO, NOx, and PM efficiency of converter \
    (1 - emis/fc\_emis\_eo)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_tmp

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
interior converter (monolith) temperature based on lumped-capacitance
thermal model

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_tmp\_old

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
interior converter (monolith) temperature based on old method
(exponential warmup or cooldown based on time fc is off or on)

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_cat\_th\_pwr

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
thermal power (heat) from catalysis of emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_gas\_tmp

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
matrix of exhaust gas temperatures vs time:  \
    1: catalyst out  \
    2: catalyst in  \
    3: manifold out

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
ex\_tmp

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
C

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
exhaust system temperatures vs time:  \
    1: interior converter (monolith)  \
    2: converter mass except for monolith and shell  \
    3: converter inlet pipe (second half of downpipe)  \
    4: outer converter shell (radiation shield)  \
    5: ave temp of manifold and first half of downpipe

</td>
</tr>
</table>
<table border width="100%">
<tr bgcolor="#FFCC99">
<td valign="CENTER" colspan="5">
<center>
**<font size="+2">Miscellaneous and Post-Processing Output</font>**
(Output Variables)

</center>
</td>
</tr>
<tr bgcolor="#FFFFCC">
<td valign="CENTER" width="20%">
**<u>Name</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Type</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Units</u>**

</td>
<td valign="CENTER" width="10%">
**<u>Vehicle Type</u>**

</td>
<td valign="CENTER" width="50%">
**<u>Description</u>**

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
dist

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
mi

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
total distance traveled

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
dt

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
s

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
size of the time step

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
COgpmi

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
g/mi

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle CO emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">co\_gpm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">g/mi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">drive cycle CO emissions</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
HCgpmi

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
g/mi

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle HC emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">hc\_gpm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">g/mi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">drive cycle HC emissions</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
NOxgpmi

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
g/mi

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle NOx emissions

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">nox\_gpm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">g/mi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">drive cycle NOx emissions</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">pm\_gpm</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">g/mi</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">drive cycle PM emissions</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gal

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
gal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
gallons of fuel used per time step

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
hybrid

</td>
<td valign="CENTER" width="10%">
Boolean

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
hybrid vehicle flag: 1= vehicle is a hybrid, 2= vehicle is not a hybrid

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">mpg</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">mi/gal</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the average fuel economy for the drive cycle (for
the type of fuel used)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mpgge

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
mi/gal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle miles per gallon gasoline equivalent

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
mpgde

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
mi/gal

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle miles per gallon diesel equivalent

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_eta

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
second-by-second efficiency of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_eta\_avg

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle average efficiency of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_in\_Jmax

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
J

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
energy into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_out\_Jmax

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
J

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
energy out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_pwr\_in\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
power achieved into the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
gb\_pwr\_out\_a

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
power achieved out of the gearbox

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_eta

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
second-by-second engine efficiency

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_eta\_avg

</td>
<td valign="CENTER" width="10%">
scalar

</td>
<td valign="CENTER" width="10%">
–

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
drive cycle average engine efficiency

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_in\_Jmax

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
J

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
energy into the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_in\_W

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
power into the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_map\_kW

</td>
<td valign="CENTER" width="10%">
matrix

</td>
<td valign="CENTER" width="10%">
kW

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
kilowatt output of the engine indexed by fc\_map\_spd and fc\_map\_trq

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_out\_Jmax

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
J

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
energy output of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
fc\_out\_W

</td>
<td valign="CENTER" width="10%">
vector

</td>
<td valign="CENTER" width="10%">
W

</td>
<td valign="CENTER" width="10%">
all

</td>
<td valign="CENTER" width="50%">
power output of the engine

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">aux\_load\_eff</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the efficiency of the auxiliary load
components</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">aux\_load\_in\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the total auxiliary load (mechanical + electrical)
input in kilo-Joules</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">aux\_load\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the loss of energy to the auxiliary load (in
kJ)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">aux\_load\_out\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the output energy from the auxiliary load</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">trace\_miss</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">mi/hr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of the absolute difference in required
speed of the cycle and the actual speed achieved by the vehicle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">trace\_miss\_allowance</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">mi/hr</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">GUI variable used to set the warning flag window.
If trace\_miss ever exceeds trace\_miss\_allowance, a warning will be
sent to the warnings window in the GUI. The user does not normally need
to change this variable.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">brake\_loss\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">the total energy lost to the brakes during the
driving cycle in kJ</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">gear\_ratio</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">vector</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">a vector of the gear ratio for each gear
setting.</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">missed\_deltaSOC</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">stores whether the delta SOC was within a
tolerance band of .005 (0 = false, 1 = true)</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">missed\_trace</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">Boolean</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">–</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">stores whether or not the the vehicle ever missed
the trace by greater than the allowable margin</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">road\_load\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">total energy required for vehicle to travel at the
achieved speed and force over the drive cycle</font>

</td>
</tr>
<tr>
<td valign="CENTER" width="20%">
<font color="#000000">rolling\_kj</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">scalar</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">kJ</font>

</td>
<td valign="CENTER" width="10%">
<font color="#000000">all</font>

</td>
<td valign="CENTER" width="50%">
<font color="#000000">total energy required for vehicle to overcome
rolling resistance over the drive cycle</font>

</td>
</tr>
</table>
<center>
<a name="Appendix B"></a>B. ADVISOR’s data files
------------------------------------------------

</center>
All model and data files use a prefix followed by an underscore (’\_’)
that is the same as the prefix used for (nearly all of) the variables it
defines, which in turn is in pointy brackets (\<) at the end of the
Simulink block in which those variables are used. Here are ADVISOR’s
component file types:

<dir>
**ACC\_\*.M** Accessory load files \
**CYC\_\*.M** Driving cycle files, which define variables starting with
cyc\_, used in the block labeled \<cyc \
**ESS\_\*.M** Energy storage system data files, which likewise define
variables starting with ess\_, used in the block labeled \<ess \
**EX\_\*.M** Exhaust after-treatment files (such as catalysts) \
**FC\_\*.M** Fuel converter data files \
**FD\_\*.M** Final drive data files \
**GB\_\*.M** Gearbox data files \
**GC\_\*.M** Generator/controller data files \
**MC\_\*.M** Motor/controller data files \
**PTC\_\*.M** Powertrain control data files, which define engine
control, clutch control, and hybrid control strategy variables starting
with vc\_ and cs\_, used in blocks labeled \<vc and \<cs \
**TC\_\*.M**Torque coupler data files \
**VEH\_\*.M** Vehicle data files \
**WH\_\*.M** Wheel/axle data files

</dir>
In addition to the above component data files, there are two other types
that use prefixes:

<dir>
**BD\_\*.MDL** Simulink block diagrams (models) \
**CV\_\*.M** Complete vehicle files that include all necessary
references to component files to define an entire vehicle

</dir>
<a name="Appendix C"></a>C. Commonly used Matlab commands
---------------------------------------------------------

Listed below are a few commands that are frequently used to reduce and
inspect ADVISOR’s input and output data. Matlab help is available on all
of these commands by entering *helpwin command, help command*, or
*helpdesk* at the command line. A very useful Matlab help feature is the
‘lookfor’ command, which searches the one line descriptions of all
Matlab commands for the word that you enter. To use ‘lookfor,’ enter
something like *lookfor color* at the command line.

<u>Plot-related commands</u> \
  \
 

  --------- ----------------------------------------------------------------
  axis      Sets limits on the axes of a selected plot
  contour   Generates a contour plot of a matrix such as an efficiency map
  grid      Toggles grid lines on a selected plot
  hold      Allows plots to be overlaid
  plot      X-Y plot
  subplot   Allows multiple plots in the same figure window
  title     Puts a title on the selected plot
  xlabel    Labels the selected x-axis
  ylabel    Labels the selected y-axis
  zoom      Toggles zoom in/out capability for selected plot 
  --------- ----------------------------------------------------------------

<u>Other commands</u> \
  \
 

  ------- ----------------------------------------------
  find    Find instances of some condition in a vector
  sum     Sum up all elements of a vector
  trapz   Integrate one vector with respect to another
  ------- ----------------------------------------------

<a name="Appendix D"></a>D. Conventions for *Goto* tag used inside the ADVISOR 2.0 Simulink Block Diagrams
----------------------------------------------------------------------------------------------------------

‘Goto’ and ‘From’ blocks should only be used to pass ‘control’ commands
or ‘sensor’ information, and should not be used to transmit torque,
speed, or power from one drivetrain component to another.

<a name="Appendix E"></a>E. [Glossary](glossary.html)
----------------------------------------------------

* * * * *

<center>
<p>
[Back to Chapter 3](advisor_ch3.html) \
[ADVISOR Documentation Contents](advisor_doc.html)

</center>
<p>
Last Revised: 11-July-2001: mpo
