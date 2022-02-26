function [sum_error]=peuk_error(C_exp)

global data
sum_error=0;
for i=1:length(data(:,1))
   sum_error=sum_error+abs(C_exp(1)*data(i,1)^C_exp(2)-data(i,2));
end
