% Energy Storage System
% 
% 

### **Energy Storage System**

**<u>Introduction</u>** \
Of all the components in a hybrid vehicle, batteries are probably the
most difficult to understand and model.  Although batteries seem to act
like simple electrical energy storage devices, when they deliver and
accept energy, they actually undergo thermally-dependent electrochemical
processes that make them difficult to model.  Thus, the electrical
behavior of a battery is a nonlinear function of a variety of constantly
changing parameters. A dynamic model of electrochemical battery behavior
is a compromise between trying to include all of the relevant effects
and creating a model that will actually work in a reasonable amount of
time.

ADVISOR has four different battery models.

1.  The most recently developed model (Spring, 2001) is the [RC
    model](ess_rc.html) (’resistive-capacitive’), which includes
    transient effects in the battery.
2.  The previous model is the [Rint Model](ess_rint.html) (’internal
    resistance’), which characterizes the battery with a voltage source
    and internal resistance.The Rint battery model is related to work
    which was originally performed by Idaho National Engineering
    Laboratory to model flooded lead-acid batteries.  ADVISOR uses this
    basic structure to roughly simulate the behavior of a variety of
    battery technologies.
3.  The third battery model is a [Fundamental Lead Acid
    Model](ess_alt_models.html#Fundamental) developed at Brigham Young
    University for NREL.
4.  The fourth model is a [neural network
    model](ess_alt_models.html#Neural%20Network) of a lead acid battery
    developed at Colorado University for NREL.

[RC Model](ess_rc.html) \
[Rint Model](ess_rint.html) \
[Fundamental Lead Acid Model](ess_alt_models.html#Fundamental) \
[Neural Network Model](ess_alt_models.html#Neural%20Network)

Additionally, ADVISOR has one carbon-based ultracapacitor model.

A recent addition (Spring, 2002) to the energy storage system library in
ADVISOR is the ultracapacitor (double layer capacitor, electrochemical
capacitor).  Although the ultracapacitor is a device that is very
similar to batteries in many respects (electrodes, liquid electrolyte,
and separator are main components), it is also fundamentally different
in how it accomplishes energy storage/supply (double-layer capacitance
and depending on the chemical make-up of the ultracapacitor a varying
extent of pseudo-capacitance).  The ultracapacitor model developed for
ADVISOR is derived from the behavior of carbon-based (double-layer)
devices.  The similarity between batteries and ultracapacitors allows
for a fair amount of overlap between modeling the two devices.  However,
the main difference in modeling the two devices is that the
ultracapacitor actually behaves more ideally as a resistance +
capacitance based device.  This allows for relatively close model
behavior without compromising actual device behavior.  Additionally, due
to the relatively straightforward capacitance model, the
ultracapacitor’s state of charge is very simple to determine.

The [UltraCap model](ess_uc.html) resides with the RC model drop down
selections within ADVISOR’s gui in the “energy storage” block under
version “rc” and then under type “cap” (rc-\>cap).

[UltraCap Model](ess_uc.html)

 

* * * * *

<center>
[Back to Chapter 3](advisor_ch3.html)

</center>
<p>
Last Revised: 4/29/02: mdz
