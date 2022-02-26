%------------------------------------------------------------------------------------
%
% M-file: CpWl.m    (Specific heat liquid water, CpWl. [J/(mol*C)])
%
% Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
% 2nd ed., 1986, John Wiley & Sons, Inc.
% Valid in the temperature range [0-100]degrees C, Water (l)
% Revision history:
% Created: 000619
% Modified: 000830
%------------------------------------------------------------------------------------------
function f=CpWl(T)

%New: Tref=0 C, changed 000830
Tref=25;
a=75.4;

Cp=a*(T-Tref);
%Specific heat of water (l) [J/(mol*C)] NOTE THE UNIT!

%HWl = -285.84E3 + 75.38*(Tcell-Tref);

clear f
f=Cp ;


