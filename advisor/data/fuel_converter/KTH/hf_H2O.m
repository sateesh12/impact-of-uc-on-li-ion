%-------------------------------------------------------------------------------------
%
% M-file: hf_H2O.m  [kJ/kg]
% saturated condition
% Data from L. Wester, 1998
% valid II: 300<=Tsat<600 K
%
% Created: 000807 by Kristina Johansson
% Revision history: 000810, 000830
%--------------------------------------------------------------------------------------
function f=hf_H2O(p)

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

if Tsat>=300
   
   %Reduced temperature
   %--------------------
   Tr=(647.3-Tsat)/647.3;
   
   A=0.8839230108;
   B=0;
   C=0;
   D=0;
   E1=-2.67172935;
   E2=6.22640035;
   E3=-13.1789573;
   E4=-1.91322436;
   E5=68.7937653;
   E6=-124.819906;
   E7=72.1435404;
   
   y=2099.3*(A+B*Tr^(1/3)+C*Tr^(5/6)+D*Tr^(7/8)+E1*Tr^(1)+E2*Tr^(2)+E3*Tr^(3)+E4*Tr^(4)+E5*Tr^(5)+E6*Tr^(6)+E7*Tr^(7));
else
   y=0; 
end;

f=[y]; %[kJ/kg]
