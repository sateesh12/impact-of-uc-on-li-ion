%-------------------------------------------------------------------------------------------------------
%
% M-file: tank_energybal.m
% Energy balance over pressure tank
% 
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%---------------------------------------------------------------------------------------------------------

function [dT]=tank_energybal(mf,t,p,Ta,T) 

% Calculates temperature of pressure tank as function of time assuming perfect gas conditions.
%-----------------------------------------------------------------------------------------------
R=8.314;				% [J/mol,K]
M=2.016;				% [g/mol] molar mass of hydrogen gas
Cv=5.9;				% [J/g,K] specific heat of hydrogen {assumed to be constant in temperature interval}
mv=30000; 			% [g] mass of tank

dT=(tank_heattransfer(Ta,T)-(mf*R*T*tank_compressfactor(p)/M))./(tank_hydrogenmass(mf,t)*Cv+(mv*tank_specificheat(T)));





%---------------end tank_energybal.m------------------------------------------------------------------