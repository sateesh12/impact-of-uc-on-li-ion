%------------------------------------------------------------------------------------
%
% M-file: CpN.m    (Specific heat Nitrogen, CpN. [J/(mol*C)])
%
% Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
% 2nd ed., 1986, John Wiley & Sons, Inc.
% Valid in the temperature range [0-1500]degrees C, Nitrogen
% Revision history:
% Created: 000619 by Kristina Johansson
% Modified: 000831
%------------------------------------------------------------------------------------------
function f=CpN(T)

%New: Tref=25 C, changed to 0C 000831
Tref=0;
a=29.00;
b=0.2199*10^-2;
c=0.5723*10^-5;
d=-2.871*10^-9;

Cp=a*(T-Tref)+b/2*(T-Tref)^2+c/3*(T-Tref)^3+d/4*(T-Tref)^4 ;
%Specific heat of Nitrogen [J/(mol*C)] NOTE THE UNIT!
% HNin = 0 + 29.00*(T-Tref) + (2.199E-3)/2*(T-Tref)^2 +...
 %  (5.723E-6)/3*(T-Tref)^3 - (2.871E-9)/4*(T-Tref)^4;
 
clear f
f=Cp;