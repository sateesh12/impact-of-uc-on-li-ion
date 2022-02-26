% J1711 Test Procedure
% 
% 

<center>
**<font size="+2">SAE J1711 Test Procedure</font>**

* * * * *

</center>
<p>
**<font size="+1">Setup, Classification, and Test Procedure
Description</font>** \
The J1711 Test Procedure runs through a maximum of four types of tests,
based on the type of hybrid vehicle.  The four tests are:

> 1.  Partial Charge Test – Hybrid Electric Vehicle (PCT-HEV)
> 2.  Full Charge Test - Hybrid Electric Vehicle (FCT-HEV)
> 3.  Partial Charge Test – Conventional Vehicle (PCT-CV)
> 4.  Full Charge Test - Electric Vehicle (FCT-EV)

The first test, PCT-HEV, is always run.  The FCT-HEV test is only run if
the vehicle is Off Vehicle Charge (OVC) capable.  The PCT-CV test is
only run if the vehicle has a “conventional only” mode.  The FCT-EV test
is only run if the vehicle is both OVC capable, and has a “electric
only” mode.  The available vehicle options are specified by the user in
the J1711 setup screen, as shown below.  The air conditioning load is an
additional constant load added for only one of the drive cycles (SC03).

<center>
<p>
![](j17setup.jpg)

</center>
<p>
For each test, four cycles are run.  They are:

> 1.  UDDS – Urban Dynamometer Driving Schedule
> 2.  HWFET – Highway Fuel Economy Test
> 3.  US06 – US06 driving cycle (high speed operation, demanding
>     accelerations)
> 4.  SC03 – SC03 driving cycle (additional air condition load, if
>     present, used here)

If the “Iterate to find initial SOC” box was checked, the initial SOC
will be adjusted until the ending SOC falls within a tolerance of +-.5%.

<p>
**<font size="+1">Weighting and Results</font>** \
The J1711 results screen is shown below:

<center>
<p>
![](j17results.gif)

</center>
If certain tests were not run, the corresponding buttons will be
disabled.  The large buttons, when clicked, will display the fuel
economy and emissions for the various cycles in the yellow box.

**Final** \
The fuel economy in the “Final” section is the standard weighting of the
UDDS and the HWFET final fuel economies.  It is computed using the
following equation: ![](j17mpg.jpg).

The emissions in the “Final” section are based on either 1) a weighting
of the UDDS and US06 final emissions, or 2) a weighting of the UDDS,
US06, and SC03 emissions (if the vehicle has air conditioning).  More
specifically, they are weighted as below:

1.  *emis=0.72\*UDDS\_emis+0.28\*US06\_emis*
2.  *emis=0.35\*UDDS\_emis+0.28\*US06\_emis+0.37\*SC03\_emis*

**Final, Cycle level** \
The fuel economy and emissions for the “Final, Cycle level” section are
averages of the Partial Charge Test and Full Charge Test results, given
that the FCT results exist.

**PCT and FCT** \
The fuel economy and emissions for the PCT and FCT sections are averages
of their respective lower level tests, given that the tests were run.

<p>
**SOC info.** for PCT-HEV gives five values:

> 1.  init: Initial SOC at the beginning of the entire drive cycle.
> 2.  pause: SOC at the midpoint of the schedule.  The PCT-HEV tests run
>     two of the given cycles, one for warmup and the next to measure
>     emissions.  The charge sustaining portion of the entire cycle is
>     taken to be the time from the midpoint to the end of the cycles.
> 3.  end: Final, or ending, SOC.
> 4.  min: Minimum SOC that the “end” SOC can take on, based on “init”
>     for UDDS and “pause” for the rest of the cycles.  The min/max
>     SOC’s are calculated based on the following
>     equation: ![](minmaxSOC.jpg)
> 5.  max: Maximum SOC that the “end” SOC can take on, based on “init”
>     for UDDS and “pause” for the rest of the cycles.

If any of the ending SOC’s are <font color="#FF0000">red</font>, the
test has failed.  For the PCT-HEV test results to be valid, the vehicle
must be charge sustaining, such that the “end” SOC must fall within the
range of the “min” and “max” SOC’s.  For the US06 and SC03 cycle, the
test may still be valid if the SOC is out of the range, provided that
the initial SOC was less that the initial SOC for the UDDS cycle.  This
exception is indicated by the color <font color="#FF6666">pink</font>.

<p>
**Add’l info.** under FCT-EV and FCT-HEV gives three values:

> 1.  kWh chg: kWh to recharge the batteries to full charge after going
>     through the given cycle.
> 2.  ZEV rng: Range in miles that the vehicle ran as a Zero Emissions
>     Vehicle.
> 3.  UF: Utility Factor, a table lookup of the utility of the vehicle
>     (0-.99) as a function of the ZEV range.

**Utility Factors (UF)** \
When vehicle propulsion is no longer possible after driving in EV mode,
it is assumed that the driver will switch to either a CV or an HEV
mode.  Because of this limited utility, FCT-EV, UF results include both
FCT-EV data and PCT data.  The weighting placed on FCT data will equal
the probability that a vehicle (based on national, in-use driving
statistics) will be driven in one day a distance that is equal to or
less than the total distance traveled during the FCT-EV test.  This
probability is what is called the Utility Factor because it indicates
the limited utility of a particular operating mode.  An operating mode
with a very long range, for example, will have a very high utility, and,
thus, a Utility Factor that approaches 1.0.

<center>
<p>
![](j17_uf.jpg)

</center>

* * * * *

<center>
[Return to Chapter 3](advisor_ch3.html#3.3)

</center>
Last Revised: 7/21/00:AB
