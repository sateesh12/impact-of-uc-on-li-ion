%------------------------------------------------------------------------------------
%
% M-file: k_air.m    (Thermal conductivity air,  [W/(m,K)]
%
% Data from R & C, "Chemical engineering", vol I, 4th ed., 1990, Pergamon Press
% Revision history:
% Created: 000816 by Kristina Johansson
% Modified: 
%------------------------------------------------------------------------------------------
function f=k_air(T)

%NOTE: temperature T in K, but the units are [W/(m*K)].

if T<273
   k=0;
elseif ((T>=273) & (T<=373))
   k=(T-273)/(373-273)*(0.031-0.024)+0.024;
elseif ((T>373))
   k=0;
end;

f=k;

