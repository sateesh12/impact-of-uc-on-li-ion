% Neural Network Emissions Models for ADVISOR from West Virginia
  University
% 
% 

Neural Network Emissions Models
===============================

Introduction
------------

As a contrast to lookup tables  (where emissions are looked up by
interpolation off of a torque by speed table), [neural
networks](http://www.emsl.pnl.gov:2080/proj/neuron/neural/neural.homepage.html)
are equation based solutions that can be “trained” to predict outputs.
West Virginia University has created two such neural network models for
use in ADVISOR. The first corresponds to a 1999 Cummins ISM 370 and the
other to a 1994 Navistar T 444E–both engines fueled on diesel no. 2.

The Cummins engine model is trained on four cycles: the heavy-duty
federal test procedure (FTP), the European Stationary Cycle (ESC), the
European Transient Cycle (ETC), and a randomly generated cycle. The
Navistar engine model is trained on the FTP only.

The neural network models use engine torque and shaft speed and their
time derivatives as inputs. Thus, one advantage that the neural network
model has over the 2D lookup table model is the incorporation of
transient effects.

Implementation
--------------

Six neural network models have been provided by West Virginia
University: CO prediction for the Cummins ISM, CO~2~ prediction for the
Cummins ISM, NO~x~ prediction for the Cummins ISM, CO prediction for the
Navistar T444E, CO~2~ prediction for the Navistar T444E, and NO~x~
prediction for the Navistar T444E. Each neural network model takes six
input parameters to predict emissions at a given time-step. The inputs
and outputs are listed below:

<div align="center">
<center>
  -----------------------------------------------------------------------------------------------------------------------
  Input at time t (units)                                                Output for time t (units)
  ---------------------------------------------------------------------- ------------------------------------------------
  engine shaft speed at time t (revolutions per minute)                   Emissions Output at time t (grams per second)

  change in engine shaft speed at t from 5 seconds previous (t-5) \
  (change in revolutions per minute per 5 seconds)

  change in engine shaft speed at t from 10 seconds previous (t-10) \
  (change in revolutions per minute per 10 seconds)

  engine brake torque at time t (Nm)

  change in engine brake torque at t from 5 seconds previous (t-5) \
  (change in Nm per 5 seconds)

  change in engine brake torque at t from 10 seconds previous (t-10) \
  (change in Nm per 10 seconds)
  -----------------------------------------------------------------------------------------------------------------------

</center>
</div>
The user has access to the neural network models in three formats: 

1.  By calling the neural network mex files directly (cumminsCO,
    navistarNOx, etc.–type ‘help cumminsCO’ on the command line for
    usage)
2.  As post processing after an ADVISOR run using nnProc.m– a function
    in \<ADVISOR main directory\>/data/fuel\_converter/neural\_net (type
    ‘help nnProc’ on the command line for usage)
3.  As an integrated part of the ADVISOR block-diagrams by setting the
    fuel\_converter version to nn\_ic (neural network internal
    combustion model).

The first and second formats above are fairly self-explanatory and help
is available at the command prompt for users wishing to use these
formats. One note of caution: when using ADVISOR generated results to
call the neural network functions directly or through nnProc, users
should use fc\_spd\_est\*30/pi (fuel converter [engine shaft] speed
estimate in rad/s transformed to RPM) and fc\_brake\_trq (the brake
torque of the fuel\_converter [engine shaft] in Nm). These variables are
used with ADVISOR’s lookup table method and are the most consistent.

The third format (within the ADVISOR block diagrams) for using the
neural network models will be where most users encounter the models and
will be discussed briefly here.

Format 3 of the neural network models is available through a Simulink
S-function implemented as a configurable subsystem in the
fuel\_converter drivetrain block (located in \<ADVISOR main
directory\>/models/library/lib\_fuel\_converter.mdl). At the input
screen, the user should select nn\_ic in the fuel\_converter
[version](version_type_help.html) pull-down menu. In order to preserve
all existing functionality in ADVISOR, a dummy engine map is created at
the input screen. The maximum torque curve from the initial engine map
is used to ensure the vehicle stays within performance constraints.
However, the user should note that the fuel usage map of this dummy
engine is not used. The neural network model generates hot emissions
data for CO, CO~2~, and NOx.

The neural network model in format 3 is tied into ADVISOR’s existing
thermal model allowing users to simulate the effects of engine warm-up
and aftertreatment scenarios. Users wishing to do such studies should
examine the initialization files fc\_cummins\_NN and fc\_navistar\_NN to
ensure proper assumptions have been made for thermal and emissions
characteristics. As the neural net only predicts NOx, CO, and CO2, maps
can be defined for O2 content, PM, and HC. Cold emissions maps can be
defined as well. Fuel use is determined by the neural net through a
carbon balance on the CO~2~ emissions. Fuel usage then allows for a
determination of efficiency and waste heat generation. 

The additional inputs and output variables used by the neural network
model are mentioned below:

<div align="center">
<center>
  ------------------------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Additional Input Variable required in the FC\_\*.m initialization script file   Meaning
  fc\_nn\_model\_name                                                             This is the name of the neural network models to use. As of the writing of this help file, there are only two options: ‘1999CumminsISM370’ & ‘1994NavistarT444E’
   fc\_CO2\_to\_FUELgps                                                           A constant multiplier used to transform CO~2~ emissions to diesel fuel usage. The transform is based on a carbon balance and should be in the neighborhood of 0.31-0.33 g diesel no. 2 per g CO~2~.
  ------------------------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

<p>
 

</center>
</div>
<div align="center">
<center>
  ----------------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Neural Network Generated Variable Names   Variable Meanings and Units
  fc\_nn\_CO                                the neural net predicted hot CO emissions in g/s
  fc\_nn\_CO2                               the neural net predicted hot CO2 emissions in g/s
  fc\_nn\_NOx                               the neural net predicted hot NOx emissions in g/s
  fc\_hotemis\_eo                           records HC, CO, NOx, and PM (g/s) in a four signal array to the workspace for *hot* emissions. (That is, the emissions that would have been generated if the engine were at its defined *hot* temperature).
  ----------------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</center>
</div>
For More Information
--------------------

<ol>
<li>
N. Clark, C. T
