% Help on Grade Test
% 
% 

<!DOCTYPE html public "-//w3c//dtd html 4.0 transitional//en">

Help on Grade Test
------------------

### Overview

The grade test routine in ADVISOR will determine the maximum grade on
which the vehicle can sustain the specified constant speed. The test
routine can be accessed both from the GUI and the Matlab command window.

### From the GUI…

A grade test can be performed via the Simulation Setup window. The user
can specify the parameters for the test in the Grade Test Advanced
Options window which is opened by selecting <b>*Grade Options</b>*.  The
test can be run with a drive cycle by selecting the <b>*Gradeability
Test</b>* in the **Additional Tests** box, or without a drive cycle by
selecting <b>*Test Procedure</b>* and then <b>*TEST\_GRADE</b>* from the
pull down menu. The Grade Options window is also accessible from the
Autosize Setup window.

\
 ![](Grade_Test_fig1.jpg)

 

The basic parameters of grade, speed, duration, and gear number allow
the user to override the default settings. By default, the routine will
find the maximum grade sustainable at 55 mph for 10s. The gear ratio
will be determined by the routine to provide maximize power output. If
the user checks the gear number option the routine will use the
specified gear number. If the grade is specified, the routine will only
test that grade point and will return an [] if unsuccessful and the
grade setting if successful.

The Enable systems section allows the user to evaluate the vehicle grade
performance with various systems disabled. By default the energy storage
system is disabled for the grade test. This option allows us to use a
much shorter cycle to determine gradeability based on engine performance
alone. This is may not represent reality and thus the ability to enable
all systems and to specify an initial and a minimum SOC for the battery
pack has been provided.

The Mass Parameters allow the user to impact the mass of the vehicle for
the grade test only. This set of radiobuttons allows you to override the
mass with a fixed amount (i.e. gross vehicle weight) or to add
incremental mass to the current mass. This last option is especially
useful if for example you want include all passengers and luggage in the
grade performance assessment while running an autosize where the vehicle
mass is changing at each iteration.

Finally, the solutions section allows you to control the solution path
and time required to conclude. If the upper and lower grade bounds are
specified they will be used to help find the initial bounds at which to
start the bisection routine. The initial step size is used with a golden
section method to move from the lower bound to find the upper bound. The
grade and speed tolerances are used to tell the routine when a solution
is sufficiently close to our desired outcome. The maximum \# of
iterations is used to limit the amount of time spent resolving a single
solution point. Lastly, if display status is checked and set to one the
intermediate iterations of the grade test routine will be displayed in
the command window.

\
 When run from the simulation setup screen the results are reported in
the Results window.

### From the Matlab command window…

Running a grade test from the command window provides the user several
options. The grade test routine is a function and requires the following
format,

[grade,
gear\_ratio]=grade\_test\_advanced(param1,value1,…param\_n,value\_n)

Inputs to the grade test function must be specified in parameter name,
parameter value pairs. All input parameters are optional.  \

<table border cellspacing="1" cellpadding="7" width="774">
<tr>
<td width="25%" valign="TOP">
<p>
**Parameter**

</td>
<td width="75%" valign="TOP">

<p>
Description</b>

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
grade

</td>
<td width="75%" valign="TOP">
<p>
(%), grade the vehicle will try to achieve [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
duration

</td>
<td width="75%" valign="TOP">
<p>
(s), duration over which the vehicle must maintain speed and grade
[optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
speed

</td>
<td width="75%" valign="TOP">
<p>
(mph), the speed the vehicle is to achieve at the specified grade
[optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
ess\_init\_soc

</td>
<td width="75%" valign="TOP">
<p>
(–), initial state of charge of the ess

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
ess\_min\_soc

</td>
<td width="75%" valign="TOP">
<p>
–), user specified minimum SOC of the ESS [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
gear\_num

</td>
<td width="75%" valign="TOP">
<p>
(–), user specified gear ratio in which test is to be performed
[optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
disp\_status

</td>
<td width="75%" valign="TOP">
<p>
(boolean), 1==\>0 display status in command window, 0==\> do not display
status [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
grade\_lb

</td>
<td width="75%" valign="TOP">
<p>
(%), grade lower bound for search [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
grade\_ub

</td>
<td width="75%" valign="TOP">
<p>
(%), grade upper bound for search [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
grade\_init\_step

</td>
<td width="75%" valign="TOP">
<p>
(%), grade initial step size [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
speed\_tol

</td>
<td width="75%" valign="TOP">
<p>
(mph), convergence tolerance on speed [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
max\_iter

</td>
<td width="75%" valign="TOP">
<p>
(–), maximum number of interations [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
grade\_tol

</td>
<td width="75%" valign="TOP">
<p>
(%), convergence tolerance on grade [optional]

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
override\_mass

</td>
<td width="75%" valign="TOP">
<p>
(kg), override vehicle mass to be used for the accel test only

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
add\_mass

</td>
<td width="75%" valign="TOP">
<p>
(kg), additional mass to be added to current vehicle mass for accel test
only

</td>
</tr>
<tr>
<td width="25%" valign="TOP">
<p>
disable\_systems

</td>
<td width="75%" valign="TOP">
<p>
(–), flag to disable power systems 1==\> disable ess, 2 ==\> disable fc

</td>
</tr>
</table>
>  

If when calling the grade test, the user specifies both the speed and
grade, the grade test routine will only evaluate that point. If the
vehicle is able to maintain the specified speed and grade it will return
the grade otherwise it will return and empty set. If only the speed is
specified by the user when calling the grade test it will find the
maximum sustainable grade at this speed for the vehicle and return that
grade. If no arguments are provided it will use the default speed of 55
mph and proceed as if only the speed was provided by the user. The
function also returns the gear ratio used during the analysis.

### How it works

The vehicle is simulated at the specified constant speed for the
specified duration. Initially, the vehicle is assumed to be traveling at
the goal speed. If at the end of the cycle the vehicle is within a
specified tolerance of the speed goal it is said to be able to maintain
this grade and speed indefinitely. The grade is then adjusted until the
maximum sustainable grade is determined unless the user has specified
both the grade and speed as input arguments.

 

* * * * *

[Back to Chapter 3](advisor_ch3.html#3.3)

</p>
Last Revised: 2/9/01:tm\
  
