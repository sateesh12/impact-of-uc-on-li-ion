function []=gui_input_open(option)

%gui_input_open(option)
%
%	If option='defaults', this function will open the input figure with
%	the default values.  
%	If option='popup pick', this function will load the selected vehicle
%  input file chosen from the popupmenu on the input screen.
%  If option= name of file to open the function will load that particular file.
%  If no input arguments, this function provides the user with a file
%	selection figure so that an ADVISOR 2.0 input file can be opened. 
%	After the selection of the input file, the input figure is opened
%  with the appropriate values from the input file.

global vinf

%load default if not already in workspace
if ~isfield(vinf, 'optionlist')
    load list_optionlist.mat
    vinf.optionlist.name=list_def;
end

if nargin==0
    %This is the file selection figure that returns file and path names
    %It is set such that it will only show files with an '_in.m' ending.
    
    old_dir=pwd;
    new_dir=strrep(which('advisor.m'),'advisor.m','saved_vehicles\');
    cd(new_dir)
    
    f=uigetfile('*_in.m');
    
    cd(old_dir)
    
    %if no file is selected(ie. figure is cancelled) then exit(or return)
    %out of this function
    if f==0
        return
    end
    
    file_name=strrep(f,'.m','');
    
    %close the input figure(it will be reopened later with the new input file
    %values).  This assumes that the figure is open to start with, which is
    %true if this function is used as intended.
    
    close(gcf);
    
    %this section added to preserve vinf.gui_size if it exists, which will dictate
    %the size of the advisor figures
    eval('temp=vinf.gui_size; test4exist=1;','test4exist=0;')
    temp2=vinf.units;
    temp3=vinf.optionlist.name;
    
    %clear vinf if present
    clear global vinf
    
    global vinf
    
    if test4exist
        vinf.gui_size=temp; %reassign the variable vinf.gui_size
    end
    vinf.units=temp2;
    vinf.optionlist.name=temp3;
    
elseif nargin>0
    switch option
    case 'defaults'
        file_name='PARALLEL_defaults_in';
        
    case 'popup pick'
        strings=get(findobj('tag','input_file_names'),'string');
        value=get(findobj('tag','input_file_names'),'value');
        file_name=strings{value};
        
        close(gcf)
        
        clear(file_name); %remove the stored function from memory for proper update.
    otherwise   
        file_name=option;
    end   
    
    % ADDED 9/26/00:tm to ensure selected file is in the Matlab path
    if isempty(which([file_name,'.m']))
        uiwait(warndlg(['File ', file_name,' cannot be used until it is present in the Matlab path.']))
        [f,p]=uigetfile([file_name,'.m'],'Locate File');
        if (p~=0)&strcmp(f,[file_name,'.m'])
            addpath(p);
            uiwait(warndlg(['Directory ', p,' successfully added to Matlab path.']))
        elseif (p==0)&(f==0)
            InputFig;
            return
        else
            uiwait(warndlg(['This file name does not match the file selected from the list. Previous file will be loaded']))
            InputFigC;
            return
        end
    end
    % end added 9/26/00:tm
    
    %this section added to preserve vinf.gui_size if it exists, which will dictate
    %the size of the advisor figures
    eval('temp=vinf.gui_size; test4exist=1;','test4exist=0;')
    temp2=vinf.units;
    temp3=vinf.optionlist.name;
    
    %clear vinf if present
    clear global vinf
    
    global vinf
    
    if test4exist
        vinf.gui_size=temp; %reassign the variable vinf.gui_size
    end
    vinf.units=temp2;
    vinf.optionlist.name=temp3;
    
end




%Run the selected file.
eval(['run ''',file_name,'''']);

%------------------------------------
%COMPATIBILITY SECTION
%This section is to allow old files pre 9/30/98 to be used, the change is
%that only a transmission is going to be specified now instead of a gearbox and
%a final drive, they are now one name

eval('h=vinf.gearbox.name; test4exist=1;','test4exist=0;')
if test4exist
    if strcmp(vinf.gearbox.name,'GB_1SPD')
        vinf.transmission.name='GB_1SPD';   
    elseif strcmp(vinf.gearbox.name,'GB_5SPD')
        vinf.transmission.name='GB_5SPD';   
    elseif strcmp(vinf.gearbox.name,'GB_CVT')
        vinf.transmission.name='GB_CVT';   
    end
    vinf=rmfield(vinf,'gearbox');
    vinf=rmfield(vinf,'final_drive');
    helpdlg('vinf.gearbox.name was changed to vinf.transmission.name and vinf.final_drive.name was deleted, please save vehicle with new transmission!','update')
    uiwait
end

%commented out on 1/28/99
%following has to do with exhaust files
%eval('h=vinf.exhaust_aftertreat.name; test4exist=1;','test4exist=0;')
%if test4exist
%   if strcmp(vinf.exhaust_aftertreat.name,'EX_SI')
%      vinf.exhaust_aftertreat.name='EX_SI_SMCAR';   
%      helpdlg('EX_SI was changed to EX_SI_SMCAR, please save vehicle with new exhaust!','update')
%      uiwait
%   end
%end

%following has to do with transmission files
if strcmp(vinf.transmission.name,'GB_1SPD')
    vinf.transmission.name='TX_1SPD';   
    helpdlg('GB_1SPD was changed to TX_1SPD, please save vehicle with new transmission name!','update')
    uiwait
elseif strcmp(vinf.transmission.name,'GB_5SPD')
    vinf.transmission.name='TX_5SPD';
    helpdlg('GB_5SPD was changed to TX_5SPD, please save vehicle with new transmission name!','update')
    uiwait
elseif strcmp(vinf.transmission.name,'GB_CVT')
    vinf.transmission.name='TX_CVT';
    helpdlg('GB_CVT was changed to TX_CVT, please save vehicle with new transmission name!','update')
    uiwait
end






%-------------------------------------
global vinf

vinf.name=file_name;

if ~isfield(vinf, 'model')
    vinf.model='ADVISOR';
end


%Run the function that opens the input figure
InputFig;

%THE END

%Revisions
%9/24/98-ss added global vinf and vinf.name=... at the end
% 2/5/99-ss updated so that vinf.gui_size is preserved if it exist which will
%		keep the advisor figures at the desired size.
% 9/15/99 ss preserved the vinf.units variable throughout this function.
% 7/10/00 ss: made it so it would open up the  dialogue within the 'saved_vehicles' directory.
% 7/11/00 ss: added the case where user is selecting a vehicle from the new popupmenu on input screen.
% 7/19/00 ss: added vinf.model to the end.  Needed in InputFig.
% 7/21/00 ss: added clear(file_name) to clear the vehicle from memory so it reads in newly saved information.
% 8/13/00 ss: changed default file from SERIES_defaults to SERIES_defaults_in.
% 8/21/00 ss: changed default file to PARALLEL_defaults_in.
% 8/22/00 ss: under otherwise, set filename to option for loading a specified file.
% 9/27/00:tm added section to ensure that selected saved vehicle file is in the current path
% 4/26/02:tm moved additions from 9/27 to before clear vinf statement and added code to handle cancel and wrong file selection cases
%