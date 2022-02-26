% The Control Strategy
% 
% 

<a name="_Toc2592697">The Fuzzy Logic Emissions and Fuel Use Control Strategy</a>
---------------------------------------------------------------------------------

 This control strategy was developed by Ohio State University under a
subcontract with NREL.  Information for this help file was taken from
the final technical report entitled “Development of Fuzzy Logic and
Neural Network Control and Advanced Emissions Modeling for Parallel
Hybrid Vehicle” which provides additional detail on the model and is
available in the [ADVISOR reading
room](http://www.ctts.nrel.gov/analysis/reading_room.html).  The fuzzy
emissions control strategy involves calculating the torque produced by
the IC Engine based on various parameters such as road-load and battery
SOC. This includes the calculation of an optimal torque based on
contending IC Engine parameters such as fuel use and emissions, and
deciding the actual torque output by later modifying the optimal torque
based on road load and battery SOC. The control strategy is made
scalable, and can be used with any parallel HEV model in ADVISOR. The
controller programs are created using MATLAB script files, and can be
modified by the user. The following
<span style="mso-field-code:&quot;REF _Ref536568354 \\h&quot;">Figure
1<!--[if gte mso 9]><xml>
 <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E0000005F005200650066003500330036003500360038003300350034000000</w:data>
</xml><![endif]--> </span> indicates the position of the Fuzzy Logic
Controller in the Simulink block in ADVISOR.

 <o:p> </o:p>

<!--[if gte vml 1]><v:shapetype id="_x0000_t75"
 coordsize="21600,21600" o:spt="75" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe"
 filled="f" stroked="f">
 <v:stroke joinstyle="miter"/>
 <v:formulas>
  <v:f eqn="if lineDrawn pixelLineWidth 0"/>
  <v:f eqn="sum @0 1 0"/>
  <v:f eqn="sum 0 0 @1"/>
  <v:f eqn="prod @2 1 2"/>
  <v:f eqn="prod @3 21600 pixelWidth"/>
  <v:f eqn="prod @3 21600 pixelHeight"/>
  <v:f eqn="sum @0 0 1"/>
  <v:f eqn="prod @6 1 2"/>
  <v:f eqn="prod @7 21600 pixelWidth"/>
  <v:f eqn="sum @8 21600 0"/>
  <v:f eqn="prod @7 21600 pixelHeight"/>
  <v:f eqn="sum @10 21600 0"/>
 </v:formulas>
 <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
 <o:lock v:ext="edit" aspectratio="t"/>
</v:shapetype><v:shape id="_x0000_i1025" type="#_x0000_t75" style='width:6in;
 height:210.75pt'>
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image001.png"
  o:title="bd1"/>
</v:shape><![endif]--> ![](fuzzye21.jpg)

                                        <span style="mso-bookmark:
_Toc2571100"> Figure 1. Base block diagram with fuzzy controller</span>

 <o:p> </o:p>

The structure of the Fuzzy Controller is shown below in
<span style="mso-field-code:&quot;REF _Ref536568364 \\h&quot;">Figure
2<!--[if gte mso 9]><xml>
 <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E0000005F005200650066003500330036003500360038003300360034000000</w:data>
</xml><![endif]--> </span>.

 <o:p> </o:p>

<!--[if gte vml 1]><v:shape id="_x0000_i1026" type="#_x0000_t75"
 style='width:431.25pt;height:3in'>
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image003.png"
  o:title="bd2"/>
</v:shape><![endif]--> ![](fuzzye22.jpg)

<a name="_Toc2571101"><span style="mso-bookmark:_Ref536568364">Figure
</span></a><!--[if supportFields]><span
style='mso-bookmark:_Toc2571101'><span style='mso-bookmark:_Ref536568364'></span></span><span
style='mso-element:field-begin'></span><span style='mso-bookmark:_Toc2571101'><span
style='mso-bookmark:_Ref536568364'><span style="mso-spacerun: yes"> </span>SEQ
Figure \* ARABIC <span style='mso-element:field-separator'></span></span></span><![endif]-->
<span style="mso-bookmark: _Ref536568364">2</span><!--[if supportFields]><span
style='mso-bookmark:_Toc2571101'><span style='mso-bookmark:_Ref536568364'></span></span><span
style='mso-element:field-end'></span><![endif]-->
<span style="mso-bookmark:
_Toc2571101">:
</span><span style="font-weight: normal; mso-bookmark: _Toc2571101">Fuzzy
Controller block components</span><span style="font-weight:normal"><o:p>
</o:p> </span>

 <o:p> </o:p>

### <a name="_Toc2592698">Optimal Torque Computation</a>

 The data for an IC Engine in ADVISOR is in the form of a 2-dimensional
map, indexed by torque and speed. Information regarding fuel economy
(g/s) and emissions such as CO, HC and NO~X~ (g/s) is available for
various speeds and torques. Shown below as a sample are the fuel use and
emissions data for a 1.9L Turbo Diesel Engine available in ADVISOR.

 <o:p> </o:p>

<!--[if gte vml 1]><v:shape
 id="_x0000_i1027" type="#_x0000_t75" style='width:423pt;height:324.75pt'>
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image005.png"
  o:title="emissions_4x2" croptop="1820f" cropbottom="3641f" cropleft=".0625"
  cropright="2731f"/>
</v:shape><![endif]--> ![MATLAB Handle Graphics](fuzzye23.jpg)

<a name="_Toc2571102"><span style="mso-bookmark:_Ref1484900">Figure
</span></a><!--[if supportFields]><span
style='mso-bookmark:_Toc2571102'><span style='mso-bookmark:_Ref1484900'></span></span><span
style='mso-element:field-begin'></span><span style='mso-bookmark:_Toc2571102'><span
style='mso-bookmark:_Ref1484900'><span style="mso-spacerun: yes"> </span>SEQ
Figure \* ARABIC <span style='mso-element:field-separator'></span></span></span><![endif]-->
3<span style="mso-bookmark:
_Toc2571102">: IC Engine emissions – a general trend</span>

 <o:p> </o:p>

As seen in the above figure, we can determine the parameters at all
torques for any given speed, up to the maximum torque point.

 The process of finding an optimal point is shown in
<span style="mso-field-code:&quot;REF _Ref536568404 \\h&quot;">Figure
4<!--[if gte mso 9]><xml>
 <w:data>08D0C9EA79F9BACE118C8200AA004BA90B02000000080000000E0000005F005200650066003500330036003500360038003400300034000000</w:data>
</xml><![endif]--> </span> below.

 <o:p> </o:p>

<!--[if gte vml 1]><v:shape
 id="_x0000_i1028" type="#_x0000_t75" style='width:6in;height:73.5pt'>
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image007.png"
  o:title="opt_trq1"/>
</v:shape><![endif]--> ![](fuzzye24.jpg)

<a name="_Toc2571103"><span style="mso-bookmark:_Ref536568404">Figure
</span></a><!--[if supportFields]><span
style='mso-bookmark:_Toc2571103'><span style='mso-bookmark:_Ref536568404'></span></span><span
style='mso-element:field-begin'></span><span style='mso-bookmark:_Toc2571103'><span
style='mso-bookmark:_Ref536568404'><span style="mso-spacerun: yes"> </span>SEQ
Figure \* ARABIC <span style='mso-element:field-separator'></span></span></span><![endif]-->
<span style="mso-bookmark: _Ref536568404">4</span><!--[if supportFields]><span
style='mso-bookmark:_Toc2571103'><span style='mso-bookmark:_Ref536568404'></span></span><span
style='mso-element:field-end'></span><![endif]-->
<span style="mso-bookmark:
_Toc2571103">: Finding an optimal IC Engine operating point</span>

 <o:p> </o:p>

The four competing parameters in the determination of an optimum are
fuel efficiency, NO~X~, CO and HC emissions. At any particular point in
time, the simulation determines a speed of rotation for the IC Engine
(based on the powertrain configuration and the current gear ratio). This
is the speed at which the “instantaneous” optimization is performed. For
the current speed, all possible torques that the IC Engine can provide
are considered. The four competing parameters for all torques at the
current speed are taken from the data maps.

 <o:p> </o:p>

<span style="mso-text-raise:-6.0pt"><!--[if gte vml 1]><v:shape
 id="_x0000_i1029" type="#_x0000_t75" style='width:280.5pt;height:24.75pt'
 o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image009.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image010.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye25.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1029"
  DrawAspect="Content" ObjectID="_1081670708">
 </o:OLEObject>
</xml><![endif]-->
<span style="mso-tab-count:3">                          
</span>(<!--[if supportFields]><span
style='mso-element:field-begin'></span> SEQ Equation \* ARABIC <span
style='mso-element:field-separator'></span><![endif]-->
1<!--[if supportFields]><span
style='mso-element:field-end'></span><![endif]--> )

<span style="mso-tab-count:1">           </span>

where <span style="mso-tab-count:1">  </span>J
<span style="mso-tab-count:1">          </span>=
<span style="mso-tab-count:1">         </span>cost function\

<span style="mso-spacerun: yes"> </span><span style="mso-tab-count:1">          
</span><span style="mso-text-raise:-6.0pt"><!--[if gte vml 1]><v:shape id="_x0000_i1030"
 type="#_x0000_t75" style='width:12pt;height:15.75pt' o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image012.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image013.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye26.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1030"
  DrawAspect="Content" ObjectID="_1081670709">
 </o:OLEObject>
</xml><![endif]-->
<span style="mso-spacerun: yes"> </span><span style="mso-tab-count:1">      
</span>= <span style="mso-tab-count:1">         </span>weights,
i=1,2,3,4\
 <span style="mso-tab-count:1">           
</span><span style="mso-text-raise:
-5.0pt"><!--[if gte vml 1]><v:shape id="_x0000_i1031" type="#_x0000_t75"
 style='width:8.25pt;height:16.5pt' o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image015.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image016.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye27.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1031"
  DrawAspect="Content" ObjectID="_1081670710">
 </o:OLEObject>
</xml><![endif]--> <span style="mso-spacerun: yes"> 
</span><span style="mso-tab-count:1">       </span>=
<span style="mso-tab-count:1">         </span>Normalized efficiency\
 <span style="mso-tab-count:1">           
</span><span style="mso-text-raise:
-5.0pt"><!--[if gte vml 1]><v:shape id="_x0000_i1032" type="#_x0000_t75"
 style='width:24.75pt;height:16.5pt' o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image018.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image019.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye28.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1032"
  DrawAspect="Content" ObjectID="_1081670711">
 </o:OLEObject>
</xml><![endif]-->
<span style="mso-spacerun: yes"> </span><span style="mso-tab-count:1">  
</span>= <span style="mso-tab-count:1">         </span>Normalized NO~X~
emissions

<span style="mso-tab-count:1">           
</span><span style="mso-text-raise:-3.0pt"><!--[if gte vml 1]><v:shape id="_x0000_i1033"
 type="#_x0000_t75" style='width:17.25pt;height:15pt' o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image021.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image022.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye29.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1033"
  DrawAspect="Content" ObjectID="_1081670712">
 </o:OLEObject>
</xml><![endif]--> <span style="mso-tab-count:1">     
</span>=<span style="mso-tab-count:1">          </span>Normalized CO
emissions

<span style="mso-tab-count:1">           
</span><span style="mso-text-raise:-3.0pt"><!--[if gte vml 1]><v:shape id="_x0000_i1034"
 type="#_x0000_t75" style='width:18pt;height:15pt' o:ole="">
 <v:imagedata src="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image024.wmz"
  o:althref="../../../../../../../../DOCUME~1/kkelly/LOCALS~1/Temp/msoclip1/01/clip_image025.pcz"
  o:title=""/>
</v:shape><![endif]--> ![](fuzzye30.gif)</span><!--[if gte mso 9]><xml>
 <o:OLEObject Type="Embed" ProgID="Equation.3" ShapeID="_x0000_i1034"
  DrawAspect="Content" ObjectID="_1081670713">
 </o:OLEObject>
</xml><![endif]--> <span style="mso-tab-count:1">     
</span>=<span style="mso-tab-count:1">          </span>Normalized HC
emissions

 <o:p> </o:p>

Here, the values are normalized with respect to the maximum for that
particular speed. Relative weights are assigned to each parameter based
on their importance. This is one large degree of freedom, and the
weights must be selected for each IC engine based on their individual
data maps. For our example in the report, we use the following default
weights.

 <o:p> </o:p>

<table border="1" cellspacing="0" cellpadding="0" style="margin-left:113.4pt;
 border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-padding-alt:0in 5.4pt 0in 5.4pt">
<tr>
<td width="132" valign="top" style="width:99.0pt;border:solid windowtext .5pt;
  background:#B3B3B3;padding:0in 5.4pt 0in 5.4pt">
**Parameter<o:p> </o:p>**

</td>
<td width="108" valign="top" style="width:81.0pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;background:#B3B3B3;
  padding:0in 5.4pt 0in 5.4pt">
**Weight<o:p> </o:p>**

</td>
</tr>
<tr>
<td width="132" valign="top" style="width:99.0pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
Efficiency

</td>
<td width="108" valign="top" style="width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
0.7

</td>
</tr>
<tr>
<td width="132" valign="top" style="width:99.0pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
NO~X~

</td>
<td width="108" valign="top" style="width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
0.3

</td>
</tr>
<tr>
<td width="132" valign="top" style="width:99.0pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
CO

</td>
<td width="108" valign="top" style="width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
0.1

</td>
</tr>
<tr>
<td width="132" valign="top" style="width:99.0pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
HC

</td>
<td width="108" valign="top" style="width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
0.1

</td>
</tr>
</table>
<a name="_Toc2571128"><span style="mso-bookmark:_Ref536568598">Table
</span></a><!--[if supportFields]><span
style='mso-bookmark:_Toc2571128'><span style='mso-bookmark:_Ref536568598'></span></span><span
style='mso-element:field-begin'></span><span style='mso-bookmark:_Toc2571128'><span
style='mso-bookmark:_Ref536568598'><span style="mso-spacerun: yes"> </span>SEQ
Table \* ARABIC <span style='mso-element:field-separator'></span></span></span><![endif]-->
<span style="mso-bookmark: _Ref536568598">1</span><!--[if supportFields]><span
style='mso-bookmark:_Toc2571128'><span style='mso-bookmark:_Ref536568598'></span></span><span
style='mso-element:field-end'></span><![endif]-->
<span style="mso-bookmark:
_Toc2571128">: Default weights in the control strategy</span>

 The above weights provide an optimum based heavily on efficiency and
NO~X~, while CO and HC are also considered. These weights can be varied
during the operation of the vehicle, based on certain vehicle
parameters.

### 

###  <a name="_Toc2592715">Implementation in ADVISOR</a>

The Fuzzy Emissions control strategy contains the following files and
variables.

 <o:p> </o:p>

<table border="1" cellspacing="0" cellpadding="0" style="border-collapse:collapse;
 border:none;mso-border-alt:solid windowtext .5pt;mso-padding-alt:0in 5.4pt 0in 5.4pt">
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  background:#B3B3B3;padding:0in 5.4pt 0in 5.4pt">
**File name<o:p> </o:p>**

</td>
<td width="345" valign="top" style="width:259.0pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;background:#B3B3B3;
  padding:0in 5.4pt 0in 5.4pt">
**Function<o:p> </o:p>**

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
fuzzy\_emissions\_in.m

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
Input file in ADVISOR 3.2 which contains the emissions control strategy
vehicle configuration to be loaded with the GUI.

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
bd\_fuzzy\_emissions.mdl

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
The main block diagram that is used when the new fuzzy logic controller
(ptc\_fuzzy\_emissions.m) is selected from the GUI interface

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
fuzzy\_target\_compute\_emissions.m

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
Calculate the optimal torque for a given IC Engine speed, based on a set
of weights. Also varies the weights based on vehicle parameters.

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
ptc\_fuzzy\_emissions.m

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
This file contains the powertrain control variables, including the
battery SOC limits. When selected, uses the file
bd\_fuzzy\_emissions.mdl to simulate the vehicle.

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
mfuzzy\_emissions.m

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
The main Fuzzy Logic Controller which takes in the optimal torque and
SOC as inputs and gives the actual torque as the output. This is used to
shift the calculated optimal torque point based on the driver’s request
and the Battery SOC. Care is taken to control the deviation to a
minimum, since a large correction from optimal destroys the purpose of
optimization. The rule-base can be modified by the user if desired.

</td>
</tr>
<tr>
<td width="245" valign="top" style="width:183.8pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt">
Block\_diagram\_name.m

</td>
<td width="345" valign="top" style="width:259.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt">
Modifications are made to this file so as to enable the respective fuzzy
logic Simulink blocks to be used, when the fuzzy powertrain controller
is selected.

</td>
</tr>
</table>
<a name="_Toc2571136">Table </a><!--[if supportFields]><span
style='mso-bookmark:_Toc2571136'></span><span style='mso-element:field-begin'></span><span
style='mso-bookmark:_Toc2571136'><span style="mso-spacerun: yes"> </span>SEQ
Table \* ARABIC <span style='mso-element:field-separator'></span></span><![endif]-->
<span style="mso-bookmark: _Toc2571136">2</span><!--[if supportFields]><span
style='mso-bookmark:_Toc2571136'></span><span style='mso-element:field-end'></span><![endif]-->
<span style="mso-bookmark:_Toc2571136">: Files added in ADVISOR 3.2 –
Emissions control</span>
