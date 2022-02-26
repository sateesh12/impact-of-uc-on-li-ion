%   runCustomDG(resultFiles,mappingFile)
%       Runs custom results files using dynamic graphics
%       Example inputs:
%           resultFiles={'fileName1','fileName2'};
%           mappingFile='customDynGraphTemplate_mine';
%           
%       **Note:  Do not include ".mat" on result filenames
function runCustomDG(resultFiles,mappingFile);

for fileNum=1:length(resultFiles)
    load(resultFiles{fileNum});
    eval(mappingFile);

    modResultFiles{fileNum}=[resultFiles{fileNum},'_4DG'];
    save(modResultFiles{fileNum});
end

DynamicReplay(3,modResultFiles) % 3 => Dynamic Compare