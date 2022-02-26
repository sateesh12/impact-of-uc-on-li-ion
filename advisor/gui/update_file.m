function update_file(datafile_name,pathname,varargin)
% ************* UPDATE FILE HELP *********************************************************************
% -------void update_file(datafile_name)
%
% This function adds the necessary variable definitions to an ADVISOR file of a
% previous version, datafile_name, to allow it to be used with the latest version
% of ADVISOR.
%
% The datafile_name passed as a parameter must begin with a prefix defining the
% data file's type.  For example, 'FC' is the prefix for a fuel converter file.
% New variable definitions are added along with comments at the end of the
% original data file.
%
%
% -------void update_file(datafile_name, pathname)
%
% same as above but with path specified (note: path should be in same format as 'pwd' command
%
%
% -------void update_file(datafile_name, pathname, compName, verName, typeName)
%
% update a specific file where the type, component, and version of the file are explicitly given.
% If the version and type are not defined, pass in '' (empty string). The variable, compName, should
% be the right hand column of one of the following (which correspond to the file prefix):
%    'FC'  ,'fuel_converter';
%    'ESS' ,'energy_storage';
%    'TX'  ,'transmission';
%    'PTC' ,'powertrain_control';
%    'WH'  ,'wheel_axle';
%    'ACC' ,'accessory';
%    'VEH' ,'vehicle';
%    'CYC' ,'cycle';
%    'MC'  ,'motor_controller';
%    'TC'  ,'torque_coupling'; 
%    'GC'  ,'generator';
%    'EX'  ,'exhaust_aftertreat'
% ************************************************************************************************

global myDEBUG;
myDEBUG=0; % set this to one and you will go into keyboard on some catch statements to try to figure out what happened

%msgbox('The convert routine is not functional for this release of ADVISOR.  Please update files by referencing an already existing file of the same type.',...
%   'Convert message','modal');
%return
if myDEBUG
    disp(['update_file.m called with ', num2str(nargin),' arguments:'])
    keyboard
end
% if this function is used without an input argument, pop up a window for user to 
% select a file
if nargin==0 ;%prompt user to pick a file
    [datafile_name,pathname]=uigetfile('*.m','Select File to Convert');
    if datafile_name==0
        return
    end
end
if nargin==1
    pathname=evalin('base','pwd');
end
if length(varargin)==3
    compName=varargin{1};
    verName=varargin{2};
    typeName=varargin{3};
else
    compName=[];
    verName=[];
    typeName=[];
end

% check pathname variable:


% initialize
new_version=2002;

%try
% develop list of strings to be added to file
%[add_list,warning_list,prep_list]=NewVars(prefix,datafile_name,prototypes);
if (nargin<=2 | isempty(compName))
    disp('Determining type using vinf')
    [compName, verName, typeName]=determineType(datafile_name);
end

[prototype_filename, prototype_independent, prototype_files2load]=determinePrototypeFile(compName,verName,typeName);

if strcmp(lower(prototype_filename),lower(datafile_name))
    disp('[update_file.m]: WARNING!!! The name of your datafile is the same as for the prototype file...')
    disp('................ update_file will not be able to update correctly. You should rename your')
    disp('................ datafile to avoid namespace crashes.')
    disp(['................ datafile name: ', datafile_name,'; prototype file name: ', prototype_filename])
    disp(['................ suggested datafilename: ',strtok(prototype_filename,'.'),'a.m'])
end

[add_list,warning_list,prep_list,old_version]=get_new_vars(strtok(datafile_name,'.'),...
    prototype_filename,prototype_independent,...
    prototype_files2load, pathname);
if myDEBUG
    disp('[update_file:main] just called update_file:get_new_vars')
    keyboard
end
% append special-case items to add_list that depend upon the component info, version, and type
[add_list]=appendSpecialCasesToAddList(add_list, compName, verName, typeName);
if myDEBUG
    disp('[update_file:main] just called appendSpecialCasesToAddList')
    keyboard
end
% add strings to file and update the version #
AddToFile(strtok(datafile_name,'.'),add_list,prep_list,new_version,old_version,pathname);

% display warnings
%Warnings(warning_list,prototypes,prefix);
%catch
%   disp('______________________________________________________________')
%   disp('Sorry...')
%   disp([datafile_name,' could not be updated automatically.'])
%   disp('Use a current data file of the same type to update it by hand.')
%   disp('______________________________________________________________')
%end

% end of MAIN
%---------------------------------------
function [add_list]=appendSpecialCasesToAddList(add_list, compName, verName, typeName)

if ~isempty(add_list) % added [15-April-2002] check for an empty addlist
    lengthAL=length(add_list.name);
elseif isempty(add_list)
    lengthAL=0;
end

switch lower(compName)
case 'vehicle'
    add_list.name{lengthAL+1}='clear veh_1st_rrc veh_2nd_rrc; %% these variables now being declared in wh_* file as wh_1st_rrc etc.';
    add_list.value{lengthAL+1}=[];
    
case 'accessory'
    add_list.name{lengthAL+1}='vinf.AuxLoads=load(''Default_aux.mat'');vinf.AuxLoadsOn';
    add_list.value{lengthAL+1}=[0];
end

return

function [comp_name, ver, type]=determineType(datafile_name)
if evalin('base','exist(''vinf'')') % is vinf available on the workspace?
    global vinf;
else
    vinf=0; % mpo 22-April-2002 make a dummy variable so no warning messages arise
end
prefix_label={'FC','fuel_converter';
    'ESS','energy_storage';
    'TX','transmission';
    'PTC','powertrain_control';
    'WH','wheel_axle';
    'ACC','accessory';
    'VEH','vehicle';
    'CYC','cycle';
    'MC','motor_controller';
    'TC','torque_coupling'; % mpo [3-Aug-2001] changed from coupler to coupling
    'GC','generator';
    'EX','exhaust_aftertreat'};

prefix=upper(strtok(datafile_name,'_'));  % ensure all letters are capitalized
datafile_name=upper(strtok(datafile_name,'.')); % discard the extension
disp(' ')
disp(['Determining component, version, and type for ', datafile_name,' ...'])
list=prefix_label(:,1);
try
    comp_name=prefix_label{strmatch(prefix,list,'exact'),2};
catch
    comp_name=[];
    disp(['Cannot determine file component type: naming convention not followed with ', datafile_name])
    return
end

if isfield(eval(['vinf.',comp_name],'[]'),'ver')
    if isfield(eval(['vinf.',comp_name],'[]'),'type')
        ver=eval(['vinf.',comp_name,'.ver'],'[]');
        type=eval(['vinf.',comp_name,'.type'],'[]');
    else
        ver=eval(['vinf.',comp_name,'.ver'],'[]'); % added eval function around the ver string-- 6-Aug-2001, mpo
        type=[];
    end
else
    ver=[];
    type=[];
end

%-------------------------------------------------------------------------------
function [prototype_filename, prototype_independent, prototype_files2load]=determinePrototypeFile(comp_name,ver,type)
%prototypes={'ACC_CONV','ESS_PB18','EX_SI','FC_SI95','FD_DUMMY','GC_PM32',...
%      'MC_AC75','TC_DUMMY','VEH_LGCAR','WH_SMCAR','CYC_ACCEL'};  % files w/ correct data

% PROTOTYPES Struct ---------------------------------------
% the independent flag tells whether other files must be dumped to the workspace first or not
% if prototypes.*.independent=0, other files must be loaded onto the workspace to avoid errors
% these files are specified in prototypes.*.files2load. (Be sure to check the independence
% of the files2load to ensure they are loaded correctly)

prototypes.fuel_converter.ic.si.name='FC_SI41_emis';
pinfo.fuel_converter.ic.si.independent=1;

prototypes.fuel_converter.ic.ci.name='FC_CI67_emis';
pinfo.fuel_converter.ic.ci.independent=1;

prototypes.fuel_converter.fc.fc.name='FC_ANL50H2';
pinfo.fuel_converter.fc.fc.independent=1;

prototypes.fuel_converter.nn_ic.ci.name='fc_cummins_NN';
pinfo.fuel_converter.nn_ic.ci.independent=1;

prototypes.energy_storage.rc.li.name='ESS_LI7_rc_temp';
pinfo.energy_storage.rc.li.independent=1;

prototypes.energy_storage.rc.nimh.name='ESS_NIMH7_rc_temp';
pinfo.energy_storage.rc.nimh.independent=1;

prototypes.energy_storage.rc.cap.name='ESS_UC2_Maxwell';
pinfo.energy_storage.rc.cap.independent=1;

prototypes.energy_storage.rint.pb.name='ESS_PB25';
pinfo.energy_storage.rint.pb.independent=1;

prototypes.energy_storage.rint.li.name='ESS_LI7_temp';
pinfo.energy_storage.rint.li.independent=1;

prototypes.energy_storage.rint.nimh.name='ESS_NIMH93';
pinfo.energy_storage.rint.nimh.independent=1;

prototypes.energy_storage.rint.nicad.name='ESS_NICAD102';
pinfo.energy_storage.rint.nicad.independent=1;

prototypes.energy_storage.rint.NiZn.name='ESS_NIZN22_temp';
pinfo.energy_storage.rint.NiZn.independent=1;

prototypes.energy_storage.rint.cap.name='ESS_ULTCAP2';
pinfo.energy_storage.rint.cap.independent=1;

prototypes.energy_storage.fund.fund.name='ESS_PB16_fund_generic_temp';
pinfo.energy_storage.fund.fund.independent=0; % 1
pinfo.energy_storage.fund.fund.files2load={'MC_AC75'};

prototypes.energy_storage.nnet.nnet.name='ESS_PB12_nnet';
pinfo.energy_storage.nnet.nnet.independent=1;

prototypes.energy_storage.saber.li.name='ESS_LI7_saber_temp';
pinfo.energy_storage.saber.li.independent=1;

prototypes.energy_storage.saber.nimh.name='ESS_NIMH7_saber_temp';
pinfo.energy_storage.saber.nimh.independent=0;
pinfo.energy_storage.saber.nimh.files2load={''}; % not sure which files to load--prob. with a vinf variable...

prototypes.energy_storage.saber.pb.name='ESS_PB54_14V_saber';
pinfo.energy_storage.saber.pb.independent=1;

prototypes.transmission.man.man.name='TX_5SPD_IDEAL'; % changed by mpo 2-July-2001
pinfo.transmission.man.man.independent=1;

prototypes.transmission.auto.auto.name='TX_AUTO4_IDEAL'; % changed by mpo 2-July-2001
pinfo.transmission.auto.auto.independent=1;

prototypes.transmission.cvt.cvt.name='TX_CVT50_SUBARU';
pinfo.transmission.cvt.cvt.independent=1;

prototypes.transmission.pgcvt.pgcvt.name='TX_PRIUS_CVT_JPN'; % changed from TX_PRIUS_JPN to TX_PRIUS_CVT_JPN 6-Aug-2001
pinfo.transmission.pgcvt.pgcvt.independent=1;

prototypes.powertrain_control.conv.man.name='PTC_CONV'; %conv
pinfo.powertrain_control.conv.man.independent=0; % 2
pinfo.powertrain_control.conv.man.files2load={'FC_SI41_emis','ACC_CONV','TX_5SPD_IDEAL'};

prototypes.powertrain_control.conv.auto.name='PTC_CONVAT';
pinfo.powertrain_control.conv.auto.independent=0; % 3
pinfo.powertrain_control.conv.auto.files2load={'FC_SI41_emis','ACC_CONV','TX_AUTO4_IDEAL'};

prototypes.powertrain_control.conv.cvt.name='PTC_CONVCVT';
pinfo.powertrain_control.conv.cvt.independent=0; % 4
pinfo.powertrain_control.conv.cvt.files2load={'FC_SI41_emis','ACC_CONV'};

prototypes.powertrain_control.par.man.name='PTC_PAR'; % parallel
pinfo.powertrain_control.par.man.independent=0; % 5
pinfo.powertrain_control.par.man.files2load={'FC_SI41_emis', 'TX_5SPD_IDEAL'};

prototypes.powertrain_control.par.auto.name='PTC_PAR_AUTO'; % parallel, auto: added 6-Aug-2001 mpo
pinfo.powertrain_control.par.auto.independent=0; % 5
pinfo.powertrain_control.par.auto.files2load={'FC_SI41_emis', 'TX_AUTO4_IDEAL'};

prototypes.powertrain_control.par.cvt.name='PTC_PAR_CVT'; 
pinfo.powertrain_control.par.cvt.independent=0; % 6
pinfo.powertrain_control.par.cvt.files2load = {'FC_SI41_emis', 'MC_AC75', 'TC_DUMMY'}; %note, fc and mc must be specified before tc

prototypes.powertrain_control.ser.man.name='PTC_SER'; % series
pinfo.powertrain_control.ser.man.independent=0; % 7
pinfo.powertrain_control.ser.man.files2load={'FC_SI41_emis', 'WH_SMCAR', 'TX_1SPD_IDEAL', 'GC_ETA95'};

prototypes.powertrain_control.ev.man.name='PTC_EV'; % ev
pinfo.powertrain_control.ev.man.independent=0; % 8
pinfo.powertrain_control.ev.man.files2load={'TX_5SPD_IDEAL'};

prototypes.powertrain_control.prius_jpn.pg.name='PTC_PRIUS_JPN'; % prius; % 15 August 2001 [mpo] changed from pgcvt to pg
pinfo.powertrain_control.prius_jpn.pg.independent=1; % 15 August 2001 [mpo] changed from pgcvt to pg

prototypes.powertrain_control.insight.man.name='PTC_INSIGHT'; % insight; 
pinfo.powertrain_control.insight.man.independent=0; % 9
pinfo.powertrain_control.insight.man.files2load={'FC_SI41_emis','TX_5SPD_IDEAL'};

prototypes.powertrain_control.fc.man.name='PTC_FUELCELL'; % fuel cell
pinfo.powertrain_control.fc.man.independent=0; % 10
pinfo.powertrain_control.fc.man.files2load={'FC_ANL50H2', 'MC_AC75', 'WH_SMCAR','TX_1SPD_IDEAL'};

prototypes.wheel_axle.name='WH_SMCAR';
pinfo.wheel_axle.independent=1;

% BEGIN added by mpo [2-APRIL-2002]
prototypes.wheel_axle.Crr.Crr.name='WH_SMCAR';
pinfo.wheel_axle.Crr.Crr.independent=1;

prototypes.wheel_axle.J2452.J2452.name='WH_P205_60R15_MED_RR';
pinfo.wheel_axle.J2452.J2452.independent=1;
% END added by mpo [2-APRIL-2002]

prototypes.accessory.name='ACC_CONV';
pinfo.accessory.independent=1;

% BEGIN added by mpo [01-April-2002]: required for new version/type for accessory
prototypes.accessory.Const.Const.name='ACC_CONV'; 
pinfo.accessory.Const.Const.independent=1;

prototypes.accessory.Var.Spd.name='ACC_no_load';
pinfo.accessory.Var.Spd.independent=1;

prototypes.accessory.Saber.DV.name='ACC_CONV_DV_Saber';
pinfo.accessory.Saber.DV.independent=1;

prototypes.accessory.Saber.SV.name='ACC_CONV_SV_Saber';
pinfo.accessory.Saber.SV.independent=1;
% END added by mpo [01-April-2002]

prototypes.vehicle.name='VEH_LGCAR';
pinfo.vehicle.independent=1;

prototypes.exhaust_aftertreat.name='EX_SI';
pinfo.exhaust_aftertreat.independent=0; % 11
pinfo.exhaust_aftertreat.files2load={'FC_SI41_emis'};

prototypes.torque_coupling.name='TC_DUMMY';
pinfo.torque_coupling.independent=0; % 12
pinfo.torque_coupling.files2load={'FC_SI41_emis', 'MC_AC75'};

prototypes.generator.name='GC_ETA95';
pinfo.generator.independent=1;

prototypes.generator.reg.reg.name='GC_ETA95'; % added by mok 16-april-2002
pinfo.generator.reg.reg.independent=1;

% commented these out for now: looks like you can't start a struct field with a number...
%prototypes.generator.saber.42v.name='GC_42VCP_CUSTOM'; % added by mok 16-april-2002
%pinfo.generator.saber.42v.independent=1;

%prototypes.generator.saber.14v.name='GC_14VCP_CUSTOM'; % added by mok 16-april-2002
%pinfo.generator.saber.14v.independent=1;

prototypes.motor_controller.name='MC_AC75';
pinfo.motor_controller.independent=1;

prototypes.cycle.name='CYC_SKELETON'; % 2-July-2001 [mpo] changed to cyc file that doesn't need to load *.mat file
pinfo.cycle.independent=1;  % ... (was CYC_HWFET which 'could not be run independently')
%--------------------------------------------------------------

if isempty(comp_name)
    disp('Unknown component name... cannot update this file')
    return
end

if ~isempty(comp_name)
    if ~isempty(ver)
        if ~isempty(type)
            str=['prototypes.',comp_name,'.',ver,'.',type,'.name'];
            if eval(['pinfo.',comp_name,'.',ver,'.',type,'.independent'],'[]') % if file is independent
                independent = 1;
                str2 = {''}; % dummy
            else % else, file is dependent and other files must be loaded
                independent = 0;
                str2 = eval(['pinfo.',comp_name,'.',ver,'.',type,'.files2load']);
            end
        else
            str=['prototypes.',comp_name,'.',ver,'.name'];
            if eval(['pinfo.',comp_name,'.',ver,'.independent'],'[]') % if file is independent
                independent = 1;
                str2 = {''}; % dummy
            else % else, file is dependent and other files must be loaded
                independent = 0;
                str2 = eval(['pinfo.',comp_name,'.',ver,'.files2load'],'[]');
            end
        end
    else
        str=['prototypes.',comp_name,'.name'];
        if eval(['pinfo.',comp_name,'.independent'],'[]') % if file is independent
            independent = 1;
            str2 = {''}; % dummy
        else % else, file is dependent and other files must be loaded
            independent = 0;
            str2 = eval(['pinfo.',comp_name,'.files2load']);
        end
    end
else
    disp('Unknown component name... cannot update file')
    prototype_filename=[];
    prototype_files2load=[];
    prototype_independent
    return
end
if 0
    comp_name
    ver
    type
    str
    keyboard
end
prototype_filename=eval(str);
prototype_files2load=str2;
prototype_independent=independent;

%-------------------------------------------------------------------------------
function [add_list,warn_list,prep_list,old_ver_num]=get_new_vars(datafile_name,prototype_filename,...
    prototype_independent, prototype_files2load, pathname)

warn_index=0;
warn_list={};
toDelete={}; % a listing of the variables used for initialization that we don't want to keep
%toSave={};

try
    if ~prototype_independent % if the file is not stand-alone, load the needed files
        for zz=1:length(prototype_files2load)
            eval(prototype_files2load{zz})
        end
        clear zz; % reset our counter
        % collect these workspace variables, because we'll need to delete them later
        wks_data=whos;
        for zz=1:length(wks_data)
            if (    strcmp(wks_data(zz).name,'warn_index') |...
                    strcmp(wks_data(zz).name,'warn_list') |...
                    strcmp(wks_data(zz).name,'toDelete') |...
                    strcmp(wks_data(zz).name,'zz') |...
                    strcmp(wks_data(zz).name,'wks_data') |...
                    strcmp(wks_data(zz).name,'datafile_name') |...
                    strcmp(wks_data(zz).name,'prototype_filename') |...
                    strcmp(wks_data(zz).name,'prototype_independent') |...
                    strcmp(wks_data(zz).name,'prototype_files2load') |...
                    strcmp(wks_data(zz).name,'pathname')   )
                
                toDelete{zz}=''; % dummy--don't delete 
            else
                toDelete{zz}=wks_data(zz).name;
            end
        end
        clear zz wks_data; % reset our counter and wks_data
    end % if ~prototype_independent
    
    % Now we should be able to load the prototype file
    eval(prototype_filename)
catch
    warn_index=warn_index+1;
    warn_list{warn_index}=['Unable to run prototype file independently. You may wish to visually inspect differences between ',...
            prototype_filename,' and your file, ', datafile_name];
    disp(warn_list{warn_index});
    disp(['Last Error: ',lasterr]);
end % end try...catch

% Now that we are safely loaded as best we could, let's delete the variables we know we don't need (if any)
for zz=1:length(toDelete)
    if ~strcmp(toDelete{zz},'') % don't eval('clear ') or *everything* is cleared
        eval(['clear ',toDelete{zz}]); % clear all variables from other files that may have been loaded
    end
end

wks_data=whos;
for cc=1:length(wks_data)
    proto_var.list{cc}=wks_data(cc).name;
end
%proto_var.list=who;
for i=1:length(proto_var.list);
    if strcmp(wks_data(i).class,'inline')
        form_str=formula(eval(proto_var.list{i}));
        args=argnames(eval(proto_var.list{i}));
        inline_str=['inline(''',form_str,''''];
        for c=1:length(args)
            inline_str=[inline_str,',''',args{c},''''];
        end
        inline_str=[inline_str,');'];
        proto_var.value{i}=inline_str;
    elseif strcmp(wks_data(i).class,'char')% added by mpo 2-Aug-2001
        proto_var.value{i}=['''',eval(proto_var.list{i}),''';']; % surround normal text in quotes and end in ';'
    else
        proto_var.value{i}=eval(proto_var.list{i});
    end
end

%----------------------------------
%change temporarily to gui directory to save update_file_temp
global saved_directory_temp
saved_directory_temp=pwd;

cd(strrep(which('advisor.m'),'advisor.m','gui'))

save update_file_temp proto_var warn_index warn_list datafile_name prototype_filename prototype_independent prototype_files2load pathname toDelete

clear

%set directory back to what it was
global saved_directory_temp
cd(saved_directory_temp)
clear global saved_directory_temp
%-----------------------------------
load(fullfile(strrep(which('advisor.m'), 'advisor.m', 'gui'), 'update_file_temp.mat'))

try
    if ~prototype_independent % if the prototype file was not stand-alone, chances are, datafile isn't either
        for zz=1:length(prototype_files2load)
            eval(prototype_files2load{zz})
        end
        clear zz; % reset our counter
        % we collected these workspace variables earlier in toDelete array
        
        %wks_data=whos;
        %for zz=1:length(wks_data)
        %    if (    strcmp(wks_data(zz).name,'warn_index') |...
        %            strcmp(wks_data(zz).name,'warn_list') |...
        %            strcmp(wks_data(zz).name,'toDelete') |...
        %            strcmp(wks_data(zz).name,'zz') |...
        %            strcmp(wks_data(zz).name,'wks_data') |...
        %            ...%strcmp(wks_data(zz).name,'toSave') |...
        %            strcmp(wks_data(zz).name,'datafile_name') |...
        %            strcmp(wks_data(zz).name,'prototype_filename') |...
        %            strcmp(wks_data(zz).name,'prototype_independent') |...
        %            strcmp(wks_data(zz).name,'prototype_files2load') |...
        %            strcmp(wks_data(zz).name,'pathname')   )
        %        toDelete{zz}={''}; % dummy--don't delete 
        %    else
        %         toDelete{zz}=wks_data(zz).name;
        %     end
        %end
        %clear zz, wks_data; % reset our counter and wks_data
    end % if ~prototype_independent
    
    % Now we should be able to load the datafile file--if not, we have the catch
    eval(['run(''', pathname, filesep, datafile_name, '.m''',')'])
catch
    warn_index=warn_index+1;
    warn_list{warn_index}=['Unable to run data file independently. You may wish to visually inspect differences between ',...
            prototype_filename,' and your file, ', datafile_name];
    disp(warn_list{warn_index});
    disp(['Last Error: ',lasterr]);
end % end try...catch block

% Now that we are safely loaded as best we could, let's delete the variables we know we don't need (if any)
for zz=1:length(toDelete)
    if ~strcmp(toDelete{zz},'') % don't eval('clear ') or *everything* is cleared
        eval(['clear ',toDelete{zz}]); % clear all variables from other files that may have been loaded
    end
end

wks_data=whos;
var_index=0;
for cc=1:length(wks_data)
    % only load actual file variables in data_var--not variables for this function
    %if (~strcmp(wks_data(cc).name,'proto_var')&~strcmp(wks_data(cc).name,'warn_index')&...
    %      ~strcmp(wks_data(cc).name,'warn_list')&~strcmp(wks_data(cc).name,'datafile_name')&...
    %      ~strcmp(wks_data(cc).name,'prototype_filename')&~strcmp(wks_data(cc).name,'pathname'))
    %  var_index=var_index+1;
    data_var.list{cc}=wks_data(cc).name;
    %end
end
%data_var.list=who;
for i=1:length(data_var.list);
    if strcmp(wks_data(i).class,'inline')
        form_str=formula(eval(data_var.list{i}));
        args=argnames(eval(data_var.list{i}));
        inline_str=['inline(''',form_str,''''];
        for c=1:length(args)
            inline_str=[inline_str,',''',args{c},''''];
        end
        inline_str=[inline_str,');'];
        data_var.value{i}=inline_str;
    else
        data_var.value{i}=eval(data_var.list{i});
    end
end

ver_name=who('*version');
try
    old_ver_num=eval(ver_name{1});
catch
    old_ver_num=2;
end

%assignin('base','proto_var',proto_var)
%assignin('base','data_var',data_var)

add_index=0;
for i=1:length(proto_var.list)
    if isempty(strmatch(proto_var.list{i},data_var.list,'exact'))
        add_index=add_index+1;
        add_list.name{add_index}=proto_var.list{i};
        add_list.value{add_index}=proto_var.value{i};
    end
end
%save testing2 data_var; % for myDEBUG purposes
if ~exist('add_list')
    add_list=[];
end
if ~exist('warn_list') % if no warnings, make warn_list empty
    warn_list{1}={'none'};
end
if ~exist('prep_list')
    prep_list{1}={'none'};
end

add_list;
return

function [add_list,warn_list,prep_list]=NewVars(lclPrefix,lclDatafile_name,...
    prototypes)
% Returns add_list, a cell array of the strings that must be added to
% a file with prefix lclPrefix and which defines variables named in lclVar_list.

switch lclPrefix
case {'GB','TX'}
    % identify file type, if there are different kinds of files with the same prefix
    file_type=FileType(lclDatafile_name,lclPrefix);
    if file_type==2 % TX/GB file is like TX/GB_5SPD
        add_list{1}='if isempty(findstr(gb_description,''CVT'')) % gearbox refers to something other than a CVT';
        add_list{2}='   switch gb_gears_num';
        add_list{3}='   case 1';
        add_list{4}='      tx_type=''manual 1 speed'';';
        add_list{5}='   case 4';
        add_list{6}='      tx_type=''auto 4 speed'';';
        add_list{7}='   case 5';
        add_list{8}='      tx_type=''manual 5 speed'';';
        add_list{9}='   otherwise';
        add_list{10}='      error(''Error defining ''''tx_type'''''')';
        add_list{11}='   end';
        add_list{12}='else';
        add_list{13}='   tx_type=''cvt'';';
        add_list{14}='end';
        warn_list{1}='For purposes of this conversion, your file has been identified as one which might be called by the GUI directly, rather than by another GB file.  If this is not correct, use TX_VW as a model to update your file by hand.';
        warn_list{2}='Assmptions were made regarding the value of ''tx_type''.  Please review the bottom of of the updated file.';
        if strcmp(lclPrefix,'GB')
            add_list{15}='%%default/dummy final drive variables, to make this gearbox file into a full transmission file';
            add_list{16}='fd_loss=0;         %% (Nm) constant torque loss in final drive, measured at input';
            add_list{17}='fd_ratio=1;        %% (--) =(final drive input speed)/(f.d. output speed)';
            add_list{18}='fd_inertia=0;      %% (kg*m^2) rotational inertia of final drive, measured at input';
            add_list{19}='fd_mass=110/2.205; %% (kg) mass of the final drive - 1990 Taurus, OTA report';
            add_list{20}='tx_mass=gb_mass+fd_mass; %% (kg), mass of the gearbox + final drive=(transmission)';
            warn_list{3}='Your gearbox file now includes final drive info.  You might want to rename it TX_... for clarity''s sake.';  
        end
    else % TX/GB file is like TX/GB_VW (loss params, no mass)
        warn_list{1}='For purposes of this conversion, your file has been identified as one which will not be called by the GUI directly, but rather by another GB file.  If this is not correct, use TX_5SPD as a model to update your file by hand.';
    end   
case 'PTC'
    warn_list{1}='Exercise EXTREME CAUTION.';
    warn_list{2}='PTC files are complicated and difficult to update.  Only';
    warn_list{3}='your file''s version number has been updated.  It is HIGHLY';
    warn_list{4}='recommended that you consult a current PTC file for guidance.';
    warn_list{5}='If your file controls an ICE-powered vehicle with a manual multi-speed transmission, you must add ''gb_upshift_spd'', ''gb_dnshift_spd'', ''gb_upshift_load'', and ''gb_dnshift_load'' to it by hand.  Use PTC_CONV as a template.';
otherwise
    % develop the lists of variables and values to be added by consulting the
    % prototype files
    switch lclPrefix
    case 'EX'
        pre_run_com=[char(FindCell(prototypes,'FC')),... % prep filetype is FC
                ',fc_ex_gas_flow_mn=1;,fc_ex_gas_flow_mx=10;,']; 
        prep_list{1}='fc_ex_gas_flow_mn=1;  %% dummy value';
        prep_list{2}='fc_ex_gas_flow_mx=10; %% dummy value';
    case 'TC'
        pre_run_com=[FindCell(prototypes,'FC'),','...
                ,FindCell(prototypes,'MC'),','];     % prep filetype is FC+MC
    otherwise
        pre_run_com='';
    end
    % use a prototype file to develop the list of variables that must be added
    add_list=ToAdd(lclDatafile_name,FindCell(prototypes,lclPrefix),...
        pre_run_com,lclPrefix);
    if ~isempty(add_list)
        if exist('warn_list')
            warn_list{end+1}=['Default values taken from (and described in) ',...
                    FindCell(prototypes,lclPrefix),...
                    ' have been appended to your file.'];
        else
            warn_list{1}=['Default values taken from (and described in) ',...
                    FindCell(prototypes,lclPrefix),...
                    ' have been appended to your file.'];
        end
    end
end
if ~exist('add_list')
    add_list=[];
end
if ~exist('warn_list') % if no warnings, make warn_list empty
    warn_list{1}={'none'};
end
if ~exist('prep_list')
    prep_list{1}={'none'};
end
% end of NewVars
%---------------------------------------


%-------------------------------------------------------------------------------
function cellcontents=FindCell(cellvar,string)
% Returns the value of the first cell in a cell array that contains the given
% string.  If no array element before the last cell contains the string, the
% contents of the last cell will be returned regardless of whether it's a match.
i=1;
while i<length(cellvar) & isempty(findstr(cellvar{i},string))
    i=i+1;
end
cellcontents=cellvar{i};
% end of FindCell
%---------------------------------------


%-------------------------------------------------------------------------------
function add_list=ToAdd(datafile_name,protofile_name,pre_run_com,lclPrefix)

% initialize
missing_indices=[]; % list of indices of variables defined by prototype not
% defined by current data file
prefix=lower(lclPrefix); % this prefix is to be used in variable names

% develop list of variables in prototype + pre_run 
[protovars.name,protovars.value]=VarsInWS([pre_run_com,protofile_name]);

% develop list of variables from current data file + pre_run
[datafilevars,dummy]=VarsInWS([pre_run_com,datafile_name]);

% determine variables listed by prototype not listed by current file
for varindex=1:length(protovars.name)
    
    % search through all variables defined by data file, stopping when a match
    % is found
    datafilevarindex=1;
    while ~strcmp(protovars.name{varindex},datafilevars{datafilevarindex}) & ...
            datafilevarindex<length(datafilevars)
        datafilevarindex=datafilevarindex+1;
    end
    
    % add the current index to the list of no-match indices if no match was found
    if ~strcmp(protovars.name{varindex},datafilevars{datafilevarindex})
        missing_indices=[missing_indices,varindex];
    end
end

% create add_list from variable names and values
if isempty(missing_indices) % then every req'd variable is defined by the file
    add_list=[];
else
    for addlistindex=1:length(missing_indices)
        name=protovars.name{missing_indices(addlistindex)};
        value=protovars.value{missing_indices(addlistindex)};
        if length(value)==1 % scalar
            add_list{addlistindex}=[name,'=',num2str(value),';'];
        elseif size(value,1)==1 % row vector
            add_list{addlistindex}=[name,'=[',num2str(value),'];'];
        elseif size(value,2)==1 % column vector
            add_list{addlistindex}=[name,'=[',num2str(value'),']'';'];
        elseif strcmp(prefix,'cyc') % matrix in cyc file
            add_list{addlistindex}=[name,'=',mat2str(value),';'];
        else
            % a matrix is to be replaced--assume that it is indexed by 
            % xx_map_spd and xx_map_trq
            add_list{addlistindex}=[name,'=ones(length(',prefix,...
                    '_map_spd),length(',prefix,'_map_trq));'];
        end
    end
end

%FC Modifications: if file is FC and fc_cold is a new variable then add proper code for cold
%maps.  This is for files pre version 3.1
if strcmp(lclPrefix,'FC')
    %check for fc_cold being a new variable
    index_match=strmatch('fc_cold',add_list);
    if index_match %true if index_match is 1 or greater
        %add the following lines to the FC file for proper cold map setup
        
        str_to_add={'%% Add data for Cold Engine Maps',...
                'fc_cold_tmp=20; %%deg C',...
                'fc_fuel_map_cold=zeros(size(fc_fuel_map));',...
                'fc_hc_map_cold=zeros(size(fc_fuel_map));',...
                'fc_co_map_cold=zeros(size(fc_fuel_map));',...
                'fc_nox_map_cold=zeros(size(fc_fuel_map));',...
                'fc_pm_map_cold=zeros(size(fc_fuel_map));',...
                '%%Process Cold Maps to generate Correction Factor Maps',...
                'names={''fc_fuel_map'',''fc_hc_map'',''fc_co_map'',''fc_nox_map'',''fc_pm_map''};',...
                'for i=1:length(names)',...
                '%%cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map',...
                '    eval([names{i},''_c2h='',names{i},''_cold./('',names{i},''+eps);''])',...
                'end'};
        
        add_list=[add_list, str_to_add];
    end
end


%ESS Modifications: if file is ess and ess_tmp is a new variable then add proper code to make sure
%that all the proper vectors are converted into lookup tables(matrices) based on temperature
%this portion is good for updating from something pre A2.2
if strcmp(lclPrefix,'ESS')
    %check for ess_tmp being a new variable
    index_match=strmatch('ess_tmp',add_list);
    if index_match %true if index_match is 1 or greater
        %add the following lines to the ESS file for proper tmp dependence
        str_to_add={'%%add the appropriate number of vectors for temp. dependence',...
                'cap=ess_max_ah_cap; eff=ess_coulombic_eff; dis=ess_r_dis; chg=ess_r_chg; voc=ess_voc;',...
                'for i=1:length(ess_tmp)-1 ',...
                '   ess_max_ah_cap=[ess_max_ah_cap; cap];',...
                '   ess_coulombic_eff=[ess_coulombic_eff; eff];',...
                '   ess_r_dis=[ess_r_dis; dis];',...
                '   ess_r_chg=[ess_r_chg; chg];',...
                '   ess_voc=[ess_voc; voc];',...
                'end %%temp dependence additions',...
                'clear cap eff dis chg voc'};
        add_list=[add_list, str_to_add];
    end
end
% end of ToAdd
%---------------------------------------


%-------------------------------------------------------------------------------
function [varnames,values]=VarsInWS(datafiles)
% Returns a list of variables created by the command passed as an input parameter
eval(datafiles)
varnames=who;
for i=1:length(varnames);
    values{i}=eval(varnames{i});
end
% end of VarsInWS
%---------------------------------------


%-------------------------------------------------------------------------------
function AddToFile(lclDatafile_name,lclAdd_list,lclPrep_list,lclNew_version,lclOld_version,pathname)
try
    % Adds lines in lclAdd_list cell array to lclDatafile_name and saves the file.
    
    % BEGIN added by mpo [02-APRIL-2002] trying to ensure that the pathname will be handled correctly
    % --we want pathname to include a slash between it and current_file
    pathname=strrep(pathname,'/',filesep);
    pathname=strrep(pathname,'\',filesep);
    if ~isempty(pathname)&length(pathname)>1
        if ~strcmp(pathname(end), filesep)
            pathname=[pathname filesep];
        end
    end
    % END added by mpo [02-April-2002]
    fullname=[pathname, lclDatafile_name, '.m'];
    verstr=num2str(lclNew_version);
    
    % put stuff that must precede the file's commands at top
    if ~strcmp(lclPrep_list{1},'none')
        
        % read the file
        try
            fid=fopen(fullname,'rt');
            S=fscanf(fid,'%c');
            fclose(fid);
        catch
            disp(lasterr)
            disp('Error in update_file.m[AddToFile] opening file to read in text mode')
            disp(['file path: ', fullname])
            try
                fclose(fid);
            catch
                disp(lasterr)
            end
            return
        end
        %get old version number
        ind=findstr(S,'_version=');
        %tempstr=S(min(ind)+9:min(ind)=20);
        %ind2=findstr('
        
        % fix it for printing via MATLAB
        S2=strrep(S,'%','%%');     % double all % signs
        %S2=strrep(S1,'''',''''''); % double all single quotes
        
        % start the file with the conversion stuff
        try
            fid=fopen(fullname,'wt');
        catch
            disp(lasterr)
            disp('Error in update_file.m[AddToFile] opening file to write in text mode')
            disp(['file path: ', fullname])
            try
                fclose(fid);
            catch
                disp(lasterr)
                return
            end
            return
        end
        fprintf(fid,['%% Begin added by ADVISOR ',verstr,' converter: ',date,'']);
        for i=1:length(lclPrep_list)  
            fprintf(fid,lclPrep_list{i});
            fprintf(fid,'');
        end
        fprintf(fid,['%% End added by ADVISOR ',verstr,...
                ' converter: ',date,'--more conversion at end of file']);
        fprintf(fid,S2);
        try
            fclose(fid);   
        catch
            disp(lasterr)
            return
        end
    end
    
    % append most stuff
    try
        fid=fopen(fullname,'at');
    catch
        disp(lasterr)
        disp('Error in update_file.m[AddToFile] opening file to append in text mode')
        disp(['file path: ', fullname])
        try
            fclose(fid);
        catch
            disp(lasterr)
            return
        end
        return
    end    
    %save testing lclAdd_list; % for DEBUG purposes
    if ~isempty(lclAdd_list)
        fprintf(fid,['\n%% Begin added by ADVISOR ',verstr,...
                ' converter: ',date,'']);
        a=0;
        inline_index=[];
        for i=1:length(lclAdd_list.name) 
            if ischar(lclAdd_list.value{i})
                try
                    if ~isempty(findstr(lclAdd_list.value{i},'inline(')) % if this is an inline function, do last
                        a=a+1;
                        inline_index(a)=i; % record the inline function index
                    else % if a text value, print out now 
                        % text value should already be quoted and end w/ ';'
                        % note, the '%' sign is a special character for fprintf--we must process to ensure
                        % that strings with '%' sign are treated properly (change %-->%%)
                        per_index=findstr(lclAdd_list.value{i},'%');
                        fliplr(per_index); % move from end to front so that index number doesn't need to be modified
                        %....................as the string gets bigger
                        for k=1:length(per_index)
                            if per_index(k)==length(lclAdd_list.value{i})
                                lclAdd_list.value{i}=[lclAdd_list.value{i}, '%'];
                            else
                                lclAdd_list.value{i}=[lclAdd_list.value{i}(1:per_index(k)),'%',...
                                        lclAdd_list.value{i}(per_index(k)+1:end)];
                            end
                        end
                        fprintf(fid,['\n',lclAdd_list.name{i},'=',lclAdd_list.value{i}]); 
                    end
                catch
                    disp(lasterr)
                    disp(['Error writing out lclAdd_list.value{',num2str(i),'} as a character'])
                    if myDEBUG
                        keyboard % DEBUG
                    end
                end
            elseif isa(lclAdd_list.value{i},'cell')
                
                % if a cell array, attempt to do something with it...
                disp(['NOTE: Attempting to copy cell array, ',lclAdd_list.name{i},', from the prototype file to your data file.']);
                disp('......If problems occur, please reference your data file and compare with an existing file of the same type you are updating.');
                disp('......Also, see <ADVISOR main directory>/documentation/updating_notes.html for further help.');
                
                try
                    % determine size of the cell array
                    [rows, cols] = size(lclAdd_list.value{i});
                    
                    str = ['={'];
                    for ii=1:rows
                        if isa(lclAdd_list.value{i}{ii,1},'char')
                            str=[str,'''',lclAdd_list.value{i}{ii,1},''''];
                        elseif isa(lclAdd_list.value{i}{ii,1}, 'double')
                            str=[str,mat2str(lclAdd_list.value{i}{ii,1})];
                        else
                            %do nothing
                        end
                        for jj=2:cols
                            if isa(lclAdd_list.value{i}{ii,jj},'char')            
                                str=[str,', ''',lclAdd_list.value{i}{ii,jj},''''];
                            elseif isa(lclAdd_list.value{i}{ii,jj}, 'double')
                                str=[str,', ',mat2str(lclAdd_list.value{i}{ii,jj})];
                            else
                                %do nothing
                            end    
                        end
                        if ii~=rows
                            str=[str,';'];
                        else
                            str=[str,'};'];
                        end
                    end         
                    fprintf(fid,['\n',lclAdd_list.name{i},str]);
                    disp('......No Errors detected in copying cell array');
                catch
                    disp('WARNING: Error encountered copying cell... moving on... please reference existing file and manually copy cell array');
                end
            elseif isa(lclAdd_list.value{i},'struct')
                % if a structure, do nothing for now
                disp(['NOTE: The structure, ',lclAdd_list.name{i},', is not being copied from the prototype file to your data file.']);
                disp('......Structures should be copied to your data file only as a special case.');
                disp('......If problems occur, please reference an existing file of the same type you are updating.');
                disp('......Also, see <ADVISOR main directory>/documentation/updating_notes.html for further help.');
                %fprintf(fid,['\n',lclAdd_list.name{i},'={',lclAdd_list.value{i},'}']);         
            else % below, the matrix text is being limited to 4 significant figures, down from 15...
                try
                    [rows,cols,ht]=size(lclAdd_list.value{i});
                    if ht<2
                        fprintf(fid,['\n',lclAdd_list.name{i},'=',mat2str(lclAdd_list.value{i},4),';']);
                    else
                        tmp = lclAdd_list.value{i};
                        for htcnt=1:ht
                            fprintf(fid,['\n',lclAdd_list.name{i},'(:,:,',num2str(htcnt),')=',mat2str(tmp(:,:,htcnt),4),';']);
                        end
                    end
                catch
                    disp(lasterr)
                    disp(['Error writing out lclAdd_list.value{',num2str(i),'} as a matrix'])
                    if myDEBUG
                        keyboard
                    end
                end
            end
            fprintf(fid,'\n');
        end
        if ~isempty(inline_index) % if there are inline functions... put at end
            for j=1:length(inline_index)
                fprintf(fid,['\n',lclAdd_list.name{inline_index(j)},'=',lclAdd_list.value{inline_index(j)}]);
            end
        end      
        fprintf(fid,['\n%% End added by ADVISOR ',verstr,' converter: ',date,'']);
        disp(['[update_file.m] variables appended to ', lclDatafile_name]);
    else
        fprintf(fid,['\n%% ',date,': automatically updated to version ',verstr]);
        disp(['[update_file.m] no new variables required for file ', lclDatafile_name])
    end
    status=fclose(fid);
    %lclOld_version=2.21;
    update_ver(num2str(lclNew_version),num2str(lclOld_version),lclDatafile_name,pathname); % correct the XXX_version
catch
    disp(['[update_file:AddToFile]: Error in sub-function AddToFile'])
    disp(lasterr)
    if myDEBUG
        keyboard
    end
end
return
% end of AddToWS
%---------------------------------------


%-------------------------------------------------------------------------------
function file_type=FileType(lclDatafile_name,lclPrefix)
% Returns file_type, an identifier to distinguish different kinds of files
% sharing the same prefix from each other.
switch lclPrefix
case {'GB','TX'}
    if ~isempty(findstr('VW',upper(lclDatafile_name)))...
            | ~isempty(findstr('HEAVY',upper(lclDatafile_name)))
        file_type=1;  % a GB/TX file that only defines loss coefficients
    else
        file_type=2;  % the kind of file that is called by the GUI, such as TX_5SPD
    end
otherwise
    file_type=0;
end
% end of FileType
%---------------------------------------


%-------------------------------------------------------------------------------
function Warnings(lclwarn_list,lclPrototypes,lclPrefix)
if ~strcmp(lclwarn_list{1},'none')
    disp(' ')
    if length(lclwarn_list)==1
        disp('WARNING:')
    else
        disp('WARNINGS:')
    end
    for i=1:length(lclwarn_list)
        disp(lclwarn_list{i})
    end
    disp(' ')
end
disp('File update is completed.  PLEASE review file before using it.')
% end of Warnings
%---------------------------------------

%Revisions
% 4/7/99 ss: added section when nargin==0 where it will pop up a file selection window.
% 9/6/99 mc: replaced repeated add_list{X}='XX_version=2.1;'; with references to update_ver and remov
% 10/15/99 ss: added cyc_accel to template list, allowed a mat2str to be used in the cyc files instead
% of assuming that a spd and trq vector were indexing the matrix variable.
% 7/28/00 ss: updated version to 3.0
% 8/21/00 ss: added msgbox saying this function is not yet functional
% 8/22/00 ss: added pathname to update_ver call
% 9/27/00:tm updated references to exhaust_aftertreatment to exhaust_aftertreat on lines 60 and 83
% 2/2/01: ss updated prius to prius_jpn
% 2/8/01: ss changed to gui directory to save update_file_temp
% 2/8/01: ss updated to version 3.1 & added cold maps to fuel converter
% 2/8/01: ss upadated version and types and names for prototypes.*
% 2/12/01:tm revised load statement to ensure that the correct file is loaded by using the directory info
% 7/02/01:mpo changed prototype drive cycle file to CYC_SKELETON.
% 7/30/01:tm updated version to 3.2
% 7/30/01:tm updated prototype list to include rc menu and NIZN items
% 7/30/01:tm updated addtolist subfunction to handle inline functions
% 7/30/01:tm updated vinf.generator_controller field to vinf.generator
% 8/02/01:mpo updated how add_list is handled to ensure that text strings are put in quotes and end with ';'
% 8/03/01:mpo fixed the order of input to file such that inline functions are last (to insure that arguments are defined first)
% 8/03/01:mpo changed the fprintf routines to deal with (skip) cell arrays and also to correctly handle '%' signs
% 8/03/01:mpo fixed the default (template) files and structure call for TC and TX (manual) to allow for easier update
% 8/06/01:mpo update to PTC_INSIGHT in prototype file names (changed from PTC_INSIGHT_draft to PTC_INSIGHT)
% 8/07/01:mpo added text so that error messages appear when we fall to a CATCH block
% 8/15/01:mpo corrected initial data struct to update prius ptc correctly
% 8/16/01:mpo changed update file to work with directories with spaces in them
% 04/04/02:mpo updated this file to work with version 2000 added new subfunctions: appendSpecialCasesToAddList, determinePrototypeFile, and determineType
% 04/11/02:mpo added new version and type support to sub-function determinePrototypeFile
% 04/15/02:mpo added a check for an "empty" add_list variable
% 04/16/02:mpo added new prototype files
% 04/22/02:mpo added field *.name to prototype.cycle structure--fixed error when updating CYC_* files