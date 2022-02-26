%-----------------------------------------------------------------------
%
% M-file: fan_cool.m
%
% Revision history:
% Created: 000815 by Kristina Johansson
% Last modified: 
%------------------------------------------------------------------------
function f=fan_cool(u,Tcool,Tcell,g,dpipefc,Lpipefc,etablow,Pamb,pblow)

%Input vector
%------------
m_A=u(2);                        %[g/s]
%T1=u(3);                          

Twcoolin=(Tcell-Tcool)+273.15;               %Temperature of cooling medium in, [C]  
Twcoolout=Twcoolin+Tcool;          % Temperature of cooling medium out, [C],Tcool is the temp. difference across ....
%the fuel cell stack

pfilter=0.01;       %Pressure loss over filter [bar]

% Assume e is zero (a very smooth pipe material)
%===============================================
deltaz=0;  %height difference inlet to outlet of blower
p2=Pamb+pblow+pfilter;

A=pi*dpipefc^2/4;
raA=dens_A(p2,Twcoolin); %[kg/m3] [K]
ra=raA*1000; %[g/m3]
myA=my_A(Twcoolin); %[Ns/m2] [K]
V=m_A/(A*ra);%[m/s]
Re=(ra*V*dpipefc)/myA;

if Re<2000
   fi_B=64/Re;
else
   f_B=(1/(-1.8*log10(6.9/Re)))^2;
   fi_B=1/8*f_B;
end;

Cc=0.67;
hf_in=(1/Cc-1)^2;
hf_pipe=8*fi_B*(Lpipefc/dpipefc);
hf_out=1;
hf_bend=0.8;   %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;

delta_p=fi_B*4*(Lpipefc/dpipefc)*ra*V^2;  %[Pa]
%wcv=(pblow*10^5)/ra+g*deltaz+sum_hf*V^2;
wcv=delta_p/ra+g*deltaz+sum_hf*V^2;
%P_fancool=(wcv*m_A)/etablow                      %Power to the fan, changed temperararily 001030
P_fancool=0; 

%Output vector
%-------------
clear u
u=[m_A P_fancool p2 Twcoolout];
f=u;
%----------------end fan_cool.m-------------------------------------------