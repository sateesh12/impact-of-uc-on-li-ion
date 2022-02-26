%------------------------------------------------------------------------------------
%
% M-file: tank_hydrogenmass.m
% 
% Calculates mass of hydrogen in tank after time t
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%-----------------------------------------------------------------------------------
function [m]=tank_hydrogenmass(mf,t)

m0=5000;		    % [g] initial mass of hydrogen

m=m0-mf*t; 	        % [g] mass of hydrogen in pressure tank