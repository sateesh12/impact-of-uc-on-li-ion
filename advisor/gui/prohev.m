function [hevPath] = prohev(veh_wheelbase, ...
  wh_radius, ... 
  fc_fuel_mass, ...
  fc_fuel_den, ...
  ess_module_num, ...
  ess_max_ah_cap)
%-----------------------------------------------------------------------
% FILE    : prohev.m
% PURPOSE : Interface code for Pro/HEV.
%
% HISTORY..
% DATE           BUILD      AUTHOR   MODIFICATIONS
% 13 Oct 1999   Matlab 5.3    ljl      $$1 Started
% 29 Oct 1999   Matlab 5.3    ljl      $$2 Further refined.
% 14 Nov 1999   Matlab 5.3    ljl      $$3 Completed for Pro/HEV 1.1.
% 23 Nov 1999   Matlab 5.3    ljl      $$4 Added advisor_ver() call.
% 28 Nov 1999   Matlab 5.3    ljl      $$5 Changed ADVISOR output file name.
% 29 Nov 1999   Matlab 5.3    ljl      $$6 Added (1) on ess_max_ah_cap. For
%                                          ADVISOR 2.2.1.
% 30 Nov 1999   Matlab 5.3    ljl      $$7 Added max(ess_max_ah_cap).
%-----------------------------------------------------------------------

% ------------------------  CONSTANTS  ---------------------------------
%
% Name-value pair separator.
NVSEP = '=';

% Name-value pair terminator.
NVTERM = ';';

% HEV file extension.
HEV_EXT = '.hev';
HEV_EXT_DIALOG = '*.hev';

% Units scales.
M_MM_SCALE = 1000; % m to mm
L_GAL_SCALE = 0.264; % L to gallon
KG_G_SCALE = 1000; % kg to g

% ---------------------------------------------------------------------

disp('Exporting HEV data for Pro/HEV 1.1.');

% Get access to the vinf variable.
global vinf;

% Get the target location for the ADVISOR data.
advPath = getAdvLocation;
if (isempty(advPath))
  disp('ADVISOR path is empty. Aborting.');
  return;
end

% Get the name and location of the output file.
[f, p] = uiputfile(HEV_EXT_DIALOG, 'Pro/HEV 1.1 Save');

if f == 0
  return;
end

%make sure file does not contain -,+,!,~,&
if ~isempty(findstr('-',f))|~isempty(findstr('+',f))|~isempty(findstr('!',f))|...
      ~isempty(findstr('~',f))|~isempty(findstr('&',f))
	WARNDLG({'invalid filename';'illegal characters -,+,!,~,&'})
	return
end

%If the filename length is less than the extension length, add the extension.
if (length(f) < length(HEV_EXT))
    f = [f, HEV_EXT];
else
  % If the filename length is greater than the extension length, append the 
  % HEV extension only if needed.
  if (strcmp(f(length(f)-(length(HEV_EXT)-1):length(f)), HEV_EXT) == 0)
    f = [f, HEV_EXT];
  end
end

% Get the root of the HEV file, to be used as root for ADVISOR filename.
hevroot = f(1:length(f)-4);
% Write ADVISOR data to a known location.
fAdvPath = autoSaveADVISOR(advPath, hevroot);
disp(['Wrote current vehicle data to ' fAdvPath]);

% Open the HEV output file.
fname = [p, f];
fid = fopen(fname, 'w');

if fid < 0 
  disp('Could not open HEV file.');
  return
end

nowtime = datestr(now, 'dd-mmm-yyyy HH:MM:SS');
fprintf(fid, '# Pro/HEV data file.\n');
fprintf(fid, '# Pro/HEV version: 1.1.\n');
fprintf(fid, '# Origin: %s\n', advisor_ver('info'));
fprintf(fid, '# Creation date: %s\n', nowtime);
fprintf(fid, '\n');

% Set vehicle class, etc.
fprintf(fid, 'VEHICLE_CLASS %s %s%s\n', NVSEP, ...
  getVehicleClass(veh_wheelbase), NVTERM);
fprintf(fid, 'VEHICLE_NAME %s %s%s\n', NVSEP, vinf.name, NVTERM);
fprintf(fid, 'ESS_NAME %s %s%s\n', NVSEP, vinf.energy_storage.name, NVTERM);
fprintf(fid, 'WH_NAME %s %s%s\n', NVSEP, vinf.wheel_axle.name, NVTERM);
fprintf(fid, 'DRIVETRAIN %s %s%s\n', NVSEP, vinf.drivetrain.name, NVTERM);
fprintf(fid, 'VEH_WHEELBASE %s %f%s\n', NVSEP, veh_wheelbase*M_MM_SCALE,... 
  NVTERM);

% fc* variables are not defined for electric vehicles
if (exist('fc_fuel_mass') == 0)
  fprintf(fid, 'FUEL_TANK_VOLUME %s %f%s\n', NVSEP, 0.0, NVTERM);
