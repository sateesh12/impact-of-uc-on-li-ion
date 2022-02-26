function [obj]=obj_fun(x,varargin)

time=varargin{1}{1};
voltage=varargin{1}{2};
idx1=varargin{1}{3};
idx4=varargin{1}{4};

% update workspace
assignin('base','re',x(1));
assignin('base','rc',x(2));
assignin('base','rt',x(3));
assignin('base','cb',x(4));
assignin('base','cc',x(5));

%run a simulation
evalin('base',['sim(''create_rc_params_Preq'');']);

%Compute Error
t=evalin('base','t');pb_voltage=evalin('base','pb_voltage');
pb_voltage4e=interp1(t,pb_voltage,time(idx1+1:idx4-1));   %voltage for error calculation
%perror=abs(voltage(idx1+1:idx4-1)-pb_voltage4e)./voltage(idx1+1:idx4-1)*100;
%Make objected weighted against overshooting the voltage
perror=(voltage(idx1+1:idx4-1)-pb_voltage4e)./voltage(idx1+1:idx4-1)*100;
%overshoot_ind=find(perror>0);
%perror(overshoot_ind)=perror(overshoot_ind)*20; %weigh the overshoot by a factor of 20
perror=abs(perror);
avg_perror=mean(perror);
max_perror=max(perror);

% return results
%obj=(avg_perror*5+max_perror)/6;
obj=avg_perror;
con=max_perror;
assignin('base','con',con);

return

%Revision history
%03/21/01: vhj changed ojbective function to be weighted against overshooting the voltage
%03/22/01: vhj call create_rc_params_Preq