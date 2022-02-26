function [sys,x0,str,ts] = sfun_fuelcell_adapt(t,x,u,flag, ...
    cs_max_pwr_rise_rate,cs_max_pwr_fall_rate, ...
    fc_fuel_lhv,cs_shutoff,cs_min_pwr,cs_max_pwr,cs_mean_eff_bool,cs_mean_eff,cs_plot_output)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Implementation of the fuel cell adaptive control strategy.
%   This script try to find at each time intervall the best power split between fuel cell
%   and battery by computing all feasible points, building a global energy function
%   and asking for its minimum value.
%
%   The script doesn't take into account fc temperature
%-------------------------------------------------------------------------------------------
%   Number of parameters:   9
%       cs_max_pwr_rise_rate:   maximum rate of increase of power
%       cs_max_pwr_fall_rate:   maximum rate of increase of power
%       fc_fuel_lhv:            low heating value of fuel
%       cs_shutoff:             Boolean for authorization of shutting off the fc
%       cs_min_pwr:             minimum fc power from control strategy (should be a fc characteristics)
%       cs_max_pwr:             maximum fc power from control strategy (should be a fc characteristics)
%       cs_mean_eff_bool:       Boolean for computing equivallent battery function
%       cs_mean_eff:            Mean efficiency for computing equivallent battery function
%       cs_plot_output:         Boolean Animation plot
%-------------------------------------------------------------------------------------------
%   Number of inputs:       8
%       PwrReq=u(1);            Power required to drive the vehicle
%       SocRegen=u(2);          Soc variation expected from regen (free energy)
%       Soc=u(3);               State of charge
%       SocFactor=u(4);         This is soc regulation factor([0.8;1.2])
%       EssMaxPwr=u(5);         This is maximum ess discharge value (>0)
%       EssMinPwr=u(6);         This is maximum charge value (<0)
%       Tess=u(7);              Ess Temperature
%       PrevFcPwrAch=u(8);      Previous FC power achieved
%-------------------------------------------------------------------------------------------
%   Number of outputs:       2 
%       the power required to the fuel cell in W 
%       Boolean Fuel cell state on/off
%-------------------------------------------------------------------------------------------
% Created on: 12-Dec-2002
% By:  Bruno Jeanneret and Tony Markel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
DebugScript=0; % debugging purpose. output main intermediate results if 1

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=[];

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=[];

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u,DebugScript,cs_plot_output, ...
       cs_max_pwr_rise_rate,cs_max_pwr_fall_rate, ...
       fc_fuel_lhv,cs_shutoff,cs_min_pwr,cs_max_pwr,cs_mean_eff_bool,cs_mean_eff);


  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
%   We have to clear the Workspace before leaving
    evalin('base','clear DeltaSocAdapt EssAdaptTime EssReqAdaptPwr FcReqAdaptPwr');
    sys=[];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,fid]=mdlInitializeSizes

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
x0  = [];
%
% str is always an empty matrix
str = [];
%
% initialize the array of sample times
ts  = [-1 0]; %inherited sample time (time of simulink 'simulation parameter')

% Select the right block choice from the library for the two small simulink models
adjust_config_bds('fuelcell_adapt_cs');
adjust_config_bds('ess_adapt_cs');

% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,DebugScript,cs_plot_output, ...
    cs_max_pwr_rise_rate,cs_max_pwr_fall_rate, ...
    fc_fuel_lhv,cs_shutoff,cs_min_pwr,cs_max_pwr,cs_mean_eff_bool,cs_mean_eff)

if DebugScript fprintf(1,'\n time= %f\n',t), end

% get the input variables
PwrReq=u(1);        % Power required to drive the vehicle
SocRegen=u(2);      % Soc variation expected from regen (free energy)
Soc=u(3);           % State of charge
SocFactor=u(4);     % This is soc regulation factor([0.8;1.2])
EssMaxPwr=u(5);     % This is maximum ess discharge value (>0)
EssMinPwr=u(6);     % This is maximum charge value (<0)
Tess=u(7);          % Ess Temperature
PrevFcPwrAch=u(8);  % Previous FC power achieved

