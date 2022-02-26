% Technical Target Based Components
% 
% 

<center>
Help on Technical Target Based Components
-----------------------------------------

</center>
<center>
(3/10/99:tm)

</center>
### Overview

The technical target based components in the ADVISOR database provide
the user with the ability to create and use components in simulations
that are based on specifications related to that component. In general a
baseline data file is selected and the parameters defining that
component are scaled and adjusted to match the user-defined
specifications. The new parameters are not saved to the baseline file
but are available in the Matlab workspace for subsequent simulations.

### Fuel converter

The user can define the following specifications. \
 

  ------------------------------------------- --------- --------------------------------
  *Parameter*                                 *Units*   *Typical values*
  Peak efficiency (IC engines only)           (%)       SI \~ 35, CI \~ 42
  Efficiency at 25% power (fuel cells only)   (%)       hydrogen \~ 50, reformed \~ 40
  Specific power                              (W/kg)    SI \~ 315, CI \~ 240
  ------------------------------------------- --------- --------------------------------

  \
The peak efficiency value will be used to scale the fuel usage map to
produce the desired peak efficiency while the specific power value will
be used to define the mass of the fuel converter based on its current
maximum power value.

### Motor/controller

The user can define the following specifications. \
 

  ----------------------------------- --------- ------------------
  *Parameter*                         *Units*   *Typical values*
  Efficiency over 2-20% power range   (%)       85-90
  Specific power                      (W/kg)    750
  ----------------------------------- --------- ------------------

  \
All points in the 2-20% power range of the motor efficiency map will be
assigned this efficiency value. This power range has been chosen because
it is the typical operating range of a properly sized (for PNGV grade
and acceleration performance specifications) motor/controller in a
vehicle operating over the UDDS and the Federal Highway Drive Schedule.
The specific power value will be used to define the mass of the motor
controller based on its current maximum power value.

### Energy storage system

The user can define the following specifications. \
 

  ------------------------------------------ --------- ----------------------------------
  *Parameter*                                *Units*   *Typical values*
  Nominal module voltage                     (V)       6-15
  Minimum module operating voltage           (V)       \~ 75% of nominal voltage
  Low state of charge                        (–)       0.3-0.5
  High state of charge                       (–)       0.6-0.9
  Specific energy                            (Wh/kg)   9(power assist), 60(dual mode)
  Power to energy ratio                      (W/Wh)    20(dual mode),100(power assist)
  Discharge duration for power calculation   (s)       10-18
  C/10 energy capacity                       (Ah)      150(power assist), 26(dual mode)
  12C energy capacity                        (Ah)      50(power assist), 12(dual mode)
  ------------------------------------------ --------- ----------------------------------

  \
The ess\_voc vector will be scaled such that the mean voltage is equal
to the user defined nominal voltage. The C/10 energy capacity and the
12C energy capacity parameter values are then used to generate the
coefficient and the exponent for the peukert equation used in ADVISOR.
The routine then determines the appropriate discharge resistance values
that will satisfy the rest of the specifications. The power in the power
to energy ratio is calculated as Power = V\*I where V and I are the
terminal voltage and current respectively of the battery module at the
end of the specified discharge duration time period. The constant power
value required to discharge the module from high SOC to low SOC (or the
minimum operating voltage whichever occurs first) within the specified
discharge duration is requested of the battery to find V and I. The
energy in the power to energy ratio is the total energy out of the
battery module during a C/1 constant power discharge from high SOC to
low SOC (or the minimum operating voltage whichever occurs first).
Finally, the mass of the module is determined based on the C/1 energy
capacity calculated above and the specified specific energy.

### Vehicle

The user can define the following specifications. \
 

  --------------------- --------- ------------------
  *Parameter*           *Units*   *Typical values*
  Vehicle glider mass   (kg)      car \~ 900
  Coefficient of drag   (–)       car \~ 0.3
  Frontal area          (m\^2)    car \~ 2.5
  --------------------- --------- ------------------

All of the specifications for the vehicle are assigned in the workspace
by overriding the current values. No scaling takes place. \

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html#3.3)

</center>
 
