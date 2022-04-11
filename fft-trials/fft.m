%Author  : Sateesh Kalidas
%Date    : 27/Mar/2022
%Purpose : FFT an e.g.

Fs = 1000;    % Sampling frequency
T = (1/Fs);   % Period
L = 1500;     % Lenght of signal
t= (0:L-1)*t; % Time stamp vector


% Create a signal
S = 0.7 * sin(2*pi*50*t) + sin(2*pi*120*t);
plot(100*t(1:50),S(1:50));