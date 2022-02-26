function plot_spider()
%Function to generate a spider plot

global vinf spider_h

set(0,'showhidden','on')	%needed to rename polar displays with names
hold off; zoom off;
%sets the maximum of the spider plot
handle=polar(0,vinf.comparesims.metric.max_display,''); 
hold on
color_sel={'r*:','bd:','ms:','gx:','ko:','c+:','rp:','bx:','m*:','yv:'};

%First, check validity of inner and outer points
for i=1:length(vinf.comparesims.files_used)
   evalin('base','vars=[];');
   for j=1:length(vinf.comparesims.metric.name)
      %Assign variable to tmpvar
      evalin('base',['tmpvar=',vinf.comparesims.files_used{i},'_',vinf.comparesims.metric.name{j},';']);
      if evalin('base','tmpvar')==0
         assignin('base','tmpvar',NaN);
      end
      tmpvar=evalin('base','tmpvar');
      inner=vinf.comparesims.metric.inner.us(j);
      outer=vinf.comparesims.metric.outer.us(j);
      if (inner>outer & tmpvar>inner) | (inner<outer & tmpvar<inner)
         vinf.comparesims.metric.inner.us(j)=tmpvar;
         inner=tmpvar;
      end
   end
end

evalin('base','clear h');
for i=1:length(vinf.comparesims.files_used)
   evalin('base','vars=[];');
   for j=1:length(vinf.comparesims.metric.name)
      %Assign variable to tmpvar
      evalin('base',['tmpvar=',vinf.comparesims.files_used{i},'_',vinf.comparesims.metric.name{j},';']);
      if evalin('base','tmpvar')==0
         assignin('base','tmpvar',NaN);
      end
      tmpvar=evalin('base','tmpvar');
      inner=vinf.comparesims.metric.inner.us(j);
      outer=vinf.comparesims.metric.outer.us(j);
      
      %Normalize variables based on center and ring values: var_norm=(Var-inner)/(outer-inner)
      evalin('base',['vars(',num2str(j),')=(tmpvar-',num2str(inner),')/(',num2str(outer),'-',num2str(inner),');']);
   end
   evalin('base',['h(',num2str(i),')=polar([0:30:330]*2*pi/360,vars,''',color_sel{i},''');']);
end
evalin('base','legh=legend(h,strvcat(strrep(vinf.comparesims.files_used,''_'',''\_'')),-1);');
%Set display attributes about the legend, plot
%evalin('base','set(findobj(legh,''type'',''text''),''FontSize'',8)');
%posn=evalin('base','get(legh,''Position'')');
%posn(3)=.8*posn(3);
%posn(1)=1.03*posn(1);
%posn(2)=.6*posn(2);
%evalin('base',['set(legh,''Position'',[',num2str(posn),'])']);
%set(findobj(spider_h,'type','text'),'FontSize',8)
%Draw solid line at value of 1
th = 0:pi/50:2*pi;
hhh = plot(cos(th),sin(th),'k-','linewidth',1.5);

%Names of plotted variables
if strcmp(vinf.units,'us')
   %names={'mpg','mpgge','HC','CO','NOx','PM','t0-60','t0-85','t40-60','MaxAccel','Dist5sec','Grade'};
   % 1/17/00:tm updated labels
   if isfield(vinf, 'accel_test')&strcmp(vinf.acceleration.run,'on')
      names={'mpg','mpgge','HC','CO','NOx','PM',...
            ['t',num2str(round(vinf.accel_test.param.spds1(1))),'-',num2str(round(vinf.accel_test.param.spds1(2)))],...
            ['t',num2str(round(vinf.accel_test.param.spds3(1))),'-',num2str(round(vinf.accel_test.param.spds3(2)))],...
            ['t',num2str(round(vinf.accel_test.param.spds2(1))),'-',num2str(round(vinf.accel_test.param.spds2(2)))],...
            'MaxAccel','Dist5sec','Grade'};
   else
      names={'mpg','mpgge','HC','CO','NOx','PM',...
            ['t',num2str(0),'-',num2str(60)],...
            ['t',num2str(0),'-',num2str(85)],...
            ['t',num2str(40),'-',num2str(60)],...
            'MaxAccel','Dist5sec','Grade'};
   end
   
else
   %names={'lpkm','lpkmge','HC','CO','NOx','PM','t0-97','t0-137','t64-97','MaxAccel','Dist5sec','Grade'};
   % 1/17/00:tm updated labels
   if isfield(vinf, 'accel_test')&strcmp(vinf.acceleration.run,'on')
      names={'lpkm','lpkmge','HC','CO','NOx','PM',...
            ['t',num2str(round(vinf.accel_test.param.spds1(1)*units('mph2kmph'))),'-',num2str(round(vinf.accel_test.param.spds1(2)*units('mph2kmph')))],...
            ['t',num2str(round(vinf.accel_test.param.spds3(1)*units('mph2kmph'))),'-',num2str(round(vinf.accel_test.param.spds3(2)*units('mph2kmph')))],...
            ['t',num2str(round(vinf.accel_test.param.spds2(1)*units('mph2kmph'))),'-',num2str(round(vinf.accel_test.param.spds2(2)*units('mph2kmph')))],...
            'MaxAccel','Dist5sec','Grade'};
   else
      names={'lpkm','lpkmge','HC','CO','NOx','PM',...
            ['t',num2str(round(0*units('mph2kmph'))),'-',num2str(round(60*units('mph2kmph')))],...
            ['t',num2str(round(0*units('mph2kmph'))),'-',num2str(round(85*units('mph2kmph')))],...
            ['t',num2str(round(40*units('mph2kmph'))),'-',num2str(round(60*units('mph2kmph')))],...
            'MaxAccel','Dist5sec','Grade'};
   end
end
for i=1:12
   h=findobj(spider_h,'String',num2str((i-1)*30));
   set(h,'String',names{i},'FontSize',8);
   %Alignment of name
   if i>=5 & i<=9
      set(h,'HorizontalAlignment','right');
   elseif i==4 | i==10
      set(h,'HorizontalAlignment','center');
   else
      set(h,'HorizontalAlignment','left');
   end
end
%set(0,'showhidden','off')	%needed to rename polar displays with names


%Revision history
% 9/27/99: vhj file created
%10/11/99: vhj/ss, no cells for legends (5.2)
%10/18/99: vhj, vinf.comparesims.files_used instead of vinf.comparesims.files
% 1/17/01:tm updated acceleration labels on spider plot
% 1/23/01:tm added conditional statements to label assignments for case when no accel results to display
