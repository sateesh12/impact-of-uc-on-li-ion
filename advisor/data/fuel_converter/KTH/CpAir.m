%------------------------------------------------------------------------------------
%Kristina Johansson, 981229
%
%M-file: CpAir.m    (Specific heat Air, CpAir. [J/(mol*C)])
%
%Data from Felder, Rousseau "Elementary Principles of Chemical Processes", 
%2nd ed., 1986, John Wiley & Sons, Inc.
%Valid in the temperature range [0-1500]C, Air
% Modified: 000221
%           000620, changed into [C]
%------------------------------------------------------------------------------------------
function f=CpAir(T1)

Tref=25;
a=28.94;
b=0.4147*10^-2;
c=0.3191*10^-5;
d=-1.965*10^-9;

Cp1=a*(T1-Tref)+b/2*(T1-Tref)^2+c/3*(T1-Tref)^3+d/4*(T1-Tref)^4;  %Specific heat of Air[J/(mol*C)]

clear f
f=Cp1;