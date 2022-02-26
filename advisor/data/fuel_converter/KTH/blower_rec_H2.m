%--------------------------------------------------------------
%
% M-file: blower_rec_H2.m   (blower for the re-circulation of hydrogen)
% Created: 06/12/99 by Kristina Haraldsson
%
% Revision history:
% Modified:    02/04/00
%              06/16/00
%			   15/11/00
%---------------------------------------------------------------
function f=blower_rec_H2(u,etablow,Tcell,dpipe,Lpipe,pblow,g,MH)

%Note
%----
%The two flows of hydrogen and water are assumed to be separated after the purge
%This function deals with hydrogen only, see pump1.m for water

p_61=u(1);               % anode pressure [bar]
m_W_re=u(2);
NoutW_re=u(3);
m_Wl_re=u(4);
NoutWl_re=u(5);
m_Wg_re=u(6);
NoutH_re=u(8);

m_H_re=MH*NoutH_re;

% Assume e is zero, that is, a very smooth pipe material
%------------------------------------------------------
deltaz=0.165;                     %assumed height difference inlet to outlet of pump
p_70=p_61+pblow;
A=pi*dpipe^2/4;
Tcell1=Tcell+273.15;                          %[K]
raH=dens_H(p_70,Tcell1);                %[kg/m3]

myH=my_H(Tcell1);                             %[Ns/m2]

V=m_H_re/(A*raH*1000);                          %[m/s]
Re=(raH*V*dpipe)/myH;

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
hf_bend=0.8;                                     %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
wcv=(pblow*10^5)/(raH*1000)+g*deltaz+sum_hf*V^2;
Pfan=(wcv*m_H_re)/etablow;                       %Power to the blower

%Output vector
%-------------
clear u
u=[m_W_re NoutH_re p_70 Pfan p_61];
f=u;

%---------------end blower_rec_H2.m-------------------------------------------