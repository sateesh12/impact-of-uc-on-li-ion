function compare_sims(action)
% gui to compare simulations
global vinf bar_h spider_h axes1 axes2 last_axes

if nargin==0
   %Initializations
   %names={'FE','FEGE','HC','CO','NOx','PM','t0-60','t40-60','t0-85','MaxAccel','Dist5sec','Grade'};
   if ~exist('vinf.comparesims.metric.inner.us')
      %Set defaults to PNGV/Tier2
      vinf.comparesims.metric.inner.us=[26.7,26.7,.25,2.4,.7,.8,18,35,7.8,8,50,2];
      vinf.comparesims.metric.outer.us=[80,80,.125,1.7,.07,.08,12,23.4,5.3,16,135,6];
      vinf.comparesims.metric.max_display=1.5;
   end
   
   %setup the colors for the figure
   figure_color=[1 1 1];
   main_frame_color=[.4 .7 1];
   plot_col=[0.7 1 1];
   button_frame_color=[0 0 0];   
   scale_color=[0.75 .75 .75];
   
   % The figure properties
   h0 = figure('Color',main_frame_color, ...
      'Name',['Compare Simulations--',advisor_ver('info')], ...
      'Position',[477 274 768 576], ...
      'NumberTitle','off',...
      'ResizeFcn','gui_size',...
      'MenuBar','none',...
      'Tag','compare_results_figure',...
      'Visible','off');
   
   
   %set up the menubar
   adv_menu('compare simulations');
   
   % The main frame
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',main_frame_color, ...
      'Position',[579 275 190 301], ...
      'Style','frame');
   %Title
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',main_frame_color, ...
      'FontSize',12, ...
      'FontWeight','bold', ...
      'Position',[589 538 175 28], ...
      'String','Compare Simulations', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0 0 0], ...
      'Position',[583 539 183 4], ...
      'Style','frame');
   %Division frame
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[0 0 0], ...
      'Position',[0 273 768 4], ...
      'Style','frame');
   
   %plot frame
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'Position',[600 450 142 74], ...
      'Style','frame');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'HorizontalAlignment','left', ...
      'Position',[610 503 124 17], ...
      'String','Plot Variable (Select Axis)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'Callback','compare_sims(''plot_time_series'')', ...
      'Position',[604 479 134 22], ...
      'String',vinf.comparesims.tvars,...
      'Style','popupmenu', ...
      'Tag','time_plots_popupmenu', ...
      'Value',1);
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'Position',[630 453 56 22], ...
      'String','# of plots', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'CallBack','compare_sims(''number of plots'')',...
      'Position',[703 456 35 22], ...
      'String','1|2', ...
      'Style','popupmenu', ...
      'Tag','num_plots_popupmenu', ...
      'Value',2);
   
   %Note to user if simulation was renamed
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',main_frame_color, ...
      'HorizontalAlignment','left', ...
      'Position',[600 363 160 80], ...
      'String','', ...
      'Style','text',...
      'Visible','off');
   if ~isempty(vinf.comparesims.adj_files)
      str='Note:  Some file names too long.';
      for i=1:length(vinf.comparesims.adj_files)
         str=strvcat(str,[vinf.comparesims.files{vinf.comparesims.adj_files(i)},' --> ',vinf.comparesims.files_used{vinf.comparesims.adj_files(i)}]);
      end
      set(h1,'String',str,'Visible','on');
   end
   
   % The button frame and buttons for load, save, continue, back
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',button_frame_color, ...
      'ListboxTop',0, ...
      'Position',[601 285 154 73], ...
      'Style','frame', ...
      'Tag','Frame3');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf);', ...
      'Position',[681 290 68 29], ...
      'String','Exit');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf);compare_sims(''going_back'');compare_sims_setup;', ...
      'Position',[607 291 68 29], ...
      'String','Back');
   h1 = uicontrol('Parent',h0, ...
      'CallBack','load_in_browser(''compare_sims.html'');',...
      'Position',[681 324 68 29], ...
      'String','Help');
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf);compare_sims(''going_back'');ResultsFig;', ...
      'Position',[607 324 68 29], ...
      'String','Back Two');
   
   %Bar chart plotting
   dx=25;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'Position',[85+dx 233 147 32], ...
      'Style','frame');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'HorizontalAlignment','left', ...
      'Position',[90+dx 241 52 15], ...
      'String','Plot Metric', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',scale_color, ...
      'Callback','compare_sims(''plot bar'')', ...
      'Position',[147+dx 239 78 21], ...
      'String','', ...
      'Style','popupmenu', ...
      'Tag','bar_chart_popupmenu', ...
      'Value',1);
   if strcmp(vinf.units,'us')
      set(h1,'string',vinf.comparesims.metric.name)
   else
      set(h1,'string',vinf.comparesims.metric.name_si)
   end
   
   %Spider chart plotting
   dy=-20;
   dx2=-15;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'Position',[290 38 95 188], ...
      'Style','frame');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'Position',[298 173 75 47], ...
      'String','Spider Chart Comparison Values for:', ...
      'Style','text');
   %popup list
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',scale_color, ...
      'Callback','compare_sims(''select spider var'')', ...
      'Position',[298 150 78 21], ...
      'String','', ...
      'Style','popupmenu', ...
      'Tag','spider_popupmenu', ...
      'Value',1);
   if strcmp(vinf.units,'us')
      set(h1,'string',vinf.comparesims.metric.name)
   else
      set(h1,'string',vinf.comparesims.metric.name_si)
   end
   %inner value
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'HorizontalAlignment','left', ...
      'Position',[296 131 83 16], ...
      'String','Center value (0)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Callback','compare_sims(''update inner'')',...
      'Position',[309 113 48 19], ...
      'String','inner', ...
      'Style','edit', ...
      'Tag','spider_inner');
   %outer value
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'HorizontalAlignment','left', ...
      'Position',[296 96 83 16], ...
      'String','Ring value (1)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Callback','compare_sims(''update outer'')',...
      'Position',[ 309 78 48 19], ...
      'String','outer', ...
      'Style','edit', ...
      'Tag','spider_outer');
   %max displayed
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',plot_col, ...
      'HorizontalAlignment','left', ...
      'Position',[296 61 83 16], ...
      'String','Max Disp (.5 inc)', ...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',[1 1 1], ...
      'Callback','compare_sims(''update max disp'')',...
      'Position',[309 43 48 19], ...
      'String',vinf.comparesims.metric.max_display, ...
      'Style','edit', ...
      'Tag','spider_max_disp');
   
   
   % The axes for the top left portion of the figure
   %Axis 1
   axes1 = axes('Parent',h0, ...
      'ButtonDownFcn','compare_sims(''set_axes_limits'')',...
      'Units','pixels', ...
      'Tag','axes1',...
      'Position',[65 446 486 115]);
   if strcmp(vinf.units,'us'),var='mpha'; else, var='kpha';,end
   tag=get(gca,'tag');
   colors={'r','b','m','g','k','c','r:','b:','m:','y'};
   matname=vinf.comparesims.files_used;
   for j=1:length(matname)		%loop through # of input simulations
      %plot the variable vs. time (found in first variable)
      evalin('base',['plot(',[matname{j},'_t'],',',[matname{j},'_',var],',''', colors{j} ,''');']);
      if j==1,hold on; zoom on;end
   end
   ylabel(strrep(var,'_','\_'))
   set(gca,'tag',tag);
   legend(strvcat(strrep(matname,'_','\_')),-1)
   
   %Axis 2
   axes2 = axes('Parent',h0, ...
      'ButtonDownFcn','compare_sims(''set_axes_limits'')',...
      'Units','pixels', ...
      'Tag','axes2',...
      'Position',[65 306 486 115]);
   var='ess_soc_hist';
   tag=get(gca,'tag');
   matname=vinf.comparesims.files_used;
   for j=1:length(matname)		%loop through # of input simulations
      %plot the variable vs. time (found in first variable)
      try %e.g. not ess vars for conventional vehicle
         evalin('base',['plot(',[matname{j},'_t'],',',[matname{j},'_',var],',''', colors{j} ,''');']);
      catch, evalin('base',['plot([0 eps],[0 0],''', colors{j} ,''');']);
      end
      if j==1,hold on; zoom on;end
   end
   ylabel(strrep(var,'_','\_'))
   set(gca,'tag',tag);
   legend(strvcat(strrep(matname,'_','\_')),-1)
   
   %Bar Chart
   bar_h = axes('Parent',h0, ...
      'ButtonDownFcn','compare_sims(''set_axes_limits'')',...
      'Units','pixels', ...
      'HandleVisibility','off',...
      'Tag','bar_axes',...
      'Position',[ 75 39 204 187]);
   set(bar_h,'units','normalized')
   
   %Spider Chart
   spider_h = axes('Parent',h0, ...
      'ButtonDownFcn','compare_sims(''set_axes_limits'')',...
      'HandleVisibility','off',...
      'Units','pixels', ...
      'Tag','spider_axes',...
      'Position',[421 20 332 235]);
   set(spider_h,'units','normalized')
   
   %set everything normalized and set the figure size and center it
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   set([h; g],'units','normalized')
   
   if isfield(vinf,'gui_size')
      set(gcf,'units','pixels','position',vinf.gui_size);
   else
      screensize=get(0,'screensize'); %this should be in pixels(the default)
      if screensize(3)>=1024
         vinf.gui_size=[238 64 768 576];
         set(gcf,'units','pixels','position',vinf.gui_size);
      else
         set(gcf,'units','normalized')
         set(gcf,'position',[.03 .05 .95 .85]);
         set(gcf,'units','pixels');
      end
   end
   
   %set everything normalized and set the figure size and center it
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   set([h; g],'units','normalized')
   
   %set the figure back on after everything is drawn
   set(gcf,'visible','on');
   
   
   compare_sims('plot spider var');
   compare_sims('plot bar');
   compare_sims('select spider var');
   compare_sims('update inner var');
   compare_sims('update outer var');
   
   axes(findobj('tag','axes2'))
   last_axes=axes2;
   
end; %if nargin==0

if nargin>0
   
   switch action
   case 'number of plots'
      num=get(findobj('tag','num_plots_popupmenu'),'value');
      h1=axes1;axes(h1);legend off;
      h2=axes2;axes(h2);legend off;ylabel('')
      if num==2
         set(h1,'position',[ 0.09 0.77 0.63 0.2 ]);
         set(h2,'position',[ 0.09 0.53 0.63 0.2 ]);
         set([h1 h2],'visible','on');
         %Plot variable on 2nd graph
         axes(h2);compare_sims('plot_time_series');
      elseif num==1
         set(h1,'position',[0.09 0.55 0.63 0.4],'visible','on');
         set([h2],'visible','off');axes(h2);cla;   
      end
      axes(h1);%make the first axes the current axes       
      legend(strvcat(strrep(vinf.comparesims.files_used,'_','\_')),-1)
      
   case 'plot_time_series'
      var=gui_current_str('time_plots_popupmenu');
      
      %the following added because the legend was registering as gca instead of the plot ss 8/5/99
      if strcmp(get(gca,'tag'),'legend')
         disp('case legend')
         axes(last_axes)
      end
      
      tag=get(gca,'tag');
      if ~(gca==axes1 | gca==axes2)
         disp('case ax1 or 2')         
         axes(last_axes)
      end
      colors={'r','b','m','g','k','c','r:','b:','m:','y'};
      matname=vinf.comparesims.files_used;
      for j=1:length(matname)		%loop through # of input simulations
         if j>1,hold on;else hold off,end
         %plot the variable vs. time (found in first variable)
         try %e.g. not ess vars for conventional vehicle
            evalin('base',['plot(',[matname{j},'_t'],',',[matname{j},'_',var],',''', colors{j} ,''');']);
         catch, evalin('base',['plot([0 eps],[0 0],''', colors{j} ,''');']);
         end
      end
      ylabel(strrep(var,'_','\_'))
      set(gca,'tag',tag);
      
      last_axes=gca;
      legend off;
      legend(strvcat(strrep(matname,'_','\_')),-1)
      
   case 'set_axes_limits'
      if ~strcmp(get(gcbf,'SelectionType'),'normal')
         axlimdlg
      end
      
   case 'going_back'
      %Delete multiple simulation results
      for i=1:length(vinf.comparesims.files_used)
         evalin('base',['clear ',vinf.comparesims.files_used{i},'*']);
      end
      
   case 'select spider var'
      %Conversion factor from us units to si units (special case mpg, mpgge)
      us2si=[235.209 235.209 .62137 .62137 .62137 .62137,...
            1 1 1 .3048 .3048 1];
      
      index=get(findobj('tag','spider_popupmenu'),'value');
      if strcmp(vinf.units,'us')
         inner=vinf.comparesims.metric.inner.us(index);
         outer=vinf.comparesims.metric.outer.us(index);
      else
         if index<=2	%mpg and mpgge casees
            inner=1/vinf.comparesims.metric.inner.us(index)*us2si(index);
            outer=1/vinf.comparesims.metric.outer.us(index)*us2si(index);
         else
            inner=vinf.comparesims.metric.inner.us(index)*us2si(index);
            outer=vinf.comparesims.metric.outer.us(index)*us2si(index);
         end
      end
      set(findobj('tag','spider_inner'),'string',num2str(round(inner*1000)/1000));
      set(findobj('tag','spider_outer'),'string',num2str(round(outer*1000)/1000));
      
   case 'update inner'
      %Conversion factor from us units to si units (special case mpg, mpgge)
      us2si=[235.209 235.209 .62137 .62137 .62137 .62137,...
            1 1 1 .3048 .3048 1];
      
      index=get(findobj('tag','spider_popupmenu'),'value');
      inner=str2num(get(findobj('tag','spider_inner'),'string'));
      outer=str2num(get(findobj('tag','spider_outer'),'string'));
      
      matname=vinf.comparesims.files_used;
      for i=1:length(matname)
         if strcmp(vinf.units,'us')
            evalin('base',['tmpvar=',matname{i},'_',vinf.comparesims.metric.name{index},';']);
         else
            evalin('base',['tmpvar=',matname{i},'_',vinf.comparesims.metric.name_si{index},';']);
         end
         tmpvar=evalin('base','tmpvar');
         flag=0;
         if (inner>outer & tmpvar>inner) | (inner<outer & tmpvar<inner)
            errordlg('Variable must fall to one side of range set by inner value.');
            flag=1;
            break
         end
      end
      
      if flag==0
         if strcmp(vinf.units,'us')
            vinf.comparesims.metric.inner.us(index)=inner;
         else
            if index<=2	%mpg and mpgge cases
               vinf.comparesims.metric.inner.us(index)=1/inner*us2si(index);
            else
               vinf.comparesims.metric.inner.us(index)=inner/us2si(index);
            end
         end
         compare_sims('plot spider var');
      else
         compare_sims('select spider var');
      end
      
   case 'update outer'
      %Conversion factor from us units to si units (special case mpg, mpgge)
      us2si=[235.209 235.209 .62137 .62137 .62137 .62137,...
            1 1 1 .3048 .3048 1];
      
      index=get(findobj('tag','spider_popupmenu'),'value');
      outer=str2num(get(findobj('tag','spider_outer'),'string'));
      
      if strcmp(vinf.units,'us')
         vinf.comparesims.metric.outer.us(index)=outer;
      else
         if index<=2	%mpg and mpgge cases
            vinf.comparesims.metric.outer.us(index)=1/outer*us2si(index);
         else
            vinf.comparesims.metric.outer.us(index)=outer/us2si(index);
         end
      end
      
      compare_sims('plot spider var');
      
   case 'update max disp'
      max_disp=str2num(get(findobj('tag','spider_max_disp'),'string'));
      vinf.comparesims.metric.max_display=max_disp;
      compare_sims('plot spider var');
      
   case 'plot spider var'
      prev_ax=gca;
      axes(spider_h);
      evalin('base','plot_spider');
      axes(prev_ax);
         
   case 'plot bar'
      %metric_names={'mpg';'mpgge';'hc_gpm';'co_gpm';'nox_gpm';'pm_gpm';...
      %      'time_0_60';'time_0_85';'time_40_60';'max_accel';...
      %      'feet_5sec';'max_grade'};
      
      index=get(findobj('tag','bar_chart_popupmenu'),'value');
      list=get(findobj('tag','bar_chart_popupmenu'),'string');
      var_to_plot=list{index};
      
      prev_ax=gca;
      axes(bar_h);	%make bar axes the current axes
      legend off; ylabel('')
      evalin('base','variable=[];');
      matname=vinf.comparesims.files_used;
      for i=1:length(matname)
         evalin('base',['variable=[variable,',matname{i},'_',var_to_plot,'];']);
      end
      evalin('base','barh(variable);');
      xlabel(strrep(var_to_plot,'_','\_'));
      set(gca,'YTickLabel',vinf.comparesims.files_used,'ydir','reverse')
      axes(prev_ax);
   otherwise
      
   end; %end of switch      
end; %if nargin>0      

%Revision history
% 9/21/99: vhj, file created
%10/05/99: vhj, if select bar or spider plot, use last axes handle
%10/07/99: vhj, help file created
%10/08/99: vhj, back two-don't eliminate accel etc in 'going back', fixed plotting if NaN, sizing
%10/11/99: vhj/ss, no cells for legends (5.2)
%10/18/99: vhj, plot selected variable on 2nd graph if becoming active/visible from 1->2 graphs
%					 vinf.comparesims.files_used instead of vinf.comparesims.files, added comments if renamed sims
%11/18/99: vhj, plotting initial values fixed if variable doesn't exist
%03/21/00: vhj, fixed default plotting with ess_soc_hist for conventional vehicles
%3/21/00: ss, updated call to results figure: ResultsFigControl was gui_results
% 7/21/00: ss, updated call to advisor_ver
%08/22/00: vhj, fixed resizing of spider and bar charts by redoing 'set everything normalized and set the figure size and center it' after line 300)
%08/22/00: vhj, forced units to be normalized for bar and spider
% 2/15/02: ss replaced ResultsFigControl with ResultsFig
