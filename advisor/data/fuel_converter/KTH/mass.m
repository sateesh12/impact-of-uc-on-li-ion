% Calculates mass of hydrogen in vessel after time t

function [m] = mass (mf,t)

m0=5000;		% [g] initial mass of hydrogen

m=m0-mf*t; 	% [g] mass of hydrogen in pressure vessel