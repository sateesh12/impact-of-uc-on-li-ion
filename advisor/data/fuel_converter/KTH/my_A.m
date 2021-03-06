%---------------------------------------------------------------
%
% M-file: my_A.m
%
% Revision history:
% Created: 000620 by Kristina Johansson
% Last modified: 
%----------------------------------------------------------------
function f=my_A(T)

%Values from "AGA Gas Handbok", valid for p=1 bar [Ns/m2]

if T<273.15
   y=0;
elseif ((T>=273.15) & (T<288.15))
   y=(T-273.15)/(288.15-273.15)*(0.000018-0.000017)+0.000017;
elseif ((T>=288.15) & (T<300))
   y=(T-288.15)/(300-288.15)*(0.000018-0.000018)+0.000018;
elseif ((T>=300) & (T<350))
   y=(T-300)/(350-300)*(0.000021-0.000018)+0.000018;
elseif ((T>=350) & (T<400))
   y=(T-350)/(400-350)*(0.000023-0.000021)+0.000021;
elseif (T>=450)
   y=0;
end;
f=y;