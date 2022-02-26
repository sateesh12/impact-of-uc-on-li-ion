function list=variable_selection(compname,return_list)
%function variable_selection
% This function is for use with the input figure.  It determines the list of components currently
% active for variable editing purposes.  It also determines what list of variables is available for each
% currently active component.  It then updates the variable popupmenus.
%
% input arguments:
%    if none:
%       this function will setup a default component and variable list
%
%    compname: 
%       can be any of the component names (full names)
%       this function will select the list of variables for compname
%
% created on 1/15/01 by ss of NREL for ADVISOR

global vinf 

% set up the component list and the variable list if function called with no input arguments
if  nargin == 0 
    
    %get the component_titles list
    comp_titles=optionlist('get','component_titles');
    
    %make a list out of the components that are currently being used
    input_vars_compo={};   
    for i=1:length(comp_titles)
        %add component to list if it exists in vinf variable and is not 'drivetrain'
        if isfield(vinf,comp_titles{i}) & ~strcmp(comp_titles{i},'drivetrain')
            input_vars_compo{end+1,1}=comp_titles{i};
        end
    end
    
    %set the popupmenu with the above list
    set(findobj('tag','input_variables_components'),'string',input_vars_compo)
    
    %set up the list of variables with a default component (the first one in the list)
    variable_selection(input_vars_compo{1});
    
    return
    
end

if nargin > 0
    
    %get the shortname of the component for figuring out which variables to accept into
    %the variable list
    short_compname=compo_name(compname);
    
    %find all current variables that are scalar and update list for input figure
    
    vars{1,1}='none';
    %select only scalar variables of type double array
    h=evalin('base','whos');%this is a structure
    j=1;
    for i=1:size(h,1)
        if (isequal(h(i).size,[1 1]) & strcmp(h(i).class,'double'))
            vars{j,1}=h(i).name;
            j=j+1;
        end
    end
    
    %use only variables starting with the short component name
    vars_index=strmatch([short_compname,'_'],vars); % ab 3_15_02 added '_' to short_compname to prevent ess2 vars appearing for energy_storage in edit var
    
    % The following if statement adds more variables for specified components
    if strcmp(short_compname,'tx')
        vars_index1=strmatch('gb',vars);
        vars_index2=strmatch('fd',vars);
        vars_index3=strmatch('tc',vars);
        vars_index=[vars_index; vars_index1; vars_index2; vars_index3];
    elseif strcmp(short_compname,'ptc')
        vars_index1=strmatch('cs',vars);
        vars_index2=strmatch('vc',vars);
        vars_index=[vars_index; vars_index1; vars_index2];
    end
    
    %use only the matched variables
    vars=vars(vars_index);
    
    if nargin > 1 & return_list==1
        list=vars;
    else
        set(findobj('tag','variable_list'),'string',vars,'value',1); %ss 6/12/00 added 'value',1 to prevent errors
        %make sure the variable value displays correctly
        if ~strcmp(vars{1},'none')
            gui_edit_var('update');
        end
        
    end
    
    
end

%Revision History
% 1/15/01 ss: new file (created from input_plot_selection.m)
% 1/18/01 ss: added more prefixes of variables to 'tx' and 'ptc'
% 2/1/01 ss: added tc variables for transmission
