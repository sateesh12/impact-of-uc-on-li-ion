%------------------------------------------------------------------------------------------------------------------------
% M-file: tank_outtemp0.m
% Calculates initial temperature of released hydrogen from
% performed work, "flow work", by expanding gas
% 
% Revision history: 
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%------------------------------------------------------------------------------------------------------------------------

function [To]=tank_outtemp0(po,mf,t,Ti)

Cv=5.9;				% [J/g,K] 	specific heat of hydrogen
R=8.314;				% [J/mol,K]	universal gas constant

To=(po*tank_specvol(mf,t)+(Cv*Ti))/(Cv+R);



%--------------------------end tank_outtemp0.m---------------------------------------------------------------------