function [sys,x0,str,ts] = sfunsinda(t,x,u,flag,sindafile)
%function [sys,x0,str,ts] = sfunsinda(t,x,u,flag)

persistent FirstCall

% Determine if it is the beginning of the simulation
if (flag == 0) & isempty(FirstCall)
    FirstCall = 1;
elseif flag == 9
    FirstCall=[];
else
    FirstCall=0;
end
%
% Original File is SFUNTMPL:
% SFUNTMPL General M-file S-function template
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
%   $Revision: 1.2 $

%
% The following outlines the general structure of an S-function.
%
global sindacontrol;
switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
case 0,
    %[sys,x0,str,ts]=mdlInitializeSizes;
    [sys,x0,str,ts]=mdlInitializeSizes(sindafile, FirstCall);
    
    %%%%%%%%%%%%%%%
    % Derivatives %
    %%%%%%%%%%%%%%%
case 1,
    sys=mdlDerivatives(t,x,u);
    
    %%%%%%%%%%
    % Update %
    %%%%%%%%%%
case 2,
    sys=mdlUpdate(t,x,u);
    
    %%%%%%%%%%%
    % Outputs %
    %%%%%%%%%%%
case 3,
    sys=mdlOutputs(t,x,u);
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % GetTimeOfNextVarHit %
    %%%%%%%%%%%%%%%%%%%%%%%
case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);
    
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
%function [sys,x0,str,ts]=mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes(sindafile,FirstCall)
'in init'
%
if FirstCall
    %sindafile='C:\MATLAB6p1\work\acc&rtjhinter3exo.sin';
    sindacontrol=actxserver('Sfserver.SFController')
    disp(['[sfunsinda:mdlInitializeSizes]: path for SindaFluint *.sin file is:']);
    disp(['[sfunsinda:mdlInitializeSizes]: ', sindafile]);
    sindav=invoke(sindacontrol, 'runSF', sindafile, 'pp.out')
    % OLD VALUE of sindafile is 'e:\SindapsPlus4.3\images\SFMatLab\acc&rtjh3ex.sin'
    %
    vcon = 0.0
    cnt=0;
    MAXCNT=180;
    while vcon < 1.0 & cnt<MAXCNT
        pause (1.0)
        vcon=get(sindacontrol, 'atWait')
        cnt=cnt+1;
    end
    %
    sindav=invoke(sindacontrol, 'continueSF')
end
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
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
sys(7) = 1
ts  = [-1 0]

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)
'in update'
sindacontrol=actxserver('Sfserver.SFController')
%sinda commands here
u(1)
u(2)
u(3)
u(4)
u(5)
v = set(sindacontrol, 'floatRegister', 'Vspeed', u(1));
v = set(sindacontrol, 'floatRegister', 'Erpm', u(2));
v = set(sindacontrol, 'floatRegister', 'AdvTsp', u(3));
v = set(sindacontrol, 'floatRegister', 'Qpass', u(4));
v = set(sindacontrol, 'floatRegister', 'Tamb', u(5));
sindav=invoke(sindacontrol, 'continueSF')

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
'in outputs'
sindacontrol=actxserver('Sfserver.SFController');
%sinda command with inputs
%
% clear y; % clear y if for some reason it exists already
y(1) = get(sindacontrol, 'floatRegister', 'ComPwr');
y(2) = get(sindacontrol, 'floatRegister', 'Tcabin');
y(3) = get(sindacontrol, 'floatRegister', 'CPwrAve');
y(4) = get(sindacontrol, 'floatRegister', 'PwrAve');
y(5) = get(sindacontrol, 'floatRegister', 'EvQAve');
y=double(y); % this ensures that y is converted to type double, which matlab uses
%sys =[y(1),	y(2)];
% clear sys; % clear sys if for some reason it exists already
sys=[y(1); y(2); y(3); y(4); y(5)] % output sys as a column array of 5 rows
% length(sys)
% if size(sys)~=[5,1]
%     clear sys;
%     sys=zeros(5,1);
%     'WARNING! value of sys is bogus'
% end
% keyboard
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

sys = [];

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
'in terminate'
sindacontrol=actxserver('Sfserver.SFController')
sindav=invoke(sindacontrol, 'continueSF')
y(1) = get(sindacontrol, 'floatRegister', 'ComPwr')
y(2) = get(sindacontrol, 'floatRegister', 'Tcabin')
%sys =[y(1),	y(2)];


sys = [];
delete(sindacontrol)
%release ('sindacontrol')

% end mdlTerminate
