function [fileInfo,savedFile]=getFileInfo(savedFile)

%   Assign savedFile if not sent in
if ~exist('savedFile')
    evalin('base','save TempWorkspaceFile');
    savedFile={'TempWorkspaceFile'};
end

%   Get fieldnames in the savedFile
for fileNum=1:length(savedFile)
    tempFileInfo=load(savedFile{fileNum});
    tempFileFields{fileNum}=fieldnames(tempFileInfo);
end

%   Get complete list of fieldnames found in every file
unionOfFileFields=tempFileFields{1};
if length(tempFileFields) > 1
    for fileNum=2:length(savedFile)
        unionOfFileFields=union(unionOfFileFields,tempFileFields{fileNum});
    end
end

%   Assign fileInfo
for fileNum=1:length(savedFile)
    tempFileInfo=load(savedFile{fileNum});
    for fieldInd=1:length(unionOfFileFields)
        if isfield(tempFileInfo,unionOfFileFields{fieldInd})
            eval(['fileInfo(fileNum).',unionOfFileFields{fieldInd},'=tempFileInfo.',unionOfFileFields{fieldInd},';']);
        end
    end
end


