function []=gui_select()
global str vinf

% if right mouse button is clicked then exit out of this function
% so predefined uimenu appears
button=get(gcf,'SelectionType');
if strcmp(button,'alt')
   return
end

% get xy position where the user clicked last
cur_pt=get(findobj('tag','image_axes'),'currentpoint');
x=cur_pt(1,1); %x position of selection
y=cur_pt(1,2); %y position of selection

% figure out which component has been selected (dependent on drivetrain)
% get image mapping from the function ImageInfo, image mapping info contained
% in the cell array 'im'
im=ImageInfo(vinf.drivetrain.name);

% define the index for x and y locations of the component
x_lo=1;x_hi=2;y_lo=3;y_hi=4;

% the following for loop returns a string containing the name of the component as is found
% in optionlist, the strings need to be properly defined in image_info and the position
% of the components in the image are also defined in image_info
for i=1:max(size(im))
   pos=im{i,2}; %a little easier to go through code if pos is used
   if x>pos(x_lo) & x<pos(x_hi) & y>pos(y_lo) & y<pos(y_hi)
      name_string=im{i,1};
      break   
   end
end

% assume the user wants to select 'vehicle' if not found in the above routine.
if ~exist('name_string')
   name_string='vehicle';
end

%use callback from pushbuttons for ease of code maintenance
eval(get(findobj('tag',[compo_name(name_string),'_pushbutton']),'callback'))



% 2/8/00 ss: totally revamped this function along with gui_image, ImageInfo (new), input figure, and 
%            InputFig.
% 7/17/00 ss: replaced gui options with optionlist.
% 8/15/00 ss: ran the callback of the associated pushbutton for simplicity in code.