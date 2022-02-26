%-------------------------------------------------------------------------------------
%
% M-file: vg_H2O.m  [m3/kg]
% saturated vapour
% Data from L. Wester, 1998
% valid VI: 273.16<=Tsat<647.3 K
%
% Created: 000810 by Kristina Johansson
% Revision history: 
%--------------------------------------------------------------------------------------
function f=vg_H2O(p)

M_H2Og=18.01; %[kg/kmol]

%Calculation of saturation temperature at specified pressure
%-----------------------------------------------------------
% Data from L. Wester, 1998
% valid: 273.16<=Tsat<600 K and 0.000611<=p<12.33 MPa 

p=p/10; %[bar] to [MPa]

A1=42.6776;
B1=-3892.70;
C1=-9.48654;

Tsat=A1+B1/(log(p)+C1)

if Tsat>=273.16
   
   %Reduced temperature
   %--------------------
   Tr=(647.3-Tsat)/647.3;
   
   A=1.0;
   B=1.6351057;
   C=52.584599;
   D=-44.694653;
   E1=-8.9751114;
   E2=-0.43845530;
   E3=-19.179576;
   E4=36.765319;
   E5=-19.462437;
   E6=0;
   E7=0;
   
   y=(A+B*Tr^(1/3)+C*Tr^(5/6)+D*Tr^(7/8)+E1*Tr^(1)+E2*Tr^(2)+E3*Tr^(3)+E4*Tr^(4)+E5*Tr^(5)+E6*Tr^(6)+E7*Tr^(7));
   v=(y*22.089*0.003155)/p
else
   v=0;
   
end;

f=[v];%[m3/kg]
