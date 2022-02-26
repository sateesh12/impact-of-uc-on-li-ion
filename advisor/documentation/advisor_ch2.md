% advisor\_ch2
% 
% 

<center>
<a name="2.0"></a>2.0 Using ADVISOR
===================================

</center>

* * * * *

\
  

[2.1 Using the GUI (demo)](#2.0)

<dir>
[2.1.1 Defining a vehicle](#2.1.1) \
 [2.1.2 Running a simulation](#2.1.2) \
 [2.1.3 Looking at outputs](#2.1.3)

</dir>
[2.2 Converting old component files to the current version of
ADVISOR](#2.2)

[2.3 Running ADVISOR without the GUI](#2.3) \
 [2.4 Helper Classes and Functions](#helper)\

* * * * *

This section should get you started using ADVISOR both by using the GUI
and by entering simple commands at the Matlab command line.

<a name="2.1"></a> 2.1 Using the GUI
------------------------------------

The ADVISOR GUI can be started using one of the two following methods.

<u>Method 1</u>

-   Start MATLAB 5.3 (or higher) and using the ‘path browser’, remove
    any previous ADVISOR paths.  Then change the current (active)
    directory to be the top-level ADVISOR directory (the folder
    containing the extracted files).
-   To run ADVISOR, type “advisor” at the command prompt in MATLAB. 
    This will update the MATLAB path for the current MATLAB session and
    start running ADVISOR.  If the directories needed for ADVISOR have
    not been saved to the path for future sessions, a window will popup
    and ask if you want to save the path for future sessions.  It may be
    necessary to save the path for other programs to have access to
    ADVISOR.

NOTE: MATLAB runs files from the current working directory first, then
the directories in the path from top to bottom.  This may cause problems
if you have two files named the same thing in different directories. 
Therefore, make sure you delete the paths for the older versions of
ADVISOR. \
  

<u>Method 2</u>  Creating ADVISOR shortcut icon to launch ADVISOR and 
MATLAB

-   In the GUI directory, find the ADVISOR shortcut icon to launch
    ADVISOR and MATLAB.
-   Right click on the file and choose ‘properties’.
-   Click on the shortcut tab.
-   Do a search for the MATLAB executable file.  Under ‘Target’ modify
    it to point to your MATLAB.EXE file, followed by -r advisor.
-   Under ‘Start in’ enter in the main ADVISOR directory.
-   Hit the ‘change icon’ button, then hit browse and find the
    ADVISOR.bmp file, not the shortcut file, in the GUI directory.
-   Enter Ok, and double-click on the icon to launch ADVISOR.

\
 The first figure is the startup figure. Here you will have the options
to select ***US*** or ***metric*** units, ***start*** using ADVISOR,
click ***help***to go to a local ADVISOR web page, ***exit*** ADVISOR or
read the ***copyright and disclaimer***.  

**MENU PROFILES:**  From the startup figure you can also select a menu
profile from the pull down menu above the ***start*** button.  This
profile list contains the names of \*.mat files that define what will be
listed in the component menus in the input figure and what cycles are
listed in the simulation setup figure.  Editing the profile is simply
done by having the profile that you want to edit selected and going
through each ADVISOR figure and deleting or adding to the component
lists using the pushbuttons next to the components.  You may also add,
delete or create new profiles by selecting ‘edit list’ from the pull
down menu on the startup figure.  See also [custom
menus](custom_menus.html).

NOTE: Throughout the GUI there are ***help*** buttons which will either
access the Matlab help window or open a web page with appropriate
context information.

### <a name="2.1.1"></a>2.1.1 Defining a vehicle

***Start***takes you to the input figure. The input figure opens and you
will see the default values for a specific vehicle.

<u>Drivetrain selection</u> \
 From the drivetrain popup menu you will be able to select the
drivetrain configuration of the vehicle (**Series, Parallel**, etc.)
which will cause the schematic of the vehicle configuration in the left
portion of the figure to change accordingly. This will also modify which
components are available for the type of drivetrain chosen.

<a name="Select_comp"></a><u>Selecting components</u> \
 After selecting the drivetrain configuration, all the components of the
vehicle can be selected using the popup menus, or by clicking on the
component in the picture. To the left of the component popup menus is a
pushbutton that will allow you to add or delete components by selecting
their corresponding listed m-files. The m-file of a specific component
can be accessed for viewing or modifying from either the component
pushbutton or by clicking on the component of the picture.

<u>Editing Variables</u> \
 After selecting all the desired components for the vehicle, scalar
input variables can be modified.  One way this can be done is with the
variable list at the bottom of the figure and the Edit Var. button.
First select the variable to change and then click the edit button to
change its value. The default value is always shown for your reference. 
The View All button allows you to see all of the variables you have
altered.  You can click on the help button to see a brief description
and the units used for the input variables.

A second way in which you can edit variables is by typing in a desired
value in the edit boxes next to the component.  For example, adjusting
the maximum power of a fuel converter adjusts the variable
fc\_trq\_scale, or increasing the peak efficiency increases the variable
fc\_eff\_scale accordingly.

A final way to edit the mass of the vehicle is to use the override mass
button.  The calculated mass is ignored and the value input into the box
is used instead.

<u>Loading and Saving vehicle configurations</u> \
 To load or save a particular vehicle configuration click on the Load
Vehicle button on the top of the figure or click on Save at the bottom
of the figure. The file will be saved in the format
’**filename**\_in.m’. A saved vehicle can be accessed by pushing the
load button.

<u>Viewing component information</u> \
 At the bottom left portion of the figure there is a popup menu and axes
with the ability to view information on components such as their
efficiency maps, emissions maps, fuel use maps, etc. These are plotted
along with their maximum torque envelopes where appropriate.

Any component m-file can be viewed by clicking the component buttons.

<u>Auto-Size</u> \
 The auto-size button takes the selected vehicle and adjusts vehicle
parameters until it meets acceleration and gradeability goals.  The
parameters it alters are the fuel converter torque scale
(fc\_trq\_scale), the motor controller torque scale (mc\_trq\_scale),
the number of energy storage system modules, and the vehicle mass.  The
minimum torque scale is set so that its peak power output is 45 kW.  The
number of battery modules is limited to yield a maximum nominal voltage
of 480 V.  The default performance targets are maintaining at least a 6%
grade at 55 mph, and obtaining less than a 12 second 0-60 mph time, 23.4
second 0-85 mph time, and 5.3 second 40-60 mph time.

<u>Back and Continue Buttons</u> \
 The ***Back*** button will take you to the opening screen, losing all
unsaved information, and the ***Continue*** button will take you to the
simulation setup figure.

### <a name="2.1.2"></a>2.1.2 Running a simulation

The simulation setup figure gives you several options on how to test the
currently defined vehicle.

<u>Drive Cycle selection</u> \
 If the drive cycle radio button is selected you can use the pull down
menu to select from a list of available driving cycles. You can then
select how many times you want the cycle repeated as well as if you want
[SOC correction](#SOC_Corr).  Initial conditions can also be set from
here. The filtering allows you to smooth out the selected drive cycle.

<a name="trip_bld"></a><u>Trip Builder</u>

A cycle can be created by combining many different cycles back to back
using this functionality.  This new cycle is then saved in the normal
cycle  format and can be run as such.

<a name="Auxiliary Loads"></a><u>[Auxiliary
Loads](aux_loads_help.html)</u> \
 Selecting this button brings up a graphical interface to select
different auiliary loads and their on/off times as related to the drive
cycle.

<a name="SOC_Corr"></a><u>SOC Correct</u> \
 There are two SOC correct options: linear and zero delta.  The Linear
SOC correction routine runs two simulations—one that gives a positive
change in the state of charge and one that gives a negative change in
SOC.  The corrected value of the variables of interest (e.g. miles per
gallon and emissions) are then interpolated from the zero change in SOC
from a linear fit to the two data points.  The Zero-Delta correction
routine adjusts the initial SOC until the simulation run yields a zero
change in SOC +/- a 0.5% tolerance band.

<u>Constant Road Grade</u> \
 By selecting the checkbox you can run the drive cycle using a constant
road grade in place of the drive cycle’s elevation profile.

<u>Interactive Simulation</u> \
 Selecting the [Interactive
Simulation](realtime_interface.html#Interactive_sim) checkbox causes a
real-time interactive simulation interface to activate while the
simulation is running.

<a name="mult_cyc"></a><u>Multiple Cycles</u>

You can speed up the process of running many different cycles with the
same initial conditions using this functionality.    Multiple Cycles
saves the setup information including initial conditions and then runs
each of the cycles selected and saves the results.  From the results
figure you can access all the different results with the aid of a 
results list.

<u>Test Procedure</u> \
 If the test procedure radio button is selected you can use the pull
down menu to select what kind of test to run.

<u>Acceleration Test</u> \
 By selecting this checkbox, an acceleration test will be run in
addition to the chose cycle.  Acceleration times, maximum accelerations,
and distanced traveled in 5 seconds will be displayed in the results
figure.  This test will be run in addition to the chosen cycle.  To see
the second by second output of an acceleration test, choose the
CYC\_ACCEL from the cycle menu.

<u>Gradeability Test</u> \
 If the gradeability checkbox is selected, a gradeability test will be
run in addition to the chosen cycle.  The grade displayed in the results
figure will be the maximum grade maintainable at the input mph.

<u>Parametric Study</u> \
 To see the effect that up to three variables have on the vehicle,
select a parametric study.  The low and high values may be set, as well
as the number of points desired for that variable.  A parametric study
runs a set of simulations to cover the matrix of input points, such that
if 3 variables are selected with 3 points each, 27 simulations will run.

<u>Load Sim Setup</u> \
 A previously saved simulation setup can be reloaded using the ***Load
Sim. Setup***push button.  See [Save](#Save) below.

<u>Optimize cs vars</u> \
 The ***Optimize cs vars*** push button opens the control strategy
optimization setup window.  Checking the radio boxes selects the design
variables used to optimize for the chosen objectives and constraints
below.

<a name="Save"></a><u>Save</u> \
 Saves the simulation setup.

<u>Run</u> \
 To run the simulation click Run and wait for the results figure to
popup.

### <a name="2.1.3"></a>2.1.3 Looking at outputs

<u>Results Figure</u> \
 The results figure presents some summary results (fuel economy,
emissions, total distance, etc.) and allows the user to plot up to four
time series plots by selecting a variable from the popup menu.  If the
acceleration and gradeability checkboxes were picked in the simulation
setup screen, appropriate results will also be displayed.

By clicking the Energy Use Figure button, a new figure is opened showing
how energy was used and transferred for the vehicle during the
simulation.  The Output Check Plots button pulls up plots that show the
vehicle’s performance, some of which are not available under the time
series plots.  The Replay button replays the dynamic interactive
interface.  Replay is not available for Test Procedures or Multiple
Cycles.

Fuel used over the simulation run  and the operation points of the fuel
converter can be viewed as a function of speed and torque of the fuel
converter by clicking on the ‘tools’ menu and selecting ‘FC operation’.

<u>Parametric Results Figure</u> \
 The parametric results figure plots the summary results as a function
of your chosen variable(s).  For two and three variable studies, the
Rotate button allows you to view the plot from all sides.  For three
variable studies, you can plot any slice of the results.

<a name="trace_miss_analysis"></a><u>Trace Miss Analysis</u> \
 When a simulated vehicle deviates from the requested drive cycle, the
trace\_miss\_analysis class (found in \<ADVISOR
directory\>/gui/@trace\_miss\_analysis) is automatically called into
play. The trace\_miss\_analysis class displays statistical information
on the severity of cycle trace-miss in the “Warnings/Messages” window of
the Results screen.

Information includes:

-   The absolute average difference between the speed requested and
    speed achieved
-   The percent of simulated time with trace miss greater than 2 mph
    (absolute)
-   The greatest percent difference based on the maximum cycle speed
    (i.e.,
    abs(speed\_requested[time=i]-speed\_achieved[time=i])/max(speed\_requested)
-   The greatest percent difference based upon local cycle speed (i.e.,
    abs(speed\_requested[time=i]-speed\_achieved[time=i])/speed\_requested[time=i]
-   The greatest absolute difference

The trace\_miss\_analysis class is accessible for normal use (ADVISOR
start-up **not** required). For details type: help trace\_miss\_analysis
on the command line.

<a name="2.2"></a>2.2  Converting old component files to the current version of ADVISOR
---------------------------------------------------------------------------------------

Updating files from older versions of ADVISOR can now(4/9/99) be done
using the user interface.  First, make sure the file you want to update
is on the matlab path or in the current working directory.  We suggest
you place it in the ADVISOR main directory.  Second, run ADVISOR and go
to the Vehicle Input figure by pressing start.  From there click on the
button of the component that you would like to convert.  There is a
convert button that will ask you for the file name.  Enter the file name
and ok and it will update your file(same name).  If your file is not up
to date and you try to add it to a component list, ADVISOR will prompt
you to convert it. Details and notes on file auto-update can be found
[here](update_notes.html).

<a name="2.3"></a>2.3  Using ADVISOR without the GUI
----------------------------------------------------

The purpose of the ADVISOR GUI is to help guide and assist the user to
use the fundamental data and models that compose ADVISOR. However, at
times it is desirable to automate some of the processes in ADVISOR,
especially when linking to external tools such as optimization packages.
Functionality to run ADVISOR without the GUI has been provided to the
user in an m-function called adv\_no\_gui. This is a function to be
called from the Matlab Command window. It accepts 2 arguments and
returns 2 arguments. To use ADVISOR without the gui you must select the
save path option when you initially start ADVISOR so that Matlab will
always be able to find the ADVISOR files. The function takes the
following form,

[error\_code,resp]=adv\_no\_gui(action,input)

Action is a string that defines the specific action you want ADVISOR to
take. The list of available actions includes the following, \
  

<table border="1" cellpadding="7" width="667">
<tbody>
<tr>
<td valign="top" width="23%">
<center>
**Action**

</center>
</td>
<td valign="top" width="77%">
<center>
**Description**

</center>
</td>
</tr>
<tr>
<td valign="top" width="23%">
initialize

</td>
<td valign="top" width="77%">
Used to prepare the workspace to run simulations. This action must be
initiated prior to executing any other action.

</td>
</tr>
<tr>
<td valign="top" width="23%">
modify

</td>
<td valign="top" width="77%">
Used to change the value of specific parameters. This is like the Edit
Var button functionality. At this time only scalar values can be
modified.

</td>
</tr>
<tr>
<td valign="top" width="23%">
grade\_test

</td>
<td valign="top" width="77%">
Used to run a grade test.

</td>
</tr>
<tr>
<td valign="top" width="23%">
accel\_test

</td>
<td valign="top" width="77%">
Used to run an acceleration test.

</td>
</tr>
<tr>
<td valign="top" width="23%">
drive\_cycle

</td>
<td valign="top" width="77%">
Used to run a drive cycle.

</td>
</tr>
<tr>
<td valign="top" width="23%">
test\_procedure

</td>
<td valign="top" width="77%">
Used to run a test procedure.

</td>
</tr>
<tr>
<td valign="top" width="23%">
other\_info

</td>
<td valign="top" width="77%">
Used to probe the workspace for simulation results or current parameter
settings

</td>
</tr>
<tr>
<td valign="top" width="23%">
save\_vehicle

</td>
<td valign="top" width="77%">
Used to save the current vehicle configuration for future use.

</td>
</tr>
<tr>
<td valign="top" width="23%">
autosize

</td>
<td valign="top" width="77%">
Runs the autosize function (same as on the GUI)

</td>
</tr>
</tbody>
</table>
\
  

</p>
Input is a structure that contains the input parameters to be passed to
ADVISOR while executing the specific actions. Only the data contained in
the field associated with the specified action will be used any other
data will be ignored. The fields of input may include, \
  

<table border="1" cellpadding="7" width="898">
<tbody>
<tr>
<td valign="top" width="14%">
<center>
**Action**

</center>
</td>
<td valign="top" width="14%">
<center>
**Field**

</center>
</td>
<td valign="top" width="16%">
<center>
**Sub-Field**

</center>
</td>
<td valign="top" width="56%">
<center>
**Usage**

</center>
</td>
</tr>
<tr>
<td valign="top" width="14%">
initialize

</td>
<td valign="top" width="14%">
init

</td>
<td valign="top" width="16%">
saved\_veh\_file

</td>
<td valign="top" width="56%">
 This contains a string that specifies a previously saved vehicle. This
is the simplest way to get started using the adv\_no\_gui functionality.

input.init.saved\_veh\_file=’Parallel\_DEFAULTS\_in’

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
comp\_files

</td>
<td valign="top" width="56%">
Contains two fields comp and name. Each field contains a cell array with
the name of the component and the corresponding data file. For example,

input.init.comp\_files.comp={’fuel\_converter’,’energy\_storage’,’transmission’}

input.init.comp\_files.name={’FC\_SI41\_emis’,’ESS\_PB25’,’TX\_5SPD’}.

This functionality is especially useful for performing discrete studies
in which the vehicle configuration is fixed but it is of interest to
evaluate the impact of different component technologies.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
overrides

</td>
<td valign="top" width="56%">
Contains three fields name, value, default. Examples include

input.init.overrides.name={’mc\_trq\_scale’,’fc\_trq\_scale’}

input.init.overrides.value={0.75,1.2}

input.init.overrides.default={1,1}

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
init\_conds\_file

</td>
<td valign="top" width="56%">
The name of the initial conditions file to load. For example, 

input.init.init\_conds\_file=’init\_conds\_hot’ %hot start initial
conditions.

</td>
</tr>
<tr>
<td valign="top" width="14%">
modify

</td>
<td valign="top" width="14%">
modify

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of parameters to be modified. 

input.modify.param={’mc\_trq\_scale’,’fc\_trq\_scale’}

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the new values of parameters specified
in the field name.

input.modify.value={0.75,1.2}

</td>
</tr>
<tr>
<td valign="top" width="14%">
grade\_test

</td>
<td valign="top" width="14%">
grade

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of grade test parameters to be
passed to the grade test function. 

input.grade.param={’speed’,’duration’}

For a list of available parameters see help on the [grade
test](grade_test_help.html).

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the values associated with the grade
test parameters specified in the field name.

input.grade.value={45,300}

</td>
</tr>
<tr>
<td valign="top" width="14%">
accel\_test

</td>
<td valign="top" width="14%">
accel

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of acceleration test
parameters to be passed to the acceleration test function.

input.accel.param={’ess\_init\_soc’,’spds’}

For a list of available parameters see help on the [accel
test](accel_test_help.html).

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the values associated with the
acceleration test parameters specified in the field name.

input.accel.value={0.75,[0 30; 0 60]}

</td>
</tr>
<tr>
<td valign="top" width="14%">
drive\_cycle

</td>
<td valign="top" width="14%">
cycle

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of drive cycle simulation
parameters to be passed to the workspace.

input.cycle.param={’cycle.name’,’cycle.soc’,’cycle.socmenu’,’cycle.SOCiter’}

Available parameters include,

cycle.name - name of the drive cycle (e.g. ‘CYC\_HWFET’,’CYC\_US06’,…)

cycle.soc - run soc correction? (’on’ or ‘off’)

cycle.socmenu - type of soc correction (’linear’ or ‘zerodelta’)

cycle.soc\_tol\_method - constraint on energy balance (’soctol’ or
‘ess2fuel’)

cycle.SOCiter - max iterations during zero delta soc correction

cycle.SOCtol - tolerace during zero delta soc corrections

cycle.number - number of repeat cycles to run

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the values associated with the drive
cycle parameters specified in the field name.

input.cycle.value={’CYC\_UDDS’,’on’,’zerodelta’,15}

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
aux\_load\_file\_name

</td>
<td valign="top" width="56%">
The name of a \*.mat file for use with variable auxiliary loads. Example
files are located in [ADVISOR directory]/data/accessory

</td>
</tr>
<tr>
<td valign="top" width="14%">
test\_procedure

</td>
<td valign="top" width="14%">
procedure

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of test procedure simulation
parameters to be passed to the workspace.

input.procedure.param={’test.name’}

Currently, name is the only available input parameter.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the values associated with the test
procedure parameters specified in the field name.

input.procedure.value={’TEST\_CITY\_HWY’}

Currently the list of options include, 

TEST\_CITY\_HWY 

TEST\_CITY\_HWY\_HYBRID

TEST\_FTP

TEST\_FTP\_HYBRID

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
aux\_load\_file\_name

</td>
<td valign="top" width="56%">
The name of a \*.mat file for use with variable auxiliary loads. Example
files are located in [ADVISOR directory]/data/accessory

</td>
</tr>
<tr>
<td valign="top" width="14%">
other\_info

</td>
<td valign="top" width="14%">
resp

</td>
<td valign="top" width="16%">
param

</td>
<td valign="top" width="56%">
This is a cell array containing the names of parameters of which the
values should be passed back to the calling function.

input.resp.param={’mpg’;’gear\_ratio’;’fc\_brake\_trq’}

These could include any variable defined in the Matlab workspace, input
or output.

</td>
</tr>
<tr>
<td valign="top" width="14%">
save\_vehicle

</td>
<td valign="top" width="14%">
save

</td>
<td valign="top" width="16%">
filename

</td>
<td valign="top" width="56%">
Contains a string identifying the filename in which to save the current
vehicle parameter settings.

</td>
</tr>
<tr>
<td valign="top" width="14%">
autosize

</td>
<td valign="top" width="14%">
autosize

</td>
<td valign="top" width="16%">
autosize

</td>
<td valign="top" width="56%">
INPUT.autosize.autosize is the same as vinf.autosize when autosize is
run in the GUI.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
grade\_test

</td>
<td valign="top" width="56%">
INPUT.autosize.grade\_test is the same as vinf.grade\_test when autosize
is run in the GUI.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
accel\_test

</td>
<td valign="top" width="56%">
INPUT.autosize.accel\_test is the same as vinf.accel\_test when autosize
is run in the GUI.

</td>
</tr>
</tbody>
</table>
\
  

</p>
After execution, the function will return to arguments. The first,
error\_code will be a boolean value identifying whether the action was
completed successfully (error\_code=0) or of there was an error during
execution (error\_code=1). The second, is a structure that contains the
default results of the specified action. \
  

<table border="1" cellpadding="7" width="898">
<tbody>
<tr>
<td valign="top" width="14%">
<center>
**Action**

</center>
</td>
<td valign="top" width="14%">
<center>
**Field**

</center>
</td>
<td valign="top" width="16%">
<center>
**Sub-Field**

</center>
</td>
<td valign="top" width="56%">
<center>
**Usage**

</center>
</td>
</tr>
<tr>
<td valign="top" width="14%">
initialize

</td>
<td valign="top" width="14%">
–

</td>
<td valign="top" width="16%">
–

</td>
<td valign="top" width="56%">
 not used

</td>
</tr>
<tr>
<td valign="top" width="14%">
modify

</td>
<td valign="top" width="14%">
–

</td>
<td valign="top" width="16%">
–

</td>
<td valign="top" width="56%">
 not used

</td>
</tr>
<tr>
<td valign="top" width="14%">
grade\_test

</td>
<td valign="top" width="14%">
grade

</td>
<td valign="top" width="16%">
grade

</td>
<td valign="top" width="56%">
Max grade sustained during the grade test.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
gear

</td>
<td valign="top" width="56%">
Gear ratio in which the grade test was performed.

</td>
</tr>
<tr>
<td valign="top" width="14%">
accel\_test

</td>
<td valign="top" width="14%">
accel

</td>
<td valign="top" width="16%">
times

</td>
<td valign="top" width="56%">
Matrix of acceleration times associated with specified speed ranges.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
dist\_in\_time

</td>
<td valign="top" width="56%">
Distance traveled during specified time.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
time

</td>
<td valign="top" width="56%">
Time to travel specified distance.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
max\_rate

</td>
<td valign="top" width="56%">
Max acceleration rate.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
max\_speed

</td>
<td valign="top" width="56%">
Max speed.

</td>
</tr>
<tr>
<td valign="top" width="14%">
drive\_cycle

</td>
<td valign="top" width="14%">
cycle

</td>
<td valign="top" width="16%">
mpgge

</td>
<td valign="top" width="56%">
Gasoline equivalent fuel economy

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
hc\_gpm

</td>
<td valign="top" width="56%">
g/mi of HC emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
co\_gpm

</td>
<td valign="top" width="56%">
g/mi of CO emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
nox\_gpm

</td>
<td valign="top" width="56%">
g/mi of NOx emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
pm\_gpm

</td>
<td valign="top" width="56%">
g/mi of particulate emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
delta\_trace

</td>
<td valign="top" width="56%">
Maximum difference between the requested and achieved vehicle speed
during the cycle.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
delta\_soc

</td>
<td valign="top" width="56%">
Difference between the initial and final SOC during the drive cycle.

</td>
</tr>
<tr>
<td valign="top" width="14%">
test\_procedure

</td>
<td valign="top" width="14%">
procedure

</td>
<td valign="top" width="16%">
mpgge

</td>
<td valign="top" width="56%">
gasoline equivalent fuel economy

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
hc\_gpm

</td>
<td valign="top" width="56%">
g/mi of HC emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
co\_gpm

</td>
<td valign="top" width="56%">
g/mi of CO emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
nox\_gpm

</td>
<td valign="top" width="56%">
g/mi of NOx emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
pm\_gpm

</td>
<td valign="top" width="56%">
g/mi of particulate emissions

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
delta\_trace

</td>
<td valign="top" width="56%">
Maximum difference between the requested and achieved vehicle speed
during the cycle.

</td>
</tr>
<tr>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="14%">
 

</td>
<td valign="top" width="16%">
delta\_soc

</td>
<td valign="top" width="56%">
Difference between the initial and final SOC during the drive cycle.

</td>
</tr>
<tr>
<td valign="top" width="14%">
other\_info

</td>
<td valign="top" width="14%">
other

</td>
<td valign="top" width="16%">
value

</td>
<td valign="top" width="56%">
This is a cell array containing the values of parameters specified in
the param field.

</td>
</tr>
<tr>
<td valign="top" width="14%">
save\_vehicle

</td>
<td valign="top" width="14%">
–

</td>
<td valign="top" width="16%">
–

</td>
<td valign="top" width="56%">
Not used.

</td>
</tr>
<tr>
<td valign="top" width="14%">
autosize

</td>
<td valign="top" width="14%">
–

</td>
<td valign="top" width="16%">
–

</td>
<td valign="top" width="56%">
Not used.

</td>
</tr>
</tbody>
</table>
\
  

</p>
**<u>Example 1: Evaluation of a single design point</u>**

1.  Start Matlab. (Do not start ADVISOR.)
2.  At the command line type,

<!-- -->

    input.init.saved_veh_file='Parallel_defaults_in';[a,b]=adv_no_gui('initialize',input)

This will load the default parallel hybrid configuration and initialize
the workspace.

3.  Now to run the grade test type the following,

<!-- -->

    input.grade.param={'speed'};input.grade.value={55};[a,b]=adv_no_gui('grade_test',input)

This will run the grade test using all defaults other than the specified
speed of 55 mph. b.grade.grade will contain the maximum grade achieved.

4.  Next change the mass of the mass of the vehicle to 1500 kg and
    reevaluating the grade performance by typing the following,

<!-- -->

    input.modify.param={'veh_mass'};input.modify.value={1500};[a,b]=adv_no_gui('modify',input)

    input.grade.param={'speed'};input.grade.value={55};[a,b]=adv_no_gui('grade_test',input)

You should see a decrease in the grade performance. \
   \
  

**<u>Example 2: Mapping of a design space</u>**

To map out the design space of a certain configuration (i.e. similar to
a parametric study), do the following;

1.  Start Matlab.
2.  In a new m-file called my\_script.m add the following script,

<!-- -->

    input.init.saved_veh_file='Parallel_defaults_in';[a,b]=adv_no_gui('initialize',input)

    % to load the default parallel hybrid configuration and initialize the workspace.

    trq_range=[0.25:0.25:1.25];

    for I=1:length(trq_range)

    input.modify.param={'fc_trq_scale'};input.modify.value={trq_range(I)};[a,b]=adv_no_gui('modify',input)

    % to modify the engine torque scale (i.e. change the peak power output of the engine)

    input.procedure.param={'test.name'};input.procedure.value={'TEST_CITY_HWY'};[a,b]=adv_no_gui('test_procedure',input)

    fuel(I)=b.procedure.mpgge

    % to run the city hwy test procedure and obtain the default fuel and emissions performance

    input.accel.param={'spds'};input.accel.value={[0 30; 50 70]};[a,b]=adv_no_gui('accel_test',input)

    accel1(I)=b.accel.times(1);

    accel2(I)=b.accel.times(2);

    % to run the acceleration test and obtain the 0 to 30 mph and 50 to 70 mph accel times

    input.resp.param={'veh_mass';'fc_trq_scale'};[a,b]=adv_no_gui('other_info',input)

    mass(I)=b.other.value{1};

    scale(I)=b.other.value{2};

    % to obtain the resulting vehicle mass

    end

    figure; plot(scale,accel1,'b-',scale,accel2,'r-') % to plot accel times vs. power

    xlabel('Torque Scale Factor')

    ylabel('Acceleration Time (s)')

    legend('0-30','50-70')

    figure; plot(scale,mass) % to plot mass vs power

    xlabel('Torque Scale Factor')

    ylabel('Vehicle Mass (kg)')

    figure; plot(scale,fuel) % to plot fuel economy vs power

    xlabel('Torque Scale Factor')

    ylabel('Fuel Economy (mpg)')

3.  At the command line type my\_script and the function should provide
    you with 3 plots showing the relationships to engine size. All of
    the raw data will be accessible in the Matlab workspace.

 

**<u>Example 3: Running Autosize</u>**

First, run the autosize feature from the GUI. Setup a test case the way
you want adv\_no\_gui to run autosize. Run this case. When finished,
switch to the MATLAB command window and type the following:

    autosize.grade_test=vinf.grade_test;autosize.accel_test=vinf.accel_test;autosize.autosize=vinf.autosize;save fname autosize;

After this is complete, you will have made and saved a structure ready
for use with adv\_no\_gui. Consult autosize.m and adv\_no\_gui.m for
details on how the sub-fields \*.autosize.autosize,
\*.autosize.grade\_test, and \*.autosize.accel\_test are used. Next,
clear the matlab workspace and start working with adv\_no\_gui:

    clear all;input=load('fname'); % creates input.autosize.autosize, *.*.grade_test, & *.*.accel_test[a,b]=adv_no_gui('autosize',input);

The model will be automatically autosized. Results are accessible from
the base workspace or via the [a,b]=adv\_no\_gui(’other\_info’,input)
command.

### <a name="2.3.1"></a>2.3.1 Calling ADVISOR from outside of MATLAB

An executable file has been include with ADVISOR to allow users to
perform automated analysis external to ADVISOR and MATLAB.  The
executable file is named advisor\_script.exe and can be found in the
C:\\ADVISOR\\gui directory.  The ADVISOR\_script executable
(advisor\_script.exe) can be used in conjunction with adv\_no\_gui to
automate the process of running analyses from the windows command line.\
 \
 Format:\
 \
 advisor\_script.exe WorkingDirectory ScriptFilename
ADVISORRootDirectory SupportDirectory\
 \
 This command can be executed from a command window and will perform the
following functions:\
 \
 1) Open the MATLAB Engine\
 2) Update the MATLAB path to include directories necessary for ADVISOR
to execute\
 3) Add the SupportDirectory to the top of the path\
 4) Update the current working directory to be WorkingDirectory\
 5) Run ScriptFilename at the MATLAB command prompt\
 6) Close the MATLAB engine when calculations are complete\
 \
 ADVISOR\_script does not return any results or output so the
ScriptFilename must handle input and output data management with
ADVISOR. The scriptfile will typically include a series of adv\_no\_gui
calls that build the ADVISOR workspace, run the cycles or tests, and
saves the results for review later. A sample script file has been
included (see SampleScriptFile.m) to serve as a template for creating
your own routines.\
 \
 CAUTION: At this time directory names with spaces are not supported!!!\
 \
 The source code for advisor\_script.exe is included in
advisor\_script.c.  \

### <a name="helper"></a>2.4 Helper Classess and Functions

-   [Cycle Audit Class](CycleAudit.html)
-   [Engine Map Class](eng_map.html)\

* * * * *

<center>
[Back to Chapter 1](advisor_ch1.html) \
 [Forward to Chapter 3](advisor_ch3.html) \
 [ADVISOR Documentation Contents](advisor_doc.html)

</center>
Last Revised: [04-Aug-2003]: mpo
