%---------------------------------------------------------------------------------------
% 
% M-file: fc_evapcool.m
% Evaporative cooler; humidifies air and H2, cools air
% 
% Kristina Haraldsson, NREL
% Date: 082602
%--------------------------------------------------------------------------------------
function f=fc_evapcool(u,Tcell,Tevap,Phum,Thyd,RHah,RHch,Pan,Tcond)

Thyd=u(1);           % Temperature of hydrogen out from the tank [C]
pblower=u(2);
NinHa=u(3);      

mW_outa=u(4);  %%total amount of water out from anode condenser flow [g/s]
%p_81=u(6); ?
mW_outc=u(5);     %total amount of water out from cathode condenser flow [g/s]
Pc=u(6);
Pa=u(7);

NinAir=u(8);
T12=u(9);       %entering temperature from the compressor [K]
mdot12=u(10);    % mass flow of air [g/s]
Wk=u(11);
p12=u(12);
NinAir1=u(13);       %dry air 
ratio=u(14);

Psat=u(15); 
Psatah=u(16);
Psatch=u(17);
XWaI=u(18);
XWcI=u(19);
XOcI=u(20);

Xo=0.7;

%Calculations
%============
Tcell1=Tcell+273.15;
Tcond1=Tcond+273.15;

%Cathode flow
%============
%If the temperature out from the compressor is too low, lower than Tcell
%---------------------------------------------------------------------------
if (T12<=Tcell1)
   Q_avail=mW_outc/18.01*ent_Wl(Tcond);
   Q_nec=mW_outc/18.01*ent_Wl(Tcell);
   Q_demand=Q_nec-Q_avail;
   %This heat is to be transferred to the cathode flow in a heat exchanger before the humidifier
else
   Q_demand=0;
end;

%Cathode humidifier 
%==================
m_1=NinAir1*28.97;				%mass flow of dry air [g/s]

w1=Xo;
w2=(18.01/28.97)*((0.01*RHch*Psatch)/(p12-0.01*RHch*Psatch));              %[bar], changed 000619

%The amount of water to be added to air flow
%--------------------------------------------
h1=h_air(T12)*28.97; %[J/mol] 082602
m_w_1=m_1*(w2-w1);          %[g/s]
N_w_1=m_w_1/18.01;         %[mol/s] 
hg1=ent_Wg(T12-273.15);

m_2=m_1+m_w_1;              %[g/s]
N_2=NinAir1+N_w_1;         %[mol/s]
hw_1=ent_Wl(Tcond);         %[J/mol]

h_O2=ent_O2(Tcell);          %[J/mol]
h_N2=ent_N2(Tcell);
h_Wg=ent_Wg(Tcell);
h_da_2=0.21*h_O2+0.79*h_N2;

h_v_2=w2*h_Wg;


%Enthalpy of air outlet, cathode flow
%------------------------------------
p_56=p12-Phum;   %Pressure cathode

%Anode humdifier
%==============
%Mixing point
%------------
w3=0;                                   % Assumption: no water in anode flow before humidification
m_3=(NinHa)*2.0158;                     % Mass flow of hydrogen at the mixing point before humidification
Thyd=Tcell;                             % Note: Thyd is temporarily set to Tcell
T_mix=(Thyd+Tcond)/2;        
h3=ent_H2(T_mix);                       % Enthalpy at mixing point

w4=(18.01/2.01)*((0.01*RHah*Psatah)/(pblower-0.01*RHah*Psatah));  %[bar]

%The amount of water to be added to hydrogen flow
%------------------------------------------------
m_w_2=m_3*(w4-w3);           %[g/s]
N_w_2=m_w_2/18.01;          %[mol/s]

m_4=m_3+m_w_2;                %[g/s]
N_4=NinHa+N_w_2;            %[mol/s]
hw_2=hw_1;

h4=(N_w_2*hw_2+NinHa*h3)/N_4;           % Enthalpy of outgoing anode flow, [J/mol]

%EB
Ttank=40;
hw2=(((m_3/2.0158)*h4+(m_w_2/18.01))*(hw_2))-((m_3/2.0158)*h3)/(m_w_2/18.01);
Qtank2=m_w_2*(abs(hw2)-4.19*1000*Ttank);

Tref=0;
a=28.84;
b=0.00765*10^-2;
c=0.3288*10^-5;
d=-0.8698*10^-9;
CpH=a*(T12-Tref)+b/2*(T12-Tref)^2+c/3*(T12-Tref)^3+d/4*(T12-Tref)^4 ;

hfg2=(CpH*(T_mix-Tcell)+cp_H2Og(T_mix+273.15)*(T_mix-Tcell))/(w4-w3);
Qt2=(abs(hfg2)-cp_H2Ol(T_mix+273.15)*1000);

p_57=pblower-Phum;                  % Pressure anode

%Total amount of water to be added to both flows
%-----------------------------------------------
w=m_w_1+m_w_2;                      % Total amount of water to be added [g/s]
diffc=mW_outc-m_w_1;                % Difference between water from cathode cond. and water needed for hum. [g/s]
diffa=mW_outa-m_w_2;                % Difference between water from anode cond. and water needed for hum.  [g/s]

diff=w-(mW_outa+mW_outc);           % Difference between water from cathode condensation and total water...
%to be added in evap-cooler, to be supplied with a water acc. tank [g/s]

%Heat, cathode
%---------------------
Tmix1=(Tcond+Ttank)/2;
cv=cp_H2Ol(Tmix1+273.15);             %[J/g,C]
z1=T12-Tcell+273.15;

Qwc=abs(diffc)*cv*z1;   %[J]

%Heat, anode
%---------------------
T_mix=(Thyd+Tcond)/2; 
z2=Tcell-T_mix;
Qwa=abs(diffa)*cv*(z2+273.15); %[J]

Qwtot=Qwa+Qwc;

h_air_2=h_da_2+h_v_2+hw_1;   

diffw=diffa+diffc;                  %The water to be collected after evap. cooler and be recirculated  [g/s]

if (diffw>0)
   rec=diffw;
else rec=0;
end;

Qevapc=NinAir*(h_air_2-h1);         % Cooling of cathode flow [W], added 000620
Qevapa=NinHa*(h4-h3);               % Cooling of anode flow l[W], added 000620

%Output vector
%--------------
clear u
u=[p_56 NinHa p_57 NinAir Psat Psatah Psatch XWaI XWcI XOcI diffc...
      diffa diffw w diff rec Qwc Qwa Qwtot m_w_1 m_w_2 Qevapc Qevapa Q_demand NinAir1];
f=u;