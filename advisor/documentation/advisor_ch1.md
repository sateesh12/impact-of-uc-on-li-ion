% Chapter 1:Introduction --ADVISOR Documentation
% 
% 

<center>
 <a name="1.0"></a>1.0 Introduction
===================================

</center>
<center>

* * * * *

</center>
[1.1 To the Reader](#1.0)

[1.2 Capabilities and intended uses](#1.2) \
[1.3 Limitations](#1.3) \
[1.4 System requirements](#1.4) \
[1.5 How to get additional help](#1.5) \

* * * * *

1.1. To the Reader
------------------

### 1.1.1. What is ADVISOR & who might benefit from using it?

    ADVISOR, NREL’s ADvanced VehIcle SimulatOR, is a set of model, data,
and script text files for use with Matlab and Simulink.  It is designed
for rapid analysis of the performance and fuel economy of conventional,
electric, and hybrid vehicles.  ADVISOR also provides a backbone for the
detailed simulation and analysis of user defined drivetrain components,
a starting point of verified vehicle data and algorithms from which to
take full advantage of the modeling flexibility of Simulink and analytic
power of MATLAB.

You may benefit from using ADVISOR if you want to:

-   estimate the fuel economy of vehicles that have not yet been built
-   learn about how conventional, hybrid, or electric vehicles use (and
    lose) energy throughout their drivetrains
-   compare relative tailpipe emissions produced on a number of cycles
-   evaluate an energy management strategy for your hybrid vehicle’s
    fuel converter
-   optimize the gear ratios in your transmission to minimize fuel use
    or maximize performance, etc.

The models in ADVISOR are:

-   mostly empirical, relying on drivetrain component input/output
    relationships measured in the laboratory, and
-   quasi-static, using data collected in steady state (for example,
    constant torque and speed) tests and correcting them for transient
    effects such as the rotational inertia of drivetrain components.

ADVISOR was preliminarily written and used in November 1994.  Since
then, it has been modified as necessary to help manage the US DOE Hybrid
Vehicle Propulsion System subcontracts.  Only in January 1998 was a
concerted development effort undertaken to clean up and document
ADVISOR.

Since then, over 4500 individuals have downloaded one or more versions
of ADVISOR, including all of the OEMs and major suppliers.  About 2/3 of
the users are from industry and 1/3 from universities.  A short list of
major ADVISOR users includes:

-   DaimlerChrysler
-   Ford Motor Company
-   General Motors Corp.
-   Delphi Automotive Systems
-   Visteon
-   and hundreds of others

### <a name="1.1.2"></a>1.1.2. How to use this manual

This manual is intended to serve both as a starting point for beginners
and as a reference for more experienced users.  New users will benefit
most by:

-   reviewing the introduction, chapter 1, for background and to
    understand what to expect from ADVISOR
-   following up with the demos in chapter 2, to get a flavor for using
    ADVISOR
-   referring to chapter 3, “How ADVISOR works,” and the appendices to
    better understand ADVISOR’s assumptions and file I/O as they become
    more experienced

Throughout this manual, Courier font will denote MATLAB commands, and
Albertus font will denote ADVISOR variables and filenames. \
 

<a name="1.2"></a>1.2. Capabilities and intended uses
-----------------------------------------------------

ADVISOR uses basic physics and measured component performance to model
existing or future vehicles.  Its real power lies in the prediction of
the performance of vehicles that have not yet been built.  It answers
the question “what if we build a car with certain characteristics?” 
ADVISOR usually predicts fuel use, tailpipe emissions, acceleration
performance, and gradeability.

<p>
In general, the user takes two steps:

> 1. Define a vehicle using measured or estimated component and overall
> vehicle data.
> <p>
> 2. Prescribe a speed versus time trace, along with road grade, that
> the vehicle must follow.

ADVISOR then puts the vehicle through its paces, making sure it meets
the cycle to the best of its ability and measuring (or offering the
opportunity to measure) just about every torque, speed, voltage,
current, and power passed from one component to another.

ADVISOR will allow the user to answer questions like:

-   Was the vehicle able to follow the speed trace?
-   How much fuel and/or electric energy were required in the attempt?
-   How does the state-of-charge of the batteries fluctuate throughout a
    cycle?
-   What were the peak powers delivered by the drivetrain components?
-   What was the distribution of torques and speeds that the piston
    engine delivered?
-   What was the average efficiency of the transmission?

By iteratively changing the vehicle definition and/or driving cycle, the
user can go on to answer questions such as:

-   At what road grade can the vehicle maintain 55 mph indefinitely?
-   What’s the smallest engine I can put into this vehicle to accelerate
    from 0 to 60 mph in 12 s?
-   What’s the final drive ratio that minimizes fuel use while keeping
    the 40 to 60 mph time below 3 s?
-   What is the fuel economy sensitivity to mass, aerodynamic drag, or
    other vehicle or component variations?

ADVISOR’s GUI and other script files answer many of these questions
automatically, while others require some custom programming on the
user’s part.

Because ADVISOR is modular, its component models can be relatively
easily extended and improved.  For example, an electrochemical model of
a battery, complete with diffusion, polarization, and thermal effects,
can easily be put into a vehicle to cooperate with a motor model that
uses a measured efficiency map.  Of course, developing new, detailed
models of drivetrain components (or anything else, for that matter)
requires an intimate familiarity with the environment, MATLAB/Simulink.

<a name="1.3"></a>1.3. Limitations
----------------------------------

#### <u>Primarily for analysis, not design</u>

ADVISOR was developed as an analysis tool, and not originally intended
as a detailed design tool.  Its component models are quasi-static, and
cannot be used to predict phenomena with a time scale of less than a
tenth of a second or so.  Physical vibrations, electric field
oscillations and other dynamics cannot be captured using ADVISOR,
however recent linkages with other tools such as Saber, Simplorer, and
Sinda/Fluint allow a detailed study of these transients in those tools
with the vehicle level impacts linked back into ADVISOR.

As an analysis tool, ADVISOR takes the required/desired speed as an
input, and determines what drivetrain torques, speeds, and powers would
be required to meet that vehicle speed.  Because of this flow of
information back through the drivetrain, from tire to axle to gearbox
and so on, ADVISOR is what is called a backward-facing vehicle
simulation.

Forward-facing vehicle simulations include a model of a driver, who
senses the required speed and responds with an accelerator or brake
position, to which the drivetrain responds with a torque.  This type of
simulation is well suited to the design of control systems, for example,
down to the integrated circuit and PC card level—the implementation
level.

ADVISOR is well suited to evaluate and, by iterative evaluation, design
control logic and energy management strategies.  By this, we mean
something like “When the engine torque output is low and the battery
state of charge is high, turn off the engine.”  The control logic, with
which ADVISOR can work, is about *what* you want the vehicle to do.  The
detailed control system, getting into details of how you would implement
this control logic in hardware, is about *how* to make the vehicle do
what you want and is not the original intention of ADVISOR’s
application.

<u>Power bus for electric power transfers</u>

In electrical components’ communication with each other, ADVISOR deals
in power, and not in voltage and current.  Linkages to other tools, such
as Saber and Simplorer let the user work with a voltage bus.

<u>Drive axle is single axle only</u>

The vehicle dynamics calculations required for traction control and the
wheel slip model assume that the front axle is the only drive axle. 
Simple steps can be taken to correct the weight transfer calculation if
you wish to model a rear-drive vehicle, and an example wheel file that
accomplishes this is included.  Modeling a four-wheel drive vehicle
requires involved Simulink reprogramming.  Please contact NREL if you
have such needs.

<a name="1.4"></a>1.4. System requirements
------------------------------------------

ADVISOR has been developed and tested in Release 12.1 (MATLAB 6.1 and
Simulink 4.1), available from The Mathworks.  The Mathworks software
runs on multiple platforms including Macintosh, UNIX, and PCs.  Contact
The Mathworks at www.mathworks.com for more information.  ADVISOR files,
however,  have been tested using only the PC platform with Windows 2000
(it should still work with NT, and Win 98 as well).  If you have success
using other platforms (such as UNIX) we would love to hear about it, but
in general we do not support other platforms at this time.

<u>[Additional features for users with
VisualDOC](cs_opt_help.html#Optimization%20Method%20Selection)</u> \
<u>[Additional features for users with
GCTool](fuel_converter_fuel_cell.html#GCTool)</u>

<a name="1.5"></a>1.5. How to get additional help
-------------------------------------------------

MATLAB’s on-line help and the MATLAB and Simulink manuals can answer
questions about MATLAB and Simulink functions.  Type helpdesk at the
MATLAB command prompt.  Additionally, you can type help or helpwin at
the MATLAB command prompt.

Descriptions of ADVISOR block diagrams are available by opening the
block diagram of interest and double-clicking on the green ‘NOTES’ block
in the bottom right or left corner.  Descriptions of ADVISOR component
and other files are available from the MATLAB command line by entering
help ADVISOR\_filename.  Help is also available from within the ADVISOR
GUI and subsequent chapters of this documentation.

This manual should get you started doing straightforward vehicle
analysis with ADVISOR.  If you have analysis needs beyond what is
covered here, please contact NREL directly at 
[www.ctts.nrel.gov/analysis](http://www.ctts.nrel.gov/analysis). \

* * * * *

<center>
[Back to ADVISOR Documentation Contents](advisor_doc.html) \
[Forward to Chapter 2](advisor_ch2.html)

</center>
Last Revised: 4/30/02:KW
