%--------------------------------------------------------------------------
% M-file: fc_act.m 
%
% Estimates the water content in Nafion 117 membrane 
%
% Kristina Haraldsson, NREL
% Date: 082602
%---------------------------------------------------------------------------
function f=fc_act(u)

% Input vector
%------------------------
a=u(1);         % Activity of water vapor

%Water content of the membrane, Nafion 117 
%------------------------------------------------
if (a>1)
   lambda=14+1.4*(a-1);
elseif (a<=1)
   lambda=0.043+17.81*a-39.85*a^2+36*a^3;
end

% Output vector
%-----------------
u=lambda;

f=u;



% Revision history
% 082802 KH: removed a<0 in the elseif condition