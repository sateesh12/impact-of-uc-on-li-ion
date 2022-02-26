%---------------------------------------------------------------------------------
%
% M-file: fc_current.m
% After the stack definition: calculating cell voltage and current density 
%
% Created: 09/18/02 by Kristina Haraldsson, NREL
%------------------------------------------------------------------------------------
function f=fc_current(u,Pc,Pa,tm,F,jo,Voc,R2,A,Tcell,Tah,Tch) 

% Input vector
%=============
Rm=u(1);
Po=u(2);

%Power demand
%-------------
Pel=u(3); 	%[W]

%Number of fuel cells
%------------------
N=u(4);

%Cellpotential, current density
%-------------------------------
% Initial values
%---------------
i=0.001;
y=0;

% NOTE: Here, the cell voltage is not allowed to be lower than 0.6 V
%--------------------------------------------------------------------
z=(Pel/(N*A));
while (y<z)
     Ecell=Voc-(R2*(Tcell+273))/(0.5*F)*log(i/(jo*Po))-i*Rm;
    i=i+0.001;
     if Ecell<0.6
        Ecell=0.6;
    end;
    y=Ecell*i;
end

u=[i Ecell N];
f=u;

%---------------------------end fc_current.m----------------------------------------------------------------