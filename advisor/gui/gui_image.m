function gui_image()

%This function sets up the image and selected menus based on the 
%drivetrain selected: options as of 6_23_98 are 'conventional',
%'parallel','series','fuel cell','ev'

%find and make the image axes current and clear any images from before
h1=findobj('tag','image_axes');
axes(h1);
delete(get(h1,'children'));

which_one=gui_current_str('drivetrain');

switch which_one
case {'series','saber_ser'}
   series_im=imread('series.jpg','jpg');
   h2 = image('Parent',h1, ...
	'ButtonDownFcn','gui_select',...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'CData',series_im, ...
   'Tag','series_image');
   

	%place fuel type on the fuel tank with text
	text('parent',h1,...
	   'string','fuel',...
	   'rotation',90,...
      'position',[30 100],...
      'tag','fuel_type');
   


case {'conventional','saber_conv_sv','saber_conv_dv'}
   conventional_im=imread('conventional.jpg','jpg');
   h2 = image('Parent',h1, ...
	'ButtonDownFcn','gui_select',...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'CData',conventional_im, ...
   'Tag','conventional_image');

	%place fuel type on the fuel tank with text
	text('parent',h1,...
	   'string','fuel',...
	   'rotation',90,...
	   'position',[30 100],...
      'tag','fuel_type');



case {'parallel','saber_par'}
   parallel_im=imread('parallel.jpg','jpg');
   h2 = image('Parent',h1, ...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'ButtonDownFcn','gui_select',...
	'CData',parallel_im, ...
   'Tag','parallel_image');

%place fuel type on the fuel tank with text
	text('parent',h1,...
	   'string','fuel',...
	   'rotation',90,...
	   'position',[27 100],...
      'tag','fuel_type');


case 'parallel_sa' % tm:7/18/00 added
   parallel_im=imread('parallel_sa.jpg','jpg'); % tm:7/18/00 updated with new figure
   h2 = image('Parent',h1, ...
    'Interruptible','off',...
    'BusyAction','cancel',...
      'ButtonDownFcn','gui_select',...
      'CData',parallel_im, ...
      'Tag','parallel_image');
   
   %place fuel type on the fuel tank with text
   text('parent',h1,...
      'string','fuel',...
      'rotation',90,...
      'position',[27 100],...
      'tag','fuel_type');
   
   
case 'insight' % tm:7/18/00 added
   parallel_im=imread('insight.jpg','jpg'); % tm:7/18/00 updated with new figure
   h2 = image('Parent',h1, ...
    'Interruptible','off',...
    'BusyAction','cancel',...
      'ButtonDownFcn','gui_select',...
      'CData',parallel_im, ...
      'Tag','parallel_image');
   
   %place fuel type on the fuel tank with text
   text('parent',h1,...
      'string','fuel',...
      'rotation',90,...
      'position',[27 100],...
      'tag','fuel_type');
   
   
case 'fuel_cell'
   fuel_cell_im=imread('fuelcell.jpg','jpg');
   h2 = image('Parent',h1, ...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'ButtonDownFcn','gui_select',...
	'CData',fuel_cell_im, ...
   'Tag','fuel_cell_image');

%place fuel type on the fuel tank with text
	text('parent',h1,...
	   'string','fuel',...
	   'rotation',90,...
      'position',[25 100],...
      'tag','fuel_type');
   
  
case 'ev'
   ev_im=imread('electric.jpg','jpg');
   h2=image('Parent',h1,...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'ButtonDownFcn','gui_select',...
   'CData',ev_im,...
   'Tag','ev_image');


case 'prius_jpn'
   prius_im=imread('prius.jpg','jpg');
   h2 = image('Parent',h1, ...
    'Interruptible','off',...
    'BusyAction','cancel',...
	'ButtonDownFcn','gui_select',...
	'CData',prius_im, ...
   'Tag','prius_image');

%place fuel type on the fuel tank with text
	text('parent',h1,...
	   'string','fuel',...
	   'rotation',90,...
      'position',[33 100],...
      'tag','fuel_type');



case 'custom'
   custom_im=imread('custom.jpg','jpg');
   h2=image('Parent',h1,...
    'Interruptible','off',...
    'BusyAction','cancel',...
 	'ButtonDownFcn','gui_select',...
   'CData',custom_im,...
   'Tag','custom_image');

otherwise
image   
end   

%make sure the axis is set up properly
set(h1,'cameraupvectormode','auto','visible','off')

%Revision history

% 08/28/98:vh enabled correct parameters for ev, parallel (no generator), and series (no TC)
% 09/3/98:tm disabled appropriate options for fuel cell
% 7/16/99: ss added prius to drivetrain list
% 10/9/99: ss removed fuel type from prius picture.
% 2/2/01: ss updated prius to prius_jpn
% 11/3/99: ss moved setting fuel type string to gui_run_files.
% 1/3/00: ss,tm added case 'custom' and called a new image named custom.jpg
% 2/8/00 ss: revamped, now selection is done in ImageInfo and gui_select
% 2/11/00 ss: added one line starting with 'set(' to make sure the axes is set up properly.
% 7/18/00;tm updated with cases for parallel_sa and insight
% 8/2/00 ss: removed all the enable on or off stuff to InputFig
% 8/16/00 ss: updated parallel_sa and insight with their respective images.