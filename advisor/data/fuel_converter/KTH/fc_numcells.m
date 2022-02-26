%---------------------------------------------------------------------------
%
% M-file: fc_numcells
%
% If N, number of cells in the stack is zero, the number of cells is 
% calculated
% 
% Kristina Haraldsson, NREL
% Date: 082602
%---------------------------------------------------------------------------
function f=fc_numcells(u,N,R2,F,jo,Voc,Tcell,A)

% Input vector
%-----------
Rm=u(1);
Po=u(2);
Pel=u(3);

% Initial values
%----------------
i=0.1;                                                  %[A/cm2]
Ecell=0.8;                                              %[V]                       

%Here, a minimum cell voltage of 0.75 V is sought
%--------------------------------------------------
while (Ecell>0.75)
Ecell=Voc-(R2*(Tcell+273))/(0.5*F)*log(i/(jo*Po))-i*Rm;
i=i+0.001;
end;


if N==0
%Calculation of the number of fuel cells to achieve the electric output requirements
%==================================================================================
N=Pel/(i*A*Ecell);
else 
    N=N;
end

% Output vector
%-----------------
clear u 
u=[i Ecell N];
f=u;