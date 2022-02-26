%--------------------------------------------------------------------------------------------------------------
%
% M-file: tank_specvol.m
%
% Calculates specific volume of hydrogen as function of mass remaining in tank (function of time)
 
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%-------------------------------------------------------------------------------------------------------------
function [vol]=tank_specvol(mf,t)

M=2.016;		            % [g/mol]
V=0.23; 	               	% [m3]

vol=M*V/(mass(mf,t));		% [m3/mol]