function parametric_plot(option)

%Plotting function for Parametric Analysis

global vinf;

name = gui_current_str('parametric_plot_menu');
n=vinf.parametric.number_variables;	%number of variables

metric_us_conversions={
    'Litersp100km'            'MilesPG'                   []
    'LpkmGE'                     'MPGGE'                    []
    'NOx_gpkm'                'NOx'                          [0.6214]
    'CO_gpkm'                  'CO'                            [0.6214]
    'HC_gpkm'                  'HC'                             [0.6214]
    'PM_gpkm'                  'PM'                             [0.6214]
    'Accel_0_97'                'Accel_0_60'               [1.0]
    'Accel_64_97'              'Accel_40_60'             [1.0]
    'Accel_0_137'              'Accel_0_85'               [1.0]
    'Meters_5sec'            'Feet_5sec'                 [0.3048]
    'Max_accel_m_s2'    'Max_accel_ft_s2'      [0.3048]
    'Grade_89kph'           'Grade_55mph'          [1.0]           };

metric_name_index = strmatch( name , metric_us_conversions(:,1) , 'exact' );

name_is_metric=~isempty(metric_name_index);

if name_is_metric
    name=metric_us_conversions{metric_name_index,2}; %use the us name for checking if it is in the workspace or not
end
   
if nargin==0
   if evalin('base',['exist(''', name ,''')'])
      var=evalin('base',name);	%Variable to be plotted
      if name_is_metric %convert us units to metric
         if strcmp(name,'MilesPG')|strcmp(name,'MPGGE')
             %convert from mpg to liters/100km
             var = 1 ./ var * 3.785 * 0.6214*100;
         else %multiply by units conversion quantity
             var=var * metric_us_conversions{ metric_name_index , 3 };
         end
         name=metric_us_conversions{metric_name_index , 1 };  %put the name back to the metric name for labeling
     end
              
      set(gca,'xlimmode','auto', 'ylimmode','auto');
      
      if n==1 %Single Variable Parametric Study
         step=(vinf.parametric.high(1)-vinf.parametric.low(1))/(vinf.parametric.number(1)-1);
         x=vinf.parametric.low(1):step:vinf.parametric.high(1);
         
         %Plot and Label
         xi=vinf.parametric.low(1):step/10:vinf.parametric.high(1);
         %interpolate with 10x number of points
         vi=interp1(x,var,xi,'linear'); %linear interpolation for 1 parameter study
         
         plot(xi,vi);	
         shading flat;
         xlabel(strrep(vinf.parametric.var(1),'_','\_'));
         ylabel(strrep(name,'_','\_'));  
         if (strcmp(name,'NOx')| strcmp(name,'CO') | strcmp(name,'HC')| strcmp(name,'PM'))
            if strcmp(vinf.units,'metric')
               str=' (grams per km)';
            else
               str=' (grams per mile)';
            end
            title([name str]);
         elseif (strcmp(name,'Accel_0_60')| strcmp(name,'Accel_40_60')|strcmp(name,'Accel_0_85'))
            title([strrep(name,'_','\_'),' (seconds)']);
         else
            title(strrep(name,'_','\_'));
         end
         
      elseif n==2 %Two Variable Parametric Study
         stepx=(vinf.parametric.high(1)-vinf.parametric.low(1))/(vinf.parametric.number(1)-1);
         x=vinf.parametric.low(1):stepx:vinf.parametric.high(1);
         stepy=(vinf.parametric.high(2)-vinf.parametric.low(2))/(vinf.parametric.number(2)-1);
         y=vinf.parametric.low(2):stepy:vinf.parametric.high(2);
         
         [Y,X]=meshgrid(y,x);	
         [yi,xi]=meshgrid(vinf.parametric.low(2):stepy/10:vinf.parametric.high(2),vinf.parametric.low(1):stepx/10:vinf.parametric.high(1));
%         if (vinf.parametric.number(1)<3 | vinf.parametric.number(2)<3)	
            vi=interp2(Y,X,var,yi,xi,'linear');	%interpolate with 10x number of points
%         else
%            vi=interp2(Y,X,var,yi,xi,'cubic');	%cubic interpolation of data
%         end
         
         surfc(yi,xi,vi);
         shading flat;
         colorbar;
         xlabel(strrep(vinf.parametric.var(2),'_','\_'));
         ylabel(strrep(vinf.parametric.var(1),'_','\_'));
         if (strcmp(name,'NOx')| strcmp(name,'CO') | strcmp(name,'HC')| strcmp(name,'PM'))
            if strcmp(vinf.units,'metric')
               str=' (grams per km)';
            else
               str=' (grams per mile)';
            end
            title([name str]);
         elseif (strcmp(name,'Accel_0_60')| strcmp(name,'Accel_40_60'))
            title([strrep(name,'_','\_'),' (seconds)']);
         else
            title(strrep(name,'_','\_'));
         end
         
      elseif n==3 %Three Variable Parametric Study
         stepx=(vinf.parametric.high(1)-vinf.parametric.low(1))/(vinf.parametric.number(1)-1);
         x=vinf.parametric.low(1):stepx:vinf.parametric.high(1);
         stepy=(vinf.parametric.high(2)-vinf.parametric.low(2))/(vinf.parametric.number(2)-1);
         y=vinf.parametric.low(2):stepy:vinf.parametric.high(2);
         stepz=(vinf.parametric.high(3)-vinf.parametric.low(3))/(vinf.parametric.number(3)-1);
         z=vinf.parametric.low(3):stepz:vinf.parametric.high(3);
         
         if var==0 %For zero everywhere case (e.g. no emissions data)
            delete(get(findobj('tag','parametric_axes'),'children'));%clear  the axes
            set(gca,'xlimmode','auto', 'ylimmode','auto','zlimmode','auto');
            text(.5,.5,.5,'Zero Everywhere');
            h=findobj('tag','Colorbar');
            delete(h);
         else
            [Y,X,Z]=meshgrid(y,x,z);	%interpolate results with 10 more points per step
            [yi,xi,zi]=meshgrid(vinf.parametric.low(2):stepy/10:vinf.parametric.high(2),vinf.parametric.low(1):stepx/10:vinf.parametric.high(1),vinf.parametric.low(3):stepz/10:vinf.parametric.high(3));
%            if (vinf.parametric.number(1)<3 | vinf.parametric.number(2)<3 | vinf.parametric.number(3)<3)	
               vi=interp3(Y,X,Z,var,yi,xi,zi,'linear');
%            else
%               vi=interp3(Y,X,Z,var,yi,xi,zi,'cubic');
%            end
            
            slice(yi,xi,zi,vi,vinf.parametric.high(2),vinf.parametric.high(1),vinf.parametric.low(3));	%plot the slices running through high values
            shading flat; %drop black lines on plot
            colorbar; %add colorbar
         end
         
         %Labels and Title
         xlabel(strrep(vinf.parametric.var(2),'_','\_'));
         ylabel(strrep(vinf.parametric.var(1),'_','\_'));
         zlabel(strrep(vinf.parametric.var(3),'_','\_'));
         if (strcmp(name,'NOx')| strcmp(name,'CO') | strcmp(name,'HC')| strcmp(name,'PM'))
            if strcmp(vinf.units,'metric')
               str=' (grams per km)';
            else
               str=' (grams per mile)';
            end
            title([name str]);
         elseif (strcmp(name,'Accel_0_60') | strcmp(name,'Accel_40_60'))
            title([strrep(name,'_','\_'),' (seconds)']);
         else
            title(strrep(name,'_','\_'));
         end
         
      end 
      
   else %Variable not avaiable
      delete(get(findobj('tag','parametric_axes'),'children'));%clear  the axes
      set(gca,'xlimmode','auto', 'ylimmode','auto','zlimmode','auto');
      text(.5,.5,.5,'Variable Not Available');
      title(strrep(name,'_','\_'));
      xlabel('');ylabel('');zlabel('');
      h=findobj('tag','Colorbar');
      delete(h);
      end
end %narg=0 

if nargin>0
   switch option
   case 'slice'	%Plotting different slices (user controlled)
      if evalin('base',['exist(''', name ,''')'])
         var=evalin('base',name);	%Variable to be plotted
         set(gca,'xlimmode','auto', 'ylimmode','auto');
         
         stepx=(vinf.parametric.high(1)-vinf.parametric.low(1))/(vinf.parametric.number(1)-1);
         x=vinf.parametric.low(1):stepx:vinf.parametric.high(1);
         stepy=(vinf.parametric.high(2)-vinf.parametric.low(2))/(vinf.parametric.number(2)-1);
         y=vinf.parametric.low(2):stepy:vinf.parametric.high(2);
         stepz=(vinf.parametric.high(3)-vinf.parametric.low(3))/(vinf.parametric.number(3)-1);
         z=vinf.parametric.low(3):stepz:vinf.parametric.high(3);
         
         if var==0 %For zero everywhere case (e.g. no emissions data)
            delete(get(findobj('tag','parametric_axes'),'children'));%clear  the axes
            set(gca,'xlimmode','auto', 'ylimmode','auto','zlimmode','auto');
            text(.5,.5,.5,'Zero Everywhere');
            h=findobj('tag','Colorbar');
            delete(h);
         else         
            [Y,X,Z]=meshgrid(y,x,z);	%interpolate results with 10 more points per step
            [yi,xi,zi]=meshgrid(vinf.parametric.low(2):stepy/10:vinf.parametric.high(2),vinf.parametric.low(1):stepx/10:vinf.parametric.high(1),vinf.parametric.low(3):stepz/10:vinf.parametric.high(3));
            if (vinf.parametric.number(1)<3 | vinf.parametric.number(2)<3 | vinf.parametric.number(3)<3)	
               vi=interp3(Y,X,Z,var,yi,xi,zi,'linear');
            else
               vi=interp3(Y,X,Z,var,yi,xi,zi,'cubic');
            end
            
            xvalue=get(findobj('tag','X_value'),'value');  %get slider bar values
            yvalue=get(findobj('tag','Y_value'),'value');
            zvalue=get(findobj('tag','Z_value'),'value');
            
            xvalue=xvalue*(vinf.parametric.high(2)-vinf.parametric.low(2))+vinf.parametric.low(2);
            yvalue=yvalue*(vinf.parametric.high(1)-vinf.parametric.low(1))+vinf.parametric.low(1);
            zvalue=zvalue*(vinf.parametric.high(3)-vinf.parametric.low(3))+vinf.parametric.low(3);
            
            slice(yi,xi,zi,vi,xvalue,yvalue,zvalue);	%plot the slices
            shading flat;
            colorbar;
         end
         
         xlabel(strrep(vinf.parametric.var(2),'_','\_'));
         ylabel(strrep(vinf.parametric.var(1),'_','\_'));
         zlabel(strrep(vinf.parametric.var(3),'_','\_'));
         if (strcmp(name,'NOx')| strcmp(name,'CO') | strcmp(name,'HC')| strcmp(name,'PM'))
            if strcmp(vinf.units,'metric')
               str=' (grams per km)';
            else
               str=' (grams per mile)';
            end
            title([name str]);
         elseif (strcmp(name,'Accel_0_60')| strcmp(name,'Accel_40_60'))
            title([strrep(name,'_','\_'),' (seconds)']);
         else
            title(strrep(name,'_','\_'));
         end
         
      else %Variable not available
         delete(get(findobj('tag','parametric_axes'),'children'));%clear  the axes
         set(gca,'xlimmode','auto', 'ylimmode','auto','zlimmode','auto');
         text(.5,.5,.5,'Not Available');
         title(strrep(name,'_','\_'));
         h=findobj('tag','Colorbar');
         delete(h);
      end %if exist()
   end %switch,case
end %if nargin>0


% Revision history
% 8/98: vh file created
% 5/05/99: vhj added PM
% 9/20/99: vhj metric units (g/km)
% 8/28/03: ss added units conversion at top of file
