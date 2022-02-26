ADVISOR_script Readme

The ADVISOR_script executable (advisor_script.exe) can be used in conjunction with
adv_no_gui to automate the process of running analyses from the windows command line.

Format:

advisor_script.exe WorkingDirectory ScriptFilename ADVISORRootDirectory SupportDirectory

This command can be executed from a command window and will perform the following functions:

1) Open the Matlab Engine
2) Update the MATLAB path to include directories necessary for ADVISOR to execute
3) Add the SupportDirectory to the top of the path
4) Update the current working directory to be WorkingDirectory
5) Run ScriptFilename at the MATLAB command prompt
6) Close the MATLAB engine when calculations are complete

ADVISOR_script does not return any results or output so the ScriptFilename must handle
input and output data management with ADVISOR.  The scriptfile will typically include a 
series of adv_no_gui calls that build the ADVISOR workspace, run the cycles or tests, and
saves the results for review later.

CAUTION: At this time directory names with spaces are not supported!!!

The source code for advisor_script.exe is included in advisor_script.c.

Revision History
% 0401802:tm file created
