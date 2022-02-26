%----------------------------------------------------------------------
%
% M-file: fc_heat.m (Heat developed in the fuel cell stack)
%
% Function: Calculate the fuel cell efficiency and heat production 
%
% Kristina Haraldsson, NREL
% Date: 082802             
%----------------------------------------------------------------------
function f=fc_heat(u,Tch, Tah, Tcell, Tref)

% Input vector
%--------------
NinWa=u();
NinHa=u();
NinWc=u();
NoutHa=u();
NoutWal=u();
NoutWag=u();
NoutWcg=u();
NoutWcl=u();
NoutO=u();
NoutN=u();

% Sensible heat in and out [W]
%=============================
sensina = NinWa*HWgain + NinHa*HHin;
sensinc = NinWc*HWgcin + NinO*HOin + NinN*HNin;

sensouta = NoutWag*HWgout + NoutHa*HHout+NoutWal*HWl;
sensoutc = NoutWcg*HWgout + NoutWcl*HWl + NoutO*HOout + NoutN*HNout;

sensin = sensina + sensinc;
sensout = sensouta + sensoutc;


% Latent heat [W]
%================
latheat= Hcond*(NWcond);                  % Changed 000512 

%Reaction heat [W]
%=================
%Hydrogen ion flow rate

NHion = 2*i*A/(2*F);
Hr = -241.83E3 -9.93*(Tcell-Tref) + (6.22E-3)/2*(Tcell-Tref)^2 +...
  (7.35E-3)/3*(Tcell-Tref)^3 - (3.38E-9)/4*(Tcell-Tref)^4;
reaheat = (-Hr - 2*F*Ecell)*NHion;

%Efficiency fuel cell
%====================
etaFC=(-2*F*Ecell)/Hr;

% Heat developed [W]
%====================
Heat=reaheat+ latheat+ sensin-sensout

% Output vector
%----------------
clear u

u=[Heat etaFC];
f=u;