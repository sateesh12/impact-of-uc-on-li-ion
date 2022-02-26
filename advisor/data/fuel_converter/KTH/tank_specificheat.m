%---------------------------------------------------------------------------------------------------------------------
% M-file: tank_specificheat.m
% Specific heat of vessel material
% 
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%---------------------------------------------------------------------------------------------------------------------

function [Cpv]=tank_specificheat(T)

% Multiplication by 4.18 converts expression from [cal] to [J]
% M of graphite is the same as for carbon, M=12.01 g/mol
%--------------------------------------------------------------------------
Cpv=4.18*(2.673+(0.002617*T)-(116900/T^2))/12.01;	% [J/g,K]














%--------------end tank_specificheat.m--------------------------------------------------------------------------------