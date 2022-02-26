function Good=SaberCheck

global vinf

%   Check if any versions are "saber"
if (isfield(vinf,'energy_storage') & isfield(vinf.energy_storage,'ver') & strcmp(vinf.energy_storage.ver,'saber')) |...
        (isfield(vinf,'energy_storage2') & isfield(vinf.energy_storage2,'ver') & strcmp(vinf.energy_storage2.ver,'saber')) |...
        (isfield(vinf,'vehicle') & isfield(vinf.vehicle,'ver') & strcmp(vinf.vehicle.ver,'saber')) |...
        (isfield(vinf,'generator') & isfield(vinf.generator,'ver') & strcmp(vinf.generator.ver,'saber')) |...
        (isfield(vinf,'fuel_converter') & isfield(vinf.fuel_converter,'ver') & strcmp(vinf.fuel_converter.ver,'saber')) |...
        (isfield(vinf,'transmission') & isfield(vinf.transmission,'ver') & strcmp(vinf.transmission.ver,'saber')) |...
        (isfield(vinf,'wheel_axle') & isfield(vinf.wheel_axle,'ver') & strcmp(vinf.wheel_axle.ver,'saber')) |...
        (isfield(vinf,'powertrain_control') & isfield(vinf.powertrain_control,'ver') & strcmp(vinf.powertrain_control.ver,'saber')) |...
        (isfield(vinf,'accessory') & isfield(vinf.accessory,'ver') & strcmp(vinf.accessory.ver,'saber')) |...
        (isfield(vinf,'exhaust_aftertreat') & isfield(vinf.exhaust_aftertreat,'ver') & strcmp(vinf.exhaust_aftertreat.ver,'saber'))
    
    
    AimExeTxt=strrep(which('advisor.m'),'advisor.m','gui\SaberCosim\aimexe.txt');
    
    if ~exist(AimExeTxt)
        GetAimExe;
        Good=0;
    elseif FileBad(AimExeTxt)
        WarnHandle=warndlg('Bad aim.exe file location.  If you have Saber, locate the aim.exe path.  If not, you cannot choose components with version ''saber.''','Warning');
        uiwait(WarnHandle);
        GetAimExe;
        Good=0;
    elseif BadDir
        WarnHandle=warndlg('The ADVISOR-Saber co-simulation does not work with spaces in the ADVISOR path.','Warning');
        uiwait(WarnHandle);
        Good=0;
    else
        Good=1;
        vinf.saber_cosim.run=1;
    end
    
else
    Good=1;
    vinf.saber_cosim.run=0;
end


function [Bad]=FileBad(AimExeTxt)

% Get aim.exe location
fid=fopen(AimExeTxt,'r');
AimExeLocation=fscanf(fid,'%s');
fclose(fid);

if ~exist(AimExeLocation) | ~exist([AimExeLocation,'aim.exe'])
    Bad=1;
else
    Bad=0;
end


function [DirBad]=BadDir

AdvisorPath=evalin('base','which(''Advisor.m'')');

if ~isempty(findstr(' ',AdvisorPath))
    DirBad=1;
else
    DirBad=0;
end