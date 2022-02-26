%-----------------------------------------------------------------------------------
%
% M-file: Wheat.m
% Evaporization heat values for water, entalphy [kJ/kg]
% Valid for temperature in the interval 70-109 degrees Celsius
% Values from L. Wester "Tabeller och diagram för energitekniska beräkningar", 1993 
% ("Tables and diagrams for calculations in energy technology")
%
% Revision history:
% Created: Oct. 1999 by Kristina Haraldsson
% Modified: 10/12/99
%           03/21/02
%----------------------------------------------------------------------------------
function f=Wheat(T)

if T<50
   h=0;
elseif ((T>=50) & (T<60))
   h=(T-50)/(60-50)*(2356.8-2381.1)+2381.1;
elseif ((T>=60) & (T<70))
   h=(T-60)/(70-60)*(2333.3-2356.8)+2356.8;
elseif ((T>=70) & (T<80))
   h=(T-70)/(80-70)*(2308.3-2333.3)+2333.3;
elseif ((T>=80) & (T<90))
   h=(T-80)/(90-80)*(2282.8-2308.3)+2308.3;
elseif ((T>=90) & (T<100))
   h=(T-90)/(100-90)*(2256.7-2282.8)+2282.8;
elseif ((T>=100) & (T<110))
   h=(T-100)/(110-100)*(2230-2256.7)+2256.7;
else T>110
   h=0;
         end
   f=h;

