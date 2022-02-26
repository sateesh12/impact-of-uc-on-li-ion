%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Names=GetInputNames(FileName,ReqInputVars)

NonCommentLines=textread(FileName,'%s','delimiter','\n','commentstyle','shell');

VarNameCounter=1;
for LineNum=1:length(NonCommentLines)
    if (length(NonCommentLines{LineNum}) > 4) & (strcmp(NonCommentLines{LineNum}(1:3),'out'))
        StartInd=strfind(NonCommentLines{LineNum},'(')+1;
        EndInd=strfind(NonCommentLines{LineNum},')')-1;
        VarNameRaw=NonCommentLines{LineNum}(StartInd:EndInd);
        
        if  isempty(strmatch(VarNameRaw,ReqInputVars,'exact'))
            VarNames{VarNameCounter,1}=VarNameRaw;
            VarNameCounter=VarNameCounter+1;
        end
    end
end
Names=unique(VarNames);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ModifyBD=Check4InputChanges(PrevAddInputVarsRaw,AddInputVars,numFiles);

PrevAddInputVars=PrevAddInputVarsRaw(1:numFiles:length(PrevAddInputVarsRaw));
if length(PrevAddInputVars)==length(AddInputVars)
    for AddInputVarInd=1:length(AddInputVars)
        if ~strcmp(AddInputVars{AddInputVarInd},PrevAddInputVars{AddInputVarInd}(1:end-1))
            ModifyBD=1;
        end
    end
else
    ModifyBD=1;
end

if ~exist('ModifyBD')
    ModifyBD=0;
end


%**************************************************************************
%   Build block diagram if changed from previous save
PrevAddInputVarsRaw=GetInputNames('Altia_Advisor2.mxc',ReqInputVars);
ModifyBD=Check4InputChanges(PrevAddInputVarsRaw,AddInputVars,length(FileInfo));
if 0%ModifyBD
    [ModifyBD]=questdlg('Changes have been found.  Would you like to automatically rebuild the Simulink model that communicates with Altia?');
    if strcmp(ModifyBD,'Yes')
        rebuildBD(AddInputVars,ReqInputVars,length(FileInfo),AltiaDesignName,BaseModelName);
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rebuildBD(AddInputVars,ReqInputVars,numFiles,AltiaDesignName,BaseModelName);

AddInputSigCounter=1;
for AddInputVarInd=1:length(AddInputVars)
    for fileNum=1:numFiles
        AddInputSigs{AddInputSigCounter}=[AddInputVars{AddInputVarInd},num2str(fileNum)];
        AddInputSigCounter=AddInputSigCounter+1;
    end
end
buildReplayBD(ReqInputVars,AddInputSigs,AltiaDesignName,BaseModelName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function buildReplayBD(StandardInputVars,NewInputVars,AltiaBlockName,BDName)

%   Assign block info
BDFileName=[BDName,'.mdl'];
NewBDName=[BDName,'2'];
NewBDFileName=[BDName,'.mdl'];
addInputsTemplate=[NewBDName,'/addInputsTemplate'];
AltiaBlockPath=[NewBDName,'/',AltiaBlockName];
NumAltiaInputs=length(StandardInputVars) + length(NewInputVars);
BDFullPath=which(BDFileName);

%   Assign parameters aligning blocks
SigLeftPos=100;
SigWidth=80;
SigHeight=15;
SigVertSpacing=10;
AltiaLeftPos=400;
AltiaWidth=50;
AltiaTopPos=60;

%   Create new block based on BDName
open(BDFullPath);
save_system(BDName,NewBDName);

%   Set Altia block parameters
AltiaBottomPos=(((NumAltiaInputs+1)*SigVertSpacing) + NumAltiaInputs*SigHeight + AltiaTopPos);
AltiaBlockPos=[AltiaLeftPos AltiaTopPos (AltiaLeftPos+AltiaWidth) AltiaBottomPos];
set_param(AltiaBlockPath,'Position',AltiaBlockPos);
set_param(AltiaBlockPath,'NumAltiaSfnInputs',num2str(NumAltiaInputs));

%   Set required inputs block properties
reqSigTopPos=AltiaTopPos+SigVertSpacing;
reqSigBottomPos=reqSigTopPos + (length(StandardInputVars)*(SigVertSpacing+SigHeight)) - SigVertSpacing;
reqBlockPos=[SigLeftPos reqSigTopPos SigLeftPos+SigWidth reqSigBottomPos];
set_param([NewBDName,'/Required Inputs'],'Position',reqBlockPos);

%   Add blocks for each input signal to Altia (beyond the standard inputs:  time, MinPosTimeStep, etc.)
for NewInputInd=1:length(NewInputVars)
    SigBlockName=NewInputVars{NewInputInd};
    SigBlockPath=[NewBDName,'/',SigBlockName];
    add_block(addInputsTemplate,SigBlockPath,'outputVector',SigBlockName,'timeVector',['time',SigBlockName(end)]);
    
    %   Position block
    sigTopPos=reqSigBottomPos + SigVertSpacing + ((NewInputInd-1)*(SigVertSpacing+SigHeight));
    sigBottomPos=sigTopPos+SigHeight;
    SigBlockPos=[SigLeftPos sigTopPos SigLeftPos+SigWidth sigBottomPos];
    set_param(SigBlockPath,'position',SigBlockPos);
    
    %   Connect signal block to Altia block
    OutPort1=[SigBlockName,'/1'];
    AltiaInPort1=[AltiaBlockName,'/',num2str(length(StandardInputVars) + (NewInputInd))];
    Line1Handle=add_line(NewBDName,OutPort1,AltiaInPort1);
    set_param(Line1Handle,'name',SigBlockName);
end

delete_block(addInputsTemplate);

save_system(NewBDName);
close_system(NewBDName);


