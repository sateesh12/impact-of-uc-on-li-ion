%------------------------------------------------------------------------------------
%
% M-file: CpWg.m    (Specific heat gaseous water, CpWg. [J/(mol*C)])
%
% Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
% 2nd ed., 1986, John Wiley & Sons, Inc.
% Valid in the temperature range [0-1500]degrees C, Water (g)
% Revision history:
% Created: 000619
% Modified: 
%------------------------------------------------------------------------------------------
function f=CpWg(T)

%New: Tref=25 C
Tref=25;
a=33.46;
b=0.6880*10^-2;
c=0.7604*10^-5;
d=-3.593*10^-9;

Cp=a*(T-Tref)+b/2*(T-Tref)^2+c/3*(T-Tref)^3+d/4*(T-Tref)^4 ;
%Specific heat of water (g) [J/(mol*C)] NOTE THE UNIT!

%HWgain = -241.83E3 +33.46*(T-Tref) + (6.88E-3)/2*(T-Tref)^2 +...
%  (7.60E-6)/3*(T-Tref)^3 - (3.59E-9)/4*(T-Tref)^4;

 
clear f
f=Cp;