% Initialisation
NStep=10;           % Number of objective function evaluation - Hard coded value do not change

if DebugScript PrevFcPwrAch, end

% for the small ess simulink model to run
assignin('base','ess_mod_init_tmp',Tess); % Energy storage temperature
assignin('base','ess_soc_current',Soc); % Energy storage soc (to compute the delta soc)
assignin('base','ess_init_soc',Soc); % Energy storage initial soc


% Step 1: Define battery available operating range satisfaying power demand and fc power rate
FcMaxPwr=min(PrevFcPwrAch+cs_max_pwr_rise_rate,cs_max_pwr);
FcMinPwr=max(PrevFcPwrAch+cs_max_pwr_fall_rate,cs_min_pwr);
RgeMinEss=max(EssMinPwr,(PwrReq-FcMaxPwr));
RgeMaxEss=min(EssMaxPwr,(PwrReq-FcMinPwr));
StepEssPwr=(RgeMaxEss-RgeMinEss)/(NStep-1);

if DebugScript PwrReq, EssMaxPwr, EssMinPwr, end
if DebugScript RgeMinEss, RgeMaxEss, end

% Step 2: For each Fuel Cell available power, compute energy consumption
a=0:(NStep-1);
EssStepTime=0:(3*NStep-1);
EssStepPwr=RgeMinEss+StepEssPwr*a;
FcStepPwr=PwrReq-EssStepPwr; %FC power to supply driver demand
PwrTgv=[FcStepPwr;FcStepPwr;FcStepPwr];
PwrTgv=[PwrTgv(:,1)' PwrTgv(:,2)' PwrTgv(:,3)' PwrTgv(:,4)' PwrTgv(:,5)' PwrTgv(:,6)' PwrTgv(:,7)' PwrTgv(:,8)' PwrTgv(:,9)' PwrTgv(:,10)'];
assignin('base','FcReqAdaptPwr',PwrTgv);
assignin('base','EssAdaptTime',EssStepTime);
evalin('base','sim(''fuelcell_adapt_cs'',29);');
JFuel=evalin('base','fc_fuel_rate')*fc_fuel_lhv;
JFuel=JFuel(3:3:30);
JFuel=JFuel';

if DebugScript FcStepPwr, end

% Step 3: Compute deltaSoc and make a correspondance between DeltaSoc and equivallent FC Energy
%Step3.1: Compute DeltaSoc
PwrTgv=[EssStepPwr;EssStepPwr;EssStepPwr];
PwrTgv=[PwrTgv(:,1)' PwrTgv(:,2)' PwrTgv(:,3)' PwrTgv(:,4)' PwrTgv(:,5)' PwrTgv(:,6)' PwrTgv(:,7)' PwrTgv(:,8)' PwrTgv(:,9)' PwrTgv(:,10)'];
assignin('base','EssReqAdaptPwr',PwrTgv);
assignin('base','EssAdaptTime',EssStepTime);
evalin('base','sim(''ess_adapt_cs'',29);');
DeltaSoc=evalin('base','DeltaSocAdapt');
DeltaSoc=DeltaSoc(3:3:30);
DeltaSoc=DeltaSoc';


