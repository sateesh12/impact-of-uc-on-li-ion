% Fuel Converter
% 
% 

### Fuel Converter for Fuel Cells

*[Fuel Converter block diagram](fc_fuel_cell.gif)*

**<u>Role of subsystem in vehicle</u>** \
The fuel converter model simulates a power source for the vehicle. In
the case of a fuel cell based fuel converter, it is the electrochemical
device that converts the fuel into useable energy (electrical power) for
the drivetrain. As modeled, it is designed to be  incorporated into a
series vehicle configuration.

**<u>Description of modeling approach</u>** \
The fuel converter model in the fuel cell block diagram is a composite
of five different fuel cell models of which only one will be used during
any simulation.  The user specifies which model is to be used through
the fc\_fuel\_cell\_model flag variable.  The five models available
include a power vs. efficiency model, a polarization curve model, an
external model called GCTool and two new fuel cell system models called
the VT and the KTH models. The two latter are described in
(<fuel_converter_fuel_cell_VT_model.html>) and
(<fuel_converter_fuel_cell_KTH_model.html>). Below is the description of
the power vs. efficiency model, the polarization curve model, and the 
GCTool software.

Given a requested power calculated by the other submodels, the fuel
converter model determines the fuel cell operating point required to
meet these requirements while also accounting for accessory loads. Once
the achievable power has been determined, these values are passed back
to the rest of the vehicle model. These values are also used to
determine the fuel use and emissions for each time step. The fuel use
and fuel converter out emissions values are stored in tables indexed by
fuel converter power. Temperature correction factors have been
incorporated to scale the fuel use and emissions for cold starts.

The power vs. efficiency model requires that the user provide the
relationship between power out of the fuel cell system and the fuel use
and emissions out of the system.  This model is best applied when the
user is not interested in specific operating characteristics of the fuel
cell.  The polarization curve model requires that the user provide more
detailed information regarding the fuel cell system including the
voltage-current characteristics of the fuel cell and the power demand
characteristics of the fuel cell auxiliaries.  The power out of the
system will then be the difference between the amount produced by the
fuel cell stack and that required by the auxiliaries. The fuel use and
emissions out will be dependent on the operating point of the fuel
cell.  Finally, the GCTool-based model requires that the user have
GCTool loaded on the local machine. GCTool is a computation engine
developed by Argonne National Lab with specific routines for fuel
cells.  The model will access GCTool as necessary to calculate the power
out, fuel use, and emissions values at each time step.

<p>
**<u>Equations used in subsystem</u>** \
*Polarization Curve Model* \
(power available) = (system voltage\*system current) – (accessories
power) \
     (accessories power) = sum(accessories power(fuel use)) \
          (fuel\_use) = (total fuel required) - (excess fuel) \
               (total fuel required) = (fuel consumed)/(fuel utilizaiton
factor) \
                    (fuel consumed) = f(current density) \
                    (fuel utilization factor) = f(current density) \
     (system voltage) = (cell\_voltage) \* (number of cells) \* (number
of stacks) \
           (cell\_voltage)=f(current density) \
     (system current) = (current density) \* (cell area) \* (number of
strings) \
           (current density)=f(power density) \
                (power density) = (power requested)/(string
number)/(stack number)/(cell number)/(cell area) \
                     (power requested)=(system power request) +
sum(accessories power req(fuel use at previous time step)) \
(gallons of fuel used) = sum(fuel used per time step)

> (fuel used per time step) = ( fuel used) \* ( temperature correction
> factor)
>
> > (temperature correction factor) = 1+ ((95-(coolant
> > temperature))/(75))\^3.1 \
> > (coolant temperature) = (previous coolant temperature) + (change in
> > temperature) / (change in time) \* (time step)
> >
> > > (change in temperature) / (change in time) = 1.1\*(key on=1)\*(-
> > > log(1-40/75)/218)\*(95-(previous coolant temperature))+(1-(key
> > > on=1))\*(gamma)\*( (previous coolant temperature)- ambient
> > > temperature)
> > >
> > > > (gamma)=(-8.22e-5\*(vehicle speed)+8.09e-6\*4-1.45e-4)\*.45

(emissions per time step) = (fully-hot emissions as a function of
current density)\*(temperature correction factor)

> > (normalized temperature)=(95-(coolant temperature))/(75) \
> > For CO: ( temperature correction factor) = 1 + 9.4 \* (normalized
> > temperature) \^ 3.21 \
> > For NOx: ( temperature correction factor) = 1+ 0.6 \* (normalized
> > temperature) \^ 7.3 \
> > For HC: ( temperature correction factor) = 1+7.4\* (normalized
> > temperature) \^ 3.072

*Power vs. Efficiency Model* \
(power available) = min(power requested, max power)

<p>
(gallons of fuel used) = sum(fuel used per time step)

> (fuel used per time step) = (fuel used) \* (temperature correction
> factor)
>
> > (temperature correction factor) = 1+ ((95-( coolant
> > temperature))/(75))\^3.1 \
> > (coolant temperature) = (previous  coolant temperature) + (change in
> > temperature) / (change in time) \* (time step)
> >
> > > (change in temperature) / (change in time) = 1.1\*(key on=1)\*(-
> > > log(1-40/75)/218)\*(95-(previous coolant temperature))+(1-(key
> > > on=1))\*(gamma)\*( (previous  coolant temperature)- ambient
> > > temperature)
> > >
> > > > (gamma)=(-8.22e-5\*(vehicle speed)+8.09e-6\*4-1.45e-4)\*.45

( emissions per time step) = (fully-hot emissions as a function of
power)\*(temperature emissions correction factor)

> > (normalized temperature)=(95-(coolant temperature))/(75) \
> > For CO: (temperature correction factor) = 1 + 9.4 \* (normalized
> > temperature) \^ 3.21 \
> > For NOx: (temperature correction factor) = 1+ 0.6 \* (normalized
> > temperature) \^ 7.3 \
> > For HC: ( temperature correction factor) = 1+7.4\* (normalized
> > temperature) \^ 3.072

*GCTool-based model*

All outputs are calculated within the GCTool package. Calculation
methods will vary depending on the input file used by GCTool. \
 

<p>
**<u>Variables used in subsystem</u>**

> [See Appendix A.2: Input
> Variables](advisor_appendices.html#Input%20Fuel%20Converter) \
> [See Appendix A.3: Output
> Variables](advisor_appendices.html#Output%20Fuel%20Converter)

**<u>References</u>** \
The temperature corrections for the emissions releases are based on a
report entitled “Emission Simulations: GM Lumina, Ford Taurus, GM
Impact, and Chrysler TEVan” by J. Dill Murrell and Associates, LLC.,
Saline, MI, January 1996. \

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
