% Advisor Version and Type Help
% 
% 

### ADVISOR Help on Version and Type

For ADVISOR 3.0 and following, variables were introduced to define the
version and the type of component being chosen by the user.  These
coincide with the options available next to each component on the input
screen.  The following definitions and lists are to aid the user in
understanding what each of these choices represent.

#### Version:

> This is the version of the model (ie. Simulink Block Diagram) for the
> component you are going to run.  For example, ‘ic’ for the fuel
> converter is a model of an internal combustion engine while ‘fc’ is
> the model for the fuel cell.  This example may change as versions and
> types are updated.

#### Type:

> Type is a choice for the version that has been picked.  For example:
> if you picked ‘ic’ for the fuel converter, the types of components
> available for that model are spark ignition (si) and compression
> ignition (ci).

### Versions and Types list:

>  
> <center>
> <table border="0" width="80%">
> <tr bgcolor="#FFFFCC">
> <th>
> component
> </th>
> <th>
> version
> </th>
> <th>
> type
> </th>
> <th>
> description
> </th>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> fuel converter
> </th>
> <td bgcolor="#FFFFFF">
> ic
> </td>
> <td bgcolor="#FFFFFF">
> </td>
> <td bgcolor="#FFFFFF">
> internal combustion engine model in Simulink with look up tables
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> si
> </td>
> <td bgcolor="#CCCCCC">
> spark ignition 
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> ci
> </td>
> <td bgcolor="#CCCCCC">
> compressed ignition
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> fcell
> </td>
> <td>
> </td>
> <td>
> fuel cell model in Simulink
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> net
> </td>
> <td bgcolor="#CCCCCC">
> net power vs. fuel consumption lookup model
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> polar
> </td>
> <td bgcolor="#CCCCCC">
> polarization curve based model
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> gctool
> </td>
> <td bgcolor="#CCCCCC">
> Links to GCTOOL
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td>
> ic\_nn
> </td>
> <td>
>  
> </td>
> <td>
> internal combustion engine model with neural network emissions model
> via s-function
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> ci
> </td>
> <td bgcolor="#CCCCCC">
> compression ignition
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> energy storage
> </th>
> <td>
> rc
> </td>
> <td>
> </td>
> <td>
> Resistance Capacitance Model. Click
> [here](../documentation/ess_rc.html) for details.
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> li
> </td>
> <td bgcolor="#CCCCCC">
> Lithium Ion
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> nimh
> </td>
> <td bgcolor="#CCCCCC">
> Nickel Metal Hydride
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> cap
> </td>
> <td bgcolor="#CCCCCC">
> Ultracapacitor
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> rint
> </td>
> <td>
> </td>
> <td>
> Internal Resistance Battery Model.  Simulink battery model consisting
> of a voltage source and an internal resistor to model the battery
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> pb
> </td>
> <td bgcolor="#CCCCCC">
> Lead-Acid
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> li
> </td>
> <td bgcolor="#CCCCCC">
> Lithium Ion
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> nimh
> </td>
> <td bgcolor="#CCCCCC">
> Nickel Metal Hydride
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> cap
> </td>
> <td bgcolor="#CCCCCC">
> ultra capacitor
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> nicad
> </td>
> <td bgcolor="#CCCCCC">
> Nickel Cadmium
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> NiZn
> </td>
> <td bgcolor="#CCCCCC">
> Nickel Zinc
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> fund
> </td>
> <td>
> </td>
> <td>
> fundamental lead acid battery model
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> fund
> </td>
> <td bgcolor="#CCCCCC">
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> nnet
> </td>
> <td>
> </td>
> <td>
> neural network battery model.
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> nnet
> </td>
> <td bgcolor="#CCCCCC">
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> powertrain control
> </th>
> <td>
> conv
> </td>
> <td>
> </td>
> <td>
> conventional
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> auto
> </td>
> <td bgcolor="#CCCCCC">
> automatic transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> cvt
> </td>
> <td bgcolor="#CCCCCC">
> continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> par
> </td>
> <td>
> </td>
> <td>
> parallel
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> auto
> </td>
> <td bgcolor="#CCCCCC">
> automatic transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> cvt
> </td>
> <td bgcolor="#CCCCCC">
> continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> ser
> </td>
> <td>
> </td>
> <td>
> series
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> ev
> </td>
> <td>
> </td>
> <td>
> ev
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> prius\_jpn
> </td>
> <td>
> </td>
> <td>
> powertrain control for the japanese prius
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> pg
> </td>
> <td bgcolor="#CCCCCC">
> planetary gear continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> insight
> </td>
> <td>
> </td>
> <td>
> insight
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> fc
> </td>
> <td>
> </td>
> <td>
> fuel cell
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> transmission
> </th>
> <td>
> man
> </td>
> <td>
> </td>
> <td>
> manual transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> man
> </td>
> <td bgcolor="#CCCCCC">
> manual transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> auto
> </td>
> <td>
> </td>
> <td>
> automatic transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> auto
> </td>
> <td bgcolor="#CCCCCC">
> automatic transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> cvt
> </td>
> <td>
> </td>
> <td>
> continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> cvt
> </td>
> <td bgcolor="#CCCCCC">
> continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td>
> pgcvt
> </td>
> <td>
> </td>
> <td>
> planetary gear continuously variable transmission
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#CCCCCC">
> </td>
> <td bgcolor="#CCCCCC">
> pgcvt
> </td>
> <td bgcolor="#CCCCCC">
> planetary gear continuously variable transmission
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> wheel
> </th>
> <td>
> Crr
> </td>
> <td>
>  
> </td>
> <td>
> constant coefficient of rolling resistance model
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> Crr
> </td>
> <td bgcolor="#CCCCCC">
> constant coefficient of rolling resistance model
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td>
> J2452
> </td>
> <td>
>  
> </td>
> <td>
> model using SAE J2452 rolling resistance parameters
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> J2452
> </td>
> <td bgcolor="#CCCCCC">
> model using SAE J2452 rolling resistance parameters
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFCC99">
> accessory
> </th>
> <td>
> Const
> </td>
> <td>
>  
> </td>
> <td>
> constant power accessory load models
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> Const
> </td>
> <td bgcolor="#CCCCCC">
> constant power accessory load models
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td>
> Var
> </td>
> <td>
>  
> </td>
> <td>
> variable accessory models (using [configurable
> subsystems](accessory_models2002.html#config_subsystemHOWTO))
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> Spd
> </td>
> <td bgcolor="#CCCCCC">
> variable accessory models (using [configurable
> subsystems](accessory_models2002.html#config_subsystemHOWTO))
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td>
> Saber
> </td>
> <td>
>  
> </td>
> <td>
> saber cosimulation on accessory loads
> </td>
> </tr>
> <tr>
> <th>
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> DV
> </td>
> <td bgcolor="#CCCCCC">
> dual voltage models
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> SV
> </td>
> <td bgcolor="#CCCCCC">
> single voltage models
> </td>
> </tr>
> <tr>
> <th>
> </th>
> <td bgcolor="#FFFFFF">
> Sinda
> </td>
> <td bgcolor="#FFFFFF">
>  
> </td>
> <td bgcolor="#FFFFFF">
> sinda/fluint co-simulation model initialization files
> </td>
> </tr>
> <tr>
> <th bgcolor="#FFFFFF">
>  
> </th>
> <td bgcolor="#CCCCCC">
>  
> </td>
> <td bgcolor="#CCCCCC">
> Sinda
> </td>
> <td bgcolor="#CCCCCC">
> sinda/fluint co-simulation model initialization files
> </td>
> </tr>
> </table>
> </center>
> <p>
> Last Revised: 4/30/2002– mpo \
>  
