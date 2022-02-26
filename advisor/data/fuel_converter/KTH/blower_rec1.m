%--------------------------------------------------------------
%
% M-file: blower_rec.m   (fan for the anode outlet)
% Created: 991206 by Kristina Johansson
% Modified:000204
%---------------------------------------------------------------
function f=blower_rec1(u,etablow,Tcell,dpipe,Lpipe,pblow,g)

p_61=u(1);
NoutWa=u(4); %after venting
NoutHa=u(5); %after venting
mW_out=u(7);

mdota=2.01*NoutHa;

% Assume e is zero, that is, a very smooth pipe material
%------------------------------------------------------
deltaz=0.165;  %height difference inlet to outlet of pump
p_70=p_61+pblow;
A=pi*dpipe^2/4;
Tcell1=Tcell+273.15; %[K]
raH=dens_H(p_70,Tcell1); %[kg/m3]
%raW=dens_W(Tcell); %[kg/m3]
%ra=((raH+raW)*1000)/2; %[g/m3]
myH=my_H(Tcell1); %[Ns/m2]
%myW=my(Tcell); %[Ns/m2]
%my1=(myH+myW)/2;
V=mdota/(A*raH*1000);%[m/s]
Re=(raH*V*dpipe)/myH;
f_B=(1/(-1.8*log10(6.9/Re)))^2;
fi_B=1/8*f_B;
Cc=0.67;
hf_in=(1/Cc-1)^2;
hf_pipe=8*fi_B*(Lpipe/dpipe);
hf_out=1;
hf_bend=0.8;   %90 degree soft bend
sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
wcv=(pblow*10^5)/(raH*1000)+g*deltaz+sum_hf*V^2;
Pfan=(wcv*mdota)/etablow;%Power to the fan

%Output vector
%-------------
clear u
u=[mW_out NoutHa Pfan p_70 p_61];
f=u;
%----------------end pump.m-------------------------------------------