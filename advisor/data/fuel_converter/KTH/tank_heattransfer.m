%-------------------------------------------------------------------------------------------------------
%
% M-file: tank_heattransfer.m
% Calculates heat transfer from surroundings
% 
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%---------------------------------------------------------------------------------------------------------
function [Qa]=tank_heattransfer(Ta,T)

kn=0.3;					% (W/m,K) 	conductivity of nylon
x=0.005;					% (m) 		pressure tank wall thickness
A=2;						% (m2) 		internal surface area of pressure tank
%Ta=293;					% (K) 		ambient temperature

Qa=kn*A*(Ta-T)/x;		% [W]