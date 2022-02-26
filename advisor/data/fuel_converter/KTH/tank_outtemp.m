%------------------------------------------------------------------------------------------------------------------------
% M-file: tank_outtemp.m
% Calculates temperature of outgoing hydrogen from
% performed work, "flow work", by expanding gas.
% 
% Revision history: 
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%------------------------------------------------------------------------------------------------------------------------
function [dTo]=tank_outtemp(po,mf,t,To)

V=0.23;				% [m3]		volume of pressure tank
M=2.016;				% [g/mol]	molar mass of hydrogen gas molecule
Cv=5.9;				% [J/g,K] 	specific heat of hydrogen
R=8.314;				% [J/mol,K]	universal gas constant
dTo=-po*((R*To/po)-tank_specvol(mf,t))/Cv;




%-----------------------------------------------end tank_outtemp.m--------------------------------------------