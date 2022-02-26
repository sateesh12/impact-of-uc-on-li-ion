% Notes on Updating User Files to New Versions of ADVISOR
% 
% 

Notes on Updating User Files to a New Version of ADVISOR
========================================================

Introduction
------------

The m-file “update\_file.m” (located in \<ADVISOR main
directory\>\\gui\\) does the work of updating previous user files to the
current version of ADVISOR. Updating is performed by comparing the
user’s file (data file) to an existing file (prototype file) of the
current version. The variables from both files are loaded onto function
workspaces and variables that are in the prototype file but **not** in
the user’s data file are appended to the user’s data file.

In certain cases, specialized pieces of code may be added to the front
or appended to the tail of a user’s file as well. It is important to
note that update\_file.m and batch\_update.m (discussed below) will
never delete items from a user’s file–only add new items. The only
exceptions to this rule are the \*\_version variables which are used to
flag ADVISOR if an m-file is from a previous version. The \*\_version
variables will always be set to the current version of ADVISOR upon
completion of a successful update.

Updated files should always be inspected manually to ensure that proper
variable values are being used. Also, although it is relatively easy to
define “dummy” parameters for missing variables, it is difficult to
track the size dependencies of variables (e.g., the number of rows and
columns of a given matrix may depend on other variables). Thus, user’s
will want to inspect the appropriateness of newly added data.

In checking their files, users will be able to see what update\_file has
added to their m-files as all updates are conveniently placed between
two comment lines. Where possible, user’s should make new file names
when changing an existing ADVISOR component file. If a user changes an
existing ADVISOR file but does not change the name of that file,
update\_file.m may not be able to update if the file in question is a
prototype file.

Some notes follow below regarding updating of files:

Batch Updating
--------------

As of version 2002, a batch update function has been made available to
the user for updating large numbers of files at one time. This function
is called batch\_update.m and is located in the \<ADVISOR main
directory\>\\gui directory.

The function batch\_update takes the following form:

*function* **batch\_update(**optionlist, startDir, destDir**)**\
 This function takes in an optionlist, and two directories where
startDir is the directory containing the m-files to update

-   optionlist – string with name of optionlist \*.mat file containing
    structure called “options” (e.g., optionlist\_all.mat)
-   startDir – string with the name of the directory holding the files
    to be updated
-   destDir – string with the name of the directory where files should
    be copied and updated to

Note: if startDir and destDir are the same, the files will be updated by
appending to the original files vs. copying and modifying the copies 

An optionlist is a \*.mat file containing all of the GUI pulldown menu
contents. The optionlist is required for proper updating. The reason why
is as follows: 

In update\_file.m as it is used from the GUI, when a user adds a file to
a menu, update\_file.m knows exactly what type of file it is by virtue
of where it is being added in the menu structure. If a user has a
fuel\_cell input file and adds it to fuel\_converter\>fc\>fc (see
[version and type help](version_type_help.html)), then update\_file knows
the file should be updated using a fuel cell initialization file
prototype.

However, in a batch update, multiple files are being updated at once and
there is no way of determining the exact type of file. Thus, the
optionlist is used to confirm where a user’s file resided in the
previous version of ADVISOR. With this information, the file can then be
updated using update\_file.m.

Updating to Version 2002
------------------------

### Vehicle and Wheel Files

The variables veh\_1st\_rrc and veh\_2nd\_rrc have been moved over to
the wheel file. These variables are now called wh\_1st\_rrc and
wh\_2nd\_rrc. Update file will append a “clear veh\_1st\_rrc
veh\_2nd\_rrc” statement to any vehicle files encountered to ensure that
the veh\_1st\_rrc variables are not put out on the workspace to cause
confusion.

Updating to Version 3.2
-----------------------

### General Notes

When updating a user data file, the matlab command window should be
consulted for warnings and notifications. The warning ‘File cannot be
run independently’ tells the user that the script file cannot be run
independently and other component files must be loaded to provide proper
variable definitions. This circumstance may require the user to manually
compare and update their files.

