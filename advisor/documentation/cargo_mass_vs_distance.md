% cargo\_mass\_vs\_distance
% 
% 

Variable Cargo Mass Specification for Drive Cycle
=================================================

A new functionality has been added to the ADVISOR drive cycle–variable
cargo mass versus distance traveled. A new variable called
cyc\_cargo\_mass is defined in the cyc\_\*.m files. The variable is a
two-column matrix specifying distance traveled since the start of the
simulation (units of meters) in the first column and cargo mass
corresponding to that distance in the second column (units of kg).

In the Simulink block diagrams, variable cargo mass is implemented with
a repeating table (see lib\_drive\_cycle for details). The variable
cargo mass has been implemented primarily for heavy vehicle applications
(e.g., loading/unloading of vehicle cargo/freight vs. distance, the
loading/unloading of passengers on a transit bus, etc.).

Upon completion of the drive-cycle, the variable
veh\_cargo\_mass\_vs\_time will be available (selectable from the GUI
pull-down menu on the ‘Results’ screen). The variable
‘veh\_cargo\_mass\_vs\_time’ is an array of the cargo mass for each time
step throughout the simulation (units of kg). The energy usage figure
takes the variable cargo mass into account when determining values such
as rolling resistance.

A drive cycle which takes advantage of the variable cargo mass
functionality has been added to ADVISOR version 3.2:
CYC\_UKBUS\_MASS\_VAR1. This cycle uses actual data for a typical London
bus trip. Variable passenger mass has been calculated with a head count
assuming 75 kg per person. This cycle has been graciously provided by
Newbus Technologies, UK.

Note: the original intention of the cyc\_cargo\_mass variable was to
specify cargo vs. distance. Negative values of cargo mass can be
specified, though the user must take care not to cancel out total
vehicle weight.

* * * * *

<center>
[Return to ADVISOR Documentation](advisor_doc.html) \

* * * * *

</center>
Last revision: [12-July-2001] mpo \
  \
 
