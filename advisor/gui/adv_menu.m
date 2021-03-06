function adv_menu(figure_name)

%adv_menu.m
%this is the ADVISOR Menubar for the figures
%figure_name options:
%		input
%		execute
%		results
%		parametric
%     energy
%		city/hwy results
%     ftp results

global vinf

if strcmp(figure_name,'input')
   h0=findobj('tag','input_figure');
elseif strcmp(figure_name,'execute')
   h0=findobj('tag','execute_figure');
elseif strcmp(figure_name,'results')
   h0=findobj('tag','results_figure');
else
   h0=gcf;
end

%File menu(standard to all)
filemenu = uimenu('Parent',h0, ...
	'Label','File');
h2= uimenu('Parent',filemenu,...
   'label','Print Figure',...
   'callback','printdlg');
h2=uimenu('Parent',filemenu,...
   'label','Simulation Info.',...
   'callback','summary_listbox(''load'')');

h2=uimenu('Parent',filemenu,...
   'label','&Export...',...
   'callback','filemenufcn(gcbf,''FileExport'')');
  

%Edit Menu(standard to all)
h1=uimenu('Parent',h0,...
   'label','Edit');
h2=uimenu('Parent',h1,...
   'label','Copy Axes to Figure',...
   'callback','CopyAxes2Fig');
h2=uimenu('Parent',h1,...
   'label','Copy Figure (Bitmap)',...
   'callback','print -dbitmap -zbuffer');
h3=uimenu('Parent',h1,...
   'label','Copy Figure (Metafile)',...
   'callback','print -dmeta -zbuffer');


%set the labels for the units menu
label_metric='Metric';
label_us='US';
switch figure_name
   
