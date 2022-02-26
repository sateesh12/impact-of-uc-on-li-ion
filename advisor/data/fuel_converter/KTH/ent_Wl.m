% Kristina Johansson
%Ref. 25 degrees Celsius

function f=ent_Wl(T)

%T=T-273.15;
Tref=25;
h_Wl= -285.84*1000+75.4*(T-Tref);



clear f
f=h_Wl;