%-------------------------------------------------------------------------------------
%
% M-file: hfg_H2O.m  [kJ/kg]
% 
% Calculates the heat of evaporation of water as a function of temperature
%
% Data from L. Wester, 1998
% valid VI: 273.16<=Tsat<647.3 K
%
% Created: 08/10/00 by Kristina Haraldsson
% Revision history: 08/30/00
%                   04/01/02
%--------------------------------------------------------------------------------------
function f=hfg_H2O(p)

M_H2Og=18.01; %[kg/kmol]

%Calculation of saturation temperature at specified pressure
%-----------------------------------------------------------
% Data from L. Wester, 1998
% valid: 273.16<=Tsat<600 K and 0.000611<=p<12.33 MPa 

p=p/10; %[bar] to [MPa]

A1=42.6776;
B1=-3892.70;
C1=-9.48654;

Tsat=A1+B1/(log(p)+C1);

if Tsat>=273.16
   
   %Reduced temperature
   %--------------------
   Tr=(647.3-Tsat)/647.3;
   
   A=0;
   B=0.779221;
   C=4.62668;
   D=-1.07931;
   E1=-3.87446;
   E2=2.94553;
   E3=-8.06395;
   E4=11.5633;
   E5=-6.02884;
   E6=0;
   E7=0;
   
   y=2500.9*(A+B*Tr^(1/3)+C*Tr^(5/6)+D*Tr^(7/8)+E1*Tr^(1)+E2*Tr^(2)+E3*Tr^(3)+E4*Tr^(4)+E5*Tr^(5)+E6*Tr^(6)+E7*Tr^(7));
else
   y=0;
   
end;
z=M_H2Og*y

f=[y] %[kJ/kg]
