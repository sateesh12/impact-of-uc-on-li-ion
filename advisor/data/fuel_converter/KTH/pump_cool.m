%-----------------------------------------------------------
%
% M-file: pump_cool.m
% Revision history: 
% Created: 1998 by Kristina Johansson
% Modified: 991206 
%           000512
%           000815
%------------------------------------------------------------
function f=pump_cool(u,Tcool,g,dpipefc,Lpipefc,etapump,Tcell,Lpipe,dpipe,N)

m_W=u(1);                        %[g/s]

Heat=u(4);                       %[W]


Twcoolin=Tcell-Tcool;              %Earlier 50 C
Twcoolout=Twcoolin+Tcool;          % [C],Tcool is the temp. difference across ....
                                   %the fuel cell stack
%deltap_pump=0.4;                   %pressure difference inlet to outlet of pump,...
                                   %including the pressure drop of the filter
deltaz=0.4;                          %Assumed height difference inlet to outlet of pump

% Assume e is zero (a very smooth pipe material)
%===============================================
A=pi*dpipe^2/4;
raW=dens_W(Twcoolin);              %density at [C], [kg/m3]
%raW=raW1*1000
myW=my(Twcoolin);                    %viscosity at [C], [Ns/m2]
V=m_W/(A*raW);                        %000512, units OK
Re=(raW*V*dpipe)/myW;              %000512, units OK

if Re<2000
   fi_B=64/Re;
else
   f_B=(1/(-1.8*log10(6.9/Re)))^2;
   fi_B=1/8*f_B;
end;

Cc=0.67;
hf_in=(1/Cc-1)^2;
hf_pipe=8*fi_B*(Lpipe/dpipe);
hf_fc=8*fi_B*(Lpipefc/dpipefc); %introduced 010123
hf_out=1;
hf_bend=0.8;                       %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_fc+hf_out+hf_bend;

%Pressure drop
%---------------
% Fuel cell
%-----------
delta_p=N*fi_B*4*(Lpipefc/dpipefc)*raW*V^2+ fi_B*4*(Lpipe/dpipe)*raW*V^2;%[Pa]
dp=(2.013-0.1)*10^5;
wcv=dp/raW+g*deltaz+sum_hf*V^2;
Ppump=(wcv*m_W)/etapump;

%Energy balance
%--------------
p_in=1.013;                             %[bar]
p_out=(p_in-0.1);                     %[bar]
h_w_in=h_H2OlsatII(p_in);
h_w_out=h_H2OlsatII(p_out);
dh=h_w_in-h_w_out;
h_w_out1=(Ppump/m_W+h_w_in)/1000;

%Output vector
%-------------
clear u
u=[m_W Re Ppump Twcoolin Twcoolout Heat];
f=u;
%----------------end pump_cool.m-------------------------------------------