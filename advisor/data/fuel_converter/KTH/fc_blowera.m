%--------------------------------------------------------------
%
% M-file: fc_blowera.m   (fan for the anode outlet)
%
% Created by: Kristina Haraldsson, NREL
%---------------------------------------------------------------
function f=blowera(u,etablow,dpipe,Lpipe,g,Pblow,Pan,Pa,Phum,Tcell)

% Input vector
%--------------
NinHa=u(1);  %Hydrogen from tank

P=Pa;  %Pressure  after tank [bar]
pstack=0.01; %Pressure loss in stack, anode side [bar]
Thyd=Tcell;

% Assume e is zero, that is, a very smooth pipe material
   %------------------------------------------------------
   deltaz=0;  %height difference inlet to outlet of pump
   p=Pa+pstack+Phum;     %Pressure rise after blower 
   
   A=pi*dpipe^2/4;
   T1=Thyd+273.15; %[K]
   raH1=dens_H(p,T1); %[kg/m3] 
   raH=raH1*1000; %[g/m3]
   myH=my_H(T1); %[K]
   
   mdotH=NinHa*2.0158;%[g/s]
   V=mdotH/(A*raH);
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
   hf_bend=0.8;   %90 degree soft bend
   sum_hf=hf_in+hf_pipe+hf_out+hf_bend;
   wcv=((p-P)*10^5)/raH+g*deltaz+sum_hf*V^2;
   Pfan=(wcv*mdotH)/etablow;   %Power to the fan
   
   %Check
   %------
   if Pfan<=0
      Pfan=0;
   end;
   
%end

%Output vector
%-------------
clear u
u=[Thyd p NinHa Pfan];
f=u;
%----------------end fc_blowera.m-------------------------------------------
% Last modified: 
% 110102: KH Clean-up