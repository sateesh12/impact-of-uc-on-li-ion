%------------------------------------------------------------------------------------
%Kristina Johansson, 981229
%
%M-file: CpH.m    (Specific heat Hydrogen, CpH. [J/(mol*C)])
%
%Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
%2nd ed., 1986, John Wiley & Sons, Inc.
%Valid in the temperature range [0-1500]degrees C, Hydrogen
%Modified: 000221
%          000619
%          000830
%------------------------------------------------------------------------------------------
function f=CpH(T)

%New: Tref=25 C
Tref=25;
a=28.84;
b=0.00765*10^-2;
c=0.3288*10^-5;
d=-0.8698*10^-9;

Cp=a*(T-Tref)+b/2*(T-Tref)^2+c/3*(T-Tref)^3+d/4*(T-Tref)^4 ;
%Specific heat of Hydrogen [J/(mol*C)] NOTE THE UNIT!
 %HHin = 0 + 28.84*(T-Tref) + (7.65E-5)/2*(T-Tref)^2 + (3.288E-6)/3*(T-Tref)^3 -...
 %(8.698E-10)/4*(T-Tref)^4;
 
clear f
f=Cp;
