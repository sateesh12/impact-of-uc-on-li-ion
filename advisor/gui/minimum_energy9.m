function [sys,x0,str,ts] = minimum_energy9(t,x,u,flag,tc_mc_to_fc_ratio,...
    fc_map_spd,fc_map_trq,fc_max_trq,fc_fuel_map,fc_nox_map,fc_pm_map,...
    fc_hc_map,fc_co_map,fc_fuel_lhv,fc_fuel_den,fc_trq_scale,fc_spd_scale,...
    ex_cat_lim,K_Energy,K_Emis,mpg_desired,hc_desired,co_desired,nox_desired,...
    pm_desired,mc_max_trq,mc_map_spd,mc_map_trq,mc_eff_map,mc_trq_scale,mc_spd_scale,...
    fc_eff_map)
%Inputs in u: 
% Tm=max torque motor can supply at given speed, initial evaluation point
% dT: increment of torque such that in 10 steps, the min motor torque is reached
% Treq: requested torque of the vehicle
% wreq: requested speed (rad/sec) of the vehicle
% DeltaSOC_regen: average increase in SOC due to regen over past x time steps
% SOC: current state of charge
% eff: catalyst efficiency vector ([HC CO NOx PM] removal efficiencies)
% mphr: required miles per hour
% lambda: temperature factor of engine. lambda=(fc_tstat-T_fc_coolant)/(75), e.g. fc_tstat=99C
% scale: scale factor to multiply effective energy used by motor
%
%Output: 
% sys=Tfc_perf=[torque to request of the fuel converter, performance metric]

%User inputs for plotting display
%only check one or the other for plots (or none)
plotalloutput=1;    %Plots Impact, Energy, Engine Efficiency, Motor Efficiency, NOx, PM
plotperformance=0;  %Plots just Impact function

%Debug test cases
% e.g. minimum_energy6(74.6781,9.1344,168.0258,175.7876,0.0000,0.5326,[0.0328 0.0492    0.0082    0.0328],30.5000,0.7698,13.0051)
%minimum_energy6(18.5673,1.4963,137.4575,261.3539,0,.6958,[.0165 .0248 .0041 .0165],200,1.0515,3.5185)
%minimum_energy6(4.502,6.555,10.13,120.1,0,0.699,[0 0 0 0],10,1.32,.1604)
%minimum_energy6(18.8166,3.4809,42.3373,96.0994,0,0.6424,[0 0 0 0],13.72,1.32,10.5687)
%minimum_energy7(14.2218,4.3656,31.9990,127.5543,0.0003,1.0000,[0 0 0 0],30.4000,1.3200,0.001);
%minimum_energy7(24.2691,5.6159,54.6055,166.1599,0.0001,0.8382,[0.9100 0.9500 0.0099 0.4000],19.2000,0,0.5292);
%minimum_energy7(14.4359,5.7367,32.4808,263.6055,0      ,.6231,[.91 .95 0.099 0.4000],62.1,0,9.1336);
%minimum_energy7(5.6563,5.9158,12.7266,231.9669,3.3E-5,0.5647,[0.1520 0.3800 0.3300 0.1520],54.7000,0.7879,11.3224);
%minimum_energy8(5.6563,5.9158,12.7266,231.9669,3.3E-5,0.5647,[0.1520 0.3800 0.3300 0.1520],54.7000,0.7879,11.3224,35);
%minimum_energy8(11.4711,5.8625,25.8099,181.1999,0,.6607,[0.0639 .1438 .0938 .0639],46.3333,0.8645,7.7243,20.5223);
%minimum_energy9(11.4711,5.8625,25.8099,181.1999,0,.6607,[0.0639 .1438 .0938 .0639],0,0.8645,7.7243,20.5223);
%minimum_energy9(.4103,6.256,1.0031,137.5523,0,.6933,[0.7946 .919 .9026 0],30.48,0.0475,3.0227,34.9448);
%minimum_energy9(18.6482,1.0909,45.5861,70.6833,0,.6999,[0 0 .0074 0],0,1.0533,1.0371,20)
%minimum_energy9(45.5786,4.0101,80.9,115.9101,0,.6999,[0 0 .0074 0],0,1.0133,1.0446,20)
%minimum_energy9(3.6961,4.0498,6.4196,120.1153,0,.699,[0 0 .0086 0],4,1.0133,1.296,20.001)
%minimum_energy9(25.1043,3.9023,43.6023,99.4833,0,.6999,[0 0 .0074 0],0,1.0133,1.0371,20)
%old function [Tfc_perf]=minimum_energy9(Tm,dT,Treq,wreq,DeltaSOC_regen,SOC,eff,mphr,lambda,scale,Tess)
weightmax=1;	%choose only max or raw for weighting
weightraw=0;
debug=0;debugdisp=0;

