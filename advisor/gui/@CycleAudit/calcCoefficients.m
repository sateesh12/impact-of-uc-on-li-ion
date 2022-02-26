function [aeroC, keC, peC, rrC] = calcCoefficients(cyc, airDensity, CD, FA, M, G, RRC0)
% function [aeroC, keC, peC, rrC] = calcCoefficients(cyc, airDensity, CD, FA, M, G, RRC0)
% calculate the coefficients--these can be time based signals or constants (or a mix)
aeroC=airDensity.*CD.*FA;
keC=M;
peC=M.*G;
rrC=G.*M.*RRC0;