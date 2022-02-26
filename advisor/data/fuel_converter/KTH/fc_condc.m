%-----------------------------------------------------------------------------------
%
% M-file: fc_condc.m
%
% Kristina Haraldsson, NREL
% Date: 082902
%-----------------------------------------------------------------------------------

function f=fc_condc(u,Tamb,Tcond,Tch,Tcell)

p_60=u(1);                                      %Ptot [bar]
NoutWcg=u(2);
NoutWlgen=u(3);
NoutWcl=u(4);
NoutO=u(5);
NoutN=u(6);
NWcondc=u(7);
T_sat=u(8);

% Mass flow of ambient air for cooling
%------------------------------------
T1=Tamb+273.15;
y=CpAir(Tamb);

NoutW=NoutWcg+NoutWcl;                         %Total amount of water out from the cathode
xtot=NoutW+NoutO+NoutN;
x_W=NoutW/xtot;
x_N=NoutN/xtot;
x_O=NoutO/xtot;

Psat=(100*exp(11.78*((Tcond-99.64)/(Tcond+230)))/100);
xcond=Psat*(x_W+x_N+x_O)/(1-(Psat/p_60));

%T_sat=Tsat(Pc)
deltaT=(Tcell-Tcond);
T_air_in=Tamb;
T_air_out=Tamb+deltaT;
Tln=(T_air_out-T_air_in)/log((T_sat-T_air_in)/(T_sat-T_air_out));


%Amount of water vapor that may condense 
%-------------------------------------------
mcond1=xcond*NoutWcg*18.01;                            %[g/s]
Ncond1=xcond*NoutWcg;                                  %[mol/s]

%Total amount of water out from cathode condenser
%------------------------------------------------
mW_out=NoutWcl*18.01+mcond1;                          %[g/s]
NW_out=NoutWcl+Ncond1;                                 %[mol/s]

% Heat of evaporation
%--------------------
lambda1=Wheat(Tcell);                                  %[kJ/kg] alt. [J/g]
lambda2=Wheat(Tcond);
lambda=(lambda1+lambda2)/2;
Qcond=mcond1*lambda;                                     %[J/s] 

%Tm=((Tcell+Tcond)/2)+273.15;
Tm=((Tcell+Tcond)/2);
y2=CpAir(Tm);                                            %[J/mol,C]
y3=CpWl(Tm);                                             %[J/mol,C]

%m2=28.97*(NoutO+NoutN)+18.01*NoutW;
%m3=28.97*(NoutO+NoutN)+mW_out;
N2=NoutO+NoutN+NoutW;
N3=NoutO+NoutN+NW_out;
N=(N2+N3)/2;                                            %Average flow [mol/s]

%Percentage of condensation
%-------------------------
diff=(abs((N2-N3)/N2))*100;

Qkyl=N*((y2+y3)/2)*(Tcell-Tamb);

Qtotcond=Qkyl+Qcond;

%Required air flow to condense the water
%----------------------------------------------
mdotA=Qcond/(y*28.97*Tcond); %[g/s]

Tamb1=Tamb+273.15;

Acond=0; % To be further developed

%Output vector
%-------------
clear u
u=[Qkyl mdotA x_W mW_out Qcond Qtotcond xcond];
f=u;