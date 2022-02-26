function plot(varargin)
% PLOT ENG_MAP class specific plotting function
% plot(eng_map_object) or plot(eng_map_object, num_contours) or plot(eng_map_object, 'rpm'|'radps') % whether to print speed in rad/s or rpm
% or plot(eng_map_object, num_contours, clabel_flag)
% 
% the num_contours option gives the number of contours to plot
% if clabel flag is 0 (false), then clabel will not be called, else
% clabel will be called (clabel prints the values on the contours)

em=varargin{1};
if nargin>=2
    if isa(varargin{2}, 'double')
        num_contours = varargin{2};
    elseif isa(varargin{2},'char')
        if strcmp(lower(varargin{2}),'rpm')
            rpmFlag=1;
        else
            rpmFlag=0;
        end
        num_contours=10.0;
    else
        num_contours = 10.0;
        rpmFlag=1;
    end
else
    num_contours = 10.0;
    rpmFlag=1;
end
figure, hold on
%  spd       trq     [6x11]
% (x(j), y(i), Z(i,j))
if rpmFlag
    [c,h] = contour(em.map_spd*30/pi,em.map_trq,em.map_eff',linspace(min(min(em.map_eff)),max(max(em.map_eff)),num_contours)); 
else
    [c,h] = contour(em.map_spd, em.map_trq, em.map_eff',linspace(min(min(em.map_eff)),max(max(em.map_eff)),num_contours));
end
if nargin==3
   clabel_flag=varargin{3};
else
   clabel_flag=1;
end
if clabel_flag
   clabel(c,h)
end
if rpmFlag
    xlabel('Shaft Speed (RPM)')
else
    xlabel('Shaft Speed (rad/s)')
end
ylabel('Shaft Torque (Nm)')
title('Engine Map--Steady State Efficiency vs. Torque and Speed')
if rpmFlag
    plot(em.map_spd*30/pi, em.max_trq, 'ro-')
else
    plot(em.map_spd, em.max_trq, 'ro-')
end