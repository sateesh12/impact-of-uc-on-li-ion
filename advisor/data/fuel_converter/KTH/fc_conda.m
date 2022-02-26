%-----------------------------------------------------
%
% M-file: fc_conda.m
% Kristina Haraldsson, NREL
%------------------------------------------------------
function f=fc_conda(u,ex,Tamb,Tcond,Tcell)

p_61=u(1);
NoutWag=u(2);                            %Amount of water(g)
NoutHa=u(3);                             %Total amount of hydrogen out from the anode [mol/s]
NWAout=u(4);                             %Total amount of water out from the anode [mol/s]
NoutWal=u(5);                            %Amount of water(l)

%Condenser
%---------
% Mass flow of ambient air for cooling
%------------------------------------
T1=Tamb+273.15;
Tref=0+273.15;
y=CpAir(Tamb);                          %[J/mol,C]

xtot=NoutWag+NoutWal+NoutHa;  			 %Changes 000616: NoutWag instead of NoutWg=(1-ex)*NoutWag
                                        %Changes 000616: NoutWal instead of NoutWl=(1-ex)*NoutWal
                                        %Changes 000616: NoutHa instead of NoutHaV
                                        
x=NoutWag;                                    
x_W=(NoutWag+NoutWal)/xtot;             %Changes 000616: earlier: x_W=NoutWaV/xtot;
x_H=NoutHa/xtot;                        %Changes 000616: earlier: x_H=NoutHaV/xtot;

Psat=exp(11.78*((Tcond-99.64)/(Tcond+230)));  %[bar]
xcond=Psat*(x_W+x_H)/(1-(Psat/p_61));    %Maximum amount of steam before condensing

%Amount of water vapor that may condense 
%-------------------------------------------
mcond=xcond*NoutWag*18.01;                    %[g/s]
Ncond=xcond*NoutWag;                          %[mol/s]

%Total amount of water out
%-----------------------------
m_Wl=NoutWal*18.01+mcond;                   %[g/s] in liquid form
N_Wl=NoutWal+Ncond;

m_Wg=NoutWag*18.01-mcond;                   %[g/s] in gaseous form
N_Wg=NoutWag-Ncond;

% Heat of evaporation
%--------------------
lambda1=Wheat(Tcell);                        %[kJ/kg] alt. [J/g]
lambda2=Wheat(Tcond);
lambda=(lambda1+lambda2)/2;
Qcond=mcond*lambda;                          %[J/s] 

%Tm=((Tcell+Tcond)/2)+273.15;
Tm=((Tcell+Tcond)/2);
y2=CpAir(Tm);                               %[J/mol,C]
y3=CpWl(Tm);                                %[J/mol,C]

%m2=28.97*(NoutHa)+18.01*(NoutWag+NoutWal);
N2=NoutHa+NoutWag+NoutWal;
%m3=28.97*(NoutHa)+m_Wl;
N3=NoutHa+N_Wl;
N=(N2+N3)/2;                                    %Average molar flow [mol/s]

%Percentage of condensation
%-------------------------
diff=(abs((N2-N3)/N2))*100;

Qkyl=N*((y2+y3)/2)*(Tcell-Tamb);

Qtotcond=Qkyl+Qcond;

%Required air flow to condense the water
%----------------------------------------------
m_A=Qcond/(y*28.97*Tcond);                          %[g/s]

%Output vector
%-----------
clear u
u=[p_61 NoutHa m_Wl m_Wg m_A Qtotcond];
f=u;