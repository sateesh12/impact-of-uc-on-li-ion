function [C_exp]=find_peuk(current, Ah)
%Finds peukert coeff and exponent that minimizes sum error

global data
%data=[Amps A-hr capacity];
data=[current Ah];

%starting points
coeff=6;
exp=-0.05;

C_exp=fminsearch('peuk_error',[coeff exp]);
disp(['C: ',num2str(C_exp(1)),' Exp: ',num2str(C_exp(2))]);

