% Optimization Templates
% 
% 

<!DOCTYPE html public "-//w3c//dtd html 4.0 transitional//en">

Optimization Templates
======================

Optimization has become an extremely important part of the vehicle
design process.  As a result, template files and example problems
providing links to four optimization suites have been included in
ADVISOR v3.2.  The template files included were developed in support of
the publication of two technical papers.  At the time of our public
release of ADVISOR v3.2 these papers were not yet published.  When
published they will be included in our [Reading
Room](http://www.ctts.nrel.gov/analysis/reading_room.html).  The first,
*Optimization Techniques for Hybrid Vehicle Analysis Using ADVISOR*
(ASME IMECE Nov. 2001) discusses the tools and the test of these tools
on a 2 dimensional sample problem called a 3 Hump CamelBack surface. 
The second paper,*Optimizing Energy Management Strategy and Degree of
Hybridization for a Hydrogen Fuel Cell SUV* (EVS-18 Oct 2001) explored
the details of the vehicle design and the effects of drive cycle demands
on the optimal configuration.

CAUTION:  Before attempting to use the adv\_no\_gui functionality or the
optimization tutorials the user must have a good working knowledge of
ADVISOR.  A basic understanding of optimization methods is useful and
experience with the tools in question will be extremely beneficial.  If
you need assistance please contact us at <advisor@nrel.gov>.

### Interfacing between ADVISOR and Optimization tools

The ability to use ADVISOR in a “GUI-free” or batch mode was introduced
and documented with the release of ADVISOR v3.1.  This mode was
specifically developed to make it easy to use ADVISOR as an automated
function or response-generating tool to be connected to optimization
routines.  As currently configured, this functionality provides the user
with nearly all of the functionality available from the GUI, and in some
instances even more functionality.

The general approach for linking the optimization tools to ADVISOR
includes three primary files and five basic steps.  The files include a
main function routine for configuring the workspace and performing post
processing operations, a function for generating the objective response
value, and a function for generating the constraint response values. 
Each of the optimization software tools explored requires minor
variations to this implementation process but use the same general
approach. As a result, it requires minimal effort to apply multiple
algorithms to the solution of the same problem.

The basic optimization process using ADVISOR can be summarized as
follows,

​1. Initialize the MATLAB workspace \
 2. Modify the design variable values in the workspace with input from
optimizer \
 3. Run simulation to generate objective responses \
 4. Run simulation to generate constraint responses \
 5. Process results with optimization tool and return to step 2 until
convergence criteria met

Each of the first four operations are achieved using the unique options
as input to the [adv\_no\_gui](advisor_ch2.html#2.3) function as defined
in the ADVISOR documentation.

### Optimization tools

#### MATLAB Optimization Toolbox

The MATLAB Optimization Toolbox is an optional component of MATLAB
developed and supported by [The MathWorks,
Inc.](http://www.mathworks.com/). This Toolbox includes a variety of
algorithms applicable to specific problem types. For our vehicle
analysis problems the most applicable algorithm in this toolbox is the
FMINCON function.  It is designed for use with non-linear constrained
and bounded optimization.  It calculates a gradient based on the
responses it receives using sequential quadratic programming (SQP)
numerical methods.  We have not been involved in any development related
to this toolbox but have focused the development of other tools to take
a similar format such that all of the tools could be applied to common
problems in using a similar I/O format.

#### VisualDOC

VisualDOC 2.0 is a commercial optimization package distributed by
[Vanderplaats R&D](http://www.vrand.com/). We have worked with
Vanderplaats R&D to integrate a limited version of VisualDOC into
ADVISOR for public use.  It has been applied to both component sizing
and control strategy optimization.  Communication between ADVISOR and
VisualDOC was originally accomplished via ASCII text files.  There was
significant overhead and inflexibility associated with this approach,
thus we have supported the development of an application programming
interface (API) for interacting with the VisualDOC functional modules
directly from MATLAB.  This approach greatly enhances the seamless
integration of the tools and provides significant flexibility in what
problems can be solved.

VisualDOC offers both Direct Gradient-based Optimization (DGO) and
Response Surface Approximations (RSA) routines.  By default the DGO
routine uses SQP numerical methods to calculate the gradients to
determine the search direction for optimal values.  RSA performs a
Design of Experiments (DOE) and builds a second-order approximation
based on the responses from these data points.  Based on the surface,
the routine can make an estimate of the optimum design point, evaluate
the function at this point, update the approximation based on the actual
value, and iterate on the design point until a stop condition is
encountered.  This routine is especially useful for problems with noisy
responses, such as a function that has an internal convergence tolerance
and thus has some free play within the system.

#### DIRECT

DIRECT is an algorithm developed by Donald R. Jones. In basic terms,
this algorithm divides a design space into smaller and smaller
sub-sections based both on the objective function in a specific area and
the characteristic dimension associated with each sub-space [8]. This
ensures that it searches the entire space in sufficient granularity to
find good areas to explore in more detail.   One very useful feature of
this routine is its restart functionality.  This allows the user to stop
the optimizer after a specified number of function evaluations or design
iterations, review the results, and continue the analysis.  Since its
original introduction, it has been upgraded to include constrained
optimization and integer functionality.  It has also been ported to
various platforms and programming languages including MATLAB and a
version is included in [TOMLAB 3.0](http://www.tomlab.net/).

#### iSIGHT

ISIGHT is an optimization software package developed and distributed by
[Engineous Software, Inc](http://www.engineous.com/).  It offers a wide
variety of algorithms and solution methods to choose from.  Two key
features of this tool are 1) its flexibility in defining linkages
between multiple programs, and 2) the ability to combine multiple
solution methods in series or parallel to solve a specific problem.  It
also provides response surface visualization tools that allow the user
to explore the impacts of design parameters manually based on
design-of-experiments based approximation.  In recent work, the Genetic
Algorithms and the Sequential Quadratic Programming with Approximations
methods have been explored.  Based on previous experience, the hybrid
vehicle design space is highly non-linear and can have discontinuous
regions.  Therefore, it is believed that these two methods would be
effective routines.

### Tutorials

Tutorial files have been created that solve 5 different problems.  Of
these problems, two are simple mathematical functions that test the
implementation and three are ADVISOR related problems.  The following
table summarizes the five problems, \
  

<p align="CENTER">
<center>
<table border cellspacing="1" width="624">
<tr>
<td valign="MIDDLE">
<p>
**<font size="4">Directory Name**</font>

</td>
<td valign="MIDDLE">
**<font size="4">**

<p>
Description</b></font>

</td>
<td valign="MIDDLE">
**<font size="4">**

<p>
Objective</b></font>

</td>
<td valign="MIDDLE">
**<font size="4">**

<p>
Constraints</b></font>

</td>
<td valign="MIDDLE">
**<font size="4">**

<p>
Design Variables</b></font>

</td>
</tr>
<tr>
<td valign="MIDDLE">
<p>
3humpcamelback

</td>
<td valign="MIDDLE">
<p>
2D multi-modal mathematical surface

</td>
<td valign="MIDDLE">
<p>
minimize f(x,y)

</td>
<td valign="MIDDLE">
<p>
none

</td>
<td valign="MIDDLE">
<p>
x and y

</td>
</tr>
<tr>
<td valign="MIDDLE">
<p>
box

</td>
<td valign="MIDDLE">
<p>
Cardboard box optimization

</td>
<td valign="MIDDLE">
<p>
minimize surface area

</td>
<td valign="MIDDLE">
<p>
volume = 2.0

</td>
<td valign="MIDDLE">
<p>
width, height, length

</td>
</tr>
<tr>
<td valign="MIDDLE">
<p>
sizing

</td>
<td valign="MIDDLE">
<p>
ADVISOR component size optimization (similar to Autosize) 

</td>
<td valign="MIDDLE">
<p>
maximize fuel economy on TEST\_CITY\_HWY

</td>
<td valign="MIDDLE">

Acceleration</b> 

-   0-96.5 km/h \<= 11.2 s
-   64-96.5 km/h \<= 4.4 s
-   0-137 km/h \<= 20.0 s

Gradeability</b>

-   @ 88.5 km/h for 20 min. at Curb Weight + 5 passengers and cargo (408
    kg) = 6.5 %

Drive Cycle</b> 

-   Difference between drive cycle requested speed and vehicle achieved
    speed at every second during the drive cycle \<= 3.2 km/h

SOC Balancing </b>

-   Difference between final and initial battery state of charge  \<=
    0.5 %

</td>
<td valign="MIDDLE">
<p>
fc\_pwr\_scale \
 mc\_trq\_scale \
 ess\_module\_num \
 ess\_cap\_scale

</td>
</tr>
<tr>
<td valign="MIDDLE">
<p>
control

</td>
<td valign="MIDDLE">
<p>
Vehicle control strategy optimization in ADVISOR 

</td>
<td valign="MIDDLE">
<p>
maximize fuel economy on TEST\_CITY\_HWY

</td>
<td valign="MIDDLE">

Acceleration</b> 

-   0-96.5 km/h \<= 11.2 s
-   64-96.5 km/h \<= 4.4 s
-   0-137 km/h \<= 20.0 s

Gradeability</b>

-   @ 88.5 km/h for 20 min. at Curb Weight + 5 passengers and cargo (408
    kg) = 6.5 %

Drive Cycle</b> 

-   Difference between drive cycle requested speed and vehicle achieved
    speed at every second during the drive cycle \<= 3.2 km/h

SOC Balancing </b>

<dir>
<p>
Difference between final and initial battery state of charge  \<= 0.5 %

</dir>
</td>
<td valign="MIDDLE">
<p>
cs\_min\_pwr \
 cs\_max\_pwr \
 cs\_charge\_pwr \
 cs\_min\_off\_time

</td>
</tr>
<tr>
<td valign="MIDDLE">
<p>
sizing\_plus\_control

</td>
<td valign="MIDDLE">
<p>
Simultaineous optimization of component sizes and vehicle energy
management strategy in ADVISOR

</td>
<td valign="MIDDLE">
<p>
maximize fuel economy on TEST\_CITY\_HWY

</td>
<td valign="MIDDLE">

Acceleration</b> 

-   0-96.5 km/h \<= 11.2 s
-   64-96.5 km/h \<= 4.4 s
-   0-137 km/h \<= 20.0 s

Gradeability</b>

-   @ 88.5 km/h for 20 min. at Curb Weight + 5 passengers and cargo (408
    kg) = 6.5 %

Drive Cycle</b> 

-   Difference between drive cycle requested speed and vehicle achieved
    speed at every second during the drive cycle \<= 3.2 km/h

SOC Balancing </b>

<dir>
<p>
Difference between final and initial battery state of charge  \<= 0.5 %

</dir>
</td>
<td valign="MIDDLE">
<p>
fc\_pwr\_scale \
 mc\_trq\_scale \
 ess\_module\_num \
 ess\_cap\_scale \
 cs\_min\_pwr \
 cs\_max\_pwr \
 cs\_charge\_pwr \
 cs\_min\_off\_time \
  

</td>
</tr>
</table>
</center>
</p>
All the optimization tools use common objective and constraint functions
but have separate main control files and support files. The common files
are located in the directory with the name of the problem while the main
control and support files specific to a tool are located in the tools
subdirectory. If you decide to change or create the main script file you
will also need to change/create the associated objective and constraint
function files.  Before attempting to use the template files, ensure
that you have started ADVISOR and selected the save path option the
first time it starts. It is also important that your directory path
names do not include spaces. \
 In general, the two simple mathematical examples will finish in a
matter of seconds while the ADVISOR problems will likely execute over a
period of 1 to several hours.  For the ADVISOR focused problems, a saved
vehicle file is normally generated at the end of the optimization
process that can then be used within the ADVISOR GUI to allow more
detailed analysis of the vehicle operation during the entire drive
cycle.

Using MATLAB Optimization Toolbox</b> \
 To use the template files for the Matlab Optimization toolbox you must
have purchased the optional toolbox from The Mathworks.  The MATLAB
routine uses only a single main control file.  In this file
(optim\_\*\_matlab.m) the optimization problem is defined and the
optimizer parameters are set.  For more information on the optimizer
parameters or the available solution methods please refer to the toolbox
documentation.  FMINCON is applicable to many types of optimization
problems.

At the command line type the name of the main control file (i.e.
optim\_box\_matlab).  This will start the optimization process.
Depending on the optimizer settings you have chosen you may or may not
receive periodic feedback.  When complete you may analyze the results in
the workspace.

Using VisualDOC</b> \
 To use VisualDOC you will need to purchase a license for VisualDOC 2.0
from Vanderplaats R&D.  Once you have installed the basic software, you
must add the custom application program interface (API) files to the
installation.  Simply double-click on the VisualDOC20\_API.zip file in
the main optimization directory and extract the files to the
/VisualDOC20/bin directory.  You may have to restart the computer for
the files to be accessible.

The API provides the user with the ability to build up problems and
access the inputs and results during the intermediate steps of the
optimization process.  For API command reference please refer to the
document VisualDOC20\_API.doc in the main optimization directory.

Once the software has been installed the user can then start the
optimization process from Matlab by typing the name of the main
optimization script file (i.e. optim\_box\_visualdoc.m).  Within this
file the user can modify the problem definition (remember to also modify
the objective and constraint functions!) and optimizer control
parameters.  For gradient-based tools these parameters are extremely
important to ensure realtively quick convergence.

Results can then be accessed from the Matlab workspace or by opening the
associated database file \*.db using the VisualDOC GUI.

Using DIRECT</b> \
 A publicly distributed version of DIRECT in the form of gclsolve.m has
been include with ADVISOR v3.2.  A commercial version of DIRECT is also
available in TOMLAB v3.0.  The TOMLAB website provides good background
information on history and methods used in this routine.  Because it is
non-gradient based it is quite effective in finding the near optimal
solution on the vehicle analysis problems solved using ADVISOR. 
However, it will require a significant amount of processing power and
time to resolve the solution to a close tolerance.

The tutorials with DIRECT have two special features that the user should
be aware of.  First since DIRECT does not have a stop convergence
tolerance for the design variables or responses, the user must predefine
how long they would like the routine to iterate.  Within the main
control file you can either define the maximum number of function
evaluations to be performed or the maximum number of iterations to be
performed.  If the maximum number of function evaluations is exceeded
first, it will complete the current design iteration before exiting.

An alternative approach using an external stop flag has also been
implemented. At the end of each design iteration DIRECT will look for a
file called stop.m in the current Matlab path.  If found, it will exit.
If not it will continue.  This is an extremely useful feature when you
know about how long you have for processing.  For example, you can start
the problem before you leave the office in the morning.  When you arrive
the next day, find the file, stop\_hide.m, in the optimization directory
and rename it to stop.m.  The routine will not stop immediately since it
needs to complete the current design iteration.

DIRECT also offers the user the ability to continue an optimization
process that has been stopped.  By changing the value of cont\_bool from
0 to 1 the routine will import the previous results and continue from
where it left off.  Remember to reset the name of the stop.m file back
to stop\_hide.m.

We have also created a plotting routine for use with DIRECT and other
optimization scripts that provide intermediate results.  By setting the
PriLev parameter to 2 in the main control file, normalized plots of the
design variables, constraints, and objective will be created at the end
of each design iteration and at the conclusion of the analysis.  These
are useful for evaluating the progress made and choosing whether to stop
the routine or to let it continue to process on the problem.

Using iSIGHT</b> \
 To use iSIGHT you will need to purchase a license for iSIGHT from
Engineous Software.  At this time the connection with iSIGHT is slightly
different from that of the other tools mentioned above in that the
initiation occurs from within iSIGHT rather than from within Matlab.  By
double-clicking on the \*.desc file in the problem directory of choice
launches iSIGHT and allows you the run and analyse the results from
within the iSIGHT GUI.  Users will need a working knowledge of iSIGHT to
effectively use these example files.

VERY IMPORTANT:  To use the included files you MUST update embedded path
information in two locations.  First in the \*.desc file (editable in
Notepad) approximately half way through the text file there is a line
that points to the location of your Matlab installation.  Update this
path to point to your installation.  Second, in the indata.m file of the
problem of interest you must update the path at the end of the file to
point to the specific indata.m file.  These are important steps that are
necessary so that iSIGHT knows where to look for specific files.  Both
of these modifications can also be completed from the iSIGHT GUI.

To run an analysis double-click on the \*.desc file of interest and then
select Execute from within iSIGHT.  Intermediate and Post-Processing
results can be reviewed using the iSIGHT Solution Monitor.

* * * * *

</p>
[ADVISOR Documentation](advisor_doc.html)

* * * * *

</p>
Last revised: [31-July-2001] tm
