%-----------------------------------------------------------------------------------
%
% M-file: vent.m
% 
% Revision history:
% Created: 06/16/00 by Kristina Haraldsson
% Modified:
%
%------------------------------------------------------------------------------------
function f=vent(u,ex)

p_61=u(1);                     %Pressure [bar]
NoutHa=u(2);                   %Amount of hydrogen [mole/s]
m_Wl=u(3);                     %Total amount of liquid water out from the anode condenser [g/s]
m_Wg=u(4);                     %Total amount of gaseous water out from the anode condenser [g/s]


%NoutTot=NWAout+NoutHa;

%Recirculation
%-------------
R=1-ex;

m_W_re=R*(m_Wl+m_Wg);  					%Total amount of water to be re-circulated [g/s]	
NoutW_re=m_W_re/18.01;               %Total amount of water to be re-circulated [mole/s]	

m_Wl_re=R*m_Wl;                      %Amount of liquid water to be re-circulated [g/s]
NoutWl_re=m_Wl_re/18.01;
m_Wg_re=R*m_Wg;                         %Amount of gaseous water to be re-circulated [g/s]
NoutWg_re=m_Wg_re/18.01;

NoutH_re=NoutHa*R;                    %Hydrogen to be re-circulated [mol/s]
%----------------------------------------------------------------------------------------

%Purge
%-----
m_W_purge=ex*(m_Wl+m_Wg);           %Assumption:both gaseous and liquid form
NoutH_purge=ex*NoutHa;

%------------------------------------------------------------------------------------------     


%Output vector
%-------------
clear u
u=[p_61 m_W_re NoutW_re m_Wl_re NoutWl_re m_Wg_re NoutWg_re NoutH_re m_W_purge NoutH_purge];
f=u;
