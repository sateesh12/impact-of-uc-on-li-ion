%------------------------------------------------------------------------------------
%
% M-file: CpO.m    (Specific heat Oxygen, CpO. [J/(mol*C)])
%
% Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
% 2nd ed., 1986, John Wiley & Sons, Inc.
% Valid in the temperature range [0-1500]degrees C, Oxygen
% Revision history:
% Created: 000619 by Kristina Johansson
% Modified: 000830
%				000912
%------------------------------------------------------------------------------------------
function f=CpO(T)

Tref=25, %degree Celsius, changed from 25 C 000830
a=29.10;
b=0.01158;
c=-0.6076*10^-5;
d=1.311*10^-9;

%Cp=a*(T-Tref)+b/2*(T-Tref)^2+c/3*(T-Tref)^3+d/4*(T-Tref)^4 ;
Cp=a+b*T+(c/2)*T^2+(d/3)*T^3 
%Specific heat of Oxygen [J/(mol*C)] NOTE THE UNIT!

%HOin = 0 + 29.10*(T-Tref) + (1.158E-2)/2*(T-Tref)^2 -...
 %  (6.076E-6)/3*(T-Tref)^3 + (1.311E-9)/4*(T-Tref)^4;

clear f
f=Cp;