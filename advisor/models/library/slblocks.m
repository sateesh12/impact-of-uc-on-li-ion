function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.
% This is for the ADVISOR library
%   SLBLOCKS returns information about a Blockset to Simulink.  The
%   information returned is in the form of a BlocksetStruct with the
%   following fields:
%
%     Name         Name of the Blockset in the Simulink block library
%                  Blocksets & Toolboxes subsystem.
%     OpenFcn      MATLAB expression (function) to call when you
%                  double-click on the block in the Blocksets & Toolboxes
%                  subsystem.
%     MaskDisplay  Optional field that specifies the Mask Display commands
%                  to use for the block in the Blocksets & Toolboxes
%                  subsystem.
%     Browser      Array of Simulink Library Browser structures, described
%                  below.
%
%   The Simulink Library Browser needs to know which libraries in your
%   Blockset it should show, and what names to give them.  To provide
%   this information, define an array of Browser data structures with one
%   array element for each library to display in the Simulink Library
%   Browser.  Each array element has two fields:
%
%     Library      File name of the library (mdl-file) to include in the
%                  Library Browser.
%     Name         Name displayed for the library in the Library Browser
%                  window.  Note that the Name is not required to be the
%                  same as the mdl-file name.
%
%   Example:
%
%      %
%      % Define the BlocksetStruct for the Simulink block libraries
%      % Only simulink_extras shows up in Blocksets & Toolboxes
%      %
%      blkStruct.Name        = ['Simulink' sprintf('\n' Extras];
%      blkStruct.OpenFcn     = simulink_extras;
%      blkStruct.MaskDisplay = disp('Simulink\nExtras');
%
%      %
%      % Both simulink3 and simulink_extras show up in the Library Browser.
%      %
%      blkStruct.Browser(1).Library = 'simulink3';
%      blkStruct.Browser(1).Name    = 'Simulink';
%      blkStruct.Browser(2).Library = 'simulink_extras';
%      blkStruct.Browser(2).Name    = 'Simulink Extras';
%
%   See also FINDBLIB, LIBBROWSE.

%   Copyright 1990-2001 The MathWorks, Inc.
%   $Revision: 1.7 $

%
% Name of the subsystem which will show up in the Simulink Blocksets
% and Toolboxes subsystem.
%
blkStruct.Name = ['ADVISOR Blockset'];
%
% The function that will be called when the user double-clicks on
% this icon.
%
blkStruct.OpenFcn = 'lib_advisor';
%
% The argument to be set as the Mask Display for the subsystem.  You
% may comment this line out if no specific mask is desired.
% Example:  blkStruct.MaskDisplay = 'plot([0:2*pi],sin([0:2*pi]));';
% No display for Simulink Extras.
%
%blkStruct.MaskDisplay = '';

%
% Define the Browser structure array, the first element contains the
% information for the Simulink block library and the second for the
% Simulink Extras block library.
%
i=1;
Browser(i).Library = 'lib_fuel_converter3';
Browser(i).Name    = 'ADVISOR Blockset: IC Engine';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
% 
i=i+1;
Browser(i).Library = 'lib_electric_machine2';
Browser(i).Name    = 'ADVISOR Blockset: E-Machines';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_transmission2';
Browser(i).Name    = 'ADVISOR Blockset: Transmission Blocks';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_power_bus2';
Browser(i).Name    = 'ADVISOR Blockset: Power Bus';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_energy_storage2';
Browser(i).Name    = 'ADVISOR Blockset: Energy Storage';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_wheel2';
Browser(i).Name    = 'ADVISOR Blockset: Vehicle, Wheel, and Axle';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_drive_cycle2';
Browser(i).Name    = 'ADVISOR Blockset: Drive Cycle';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_accessory2';
Browser(i).Name    = 'ADVISOR Blockset: Accessory Loads';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_controls2';
Browser(i).Name    = 'ADVISOR Blockset: Hybrid Controls';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

i=i+1;
Browser(i).Library = 'lib_etc';
Browser(i).Name    = 'ADVISOR Blockset: Misc. Blocks';
Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

% i=i+1;
% Browser(i).Library = 'lib_ADVISOR_blockset';
% Browser(i).Name    = 'ADVISOR Blockset';
% Browser(i).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
% 
blkStruct.Browser = Browser;
% End of slblocks


