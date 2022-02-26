function fuel_per_cycle(option)
%function fuel_used_grams = fuel_per_cycle(time)
%
%This function plots the fuel use over a cycle with respect to spd and trq.  It groups speed and trq operating points
%into bins and adds up the fuel used in each bin.  A plot of the fuel use vs. trq and spd displayed.

%
global fuel_per_cycle_var

if nargin==0
   open fuel_per_cycle.fig
   
   cycle_name = evalin('base','vinf.cycle.name');
   set(gcf,'Name',['Fuel Converter Operation Over ', cycle_name])
   
   fuel_per_cycle_var.time=evalin('base','t');
   fuel_per_cycle_var.spd_rpm=evalin('base','fc_spd_est').*30./pi;
   fuel_per_cycle_var.trq_Nm=evalin('base','fc_brake_trq');
   fuel_per_cycle_var.fuel=evalin('base','fc_fuel_rate');
   
   %set defaults
   fuel_per_cycle_var.spd_bin_min=0;
   fuel_per_cycle_var.trq_bin_min=0;
   fuel_per_cycle_var.spd_bin_size=500;
   fuel_per_cycle_var.trq_bin_size=5;
   
   set(findobj('tag','spd min'),'string',num2str(fuel_per_cycle_var.spd_bin_min))
   set(findobj('tag','trq min'),'string',num2str(fuel_per_cycle_var.trq_bin_min))
   set(findobj('tag','spd bin size'),'string',num2str(fuel_per_cycle_var.spd_bin_size))
   set(findobj('tag','trq bin size'),'string',num2str(fuel_per_cycle_var.trq_bin_size))
   
   %type of plots
   fuel_per_cycle_var.plot_2d=1;
   fuel_per_cycle_var.plot_3d=0;
   fuel_per_cycle_var.plot_contour=0;
   
   set(findobj('tag','2d radio'),'value',fuel_per_cycle_var.plot_2d)
   set(findobj('tag','3d radio'),'value',fuel_per_cycle_var.plot_3d)
   set(findobj('tag','contour radiobutton'),'value',fuel_per_cycle_var.plot_contour)
   
   %plots on or off (0 or 1)
   fuel_per_cycle_var.chkfc_plot=1;
   fuel_per_cycle_var.fuel_bin_plot=0;
   fuel_per_cycle_var.op_pts_bin_plot=0;
   
   set(findobj('tag','chkfc checkbox'),'value',fuel_per_cycle_var.chkfc_plot)
   set(findobj('tag','fuel_bin checkbox'),'value',fuel_per_cycle_var.fuel_bin_plot)
   set(findobj('tag','op_pts_bin checkbox'),'value',fuel_per_cycle_var.op_pts_bin_plot)
  
   %plot defaults
   fuel_per_cycle('plot')
   
   