%Variable needed from workspace, pass these to function later
mc_T=evalin('base','round(min(mc_max_trq))');

%SFUNTMPL General M-file S-function template
%   With M-file S-functions, you can define you own ordinary differential
%   equations (ODEs), discrete system equations, and/or just about
%   any type of algorithm to be used within a Simulink block diagram.
%
%   The general form of an M-File S-function syntax is:
%       [SYS,X0,STR,TS] = SFUNC(T,X,U,FLAG,P1,...,Pn)
%
%   What is returned by SFUNC at a given point in time, T, depends on the
%   value of the FLAG, the current state vector, X, and the current
%   input vector, U.
%
%   FLAG   RESULT             DESCRIPTION
%   -----  ------             --------------------------------------------
%   0      [SIZES,X0,STR,TS]  Initialization, return system sizes in SYS,
%                             initial state in X0, state ordering strings
%                             in STR, and sample times in TS.
%   1      DX                 Return continuous state derivatives in SYS.
%   2      DS                 Update discrete states SYS = X(n+1)
%   3      Y                  Return outputs in SYS.
%   4      TNEXT              Return next time hit for variable step sample
%                             time in SYS.
%   5                         Reserved for future (root finding).
%   9      []                 Termination, perform any cleanup SYS=[].
%
%
%   The state vectors, X and X0 consists of continuous states followed
%   by discrete states.
%
%   Optional parameters, P1,...,Pn can be provided to the S-function and
%   used during any FLAG operation.
%
%   When SFUNC is called with FLAG = 0, the following information
%   should be returned:
%
%      SYS(1) = Number of continuous states.
%      SYS(2) = Number of discrete states.
%      SYS(3) = Number of outputs.
%      SYS(4) = Number of inputs.
%               Any of the first four elements in SYS can be specified
%               as -1 indicating that they are dynamically sized. The
%               actual length for all other flags will be equal to the
%               length of the input, U.
%      SYS(5) = Reserved for root finding. Must be zero.
%      SYS(6) = Direct feedthrough flag (1=yes, 0=no). The s-function
%               has direct feedthrough if U is used during the FLAG=3
%               call. Setting this to 0 is akin to making a promise that
%               U will not be used during FLAG=3. If you break the promise
%               then unpredictable results will occur.
%      SYS(7) = Number of sample times. This is the number of rows in TS.
%
%
%      X0     = Initial state conditions or [] if no states.
%
%      STR    = State ordering strings which is generally specified as [].
%
%      TS     = An m-by-2 matrix containing the sample time
%               (period, offset) information. Where m = number of sample
%               times. The ordering of the sample times must be:
%
%               TS = [0      0,      : Continuous sample time.
%                     0      1,      : Continuous, but fixed in minor step
%                                      sample time.
%                     PERIOD OFFSET, : Discrete sample time where
%                                      PERIOD > 0 & OFFSET < PERIOD.
%                     -2     0];     : Variable step discrete sample time
%                                      where FLAG=4 is used to get time of
%                                      next hit.
%
%               There can be more than one sample time providing
%               they are ordered such that they are monotonically
%               increasing. Only the needed sample times should be
%               specified in TS. When specifying than one
%               sample time, you must check for sample hits explicitly by
%               seeing if
%                  abs(round((T-OFFSET)/PERIOD) - (T-OFFSET)/PERIOD)
%               is within a specified tolerance, generally 1e-8. This
%               tolerance is dependent upon your model's sampling times
%               and simulation time.
%
%               You can also specify that the sample time of the S-function
%               is inherited from the driving block. For functions which
%               change during minor steps, this is done by
%               specifying SYS(7) = 1 and TS = [-1 0]. For functions which
%               are held during minor steps, this is done by specifying
%               SYS(7) = 1 and TS = [-1 -1].

%   Copyright (c) 1990-1998 by The MathWorks, Inc. All Rights Reserved.
%   $Revision: 1.4 $

%
% The following outlines the general structure of an S-function.
%
switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
case 0,
    [sys,x0,str,ts]=mdlInitialize;
    
    %%%%%%%%%%
    % Update %
    %%%%%%%%%%
case 2,
    sys=mdlUpdate(t,x,u);
    
    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
