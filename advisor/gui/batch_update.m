function batch_update(optionlist, startDir, destDir)
% function batch_update(optionlist, startDir, destDir)
% Takes in an optionlist, and directory for m-files to update
%
% optionlist -- string with name of optionlist *.mat file containing structure called "options" (e.g., optionlist_all.mat)
% startDir   -- string with the name of the directory holding the files to be updated
% destDir    -- string with the name of the directory where files should be copied and updated to 
% note: if startDir and destDir are the same, the files will be updated in their current directory without copying

DEBUG=0; % used to turn on/off debugging functionality

load(optionlist);
if ~exist('options')
    disp(['The file ',optionlist,' does not contain the structure options. Exiting...'])
    return
end
disp('BEGIN batch_update.m')
tic
pathinfo=what(startDir);
disp(['Pathinfo has been obtained from directory: ', startDir,' (',num2str(length(pathinfo.m)),' m-files found)'])
for i=1:length(pathinfo.m)
    if ~strcmp(startDir,destDir)
        disp(' ')
        disp(['Copying: ',startDir, filesep, pathinfo.m{i}, ' to directory ',destDir])
        disp(' ')
        try
            copyfile([startDir,filesep,pathinfo.m{i}],destDir,'writable');
        catch
            disp('Unable to copy file ', [startDir,filesep,pathinfo.m{i}])
            disp('...to directory ', destDir);
            disp('Moving on... Note: files may not be updated correctly')
        end
    end
    disp(' ')
    disp(['Updating ', pathinfo.m{i}]) 
    [compName, verName, typeName]=findInfo(options, pathinfo.m{i});
    disp(' ')
    disp([pathinfo.m{i},' COMP: ',compName,' VERSION: ',verName,' TYPE: ', typeName])
    try
        update_file(pathinfo.m{i}, destDir, compName, verName, typeName);
    catch
        disp(['File ',pathinfo.m{i},' has encountered an error in update_file.m. This file has not been updated correctly.'])
        disp(lasterr)
    end
    disp(' ')
end
disp('END batch_update.m ')
toc

function [compName, verName, typeName]=findInfo(options, fname)
% This subfunction figures out component, version, and type by mucking through an optionlist file to 
% find a match for fname. If fname is in more than once, only the first occurance will be returned
% fname should not include the *.m extension--just the name
prefix_label={'FC','fuel_converter';
    'ESS','energy_storage';
    'TX','transmission';
    'PTC','powertrain_control';
    'WH','wheel_axle';
    'ACC','accessory';
    'VEH','vehicle';
    'CYC','cycles';
    'MC','motor_controller';
    'TC','torque_coupling'; % mpo [3-Aug-2001] changed from coupler to coupling
    'GC','generator';
    'EX','exhaust_aftertreat'};

prefix=upper(strtok(fname,'_'));  % ensure all letters are capitalized
datafile_name=upper(strtok(fname,'.')); % discard the extension
disp(' ')
disp(['Determining version, type, and component for ', fname,' ...'])
list=prefix_label(:,1);
try
    initIndex=strmatch(prefix,list,'exact');
    compName=prefix_label{initIndex,2};
catch
    %OK, so the user is not using our naming convention, we'll have to muck through the whole thing
    %let's start with fuel_converter...
    compName='fuel_converter';
    prefix='FC';
    initIndex=1;
end
disp(['Checking optionlist for component: ', compName])
disp(' ')
prefixLowerCase=lower(prefix);

found=0;
index=initIndex;
while ~found 
    disp(' ')
    disp(['prefix_label index is ', num2str(index),' corresponding to ',prefix_label{index,1},' [',prefix_label{index,2},']'])
    disp(' ')
    numVers=eval(['length(options.', prefixLowerCase, '_ver)'],'0');
    numTypes=zeros(1,numVers);
    if isempty(numTypes)
        numTypes=0;
    end
    for i=1:numVers
        numTypes(i)=eval(['length(options.', prefixLowerCase, '_type{',num2str(i),'})'],'0');
    end
    % OK, now we know the number of versions and the number of types per version. Now let's try accessing the... 
    % listing of files to see if we can get a match on datafile_name (in UPPER case)
    if numVers==0 
        % OK, this should be easy--no version and let's assume that means no type either
        disp(['There is no version or type for component ', compName])
        fListing=eval(['upper(options.', compName,')'],'[]'); % let's use upper to be consistent
        if isempty(fListing)
            disp(['No files listed in options.', compName]);
        elseif strmatch(datafile_name, fListing, 'exact')
            % We found it!
            found=1;
            % NOTE: compName declared above
            compName=compName;
            verName=[]; % no version
            typeName=[]; % assume no type either
            return
        end
    elseif numVers>0
        for verCnt=1:numVers
            for typeCnt=1:numTypes(verCnt)
                disp(['Checking version ',num2str(verCnt),' and type ',num2str(typeCnt),' for component ', compName])
                fListing=eval(['upper(options.', compName,'{',num2str(verCnt),'}{', num2str(typeCnt),'})'],'[]');
                if isempty(fListing)
                    disp(['No files listed in options.', compName]);
                elseif strmatch(datafile_name, fListing, 'exact')
                    % We found it!
                    found=1;
                    % NOTE: compName declared above
                    verName=eval(['options.',prefixLowerCase,'_ver{',num2str(verCnt),'}']); 
                    typeName=eval(['options.',prefixLowerCase,'_type{',num2str(verCnt),'}{',num2str(typeCnt),'}']);
                    return
                end
            end
        end
    else
        disp(['Error evaluating number of versions for ',compName])
    end
    % end of loop updating:
    index=mod(index+1,length(prefix_label(:,1))); 
    if index==0
        index=length(prefix_label(:,1));
    end
    if index==initIndex 
        %OK, we've gone through all of the components... and no file, ...
        % Therefore, we don't know the version, type, or component name...
        compName=[];
        verName=[];
        typeName=[];
        found=0;
        if DEBUG
            disp('[batch_update.m]: index has gone one full revolution...')
            keyboard
        end
        return
    end
    prefix=prefix_label{index,1};
    prefixLowerCase=lower(prefix);
    compName=prefix_label{index,2};
end
