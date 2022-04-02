%Author  : Sateesh Kalidas
%Date    : 27/Mar/2022
%Purpose : FFT an e.g.

Fs = 1000;    % Sampling frequency
T = (1/Fs);   % Period
L = 1500;     % Lenght of signal
t= (0:L-1)*T; % Time stamp vector


% Create a signal
S = 0.7 * sin(2*pi*50*t) + sin(2*pi*120*t) + 2*rand(size(t));
plot(100*t(1:50),S(1:50));

% Compute FFT of the signal
Y = fft(S);

% Compute two sided spectrum
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1);