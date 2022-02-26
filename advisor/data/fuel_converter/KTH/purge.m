%-----------------------------------------------------
%
% M-file: purge.m
% Created: 1998 by Kristina Johansson
% Modified: 991216 
%           000512
%------------------------------------------------------
function f=purge(u,ex,Tamb,Tcond,Tah,Tcell,Pa)

p_61=u(1);
NoutWag=u(2);  %Amount of water(g)
NoutHa=u(3);  %Total amount of hydrogen out from the anode [mol/s]
NWAout=u(4);  %Total amount of water out from the anode [mol/s]
NoutWal=u(5); %Amount of water(l)

NoutTot=NWAout+NoutHa;

%Recirculation
%-------------
%R=1-ex
%NoutTot1=R*NoutTot;
%NoutWa1=R*NoutWa
%NoutHa1=NoutHa*R

%Bleed
%-----
V=ex*NoutTot;
NoutWa1=ex*NoutWag+ex*NoutWal;           %Aassumption:both gaseous and liquid form
NoutHa1=ex*NoutHa;

%------------------------------------------------------------------------
NoutHaV=NoutHa-NoutHa1;                 %Hydrogen to be re-circulated 

NoutHa1=ex*NoutHa;
NoutWg=(1-ex)*NoutWag;                   %Water (g)
NoutWl=(1-ex)*NoutWal;                   %Water (l)

NoutWaV=NoutWg+NoutWl;                 %Total amount of water to the anode condenser

%Condenser
%---------
% Mass flow of ambient air for cooling
%------------------------------------
T1=Tamb+273.15;
Tref=0+273.15;
y=Cp_A(T1);

xtot=NoutWg+NoutWl+NoutHaV;
x_W=NoutWaV/xtot;
x_H=NoutHaV/xtot;

Psat=exp(11.78*((Tcond-99.64)/(Tcond+230)));
xcond=Psat*(x_W+x_H)/(1-(Psat/p_61));

%Amount of water vapor that may condense 
%-------------------------------------------
mcond1=xcond*NoutWg*18.01;                    %[g/s]

%Total amount of water out
%-----------------------------
mW_out=NoutWl*18.01+mcond1;                   %[g/s]

% Heat of evaporation
%--------------------
lambda1=Wheat(Tcell);                         %[kJ/kg] alt. [J/g]
lambda2=Wheat(Tcond);
lambda=(lambda1+lambda2)/2;
Qcond=mcond1*lambda;                          %[J/s] 

Tm=((Tcell+Tcond)/2)+273.15;
y2=Cp_A(Tm);
y3=Cp_Wl(Tm);
m2=28.97*(NoutHaV)+18.01*(NoutWag+NoutWal);
m3=28.97*(NoutHaV)+mW_out;
m=(m2+m3)/2;                                    %Average flow [g/s]

%Percentage of condensation
%-------------------------
diff=(abs((m2-m3)/m2))*100;

Qkyl=m*((y2+y3)/2)*(Tcell-Tamb);

Qtotcond=Qkyl+Qcond;

%Required air flow to condense the water
%----------------------------------------------
mdotA=Qcond/(y*Tcond);                          %[g/s]

%Output vector
%-----------
clear u
u=[p_61 NoutWa1 NoutHa1 NoutWaV NoutHaV V mW_out mdotA Qtotcond];
f=u;