else
  % Need volume in gallons.
  % Fuel mass is in kg. (NOTE: Includes tank.)
  % Assume fuel density is in g/L.
  fprintf(fid, 'FUEL_TANK_VOLUME %s %f%s\n', NVSEP, ...
    KG_G_SCALE*L_GAL_SCALE*fc_fuel_mass/fc_fuel_den, NVTERM);
end

% Tire dimensions. Same for front and rear.
fprintf(fid, 'TIRE_DIA %s %f%s\n', NVSEP, 2*wh_radius*M_MM_SCALE, NVTERM);

% ess* variables are not defined for conventional vehicles.
if exist('ess_module_num') == 0
  fprintf(fid, 'ESS_MAX_AH_CAP %s %f%s\n', NVSEP, 0, NVTERM);
  fprintf(fid, 'ESS_MODULE_NUM %s %d%s\n', NVSEP, 1, NVTERM);
else
  fprintf(fid, 'ESS_MAX_AH_CAP %s %f%s\n', NVSEP, max(ess_max_ah_cap), NVTERM);
  fprintf(fid, 'ESS_MODULE_NUM %s %d%s\n', NVSEP, ess_module_num, NVTERM);
end

% Write the location of the ADVISOR output file.
fprintf(fid, 'ADVISOR_DATA %s %s%s\n', NVSEP, fAdvPath, NVTERM);

fclose(fid);

disp(['Wrote HEV data to ' fname]);

% Copy HEV path to output argument. To show success.
hevPath = fname;

return

% -------------------------------------------------------------------
% Function to get the target location of the ADVISOR data.
function [advPath] = getAdvLocation()
  advPath = getenv('PROHEV_ADV_LOCATION');
return 

% -------------------------------------------------------------------
% Save the ADVISOR data.
function [fullAdvPath] = autoSaveADVISOR(dirPath, rootname)

  % Build the name of the ADVISOR file based on the current time.
  %fTimeName = [datestr(now, 'dd-mmm-yyyy') '-' datestr(now, 'HH:MM:SS')];
  % Had some problem with - and :. Replace with _.
  %fTimeName = strrep(fTimeName, '-', '_');
  %fTimeName = strrep(fTimeName, ':', '_');

  fpath = saveADVISOR([rootname, '_in.m'], [dirPath, '/']);

  % Copy the full path to the output argument. To show success.
  fullAdvPath = fpath;

return

% -------------------------------------------------------------------
% Get the vehicle class.
function [vehClass] = getVehicleClass(wBase)
  if (wBase <= 2700)
    vehClass = 'SMALL CAR';
  elseif (wBase > 2700 & wBase <= 2880)
    vehClass = 'MIDSIZE CAR';
  elseif (wBase > 2880)
    vehClass = 'LARGE CAR';
  end
return;	

% -------------------------------------------------------------------
% Save an ADVISOR file.
% Arguments: 
% f: the name of the file
% fPath: the directory location, including the terminating '/'
function [outFilePath] = saveADVISOR(f, fPath)
  global vinf
  filePath = [fPath, f];
  
  fid = fopen(filePath ,'wt');
  if (fid <= 0)
    disp(['ERROR: Could not write ADVISOR file ' filePath]);
	outFilePath = '';
    return;
  end
   
  fprintf(fid,['%% ',f , '  ADVISOR 2.0 input file created: ', ... 
    datestr(now,0),'\n\n']);
  
  fprintf(fid,'global vinf \n\n');
  
  comp=optionlist('get','component_titles');
  fwithoutmext=strrep(f,'.m','');
  vinf.name=fwithoutmext;
  fprintf(fid,['vinf.name=''',fwithoutmext,''';\n']);
  for x=1:size(comp,1)
     string=gui_current_str(comp{x,1});
     fprintf(fid,['vinf.',comp{x,1},'.name=''',string,''';\n']);
  end
  
  % check to see if there are any modified variables, and if so then write 
  % them to the file
  %this is sort of an 'exist' statement for structures
  eval('vinf.variables; test4exist=1;','test4exist=0;');
  if test4exist
     for i=1:max(size(vinf.variables.name))
        fprintf(fid,['vinf.variables.name{',num2str(i),'}=''', ...
		  vinf.variables.name{i},''';\n']);
        fprintf(fid,['vinf.variables.value(',num2str(i),')=', ...
		  num2str(vinf.variables.value(i)),';\n']);
        fprintf(fid,['vinf.variables.default(',num2str(i),')=', ...
		  num2str(vinf.variables.default(i)),';\n']);
     end
  end
  
  fclose(fid);

  % Copy to output argument, to show success.
  outFilePath = filePath;
    
return

% 7/17/00: ss replaced gui options with optionlist.
% 7/21/00 ss: updated name for version info to advisor_ver.
