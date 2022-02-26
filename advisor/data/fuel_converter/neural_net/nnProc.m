function out=nnProc(spd, trq, time, nnFuncs, outputNames, outputUnits)
% nnProc.m neural network processor for WVU Nerual Net emissions models
%
% out=nnProc(spd, trq, time, nnFuncs, outputNames, outputUnits)
% 
% spd is angular shaft speed in revolutions per minute
% trq is shaft torque in Nm
% time is the time signal in seconds corresponding to the speed and torque signals
% args is an structure with args.name and args.values (both cell arrays)
% argFuncs is an array of function handles for preprocessing
% modelNames are the names of the neural net functions to call
% outputNames are names of the fields of out to assign
% outputUnits are names of the units of the fields in out
%
% out is a structure with fields equal to the outNames and field units of outNames with '_units' appended
%
% e.g., 
% spd=[500:520]; % rpm
% trq=[300:320]; % Nm
% t=[0:20]; % sec
% nnFuncs=[@cumminsCO,@cumminsCO2,@cumminsNOx];
% outNames={'CO','CO2','NOx'};
% outUnits={'g/s','g/s','g/s'};
% out=nnProc(spd, trq, t, nnFuncs, outNames, outUnits)

try
    spd=makeRowArray(spd);
catch
    error('[nnProc.m]: spd array is not correct--please check inputs and try again')
end
try
    trq=makeRowArray(trq);
catch
    error('[nnProc.m]: trq array is not correct--please check inputs and try again')
end
try
    time=makeRowArray(time);
catch
    error('[nnProc.m]: time array is not correct--please check inputs and try again')
end
if length(nnFuncs)~=length(outputNames)&length(nnFuncs)~=length(outputUnits)
    error('[nnProc.m]: outputNames, outputUnits, and nnFuncs must all be of the same length')
end

dsdt_05sec=d_dt(spd, time, 5.0); % dspd/dt taken at  5 sec intervals
dsdt_10sec=d_dt(spd, time, 10.); % dspd/dt taken at 10 sec intervals
dTdt_05sec=d_dt(trq, time, 5.0); % dtrq/dt taken at  5 sec intervals
dTdt_10sec=d_dt(trq, time, 10.); % dtrq/dt taken at 10 sec intervals
% save ddt_sigs dsdt_05sec dsdt_10sec dTdt_05sec dTdt_10sec; % used for debugging

out=[];
for i=1:length(nnFuncs)
    out=setfield(out, outputNames{i}, feval(nnFuncs(i), [spd; dsdt_05sec; dsdt_10sec; trq; dTdt_05sec; dTdt_10sec]));
    out=setfield(out, [outputNames{i},'_units'], outputUnits{i});
end
%[spd; dsdt_05sec; dsdt_10sec; trq; dTdt_05sec; dTdt_10sec] % used for debugging
%out=cumminsCO([spd; dsdt_05sec; dsdt_10sec; trq; dTdt_05sec; dTdt_10sec]) % used for debugging

function out=d_dt(y,t,tshift)
tsig=t-tshift;
indexLo=find((tsig)<t(1));
indexHi=find((tsig)>t(end));
tsig(indexLo)=t(1); % extrapolate using nearest neighbor
tsig(indexHi)=t(end); % extrapolate using nearest neighbor

yshift=interp1(t, y, tsig,'linear', 'extrap');

out=(y-yshift)./tshift;

function out=makeRowArray(x)
[r,c]=size(x);
if c>=r & r==1
    out=x;
    return
elseif c==1
    out=x';
    return
else
    error('input variable must be an array');
end

% Revision History
% YYYY-MM-DD [init] Comments
% 2002-04-09 [mpo] file created for work with WVU Neural Network Models (mex functions)