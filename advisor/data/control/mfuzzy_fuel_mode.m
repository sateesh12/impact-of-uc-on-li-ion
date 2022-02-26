% ADVISOR data file:  mfuzzy_fuel_mode.m
%
% Data confirmation:
%
% Notes:
% Fuzzy Logic control strategy
% This file takes in 2 inputs (Torque and SoC) and gives out 1 output (ICE Torque)
% This file is for the fuel-use mode. (see help files for more information.)
% 
% Created on: 21-July-2001
% By:  AR, NREL, arun_rajagopalan@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u]=mfuzzy_fuel_mode(torque,soc)

% Membership functions
% Input 11x11
% Output 11

% Set the scaling gains for Each membership function
% Inputs
soc_scale=1;
torque_scale=1;
% Output
ice_scale=1;

% The rule base is entered below:
% The rule base is vertically indexed by Torque, and horizontally by SoC

% FULE USE MODE
rule=[6 5 5 4 3 3 2 2 2 1 1;...
      6 5 5 4 3 3 2 2 2 1 1;...
      6 5 5 4 4 3 3 2 2 2 1;...
      6 5 5 4 4 3 3 3 2 2 2;...
      6 5 5 4 4 4 3 3 3 2 2;...
      6 6 6 5 4 4 4 3 3 2 2;...
      6 6 6 5 5 4 4 3 3 3 2;...
      6 6 6 6 5 5 4 3 3 3 2;...
      6 6 6 6 6 5 4 4 4 3 3;...
      6 6 6 6 6 5 5 4 4 4 3;...
      6 6 6 6 6 5 5 5 4 4 4];
   
%  Define membership functions
mf_soc_min(1)=1*soc_scale;      	% Low SoC 
mf_soc_max(1)=2*soc_scale;        	%
mf_soc_min(2)=1*soc_scale;        	%
mf_soc_max(2)=3*soc_scale;       	%
mf_soc_min(3)=2*soc_scale;        	%   SOC MEMBERSHIP FUNCTION DEFINITION (INPUT)
mf_soc_max(3)=4*soc_scale;       	%
mf_soc_min(4)=3*soc_scale;        	%
mf_soc_max(4)=5*soc_scale;       	%
mf_soc_min(5)=4*soc_scale;        	%
mf_soc_max(5)=6*soc_scale;        	%
mf_soc_min(6)=5*soc_scale;        	%
mf_soc_max(6)=7*soc_scale;        	%
mf_soc_min(7)=6*soc_scale;        	%
mf_soc_max(7)=8*soc_scale;        	%
mf_soc_min(8)=7*soc_scale;        	%
mf_soc_max(8)=9*soc_scale;        	%
mf_soc_min(9)=8*soc_scale;        	%
mf_soc_max(9)=10*soc_scale;        	%
mf_soc_min(10)=9*soc_scale;        	%
mf_soc_max(10)=11*soc_scale;        	%
mf_soc_min(11)=10*soc_scale;        	%
mf_soc_max(11)=11*soc_scale;       	% High SoC

mf_torque_min(1)=1*torque_scale;      	% Low torque
mf_torque_max(1)=2*torque_scale;        	%
mf_torque_min(2)=1*torque_scale;        	%
mf_torque_max(2)=3*torque_scale;       	%
mf_torque_min(3)=2*torque_scale;        	%   TORQUE MEMBERSHIP FUNCTION DEFINITION (INPUT)
mf_torque_max(3)=4*torque_scale;       	%
mf_torque_min(4)=3*torque_scale;        	%
mf_torque_max(4)=5*torque_scale;       	%
mf_torque_min(5)=4*torque_scale;        	%
mf_torque_max(5)=6*torque_scale;        	%
mf_torque_min(6)=5*torque_scale;        	%
mf_torque_max(6)=7*torque_scale;        	%
mf_torque_min(7)=6*torque_scale;        	%
mf_torque_max(7)=8*torque_scale;        	%
mf_torque_min(8)=7*torque_scale;        	%
mf_torque_max(8)=9*torque_scale;        	%
mf_torque_min(9)=8*torque_scale;        	%
mf_torque_max(9)=10*torque_scale;        	%
mf_torque_min(10)=9*torque_scale;        	%
mf_torque_max(10)=11*torque_scale;       %
mf_torque_min(11)=10*torque_scale;       	%
mf_torque_max(11)=11*torque_scale;       	% High Torque

mf_ice_min(1)=0*ice_scale;      	% Low ICE Torque
mf_ice_max(1)=2*ice_scale;        	%
mf_ice_min(2)=1*ice_scale;        	%
mf_ice_max(2)=3*ice_scale;       	%
mf_ice_min(3)=2*ice_scale;        	%   ICE OUTPUT MEMBERSHIP FUNCTION DEFINITION
mf_ice_max(3)=4*ice_scale;       	%
mf_ice_min(4)=3*ice_scale;        	%
mf_ice_max(4)=5*ice_scale;       	%
mf_ice_min(5)=4*ice_scale;        	%
mf_ice_max(5)=6*ice_scale;        	%
mf_ice_min(6)=5*ice_scale;        	%
mf_ice_max(6)=7*ice_scale;        	%
mf_ice_min(7)=6*ice_scale;        	%
mf_ice_max(7)=8*ice_scale;        	%
mf_ice_min(8)=7*ice_scale;        	%
mf_ice_max(8)=9*ice_scale;        	%
mf_ice_min(9)=8*ice_scale;        	%
mf_ice_max(9)=10*ice_scale;        	%
mf_ice_min(10)=9*ice_scale;        	%
mf_ice_max(10)=11*ice_scale;        	%
mf_ice_min(11)=10*ice_scale;        	%
mf_ice_max(11)=12*ice_scale;       	% High ICE Torque

