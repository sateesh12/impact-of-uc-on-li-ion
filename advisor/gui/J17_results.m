function fig = J17_results(option)

%Colors
blue=[.4 .7 1];
green=[0 .9 .45];
yellow=[1 1 .635];
red=[1 0 0];
pink=[1 .5 .5];

if nargin==0
   global vinf
   
   %Figure
   h0 = figure('Color',blue, ...
      'MenuBar','none', ...
      'Name','J1711 Test Results', ...
      'NumberTitle','off', ...
      'Position',[171 107 757 600], ...
   	'ResizeFcn','gui_size', ...
      'Tag','j1711_results_figure',...
      'Visible','off');
    adv_menu('j1711');
   
   %Back, exit, help
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0 0 0], ...
      'Position',[597 9 154 73], ...
      'Style','frame');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf)', ...
      'Position',[678 15 69 28], ...
      'String','Exit');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf);h=waitbar(0,''Loading J1711 Setup Figure'');TEST_J1711;close(h);', ...
      'Position',[603 15 70 28], ...
      'String','Back');
   h1 = uicontrol('Parent',h0, ...
      'Callback','load_in_browser(''j1711_proc.html'');', ...
      'Position',[678 48 69 28], ...
      'String','Help');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf);clear vinf.acceleration.time_0_60 vinf.acceleration.time_40_60 vinf.acceleration.time_0_85 vinf.acceleration.max_accel vinf.acceleration.feet_5sec vinf.max_grade;SimSetupFig;', ...
      'ListboxTop',0, ...
      'Position',[603 48 70 28], ...
      'String','Back Two');
   
   %title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',blue, ...
      'FontSize',12, ...
      'FontWeight','bold', ...
      'Position',[253 546 315 33], ...
      'String','SAE J1711 Test Procedure Results',...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0 0 0], ...
      'Position',[225 553 366 4],...
      'Style','frame');
   
   %Tree (pushbuttons)
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0.75 0.75 0.75], ...
      'FontWeight','bold', ...
      'Position',[381 535 50 15], ...
      'String','Final', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0.75 0.75 0.75], ...
      'FontWeight','bold', ...
      'Position',[354 444 116 15], ...
      'String','Final, Cycle level', ...
      'Style','text');
   
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''pct'')',...
      'FontWeight','bold', ...
      'Position',[211 263 143 26], ...
      'String','Partial Charge Test', ...
      'Tag','PCT');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct'')',...
      'FontWeight','bold', ...
      'Position',[469 263 143 26], ...
      'String','Full Charge Test', ...
      'Tag','FCT');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''pct-hev'')',...
      'FontWeight','bold', ...
      'Position',[169 200 95 26], ...
      'String','PCT-HEV', ...
      'Tag','PCT-HEV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''soc'')',...
      'Enable','on',...
      'Position',[179 182 73 16], ...
      'String','SOC info.', ...
      'Style','pushbutton', ...
      'Tag','SOC button');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''pct-cv'')',...
      'FontWeight','bold', ...
      'Position',[293 200 95 26], ...
      'String','PCT-CV', ...
      'Tag','PCT-CV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-hev,uf'')',...
      'FontWeight','bold', ...
      'Position',[555 200 95 26], ...
      'String','FCT-HEV,UF', ...
      'Tag','FCT-HEV,UF',...
      'Tooltip','Utility factor weighting of FCT_HEV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-ev,uf'')',...
      'FontWeight','bold', ...
      'Position',[420 200 95 26], ...
      'String','FCT-EV,UF', ...
      'Tag','FCT-EV,UF',...
      'Tooltip','Utility factor weighting of FCT_EV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-hev'')',...
      'FontWeight','bold', ...
      'Position',[555 130 95 26], ...
      'String','FCT-HEV', ...
      'Tag','FCT-HEV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-hev zev'')',...
      'Position',[569 111 67 17], ...
      'String','Add''l info.', ...
      'Style','pushbutton', ...
      'Tag','FCT-HEV button');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-ev'')',...
      'FontWeight','bold', ...
      'Position',[420 130 95 26], ...
      'String','FCT-EV', ...
      'Tag','FCT-EV');
   h1 = uicontrol('Parent',h0, ...
      'Callback','j17_results(''fct-ev zev'')',...
      'Position',[434 111 67 17], ...
      'String','Add''l info.', ...
      'Style','pushbutton', ...
      'Tag','FCT-EV button');
   
   %Final results
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',green, ...
      'Position',[256 466 317 68],...
      'Style','frame');
   if strcmp(vinf.units,'metric')
      str='Emissions (grams/km)';
   else
      str='Emissions (grams/mile)';
   end
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',green, ...
      'HorizontalAlignment','left', ...
      'Position',[402 506 128 21], ...
      'String',str, ...
      'Style','text', ...
      'Tag','StaticText15');
   %Fuel economy/consumption
   if strcmp(vinf.units,'metric')
      str='Fuel Consumption (L/100kmGE)';
   else
      str='Fuel Economy (mpgge)';
   end
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',green, ...
      'HorizontalAlignment','left', ...
      'Position',[267 497 127 30], ...
      'String',str, ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',green, ...
      'FontWeight','bold', ...
      'Position',[316 469 47 21], ...
      'String',num2str(evalin('base','round(j1711_mpg*10)/10')), ...
      'Style','text', ...
      'Tag','mpg_final_value');
   if strcmp(vinf.units,'metric')
      set(h1,'string',evalin('base','round((1/j1711_mpg)*units(''gpm2lp100km'')*10)/10'));
   else
      set(h1,'string',evalin('base','round(j1711_mpg*10)/10'));
   end
   %Emissions
   names2={'HC','CO','NOx','PM'};
   for i=1:length(names2)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',green, ...
         'Position',[366+(i-1)*50 487 40 19], ...
         'String',names2{i}, ...
         'Style','text');
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',green, ...
         'FontWeight','bold', ...
         'Position',[366+(i-1)*50 469 47 21], ...
         'String',num2str(evalin('base',['round(j1711_',names2{i},'_gpmi*units(''gpm2gpkm'')*1000)/1000'])), ...
         'Style','text', ...
         'Tag',[names2{i},'_final_value']);
   end
   
   
   %Final results, cycle level
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',green, ...
      'Position',[255 325 320 118], ...
      'Style','frame', ...
      'Tag','Frame2');
   %Strings
   names3={'Fuel(GE)','HC','CO','NOx','PM'};
   for i=1:length(names3)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',green, ...
         'Position',[316+(i-1)*50 418 40 19], ...
         'String',names3{i}, ...
         'Style','text');
   end
   %cycle strings
   names4={'UDDS','HWFET','US06','SC03'};
   for i=1:length(names4)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',green, ...
         'Position',[263 400-(i-1)*22 40 19], ...
         'String',names4{i}, ...
         'Style','text');
   end
   
   
   names2={'HC','CO','NOx','PM'};
   names={'udds','hwfet','us06','sc03'};
   for i=1:length(names)
      %MPG
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',green, ...
         'FontSize',6, ...
         'FontWeight','bold', ...
         'Position',[316 400-(i-1)*22 47 21], ...
         'String',num2str(evalin('base',['round(1/j_galpmi_final(',num2str(i),')*10)/10'])), ...
         'Style','text', ...
         'Tag',['mpg_',names{i},'_value']);
      if strcmp(vinf.units,'metric')
         set(h1,'string',evalin('base',['round(j_galpmi_final(',num2str(i),')*units(''gpm2lp100km'')*10)/10']));
      else
         set(h1,'string',evalin('base',['round(1/j_galpmi_final(',num2str(i),')*10)/10']));
      end
      for j=1:length(names2)
         %Emissions
         h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',green, ...
            'FontSize',6, ...
            'FontWeight','bold', ...
            'Position',[366+(j-1)*50 400-(i-1)*22 47 21], ...
            'String',num2str(evalin('base',['round(j_',names2{j},'_gpmi_final(',num2str(i),')*units(''gpm2gpkm'')*1000)/1000'])), ...
            'Style','text', ...
            'Tag',[names2{j},'_',names{i},'_value']);
      end
   end
   
   %Bottom box (adjustable values)
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',yellow, ...
      'Position',[60 16 320 147], ...
      'Style','frame', ...
      'Tag','Frame2');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',yellow, ...
      'FontWeight','bold', ...
      'HorizontalAlignment','left', ...
      'Position',[68 140 163 19], ...
      'String','PCT', ...
      'Style','text',...
      'Tag','Box Label');
   
   %Strings (mpg, UDDS)
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',yellow, ...
      'FontSize',6, ...
      'Position',[127 120 50 19], ...
      'String','MPGGE', ...
      'Style','text',...
      'Tag','col1');
   names2={'HC','CO','NOx','PM'};
   for i=1:length(names2)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',yellow, ...
         'FontSize',6, ...
         'Position',[177+(i-1)*50 120 40 19], ...
         'String',names2{i}, ...
         'Style','text',...
         'Tag',['col',num2str(i+1)]);
   end
   
   %cycle strings
   names={'UDDS','HWFET','US06','SC03'};
   for i=1:length(names)
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',yellow, ...
         'HorizontalAlignment','left', ...
         'Position',[68 101-(i-1)*22 40 19], ...
         'String',names{i}, ...
         'Style','text');
   end
   
   names={'udds','hwfet','us06','sc03'};
   names2={'HC','CO','NOx','PM'};
   for i=1:length(names)
      %Fuel ec/consump
      h1 = uicontrol('Parent',h0, ...
         'BackgroundColor',yellow, ...
         'FontSize',6, ...
         'FontWeight','bold', ...
         'Position',[127 107-(i-1)*22 40 15], ...
         'String',num2str(evalin('base',['round(1/j_galpmi_pct(',num2str(i),')*10)/10'])), ...
         'Style','text', ...
         'Tag',['mpg_',names{i},'_value2']);
      for j=1:length(names2)
         %Emissions
         h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',yellow, ...
            'FontSize',6, ...
            'FontWeight','bold', ...
            'Position',[177+(j-1)*50 107-(i-1)*22 40 15], ...
            'String',num2str(evalin('base',['round(j_',names2{j},'_gpmi_pct(',num2str(i),')*1000)/1000'])), ...
            'Style','text', ...
            'Tag',[names2{j},'_',names{i},'_value2']);
      end
   end
   
   
   %Notes section
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',yellow, ...
      'FontSize',6, ...
      'Position',[ 276 140 102 19 ], ...
      'String','Allowable SOC(end) *', ...
      'Style','text', ...
      'Tag','SOC notes');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',blue, ...
      'FontSize',6, ...
      'Position',[ 273 35 4 103 ], ...
      'Style','frame', ...
      'Tag','SOC notes');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',yellow, ...
      'FontSize',6, ...
      'HorizontalAlignment','left',...
      'Position',[ 189 17 190 17 ], ...
      'String','* Calculated based on +-1% fuel energy', ...
      'Style','text', ...
      'Tag','SOC notes');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',red, ...
      'FontSize',6, ...
      'HorizontalAlignment','left',...
      'Position',[ 385 43 193 27 ], ...
      'String','For UDDS and HWFET, SOC(end) must fall within [min max]', ...
      'Style','text', ...
      'Tag','SOC notes');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',pink, ...
      'FontSize',6, ...
      'HorizontalAlignment','left',...
      'Position',[ 385 16 193 27 ], ...
      'String','US06 and SC03 okay if out of range, but SOC(init) <= SOC(init,UDDS)', ...
      'Style','text', ...
      'Tag','SOC notes');
   
   
   %Axes for tree
   h1 = axes('Parent',h0, ...
      'Units','pixels', ...
      'CameraUpVector',[0 1 0], ...
      'Color',blue, ...
      'Position',[154 122 505 218], ...
      'Tag','Axes1', ...
      'Visible','off',...
      'XColor',[0 0 0], ...
      'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   %Lines for tree
   axis([0 1 0 1]);
   line([.5 .25],[.92 .78],'Color',[0 0 0],'LineWidth',1.5);
   line([.5 .75],[.92 .78],'Color',[0 0 0],'LineWidth',1.5);
   line([.25 .11],[.63 .51],'Color',[0 0 0],'LineWidth',1.5);
   line([.25 .39],[.63 .51],'Color',[0 0 0],'LineWidth',1.5);
   line([.6 .75],[.51 .63],'Color',[0 0 0],'LineWidth',1.5);
   line([.9 .75],[.51 .63],'Color',[0 0 0],'LineWidth',1.5);
   line([.6 .6],[.325 .18],'Color',[0 0 0],'LineWidth',1.5);
   line([.9 .9],[.325 .18],'Color',[0 0 0],'LineWidth',1.5);
   
   J17_results('enable');
   J17_results('soc');
   
   %set everything normalized and set the figure size and center it
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   set([h; g],'units','normalized')
   eval('h=vinf.gui_size; test4exist=1;','test4exist=0;')
   if test4exist
      set(gcf,'units','pixels','position',vinf.gui_size);
   else
      screensize=get(0,'screensize'); %this should be in pixels(the default)
      if screensize(3)>=1024
         vinf.gui_size=[124 81 768 576];
         set(gcf,'units','pixels','position',vinf.gui_size);
      else
         set(gcf,'units','normalized')
         set(gcf,'position',[.03 .05 .95 .85]);
         set(gcf,'units','pixels');
      end
   end
   %set the figure back on after everything is drawn
   set(gcf,'visible','on');

end %nargin==0

if nargin > 0
   switch option
   case 'enable'
      if evalin('base','mode_run(2)')==1 %FCT-HEV
         set(findobj('tag','FCT'),'enable','on')
         set(findobj('tag','FCT-HEV,UF'),'enable','on')
         set(findobj('tag','FCT-HEV'),'enable','on')
         set(findobj('tag','FCT-HEV button'),'enable','on')
         if evalin('base','mode_run(4)')==1 %FCT-EV
            set(findobj('tag','FCT-EV,UF'),'enable','on')
            set(findobj('tag','FCT-EV'),'enable','on')
            set(findobj('tag','FCT-EV button'),'enable','on')
         else
            set(findobj('tag','FCT-EV,UF'),'enable','off')
            set(findobj('tag','FCT-EV'),'enable','off')
            set(findobj('tag','FCT-EV button'),'enable','off')
         end
      else
         set(findobj('tag','FCT'),'enable','off')
         set(findobj('tag','FCT-HEV,UF'),'enable','off')
         set(findobj('tag','FCT-HEV'),'enable','off')
         set(findobj('tag','FCT-HEV button'),'enable','off')
         set(findobj('tag','FCT-EV,UF'),'enable','off')
         set(findobj('tag','FCT-EV'),'enable','off')
         set(findobj('tag','FCT-EV button'),'enable','off')
      end
      if evalin('base','mode_run(3)')==1 %PCT-CV
         set(findobj('tag','PCT-CV'),'enable','on')
      else
         set(findobj('tag','PCT-CV'),'enable','off')
      end
      
   case 'pct'
      set(findobj('tag','Box Label'),'string','PCT')
      J17_results('mpg strings');
      names={'udds','hwfet','us06','sc03'};
      names2={'HC','CO','NOx','PM'};
      for i=1:length(names)
         global vinf
         h1=findobj('tag',['mpg_',names{i},'_value2']);
         if strcmp(vinf.units,'metric')
            set(h1,'string',evalin('base',['round(j_galpmi_pct(',num2str(i),')*units(''gpm2lp100km'')*10)/10']));
         else
            set(h1,'string',evalin('base',['round(1/j_galpmi_pct(',num2str(i),')*10)/10']));
         end
         for j=1:length(names2)
            set(findobj('tag',[names2{j},'_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_',names2{j},'_gpmi_pct(',num2str(i),')*units(''gpm2gpkm'')*1000)/1000'])))
         end
      end
      
   case 'fct'
      set(findobj('tag','Box Label'),'string','FCT')
      J17_results('mpg strings');
      names={'udds','hwfet','us06','sc03'};
      names2={'HC','CO','NOx','PM'};
      for i=1:length(names)
         global vinf
         h1=findobj('tag',['mpg_',names{i},'_value2']);
         if strcmp(vinf.units,'metric')
            set(h1,'string',evalin('base',['round(j_galpmi_fct(',num2str(i),')*units(''gpm2lp100km'')*10)/10']));
         else
            set(h1,'string',evalin('base',['round(1/j_galpmi_fct(',num2str(i),')*10)/10']));
         end
         for j=1:length(names2)
            set(findobj('tag',[names2{j},'_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_',names2{j},'_gpmi_fct(',num2str(i),')*units(''gpm2gpkm'')*1000)/1000'])))
         end
      end
      
   case 'pct-hev' %case 1
      set(findobj('tag','Box Label'),'string','PCT-HEV')
      evalin('base','index=1;');
      J17_results('reset values')
      J17_results('mpg strings');
      
   case 'pct-cv' 	%case 3
      set(findobj('tag','Box Label'),'string','PCT-CV')
      evalin('base','index=3;');
      J17_results('reset values');
      J17_results('mpg strings');
      
   case 'fct-ev,uf'	%case 6
      set(findobj('tag','Box Label'),'string','FCT-EV,UF')
      evalin('base','index=6;');
      J17_results('reset values')
      J17_results('mpg strings');
      
   case 'fct-hev,uf'	%case 5
      set(findobj('tag','Box Label'),'string','FCT-HEV,UF')
      evalin('base','index=5;');
      J17_results('reset values')
      J17_results('mpg strings');
      
   case 'fct-ev'		%case 4
      set(findobj('tag','Box Label'),'string','FCT-EV')
      evalin('base','index=4;');
      J17_results('mpg strings');
      J17_results('reset values')
      
   case 'fct-hev'		%case 2
      set(findobj('tag','Box Label'),'string','FCT-HEV')
      evalin('base','index=2;');
      J17_results('reset values')
      J17_results('mpg strings');
      
   case 'reset values'
      global vinf;
      names={'udds','hwfet','us06','sc03'};
      names2={'HC','CO','NOx','PM'};
      for i=1:length(names)
         h1=findobj('tag',['mpg_',names{i},'_value2']);
         if strcmp(vinf.units,'metric')
            set(h1,'string',evalin('base',['round(j_galpmi(',num2str(i),',index)*units(''gpm2lp100km'')*10)/10']));
         else
            set(h1,'string',evalin('base',['round(1/j_galpmi(',num2str(i),',index)*10)/10']));
         end
         %Emissions
         for j=1:length(names2)
            set(findobj('tag',[names2{j},'_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_',names2{j},'_gpmi(',num2str(i),',index)*units(''gpm2gpkm'')*1000)/1000'])))
         end
      end
      
   case 'mpg strings'
      set(findobj('tag','col1'),'string','Fuel(GE)')
      names2={'HC','CO','NOx','PM'};
      for i=1:length(names2)
         set(findobj('tag',['col',num2str(i+1)]),'string',names2{i})
      end
      %set color of end 'soc' to yellow, in case set to red earlier
      names={'udds','hwfet','us06','sc03'};
      for i=1:length(names)
         set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',yellow) %set to yellow
      end
      set(findobj('tag','SOC notes'),'visible','off')
      
   case 'soc'
      set(findobj('tag','Box Label'),'string','SOC values for PCT-HEV')
      J17_results('soc strings');
      
      names={'udds','hwfet','us06','sc03'};
      
      for i=1:length(names)
         %j_SOC(cyc,tst,time)
         dsoc=round(j17_dsoc(i)*1000)/1000;
         soc_end=evalin('base',['round(j_SOC_end(',num2str(i),',1)*1000)/1000']);
         if i==1	%for UDDS case
            soc_init=evalin('base',['round(j_SOC_init(',num2str(i),',1)*1000)/1000']);
            set(findobj('tag',['mpg_',names{i},'_value2']),'string',num2str(soc_init))
            set(findobj('tag',['HC_',names{i},'_value2']),'string','n/a')
            set(findobj('tag',['NOx_',names{i},'_value2']),'string',num2str(soc_init-dsoc))
            set(findobj('tag',['PM_',names{i},'_value2']),'string',num2str(soc_init+dsoc))
            if abs(soc_end-soc_init)>dsoc
               set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',red) %set to red
            else
               set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',yellow) %set to yellow
            end
            %for use below
            soc_init_udds=soc_init;
         else
            soc_init=evalin('base',['round(j_SOC_init(',num2str(i),',1)*1000)/1000']);
            soc_pause=evalin('base',['round(j_SOC_pause(',num2str(i),',1)*1000)/1000']);
            set(findobj('tag',['mpg_',names{i},'_value2']),'string',num2str(soc_init))
            set(findobj('tag',['HC_',names{i},'_value2']),'string',num2str(soc_pause))
            set(findobj('tag',['NOx_',names{i},'_value2']),'string',num2str(soc_pause-dsoc))
            set(findobj('tag',['PM_',names{i},'_value2']),'string',num2str(soc_pause+dsoc))
            if soc_init<=soc_init_udds & abs(soc_end-soc_pause)>dsoc & i>=3 %pink case only for us06 and sc03
               set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',pink) %set to pink
            elseif abs(soc_end-soc_pause)>dsoc
               set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',red) %set to red
            else
               set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',yellow) %set to yellow
            end
         end
         
         set(findobj('tag',['CO_',names{i},'_value2']),'string',num2str(soc_end))
         
      end
      
      
   case 'soc strings'
      set(findobj('tag','col1'),'string','init')
      set(findobj('tag','col2'),'string','pause')
      set(findobj('tag','col3'),'string','end')
      set(findobj('tag','col4'),'string','[min')
      set(findobj('tag','col5'),'string','max]')
      set(findobj('tag','SOC notes'),'visible','on')
      
   case 'fct-hev zev' %tst=2
      set(findobj('tag','Box Label'),'string','FCT-HEV Outputs')
      J17_results('range strings');
      names={'udds','hwfet','us06','sc03'};
      for i=1:length(names)
         %1st column: kWh, 2nd: ZEV range, 3rd: util at ZEV range
         set(findobj('tag',['mpg_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_kWh(',num2str(i),',2)*10)/10'])))
         set(findobj('tag',['HC_',names{i},'_value2']),'string','')
         set(findobj('tag',['CO_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_zev_mi(',num2str(i),',2)*units(''miles2km'')*10)/10'])))
         set(findobj('tag',['NOx_',names{i},'_value2']),'string','')
         set(findobj('tag',['PM_',names{i},'_value2']),'string',num2str(evalin('base',['round(J17_util(j_zev_mi(',num2str(i),',2))*100)/100'])))
      end
      
   case 'fct-ev zev' %tst=4
      set(findobj('tag','Box Label'),'string','FCT-EV Outputs')
      J17_results('range strings');
      names={'udds','hwfet','us06','sc03'};
      for i=1:length(names)
         %1st column: kWh, 2nd: ZEV range, 3rd: util at ZEV range
         set(findobj('tag',['mpg_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_kWh(',num2str(i),',4)*10)/10'])))
         set(findobj('tag',['HC_',names{i},'_value2']),'string','')
         set(findobj('tag',['CO_',names{i},'_value2']),'string',num2str(evalin('base',['round(j_zev_mi(',num2str(i),',4)*units(''miles2km'')*10)/10'])))
         set(findobj('tag',['NOx_',names{i},'_value2']),'string','')
         set(findobj('tag',['PM_',names{i},'_value2']),'string',num2str(evalin('base',['round(J17_util(j_zev_mi(',num2str(i),',4))*100)/100'])))
      end
      
   case 'range strings'
      set(findobj('tag','col1'),'string','kWh chg')
      set(findobj('tag','col2'),'string','')
      set(findobj('tag','col3'),'string','ZEV rng')
      set(findobj('tag','col4'),'string','')
      set(findobj('tag','col5'),'string','UF')
      %set color of end 'soc' to yellow, in case set to red earlier
      names={'udds','hwfet','us06','sc03'};
      for i=1:length(names)
         set(findobj('tag',['CO_',names{i},'_value2']),'BackgroundColor',yellow) %set to yellow
      end
      set(findobj('tag','SOC notes'),'visible','off')

   end %switch, cases
end %nargin > 0

%Revision history
% 3/9/99: vhj file created
% 3/10/99: vhj added soc info for PCT, add'l info under FCT-HEV and FCT-EV
% 3/15/99: vhj added notes for SOC info, add'l titles
% 5/10/99: vhj mpgge instead of mpg
% 9/17/99: vhj units, simplified soc/add'l results cases
% 9/22/99: vhj 'pink' SOC case re-added
% 9/22/99: vhj normalized figure, prints okay
% 11/05/99: ss removed call to waitbar when pressing back two button, (confusion with the Simulation Setup Figure waitbar).
% 7/10/99:ss all references to FUDS are now UDDS
