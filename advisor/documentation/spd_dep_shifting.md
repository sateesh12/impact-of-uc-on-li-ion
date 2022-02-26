% Vehicle-Speed Dependant Shifting
% 
% 

Vehicle-Speed Dependent Shift Control
=====================================

In order to more closely recreate the results of dynamometer testing, a
vehicle-speed dependent shift control has been implemented in version
3.2 of ADVISOR. Vehicle-speed dependent shifting is activated using a
boolean flag variable, tx\_speed\_dep. When tx\_speed\_dep is equal to
1, vehicle-speed dependent shifting is used. When tx\_speed\_dep is
equal to 0, the default control strategy of ADVISOR is used for
shifting.

The information required to use vehicle-speed dependent shifting is
contained in the powertrain control (PTC\_\*.m) files. There are two
matrices that determine the vehicle-speed dependent shifting control.
One matrix is for up-shifting and is called tx\_spd\_dep\_upshift. The
other matrix is for down-shifting and is called tx\_spd\_dep\_dnshift.
Both matrices have two columns: the first column contains vehicle speed
in meters/second. The second column contains gear number (i.e., 1 for
1st gear, 2 for 2nd gear, etc.).

<p>
It is important that both tx\_spd\_dep\_upshift and
tx\_spd\_dep\_dnshift be specified as step-functions. In matlab, this is
done by repeating the x-coordinate (speed) twice for each y-coordinate
(gear) of the step. For example, if we have a 3-speed transmission that
upshifts from 1st to 2nd when crossing 15 mph, and from 2nd to 3rd when
crossing 45 mph, we would specify tx\_spd\_dep\_upshift as follows:

<center>
<p>
tx\_spd\_dep\_upshift = [0 1; 15\*0.4470 1; 15\*0.4470 2; 45\*0.4470 2;
45\*0.4470 3; 1000\*0.4470 3];

</center>
<p>
Note that the factor 0.4470 is used to convert from mph to m/s. A value
of 1000 mph is used at the end of the vector since the vehicle is never
expected to reach or exceed 1000 mph. Users new to this format for
specifying step-functions may be helped by plotting the above:

<center>
<p>
figure, plot(tx\_spd\_dep\_upshift(:,1), tx\_spd\_dep\_upshift(:,2)),
axis([0 100 0 4])

</center>
The difference between vehicle-speed dependent shifting and the ADVISOR
default shifting control can be seen by setting tx\_speed\_dep to 0 and
checking the variable, new\_gear\_ratio, available under component \>
other on the Results screen.

Vehicle-speed dependent shifting is implemented in lib\_controls.mdl in
the folder \<ADVISOR main directory\>/models/library/.

Vehicle-speed dependent shifting is currently available for all
powertrains except for CVT powertrains and the Toyota Prius powertrain.
\

* * * * *

<center>
[Return to ADVISOR Documentation](advisor_doc.html) \

* * * * *

</center>
Last revision: [12-July-2001] mpo \
  \
 
