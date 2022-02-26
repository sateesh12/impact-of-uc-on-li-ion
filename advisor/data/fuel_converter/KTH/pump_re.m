%-------------------------------------------------------------------------------------------------
%
% M-file: pump_re.m     (pump for the re-circulation of water)
% Revision history
% Created: 000616 by Kristina Johansson
% Modified: 001115
%---------------------------------------------------------------------------------------------------
function f=pump_re(u,Tcond,g,dpipe,Lpipe,etapump)

%Note: 
%-----
%The amount of gaseous water is much smaller than the amount of liquid water, thus this amount is assumed ...
%to be pumped along with the liquid water

%Input vector
%------------                  
p_61=u(1);                              %pressure at anode, [bar]
m_W_re=u(2);                            %total amount of water [g/s]
NoutW_re=u(3);                          %total amount of water [mol/s]
m_Wl_re=u(4); 
NoutWl_re=u(5);
m_Wg_re=u(6);
NoutWg_re=u(7);

deltap_pump=0.4;                       %pressure difference inlet to outlet of pump
deltaz=0.165;                          %assumed height difference inlet to outlet of pump

% Assume e is zero, that is, a very smooth pipe material
%------------------------------------------------------
A=pi*dpipe^2/4;
raW=dens_W(Tcond);
myW=my(Tcond);
V=m_W_re/(A*raW*1000);
Re=(raW*V*dpipe)/myW;

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
hf_bend=0.8;                           %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;

wcv=(deltap_pump*10^5)/raW+g*deltaz+sum_hf*V^2;
Ppump1=(wcv*m_W_re)/etapump;
p_81=p_61+deltap_pump;

%Output vector
%-------------
clear u
u=[Ppump1 m_W_re m_Wl_re m_Wg_re p_81];
f=u;
%----------------end pump1.m-------------------------------------------