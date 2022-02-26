%------------------------------------------------------------------------------------
%
% M-file: tank_temp.m
% 
% Revision history:
% Created: 09/21/00 by Kristina Haraldsson
% Modified: 06/28/00
%           03/21/02 
%-----------------------------------------------------------------------------------
function f=tank_temp(u,V,Cv,Pa,MH,R,Tamb,Tcell)

%Input vector
%-----------
mf=u(1);
po=u(2);

%NoutH=u(1);                  %[mole/s] re-circulated molar flow of hydrogen
%NinH=u(3);                    %[mole/s] initial molar flow of hydrogen

% To calculates temperature in pressure tank and temperature of outgoing hydrogen
% from the work performed by expanding gas, "flow work".
%---------------------------------------------------------------------------------
%mf=NinH*MH;       %[g/s] mass flow of hydrogen
po=Pa*100000;	% [Pa] system pressure, earlier 200000 Pa =2 bar
Ta=Tamb+273.15;		% [K] ambient temperature, earlier 293 K

T0=Ta;					% [K]			initial pressure tank temperature
T1=[T0];					% [K]			temperature vector
time0=0;					% [s]			time vector
p0=35000000;			% [Pa]		initial pressure
p1=[p0];					% [Pa]		pressure vector
Q0=0;						% [W]			initial heat transfer to tank
To0=tank_outtemp0(po,mf,time0,T0) 	% [K]	temperature of released gas initially
To1=[To0];				% [K] 		outtemp vector

y2=ent_H2(Tcell);

for t=1 %earlier t=1:1000
   
   time=[time0,t];									% building of time vector
   time0=time;
   
   p2=tank_pressure(T1(t),mf,t,p1(t));				% pressure in tank
   p1=[p0,p2];
   p0=p1;
   
   T2=T1(t)+tank_energybal(mf,t,p1(t),Ta,T1(t));	% temperature in tank
   T1=[T0,T2];
   T0=T1;
   
  %To2=T2+outtemp(po,mf,t,To1(1));				% temperature of extracted gas
      To2=T2+tank_outtemp(po,mf,t,To1(t));	     %changed 06/28/00
   To1=[To0,To2];
   To0=To1;
 
end

%Heat exchanger
%----------------
t1=2;
Tx1=To1(t1);
Tx=abs(Tx1-273.15);
y1=ent_H2(Tx);
Q_hex1=mf*(y2-y1);
p2x=p1(t1)./100000; %[bar]

%t2=4;
%Ty1=To1(t2);
%Ty=abs(Ty1-273.15);
%p2y=p1(t2)./100000; %[bar] 
%y3=ent_H2(Ty);
%Q_hex2=mf*(y2-y3);

%Output vector
%-------------
clear u
%u=[NinH mf p2x T1(t1)Tx Q_hex1];
u=[mf p2x T1(t1)Tx Q_hex1];
f=u;

%----------------------------end tank_temp.m---------------------------------------------------------------------