elseif nargin>0
   switch option
   case '2d radio'
      set(findobj('tag','3d radio'),'value',0)
      set(findobj('tag','contour radiobutton'),'value',0)
      fuel_per_cycle_var.plot_2d=1;
      fuel_per_cycle_var.plot_3d=0;
      fuel_per_cycle_var.plot_contour=0;
      fuel_per_cycle('plot')
      
   case '3d radio'
      set(findobj('tag','2d radio'),'value',0)
      set(findobj('tag','contour radiobutton'),'value',0)
      fuel_per_cycle_var.plot_2d=0;
      fuel_per_cycle_var.plot_3d=1;
      fuel_per_cycle_var.plot_contour=0;
      fuel_per_cycle('plot')
      
   case 'contour radio'
      set(findobj('tag','2d radio'),'value',0)
      set(findobj('tag','3d radio'),'value',0)
      fuel_per_cycle_var.plot_2d=0;
      fuel_per_cycle_var.plot_3d=0;
      fuel_per_cycle_var.plot_contour=1;
      fuel_per_cycle('plot')
    
   case 'spd_bin_min'
      fuel_per_cycle_var.spd_bin_min=str2num(get(gcbo,'string'));
      fuel_per_cycle('plot')
      
   case 'trq_bin_min'
      fuel_per_cycle_var.trq_bin_min=str2num(get(gcbo,'string'));
      fuel_per_cycle('plot')
      
   case 'spd_bin_size'
      fuel_per_cycle_var.spd_bin_size=str2num(get(gcbo,'string'));
      fuel_per_cycle('plot')
      
   case 'trq_bin_size'
      fuel_per_cycle_var.trq_bin_size=str2num(get(gcbo,'string'));
      fuel_per_cycle('plot')
      
   case 'chkfc checkbox'
      fuel_per_cycle_var.chkfc_plot=get(gcbo,'value');
      fuel_per_cycle('plot')
      
   case 'fuel_bin checkbox'
      fuel_per_cycle_var.fuel_bin_plot=get(gcbo,'value');
      fuel_per_cycle('plot')
      
   case 'op_pts_bin checkbox'
      fuel_per_cycle_var.op_pts_bin_plot=get(gcbo,'value');
      fuel_per_cycle('plot')

   case 'plot'
      spd  = fuel_per_cycle_var.spd_rpm;        % rpm
      trq  = fuel_per_cycle_var.trq_Nm ;        % Nm
      fuel = fuel_per_cycle_var.fuel;   			% grams/sec
		time = fuel_per_cycle_var.time;				% sec
      
      spd_bin_min=fuel_per_cycle_var.spd_bin_min;
      trq_bin_min=fuel_per_cycle_var.trq_bin_min;
      spd_bin_size=fuel_per_cycle_var.spd_bin_size;
      trq_bin_size=fuel_per_cycle_var.trq_bin_size;
      
      %figure out time step (sec)
      if length(time) > 1
         time_step = median( diff( time ) );
      else
         time_step = time;
      end
      
      %spd and trq bin maxes based on data
      spd_bin_max = max( spd ) + spd_bin_size - rem( max( spd ) , spd_bin_size );
      trq_bin_max = max( trq ) + trq_bin_size - rem( max( trq ) , trq_bin_size );
      
      %bin boundaries
      trq_bin_bounds = [ trq_bin_min:trq_bin_size:trq_bin_max ] ;
      spd_bin_bounds = [ spd_bin_min:spd_bin_size:spd_bin_max ] ;
      
      %initialize the matrix that stores the bin information
      global fuel_mat
      fuel_mat = zeros( length ( spd_bin_bounds ) - 1 , length( trq_bin_bounds ) - 1 );
      op_pts_count = zeros( size(fuel_mat) );
      
      %go through each bin and find all operating points there and sum up fuel use based on indices
      for i = 1 : length( spd_bin_bounds ) - 1 ;
         
         spd_indices = find( spd >= spd_bin_bounds(i) & spd < spd_bin_bounds(i+1) );
         
         for j = 1 : length( trq_bin_bounds ) - 1 ;
            
            %find indices for points in current bin
            
            fuel_indices = find( trq(spd_indices) >= trq_bin_bounds(j) & trq(spd_indices) < trq_bin_bounds(j+1) );
            
            fuel_mat (i,j) = sum ( fuel(fuel_indices) ) * time_step;
            op_pts_count (i,j) = length(fuel_indices);
            
         end; % for j
         
      end; % for i
      
      %mid points of bins for plotting
      trq_bin_mid4contour = trq_bin_bounds(1:end-1) + 0.5 * trq_bin_size;
      spd_bin_mid4contour = spd_bin_bounds(1:end-1) + 0.5 * spd_bin_size;
      
      %instead of mid points, use beginning points for proper plotting
      trq_bin_mid = trq_bin_bounds(1:end-1) ;
      spd_bin_mid = spd_bin_bounds(1:end-1) ;
      
      %plot with mesh and colors 2-d
      %figure
      cla
      if fuel_per_cycle_var.chkfc_plot
         handle=gcf;
         delete(gca); %delete current axes, new one to be copied in.
         delete((findobj(gcf,'tag','legend')))
         evalin('base','chkfc'); %function plots chkfc in new figure
         handle2delete=gcf;
         CopyAxes2Fig(handle); %see subfunction below (copied from gui directory and slightly changed)
         delete(handle2delete)
         
      end
      
      if fuel_per_cycle_var.fuel_bin_plot
         hold on
         delete((findobj(gcf,'tag','legend')))
         if fuel_per_cycle_var.plot_2d
            pcolor( spd_bin_mid , trq_bin_mid , fuel_mat' )
         	colorbar
         elseif fuel_per_cycle_var.plot_3d
         	surf(spd_bin_mid ,trq_bin_mid, fuel_mat')
            colorbar
         elseif fuel_per_cycle_var.plot_contour
            [c,h]=contour(spd_bin_mid4contour ,trq_bin_mid4contour, fuel_mat');
            clabel(c,h)
            colorbar

         end
         
         title('Fuel used (grams) over cycle')
         xlabel('Speed (rpm)')
         ylabel('Trq (Nm)')
      end
      
      if fuel_per_cycle_var.op_pts_bin_plot
         %figure
         delete((findobj(gcf,'tag','legend')))
         if fuel_per_cycle_var.plot_2d
            hold on
            pcolor( spd_bin_mid , trq_bin_mid , op_pts_count' )
            colorbar
         elseif fuel_per_cycle_var.plot_3d
            surf(spd_bin_mid ,trq_bin_mid, op_pts_count')
            colorbar
         elseif fuel_per_cycle_var.plot_contour
            [c,h]=contour(spd_bin_mid4contour ,trq_bin_mid4contour, op_pts_count');
            clabel(c,h)
            colorbar
         end
         
         title('Number of operating points per bin')
         xlabel('Speed (rpm)')
         ylabel('Trq (Nm)')
      end
      
      fuel_used_grams=sum(fuel)*time_step;
      num_op_pts = length(fuel);
      
      set(findobj('tag','total grams fuel'),'string',num2str(round(fuel_used_grams)))
      set(findobj('tag','no. op. pts'),'string',num2str(num_op_pts))
      
      
      %tag for axes is 'plot axes'
      
   end; %switch
   
end; %if nargin==0



%for temporary use-------------------
%load fc_vars.mat %contains spd, trq and fuel use in grams/sec
%spd_rpm = fc_spd_out_a * 30/pi;
%trq_Nm = fc_trq_out_a;
%fuel=fuel_use_gps;
%-------------------------------------
function CopyAxes2Fig(handle)

oldfighandle=gcf;
oldaxeshandle=gca;

%get legend handle for axes in question if exist
legendhandles=findall(oldfighandle,'tag','legend');
if ~isempty(legendhandles)
   olduserdata=get(legendhandles,'userdata');
   if length(legendhandles)==1
      if olduserdata.PlotHandle==oldaxeshandle
         oldlegendhandle=legendhandles;
      end
   else
      
      for i=1:length(legendhandles)
         if olduserdata{i}.PlotHandle==oldaxeshandle
            oldlegendhandle=legendhandles(i);
         end
      end
   end
end

newfighandle=handle;
newaxeshandle=copyobj(oldaxeshandle,newfighandle);

set(newaxeshandle,'units','normalized','position',[0.130372 0.109524 0.567335 0.816667],'tag','plot axes');

if exist('oldlegendhandle')
   %find the text handle that deletes legends and remove its delete function and delete the text object
   %this prevents unwanted deletion of legends not on the copied axes
   texthandle=findall(newaxeshandle,'tag','LegendDeleteProxy');
   set(texthandle,'DeleteFcn','');
   delete(texthandle);
   
   %create a new legend based on the old legend strings from the copied axes.
   ud=get(oldlegendhandle,'userdata');
	axes(newaxeshandle);
   
   if iscell(ud.lstrings)
      legend(ud.lstrings{:})
   else
      legend(ud.lstrings);
   end
end

