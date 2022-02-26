function [u]=pause_time(last_real_t,clock_t_in,last_clock_t,time_gain);

real_t=now;
time_diff=(real_t-last_real_t)*100000;
clock_diff=(clock_t_in-last_clock_t);

if time_gain>0
	pause_t=(clock_diff-time_diff)/time_gain;
else
   pause_t=0;
end

if pause_t>0
     pause(pause_t);
end
real_t=now;
clock_t=clock_t_in;
u(1)=real_t;
u(2)=clock_t;
