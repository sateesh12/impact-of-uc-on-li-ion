%-----------------------------------------------------------------
%
% M-file: radiator.m   counter-current heat exchanger
% 
% Kristina Haraldsson, NREL
%-----------------------------------------------------------------
function f=radiator(u,Tamb,Trad,U,Tcool,kw,dpipe,Lpipe,etablow,Tcell,g,drad,Lrad,Nrad)

m_W=u(1);                             % cooling water mass flow [g/s]
Re=u(2);
Ppump=u(3);
Twcoolout=u(5);                  
Heat=u(6);                            %[W]


%Temperature definitions [C]
%-----------------------
T1=Tamb;                             %radiator cooling air, ambient temperature       
T2=Trad;										  %air temperature out, first set to vehicle coupé temperature
T3=(Twcoolout);                        %hot water in to the radiator
T4=(Tcell-Tcool);                       %cold water out from the radiator

fi_1=T3-T2;
fi_2=T4-T1;
Tln=(fi_1-fi_2)/log((fi_1/fi_2));      % logarithmic mean temperature


%Thermal conductivity of water, 
%data from Hellsten, Gunnar, "Tabeller och diagram",1992, Almqvist & Wiksell 
%------------------------------------------------------
k_water=k_H2Ol(Twcoolout);						%thermal conductivity, [W/(m,K)], T in [C]!


%Thermal conductivity of air at Tamb, Ref. C&R vol. 1
%data from R & C, "Chemical engineering", vol I, 4th ed., 1990, Pergamon Press
%-----------------------------------------------------
ka=k_air(Tamb+273.15);                    %thermal conductivity, [W/(m,K)], T in [K]!

Thin=Twcoolout;  %hot water into the radiator

%Effectiveness
%----------------
e=(Trad-Tamb)/(Thin-Tamb);


cw=cp_H2Ol(Twcoolout+273.15);              %[kJ/kg,K]
myW=my(Twcoolout);                         %viscosity at [C], [Ns/m2]  
Ch=cw*1000*m_W; %[kJ/s]

%--------------------------------------------------------------------------
% Qcool= The amount of heat if the cooling medium is to be cooled to 50 C, 
% i.e. the temperature before entering the fuel cell stack again
%--------------------------------------------------------------------------
Qcool=m_W*cw*(Tcool);

cpA=cp_air(Tamb+273.15);
m_A=Qcool/(cpA*(Trad-Tamb));       % Trad=22 C or something else....

Cc=cpA*1000*m_A;

%Counterflow (both fluids unmixed)
%----------------------------------
if (Ch>=Cc)
   Cmax=Ch;
   Cmin=Cc;
else
   Cmax=Cc;
   Cmin=Ch;
end;

Rc=Cmin/Cmax;

if (Rc>=1)
   Rc=0;
end;

%The water side
%---------------
d=0.005;
raW=dens_W(Thin); %[kg/m3]
myW=my(Thin); %[Ns/m2]
%A=(pi*d^2)/4  %starting value
A=pi*drad*Lrad*Nrad;
V=m_W/(A*raW*1000);%[m/s]
ReW=(raW*V*drad)/myW;
Pr_W=Pr_H2Ol(Thin);

if ((Pr_W>0.7) &(ReW>10000))
   Nu_w=0.023*(ReW)^0.8*(Pr_W)^0.3; % Cooling of water
   alfa_w=(Nu_w*k_water)/drad;
else
   alfa_w=64/ReW;
end;

%The air side
%--------------
p=1;
raA=dens_A(p,(Tamb+273.15)); %[kg/m3]
myA=0.000018; %[Ns/m2] at 15 C
V=m_A/(A*raA*1000);%[m/s]
ReA=(raA*V*drad)/myA;
Pr_A=(cpA*1000*myA)/ka;

if ((Pr_A>0.7) & (ReA>10000))
   Nu_a=0.023*(ReA)^0.8*(Pr_A)^0.4; %Heating of air
   alfa_a=(Nu_a*ka)/drad;
else
   alfa_a=64/ReA;
end;

de=(1/alfa_a)+(drad/kw)+(1/alfa_w);    % Here: kw for aluminium [W/m,K]
u=1/de;
N=(log(1-e*Rc)-log(1-e))/(1-Rc);

%A_rad=(N*Cmin)/u;   %[m2];
A_rad1=Qcool/(u*Tln);
A_rad=2; %[m2]

%Power input to the fan for the radiator, P_fanrad
%--------------------------------------------------
if ReA<2000
   fi_B=64/ReA;
else
   f_B=(1/(-1.8*log10(6.9/ReA)))^2;
   fi_B=1/8*f_B;
end;

Cc=0.67;
hf_in=(1/Cc-1)^2;
hf_pipe=8*fi_B*(Lpipe/dpipe);
hf_out=1;
hf_bend=0.8;   %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
deltaz=0;

m_A_new=(A_rad*u)/(cpA*1000);
dp=(p-0.1)*10^5;
delta_p=fi_B*4*(Lpipe/dpipe)*raA*V^2; %[Pa]
wcv=(delta_p)/raA+g*deltaz+sum_hf*V^2;
P_fanrad=(wcv*m_A_new)/etablow; 
%P_fanrad=0; 

% Output vector
%---------------
clear u

%u=[m_W Ppump A_rad Heat etafc Qcool P_fanrad];
u=[m_W Ppump A_rad Heat Qcool P_fanrad];
f=u;

%-------------------------------------end radiator.m----------------------------------