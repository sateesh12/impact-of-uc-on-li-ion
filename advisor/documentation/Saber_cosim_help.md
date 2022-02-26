% aux\_loads\_help
% 
% 

<div class="Section1">
<!DOCTYPE html> Saber Co-simulation Help<span style="font-size:12.0pt"><o:p></o:p></span>
=========================================================================================

![](Saber_cosim_help_files/link.gif)<!--[if !vml]--><!--[endif]-->

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

[Overview](#_Overview)

[ADVISOR/Saber Co-simulation
Requirements](#_ADVISOR/Saber_Co-simulation_Requirement)

[Using Existing ADVISOR/Saber Co-Simulation
Configurations](#_Using_Existing_ADVISOR/Saber)

[Creating A Custom Co-simulation](#_Creating_A_Custom)

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

<a name="_Overview"></a>Overview
--------------------------------

The ADVISOR/Saber co-simulation improves and expands ADVISOR’s electric
modeling capability.<span style="mso-spacerun: yes">  </span>It improves
ADVISOR by providing the option for a more detailed voltage and current
based analysis to capture fluctuations in the electrical power
bus.<span style="mso-spacerun: yes">  </span>It expands ADVISOR by
providing the capability to use industry-contributed models and Saber
library models in ADVISOR.<span style="mso-spacerun: yes">  </span>These
models include:

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Industry-contributed:

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Generator

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->DC/DC Converter

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Regulator

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Many Electrical Loads

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Saber library

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Lead Acid / Lithium Ion Batteries

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Integrated Starter Generator, Alternator,
Crankshaft Mounted Generators

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Electrical Load Models And Characterization
Tools

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Behavioral To Detailed Electronic, Digital,
Electrical, Mechanical, Hydraulic, and Pneumatic System Models

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Top Down DC/DC Converters (Behavioral To
Physical Models)

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Bus Systems (CAN, FlexRay, TTP Etc.)

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Power Management System

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->PEM And SOFC Fuel Cells (Models And Building
Blocks)

<!--[if !supportLists]--><span style="font-family:&quot;Courier New&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;">o<span style="font:7.0pt &quot;Times New Roman&quot;">      
</span></span><!--[endif]-->Over 150 Complete Automotive Systems (From
ABS To X-By-Wire)

Using models from both industry and the Saber library, additional
vehicle configurations have been created:

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Conventional, single voltage vehicle
including a battery, generator, and electrical loads:

![](Saber_cosim_help_files/sv_config.gif)<!--[if !vml]--><!--[endif]-->

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">1</span>.<span style="mso-spacerun: yes"> 
</span>Electrical Portion of Single Voltage Vehicle Configuration.

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Conventional (14V/42V) dual voltage vehicle
configuration:

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

![](Saber_cosim_help_files/dv_config.gif)<!--[if !vml]--><!--[endif]-->

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">2</span>.<span style="mso-spacerun: yes"> 
</span>Electrical Portion of Dual Voltage Vehicle Configuration

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Parallel electric hybrid vehicle
configuration:

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

![](Saber_cosim_help_files/par_config.jpg)<!--[if !vml]--><!--[endif]-->

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">3</span>.<span style="mso-spacerun: yes"> 
</span>Electrical Portion of Parallel Hybrid Electric Vehicle
Configuration

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Series electric hybrid vehicle
configuration:

<!--[if !vml]--><!--[endif]-->![](Saber_cosim_help_files/ser_config.jpg)

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">4</span>.<span style="mso-spacerun: yes"> 
</span>Electrical Portion of Series Hybrid Electric Vehicle
Configuration

<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

<a name="_ADVISOR/Saber_Co-simulation_Requirement"></a>ADVISOR/Saber Co-simulation Requirements
-----------------------------------------------------------------------------------------------

### Co-simulation Requirements:

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Standard Saber License

<!--[if !supportLists]--><span style="font-family:Symbol">·<span style="font:7.0pt &quot;Times New Roman&quot;">       
</span></span><!--[endif]-->Optional Template Library License or Vehicle
Electric Library License

### How To Get Saber

If you want Saber please contact:

[<span style="font-family:Times">http://www.avanticorp.com/sales</span>](http://www.avanticorp.com/sales)

or mailto:

[<span style="font-family:Times">saber-info@avanticorp.com</span>](saber-info@avanticorp.com)

<a name="_Using_Existing_ADVISOR/Saber"></a>Using Existing ADVISOR/Saber Co-Simulation Configurations
-----------------------------------------------------------------------------------------------------

<!--[if !vml]--><!--[endif]-->![](Saber_cosim_help_files/inputfig.gif)

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">5</span>.<span style="mso-spacerun: yes"> 
</span>Selecting ADVISOR/Saber
co-simulation.<span style="font-weight:normal"><o:p></o:p></span>

### Choose Saved Vehicle Configuration

An ADVISOR/Saber co-simulation is run by selecting a “saber\_\*” saved
vehicle on the load file menu from the “Vehicle Input” screen, such as
CONV\_cosim\_dv\_in (dual voltage) seen in Figure
3.<span style="mso-spacerun: yes">  </span>Choosing a saved vehicle
configuration automatically makes the correct combination of component
selections.<span style="mso-spacerun: yes">  </span>These menu
selections define parameters that correspond to the models created in
Saber.<span style="mso-spacerun: yes">  </span>The parallel Saber model
includes a 14-volt and a high voltage battery, a motor, and Saber
auxiliary load models.

When choosing one of the “saber” drivetrain configurations, ADVISOR will
only allow appropriate component
selections.<span style="mso-spacerun: yes">  </span>The mapping for
these selections are outlined in Table 1.

<div align="center">
<table border="1" cellspacing="0" cellpadding="0" style="border-collapse:collapse;
 border:none;mso-border-alt:solid windowtext .5pt;mso-padding-alt:0in 5.4pt 0in 5.4pt">
<tr style="height:31.35pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:31.35pt">
**Load File (Saved Vehicle Name)<o:p></o:p>**

</td>
<td width="173" valign="top" style="width:129.8pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:31.35pt">
**Components<o:p></o:p>**

</td>
<td width="172" valign="top" style="width:128.7pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:31.35pt">
**Valid Versions<o:p></o:p>**

</td>
<td width="170" valign="top" style="width:127.85pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:31.35pt">
**Valid Types<o:p></o:p>**

</td>
<td width="177" valign="top" style="width:132.95pt;border:solid windowtext .5pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:31.35pt">
**Valid File Names<o:p></o:p>**

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Conv\_cosim\_dv\_in

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage (HiV)

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber2

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
pb

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage 2 (12v)

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
pb

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Generator (HiV)

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Accessory

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabDV

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Powertrain Control

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabDV

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
man

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
PTC\_CONV\_Saber\_dv

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Torque Coupling

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
TC\_GC\_TO\_FC

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
Conv\_cosim\_sv\_in

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage 2

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
pb

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Generator

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Accessory

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabSV

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Conv

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Powertrain Control

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabSV

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
man

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
PTC\_CONV\_Saber\_sv

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Torque Coupling

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
TC\_GC\_TO\_FC

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
SER\_Saber\_Cosim\_in

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber2

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage 2

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
pb

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all, scale voltage to 12v

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Generator

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
reg

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
reg

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Accessory

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Var

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Const

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;background:#E0E0E0;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Powertrain Control

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabSer

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
man

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  background:#E0E0E0;padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
PAR\_Saber\_Cosim\_in

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber2

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Energy Storage 2

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
saber

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
pb

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
rint

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all, scale voltage to 12v

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Accessory

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabPar

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Var

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Const

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Powertrain Control

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
sabPar

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
man

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
PTC\_PAR\_Saber

</td>
</tr>
<tr style="height:15.6pt">
<td width="196" valign="top" style="width:146.65pt;border:solid windowtext .5pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:15.6pt">
<!--[if !supportEmptyParas]--> <!--[endif]--><o:p></o:p>

</td>
<td width="173" valign="top" style="width:129.8pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
Torque Coupling

</td>
<td width="172" valign="top" style="width:128.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="170" valign="top" style="width:127.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
-

</td>
<td width="177" valign="top" style="width:132.95pt;border-top:none;border-left:
  none;border-bottom:solid windowtext .5pt;border-right:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.6pt">
all but TC\_GC\_TO\_FC

</td>
</tr>
</table>
</div>
Table
<span style="mso-field-code:&quot;SEQ Table \\* ARABIC&quot;">1</span>.<span style="mso-spacerun: yes"> 
</span>Valid selections for each Saber co-simulation configuration
(saved vehicle file).

### Define The Simulation

After defining the vehicle inputs, “continue” to the Simulation Setup
Figure.<span style="mso-spacerun: yes">  </span>On that screen, the
[auxiliary loads](aux_loads_help.html), drive cycle, and other simulation
parameters can be modified.<span style="mso-spacerun: yes">  </span>For
running test procedures, we recommend first selecting the drive cycle
radio button.<span style="mso-spacerun: yes">  </span>This allows the
SOC balancing iterations to be changed to
1.<span style="mso-spacerun: yes">  </span>Then select the test
procedure.<span style="mso-spacerun: yes">  </span>This prevents SOC
balancing iterations, which may not be needed or desired for
co-simulation runs.<span style="mso-spacerun: yes">  </span>

### Run The Simulation

Finally, make sure Saber is not open, and click
“Run.”<span style="mso-spacerun: yes">  </span>ADVISOR opens and runs
Saber exchanging information between Saber and ADIVSOR at every ADVISOR
time step.<span style="mso-spacerun: yes">  </span>At the end of the
simulations, Saber is closed and ADVISOR displays the co-simulation
results from both Saber and ADVISOR.

<a name="_Creating_A_Custom"></a>Creating A Custom Co-Simulation
----------------------------------------------------------------

### Overview

![](Saber_cosim_help_files/custom_cosim.gif)<!--[if !vml]--><!--[endif]-->

Figure
<span style="mso-field-code:&quot;SEQ Figure \\* ARABIC&quot;">6</span>.<span style="mso-spacerun: yes"> 
</span>Custom co-simulation structure overview.

The general structure of the co-simulation can be seen in Figure
4.<span style="mso-spacerun: yes">  </span>The three numbered
requirements in the figure include:

<!--[if !supportLists]-->1.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->Input parameter lists that correspond to Simulink
inputs to Saber.<span style="mso-spacerun: yes">  </span>

<!--[if !supportLists]-->2.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->An output parameter list that corresponds to Saber
outputs to Simulink.

<!--[if !supportLists]-->3.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->The name of the input/output list file as the third
S-function parameter (for ADVISOR co-simulations, the first parameter is
“vinf.tmppath” and the second is
“time\_step.”<span style="mso-spacerun: yes">  </span>The S-function
name is always “SaberCosimSfun.”)

### Steps To Create A Custom Co-Simulation

<!--[if !supportLists]-->1.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->**Copy
SaberCosimIO\_Template**.<span style="mso-spacerun:
yes">  </span>Open and save a copy of the file
“…advisor\\gui\\SaberCosim\\SaberCosimIO\_Template” with a unique
name.<span style="mso-spacerun: yes">  </span>For the example, save it
as “SaberCosimIO\_Example.”

<!--[if !supportLists]-->2.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->**Assign Input Parameter List,
InputSaberParams**.<span style="mso-spacerun: yes">  </span>Fill in the
empty “InputSaberParams” list with Saber parameter
names.<span style="mso-spacerun: yes">  </span>Follow the format as
specified in the copied file (example:<span style="mso-spacerun:
yes">  </span>‘primitive.ref = ParameterName
=’).<span style="mso-spacerun:
yes">  </span>For the example change “InputSaberParams={’ ’};” to
“InputSaberParams={’radio.radio1 = loadcontrol = ‘,’radio.radio1 =
vehicletype =’};”

<!--[if !supportLists]-->3.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->**Assign Output Parameter List,
OutputSaberValues**.<span style="mso-spacerun: yes">  </span>Fill in the
empty “OutputSaberValues” list with Saber parameter names that need to
be output from Saber to ADVISOR.<span style="mso-spacerun: yes"> 
</span>Follow the format as specified in the copied file
(example:<span style="mso-spacerun: yes"> 
</span>‘mech\_pwr(generator\_generic.generator\_generic\_42v)’). For the
example change “OutputSaberValues={’’};” to
“OutputSaberValues={’power(power\_meter.generator)’,’p\_radio(radio.radio1)’,’i(radio.radio1)’};”

<!--[if !supportLists]-->4.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->**Create the Simulink
Model**.<span style="mso-spacerun:
yes">  </span>Add a S-function block to a SIMULINK model where
communication between Simulink and Saber should
occur.<span style="mso-spacerun: yes">  </span>Similar to Figure 4, the
inputs and outputs to the S-function should be in the same order as the
parameters in the input and output
lists.<span style="mso-spacerun: yes">  </span>For the example, create a
SIMULINK model as seen in Figure 4.<span style="mso-spacerun: yes"> 
</span>The “radio loadcontrol” block is a “to workspace”
block.<span style="mso-spacerun: yes">  </span>The “radio vehicletype”
block is a constant block.<span style="mso-spacerun: yes">  </span>These
input blocks go to a “Horizontal Matrix Concatenation” block, then a
“S-function” block, then a “demux” block, and finally three
“scopes.”<span style="mso-spacerun: yes">  </span>Double click the
“Horizontal Matrix Concatenation” block to change the number of inputs
to two.<span style="mso-spacerun: yes">  </span>Double click the “demux”
block to change the number of outputs to three.

<!--[if !supportLists]-->5.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->**Assign the Parameters for the
S-Function**.<span style="mso-spacerun: yes">  </span>Double click the
S-function block that will control the
co-simulation.<span style="mso-spacerun: yes">  </span>A “Block
Parameters” dialog opens.<span style="mso-spacerun: yes">  </span>Change
the “S-function name:” to
“SaberCosimSfun.”<span style="mso-spacerun: yes">  </span>Three comma
separated inputs go in the “S-function Parameters” edit
box.<span style="mso-spacerun: yes">  </span>The first input is the
location for temporary files to be
written.<span style="mso-spacerun: yes">  </span>The second input is the
fixed time step to be used.<span style="mso-spacerun:
yes">  </span>The third input is the name of the file that contains the
input and output lists.<span style="mso-spacerun: yes">  </span>For
general ADVISOR co-simulations, the first input is “vinf.tmppath” and
the second input is “time\_step.”<span style="mso-spacerun: yes"> 
</span>For the example, enter:

**strrep(which(’advisor’),’advisor.m’,’tmp\\’),.2,’SaberCosimIO\_Example’<o:p></o:p>**

This sets the temporary file path to the folder “tmp,” the fixed time
step to 0.2 seconds, and the list file name to
“SaberCosimIO\_Example.”<span style="mso-spacerun: yes">  </span>Click
**OK**.

### Running The Example Custom Co-Simulation

<!--[if !supportLists]-->1.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->Open
[“CustomSaberDemo.mdl”](..\models\customsaberdemo.mdl) from
“…advisor\\models\\.”

<!--[if !supportLists]-->2.<span style="font:7.0pt &quot;Times New Roman&quot;">     
</span><!--[endif]-->Click play.
![](Saber_cosim_help_files/play_button.jpg)<!--[if !vml]--><!--[endif]-->

### Known Co-Simulation Limitations

Currently the co-simulation is only developed for a fixed time step in
Simulink.<span style="mso-spacerun: yes">  </span>Saber can run at a
variable time step in the co-simulation.

<div class="MsoNormal" align="center" style="text-align:center">

* * * * *

</div>
[Back to Chapter 3](advisor_ch3.html)\
 [ADVISOR Documentation Contents](advisor_doc.html)

Last Revised: [26-August-2002]: ab

</div>