% Step 3.2: compute reference values for DeltaSoc and equivallent fuel used: (DeltaSocCalc,JFuelCalc)
% We assume that the cs_max_pwr et cs_min_pwr are in accordance with the fuel cell data file (!)
% Here the power rate limitation are not taken into account, again that is reference values. 
PwrRef=min(cs_max_pwr*9/10,max(cs_max_pwr/8,PwrReq));
RgeMinEssTmp=max(EssMinPwr,(PwrRef-cs_max_pwr));
RgeMaxEssTmp=min(EssMaxPwr,(PwrRef-cs_min_pwr));
StepEssTmp=(RgeMaxEssTmp-RgeMinEssTmp)/(NStep-1);
a=0:(NStep-1);
EssStepTmp=RgeMinEssTmp+StepEssTmp*a;
FcPwr=PwrRef-EssStepTmp; %FC power to supply driver demand
EssStepTime=0:(3*NStep-1);
if cs_mean_eff_bool==0
    PwrTgv=[FcPwr;FcPwr;FcPwr]; 
    PwrTgv=[PwrTgv(:,1)' PwrTgv(:,2)' PwrTgv(:,3)' PwrTgv(:,4)' PwrTgv(:,5)' PwrTgv(:,6)' PwrTgv(:,7)' PwrTgv(:,8)' PwrTgv(:,9)' PwrTgv(:,10)'];
    assignin('base','FcReqAdaptPwr',PwrTgv);
    assignin('base','EssAdaptTime',EssStepTime);
    evalin('base','sim(''fuelcell_adapt_cs'',29);');
    JFuelCalc=evalin('base','fc_fuel_rate')*fc_fuel_lhv;
    JFuelCalc=JFuelCalc(3:3:30);
    JFuelCalc=JFuelCalc';

else
   JFuelCalc=FcPwr/cs_mean_eff;  
end

%Step3.3: Compute JFuelRef at 0 Ess pwr (for the PwrRef value) and correct JFuelCalc
assignin('base','FcReqAdaptPwr',[PwrRef PwrRef PwrRef]);
assignin('base','EssAdaptTime',[0 1 2]);
evalin('base','sim(''fuelcell_adapt_cs'',2);');
JFuelRef=evalin('base','fc_fuel_rate(end)')*fc_fuel_lhv;
JFuelCalc=JFuelCalc-JFuelRef;

if DebugScript JFuelRef, end

% Step3.4: Compute corresponding DeltaSocCalc
PwrTgv=[EssStepTmp;EssStepTmp;EssStepTmp];
PwrTgv=[PwrTgv(:,1)' PwrTgv(:,2)' PwrTgv(:,3)' PwrTgv(:,4)' PwrTgv(:,5)' PwrTgv(:,6)' PwrTgv(:,7)' PwrTgv(:,8)' PwrTgv(:,9)' PwrTgv(:,10)'];
assignin('base','EssReqAdaptPwr',PwrTgv);
assignin('base','EssAdaptTime',EssStepTime);
evalin('base','sim(''ess_adapt_cs'',29);');
DeltaSocCalc=evalin('base','DeltaSocAdapt');
DeltaSocCalc=DeltaSocCalc(3:3:30);
DeltaSocCalc=DeltaSocCalc'+SocRegen; % Add the regen term

if DebugScript DeltaSocCalc,JFuelCalc,EssStepTmp,FcPwr, end

% Step3.5 Compute the equivallent energy from energy storage system
JEqEss=interp1(DeltaSocCalc,JFuelCalc,(-1)*DeltaSoc,'linear','extrap');

%Step4: Total energy
Energy=SocFactor*JEqEss+JFuel;

if DebugScript  EssStepPwr, fprintf(1,'DeltaSoc=\n');, fprintf(1,'  %12.8f  ',DeltaSoc);, JFuel, end
if DebugScript JEqEss, Energy, end

% Step: Define Performance function. normalized values (neglected)
%Energy_adjust=(Energy-min(Energy))/(max(Energy)-min(Energy))

