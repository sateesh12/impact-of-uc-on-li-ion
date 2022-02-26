function center_figure(Handle)   
%   This function centers the figure having handle passed to it

set(Handle,'units','pixels');
position=get(Handle,'position');
screensize=get(0,'screensize');
set(Handle,'position', [(screensize(3)-position(3))/2  (screensize(4)-position(4))/2 ...
        position(3) position(4)]);