case 'input'
   h2 = uimenu('Parent',filemenu, ...
      'CallBack','gui_save_input',...
      'Label','Save Vehicle');
   h2 = uimenu('Parent',filemenu, ...
      'Callback','OptionListFigControl(''open'',''input_file_names'');', ...
      'Label','Load Vehicle');
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';InputFig(''units'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''metric units''),''checked'',''off'');',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';InputFig(''units'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''us units''),''checked'',''off'');',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
  if 0 %disabled model menu for now since it will only be ADVISOR 
  %model menu
   model_menu=uimenu('parent',h0,...
      'label','Model');
   
   if ~isfield(vinf, 'model')
      vinf.model='ADVISOR';
   end
   
   if strcmp(vinf.model,'ADVISOR')
      advisor_checked='on';
   else
      advisor_checked='off';
   end
   if strcmp(vinf.model,'PSAT')
      psat_checked='on';
   else
      psat_checked='off';
   end
   
   
   
   h2=uimenu('parent',model_menu,...
      'callback','close(gcf);vinf.model=''ADVISOR'';InputFig',...
      'label','ADVISOR',...
      'checked',advisor_checked);
   

   
   h2=uimenu('parent',model_menu,...
      'callback','helpdlg(''This option is not yet fully functional.  NREL is working with ANL to integrate the PSAT (PNGV Systems Analysis Toolkit) Simulink model into a common GUI (based on ADVISOR) which can be used to run both models.  PSAT was written by SwRI, beginning in 1995, and over the last year has been modified and improved by ANL.  Many of the things in the GUI screens that are currently "grayed out" will be used in the future by PSAT and ADVISOR.'')',...
      'label','PSAT',...
      'checked',psat_checked);

end %if 0
  
case 'execute'
   h2 = uimenu('Parent',filemenu, ...
      'CallBack','gui_save_execute',...
      'Label','Save Sim. Setup');
   h2 = uimenu('Parent',filemenu, ...
      'Callback','SimSetupFig(''load_exec_pushbutton_Callback'')', ...
      'Label','Load Sim. Setup');
   
   
   h2 = uimenu('Parent',filemenu, ...
      'Separator','on',...
      'CallBack','advisor(''Load_Results_Callback'')',...
      'Label','Load Sim. Results');
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';SimSetupFig(''units4SimSetupFig'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''metric units''),''checked'',''off'');',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';SimSetupFig(''units4SimSetupFig'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''us units''),''checked'',''off'');',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
  
  % condor 
  if ~isfield(vinf,'condor')
      vinf.condor.run='off';
      condor_on_checked='off';
      condor_off_checked='on';
  elseif strcmp(vinf.condor.run,'on')
      condor_on_checked='on';
      condor_off_checked='off';
  else
      condor_on_checked='off';
      condor_off_checked='on';
  end
   condor_menu=uimenu('Parent',h0,...
      'Label','Condor');
   condor_on_item=uimenu('Parent',condor_menu,...
      'Callback','vinf.condor.run=''on'';set(gcbo,''checked'',''on'');set(findobj(''tag'',''condor off''),''checked'',''off'');',...   
      'Label','On',...
      'checked',condor_on_checked,...
      'tag','condor on');
   condor_off_item=uimenu('Parent',condor_menu,...
      'Callback','vinf.condor.run=''off'';set(gcbo,''checked'',''on'');set(findobj(''tag'',''condor on''),''checked'',''off'');',...   
      'Label','Off',...
      'checked',condor_off_checked,...
      'tag','condor off');

%options menu
options_menu=uimenu('Parent',h0,...
      'Label','Options');
runDOE_item=uimenu('Parent',options_menu,...
      'Callback','rundoe',...
      'Label','Run DOE');   
loadDOE_results_item=uimenu('Parent',options_menu,...
      'Callback','doeresults',...
      'Label','Load DOE Results');   
  
  
case 'results'
   h3=uimenu('Parent',filemenu,...
      'Callback','ResultsFig(''save_simulation'')',...
      'Label','Save Simulation');
   h2 = uimenu('Parent',filemenu, ...
   'CallBack','advisor(''Load_Results_Callback'')',...
   'Label','Load Sim. Results');
   h3=uimenu('Parent',filemenu,...
      'Callback','close(gcf);compare_sims_setup',...
      'Label','Compare Simulations');
   
   tools_menu=uimenu('Parent', h0,...
      'Label', 'Tools');
   
   fc_operation_menu=uimenu('Parent', tools_menu,...
      'Label','FC operation',...
      'callback','fuel_per_cycle');
   
   
   units_menu=uimenu('Parent',h0,...
   'Label','Units');

if strcmp(vinf.units,'metric')
   us_checked='off';
   metric_checked='on';
else
   us_checked='on';
   metric_checked='off';
end

	english_units=uimenu('Parent',units_menu,...
   'Callback','vinf.units=''us'';ResultsFig(''units4ResultsFig'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''metric units''),''checked'',''off'');',...   
   'Label',label_us,...
   'checked',us_checked,...
   'tag','us units');
	metric_units=uimenu('Parent',units_menu,...
   'Callback','vinf.units=''metric'';ResultsFig(''units4ResultsFig'');set(gcbo,''checked'',''on'');set(findobj(''tag'',''us units''),''checked'',''off'');',...
   'Label',label_metric,...
   'checked',metric_checked,...
   'tag','metric units');

case 'parametric'
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);parametric_gui;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);parametric_gui;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
case 'energy'
   
case 'loss_plot'
   
case 'j1711'
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);J17_results;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);J17_results;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
case 'real world setup'
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);TEST_REAL_WORLD;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);TEST_REAL_WORLD;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
case 'real world results'
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);RW_results;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);RW_results;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
   
case 'city/hwy results'
   
   units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);gui_cty_hwy_results;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);gui_cty_hwy_results;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
   
case 'ftp results'
     units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);gui_ftp_results;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);gui_ftp_results;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
 
case 'compare simulations'
     units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);compare_sims;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);compare_sims;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
case 'prius speeds'
     units_menu=uimenu('Parent',h0,...
      'Label','Units');
   
   if strcmp(vinf.units,'metric')
      us_checked='off';
      metric_checked='on';
   else
      us_checked='on';
      metric_checked='off';
   end
   
   english_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''us'';close(gcf);plot_prius_spds;',...   
      'Label',label_us,...
      'checked',us_checked,...
      'tag','us units');
   metric_units=uimenu('Parent',units_menu,...
      'Callback','vinf.units=''metric'';close(gcf);plot_prius_spds;',...
      'Label',label_metric,...
      'checked',metric_checked,...
      'tag','metric units');
   
