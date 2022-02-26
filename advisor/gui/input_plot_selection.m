function input_plot_selection(compname)
%function input_plot_selection
% This function is for use with the input figure.  It determines the list of components currently
% active for plotting purposes.  It also determines what list of plots is available for each
% currently active component.  It then updates the plotting popupmenus.
%
% input arguments:
%    if none:
%       this function will setup a default plot
%
%    compname: 
%       can be any of the component names (full names)
%       this function will select the list of plots for compname
%
% created on 10/23/00 by ss of NREL for ADVISOR

global vinf 


% set up the component list and the plot list if function called with no input arguments
if  nargin == 0 
   
   %load all the options for access to component_titles and *_plot lists
	%load default if not already in workspace
   if ~isfield(vinf, 'optionlist')
        load list_optionlist.mat
        vinf.optionlist.name=list_def;
    end

   load(vinf.optionlist.name) 
   
   %get the component titles in the 'options' structure(ex. fuel_converter, motor_controller, etc.)
   %use shorter variable name to hold component titles
   comp_titles=options.component_titles; 
   
   %make a list out of the components that are currently being used
   input_plots_compo={};   
	for i=1:length(comp_titles)
      %add component to list if it exists in vinf variable 
      oklist4comp_plot={'fuel_converter';
         'motor_controller';
         'energy_storage';
         'transmission'};
      if isfield(vinf,comp_titles{i})&strmatch(comp_titles{i},oklist4comp_plot)
         input_plots_compo{end+1,1}=comp_titles{i};
      end
   end
   
   %set the popupmenu with the above list
   set(findobj('tag','input_plots_components'),'string',input_plots_compo)
   
   return
   
end

if nargin==1
   
   short_compname=compo_name(compname);
   % if the plots are based on the component version then the following will work
   str=['vinf.' compname];
   if eval(['isfield(', str , ',''ver'')'])
      ver=eval(['vinf.' compname '.ver']);
      ver_index=strmatch(ver,optionlist('get',[short_compname '_ver'],''));
      input_plots=optionlist('get',[short_compname '_plot']);
      if iscell(input_plots{1})
         input_plots=input_plots{ver_index};
      end
   else
      input_plots=optionlist('get',[short_compname '_plot']);
   end
   
   set(findobj('tag','input_plots'),'string',input_plots,'value',1)
   
   evalin('base','gui_inpchk')
   
end

%Revision History
% 10/27/00 ss: finished creating this file
