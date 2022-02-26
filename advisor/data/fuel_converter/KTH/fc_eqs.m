%----------------------------------------------------------------------
%
% M-file: fc_eqs.m (gas flows in anode and cathode)
%
% Kristina Haraldsson, NREL
% Date: 082602             
%----------------------------------------------------------------------

function f=fc_eqs(u, A, Pa, Pc, Pamb, RHo, F, Tcell, Tah, Tch, Tamb, Mm, pdry, tm, vO, vH, zw, Pel,N) 

% Input vector
%--------------
p_56=u(1);                                        % Cathode pressure in [bar]
NinH=u(2);                                        % Anode flow
p_57=u(3);                                        % Anode pressure in [bar]

NinAir=u(4);                                      % Cathode flow [mol/s]
Psat=u(5);                                        % Saturation pressure of water in fuel cell
Psatah=u(6);
Psatch=u(7);
XWaI=u(8);                                         % Inlet water fraction anode
XWcI=u(9);                                         % Inlet water fraction cathode
XOcI=u(10);                                        % Inlet oxygen fraction cathode
NinO=u(11);
NinN=u(12);
lambda=u(13);
J=u(14);                                           % Flux of water produced at cathode

% Hydrogen and nitrogen fractions
%---------------------------------
XHaI=1-XWaI;
XNcI=1-XWcI-XOcI;

%Water content at the cathode/membrane interface
%-----------------------------------------------
L3=14;
Lm=(lambda+L3)/2;                                   % Water content membrane, assuming linear water profile
ndrag=(2.5*Lm)/22;                                  % Electro-osmotic drag coefficient

Ndrag=ndrag*2*J;

%Diffusion coefficient of water in membrane
%------------------------------------------
Dm = (2.6693 - 0.38*lambda + 0.0306*lambda^2 - 0.000748*lambda^3)*1E-6*exp(2416*(1/303-1/(273.15+Tcell)));
Ndiff=pdry*Dm/Mm*(L3-lambda)/tm;                    % Diffusion flux through membrane, from cathode to anode

%Water flux through membrane
%----------------------------
NWm=(Ndrag-Ndiff)*A;                                %[mol/s], not flux [mol/(cm2*s)]from anode to cathode

% Inlet and exit flows at the cathode
%====================================
NinWc=NinAir*XWcI;                                  % water into cathode
NoutO=(1-(1/vO))*NinO;
NoutN=NinN;

% Inlet and exit flows at the anode
%==================================
NinWa=NinH*XWaI;
NinHa=NinH*XHaI;                                 
NoutHa=(1-(1/vH))*NinHa;

%Generation of liquid water at the cathode (assumption: all water produced in liquid form)
%-----------------------------------------------------------------------------------------
NWlgen=(NinHa-NoutHa);
real_alfa=NWm/NWlgen;       

% Saturation pressure and water percentage out
%-----------------------------------------------   
RH_out=100;

% Pressure
%==========
%Cathode outlet pressure [bar]
%------------------------------
p_60=p_56-0.1;                                      % Assume: pressure drop across stack of 0.1 bar

% Anode outlet pressure [bar]
%-----------------------------
p_61=p_57-0.01;                                     % Assume: pressure drop of 0.01 bar

Psatcell=exp(11.78*((Tcell-99.64)/(Tcell+230)));    %[bar]
XW_outc=(RH_out/100)*Psatcell/(p_60);               % Assumption: saturation at cathode outlet
XW_outa =(RH_out/100)*Psatcell/(p_61);              % Assumption: saturation at anode outlet
XO_outc=(1 - XW_outc)*0.21;

% Amount of water in outlet flows
%====================================
%Cathode
%-------
NoutWcg=(NoutO+NoutN)*XW_outc;					      % Amount of gaseous water out from the cathode
NoutWcl=zw*NWlgen;                                    % Amount of produced water out from the cathode                      
Nout_condc1=(NinWc+NoutWcl)-NoutWcg;							
Nout_condc=NinWc-NoutWcl-NoutWcg;		
if Nout_condc<=0 
    Nout_condc=0;
end;

%Anode
%-----
NoutWag=NoutHa*XW_outa;
NoutWal=(1-zw)*NWlgen;                     
Nout_conda=NinWa-NoutWal-NoutWag; 

%Total amount of water out from cathode and anode
%-------------------------------------------------
NWCout=NoutWcg+NoutWcl;
NWAout=NoutWag+NoutWal;
NWcond=Nout_condc+Nout_conda;

%Output vector
%-------------
clear u

u=[p_60 p_61 NinWa NinHa NoutWag NoutHa NinWc NinO NinN NoutWcg NWlgen NoutWcl NoutO NoutN NWCout...
        NWAout NoutWal real_alfa Nout_condc Nout_conda];
f = u;

%------------------------------------------------------------------------------------
% Revision history
% 082802 KH: replaced L2 with lambda in the calculation of Lm, Dm and Ndiff