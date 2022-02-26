function ModBD(StandardInputVars,NewInputVars,AltiaBlockName,BDName)

%   Assign block info
BDFileName=[BDName,'.mdl'];
NewBDName=[BDName,'2'];
NewBDFileName=[BDName,'.mdl'];
AddSignalTemplate=[NewBDName,'/signal_template'];
AltiaBlockPath=[NewBDName,'/',AltiaBlockName];
NumAltiaInputs=length(StandardInputVars) + 2*length(NewInputVars);
BDFullPath=which(BDFileName);

%   Assign parameters aligning blocks
SigLeftPos=100;
SigVertSpacing=30;
SigWidth=80;
SigHeight=(SigVertSpacing*2)-4;
AltiaTopPos=60;
AltiaLeftPos=400;
AltiaRightPos=AltiaLeftPos+50;

%   Create new block based on BDName
open(BDFullPath);
save_system(BDName,NewBDName);

%   Set Altia block parameters
AltiaBlockPos=[AltiaLeftPos AltiaTopPos AltiaRightPos ((NumAltiaInputs*SigVertSpacing)+AltiaTopPos)];
set_param(AltiaBlockPath,'Position',AltiaBlockPos);
set_param(AltiaBlockPath,'NumAltiaSfnInputs',num2str(NumAltiaInputs));

%   Add blocks for each input signal to Altia (beyond the standard inputs:  time, MinPosTimeStep, etc.)
for NewInputInd=1:length(NewInputVars)
    SigBlockName=NewInputVars{NewInputInd};
    SigBlockPath=[NewBDName,'/',SigBlockName];
    add_block(AddSignalTemplate,SigBlockPath,'VarName',['''',SigBlockName,'''']);
    top_pos=(AltiaTopPos + ((length(StandardInputVars)-2)*SigVertSpacing) + (2*SigVertSpacing*(NewInputInd)));
    SigBlockPos=[SigLeftPos top_pos SigWidth+SigLeftPos SigHeight+top_pos];
    set_param(SigBlockPath,'position',SigBlockPos);
    OutPort1=[SigBlockName,'/1'];
    AltiaInPort1=[AltiaBlockName,'/',num2str(length(StandardInputVars)+(NewInputInd*2) -1)];
    Line1Handle=add_line(NewBDName,OutPort1,AltiaInPort1);
    set_param(Line1Handle,'name',[SigBlockName,'1']);
    OutPort2=[SigBlockName,'/2'];
    AltiaInPort2=[AltiaBlockName,'/',num2str(length(StandardInputVars)+(NewInputInd*2))];
    Line2Handle=add_line(NewBDName,OutPort2,AltiaInPort2);
    set_param(Line2Handle,'name',[SigBlockName,'2']);
end

delete_block(AddSignalTemplate);

save_system(NewBDName);
% close_system(NewBDName);
