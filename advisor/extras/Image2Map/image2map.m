function image2map(option,option2)
%this file reads map information off a picture and saves it to a matrix for 
%use with advisor

global i2m

if nargin==0
   
   %initialize the default directories
   i2m.lastloadpath=pwd;
   i2m.lastsavepath=pwd;
   
   %open the main figure
   open image2map.fig
   
   image2map('load previous work' , 'defaults')
   
   warndlg(['Image2Map works well ',...
           'for maps without contours that form islands or fold back on themselves.  ',...
           'In most cases clicking more points for the contours and refining the x and ',...
           'y-values will improve the map.  The interpolation is done using the griddata ',...
           'command.  Please email any helpful suggestions/comments to advisor@nrel.gov.'],'Image2Map warning','modal')

else % if nargin~=0
   
   switch option
      
   case 'load image'
      
      %remember current directory
      curdir=pwd;
      
      %switch directories to last load directory
      cd(i2m.lastloadpath)
      
      %get the name of the image file to load.
      [f,p]=uigetfile('*.jpg;*.bmp;*.pcx;*.png;*.hdf;*.xwd','Select the Image File');
      
      %change the directory back
      cd(curdir)
      
      %if no file selected then get out of this function
      if f==0; return; end
      
      %save the load directory
      i2m.lastloadpath=p;
      
      %save filename for later-documentation
      i2m.image.imagefilename=[p f];
      
      %read the image into matlab format
      i2m.imagedata=imread(i2m.image.imagefilename);
      
      %find the appropriate axes to load the image into, 
      %load the image, then reset the axes 'tag' property
      axes(findobj('tag','image2map image axes'))
      image(i2m.imagedata);
      
      %handle differently if data is grayscale
      if ndims(i2m.imagedata)==2
      
          if isempty(find(i2m.imagedata>1))  %if it is 1 bit per pixel (black and white)
              colormap([0 0 0;1 1 1])
          else
              colormap(gray);
          end
          
      end
       
      set(gca, 'tag','image2map image axes')
      
      if isfield(i2m,'image') & isfield(i2m.image, 'curves')
         i2m.image=rmfield(i2m.image, 'curves');
         set(findobj('tag','curves_inputed'),'value',1,'string',' ')    
      end
      if isfield(i2m,'image') & isfield(i2m.image, 'contour')
         i2m.image=rmfield(i2m.image, 'contour');
         set(findobj('tag','contour_values_inputed'),'value',1,'string',' ')
      end
      
      image2map('update mapping')
      
   case 'x-low data value'
      i2m.map.xa1=str2num(get(findobj('tag','x-low data value'),'string'));
      image2map('update mapping')   
   case 'x-high data value'
      i2m.map.xa2=str2num(get(findobj('tag','x-high data value'),'string'));
      image2map('update mapping')   
   case 'y-low data value'
      i2m.map.ya1=str2num(get(findobj('tag','y-low data value'),'string'));
      image2map('update mapping')   
   case 'y-high data value'
      i2m.map.ya2=str2num(get(findobj('tag','y-high data value'),'string'));
      image2map('update mapping')   
      
   case 'x-low pixel value'
      h=findobj('tag',option);
      color=get(h,'backgroundcolor');
      set(h,'backgroundcolor',[1 0 0]);
      [i2m.map.xp1,junk]=ginput(1); %p is for pixel
      set(h,'string',num2str(i2m.map.xp1),'backgroundcolor',color)
      image2map('update mapping')   
   case 'x-high pixel value'
      h=findobj('tag',option);
      color=get(h,'backgroundcolor');
      set(h,'backgroundcolor',[1 0 0]);
      [i2m.map.xp2,junk]=ginput(1); %p is for pixel
      set(h,'string',num2str(i2m.map.xp2),'backgroundcolor',color)
      image2map('update mapping')   
   case 'y-low pixel value'
      h=findobj('tag',option);
      color=get(h,'backgroundcolor');
      set(h,'backgroundcolor',[1 0 0]);
      [junk,i2m.map.yp1]=ginput(1); %p is for pixel
      set(h,'string',num2str(i2m.map.yp1),'backgroundcolor',color)
      image2map('update mapping')   
   case 'y-high pixel value'
      h=findobj('tag',option);
      color=get(h,'backgroundcolor');
      set(h,'backgroundcolor',[1 0 0]);
      [junk,i2m.map.yp2]=ginput(1); %p is for pixel
      set(h,'string',num2str(i2m.map.yp2),'backgroundcolor',color)
      image2map('update mapping')   
      
      
   case 'update mapping'
      %next figure out the function that maps pixels to actual data
      i2m.map.xp2xa=(i2m.map.xp2-i2m.map.xp1)/(i2m.map.xa2-i2m.map.xa1);
      i2m.map.xp0=i2m.map.xp1-i2m.map.xa1*i2m.map.xp2xa;
      
      % this gives actual x data  xa=(xsel-xp0)/xp2xa;  
      
      i2m.map.yp2ya=(i2m.map.yp2-i2m.map.yp1)/(i2m.map.ya2-i2m.map.ya1);
      i2m.map.yp0=i2m.map.yp1-i2m.map.ya1*i2m.map.yp2ya;
      
      %this gives actual y data   ya=(ysel-yp0)/yp2ya;  
      
      %update any data that may be affected by new mapping variables
      image2map('update data')
      
   case 'update data'
      %use the currently saved mapping variables to update the data
      eval('junk=i2m.image.curves(1).x;testing=1;','testing=0;')%try, catch type of statement
      if testing
         
         if isfield(i2m , 'data') & isfield(i2m.data, 'curves')
            i2m.data=rmfield(i2m.data,'curves'); %remove data.curves (keeps things clean)
         end
         
         for i=1:length(i2m.image.curves)
            i2m.data.curves(i).x = ( i2m.image.curves(i).x - i2m.map.xp0 ) ./ i2m.map.xp2xa;
      		i2m.data.curves(i).y = ( i2m.image.curves(i).y - i2m.map.yp0 ) ./ i2m.map.yp2ya;
         end
      end
            
      
      %update contour data
      eval('junk=i2m.image.contour(1).x;testing=1;','testing=0;');%try, catch type of statement
      if testing
         
         xp=[]; yp=[]; z=[];
         for i=1:length(i2m.image.contour)
            xp=[xp; i2m.image.contour(i).x];
            yp=[yp; i2m.image.contour(i).y];
            z=[z; i2m.image.contour(i).value*ones(size(i2m.image.contour(i).x))];
         end
         
         x=(xp-i2m.map.xp0)./i2m.map.xp2xa;
      	y=(yp-i2m.map.yp0)./i2m.map.yp2ya;
      
      	i2m.data.mapdata=[x y z];
         
      elseif isfield(i2m,'data') & isfield(i2m.data,'mapdata')
         i2m.data=rmfield(i2m.data,'mapdata');
      end
      
      image2map('plot')
      
   case 'add curve'
      
      image2map('show image')
    
      fig_handle=gcf;
      
      %defining curve1
      curvename=inputdlg({'Name this curve; Click ok; Then click on defining curve points; hit ''enter'' when done'},...
         'Title',1,{'curve'});
      if isempty(curvename);return;end
      
      [x,y]=ginput;
      % -------- arun added new: 8/23/01---
      x_temp=x;
      y_temp=y;
      clear x y;
      x=[];
      y=[];
      for i=1:length(x_temp)
         x=[x;x_temp(i)];
         y=[y;y_temp(i)];
         if(i~=length(x_temp))
            for j=1:9
               x=[x;x_temp(i)+(x_temp(i+1)-x_temp(i))*j/10];
               y=[y;y_temp(i)+(y_temp(i+1)-y_temp(i))*j/10];
            end
         else
            disp('done')
         end
      end
      % -------end of arun added stuff -----
      
      %set the figure as the active one on top again
      figure(fig_handle);
      
      %store information in the i2m structure
      if isfield(i2m, 'image') & isfield(i2m.image,'curves')
         curve_index=length(i2m.image.curves) +1;      
      else
         curve_index=1;
      end

      i2m.image.curves(curve_index).name=curvename{1};
      i2m.image.curves(curve_index).x=x;
      i2m.image.curves(curve_index).y=y;
            
      %the following will convert pixel data into actual data
      image2map('update data')
      
      for i=1:length(i2m.image.curves)
         string{i}=i2m.image.curves(i).name;
      end
      
      set(findobj('tag','curves_inputed'),'string', string , 'value',length(i2m.image.curves))

	case 'delete curve'
      curve_index=get(findobj('tag','curves_inputed'),'value');
      number_of_entries=length(get(findobj('tag','curves_inputed'),'string'));
      
      if number_of_entries==1& strcmp(' ',get(findobj('tag','curves_inputed'),'string'))
         return
      elseif number_of_entries==1
         i2m.image=rmfield(i2m.image,'curves');
         set(findobj('tag','curves_inputed'),'string', ' ' , 'value',1)
      elseif number_of_entries>1
         temp=i2m.image.curves;
         i2m.image=rmfield(i2m.image,'curves');
         
         keep_indices=[];
         for i=1:number_of_entries
            if i~=curve_index
               keep_indices=[keep_indices, i];
            end
         end
         i2m.image.curves=temp(keep_indices);
         
         for i=1:length(i2m.image.curves)
            string{i}=i2m.image.curves(i).name;
         end
         
         set(findobj('tag','curves_inputed'),'string', string , 'value',length(i2m.image.curves))
      end
      
      image2map('update data')
      
   case 'delete contour'
      contour_index=get(findobj('tag','contour_values_inputed'),'value');
      number_of_entries=length(get(findobj('tag','contour_values_inputed'),'string'));
      
      if number_of_entries==1 & strcmp(' ',get(findobj('tag','contour_values_inputed'),'string'));
         return
      elseif number_of_entries==1
         i2m.image=rmfield(i2m.image,'contour');
         set(findobj('tag','contour_values_inputed'),'string', ' ' , 'value',1)
      elseif number_of_entries>1
         temp=i2m.image.contour;
         i2m.image=rmfield(i2m.image,'contour');
         
         keep_indices=[];
         for i=1:number_of_entries
            if i~=contour_index
               keep_indices=[keep_indices, i];
            end
         end
         i2m.image.contour=temp(keep_indices);
         
         for i=1:length(i2m.image.contour)
            string{i}=num2str(i2m.image.contour(i).value);
         end
         
         set(findobj('tag','contour_values_inputed'),'string', string , 'value',length(i2m.image.contour))
      end
      
      image2map('update data')

	case 'add contour'   
      
      image2map('show image')
      
      fig_handle=gcf;
      
      %collect map data
      zstr=inputdlg('enter value corresponding to next series of clicks; hit ''enter'' when done');
      if isempty(zstr);return;end
      z=str2num(zstr{1});
      
      [x,y]=ginput;
      % -------- arun added new: 8/23/01---
      x_temp=x;
      y_temp=y;
      clear x y;
      x=[];
      y=[];
      for i=1:length(x_temp)
         x=[x;x_temp(i)];
         y=[y;y_temp(i)];
         if(i~=length(x_temp))
            for j=1:9
               x=[x;x_temp(i)+(x_temp(i+1)-x_temp(i))*j/10];
               y=[y;y_temp(i)+(y_temp(i+1)-y_temp(i))*j/10];
            end
         else
            disp('done')
         end
      end
      % -------end of arun added stuff -----
      
      %set the figure as the active one on top again
      figure(fig_handle);

      %store information in the i2m structure
      if isfield(i2m, 'image') & isfield(i2m.image,'contour')
         contour_index=length(i2m.image.contour) +1;      
      else
         contour_index=1;
      end
      
      i2m.image.contour(contour_index).value=z;

      i2m.image.contour(contour_index).x=x;
      i2m.image.contour(contour_index).y=y;
      
      %order the contour data by the contour values
      for i=1:length(i2m.image.contour)
         temp(i)=i2m.image.contour(i).value;
      end
      [y,sorted_indices]=sort(temp);
      clear temp
      temp=i2m.image.contour;
      i2m.image=rmfield(i2m.image,'contour');
      i2m.image.contour=temp(sorted_indices);
      
      %the following will convert pixel data into actual data
      image2map('update data')
      
      for i=1:length(i2m.image.contour)
         string{i}=num2str(i2m.image.contour(i).value);
      end
      
      set(findobj('tag','contour_values_inputed'),'string', string , 'value',length(i2m.image.contour))
      
   case 'x-values'        
      
      i2m.data.x_map=eval(get(findobj('tag','x-values'),'string'));
      image2map('plot')

   case 'y-values'
      
      i2m.data.y_map=eval(get(findobj('tag','y-values'),'string'));
      image2map('plot')
      
   case  'contour values'  
      i2m.plot.contour_values=str2num(get(findobj('tag','contour values'),'string'));
      image2map('plot')
      
   case 'axes limits'
      i2m.plot.axes_limits=eval(get(findobj('tag','axes limits'),'string'));
      image2map('plot')
      
   case 'plot'
      handle=findobj('tag','image2map data axes');
      axes(handle)
      cla
      
      hold on      
      eval('junk=i2m.image.curves(1).x;testing=1;','testing=0;')%try, catch type of statement
      if testing
         %data to plot
         for i=1:length(i2m.image.curves)
            %Don't use spline because it goes out of the envelope of points
            i2m.data.curves(i).interp_vals = interp1( i2m.data.curves(i).x , i2m.data.curves(i).y , i2m.data.x_map ,'linear');
            %i2m.data.curves(i).interp_vals = spline( i2m.data.curves(i).x , i2m.data.curves(i).y , i2m.data.x_map);
           	plot(i2m.data.x_map,i2m.data.curves(i).interp_vals)
            
            if get(findobj('tag','plot points checkbox'),'value')
                plot(i2m.data.curves(i).x,i2m.data.curves(i).y,'+')  
            end
         end
      end  
      % Most important contour interpolating algorithm is coded below      
      if isfield(i2m , 'data') & isfield(i2m.data,'mapdata') & ~isempty(i2m.data.mapdata)
         [xgrid,ygrid]=meshgrid(i2m.data.x_map,i2m.data.y_map);
         
         if isfield(i2m,'interpolation_method')
            method=i2m.interpolation_method;
         else
            method='linear';
         end
         
         % ---------------- Interpolating done here ----------------
         i2m.data.map=griddata(i2m.data.mapdata(:,1),i2m.data.mapdata(:,2),i2m.data.mapdata(:,3),xgrid,ygrid,method);
         % ---------------- End of interpolating ----------------
         
         hold on
         
         if isempty(i2m.plot.contour_values)
            i2m.plot.contour_values=[i2m.data.data_values_entered];
         end
         
         try %sometimes there is an error when the first contour is picked (this will avoid it)
         	[c,handles]=contour(xgrid,ygrid,i2m.data.map,i2m.plot.contour_values);
            label=clabel(c,handles,i2m.plot.contour_values);
            
            
            if get(findobj('tag','plot points checkbox'),'value')
                % ------- ADDED by ARUN-------
                hold on
                for i=1:length(i2m.data.mapdata)
                    plot(i2m.data.mapdata(i,1),i2m.data.mapdata(i,2),'r+')  
                end
            end
        % ------- END OF ARUN -----------
         end
      end
      
      axis(i2m.plot.axes_limits)
      set(gca,'tag','image2map data axes')
   
   case 'show image'
      %hide data plot
      h=findobj('tag','image2map data axes');
      set(findobj(h),'visible','off')
      %show image plot
      h=findobj('tag','image2map image axes');
      set(findobj(h),'visible','on')
      
   case 'show data plot'
      %hide image plot
      h=findobj('tag','image2map image axes');
      set(findobj(h),'visible','off')
      %show data plot
      h=findobj('tag','image2map data axes');
      set(findobj(h),'visible','on')
      
   case 'show overlay'
      %show data plot
      h=findobj('tag','image2map data axes');
      set(findobj(h),'visible','on');
		set(h,'visible','off')
      %show image plot
      h=findobj('tag','image2map image axes');
      set(findobj(h),'visible','on')
       
   case 'show both'
      %show data plot
      h=findobj('tag','image2map data axes');
      set(findobj(h),'visible','on');
      %show image plot
      h=findobj('tag','image2map image axes');
      set(findobj(h),'visible','on')
      
   case 'interpolation method'
      string=get(findobj('tag','interpolation method'),'string');
      value=get(findobj('tag','interpolation method'),'value');
      i2m.interpolation_method=string{value};
      
      image2map('plot')
      
   case 'match up axes'
      %leave image axes alone and change data axes to match image axes
      set(findobj('tag','image2map image axes'),'units','pixels');
      
      pos_im_ax=get(findobj('tag','image2map image axes'),'position');
      xlim=get(findobj('tag','image2map image axes'),'XLim');
      ylim=get(findobj('tag','image2map image axes'),'YLim');
      
      x_axes_p2fig_p=pos_im_ax(3)/diff(xlim);
      y_axes_p2fig_p=pos_im_ax(4)/diff(ylim);
      
      height_pix=(i2m.plot.axes_limits(4)-i2m.plot.axes_limits(3))*abs(i2m.map.yp2ya) * y_axes_p2fig_p;
      width_pix=(i2m.plot.axes_limits(2)-i2m.plot.axes_limits(1))*abs(i2m.map.xp2xa) * x_axes_p2fig_p;
      
      %xa=(xsel-xp0)/xp2xa
      
      x_axes_pix=i2m.plot.axes_limits(1) * i2m.map.xp2xa + i2m.map.xp0;
      y_axes_pix=i2m.plot.axes_limits(3) * i2m.map.yp2ya + i2m.map.yp0;
      x_fig_pix=(x_axes_pix-xlim(1))*x_axes_p2fig_p+pos_im_ax(1);
      y_fig_pix=(ylim(2)-y_axes_pix)*y_axes_p2fig_p+pos_im_ax(2);
      
      axes_pos=[x_fig_pix y_fig_pix width_pix height_pix];
      
      set(gcf,'units','pixels')
      set(findobj('tag','image2map data axes'),'units','pixels','position',axes_pos)
      
      set(findobj('tag','image2map data axes'),'units','normalized')
      set(findobj('tag','image2map image axes'),'units','normalized')
      
   case 'output to *.m'
      %save map and curve data
      
      [f,p]=uiputfile('*.m','Save as m-file');
      if f==0; return; end
      
      fid=fopen([p f],'w+');
      
      fprintf(fid,['\n%%following created from image file, ',strrep(i2m.image.imagefilename,'\','\\'),', on ',datestr(now,0),'\n\n']);
      
      fprintf(fid,['x_map=',mat2str(i2m.data.x_map,4),';\n']);
      
      fprintf(fid,['y_map=',mat2str(i2m.data.y_map,4),';\n']);
      
      eval('junk=i2m.image.contour(1).x;testing=1;','testing=0;');%try, catch type of statement
      if testing
      	fprintf(fid,['map=',strrep(mat2str(i2m.data.map,3),';',';\n'),';\n']);
      end
      
      eval('junk=i2m.image.curves(1).x;testing=1;','testing=0;')%try, catch type of statement
		if testing
      	for i=1:length(i2m.image.curves)
      		fprintf(fid,[i2m.image.curves(i).name,'=',mat2str(i2m.data.curves(i).interp_vals,4),';\n']);
      	end
      end
      
      fclose(fid);
      helpdlg(['file saved as:',p,f]);
      
   case 'save current work'
      
      [f,p] = uiputfile('*_i2m.mat','image2map save current work in *_i2m.mat');
      
      if f==0 %user did not select a file name
         return
      end
      
      %make sure file does not contain -,+,!,~,&
      if ~isempty(findstr('-',f))|~isempty(findstr('+',f))|~isempty(findstr('!',f))|...
            ~isempty(findstr('~',f))|~isempty(findstr('&',f))|~isempty(findstr(';',f))|...
            ~isempty(findstr('''',f))|~isempty(findstr(' ',f))
         WARNDLG({'invalid filename';'illegal characters - , + , ! , ~ , & , ; ,'',space'})
         return
      end
      
      %make sure file does not start with a number, make sure i&j are ok though (imaginary by default).
      if ~isempty(str2num(f(1)))
         if ~(strcmp(f(1),'j')|strcmp(f(1),'i')) %i and j are ok.
            WARNDLG({'invalid filename';'first character cannot be a number'})
            return;
         end
      end
      
      %make sure file ends in '_i2m.mat'
      temp=length(f);
      
      if temp>8
         if ~strcmp(f(temp-7:temp),'_i2m.mat')
            index=temp+1; %initialize the place where the _i2m.mat will be added
            %match the letters from the end towards the beginning, when there is a mismatch
            %that is where the additional characters will be added.
            if strcmp(f(temp-1:temp),'.mat')
               index=index-4;
            elseif strcmp(f(temp-3:temp),'_i2m')
               index=index-4;
            end
            
            f=[f(1:index-1),'_i2m.mat'];
            
            %clear problem with extra '.' in the name
            if length(findstr(f,'.'))>1
               WARNDLG({['invalid filename:  ',f];'contains more than 1 '' . '''})
               return;
            end
            
            errordlg(['input file name will be: ',f],' ');
            uiwait(gcf);
         end
      else
         if ~isempty(findstr(f,'.mat'))
            f=[f(1:length(f)-4),'_i2m.mat'];
         elseif ~isempty(findstr(f,'_i2m'))
            index2=findstr(f,'_i2m');
            f=[f(1:index2-1), '_i2m.mat'];
         else
            f=[f,'_i2m.mat'];
         end
         
         %clear problem with extra '.' in the name
         if length(findstr(f,'.'))>1
            WARNDLG({['invalid filename:  ',f];'contains more than 1 '' . '''})
            return;
         end
         
         errordlg(['input file name will be: ',f],' ');
         uiwait(gcf);
         
      end
      
      save([p,f],'i2m');
      
   case 'load previous work'
      
      if nargin==2 & strcmp(option2, 'defaults')
         clear i2m
         load default_i2m.mat
      else
         [f,p]=uigetfile('*_i2m.mat','Load Previous Work');
      	if f==0; return; end
      
      	clear i2m
      	load([p,f])
      end
      
      axes(findobj('tag','image2map image axes'))
      image(i2m.imagedata);
      set(gca, 'tag','image2map image axes')

      
      set(findobj('tag','x-low data value'),'string',num2str(i2m.map.xa1));
      set(findobj('tag','x-high data value'),'string',num2str(i2m.map.xa2));
      set(findobj('tag','y-low data value'),'string',num2str(i2m.map.ya1));
      set(findobj('tag','y-high data value'),'string',num2str(i2m.map.ya2));
      set(findobj('tag','x-low pixel value'),'string',num2str(i2m.map.xp1));
      set(findobj('tag','x-high pixel value'),'string',num2str(i2m.map.xp2));
      set(findobj('tag','y-low pixel value'),'string',num2str(i2m.map.yp1));
      set(findobj('tag','y-high pixel value'),'string',num2str(i2m.map.yp2));
      
      
      
      set(findobj('tag','x-values'),'string',['[' num2str(i2m.data.x_map) ']']);
      set(findobj('tag','y-values'),'string',['[' num2str(i2m.data.y_map) ']']);
      
      %initialize the contour values from saved figure
      set(findobj('tag','contour values'),'string',['[' num2str(i2m.plot.contour_values) ']']);
      
      %initialize the axes limits from the saved figure
      set(findobj('tag','axes limits'),'string', ['[' num2str(i2m.plot.axes_limits) ']']);
      
      if isfield(i2m, 'image')
         if isfield(i2m.image, 'curves')
      		for i=1:length(i2m.image.curves)
         		string{i}=i2m.image.curves(i).name;
      		end
         set(findobj('tag','curves_inputed'),'string', string , 'value',length(i2m.image.curves))
   		end
         if isfield(i2m.image, 'contour')
            for i=1:length(i2m.image.contour)
               string{i}=num2str(i2m.image.contour(i).value);
            end
            
            set(findobj('tag','contour_values_inputed'),'string', string , 'value',length(i2m.image.contour))
         end
      end
      
      if isfield(i2m, 'interpolation_method')
        strings=get(findobj('tag','interpolation method'),'string');
        value=strmatch(i2m.interpolation_method,strings,'exact');
        set(findobj('tag','interpolation method'),'value',value);
      end
  

	image2map('update mapping')
	image2map('match up axes')
      
   case 'exit'
      close(gcbf)
      
   end   
end %if nargin==0
