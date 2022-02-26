% Kristina Johansson
%Ref. 25 degrees Celsius

function f=ent_O2(T)

%T=T-273.15;
Tref=25;
h_O2=29.10*(T-Tref)+(1.158E-2)/2*(T-Tref)^2-(6.076E-6)/3*(T-Tref)^3+(1.311E-9)/4*(T-Tref)^4;

clear f
f=h_O2;