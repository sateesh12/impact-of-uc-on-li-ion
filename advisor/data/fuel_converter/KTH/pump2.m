%-----------------------------------------------------------
%
% M-file: pump2.m
% Created: 000207 by Kristina Johansson
% Last modified: 001115
%------------------------------------------------------------
function f=pump2(u,Tcond,g,dpipe,Lpipe,etapump)

mW_out=u(1); %[g/s]

%Cathode

deltap_pump=0.4;  %pressure difference inlet to outlet of pump
deltaz=0.165;  %height difference inlet to outlet of pump

% Assume e is zero, that is, a very smooth pipe material
%------------------------------------------------------
A=pi*dpipe^2/4;
raW=dens_W(Tcond);
myW=my(Tcond);
V=mW_out/(A*raW*1000);
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
hf_bend=0.8;   %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
wcv=(deltap_pump*10^5)/raW+g*deltaz+sum_hf*V^2;
Ppump2=(wcv*mW_out)/etapump;
%p_81=p_61+deltap_pump

%Output vector
%-------------
clear u
u=[mW_out Ppump2];
f=u;
%----------------end pump.m-------------------------------------------