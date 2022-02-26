%------------------------------------------------------------------------------------
%
% M-file: tank_pressure.m
% 
% Revision history:
% Created: 1999 by Thomas Vernersson
% Modified: 03/21/02 by Kristina Haraldsson, NREL
%-----------------------------------------------------------------------------------

function [vp]=tank_pressure(T,mf,t,p)

R=8.314;                        % [J/mol,K]	universal gas constant

vp=tank_compressfactor(p)*R*T/tank_specvol(mf,t);



%---------------------------------end tank_pressure.m--------------------------------------