otherwise
end

%add the exit item to filemenu after everything else has been added
h2=uimenu('Parent',filemenu,...
   'Separator','on',...
   'label','Exit ADVISOR',...
   'callback','close(gcbf)');

%Help Menu(standard to all)
h1=uimenu('Parent',h0,...
   'label','Help');

h2=uimenu('Parent',h1,...
   'label','Matlab Help');
h3=uimenu('Parent',h2,...
   'label','Help Window',...
   'callback','helpwin');
h3=uimenu('Parent',h2,...
   'label','Help Tips',...
   'callback','helpwin helpinfo');
h3=uimenu('Parent',h2,...
   'label','Help Desk (HTML)',...
   'separator','on',...
   'callback','doc');
h3=uimenu('Parent',h2,...
   'label','Examples and Demos',...
   'callback','demo',...
   'separator','on');

%if version is 5.3 then do the proper about menu
if findstr(version,'5.3')
   aboutcallback='uimenufcn(gcbf,''HelpAbout'')';
else
   aboutcallback='';
end
  
h3=uimenu('Parent',h2,...
   'label','About Matlab...',...
   'CallBack',aboutcallback);

h3=uimenu('Parent',h2,...
   'label','Join Matlab Access',...
   'separator','on',...
   'CallBack','doc subscribe'  );
   
h2=uimenu('Parent',h1,...
   'Separator','on',...
   'label','ADVISOR Help (HTML)',...
   'callback','load_in_browser(''advisor_doc.html'');');
h2=uimenu('Parent',h1,...
   'callback','about',...
   'label','About ADVISOR...');
h2=uimenu('Parent',h1,...
   'label','ADVISOR Online',...
   'callback','web(''http://bigladdersoftware.com/advisor'',''-browser'')',...
   'separator','on');


% 9/14/99: vhj added save simulation to results case.
% 9/15/99: ss added units choice of vinf.units='metric' or 'us'.
% 9/16/99: vhj added units to real world choices
% 9/20/99: vhj added units to parametric
% 9/20/99: ss moved help menu to end so it would be last item on menu.
% 9/20/99: ss added units to cty_hwy and ftp results figures.
% 9/28/99: vhj added 'compare simulations' w/ units
%10/04/99: vhj compare simulations added to file menu for results
% 11/19/99: ss updated callback for print from 'print' to 'printdlg'
% 11/19/99: ss added edit menu item for copying axes to new figure.
% 11/29/99: ss added Save Pro/HEV menu item to input figure file menu.
% 2/8/00: ss 'units' calls InputFig now instead of gui_input in the input figure menu
% 3/21/00 ss: InputFig('units') was just InputFig and removed close(gcf) for input figure units menus
%             SimSetupFig('units4SimSetupFig') was SimFigControl.
%             ResultsFigControl('units') was 'close(gcf);gui_results'.
% 3/21/00 ss: made axis to fit figure when copying an axis to a new figure.
% 7/7/00 ss: edit menu copy axes to figure now calls new function CopyAxes2Fig
% 8/14/00 ss: updated callback for load vehicle in case 'input'
% 8/14/00 ss: added load and save sim. setup to uimenu for case 'execute'
% 8/21/00 ss: disabled save PRO/HEV uimenu on input figure.
% 1/31/01 ss: commented out model menu (psat/advisor) for now since it will only run ADVISOR
% 4/17/01 ss: added VSOL to File menu
% 6/22/01 ss: updated the name VSOL to VSOLE
% 7/13/01 ss: added Export to filemenu
% 7/19/01 ss: updated callback to VSOLE, it is now 'vsole', it was 'window9'
% 2/15/02: ss replaced ResultsFigControl with ResultsFig
% 8/4/03: ss removed VSOLE from menu pick as this is no longer available
%              through ADVISOR
