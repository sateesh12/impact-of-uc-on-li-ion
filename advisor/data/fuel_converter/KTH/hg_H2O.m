%-------------------------------------------------------------------------------------
%
% M-file: hg_H2O.m  [kJ/kg]
% saturated vapour
% Data from L. Wester, 1998
% valid VI: 273.16<=Tsat<647.3 K
%
% Created: 000810 by Kristina Johansson
% Revision history: 000830
%--------------------------------------------------------------------------------------
function f=hg_H2O(p)

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
   
   A=1.0;
   B=0.457874342;
   C=5.08441288;
   D=-1.48513244;
   E1=-4.81351884;
   E2=2.69411792;
   E3=-7.39064542;
   E4=10.4961689;
   E5=-5.46840036;
   E6=0;
   E7=0;
   
   y=2099.3*(A+B*Tr^(1/3)+C*Tr^(5/6)+D*Tr^(7/8)+E1*Tr^(1)+E2*Tr^(2)+E3*Tr^(3)+E4*Tr^(4)+E5*Tr^(5)+E6*Tr^(6)+E7*Tr^(7));
else
   y=0; 
end;

f=[y]; %[kJ/kg]
