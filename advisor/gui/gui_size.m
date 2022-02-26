function gui_size()

%this function records the position of the resized figure
global vinf
set(gcbf,'units','pixels');
vinf.gui_size=get(gcbf,'position');