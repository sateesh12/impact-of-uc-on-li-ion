
%------------------------------------------------------------------------------
% M-file: fc_compressor.m      
% NOTE: A compresssor data map for a specific compressor needs to be initiated
%
% Created: 03/21/02 by Kristina Haraldsson, NREL
%-----------------------------------------------------------------------------

function f=fc_compressor(u,Pamb,Tamb,Pc,eta1,etagen,RHo,Phum,Tevap,Tcell,Pel)

%Input vector
%------------
NinAir=u(1);                  %Molar flow air [mol/s]
p12=u(2);                     %Discharge pressure [bar(a)]
Wk=u(3);                      %Power demand [W]
T2=u(4);                       %Discharge temperature [C]
T12=T2+273.15;

%Calculations
%--------------
pfilter=0.01;                 %Pressure loss over filter [bar]
pstack=0.1;                   %Pressure loss in stack, cathode side [bar]
px=Pamb-pfilter;              %Pressure into system, into compressor [bar]

mdot12=(NinAir*28.97);               %Mass air flow [g/s]
T1=Tamb+273.15;                     %ambient temperature [K]

%Components (basis: 1 kg air)
%===============================
%Absolute humidity in the inlet air
%-----------------------------------
Psat_air=exp(11.78*((Tamb-99.64)/(Tamb+230)));             %[bar]
Xo=((18.01/28.97)*(RHo/100)*Psat_air)/(Pamb-((RHo/100)*Psat_air)); %[kg H20/kg dry air] alt.[g H2O/g da]

%NOTE: adjustments for humidity in the air should be made!

%New value of NinAir, amount of dry air
%--------------------------------------
NinAir1=(1-Xo)*NinAir;

%Specific heat Air [J/mol,K]
%---------------------------
ka=k(T1);                            % T1 in [K]
y=(ka-1)/ka;

if p12>Pc
   ratio=p12;
elseif p12<Pc
   ratio=p12;
end;

%Output vector with calculated data
%===================================
clear u
u=[NinAir T12 mdot12 Wk p12 NinAir1 ratio];
f=u;
%=============End fc_compressor.m===============================================
% Revision history
%-----------------
% Modified: 082602 KH: changed name of file, removed h and s