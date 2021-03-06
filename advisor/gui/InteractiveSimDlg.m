function InteractiveSimDlg

% This function creates a msgbox when "Interactive Simulation" is checked from the SimSetupFig

global vinf

if exist('Interactive_msg.m')
   assignin('base','dont_show',0);
   [vdoc_image,vdoc_image_map] = evalin('base','imread(''advisor.bmp'',''bmp'')');
   interactive_description_msg=['By selecting the interactive simulation checkbox, a real time interactive interface will display dynamic '...
         'outputs and offer tools to create a drive cycle ''''on the fly.''''  A 0.1 second time step and the CYC_INTERACTIVE drive cycle '...
         'are recommended.  To automatically make these changes, select ''''Accept Changes'''' below.  To decline, select ''''Decline Changes.  '''''...
         'For additional information select Help.'];
   h_msg=msgbox(interactive_description_msg,'Interactive Message','custom',vdoc_image,vdoc_image_map);
   DeclineHdl=findobj('string','OK');
   set(DeclineHdl,'string','Decline Changes');
   DeclinePos=get(DeclineHdl,'position');
   new_DeclinePos=DeclinePos;
   new_DeclinePos=[118 14 78 20];
   set(DeclineHdl,'position',new_DeclinePos)
   set(h_msg,'windowstyle','modal')
   h1 = uicontrol('Parent',h_msg, ...
      'Callback','dont_show=get(findobj(''tag'',''interactive_msg_checkbox''),''value'');', ...
      'Position',[60 0 165 20], ...
      'String','Don''t show this message again.', ...
      'Style','checkbox', ...
      'Tag','interactive_msg_checkbox',...
      'Value',evalin('base','dont_show'));
   h1 = uicontrol('Parent',h_msg, ...
      'Callback','close; vinf.cycle.name=''CYC_INTERACTIVE''; set(findobj(''tag'',''cycles''),''String'',optionlist(''get'',''cycles''),''Value'',optionlist(''value'',''cycles'',vinf.cycle.name));SimSetupFig(''cycles_Callback'');set(findobj(''tag'',''time_step''),''String'',''.1'');SimSetupFig(''time_step_Callback'');', ...
      'Position',[60 20 95 26], ...
      'String','Accept Changes', ...
      'Style','pushbutton', ...
      'Tag','interactive_decline_pushbutton');
   h1 = uicontrol('Parent',h_msg, ...
      'Callback','close; load_in_browser(''realtime_interface.html'');', ...
      'Position',[265 20 50 26], ...
      'String','Help', ...
      'Style','pushbutton', ...
      'Tag','interactive_help_pushbutton');
   uiwait(h_msg)
   if evalin('base','dont_show')==1
      path_old=evalin('base','which(''Interactive_msg.m'')');
      name_new='Interactive_ms_.m';
      evalin('base',['!rename "',path_old,'" ',name_new,''])
   end
   evalin('base','clear dont_show')
   
end

% 1/29/01 ab: created
