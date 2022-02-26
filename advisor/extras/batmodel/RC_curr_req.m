function [sys,x0,str,ts] = RC_curr_req(t,x,u,flag,...
    ess_min_volts,ess_max_volts,mc_min_volts,...
    ess_soc,ess_tmp,ess_voc,...
    ess_init_soc,ess_mod_init_tmp)
%Inputs in u: 
% Cb,Cc,Re,Rc,Rt,I,Ess_temperature
%Outputs: 
% Pout,SOC,Vout,Qess_gen,Pmax,Pmin(chg max),Current
debugvhj=0;
if debugvhj,
    disp(['t: ',num2str(t),' flag: ',num2str(flag)]);
    disp(x);
    disp([num2str(u)]),
end

switch flag,

    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
case 0,
    [sys,x0,str,ts]=mdlInitialize(ess_soc,ess_voc,ess_tmp,ess_init_soc,ess_mod_init_tmp,debugvhj);
    
    %%%%%%%%%%%%%%%
    % Derivatives %
    %%%%%%%%%%%%%%%
case 1,
    sys=mdlDerivatives(t,x,u,ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp,debugvhj);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update Discrete States %
    %%%%%%%%%%%%%%%%%%%%%%%%%%
case 2,
    sys=mdlUpdate(t,x,u);

    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
case 3,
    sys=mdlOutputs(t,x,u,...
        ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp,debugvhj);
    
    %%%%%%%%%%%%%
    % Terminate %
    %%%%%%%%%%%%%
case 9,
    sys=mdlTerminate(t,x,u);
    
    %%%%%%%%%%%%%%%%%%%%
    % Unexpected flags %
    %%%%%%%%%%%%%%%%%%%%
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
    
end


%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
function [sys,x0,str,ts]=mdlInitialize(ess_soc,ess_voc,ess_tmp,ess_init_soc,ess_mod_init_tmp,debugvhj)
sizes = simsizes;

sizes.NumContStates  = 2;   %voltages of the two capacitors
sizes.NumDiscStates  = 0;   % 
sizes.NumOutputs     = 7;   %Pout,SOC,Vout,Qess_gen,Pmax,Pmin(chg max),Current
sizes.NumInputs      = 7;   %Cb,Cc,Re,Rc,Rt,Pload,Ess_temperature
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;  

sys = simsizes(sizes);

