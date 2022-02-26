function bsfc=fc2bsfc(em, trq, spd, fc)
% bsfc=fc2bsfc(trq, spd, fc)-- fuel consumption (g/s) to break specific fuel consumption (g/kWh)

[T,w]=meshgrid(trq,spd); % Torque and Speed
pow=T.*w/1000; % kW
bsfc= (fc*3600)./pow; % (g/kWh)