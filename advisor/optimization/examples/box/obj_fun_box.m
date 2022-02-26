function obj=obj_fun(x,varargin)

% This is a example of optimizing a cardboard box
%	3 design variables and 2 responses.
%	Design variables:	DV1 = W - width of a cardboard box
%							DV2 = H	- height of a cardboard box
%							DV3 = D	- depth of a cardboard box
%	Responses:		R1 = V	- Volume of a cardboard box
%						R2 = S	- Surface area of a cardboard box.
%
%	Problem: Minimize a surface area in such a way that the volume
%				of a box will be greater than 2.
%


% Extract design variables
W = x(1);
H = x(2);
D = x(3);

% Evaluate responses
V = W*H*D;
S = 2*(H*W + H*D + 2*W*D);

obj=S;

return