% initialize the initial conditions
%Interpolate here to determine initial voltages based on initial SOC (ess_init_soc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[SOC_index,Tmp]=meshgrid(ess_soc,ess_tmp);
%Limit SOC and Temperature of inputs
if ess_mod_init_tmp>max(ess_tmp)
    mod_tmp=max(ess_tmp);
elseif ess_mod_init_tmp<min(ess_tmp)
    mod_tmp=min(ess_tmp);
else
    mod_tmp=ess_mod_init_tmp;
end
voc4interp=griddata(Tmp,SOC_index,ess_voc,mod_tmp,ess_soc)';
Vinit=interp1(ess_soc,voc4interp,ess_init_soc);
x0  = [1 1]*Vinit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% str is always an empty matrix
str = [];

% initialize the array of sample times
ts  = [0 0]; % 

if debugvhj,disp(['sys: ',num2str(sys),' xo: ',num2str(x0),' str: ',str,' ts: ',num2str(ts)]);
end
% end mdlInitializeSizes


%=============================================================================
% mdlDerivatives
% Handle continuous state derivatives
%=============================================================================
function sys=mdlDerivatives(t,x,u,ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp,debugvhj)
%Calculate the state matrices based on input R's and C's
[A,B,C,D,il,Plmax,Plmin,SOC]=calcABCD(x,u,ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp);

sys = A*x + B*il;
% end mdlDerivatives


%calcABCD
function [A,B,C,D,il,Plmax,Plmin,SOC]=calcABCD(x,u,ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp)
Cb=u(1);
Cc=u(2);
Re=u(3);
Rc=u(4);
Rt=u(5);
il=u(6); %current load

% state space form : [dVcb/dt; dVcc/dt]=A*[Vcb; Vcc]+B*[is]
% [Vo Vcb Vcc]=C*[Vcb; Vcc]+D*[is]

A=[-1/(Cb*(Re+Rc))  1/(Cb*(Re+Rc))
    1/(Cc*(Re+Rc))					-1/(Cc*(Re+Rc))];

B=[-Rc/(Cb*(Re+Rc))
    -Re/(Cc*(Re+Rc))];

C=[Rc/(Re+Rc)  Re/(Re+Rc)
    1   0
    0   1];

D=[-Rt-(Rc*Re)/(Re+Rc)
    0
    0];

%calculate Current load, limit power to ess_min_volts, ess_max_volts, mc_min_volts, max power available 
SOC=calcSOC(x,u,ess_soc,ess_voc,ess_tmp);  %calculate SOC 
% Limit power to max battery can deliver
%Pmax_ess=(C(1,1)*x(1)+C(1,2)*x(2))^2/(4*D(1))-eps;
%%Voltage limits, il=(Vo-c1x1-c2x2)/d where Vo is either ess min, ess max, or mc min;
%Vmin=max(ess_min_volts,mc_min_volts);
%Vmax=ess_max_volts;
%ilmax=(Vmin-C(1,1)*x(1)-C(1,2)*x(2))/D(1); %discharging
%ilmin=(Vmax-C(1,1)*x(1)-C(1,2)*x(2))/D(1); %charging
%Plmax=ilmax*Vmin;   %max due to voltage limit
Plmax=1;%min(Plmax,Pmax_ess);   %max due to v limit and battery limits
Plmin=-1;%ilmin*Vmax;
if SOC<eps  %provide no dis power if SOC<eps 
    Plmax=0; %cannot discharge
elseif SOC>(1-eps)  %provide no charge power if SOC>1-eps
    Plmin=0; %cannot charge
end
%Pl=min(Pl,Plmax);      %take the lower in order not to exceed the max, saturate at max discharge limit
%Pl=max(Pl,Plmin);               %saturate at min charge limit
% i load = (-b+sqrt(b^2-4ac))/2d
%il=(-1*((C(1,1)*x(1)+C(1,2)*x(2)))+((C(1,1)*x(1)+C(1,2)*x(2))^2-4*Pl*D(1))^0.5)/(2*D(1));
%end calcABCD

%calcSOC
function [SOC]=calcSOC(x,u,ess_soc,ess_voc,ess_tmp)
[SOC_index,Tmp]=meshgrid(ess_soc,ess_tmp);
%Limit SOC and Temperature of inputs
if u(7)>max(ess_tmp)
    mod_tmp=max(ess_tmp);
elseif u(7)<min(ess_tmp)
    mod_tmp=min(ess_tmp);
else
    mod_tmp=u(7);
end
voc4interp=griddata(Tmp,SOC_index,ess_voc,mod_tmp,ess_soc)';
%disp(['Tmp in: ',num2str(u(7)),' mod_tmp: ',num2str(mod_tmp)])
%voc4interp
Vmax=interp1(ess_soc,voc4interp,1);
Vmin=interp1(ess_soc,voc4interp,0);
%disp(['Vmax: ',num2str(Vmax),' Vmin: ',num2str(Vmin),' Vcb: ',num2str(x(1)),' Vcc: ',num2str(x(2))])
if x(1)>Vmax, SOCcb=1;
elseif x(1)<Vmin, SOCcb=0;
else
    SOCcb=interp1(voc4interp,ess_soc,x(1)); %Evaluate SOC at Vcb
end
if x(2)>Vmax, SOCcc=1;
elseif x(2)<Vmin, SOCcc=0;
else
    SOCcc=interp1(voc4interp,ess_soc,x(2)); %Evaluate SOC at Vcc
end
SOC=mean([SOCcb SOCcc]);
%end calcSOC

%calcQgen
function [Qess_gen]=calcQgen(x,u,il)
Re=u(3);
Rc=u(4);
Rt=u(5);
%heat generated in resistors: i^2*R
Prt=il^2*Rt;
ire=(x(1)-x(2)+Rc*il)/(Re+Rc);
Pre=ire^2*Re;
Prc=(ire-il)^2*Rc;
Qess_gen=Prt+Pre+Prc;
%end calcQgen

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update Discrete States %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u);
sys=[];
%end mdlUpdate


%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
function sys=mdlOutputs(t,x,u,...
    ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp,debugvhj)

if debugvhj, disp('Outputs: calc ABCD start'); end
    
[A,B,C,D,il,Plmax,Plmin,SOC]=calcABCD(x,u,ess_min_volts,ess_max_volts,mc_min_volts,ess_soc,ess_voc,ess_tmp);

if debugvhj, disp('Outputs: calc ABCD end'); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass variables of interest back to ADVISOR
y = C*x + D*il; %y=[Vo Vcb Vcc]
Vo=y(1);
Qess_gen=calcQgen(x,u,il);

if debugvhj, disp(['Outputs: Pout: ',num2str(il*Vo),' SOC: ',num2str(SOC),' Vo: ',num2str(Vo),' Qess_gen: ',...
            num2str(Qess_gen),' Plmax: ', num2str(Plmax),' Plmin: ',num2str(Plmin),' il: ',num2str(il)]); end

sys=[il*Vo SOC Vo Qess_gen Plmax Plmin il];   %Pout,SOC,Vout,Qess_gen,Pmax,Pmin(chg max),Current
% end mdlOutputs


%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
sys = [];
% end mdlTerminate

%%%%%%%%%%%%%%%%%%
%Revision history
%02/08/01: vhj file created
%02/12/01: vhj updated calcABCD
%02/13/01: vhj added calcSOC, updated calcABCD to include max/min V limits, added calcQess_gen
%02/14/01: vhj SOC determined by mean of SOC's of the two capacitors
%02/21/01: vhj renamed RC_curr_req and have input as current (used for batmodel since battery tests have current known)
%03/01/01: vhj SOC calc in 2 steps (griddata then interp1)
%03/15/01: vhj adjust SOC calc (Vmin, Vmax), new xo
