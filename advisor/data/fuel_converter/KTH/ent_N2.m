% Kristina Johansson
%Ref. 25 degrees Celsius

function f=ent_N2(T)

%T=T-273.15;
Tref=25;
h_N2=29.00*(T-Tref)+(2.199E-3)/2*(T-Tref)^2+(5.723E-6)/3*(T-Tref)^3-(2.781E-9)/4*(T-Tref)^4;
 %Enthalpy of Nitrogen [J/mol]

clear f
f=h_N2;