% Step 5: find the function's minimum
% To shut the mouse of polyfit's warning, 
% we have to scale abscisse and ordonnate
AdimEssStepPwr=EssStepPwr/max(abs(EssStepPwr));
AdimEnergy=Energy/max(abs(Energy));
[p,s]=polyfit(AdimEssStepPwr,AdimEnergy,5);
StepFine=(max(AdimEssStepPwr)-min(AdimEssStepPwr))/100;
EssPwrFine=min(AdimEssStepPwr):StepFine:max(AdimEssStepPwr);
PerfoFine=polyval(p,EssPwrFine);
% Back to non normalized values;
EssPwrFine=EssPwrFine*max(abs(EssStepPwr));
PerfoFine=PerfoFine*max(abs(Energy));
StepFine=StepFine*max(abs(EssStepPwr)); % it is used below
index=find(PerfoFine==min(PerfoFine));
EssPwrChoice=EssPwrFine(index);  % This is the best ess operating point

% Step 6: is a shut off the Fuell Cell a good idea ?
FcOnOff=1;
if cs_shutoff
   if PwrReq-EssPwrChoice<=0
      FcOnOff=0;
   end
   if EssMaxPwr>PwrReq & EssMinPwr<PwrReq
      EssPwrOff=PwrReq;
      assignin('base','EssReqAdaptPwr',[EssPwrOff EssPwrOff EssPwrOff]);
      assignin('base','EssAdaptTime',[0 1 2]);
      evalin('base','sim(''ess_adapt_cs'',2);');
      DeltaSocOff=evalin('base','DeltaSocAdapt(end)');
      % Correction with the socfactor for charge sustaining strategy
      JEqEssOff=SocFactor*interp1(DeltaSocCalc,JFuelCalc,(-1)*DeltaSocOff,'linear','extrap');
      if JEqEssOff<=PerfoFine
         FcOnOff=0;
         EssPwrChoice=PwrReq;
      end
   end

end

if DebugScript EssPwrChoice, PwrReq-EssPwrChoice, end

sys = [min(cs_max_pwr,PwrReq-EssPwrChoice) FcOnOff]; %Return optimal power required to the fuel cell and on/off operation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   plotting purpose %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cs_plot_output

    if(isempty(findobj('Tag','CS_Adapt_FuelCell','Type','figure')))
        %set the figure size by defining vinf.gui_size and then setting the size
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            %figsize=[(screensize(3)-900)/2 (screensize(4)-650)/2 900 650]; %full size
            figsize=[(screensize(3)-900)/2 (screensize(4)-650)/2 600 400];
            btnsize=[(screensize(3)-900)/2+200 110 50 20]
       else
            figsize=[100 100   600   400];
            btnsize=[300 100 50 20];
        end
        %end set the figure size
         FigGr = figure( ...
	    'Name','Adaptive Control Strategy of hybrid series with Fuel Cell', ...
        'NumberTitle','off', ...
        'Position',figsize, ...
        'Visible','On', ...
        'Tag','CS_Adapt_FuelCell');
 
   end
   set(0,'CurrentFigure',findobj('Tag','CS_Adapt_FuelCell'));   
   
   plot(EssStepPwr/1000,JEqEss,'b-+',FcStepPwr/1000,JFuel,'r-+',FcStepPwr/1000,Energy,'m-+',EssPwrFine/1000,PerfoFine,'k-');
   grid on;
   xlabel('Power kW')
   ylabel('Energy J');
   hold on;
   plot(EssPwrFine(index)/1000,PerfoFine(index),'k*');
   text(EssPwrFine(index)/1000,PerfoFine(index)*1.05,'OP_E_S_S','Color','k');
   plot((PwrReq-EssPwrFine(index))/1000,PerfoFine(index),'m*');
   text((PwrReq-EssPwrFine(index))/1000,PerfoFine(index)*1.05,'OP_F_C','Color','m');
   
   if FcOnOff==1
    title(['Time: ',num2str(round(t)),'  Power required: ',num2str(round(PwrReq/100)/10),' kW']);
   else
    title(['Time: ',num2str(round(t)),'  Power required: ',num2str(round(PwrReq/100)/10),' kW',' Engine shut off']);
   end
   legend('Power Ess,En Ess','Power FC, En FC','Power FC, Tot En','Power Ess Tot En' ,-1);
   hold off
end

% end mdlOutputs