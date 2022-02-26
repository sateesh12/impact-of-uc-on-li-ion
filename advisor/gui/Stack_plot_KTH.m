%----------------------------------------------------------------------------------------------------
% M-file: Stack_plot_KTH.m    to produce values of E and i and thus relation between load, E and i
% 
% Revision history: Created: 032902 by Kristina Haraldsson
%					  
%
%-----------------------------------------------------------------------------------------------------
function [icell,Vcell,Ecell,eta_ohm, eta_act,Tcell,p,moist,Pcell,eta_fc]=Stack_plot_KTH(icell,Tcell,p,moist)

%Input
%-----

RHah=100*moist;
RHch=100*moist;
Pa=p;
Pc=p;
%RHah=50;
%RHch=50;
Tah=Tcell;
Tch=Tcell;
Tamb=15;
Pamb=1.013;
RHo=66;
XON=0.21;
tm=0.0125;
%Voc=1.1;
%Voc=1.08;
R2=8.314;
jo=0.01;
F=96487;
A=280;
N=1;
%N=380;

% Saturation pressures [atm]
%===========================

% Saturation pressure of water in fuel cell
Psat1=exp(11.78*((Tcell-99.64)/(Tcell+230)));%[bar]

% Saturation pressure of water in anode humidifier
Psatah1 =exp(11.78*((Tah-99.64)/(Tah+230)));%[bar]

% Saturation pressure of water in cathode humidifier
%Psatch = fcpsat(Tch);
Psatch1=exp(11.78*((Tch-99.64)/(Tch+230)));%[bar]

%Absolute humidity in the inlet air
%==================================
%Psat_air=exp(11.78*((Tamb-99.64)/(Tamb+230)));%[bar]
%x=((18.015/28.97)*(RHo/100)*Psat_air)/(Pamb-((RHo/100)*Psat_air));

% Inlet molar fractions of components in inlet gas streams
%=========================================================

% Anode
XWaI = (RHah/100)*Psatah1/Pa;
XH=1-XWaI;

% Cathode
XWcI = (RHch/100)*Psatch1/Pc;
XOcI = (1 - XWcI)*XON;

%Activity of water vapour
a=(XWaI*Pa)/Psatah1;

%Water content of the membrane, Nafion 117 (OLD!)
%------------------------------------------------
if (a>1)
   lambda=14+1.4*(a-1);
elseif ((a>0) & (a<=1))
    lambda=0.043+17.81*a-39.85*a^2+36*a^3;
end

% Membrane resistance [Ohm*cm2]
%==============================
sigma=(0.005139*lambda-0.00326)*exp(1268*((1/303)-(1/(273+Tcell))));
%Rm1=1.\sigma;
Rm1=1/sigma;
Rm=Rm1*tm;

%Cathode overpotential
%-------------
Po=(XOcI/(1-XWcI))*Pc;

%Anode partial pressure
%------------------
Ph=(XH*Pa);

if Ph>=1
    Ph=0.9;
end

%Cell potential
%---------------
Voc=1.08559+((R2*(Tcell+273))/F)*log(Ph/Po);
if Voc>1.1
    Voc=1.08559;
end

Vcell=Voc-(R2*(Tcell+273))/(0.5*F)*log(icell/(jo*Po))-Rm*icell;
Ecell=Voc;
eta_act=(R2*(Tcell+273))/(0.5*F)*log(icell/(jo*Po));
eta_ohm=Rm*icell;


% Fuel cell power output, [W/cm2]
%----------------------------
Pcell=Vcell*icell;

% Heat of reaction [J/mol] 
%------------------------
Tref=25;
Hr = -241.83E3 -9.93*(Tcell) + (6.22E-3)/2*(Tcell)^2 +...
  (7.35E-3)/3*(Tcell)^3 - (3.38E-9)/4*(Tcell)^4;
eta_fc=(-2*F*Vcell)/Hr;

% System
%---------

%t=[];
%[t,x,y]=sim('FCSystem_H2_060602');
%eff(:,2)
%Stack_plot(1);


%Output
%------

u=[icell Vcell Ecell eta_ohm eta_act Tcell p moist Pcell eta_fc];
