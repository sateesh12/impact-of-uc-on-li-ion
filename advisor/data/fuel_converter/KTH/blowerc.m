%-----------------------------------------------------------------------
%
% M-file: blowerc.m
% Created: 000121  by Kristina Johansson
% Last modified: 000121, 001115
%------------------------------------------------------------------------
function f=blowerc(u,etablow,Pamb,Tamb,dpipe,Lpipe,pblow,g,Phum,RHo)

%Input vector
%------------
NinAir=u(1);         %Molar flow air [mol/s]
pfilter=0.01;       %Pressure loss over filter [bar]
pstack=0.1;         %Pressure loss in stack, cathode side [bar]
p=Pamb+pfilter+Phum+pstack;
p1=p-pfilter;        %Required pressure into system, into blower 

%Absolute humidity in the inlet air
%-----------------------------------
Psat_air=(100*exp(11.78*((Tamb-99.64)/(Tamb+230))))/100;%[bar]
Xo=(0.622*(RHo/100)*Psat_air)/(Pamb-((RHo/100)*Psat_air)); %[kg H20/kg dry air]

%New value of NinAir, amount of dry air
%--------------------------------------
NinAir1=NinAir-Xo*NinAir;         %[mol/s]
mdota=NinAir*((28.97+18.01)/2);  %[g/s]

% Assume e is zero, that is, a very smooth pipe material
%------------------------------------------------------
deltaz=0.165;  %height difference inlet to outlet of pump
p2=p1+pblow;
A=pi*dpipe^2/4;
Tamb1=Tamb+273.15; %[K]
raA=dens_A(p2,Tamb); %[kg/m3]
raW=dens_W(Tamb); %[kg/m3]
ra=((raA+raW)*1000)/2; %[g/m3]
myA=my_A(Tamb1); %[Ns/m2]
myW=my(Tamb); %[Ns/m2]
my1=(myA+myW)/2;
V=mdota/(A*ra);%[m/s]
Re=(ra*V*dpipe)/my1;

if Re<2000
   fi_B=64/Re;
else
   f_B=(1/(-1.8*log10(6.9/Re)))^2;
   fi_B=1/8*f_B;
end;

Cc=0.67;
hf_in=(1/Cc-1)^2;
hf_pipe=8*fi_B*(Lpipe/dpipe);
hf_out=1;
hf_bend=0.8;   %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
wcv=(pblow*10^5)/ra+g*deltaz+sum_hf*V^2;
Pfan=(wcv*mdota)/etablow;%Power to the fan

%Output vector
%-------------
clear u
u=[NinAir Pfan p2];
f=u;
%----------------end blowerc.m-------------------------------------------