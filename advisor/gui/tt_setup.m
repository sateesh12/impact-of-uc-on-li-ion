function flag=tt_setup(option)

%
% GUI interface to setup component tech targets
%

global vinf

if nargin<1
   option='load';
end

switch option
   
case 'load'
   
   % set figure color
   figure_color=[1 1 .8];
   
   % setup figure and attribute sizes
   screen_size=get(0,'screensize');
   line_height=20;
   char_width=10;
   border=20;
   button_width=60;
   button_height=25;
   editbox_width=60;
   editbox_height=line_height;
   line_num=1;
   par_width=screen_size(3)/3;
   par_height=(eval(['length(vinf.tt.',vinf.tt.comp_name,'.params.value)'])*2+5)*line_height;
   par_left=screen_size(3)/3;
   par_bottom=screen_size(4)-par_height-100;
   posfig=[par_left par_bottom par_width par_height];
   
   % build parent figure
   h0 = figure('Color',figure_color, ...
      'Position',posfig, ...
      'numbertitle','off',...
      'name','Component Technical Target Definition Window',...
      'windowstyle','modal');
   
   % baseline datafile selection 
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color, ...
      'Position',[border par_height-line_num*line_height 10*char_width line_height], ...
      'HorizontalAlignment','left',...
      'String','Baseline Datafile', ...
      'Fontweight','normal',...
      'Style','text');
   
   %%%%%%%%%%%%%%%%%%%% get fuel converter based on version and type
   if isfield(eval(['vinf.' vinf.tt.comp_name]),'ver')
      version=eval(['vinf.' vinf.tt.comp_name '.ver']);
      if isfield(eval(['vinf.' vinf.tt.comp_name]),'type')
         type=eval(['vinf.' vinf.tt.comp_name '.type']);
         str='optionlist(''get'', vinf.tt.comp_name ,''junk'',version,type)';
      else
         str='optionlist(''get'', vinf.tt.comp_name ,''junk'',version)';
      end
   else
      str='optionlist(''get'', vinf.tt.comp_name)';
   end
   
   list=eval(str); 
   
   
   h1 = uicontrol('Parent',h0, ...
      'FontSize',8, ...
      'Position',[border+10*char_width par_height-line_num*line_height 10*char_width line_height], ...
      'String',eval(str), ...
      'Style','popupmenu', ...
      'Tag','baseline_datafile', ...
      'Value',eval(['strmatch(vinf.tt.',vinf.tt.comp_name,'.filename, list ,''exact'')']));
   
   % parameter definition section
   for x=1:eval(['length(vinf.tt.',vinf.tt.comp_name,'.params.value)'])
      line_num=line_num+1;
      line_num=line_num+1;
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',figure_color, ...
         'Position',[border par_height-line_num*line_height (par_width-2*border) line_height], ...
         'String',eval(['vinf.tt.',vinf.tt.comp_name,'.params.description(',num2str(x),')']), ...
         'HorizontalAlignment','left',...
         'Fontweight','normal',...
         'Style','text');
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',[1 1 1], ...
         'Position',[par_width-editbox_width-border par_height-line_num*line_height editbox_width line_height], ...
         'String',num2str(eval(['vinf.tt.',vinf.tt.comp_name,'.params.value(',num2str(x),')'])), ...
         'Style','edit', ...
         'enable','on', ...
         'Tag',['param_',num2str(x),'']);
   end
   
   % OK button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','tt_setup(''ok'')',...
      'Position',[(par_width-button_width*3)/4 border button_width button_height], ...
      'String','OK', ...
      'Tag','Pushbutton1');
   % cancel button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','tt_setup(''cancel'')',...
      'Position',[2*(par_width-button_width*3)/4+1*button_width border button_width button_height], ...
      'String','CANCEL', ...
      'Tag','Pushbutton2');
   % Help button
   h1 = uicontrol('Parent',h0, ...
      'CallBack','load_in_browser(''tech_targets_help.html'');',...
      'Position',[3*(par_width-button_width*3)/4+2*button_width border button_width button_height], ...
      'String','HELP', ...
      'Tag','Pushbutton3');
   
   str=eval(['vinf.',vinf.tt.comp_name,'.name']);
   index=min(findstr('_',str));
   prefix=lower(str(1:index));
   vars=evalin('base',['who(''',prefix,'*'')']);
   if length(vars)>1
      set(findobj('String','CANCEL'),'enable','on')
   else
      set(findobj('String','CANCEL'),'enable','off')
   end
   
   uiwait % pause gui execution until user replies
   
case 'ok'
   
	eval(['vinf.tt.',vinf.tt.comp_name,'.filename=gui_current_str(''baseline_datafile'');']);
   
   for x=1:eval(['length(vinf.tt.',vinf.tt.comp_name,'.params.value)'])
      eval(['vinf.tt.',vinf.tt.comp_name,'.params.value(',num2str(x),')=str2num(get(findobj(''tag'','''['param_',num2str(x)],'''),''string''));']);
   end
   
   close(gcf)
   
case 'cancel'
   
   close(gcf)

   % restore to previous file name
   eval(['vinf.',vinf.tt.comp_name,'.name=vinf.',vinf.tt.comp_name,'.prev_name;'])
   
      %%%%%%%%%%%%%%%%%%%% get fuel converter based on version and type
   if isfield(eval(['vinf.' vinf.tt.comp_name]),'ver')
      version=eval(['vinf.' vinf.tt.comp_name '.ver']);
      if isfield(eval(['vinf.' vinf.tt.comp_name]),'type')
         type=eval(['vinf.' vinf.tt.comp_name '.type']);
         str='optionlist(''get'', vinf.tt.comp_name ,''junk'',version,type)';
      else
         str='optionlist(''get'', vinf.tt.comp_name ,''junk'',version)';
      end
   else
      str='optionlist(''get'', vinf.tt.comp_name)';
   end
   list=eval(str);

   % update the gui
   set(findobj('tag',vinf.tt.comp_name),'value',eval(['strmatch(vinf.',vinf.tt.comp_name,'.name, list ,''exact'')']))
   
end
% revision history
% 02/17/99:tm file created 
% 3/11/99:tm added cancel button
% 3/15/99:ss pointed help to tech_targets_help.htm instead of advisor_doc.htm
% 7/17/00: ss replaced gui options with optionlist.
% 8/21/00:tm updated set statement in case cancel - changed vinf.tt',...'.filename to vinf.',...'.name
%
