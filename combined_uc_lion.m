%% Battery Parameters
Q    = 30000;       % Battery capacity                     [W*hr]
Vnom = 300;         % Nominal voltage                      [V]
Ri   = 0.001;       % Internal resistance                  [Ohm]
AH   = Q/Vnom;      % Ampere-hour rating                   [hr*A]
V1   = 0.9*Vnom;    % Voltage V1 < Vnom when charge is AH1 [V]
AH1  = AH/2;        % Charge AH1 when no-load volts are V1 [hr*A]
AH0  = 0.7*AH;      % Initial charge                       [hr*A]
SOC0 = 0.7;         % Initial State of Charge              [%]

%% Other Parameters
Ts    = 0.01;       % Fundamental sample time   [s]
Cdc   = 0.001;      % Capacitance               [F]
Vcdc0 = 0.95*Vnom;  % Initial Capacitor voltage [V]
