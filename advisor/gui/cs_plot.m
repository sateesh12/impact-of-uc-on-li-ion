function cs_plot(option,vargin)
% creates the optimization summary plot

global vinf

units_flag=strcmp(vinf.units,'metric');

if nargin<1
   option='initialize';
end

switch option
   
case 'initialize'
   %figure_color=[.4 .7 1];
   %figure_color='cyan';
   figure_color=[.54 1 .66];
   
   screen=get(0,'screensize');
   
   h0 = figure('NumberTitle','off',...
      'position',[(screen(3)-600)/2 (screen(4)-500)/2-25 600 500],...
      'Color',[1 1 1],...
      'name','Control Strategy Optimization Status Window',...
      'tag','cs_optimization_summary',...
      'WindowStyle','modal');
   
   [par_position]=get(h0,'position');
   par_height=par_position(4);
   par_width=par_position(3);
   border=10;
   line_height=18;
   
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2 1 par_width/2 par_height], ...
      'Style','frame',...
      'tag','frame1');
   
   line_num=1;
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2+border par_height-line_num*line_height (par_width/2-border) line_height], ...
      'Fontweight','bold',...
      'String','Design Variables',...
      'Style','text');
   line_num=line_num+1;
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2+border par_height-line_num*line_height 112 line_height], ...
      'String','Variable Name',...
      'Fontweight','bold',...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2+112+4+border par_height-line_num*line_height 50 line_height], ...
      'String','Units',...
      'Fontweight','bold',...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2+112+4+50+4+border par_height-line_num*line_height 50 line_height], ...
      'String','Value',...
      'Fontweight','bold',...
      'Style','text');
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',figure_color,...
      'Position',[par_width/2+112+4+50+4+50+4+border par_height-line_num*line_height 50 line_height], ...
      'String','History',...
      'Fontweight','bold',...
      'Style','text');
   
   for i=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(i)
         line_num=line_num+1;
         line_num=line_num+1;
         h1 = uicontrol('Parent',h0, ...
            'Position',[par_width/2+border par_height-line_num*line_height 112 line_height], ...
            'BackgroundColor',figure_color,...
            'horizontalAlign','left',...
            'String',vinf.control_strategy.dv.name{i},...
            'Style','text');
         h1 = uicontrol('Parent',h0, ...
            'Position',[par_width/2+112+4+border par_height-line_num*line_height 50 line_height], ...
            'BackgroundColor',figure_color,...
            'String',vinf.control_strategy.dv.units{i},...
            'Style','text');
         h1 = uicontrol('Parent',h0, ...
            'Position',[par_width/2+112+4+50+4+border par_height-line_num*line_height 50 line_height], ...
            'BackgroundColor',figure_color,...
            'String','0',...
            'Style','text', ...
            'enable','on', ...
            'ForegroundColor',[0 0 0], ...
            'Tag',['EditBox',num2str(i)]);
         h1 = uicontrol('Parent',h0, ...
            'Callback',['cs_plot(''history'',',num2str(i),')'],...
            'Position',[par_width/2+112+4+50+4+50+4+border par_height-line_num*line_height 50 line_height], ...
            'String','Plot',...
            'Style','PushButton', ...
            'enable','off', ...
            'visible','off', ...
            'Tag',['PushButton',num2str(i)]);
      end
   end
   line_num=line_num+1;
   line_num=line_num+1;
   h1 = uicontrol('Parent',h0, ...
      'Callback','close(gcbf)',...
      'Position',[par_width/2+112+4+50+4+50+4+border par_height-line_num*line_height 50 line_height], ...
      'String','Continue',...
      'Style','PushButton', ...
      'enable','off', ...
      'visible','off', ...
      'Tag','continue_pushbutton');
   
   
   h1=subplot(3,2,1);
   ylabel('Constraints')
   set(h1,'tag','constraints_fig')
   
   h2=subplot(3,2,3);
   ylabel('Partial Objectives')
   set(h2,'tag','partial_obj_fig')
   
   h3=subplot(3,2,5);
   ylabel('Objective')
   xlabel('Design Iteration')
   set(h3,'tag','comp_obj_fig')
   
