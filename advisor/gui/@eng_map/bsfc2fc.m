function fc = bsfc2fc(em, trq, spd, bsfc)
% fc = bsfc2fc(em, trq, spd, bsfc)--break specific fuel consumption (g/kWh) to fuel consumption (g/s)

[T,w]=meshgrid(trq,spd); % torque and speed
pow=T.*w/1000; % kW
fc=bsfc.*pow*(1/3600); % (g/s)
