% Version 3
% 
% 

# Change Log

## ADVISOR-2003-00-r0110 (posted 2013-04-24)

This release of ADVISOR contains the following fixes and enhancements:

* Updated README.txt file for current release and help information
* Changed documentation base format from HTML to Markdown
* Multiple documentation fixes for errors
* Fixed loading of driving cycles AQMD RTC2 cycle, NYGTC
* Added missing files from NREL: jpeg files and simulink new-style
  block diagrams
* Switch documentation to markdown format
* Added "get_adv_path" function to simplify m-file code working with
  cross-platform relative path

## ADVISOR-2003-00-r0080 (posted 2012-06-29)

This is a bug-fix release of the ADVISOR software 2003. With this release,
the ADVISOR software is now able to run on the Mac OS X platform. It
should also run on Linux (if you have Matlab/Simulink installed) but this
has not been tested. Any ability to test on Linux will be appreciated.
This release also begins to fix some of the warnings and errors due to
changes in the MATLAB and Simulink API.

## ADVISOR-2003-00-r0000 (posted 2012-01-03)

This is the original release provided to Big Ladder by NREL for
distribution as open-source software. This distribution of ADVISOR will
form the base case for any regression testing.

## Version 2002 [April 30, 2002 Release]

-   Configurable subsystems now used in Simulink models [[click for
    documentation](configurable_subsystems.html)]