case 3,
    sys=mdlOutputs(t,x,u,plotalloutput,plotperformance,weightmax,weightraw,debug,debugdisp,...
        tc_mc_to_fc_ratio,...
        fc_map_spd,...
        fc_map_trq,...
        fc_max_trq,...
        fc_fuel_map,...
        fc_nox_map,...
        fc_pm_map,...
        fc_hc_map,...
        fc_co_map,...
        fc_fuel_lhv,...
        fc_fuel_den,...
        fc_trq_scale,...
        fc_spd_scale,...
        ex_cat_lim,...
        mc_T,...
        K_Energy,...
        K_Emis,...
        mpg_desired,...
        hc_desired,...
        co_desired,...
        nox_desired,...
        pm_desired,...
        mc_max_trq,mc_map_spd,mc_map_trq,mc_eff_map,mc_trq_scale,mc_spd_scale,fc_eff_map);
    
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

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitialize
%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0; % 
sizes.NumOutputs     = 2; % 
sizes.NumInputs      = 14; %
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

% initialize the initial conditions
x0  = [];

% str is always an empty matrix
str = [];

% initialize the array of sample times
% later use this for Saber designation
ts  = [-1 0]; % inherited time step 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use this for initialization of saber runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% end mdlInitializeSizes

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)
sys=[];
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,plotalloutput,plotperformance,weightmax,weithtraw,debug,debugdisp,...
    tc_mc_to_fc_ratio,...
    fc_map_spd,...
    fc_map_trq,...
    fc_max_trq,...
    fc_fuel_map,...
    fc_nox_map,...
    fc_pm_map,...
    fc_hc_map,...
    fc_co_map,...
    fc_fuel_lhv,...
    fc_fuel_den,...
    fc_trq_scale,...
    fc_spd_scale,...
    ex_cat_lim,...
    mc_T,...
    K_Energy,...
    K_Emis,...
    mpg_desired,...
    hc_desired,...
    co_desired,...
    nox_desired,...
    pm_desired,...
    mc_max_trq,mc_map_spd,mc_map_trq,mc_eff_map,mc_trq_scale,mc_spd_scale,...
    fc_eff_map)

Tm=u(1);
dT=u(2);
Treq=u(3);
wreq=u(4);
DeltaSOC_regen=u(5);
SOC=u(6);
eff=[u(7) u(8) u(9) u(10)];
mphr=u(11);
lambda=u(12);
scale=u(13);
Tess=u(14);

if debug,assignin('base','Output',[Tm dT Treq wreq DeltaSOC_regen SOC eff mphr lambda scale Tess]);end%debug purposes, delete later

%Case to return immediately:
if dT<=0	%can't supply requested torque
    Tfc_perf=[Treq 0];
    sys = [Tfc_perf];
    return
