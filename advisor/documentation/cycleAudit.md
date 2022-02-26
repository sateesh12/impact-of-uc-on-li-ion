% ADVISOR CycleAnalysis Class
% 
% 

Cycle Audit Class
=================

For the convenient analysis of drive cycle data and simple vehicle
modeling (up to the powertrain), a drive cycle analysis class has been
created.  MATLAB Classes are described in detail in the MATLAB help
documentation. This help file discusses the major features of the
CycleAnalysis class and how to use it.\

Major Features
--------------

-   Speed vs. Time Trace statistical analysis
-   Building New Cycles\
-   Histogram Analysis and Plots of Speed vs. Time Trace statistics
-   Simple vehicle energy analysis
-   Roadload Loss Analysis for Simple Vehicles

Examples
--------

Shown below,  are examples to walk a user through usage of 
CycleAnalysis objects. As with all objects in MATLAB, one can type:\

-   methods(CycleAudit) % displays all of the methods for class
    CycleAudit
-   help CycleAudit/[method name] % displays text help for a method\

### Speed vs. Time Trace Statistical Analysis

There are several ways one can create a CycleAudit object:\

% method 1: using t and v arrays\
 t = [0, 1, 2, 3, 4, 5]; % elapsed time, seconds\
 v = [0, 1, 2, 2, 1, 0]; % speed, m/s\
 cyc = CycleAudit(t,v,’my cycle’); % creates a CycleAudit object named
cyc\
 %\
 % method 2: using ADVISOR CYC\_\*.m files\
 cyc2 =CycleAudit(’CYC\_UDDS’); % creates a CycleAudit object based on
the UDDS drive cycle\

Once the object has been created, the default statistics can be
determined using the display method:\

display(cyc)\
 cyc % alternately, just leave off the semi-colon; calls
CycleAudit/disp.m \

To explicitly obtain cycle statistics, we can call the cycStats method\

[velbar, accbar, decbar, velmax, accmax, decmax, hist] = cycStats(cyc);
% mean velocity, mean acceleration, etc.\

To plot the cycle, we can use the plot method.\

plot(cyc);\

### Buidling New Cycles

Building new cycles is simple with the CycleAudit class.  Let’s say we
want to create a new cycle that is a combination of two UDDS cycles with
a HWFET cycle in the middle. Here is what we do:\

cyc1 = CycleAudit(’CYC\_UDDS’);\
 cyc2 = CycleAudit(’CYC\_HWFET’);\
 cyc  = cycSplice([cyc1 cyc2 cyc1]);\

If we plot the cyc object, we will see that this indeed works:\

plot(cyc);\

### Histogram Analysis

Alternately, we can call up the plotDist method which will display
statistics in histogram  format.\

plotDist(cyc); % note: the red lines indicate where the average is\

### Simple Vehicle Energy Analysis

Let’s assume we want to examine a heavy vehicle with the following
statistic

  ---------------------------------------------------- --------------
  Param\                                               Value\
                                                       

  Air Density [kg/m/m/m] [airDensity]\                 1.23\
                                                       

  Coefficient of Drag [–] [CD]\                        0.65\
                                                       

  Frontal Area [m\*m] [FA]\                            7.99\
                                                       

  Vehicle Mass [kg] [M]\                               7257\
                                                       

  Gravity Acceleration [m/s/s] [G]\                    9.81\
                                                       

  Rolling Resistance [RRC0]\                           0.00525\
                                                       

  Cycle Averaged Regenerative Efficiency [regenEff]\   0%\
                                                       

  Cycle Averaged Powertrain Efficiency [cycEff]\       20%\
                                                       

  Fuel Volumetric Heating Value [J/gallon] [VHV]\      137217399.6\
                                                       

  Accessory Loads [Watts] [accPwr]\                    7500
                                                       
  ---------------------------------------------------- --------------

We can wrap all of this simple data up and use it in the evalVeh
method:\

% the following are useful constants: aerodynamic loss constant, kinetic
energy constant, potential energy constant, etc.\
 aeroC=airDensity\*CD\*FA;\
   keC=M;\
   peC=M\*G;\
   rrC=G\*M\*RRC0;\

[mpg, E]=evalVeh(cyc, aeroC, keC, peC, rrC, regenEff, cycEff, fuelVolHV,
auxLoads); \

After we’ve generated the data, we can look at the details in the energy
structure, E, as detailed in *help CycleAudit/evalVeh*. In addition, we
can get an estimate of the fuel economy based on the cycle-averaged
powertrain efficiency, regenerative energy round-trip efficiency, and
the auxiliary loads we’ve specified. \

### Histogram of Losses\

Lastly, we may wish to view the loss histogram on the vehicle which can
be done as follows:\

plotDist(cyc, E);\

[return to advisor documentation\
](advisor_doc.html)

* * * * *

Page Last Updated: August 4, 2003\
 Page Last Updated by: Michael P. O’Keefe\