case 'update'
   for i=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(i)
         if abs(evalin('base',vinf.control_strategy.dv.name{i}))>100 
            form='%7.0f'; 
         else 
            form='%7.3f'; 
         end;
         str=num2str(evalin('base',vinf.control_strategy.dv.name{i}),form);
         if ~strcmp(get(findobj('tag',['EditBox',num2str(i)]),'string'),str)
            fcolor='red';
         else
            fcolor='black';
         end
         set(findobj('tag',['EditBox',num2str(i)]),'string',str,'ForegroundColor',fcolor)
      end
   end
   
   obj_log=evalin('base','obj_log');
   results_log=evalin('base','results_log');
   
   linetype={'o-','s-','^-','v-','*-'};
   linecolor={'g','c','m','k','y'};
   
   subplot(3,2,1)
   for i=1:length(vinf.control_strategy.obj.active)
      if ~vinf.control_strategy.obj.active(i)&vinf.control_strategy.con.value(i)>0
         plot([1:size(results_log,1)],results_log(:,i),[linecolor{rem(i-1,length(linecolor))+1},linetype{rem(i-1,length(linetype))+1}]);
         hold on
      end
   end
   for i=1:length(vinf.control_strategy.obj.active)
      if ~vinf.control_strategy.obj.active(i)&vinf.control_strategy.con.value(i)>0
         plot([1:size(results_log,1)],ones(size(results_log,1))*vinf.control_strategy.con.value(i),'b--')
      end
   end
   str=[];
   for i=1:length(vinf.control_strategy.obj.active)
      if ~vinf.control_strategy.obj.active(i)&vinf.control_strategy.con.value(i)>0
         if i==5
            str=[str,'''',strrep(vinf.control_strategy.obj.name{i},'_',' '),''','];
         else
            str=[str,'''',strrep(vinf.control_strategy.obj.name{i},'_',' '),' emis'','];
         end
      end
   end
   if ~isempty(str)
      eval(['legend(',str,'0)'])
   end
   ylabel('Constraints')
   hold off
   
   subplot(3,2,3)
   for i=1:length(vinf.control_strategy.obj.active)
      if vinf.control_strategy.obj.active(i)
         if i==5
            plot([1:size(results_log,1)],results_log(1,i)./results_log(:,i),[linecolor{rem(i-1,length(linecolor))+1},linetype{rem(i-1,length(linetype))+1}]);
         else
            plot([1:size(results_log,1)],results_log(:,i)./results_log(1,i),[linecolor{rem(i-1,length(linecolor))+1},linetype{rem(i-1,length(linetype))+1}]);
         end
         hold on
      end
   end
   plot([1:size(results_log,1)],ones(size(results_log,1)),'b--')
   str=[];
   for i=1:length(vinf.control_strategy.obj.active)
      if vinf.control_strategy.obj.active(i)
         if i==5
            str=[str,'''',strrep(vinf.control_strategy.obj.name{i},'_',' '),''','];
         else
            str=[str,'''',strrep(vinf.control_strategy.obj.name{i},'_',' '),' emis'','];
         end
      end
   end
   if ~isempty(str)
      eval(['legend(',str,'0)'])
   end
   ylabel('Partial Objectives')
   hold off
   
   subplot(3,2,5)
   plot([1:length(obj_log)],obj_log,'rx-')
   hold on
   plot([1:length(obj_log)],ones(length(obj_log)),'b--')
   ylabel('Objective Function')
   xlabel('Design Iteration')
   hold off
   
   drawnow
   
case 'end_opt'
   for i=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(i)
         set(findobj('tag',['PushButton',num2str(i)]),'visible','on')
         set(findobj('tag',['PushButton',num2str(i)]),'enable','on')
      end
   end
   set(findobj('tag','continue_pushbutton'),'enable','on')
   set(findobj('tag','continue_pushbutton'),'visible','on')
   
case 'history'
   index=vargin(1);
   h=figure;
   set(h,'NumberTitle','off','Name','Design Variable History')
   dv_log=evalin('base','dv_log');
   count=0;
   for i=1:length(vinf.control_strategy.dv.active)
      if vinf.control_strategy.dv.active(i)
         count=count+1;
         if i==index
            if vinf.control_strategy.matlab
               if (index==3&vinf.control_strategy.dv.active(4))|(index==4&vinf.control_strategy.dv.active(3))
                  if 1
                     xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                     if index==3
                        ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i+1}]);
                        zdata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                        con_flag=nnz(evalin('base',['con1_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]));
                     else
                        ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i-1}]);
                        zdata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                        zdata=zdata';
                        con_flag=nnz(evalin('base',['con1_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]));
                     end
                     if con_flag
                         subplot(2,2,1)
                     else
                         subplot(2,1,1)
                     end
                     surf(xdata,ydata,zdata')
                     xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                     if index==3
                        ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                     else
                        ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                     end
                     zlabel('Objective')
                     title('Coarse Parametric Sweep')
                     
                     if con_flag
                        %plot constraint info   
                        subplot(2,2,2)
                        xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                        if index==3
                           ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i+1}]);
                           zdata=evalin('base',['con1_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                        else
                           ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i-1}]);
                           zdata=evalin('base',['con1_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                           zdata=zdata';
                        end
                        surf(xdata,ydata,zdata')
                        xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                        if index==3
                           ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                        else
                           ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                        end
                        zlabel('Constraint Violation')
                        title('Coarse Parametric Sweep')
                     end
                     
                     xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                     if index==3
                        ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i+1}]);
                        zdata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                        con_flag=nnz(evalin('base',['con2_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]));
                     else
                        ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i-1}]);
                        zdata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                        zdata=zdata';
                        con_flag=nnz(evalin('base',['con2_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]));
                     end
                     
                     if con_flag
                        subplot(2,2,3)
                     else
                        subplot(2,1,2)
                     end
                     
                     surf(xdata,ydata,zdata')
                     xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                     if index==3
                        ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                     else
                        ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                     end
                     zlabel('Objective')
                     title('Fine Parametric Sweep')
                     
                     if con_flag
                        %plot constraint info
                        subplot(2,2,4)
                        xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                        if index==3
                           ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i+1}]);
                           zdata=evalin('base',['con2_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                        else
                           ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i-1}]);
                           zdata=evalin('base',['con2_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                           zdata=zdata';
                        end
                        
                        surf(xdata,ydata,zdata')
                        xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                        if index==3
                           ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                        else
                           ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                        end
                        zlabel('Constraint Violation')
                        title('Fine Parametric Sweep')
                     end
                     
                  else
                     xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                     if index==3
                        ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i+1}]);
                        zdata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                     else
                        ydata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i-1}]);
                        zdata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                        zdata=zdata';
                     end
                     %subplot(2,1,1)
                     h=surf(xdata,ydata,zdata');
                     set(h,'Marker','x','markeredgecolor','red')
                     %xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                     %if index==3
                     %   ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                     %else
                     %   ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                     %end
                     %zlabel('Objective')
                     
                     %title('Coarse Parametric Sweep')
                     hold on
                     
                     xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                     if index==3
                        ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i+1}]);
                        zdata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i},'_',vinf.control_strategy.dv.name{i+1}]);
                     else
                        ydata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i-1}]);
                        zdata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i-1},'_',vinf.control_strategy.dv.name{i}]);
                        zdata=zdata';
                     end
                     %subplot(2,1,2)
                     h=surf(xdata,ydata,zdata');
                     set(h,'marker','o','markeredgecolor','blue')
                     xlabel([strrep(vinf.control_strategy.dv.name{index},'_','\_'),' ',vinf.control_strategy.dv.units{index}])
                     if index==3
                        ylabel([strrep(vinf.control_strategy.dv.name{index+1},'_','\_'),' ',vinf.control_strategy.dv.units{index+1}])
                     else
                        ylabel([strrep(vinf.control_strategy.dv.name{index-1},'_','\_'),' ',vinf.control_strategy.dv.units{index-1}])
                     end
                     zlabel('Objective')
                     %title('Fine Parametric Sweep')
                     
                     legend('Coarse Sweep','Fine Sweep',0)
                  end
                  
               else
                  if 0
                     xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i}]);
                     subplot(2,1,1)
                     plot(xdata,ydata)
                     ylabel('Objective')
                     xlabel([strrep(vinf.control_strategy.dv.name{i},'_','\_'),' ',vinf.control_strategy.dv.units{i},''])
                     title('Coarse Parametric Sweep')
                     
                     xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i}]);
                     subplot(2,1,2)
                     plot(xdata,ydata)
                     ylabel('Objective')
                     xlabel([strrep(vinf.control_strategy.dv.name{i},'_','\_'),' ',vinf.control_strategy.dv.units{i},''])
                     title('Fine Parametric Sweep')
                  else
                     subplot(2,1,1)
                     xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['obj1_',vinf.control_strategy.dv.name{i}]);
                     plot(xdata,ydata,'rx-')
                     hold on
                     xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['obj2_',vinf.control_strategy.dv.name{i}]);
                     plot(xdata,ydata,'bo-')
                     ylabel('Objective')
                     xlabel([strrep(vinf.control_strategy.dv.name{i},'_','\_'),' ',vinf.control_strategy.dv.units{i},''])
                     legend('Coarse Sweep','Fine Sweep')
                     
                     subplot(2,1,2)
                     xdata=evalin('base',['dv1_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['con1_',vinf.control_strategy.dv.name{i}]);
                     plot(xdata,ydata,'rx-')
                     hold on
                     xdata=evalin('base',['dv2_',vinf.control_strategy.dv.name{i}]);
                     ydata=evalin('base',['con2_',vinf.control_strategy.dv.name{i}]);
                     plot(xdata,ydata,'bo-')
                     ylabel('Constraint Violation')
                     xlabel([strrep(vinf.control_strategy.dv.name{i},'_','\_'),' ',vinf.control_strategy.dv.units{i},''])
                     legend('Coarse Sweep','Fine Sweep')
                  end
               end
            else
               plot([1:(size(dv_log,1))],dv_log(:,count))
               xlabel('Design Iteration')
               ylabel([strrep(vinf.control_strategy.dv.name{i},'_','\_'),' ',vinf.control_strategy.dv.units{i},''])
               title('Design Variable History')
            end
         end
      end
   end
   
end

return

% revision history
% 8/21/00:tm added statements to case initialize to add a continue button
% 8/21/00:tm added statements to the end_opt case to make continue button visible and enabled