% TO CALCULATE THE CENTERS AND WIDTHS OF THE INPUT MEMBERSHIP FUNCTIONS

for i=1:length(mf_soc_min)
   % FOR SOC
   mf_soc_center(i)=(mf_soc_min(i)+mf_soc_max(i))/2;
   mf_soc_width(i)=abs(mf_soc_min(i)-mf_soc_max(i));
   % FOR TORQUE
   mf_torque_center(i)=(mf_torque_min(i)+mf_torque_max(i))/2;
   mf_torque_width(i)=abs(mf_torque_min(i)-mf_torque_max(i));
end
% ----- END OF FUZZY DEFINITION ------


% -----------------FUZZIFICATION-------------------------

% FINDING MEMBERSHIP FUNCTIONS THAT ARE "ON"
% FINDING PREMISE VALUES (Based on Triangular membership functions)

% ----- SoC INPUT -----

i=1;									% This loop corresponds to the Left 
if(soc<mf_soc_max(i))			% most Saturated Membership function. 
   mf_soc(i)=1;					 
   if(soc<=mf_soc_min(i))		
      mf_soc_value(i)=1;
   else
      mf_soc_value(i)=max(0,(1+((mf_soc_min(i)-soc)/mf_soc_width(i))));
   end
else
   mf_soc(i)=0;
   mf_soc_value(i)=0;
end


for i=2:(length(mf_soc_min)-1)                   	% This loop corresponds to the Membership
   % functions in-between.
   
   if(soc<mf_soc_max(i) & soc>mf_soc_min(i))
      mf_soc(i)=1;
      if(soc<=mf_soc_center(i))
         mf_soc_value(i)=max(0,(1+((soc-mf_soc_center(i))/(0.5*mf_soc_width(i)))));
      else
         mf_soc_value(i)=max(0,(1+((mf_soc_center(i)-soc)/(0.5*mf_soc_width(i)))));
      end
   else
      mf_soc(i)=0;
      mf_soc_value(i)=0;
   end
end

i=length(mf_soc_min);									% This loop corresponds to the Right 
if(soc>mf_soc_min(i))			% most Saturated Membership function.
   mf_soc(i)=1;
   if(soc<=mf_soc_max(i))
      mf_soc_value(i)=max(0,(1+((soc-mf_soc_max(i))/mf_soc_width(i))));
   else
      mf_soc_value(i)=1;
   end
else
   mf_soc(i)=0;
   mf_soc_value(i)=0;
end


% ----- TORQUE  INPUT -------


i=1;									% This loop corresponds to the left
if(torque<mf_torque_max(i))			% most Saturated Membership function.
   mf_torque(i)=1;
   if(torque<=mf_torque_min(i))
      mf_torque_value(i)=1;
   else
      mf_torque_value(i)=max(0,(1+((mf_torque_min(i)-torque)/mf_torque_width(i))));
   end
else
   mf_torque(i)=0;
   mf_torque_value(i)=0;
end

for i=2:(length(mf_soc_min)-1)                     % This loop corresponds to the Membership
   % functions in-between.
   
   if(torque<mf_torque_max(i) & torque>mf_torque_min(i))
      mf_torque(i)=1;
      if(torque<=mf_torque_center(i))
         mf_torque_value(i)=max(0,(1+((torque-mf_torque_center(i))/(0.5*mf_torque_width(i)))));
      else
         mf_torque_value(i)=max(0,(1+((mf_torque_center(i)-torque)/(0.5*mf_torque_width(i)))));
      end
   else
      mf_torque(i)=0;
      mf_torque_value(i)=0;
   end
end

i=length(mf_soc_min);									% This loop corresponds to the right
if(torque>mf_torque_min(i))			% most Saturated Membership function.
   mf_torque(i)=1;
   if(torque<=mf_torque_max(i))
      mf_torque_value(i)=max(0,(1+((torque-mf_torque_max(i))/mf_torque_width(i))));
   else
      mf_torque_value(i)=1;
   end
else
   mf_torque(i)=0;
   mf_torque_value(i)=0;
end

% ------------ RULE BASE MATCHING ----------------

for i=1:length(mf_soc_min)							% Check for the IxJ rules
   for j=1:length(mf_soc_min)
      if(mf_soc(j)==1 & mf_torque(i)==1)
         
         rule_valid(i,j)=1;	% Set rule as valid
         % This helps in reducing 
         % computing time for the rules
         % that are not valid
         % during defuzzification
         
         premise_value(i,j)=min(mf_soc_value(j),mf_torque_value(i)); 
         
         % Using Minimum value of 
         % of individual premises	
      else
         
         rule_valid(i,j)=0;	% Set rule as invalid
         premise_value(i,j)=0;
      end
   end
end

%--------------DEFUZZIFICATION-----------------

% OBTAIN A CRISP OUTPUT

cog1=0;								% numerator variables for 
cog2=0;								% COG calculation

for i=1:length(mf_soc_min)
   for j=1:length(mf_soc_min)
      if(rule_valid(i,j)==1)
         
         % CALCULATE CENTER OF IMPLIED FUZZY SET
         
         center=(mf_ice_max(rule(i,j))+mf_ice_min(rule(i,j)))/2;
         
         % CALCULATE THE AREA UNDER THE IMPLIED FUZZY SET
         
         area=abs((mf_ice_max(rule(i,j))-mf_ice_min(rule(i,j)))*(premise_value(i,j)- (premise_value(i,j)^2)/2));
         
         % Calclates the center of gravity
         
         cog1=cog1+center*area;
         cog2=cog2+area;
      end
	end
end

u=cog1/cog2;	   		% FINAL CRISP OUTPUT

% ---------------- End of Fuzzy Control Code -----------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8/8/01: ar changed rules

