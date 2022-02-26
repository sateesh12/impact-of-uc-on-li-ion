function axes2bmp(axes_handle,bmp_filename,properties,filePath)

%This function prints the axes designated by the handle of the first input to the function to 
%a bmp file name designated by the second input to the function.  

%Assigns the handle of the figure used to copy the axes to "tempfighandle."  
%Corrected for using version 5 or 6 of matlab.

global glb_no_ghostscript

%set up path for altia files
stored_current_dir=evalin('base','pwd');
advisor_path=strrep(which('advisor.m'),'\advisor.m','');
if nargin == 4
    save_path=filePath;
else
    save_path=[advisor_path,'\interactive'];
end

evalin('base',['cd ''',save_path,''''])


open('axes2bmpfig.fig');
tempfighandle=findobj('tag','axes2bmp');
new_axes_handle=copyobj(axes_handle,tempfighandle);

if nargin==2
   print(tempfighandle,'-dbmp16m','-r600',bmp_filename) 
else
   switch properties
   case 'altia'
      set(get(new_axes_handle,'XLabel'),'FontSize',12,'FontWeight','bold');
      set(get(new_axes_handle,'YLabel'),'FontSize',12,'FontWeight','bold');
      set(new_axes_handle,'FontWeight','bold','FontSize',11);
      set(tempfighandle,'Color',[.87,.87,1]);
      set(new_axes_handle,'Color',[.98,.98,1]);
      set(tempfighandle,'PaperPosition',[0,0,4.73,3.25]);
      set(new_axes_handle,'Position',[.15,.15,.75,.7]);
      set(get(new_axes_handle,'Title'),'visible','off');
      
      if strcmp(bmp_filename,'fc_efficiency')
      	fc_plot_axis=axis;
         assignin('base','fc_plot_axis',fc_plot_axis);
      end
      
      if strcmp(bmp_filename,'mc_efficiency')
      	mc_plot_axis=axis;
         assignin('base','mc_plot_axis',mc_plot_axis);
      end
      
      if strcmp(bmp_filename,'speed_trace')
         xlabel('Time (seconds)');
         ylabel('');
      end
      
      
   end
end

set(tempfighandle,'InvertHardcopy','off')

if isempty(glb_no_ghostscript)
   try
      print(tempfighandle,'-dbmp','-r72',bmp_filename) 
   catch
      errordlg('You must install Ghostscript from the Matlab installation CD for all of the interactive/replay outputs to display correctly.');
      waitfor(findobj('tag','OKButton'));
      glb_no_ghostscript=1;
   end
end

close(tempfighandle)

% return the current directory to what it was before this function
evalin('base',['cd ''',stored_current_dir,''''])

% 1/18/01 ab:created to write bmps from figures with properties for Altia
% 1/22/01 ab:made current directory adjusting
% 1/24/01 ab:corrected current directory replacing 