-   Delta-SOC correction based on ratio of change in stored battery
    energy to total fuel energy used[[click for
    documentation](glossary.html#SOC_energy_correction)] 
-   Ultracapacitor model with Maxwell data [[click for
    documentation](ess_uc.html)]
-   Rolling resistance model provided by Michelin [[click for
    documentation](J2452_RR.html)]
-   Fuzzy logic from Ohio State University (updated to include
    simultaneous emissions and fuel use control) [[click for
    documentation](fuzzyemis.html)]
-   Co-simulation link with Saber for a more detailed electrical
    analysis option [[click for documentation](Saber_cosim_help.html)]
-   Direct link with Ansoft SIMPLORER^®^ for electrical system
    co-simulation [[click for documentation](Simplorer_cosim_help.html)]
-   Files added to allow Sinda/Fluint co-simulation with ADVISOR for
    transient air conditioning system analysis [[click for
    documentation](sinda_cosim.html)]
-   Executable for running ADVISOR analyses from outside of MATLAB
    [[click for documentation](advisor_ch2.html#2.3.1)]
-   New command line tool for doing engine map modifications, plotting,
    and studies [[click for documentation](eng_map.html)]
-   Speed-dependent auxiliary loads and other configurable auxiliary
    load models implemented using configurable subsystems [[click for
    documentation](accessory_models2002.html)]
-   New functionality added to adv\_no\_gui.m to allow autosizing
    [[click for documentation](advisor_ch2.html#2.3)]
-   A batch auto-update function to assist users in transitioning from
    previous versions of ADVISOR to ADVISOR 2002 [[click for
    documentation](update_notes.html)]
-   Engine scaling by bore and stroke is now available [[click for
    documentation](bore_stroke_scaling.html)]
-   Heavy vehicle tire information added to the wheel/axle model in
    ADVISOR [[click for documentation](hvy_veh_tires.html)]
-   Heavy vehicle engine emission models using Neural Networks are
    available [[click for documentation](nn_eng_emis_model.html)]
-   New heavy duty components have been added (see table below for a
    complete listing)
-   Ability to customize the ADVISOR menus for multiple users or
    projects [[click for documentation](custom_menus.html)]
-   GUI files have been converted to \*.fig format to allow easier
    customization

 

<table border="1" cellpadding="0" width="100%" style="width:100.0%;mso-cellspacing:
 1.5pt;mso-padding-alt:0in 0in 0in 0in" cols="3">
<tr>
<td colspan="3" style="border:none;padding:.75pt .75pt .75pt .75pt">
New Component, Drive Cycle, and Vehicle Files Added to ADVISOR Version
2002

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
**File Name<o:p></o:p>**

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
**Location<o:p></o:p>**

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
**Description<o:p></o:p>**

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
ACC\_SAEJ1343\_line

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Accessory duty cycle for a tractor trailer under typical line haul/long
haul conditions (based on SAE J1343 specification). Line haul/Long haul
is taken to represent trucks that travel \>500 miles from home base per
trip. (definition taken from VIUS–Vehicle Inventroy and Use Survey 1997)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
ACC\_SAEJ1343\_local

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Accessory duty cycle for a tractor trailer under typical local haul
(based on SAE J1343 specification). Local is assumed to mean trips
within 50 miles of home base (VIUS).

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
ACC\_SAEJ1343\_short

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Accessory duty cycle for a tractor trailer under typical short haul
conditions (based on SAE J1343 specification). Short haul is taken to
mean trucks that travel from 50 to 100 miles from their home base per
trip. (VIUS)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
ACC\_Sinda\_default

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Default accessory load file to call up the configurable subsystem to use
with Sinda/Fluint transient air-conditioning model. Requires
Sinda/Fluint to run.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_abc

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
air brake compressor file for speed dependent auxiliary loads for a
Class 8 Truck. This file initializes a simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_ac

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
air condition file for speed dependent auxiliary loads for a Class 8
Truck. This file initializes a simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_alt

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
alternator file for speed dependent auxiliary loads for a Class 8 Truck.
This file initializes a simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_ef

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
engine fan file for speed dependent auxiliary loads for a Class 8 Truck.
This file initializes a simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_op

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
oil pump file for speed dependent auxiliary loads for a Class 8 Truck.
This file initializes a simulink block. Note: it is assumed that oil
pump operation is boiled into the original engine map. Therefore, if the
oil pump is “turned off” this file subtracts the estimated effect the
oil pump had on the engine.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_ps

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
power steering file for speed dependent auxiliary loads for a Class 8
Truck. This file initializes a simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
c8truck\_wp

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
water/coolant pump file for speed dependent auxiliary loads for a Class
8 Truck. This file initializes a simulink block. Note: it is assumed
that the water/coolant pump operation is boiled into the original engine
map. Therefore, if the water/coolant pump is “turned off” this file
subtracts the estimated effect the water/coolant pump had on the engine.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_abc

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null air brake compressor file (i.e., no load). This file initializes a
simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_ac

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null air condition file (i.e., no load). This file initializes a
simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_alt

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null alternator file (i.e., no load). This file initializes a simulink
block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_ef

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null engine fan file (i.e., no load). This file initializes a simulink
block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_op

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null oil pump file (i.e., no load). This file initializes a simulink
block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_ps

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null power steering file (i.e., no load). This file initializes a
simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
null\_wp

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/accessory/etc

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Null water/cooling pump file (i.e., no load). This file initializes a
simulink block

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
CYC\_NYGTC

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/drive\_cycle

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
New York Garbage Truck Cycle

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
CYC\_const\_65

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/drive\_cycle

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
A constant 65 mph drive cycle. Vehicle will automatically be put in gear
to start at 65 mph.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI324

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
324 kW compression ignition engine (15 Liter)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI321

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
321 kW compression ignition engine (12 Liter)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI250

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
250 kW compression ignition engine (10 Liter)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI205cat3126\_emis

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
205 kW CI engine map based on testing of the Caterpillar 3126 engine.
Includes emissions

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI162\_emis\_ft\_poly

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
162 kW CI engine map based on testing done on the Navistar T444 engine
by Battelle for the DECSE program. Fuel is Fischer Tropsch.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI163\_emis\_d2\_poly

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
163 kW CI engine map based on testing done on the Navistar T444 engine
by Battelle for the DECSE program. Fuel is no. 2 diesel.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_CI92\_emis

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
92 kW 2.2L CIDI Mercedes engine data collected by SwRI

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
FC\_ANL50H2\_p

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/fuel\_converter

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
50 kW(net) pressurized hydrogen fuel cell system based on GCTool
modeling results for use with polarization curve based fuel cell model

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
ESS\_UC2\_Maxwell

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/energy\_storage

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Maxwell ultracapacitor data

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
VEH\_ralphs\_grocery

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/vehicle

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Chassis based on a Sterling AT9513 (1999) from Ralphs Grocery EC-Diesel
Truck Fleet (see a related report
[here](http://www.ctts.nrel.gov/heavy_vehicle/diesel_pub.html#ecdiesel))

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
grocery\_delivery\_truck\_in

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/saved\_vehicles

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Based on Ralphs Grocery Trucks from EC-Diesel testing. A Sterling AT9513
with DDC s60 engine hauling a trailer with cargo.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
WH\_TractorTrailer\_lowRR\_SS

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/wheel

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Tractor Trailer with low rolling resistance tires plus super singles
(i.e., a wide wheel that replaces two conventional wheels)

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
WH\_TractorTrailer\_lowRR

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/wheel

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Tractor Trailer with lower rolling resistance conventional wheels

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
WH\_TractorTrailer\_midRR

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/wheel

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Tractor Trailer with mid-range rolling resistance conventional wheels

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
WH\_TractorTrailer\_highRR

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/data/wheel

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Tractor Trailer with higher rolling resistance conventional wheels

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
AnnexVII\_CONV\_in

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/saved\_vehicles

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
Conventional distribution truck from Annex VII (Hybrid Vehicles) Topic
13 on the assessment of the energy consumption of hybrid trucks using
ADVISOR. Includes files veh\_AnnexVII\_HD\_conv and TX\_AnnexVII\_conv.
Files contributed by [TNO Automotive](http://www.automotive.tno.nl).

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
AnnexVII\_PHEV\_in

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/saved\_vehicles

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
A Parallel hybrid distribution truck from the TNO IEA Annex VII study
mentioned above. Files include: veh\_AnnexVII\_HD\_conv,
TX\_AnnexVII\_conv, PTC\_PHEV\_mv, ESS\_AnnexVII\_SHEV\_NIMH28, and
MC\_AnnexVII\_SerHyb.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
AnnexVII\_PHEV\_SA\_in

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/saved\_vehicles

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
A Parallel starter-alternator distribution truck from the TNO IEA Annex
VII study mentioned above. Files include: veh\_AnnexVII\_HD\_conv,
TX\_AnnexVII\_conv, PTC\_PHEV\_mv, ESS\_AnnexVII\_SHEV\_NIMH28, and
MC\_AnnexVII\_SerHyb.

</td>
</tr>
<tr>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
AnnexVII\_SHEV\_in

</td>
<td width="25%" style="width:25.0%;padding:.75pt .75pt .75pt .75pt">
\<ADV\>/saved\_vehicles

</td>
<td width="50%" style="width:50.0%;padding:.75pt .75pt .75pt .75pt">
A Series hybrid distribution truck from the TNO IEA Annex VII study
mentioned above. Files include: veh\_AnnexVII\_HD\_conv,
TX\_AnnexVII\_SerHyb, PTC\_shev\_mv, ESS\_AnnexVII\_SHEV\_NIMH28,
ACC\_AnnexVII\_serHyb, MC\_AnnexVII\_SerHyb, and gc\_AnnexVII\_serHyb.

</td>
</tr>
</table>
 

<center>
Version 3.2 [release 20 August 2001]
------------------------------------

</center>
-   New functionality to specify vehicle cargo mass versus distance
    [[click for documentation](cargo_mass_vs_distance.html)]
-   New transmission gearbox model (manual and automatic) using lookup
    table for efficiency [[click for
    documentation](gearbox_loss_model_3_2.html)]
-   Trace miss analysis calculation from the “Results” screen when
    vehicle fails to meet drive trace [[click for
    documentation](advisor_ch2.html#trace_miss_analysis)]
-   Templates for linking optimization tools to MATLAB and ADVISOR
    [[click for documentation](optimization_scripts.html)]
-   User definable mass and battery resistance scaling relationships
    [[click for documentation](scaling_relationships.html)]
-   Vehicle-speed dependant shift control [[click for
    documentation](spd_dep_shifting.html)]
-   New time dependent auxiliary load specification [[click for
    documentation](aux_loads_help.html)]
-   Auto-update feature improved–more documentation now available [[see
    here for details](update_notes.html)]
-   A fuzzy logic strategy for parallel hybrid electric vehicles is now
    available to the user.[[click for documentation](fuzzy_logic.html)]
-   PNGV Pulse Power Plot for energy storage systems. [[click for
    documentation](pulse_pwr_plot_help.html)]
-   New RC battery model and datafiles based on testing at NREL. [[click
    for documentation](ess_rc.html)]
-   New emissions control device models based on testing at ORNL.
    [[click for documentation](emis_ornl.html)]
-   A new Honda Insight parallel hybrid electric vehicle control
    strategy is modeled using test data and data from published
    sources.[[click for documentation](honda_insight.html)]
-   Vehicle Solar Load Estimator (VSOLE) subprogram provided to
    calculate solar load in vehicle based on glazings selected.  This is
    no longer available through ADVISOR.  Please visit
    [www.ctts.nrel.gov/programs.html](http://www.nrel.gov/programs.html)
    and the vehicle auxiliary loads reduction team.
-   Image to Map functionality added to be able to take an image, click
    on curves and save them to a \*.m file.  This is accessible through
    the component edit lists by pushing the buttons labeled with the
    component name.

<center>
<table border cols="2" width="100%">
<caption>
New Component, Drive Cycle, and Vehicle Files Added to ADVISOR Version
3.2

</caption>
<tr align="CENTER" valign="CENTER">
<td>
**File Name**

</td>
<td>
**Description**

</td>
</tr>
<tr>
<td>
TX\_ZF5HP590AT

</td>
<td>
A preliminary heavy-duty 5-speed automatic transmission. Gear ratios
based upon ZF 5HP590

</td>
</tr>
<tr>
<td>
MC\_AC187

</td>
<td>
A 187 kW AC motor representative of motors used in series hybrid transit
buses

</td>
</tr>
<tr>
<td>
TX\_1SPD\_BUS

</td>
<td>
A single-speed gearbox especially for series hybrid transit bus
applications

</td>
</tr>
<tr>
<td>
TX\_AUTO4\_IDEAL

</td>
<td>
A 4-speed automatic with 100% efficient gearbox–only losses are due to
hydraulic torque converter

</td>
</tr>
<tr>
<td>
PTC\_CONVAT5spd

</td>
<td>
Powertrain Control for 5-speed (intended for use with TX\_ZF5HP590AT)

</td>
</tr>
<tr>
<td>
CYC\_UKBUS\_MASS\_VAR1

</td>
<td>
A drive cycle typical of a London bus journey. This file contains
variable cargo mass (passenger mass changes as patrons enter and exit
the bus). Special thanks to Newbus Technology Limited, UK for providing
this file.

</td>
</tr>
<tr>
<td>
TransitBus\_conv\_auto\_in

</td>
<td>
A vehicle file for a recent (\~year 2000) model transit bus with
automatic transmission. This transit bus is operating under severe
auxiliary loading–i.e., A/C on full. Simulated mass corresponds to 1/2
Seated Load Weight (i.e., weight of half the possible seated passengers
is added to vehicle model assuming 68 kg a head). A value of 14 kW
(mechanical) is assumed for A/C loading. Compare this file with the
hybrid bus file both with and without A/C loading.

</td>
</tr>
<tr>
<td>
TransitBus\_conv\_CNG\_auto\_in

</td>
<td>
Similar to *TransitBus\_conv\_auto\_in* but corresponding to a CNG
powered bus.

</td>
</tr>
<tr>
<td>
TransitBus\_ser\_highAux\_in

</td>
<td>
This transit bus model is similar to *TransitBus\_conv\_auto\_in* but
incorporates those changes necessary for hybridization. This model is
similarly setup by default to be under heavy auxiliary loading (A/C on)
and 1/2 Seated Load Weight. A value of 14 kW of mechanical auxiliary
loading is assumed for the A/C’s contribution. This model incorporates
new components and a more informed setup than TransitBus\_hybrid\_in
(from ADVISOR v. 3.1–kept for legacy purposes). The user may be
interested to compare this vehicle setup with
*TransitBus\_conv\_auto\_in*–both with and without A/C auxiliary
loading.

For comparison, actual bus fuel economy information can be obtained
from:

-   “Hybrid-Electric Drive Heavy-Duty Vehicle Testing Project: Final
    Emissions Report”, NAVC, 15 Feb 2000 available
    [here](http://www.navc.org)
-   NREL Bus Emissions Database Queries available
    [here](http://www.ctts.nrel.gov/heavy_vehicle/emissions.html)

</td>
</tr>
<tr>
<td>
TransitBus\_ser\_cng\_in

</td>
<td>
Similar to *TransitBus\_ser\_highAux\_in* but using a CNG powered
engine.

</td>
</tr>
<tr>
<td>
CYC\_INDIA\_URBAN\_SAMPLE

</td>
<td>
A sample (unofficial) Indian Urban driving cycle, taken on 12-March-2000
for 2689 seconds. This cycle is characterised by frequent starts and
stops, with lower top speeds.

</td>
</tr>
<tr>
<td>
CYC\_INDIA\_HWY\_SAMPLE

</td>
<td>
A sample (unofficial) Indian highway driving cycle, taken on
12-March-2000 for 881 seconds. This cycle is characterised by moderate
transients, with lower top speeds.

</td>
</tr>
<tr>
<td>
ACC\_CONV\_BUS

</td>
<td>
Defines what is thought to be a typical load for a transit bus (note: a
breakdown of loads as well as values for A/C on are given in the file)

</td>
</tr>
<tr>
<td>
ACC\_SER\_HYBRID\_BUS

</td>
<td>
Defines what is thought to be a typical load for a series hybrid transit
bus (note: a breakdown of loads as well as values for A/C on are given
in the file)

</td>
</tr>
<tr>
<td>
CYC\_CLEVELAND

</td>
<td>
First four laps of formula electric race at Cleveland Burke Lakefront
Airport in 1997.

</td>
</tr>
<tr>
<td>
CYC\_COAST

</td>
<td>
Coastdown from 35 mph (effectively the transmission is forced into
“neutral” by setting gb\_shift\_delay to a large time)

</td>
</tr>
<tr>
<td>
CYC\_1015\_6PRIUS

</td>
<td>
ANL dyno test data on Prius for Japanese 10-15 driving cycle.

</td>
</tr>
<tr>
<td>
VEH\_CYCLE

</td>
<td>
Defines a motorcycle

</td>
</tr>
<tr>
<td>
VEH\_FOCUS

</td>
<td>
Based on the Ford Focus EV

</td>
</tr>
<tr>
<td>
VEH\_SUBURBAN\_RWD

</td>
<td>
2000 Chevy Suburban for Future Truck 2000

</td>
</tr>
<tr>
<td>
ESS\_PB65\_FocusEV

</td>
<td>
Draft energy storage based on the Optima Spiralwound VRLA prototype
battery D750S

</td>
</tr>
<tr>
<td>
MC\_AC150\_Focus\_draft

</td>
<td>
Based on spec sheet for AC-150 motor/controller

</td>
</tr>
<tr>
<td>
MC\_PM15\_LYNX

</td>
<td>
Lynx Motion 15-kW cont/45-kw peak permanent magnet motor/controller

</td>
</tr>
<tr>
<td>
TX\_1SPD\_FOCUS

</td>
<td>
1-speed gearbox for use with Ford Focus EV model

</td>
</tr>
<tr>
<td>
GC\_PM63

</td>
<td>
Mannesmann Sachs 63 kW permanent magnet generator/controller

</td>
</tr>
<tr>
<td>
WH\_CYCLE

</td>
<td>
Wheel definition for motorcycle

</td>
</tr>
<tr>
<td>
WH\_FOCUS\_REGEN

</td>
<td>
Wheel/axle assembly for Ford Focus

</td>
</tr>
<tr>
<td>
ACC\_EV\_FOCUS

</td>
<td>
Assumed accessory load on EV Ford Focus

</td>
</tr>
<tr>
<td>
TX\_AUTO4\_4L60E

</td>
<td>
Model of GM 4L60E Automatic Transmission + Final Drive

</td>
</tr>
<tr>
<td>
conv\_27mpg\_in

</td>
<td>
Baseline conventional vehicle that achieves \~27 mpg on the city/highway
test

</td>
</tr>
<tr>
<td>
para\_80mpg\_in

</td>
<td>
Baseline parallel hybrid vehicle that achieves \~80 mpg on the
city/highway test

</td>
</tr>
<tr>
<td>
Focus\_in

</td>
<td>
Electric Ford Focus vehicle model submitted by Brian Andonian
(bandoman@umich.edu)

</td>
</tr>
</table>
</center>

* * * * *

[Return to ADVISOR Documentation](advisor_doc.html)

* * * * *

Created: [23-April-2002] kh\
 Modified: [16-January-2003] ss
