% Engine Map Class Documentation
% 
% 

ENG\_MAP An Engine Map class.
=============================

Overview
--------

The eng\_map class is a class for doing convenient pre- and
post-processing of ADVISOR style engine maps (i.e., lookup tables). The
eng\_map class is used from the MATLAB command line. Detailed help can
be obtained by typing:

help eng\_map % for help on eng\_map

help eng\_map\\method\_name % for help on a specific method name. e.g.,
help eng\_map\\plot

methods eng\_map % lists all of the available methods for the eng\_map
class

All of the eng\_map class is available to the user (open source) in the
@eng\_map directory in \<ADVISOR root directory\>\\gui\\@eng\_map. For
more information on matlab classes, please consult the MATLAB
documentation. Listed below are various constructors for the eng\_map
class demonstrating how you might instantiate an eng\_map object.

### Constructor 1:

<dl>
<dd>
em = ENG\_MAP(shaft\_speed,… % [rad/s]

</dd>
<dd>
<dl>
<dd>
shaft\_brake\_trq,… % [Nm]

</dd>
<dd>
Brake\_Specific\_Fuel\_Consumption\_matrix ,… % [g/kWh] indexed
vertically by speed, and horizontally by trq

</dd>
<dd>
fuel\_LHV,… % [J/g], lower heating value of the fuel

</dd>
<dd>
max\_trq); %[Nm], the maximum torque corresponding to the shaft\_speed
vector

</dd>
</dl>
</dd>
</dl>
creates an eng\_map object

### Constructor 2:

<dl>
<dd>
em = ENG\_MAP(’fuel\_consumption’,…% dummy flag to indicate fuel
consumption will be given instead of BSFC

</dd>
<dd>
<dl>
<dd>
shaft\_speed,… % [rad/s]

</dd>
<dd>
shaft\_brake\_trq,… % [Nm]

</dd>
<dd>
Fuel\_Consumption\_matrix ,… % [g/s] indexed vertically by speed, and
horizontally by trq

</dd>
<dd>
fuel\_LHV,… % [J/g], lower heating value of the fuel

</dd>
<dd>
max\_trq); %[Nm], the maximum torque corresponding to the shaft\_speed
vector

</dl>
</dd>
</dl>
### Constructor 3:

<dl>
<dd>
em = ENG\_MAP(’fc\_file\_name’) % the fc\_file\_name is the name of an
ADVISOR fc file

</dd>
</dl>
### Constructor 4:

<dl>
<dd>
em = ENG\_MAP(em\_object) % creates a new eng\_map object from an
existing one

</dd>
</dl>
creates an eng\_map object

### Constructor 5:

<dl>
<dd>
em = ENG\_MAP(’dummyFlagOne’,…% dummy flag to indicate fuel consumption
will be given instead of BSFC

</dd>
<dd>
<dl>
<dd>
‘dummyFlagTwo’,…

</dd>
<dd>
shaft\_speed,… % [rad/s]

</dd>
<dd>
shaft\_brake\_trq,… % [Nm]

</dd>
<dd>
eff\_matrix ,… % [–,decimal between 0 and 1] indexed vertically by
speed, and horizontally by trq

</dd>
<dd>
fuel\_LHV,… % [J/g], lower heating value of the fuel

</dd>
<dd>
max\_trq); %[Nm], the maximum torque corresponding to the shaft\_speed
vector

</dd>
</dl>
</dd>
</dl>
#### METHODS AVAILABLE FOR THIS CLASS: 

(type methods eng\_map for the most up-to-date listing)

-   buildNewMap
-   set
-   get
-   display
-   plot
-   interp
-   saveToFile
-   diffMap
-   bsfc2eff
-   eff2bsfc
-   bsfc2fc
-   fc2bsfc
-   scaleTrq
-   scaleSpd
-   webHelp (brings you to this page)

Example: Creating a New Engine from BSFC Information at Max. Torque
-------------------------------------------------------------------

Engine OEM’s will often make available performance data that contains
such information as maximum torque curves for their engine model by
shaft speed. If one is lucky, the brake-specific fuel consumption (or
fuel rate) will also be given along this maximum curve. However, rarely
is the entire efficiency map provided.

One quick and dirty way to make an engine efficiency map using only this
limited information is to use the eng\_map class. The eng\_map class has
a method called buildNewMap that is a scaling function.
eng\_map.buildNewMap uses an existing engine map and scales efficiency
at constant shaft speeds to match that of the efficiency at max torque
provided by the user. Let’s take an example.

Let’s say a user has the following information available along the max
torque curve for an engine and let us assume the fuel lower heating
value is 43 MJ/kg:

<div align="center">
<center>
  Engine Speed (rad/s [rpm])   Engine Max. Torque (Nm)   BSFC (g/kWh)
  ---------------------------- ------------------------- --------------
  125.7 [1200]                 1690                      196
  146.6 [1400]                 1650                      195
  167.6 [1600]                 1540                      196
  188.5 [1800]                 1380                      197
  209.4 [2000]                 1220                      199

  : Engine Data

</center>
</div>
Let’s use the FC\_CI330.m file in ADVISOR as the base engine to work off
of with the above data. To make an eng\_map class based off of the
FC\_CI330.m file, we need only call constructor 3:

\> em205=eng\_map(’FC\_CI205’)

Now that we have this map, let’s plot it to look at it:

\> plot(em205)

You should now see a custom drawn efficiency map figure. Now let’s scale
the 205 kW map to fit our information at max. torque. We’ll specify our
new map to have torque evaluated every 50 Nm from 50 up to 1700 Nm. Fuel
lower heating value will be taken as 43000 J/g:

\> emNew=buildNewMap(em205, [125.7, 146.6, 167.6, 188.5, 209.4],
[50:50:1700], [196, 195, 196, 197, 199], …\
    [1690, 1650, 1540, 1380, 1220], 43000);

We can now plot our new map:

\> plot(emNew)

If we like our results, we can save them to an m-file and begin creating
an ADVISOR engine m-file:

\> saveToFile(emNew, ‘fc\_testEngine.m’)

Remember, if you ever need help, just type

‘help eng\_map\\{method name}’ or ‘methods eng\_map’

Let’s compare how our scaling algorithm did versus just scaling the 205
kW engine by Torque:

\> em205a=scaleTrq(em205,1700/1200) % scale the torque values of the
engine

\> em205a=set(em205a, ‘maxTorque’,get(em205a, ‘maxTorque’).\*1700/1200)
% scale the max torque curve of the 205 kW engine

\> plot(diffMap(emNew, em205a)) % plot the difference between the two
engines

* * * * *

<center>
<p>
[Return to ADVISOR Documentation](advisor_doc.html)

</center>

* * * * *

<center>
<p>
Last revised: [01-April-2002] mpo \
Created: [01-April-2002] mpo

</center>
