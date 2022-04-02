% Author : Sateesh Kalidas
% Date   : 26/Mar/2022
% Purpose: Plot FFT
fs = 10000;
n = length(tigor_ev_cy_udds_array);          % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(y).^2/n;    % power of the DFT

plot(f,power)
xlabel('Frequency')
ylabel('Power')