%-----------------------------------------------------------------------------
%
% M-file: fc_coolstack.m
%
% Kristina Haraldsson, NREL
% Date: 082902
%-----------------------------------------------------------------------------
function f=fc_coolstack(u,Tcool,Tamb,Tcell)

T_in=30;

% Input vector
%--------------
Heat=u(1);                         % Heat developed in stack [W]

Q=Heat/(1000);                       % Heat developed in stack [kW]

T11=(Tcell-Tcool)+273.15;              %[K]
T22=Tcell+273.15;                      %[K]

% Mass flow of cooling medium WATER
%====================================
CpW1=cp_H2Ol(T11);                          %[kJ/kg,K]
CpW2=cp_H2Ol(T22);                          %[kJ/kg,K]
CpW=(CpW1+CpW2)/2;

m_W=Heat/(Tcool*CpW*1000);                 %[g/s]

T_out=T_in+273.15+Heat/(m_W*CpW*1000); %[K]

% Mass flow of cooling medium AIR
%==================================
%Ambient air is used for cooling the fuel cell stack
%----------------------------------------------------
T1=Tamb+273.15;

CpA1=cp_air(T1);                         %[kJ/kg,K]
CpA2=cp_air(T22);
CpA=(CpA1+CpA2)/2;

m_A1=Q/(Tcool*CpA);              %[kg/s] 
m_A=m_A1*1000;                              %[g/s] 

%Output vector with calculated data
%----------------------------------
clear u
u=[m_W m_A T_out Heat];
f=u;
%=============End fc_coolstack.m===============================================