Files that cannot run independently require variables defined in other
component m-files. The autoupdater loads any known needed files for a
given prototype file and guesses what files may be needed for the data
file based upon what type of file it is. The problem with this method is
that the additional files that are loaded (and in-fact, even the
prototype file) may not best correspond with the user’s data. The user
should be aware that autoupdate attempts to insert the minimum needed
variable definitions into a file such that the file can run in the
current version of ADVISOR. However, the values for the inserted
variables should be checked for accuracy and correctness by the user.
This can be done by comparing the user’s updated data file to an
existing ADVISOR 3.2 file.

Cell arrays are copied over into new user files when encountered. This
functionality has been tested and found to work. However, due to the
tricky nature of copying cell arrays (cell arrays can hold any data
type), a note is given on the command window when cell array variables
are copied. Furthermore, a note or warning is given if errors are
encountered while trying to copy cell arrays. Users should always check
their updated files to determine what information was appended by
auto-update and check this information for correctness. The prototype
files (files of the existing version of ADVSIOR) that are consulted
during an update can be determined by examining the command window after
an update.

All inline function definitions are placed at the end of the updated
user data file. Text strings should be updated automatically from the
prototype files where needed though an error may occur if the ‘\\’
character is contained in the original string.

Note that logic statements such as “if” statements are not copied into
the target user datafile. The user should always visually inspect the
two files for logic errors or leftout statements that may be required.

### Drive Cycle Files (CYC\_\*.m files)

All drive cycle traces should begin at time equal to zero seconds. This
is not automatically done in the autoupdate function. The user can
simply prepend a zero value (e.g., cyc\_mph=[0 cyc\_mph(1,2);
cyc\_mph];) or shift sample times down to start at zero. Failure to do
this may result in an error.

### The Transmission (TX\_\*.m files)

As of ADVISOR 3.2, a new transmission efficiency model has been added to
ADVISOR. As such, new variables must be added to the user’s file. These
variables are tx\_eff\_map, tx\_map\_spd, and tx\_map\_trq. These
variables define a lookup table to replace the previously used equation
coefficients (note: user’s who wish to continue using the old equation
form can do so with block diagram changes–see [this
page](gearbox_loss_model_3_2.html) for details). A special function,
\<ADVISOR main directory\>/gui/tx\_eff\_mapper.m, is provided to create
a lookup-table from the previous efficiency model. However, the values
that are placed in the converted TX\_\*.m file are dummy variables for a
100% efficient transmission. The user is then requested to open the
converted m-file and determine how they would like to handle the
tranmission efficiency. Here are some common options:

-   ***constant efficiency over all gears–***this can be achieved by
    specifying tx\_map\_trq and tx\_map\_spd and tx\_eff\_map for one
    gear (e.g. tx\_map\_trq = [-1 1]; tx\_map\_spd = [0 1];
    tx\_eff\_map(:,:,1) = [0.92 0.92; 0.92 0.92]).
-   ***constant efficiency by gear–*** this can be achieved by
    specifying dummy values of tx\_map\_spd and tx\_map\_trq (e.g., [0
    1] and [-1 1] respectively–since you will be specifying constant
    efficiency by gear, the values of tx\_map\_spd and tx\_map\_trq are
    irrelevant). tx\_eff\_map should then be a constant for each gear
    (e.g., tx\_eff\_map(:,:,1) = [0.85 0.85; 0.85 0.85]; % gear 1,
    tx\_eff\_map(:,:,2) = [0.92 0.92; 0.92 0.92] % gear 2– the
    tx\_eff\_map size must correspond to the size of tx\_map\_spd and
    tx\_map\_trq (2 x 2)).
-   ***calculate a lookup table for your transmision using your custom
    gear ratios–***see [this page](gearbox_loss_model_3_2.html) and
    current v 3.2 TX\_\*.m files for details and examples. You will want
    to use the tx\_eff\_mapper.m function. It is recommended that this
    process be done once and tx\_map\_trq, tx\_map\_spd, and
    tx\_eff\_map then be loaded via \*.mat file as opposed to running
    tx\_eff\_mapper.m each time the TX\_\*.m file is loaded (running
    tx\_eff\_mapper takes processing time and can slow down file loading
    via the GUI).
-   ***add your own data–***for users who have gearbox efficiency maps
    by output torque and speed, this data can be input directly.
    Reference [this page](gearbox_loss_model_3_2.html) for details.

* * * * *

<center>
[Return to ADVISOR Documentation](advisor_doc.html) \

* * * * *

</center>
Last revision: [16-Aug-2001] mpo \
  \
 
