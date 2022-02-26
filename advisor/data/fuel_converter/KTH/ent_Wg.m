% Kristina Johansson
%Ref. 25 degrees Celsius

function f=ent_Wg(T)

%T=T-273.15;
Tref=25;
h_Wg=-241.83E3+33.46*(T-Tref)+(6.88E-3)/2*(T-Tref)^2+(7.604E-6)/3*(T-Tref)^3-(3.593E-9)/4*(T-Tref)^4;

clear f
f=h_Wg;