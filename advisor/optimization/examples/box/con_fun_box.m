function [con,con_e]=con_fun(x,varargin)

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

con=V;

% matlab only
if length(varargin)>3
    for i=1:length(con)
        if varargin{4}(i)>-1e29
            con(i)=varargin{4}(i)-con(i);
        elseif varargin{5}(i)<1e29
            con(i)=con(i)-varargin{5}(i);
        end
    end
end
con_e=0;
% ****

return
