%-------------------------------------------------------------------------------------
%
% M-file: cp_H2Og.m  [kJ/kmol,K respectively kJ/kg,K] water vapor (Gaseous water)
% 
% Calculates specific heat of water vapor
% Data from L. Wester, 1998
%
% Created: 08/04/00 by Kristina Haraldsson
% Revision history: 04/01/02
%--------------------------------------------------------------------------------------
function f=cp_H2Og(T)

M_H2Og=18.01; %[kg/kmol]

a_min1=0.073147600;
a_0=27.885805;
a_1=8.4430197;
a_2=11.985297;
a_3=-16.092233;
a_4=13.636273;
a_5=-6.4729000;
a_6=1.1891256;
a_7=0;

y=a_min1*(T/1000)^(-1)+a_0*(T/1000)^(0)+a_1*(T/1000)^(1)+a_2*(T/1000)^(2)+a_3*(T/1000)^(3)+a_4*(T/1000)^(4)+a_5*(T/1000)^(5)+a_6*(T/1000)^(6)+a_7*(T/1000)^(7);
z=y/M_H2Og;

f=[y];