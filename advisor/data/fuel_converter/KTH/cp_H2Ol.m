%------------------------------------------------------------------------------------
%
% M-file: cp_H20l.m    (Specific heat of liquid water,  [kJ/(kg,K)])
%
% Data from Moran, Shapiro "Fundamentals of Engineering Thermodynamics", 
% 3rd ed., 1998, John Wiley & Sons, Inc.
% 
% Revision history:
% Created: 08/15/00 by Kristina Haraldsson
% Modified: 
%------------------------------------------------------------------------------------------
function f=cp_H2Ol(T)

%NOTE: temperature T in K.

if T<273
   cp=0;
elseif ((T>=273) & (T<300))
   cp=(T-273)/(300-273)*(4.179-4.217)+4.217;
elseif ((T>=300) & (T<373))
   cp=(T-300)/(373-300)*(4.218-4.179)+4.179;
else T>373
   cp=0;
end;
f=cp;

