% Kristina Johansson
%Ref. 25 degrees Celsius

function f=ent_H2(T)
%global T
%T=T-273.15;
Tref=25;
%Tref=0;
h_H2=28.84*(T-Tref)+(7.65E-5)/2*(T-Tref)^2+(3.29E-6)/3*(T-Tref)^3-(8.698E-10)/4*(T-Tref)^4;
%h_H2=28.84*T.*28.+(7.65E-5)/2*(T)^2+(3.29E-6)/3*(T)^3-(8.698E-10)/4*(T)^4;

clear f
f=h_H2;