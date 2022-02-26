% ADVISOR Documentation
% 
% March 26, 2013

# ADVISOR Documentation

Aaron Brooker, Kristina Haraldsson, Terry Hendricks, Valerie Johnson,
Kenneth Kelly, Bill Kramer, Tony Markel, Michael O’Keefe, Sam Sprik,
Keith Wipke, Matthew Zolot \

Contributors:  Desikan Bharathan, Steve Burch, Matthew Cuddy, Dave
Rausen \
  
![](nrellogo.gif)
<img src="ADVISOR_logo.gif" width="250"/>
![](DOE%20color.gif)

# ADVANCED VEHICLE SIMULATOR

National Renewable Energy Laboratory

Last Modified: October 10, 2003 [version 2003]

## Contents

[What’s New in ADVISOR](whats_new.html)

[1.0 Introduction](advisor_ch1.html)

1.1 To the Reader

1.1.1 What is ADVISOR \
 1.1.2 How to use this manual

1.2 Capabilities and intended uses \
 1.3 Limitations \
 1.4 System requirements \
 1.5 How to get additional help

[2.0 Using ADVISOR](advisor_ch2.html)

2.1 Using the GUI (demo)

2.1.1 Defining a vehicle \
 2.1.2 Running a simulation \
 2.1.3 Looking at outputs

2.2 Converting old component files to the current version of ADVISOR \
 2.3 Running ADVISOR without the GUI\
 2.4 Helper Classes and Functions

[3.0 How ADVISOR works](advisor_ch3.html)

3.1 ADVISOR file structure

3.1.1 File interactions \
 3.1.2 File locations \
 3.1.3 File naming conventions \
 3.1.4 Adding files to ADVISOR \
 3.1.5 Inspecting input files \
 3.1.6 Deleting files from ADVISOR’s database

3.2 Drivetrain model descriptions

3.2.1 Fuel Converter and Exhaust Aftertreatment \
 3.2.2 Electric Components \
 3.2.3 Transmission \
 3.2.4 Vehicle, Wheel and Brakes \
 3.2.5 Hybrid Control Strategies

3.2.6 Auxiliary Load Models

3.2.7 Saber Co-simulation

3.2.8 Simplorer Co-simulation

3.3 ADVISOR routines

3.3.1 SOC Corrections \
 3.3.2 Autosize \
 3.3.3 Acceleration Test \
 3.3.4 Grade Test \
 3.3.5 Tech Targets \
 3.3.6 J1711 Test Procedure \
 3.3.7 Real World Test Procedure \
 3.3.8 City Highway Test Procedure \
 3.3.9 Comparing Simulations \
 3.3.10 Optimization

3.3.11 Comparing Simulation Results with Test Data

3.4 Data flow in ADVISOR’s block diagrams

3.4.1 Overview \
 3.4.2 Backward-facing calculation path \
 3.4.3 Details of motor and motor controller \
 3.4.4 Forward-facing calculation path

[APPENDICES:](advisor_appendices.html)

A. ADVISOR’s variables

A.1 Variable naming convention \
 A.2 ADVISOR Input Variables \
 A.3 ADVISOR Output Variables

B. ADVISOR’s data files \
 C. Commonly used Matlab commands \
 D. Conventions for Goto tag use \
 E. Glossary

For online help with ADVISOR please visit
[the ADVISOR Community Group](https://groups.google.com/group/adv-vehicle-sim). \

Last Revised: 10-Oct-2003: ss