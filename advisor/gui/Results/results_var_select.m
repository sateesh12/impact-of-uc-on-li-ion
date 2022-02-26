function results_var_select(compname)
%function results_var_select
% This function is for use with the results figure.  It determines the list of components currently
% active for time variable plotting purposes.  It also determines what list of variables is available for each
% currently active component.  It then updates the variable popupmenu.
%
% input arguments:
%    if none:
%       this function will setup a default component and variable list
%
%    compname: 
%       can be any of the component names (full names)
%       this function will select the list of variables for compname
%
% created on 2/21/01 by ss of NREL for ADVISOR

global vinf 

% set up the component list and the variable list if function called with no input arguments
if  nargin == 0 
    
    %get the component_titles list
    comp_titles=optionlist('get','component_titles');
    
    %make a list out of the components that are currently being used
    results_vars_compo={};   
    for i=1:length(comp_titles)
        %add component to list if it exists in vinf variable and is not 'drivetrain'
        if isfield(vinf,comp_titles{i}) & ~strcmp(comp_titles{i},'drivetrain')
            results_vars_compo{end+1,1}=comp_titles{i};
        end
    end
    
    %add 'saber' and 'other' components
    if ~isempty(evalin('base','who(''saber_*'')'))
        results_vars_compo{end+1,1}='saber';
    end
    results_vars_compo{end+1,1}='other';
    
    
    %set the popupmenu with the above list
    set(findobj('tag','result_variable_components'),'string',results_vars_compo)
    
    %set up the list of variables with a default component (the first one in the list)
    results_var_select(results_vars_compo{1});
    
    return
    
end

if nargin==1
    
    %get the shortname of the component for figuring out which variables to accept into
    %the variable list
    short_compname=compo_name(compname);
    
    %find all current variables that are time dependent and update list for results figure
    
    vars=gui_get_vars('time');
    
    %use only variables starting with the short component name
    vars_index=strmatch([short_compname,'_'],vars);
    
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
    elseif strcmp(short_compname,'other');
       comp_titles=optionlist('get','component_titles');
       for i=1:length(comp_titles)
          if ~strcmp(comp_titles{i},'drivetrain')
             vars_index=[vars_index; strmatch(compo_name(comp_titles{i}),vars)];
          end
       end
       add_vars={'gb' 'fd' 'tc' 'cs' 'vc' 'saber'};
       for i=1:length(add_vars)
          vars_index=[vars_index; strmatch(add_vars{i},vars)];
       end
       %select only variables that are not indexed by vars_index
       opp_vars_index=[];
       for i=1:length(vars)
          if isempty(find(vars_index==i))
             opp_vars_index=[opp_vars_index; i];
          end
       end
       
       
       vars_index=opp_vars_index;
       
       
       
    end
    
    %use only the matched variables
    vars=vars(vars_index);
    
    set(findobj('tag','time_plots_popupmenu'),'string',vars,'value',1); 
    
end

%Revision History
% 2/22/01 ss: new file (created from variable_selection)
% 5/31/01: vhj added saber to list of components if running a saber cosim, add to nargin=0