else
    
    % Define available variables, see if emissions are defined/calculate based on available emissions
    % (check to see if number of non-zero elements is > 0)
    %variable_names={'Energy','HC','CO','NOx','PM'};
    calculate_index=[1 1 1 1 1];	%index used to calculate variables
    if nnz(fc_hc_map)==0, calculate_index(2)=0; end
    if nnz(fc_co_map)==0, calculate_index(3)=0; end
    if nnz(fc_nox_map)==0, calculate_index(4)=0; end
    if nnz(fc_pm_map)==0, calculate_index(5)=0; end
    
    %Initializations and constants
    Tm_init=Tm;
    n=10; %number of points to pick
    dT=dT*10/n;
    wmotor=wreq*tc_mc_to_fc_ratio;
    Energy(n)=0;
    Torque_fc(n)=0;
    Jfuel(n)=0;
    Jmotor(n)=0;
    DeltaSOC=0; JfuelSOC=0; ratio=0;
    if wreq<min(fc_map_spd*fc_spd_scale)	%limit speed to low limit of map
        wreq=min(fc_map_spd*fc_spd_scale);
    elseif wreq>max(fc_map_spd*fc_spd_scale) %limit speed to high limit of map
        wreq=max(fc_map_spd*fc_spd_scale);
    end
    [Trq,Spd]=meshgrid(fc_map_trq*fc_trq_scale,fc_map_spd*fc_spd_scale);
    %Motor torque values to use: Torque_m
    Torque_m=Tm:-dT:(Tm-(n-1)*dT);
    assignin('base','wm',wmotor);
    assignin('base','Tess',Tess);
    assignin('base','ess_soc_current',SOC); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Jfuel versus DeltaSOC for given Treq
    for j=1:n	%Find JfuelSOC, DeltaSOC, vs Tmotor
        Tfc=Treq-tc_mc_to_fc_ratio*Torque_m(j);
        if debugdisp,disp(['Tfc,Treq,Tm: ',num2str(Tfc),',',num2str(Treq),',',num2str(Torque_m(j))]),end
        %Find fuel used at fuel converter
        if Tfc<min(fc_map_trq*fc_trq_scale)	%limit trq to low limit of map
            Tfc=min(fc_map_trq*fc_trq_scale);
        elseif Tfc>max(fc_map_trq*fc_trq_scale)	%limit trq to high limit of map
            Tfc=max(fc_map_trq*fc_trq_scale);
        end
        JfuelSOC(j)=fc_fuel_lhv*interp2(Trq,Spd,fc_fuel_map*fc_spd_scale*fc_trq_scale,Tfc,wreq);
        JfuelSOC(j)=JfuelSOC(j)*(1+lambda^3.1); %adjust for hot/cold engine
        
        %Find Delta SOC from using motor
        assignin('base','Tm',Torque_m(j));
        evalin('base','sim(''mc_pb_ess3'',2);');	%run the small simulation to get DeltaSOC
        %offest Dsoc with regen expected since regen is 'free'
        DeltaSOC(j)=evalin('base','DeltaSOC_mcpbess(end)')+DeltaSOC_regen;
        
        if debugdisp,disp(['j: ',num2str(j)]),end
        if j>=2	%monotonically increasing Dsoc (for Vlimiting cases)
            if DeltaSOC(j)<=DeltaSOC(j-1), 
                if debugdisp,disp(['adjust Dsoc: ',num2str(j)]),end
                DeltaSOC(j)=DeltaSOC(j-1)+1E-8;,end
        end
    end
    %%%%%%%%%%%%
    
    if debug,
        assignin('base','DeltaSOCminNRG',[DeltaSOC']);
        assignin('base','JfuelSOC',[JfuelSOC']);
        assignin('base','Torque_m',[Torque_m']);
    end
    
    %Temperature factor calculations
    %Correct Jfuel and emis for hot/cold engine
    variables={'Jfuel','HC','CO','NOx','PM'};
    coeff=[0.1 8.05 2.13 0.51 5.14];	%EngineOut=hot*(1+coeff*lambda^expon)
    expon=[0.65 9.46 4.26 1.37 17.04];
    for i=1:length(variables)
        efactor(i)=1+coeff(i)*lambda^expon(i);	%efactor=(1+coeff*lambda^expon)
    end
    %Correct emissions for catalyst efficiency =f(temp)
    variables2={'HC','CO','NOx','PM'};	%TailpipeEmis=EngineOut*(1-effic_cat)
    for i=1:length(variables2)
        cfactor(i)=1-eff(i);						%cfactor=1-effic_catalyst
    end
    %Fuel req'd if no motor(or max engine), adjust for hot/cold engine
    if Treq>interp1(fc_map_spd,fc_max_trq*fc_trq_scale,wreq)
        Treq_fc=interp1(fc_map_spd,fc_max_trq*fc_trq_scale,wreq);
    elseif Treq<min(fc_map_trq*fc_trq_scale)
        Treq_fc=min(fc_map_trq*fc_trq_scale);
    else Treq_fc=Treq; end
    Jfuel_req=fc_fuel_lhv*interp2(Trq,Spd,fc_fuel_map*fc_spd_scale*fc_trq_scale,Treq_fc,wreq);
    Jfuel_req=Jfuel_req*(1+coeff(1)*lambda^expon(1));
    
    %Loop over all possible motor torque scenarios
    %Fuel used
    Jfuel=JfuelSOC;
    for j=1:n
        Tfc=Treq-tc_mc_to_fc_ratio*Torque_m(j);
        %Limit torque to be within map space
        Tfc=min(Tfc,interp1(fc_map_spd,fc_max_trq*fc_trq_scale,wreq));  %Tfc < max
        Tfc=max(Tfc,min(fc_map_trq*fc_trq_scale));                      %Tfc > min
        %Find fuel used and emissions at fuel converter
        if Torque_m(j)<=Treq/tc_mc_to_fc_ratio*1.03 & Torque_m(j)>=Treq/tc_mc_to_fc_ratio*.97	%case where motor supplies all of the torque
            if debugdisp,disp(['All torque coming from motor']),end
            Jfuel(j)=0;
            HC(j)=0;
            CO(j)=0;
            NOx(j)=0;	%NOx and PM most important
            PM(j)=0;
        else
            %Emissions
            if calculate_index(2),HC(j)=interp2(Trq,Spd,fc_hc_map*fc_spd_scale*fc_trq_scale,Tfc,wreq);end
            if calculate_index(3),CO(j)=interp2(Trq,Spd,fc_co_map*fc_spd_scale*fc_trq_scale,Tfc,wreq);end
            if calculate_index(4),NOx(j)=interp2(Trq,Spd,fc_nox_map*fc_spd_scale*fc_trq_scale,Tfc,wreq);end
            if calculate_index(5),PM(j)=interp2(Trq,Spd,fc_pm_map*fc_spd_scale*fc_trq_scale,Tfc,wreq);end
            
            %Correct emis for hot/cold engine
            %variables={'Jfuel','HC','CO','NOx','PM'};
            for i=2:length(variables)
                if calculate_index(i)
                    %efactor=(1+coeff*lambda^expon)
                    eval([variables{i} ,'(j)=',variables{i},'(j)*',num2str(efactor(i)),';']);
                end
            end
            
            %Correct emissions for catalyst efficiency =f(temp)
            %variables2={'HC','CO','NOx','PM'};	%TailpipeEmis=EngineOut*(1-effic_cat)
            for i=1:length(variables2)
                if calculate_index(i+1)
                    breakthrough=eval([variables2{i} '(j)'])-ex_cat_lim(i); %cfactor=1-effic_catalyst
                    eval([variables{i} ,'(j)=',variables{i},'(j)*',num2str(cfactor(i)),';']);
                    if breakthrough>eval([variables2{i} '(j)'])	%emissions can't be lower than breakthrough limits
                        eval([variables2{i} '(j)=breakthrough;'])
                    end
                end
            end
            
        end
        
        %Effective energy used by motor
        %%Find Delta SOC from using motor
        DeltaSOC_init=interp1(Torque_m,DeltaSOC,Torque_m(j))-DeltaSOC_regen; %need to subtract regen Dsoc (was added above)        
        %DeltaSOC_init=DeltaSOC(j)-DeltaSOC_regen; %need to subtract regen Dsoc (was added above)
        s=sign(DeltaSOC_init);
        if debugdisp,disp(['Sign of DeltaSOC: ',num2str(s)]),end
        %Find total fuel used to replace Dsoc and fullfill Treq
        Jused=interp1(DeltaSOC,JfuelSOC,-1*DeltaSOC_init);
        if debugdisp,disp(['Jused1: ',num2str(Jused)]),end
        if isnan(Jused) %case where current conditions couldn't replace Dsoc
            if s<0
                ratio=abs(DeltaSOC_init/max(DeltaSOC)*1.02);
                if debugdisp,disp(['ratio: ',num2str(ratio)]),end
                Jused=ratio*interp1(DeltaSOC,JfuelSOC,-1*DeltaSOC_init/ratio);
            elseif s>0
                ratio=abs(DeltaSOC_init/min(DeltaSOC)*1.02);
                if debugdisp,disp(['ratio: ',num2str(ratio)]),end
                Jused=ratio*interp1(DeltaSOC,JfuelSOC,-1*DeltaSOC_init/ratio);
            elseif s==0
                ratio=0;	%no change in Dsoc for given torque, so no Jused
                Jused=0;
            end
        end
        if isnan(Jused) %case where DeltaSOC range didn't cross zero 
            Jused=1E5;	%(e.g. request is very close or greater than Tmax engine)
        end
        if debugdisp,disp(['Jused2: ',num2str(Jused)]),end
        %Reference energy is J used to fullfill Treq
        Jmotor(j)=scale*(Jused-Jfuel_req);
        
        %Total Energy consumed (effectively)
        Energy(j)=Jfuel(j)+Jmotor(j);	%total energy consumed 
        Torque_fc(j)=Tfc;					%track torque from fuel converter
        
    end
    if debug,assignin('base','Out2',[Energy' Jmotor' Torque_m' Jfuel' HC']);end %HC' CO' NOx' PM'
    
    %Define Performance function (function of energy used and emissions)
    %Adjust energy and emissions to vary between 0 and 1
    vars={'Energy','HC','CO','NOx','PM'};
    stds=[mpg_desired hc_desired co_desired nox_desired pm_desired];	%units are (mpg gpm gpm gpm gpm)
    %change standards into appropriate units (J/s g/s g/s g/s g/s)
    stds(1)=fc_fuel_den*fc_fuel_lhv*mphr/(3600*.264172*stds(1))+eps;	%.264172 gal/liter converts mpg to J/s,add eps for 0 mphr cases
    for i=2:length(stds)
        stds(i)=stds(i)*mphr/3600+eps;	%conver gpm to gps, add eps for 0 mphr cases
    end
    if weightmax
        %Normalized variables (0-1)
        for i=1:length(vars)	%new names are Energy_adj, etc. Adj_value=Orig_value-min_value/range of values;
            if calculate_index(i)
                eval([vars{i},'_adj=[',num2str((eval(vars{i})-min(eval(vars{i})))/(max(eval(vars{i}))-min(eval(vars{i})))),'];']);
                %define K_stds as a vector (length=5) that will weight the adjusted values K_std=max_value/standard_value
                K_stds(i)=max(eval(vars{i}))/stds(i);
            end
        end
        if mphr==0,K_stds=[1 1 1 1 1];,end
    elseif weightraw
        %Raw variables / desired or standards value
        for i=1:length(vars)	%new names are Energy_adj, etc. Adj_value=Orig_value/standard;
            if calculate_index(i)
                eval([vars{i},'_adj=[',num2str(eval(vars{i})/stds(i)),'];']);
            end
        end
        K_stds=[1 1 1 1 1];
    end
    
    %Performance function, range is from 0 to 1
    den=0;
    num=zeros(size(Energy_adj));
    K_user=[K_Energy K_Emis];	%K weightings defined by the user
    %also have K_stds computed above
    for i=1:length(vars)	%
        if calculate_index(i)
            num=num+K_user(i)*K_stds(i)*eval([vars{i} '_adj']);
            den=den+K_user(i)*K_stds(i);
        end
    end
    performance=num/den;
    
    %Minimize performance function to minimze energy and emissions
    %curvefit on performance
    Torque_mfine=Tm_init:-dT/1000:(Tm_init-(n-1)*dT);
    [p,s]=polyfit(Torque_m,performance,5);
    performance_fine=polyval(p,Torque_mfine);
    index=find(performance_fine==min(performance_fine));
    Tmotor_choice=Torque_mfine(index);
    Tfc=Treq-tc_mc_to_fc_ratio*Tmotor_choice;   %final torque required of fuel converter
    Perf=performance_fine(index);
    Tfc_perf=[Tfc Perf];
end
if debug,
    assignin('base','performance',[performance]);%debug purposes, delete later
    assignin('base','performance_fine',[performance_fine]);%debug purposes, delete later
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass variables of interest back to ADVISOR
sys = [Tfc_perf];

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotperformance
    if evalin('base','~exist(''firstplot'')'),
        h=figure('visible','off');
        %_______set the figure size by defining vinf.gui_size and then setting the size
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            figsize=[(screensize(3)-560)/2 (screensize(4)-420)/2 560 420];
        else
            figsize=[1    29   800   534];
        end
        
        set(h,'units','pixels','position',figsize,'visible','on');
        %_____________end set the figure size
        evalin('base','firstplot=0;');
    end
    max_motor=mc_T; %min Nm for motor plot
    %Performance function
    hold off;
    plot(Torque_m,performance,'bx'); %performance function
    %added for fine performance
    hold on;
    plot(Torque_mfine,performance_fine,'k');
    legstr=strvcat('Impact','Impact curve fit');
    colors={'r:','k:','g:','m:','c:'};
    %colors={'k*:','kd:','ko:','ks:','kv:'}; %black only
    for i=1:length(vars)	%new names are Energy_adj, etc.
        if calculate_index(i)
            plot(Torque_m,eval([vars{i},'_adj']),colors{i});
            legstr=strvcat(legstr,[vars{i},' ',num2str(round(K_user(i)*K_stds(i)*10)/10),'x']);
        end
    end
    %plot(Torque_mfine(index),performance_fine(index),'kx'); %chosen operation point
    plot(Torque_mfine(index),performance_fine(index),'r*'); %chosen operation point
    %text(Torque_mfine(index)*1.15,performance_fine(index)*1.15,'Operation Point','Color','k');
    if weightmax,axis([-max_motor max_motor 0 1]);,
    elseif weightraw, axis([-max_motor max_motor -inf inf]); end
    %%added for fine performance
    %plot(Torque_mfine,performance_fine,'k');
    xlabel('Torque supplied by motor (Nm)');
    ylabel('Impact');
    title(['Impact T_r_e_q= ',num2str(round(Treq)),...
            ' Nm, w_r_e_q= ',num2str(round(wreq)),' rad/s (',num2str(round(wreq*30/pi)),' rpm)']);
    legend(legstr,-1);
    drawnow
    
elseif plotalloutput
    if evalin('base','~exist(''firstplot'')'),
        h=figure('visible','off');
        %_______set the figure size by defining vinf.gui_size and then setting the size
        screensize=get(0,'screensize'); %this should be in pixels(the default)
        if screensize(3)>=1024
            figsize=[(screensize(3)-900)/2 (screensize(4)-650)/2 900 650];
        else
            figsize=[1    29   800   534];
        end
        
        set(h,'units','pixels','position',figsize,'visible','on');
        %_____________end set the figure size
        evalin('base','firstplot=0;');
    end
    max_motor=mc_T; %min Nm for motor plot
    
    %Performance function
    subplot(3,2,1)
    hold off;
    plot(Torque_m,performance,'bx-'); %performance function
    legstr=['Impact'];
    hold on;
    %vars={'Energy','NOx','PM','HC','CO'};
    colors={'r:','k:','g:','m:','c:'};
    for i=1:length(vars)	%new names are Energy_adj, etc.
        if calculate_index(i)
            plot(Torque_m,eval([vars{i},'_adj']),colors{i});
            legstr=strvcat(legstr,[vars{i},' ',num2str(round(K_user(i)*K_stds(i)*10)/10),'x']);
        end
    end
    plot(Torque_mfine(index),performance_fine(index),'r*'); %chosen operation point
    text(Torque_mfine(index),performance_fine(index)*1.05,'Operation Point','Color','r');
    if weightmax,axis([-max_motor max_motor 0 1]);,
    elseif weightraw, axis([-max_motor max_motor -inf inf]); end
    xlabel('Torque supplied by motor (Nm)');
    ylabel('Impact');
    title('Impact (weight of energy and emissions)');
    h=legend(legstr,-1);
    %set(h,'Fontsize',6);
    
    %Energy used
    %redo index for plotting
    index=min(find(Torque_mfine(index)>=Torque_m));
    subplot(3,2,2),
    hold off;
    plot(Torque_m,Energy,'b'); %total energy
    hold on;
    plot(Torque_m,Jfuel,'k.'); %fc energy
    plot(Torque_m,Jmotor,'gd'); %motor energy
    [p,s]=polyfit(Torque_m,Energy,3);
    Energy_fine=polyval(p,Torque_mfine);
    plot(Torque_mfine(index),Energy_fine(index),'r*');
    text(Torque_mfine(index),Energy_fine(index)*1.05,'OP','Color','r');
    axis([-100 100 min([Jfuel Energy Jmotor])-.5*Energy(end) 1.2*max([Jfuel Energy Jmotor])]);
    xlabel('Torque supplied by motor (Nm)');
    ylabel('Energy (J)');
    title(['T_r_e_q= ',num2str(round(Treq)),' Nm, w_r_e_q= ',num2str(round(wreq*30/pi)),' rpm']);
    legend('Total Energy','Engine','Motor',-1); %'0' places legend in place with least data conflict
    
    %Plot on engine map
    subplot(3,2,3),
    hold off;
    plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx-'); %max torque envelope
    hold on;
    %%%%%% plot efficiency map and torque envelope
    V=[.15 .25 .3 .35];
    c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_eff_map',V);
    clabel(c,V)
    ylabel('Engine Trq (Nm)')
    xlabel('Speed (rpm)')
    plot(wreq*30/pi,Tfc,'r*');
    text(wreq*30/pi,Tfc*1.05,['OP T=',num2str(round(Tfc))],'Color','r');
    axis([min(fc_map_spd*30/pi)*0 max(fc_map_spd*30/pi) min(fc_map_trq) max(fc_map_trq)]);
    text(.5*(max(fc_map_spd*30/pi)-min(fc_map_spd*30/pi)),.5*(max(fc_map_trq)-min(fc_map_trq)),'Effic (%)');
    
    %Plot on motor map
    subplot(3,2,4),
    hold off;
    plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale,'kx-'); %max torque envelope
    hold on;
    %%%%%% plot efficiency map and torque envelope
    V=[.75 .8 .85 .9];
    c=contour(mc_map_spd*30/pi*mc_spd_scale,mc_map_trq*mc_trq_scale,mc_eff_map',V);
    clabel(c,V)
    ylabel(['Motor Trq (Nm) Ratio=',num2str(tc_mc_to_fc_ratio)])
    xlabel('Speed (rpm)')
    plot(wmotor*30/pi,Torque_m(index),'r*');
    text(wmotor*30/pi,Torque_m(index)*1.05,['OP T=',num2str(round((Treq-Tfc)/tc_mc_to_fc_ratio))],'Color','r');
    axis([min(mc_map_spd*30/pi) max(mc_map_spd*30/pi) -max_motor max_motor]);
    
    %Plot on NOx map
    if calculate_index(4)
        fc_nox_map_gpkWh=evalin('base','fc_nox_map_gpkWh');
        subplot(3,2,5),
        hold off;
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx-'); %max torque envelope
        hold on;
        %%%%%% plot efficiency map and torque envelope
        V=[2 4 6 8 10];
        c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_nox_map_gpkWh',V);
        clabel(c,V)
        ylabel('Engine Trq (Nm)')
        xlabel('Speed (rpm)')
        plot(wreq*30/pi,Tfc,'r*');
        text(wreq*30/pi,Tfc*1.05,'OP','Color','r');
        axis([min(fc_map_spd*30/pi)*0 max(fc_map_spd*30/pi) min(fc_map_trq) max(fc_map_trq)]);
        text(.5*(max(fc_map_spd*30/pi)-min(fc_map_spd*30/pi)),.5*(max(fc_map_trq)-min(fc_map_trq)),'NOx (gpkWh)');
    end
    
    %Plot on PM map
    if calculate_index(5)
        fc_pm_map_gpkWh=evalin('base','fc_pm_map_gpkWh');
        subplot(3,2,6),
        hold off;
        plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'kx-'); %max torque envelope
        hold on;
        %%%%%% plot efficiency map and torque envelope
        V=[.2 .4 .6 .8 1];
        c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,fc_pm_map_gpkWh',V);
        clabel(c,V)
        ylabel('Engine Trq (Nm)')
        xlabel('Speed (rpm)')
        plot(wreq*30/pi,Tfc,'r*');
        text(wreq*30/pi,Tfc*1.05,'OP','Color','r');
        axis([min(fc_map_spd*30/pi)*0 max(fc_map_spd*30/pi) min(fc_map_trq) max(fc_map_trq)]);
        text(.5*(max(fc_map_spd*30/pi)-min(fc_map_spd*30/pi)),.5*(max(fc_map_trq)-min(fc_map_trq)),'PM (gpkWh)');
    end
    
    drawnow
    
end
% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

%Could later use this to specify time step of Saber
sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
evalin('base','clear firstplot');

sys = [];

% end mdlTerminate

%%%%%%%%%%%%%%%%%%
%Revision history
%12/04/98: vhj file created
% 5/11/99: vhj moved reverse_energy to subfunction, added functionality from energy_loop4,
%			changed charging break to min(DeltaSOC)<-1*DeltaSOC_init
%			begin incrementing Tm for Dsoc interpolation at T=0
%			0mphr cases for stds, moved DeltaSOC vs JfuelSOC from subfunction into main function (only calculate once)
% 5/12/99: vhj elminated subfunction, Jfuel=nan fixed (SOC not crossing zero), Dsoc for sign==0 fixed
% 5/13/99: vhj moved plotting to separate plot function, plot_min_energy
% 5/17/99: vhj added case for Jfuel_req if Treq>max trq (accel cases), dT<0 case
% 5/18/99: vhj changed weighting to K_user*raw value/desired value
% 7/15/99: vhj added 2nd output of performance, used 3rd order polyfit to find minimum of performance, 
%				  added average mph to determine gpm/fuel economy
% 8/17/99: vhj changed scale--can't be zero ever, changed name of Performance to Impact
%01/05/00: vhj added Tess, debug
%01/06/00: vhj added acc_elec_pwr to block diagram, 1/(# pts-1)=1/9 
%10/25/00: vhj renamed to min_energy9, add checks to see if the emissions maps exist, changed plotting, calculations accordingly
%					changed 'fine' curve fit to be 5th order
%01/25/01: vhj added 3% tolerance to case where motor supplies all of the torque, pre-define a motor torque vector and use values
%               in that vector for evaluation points, limited trq req for Jfuel_req to be lower limit of torque map (fc_map_trq)
%01/26/01: vhj limited Tfc to fall within map range, added 2% to ratio if 'replacement SOC' falls outside of DeltaSOC curve
%01/29/01: vhj converted to S-function
%01/29/01: vhj updated location of plots, axis on FC effic and NOx and PM
%01/30/01: vhj updated fuel & emission correction factors for cold-hot relationship
%02/09/01: vhj updated plot location to middle of screen