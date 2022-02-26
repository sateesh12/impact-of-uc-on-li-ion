%---------------------------------------------------------------
%
% M-file: my.m
% Last modified: 991206 by Kristina Johansson
%----------------------------------------------------------------
%Values for water from "Inledande fluiddynamik", valid for temperatures above 10 C, under 120 C 
%[Ns/m2]

function f=my(T)

if T<10
   y=0;
elseif ((T>=10) & (T<15))
   y=(T-10)/(15-10)*(0.00140-0.001304)+0.001304;
elseif ((T>=15) & (T<20))
   y=(T-15)/(20-15)*(0.001002-0.00140)+0.00140;
elseif ((T>=20) & (T<25))
   y=(T-20)/(25-20)*(0.0008937-0.001002)+0.001002;
elseif ((T>=25) & (T<30))
   y=(T-25)/(30-25)*(0.000798-0.0008937)+0.0008937;
elseif ((T>=30) & (T<35))
   y=(T-30)/(35-30)*(0.0007225-0.000798)+0.000798;      
elseif ((T>=35) & (T<40))
   y=(T-35)/(40-35)*(0.000653-0.0007225)+0.0007225;
elseif ((T>=40) & (T<45))
   y=(T-40)/(45-40)*(0.0005988-0.000653)+0.000653;      
elseif ((T>=45) & (T<50))
   y=(T-45)/(50-45)*(0.000546-0.0005988)+0.0005988;
elseif ((T>=50) & (T<55))
   y=(T-50)/(55-50)*(0.0005064-0.000546)+0.000546;      
elseif ((T>=55) & (T<60))
   y=(T-55)/(60-55)*(0.000466-0.0005064)+0.0005064;      
elseif ((T>=60) & (T<65))
   y=(T-60)/(65-60)*(0.0004355-0.000466)+0.000466;      
elseif ((T>=65) & (T<70))
   y=(T-65)/(70-65)*(0.000404-0.0004355)+0.0004355;      
elseif ((T>=70) & (T<75))
   y=(T-70)/(75-70)*(0.0003799-0.000404)+0.000404;
elseif ((T>=75) & (T<80))
   y=(T-75)/(80-75)*(0.000355-0.0003799)+0.0003799;
elseif ((T>=80) & (T<85))
   y=(T-80)/(85-80)*(0.0003355-0.000355)+0.000355;
elseif ((T>=85) & (T<90))
   y=(T-85)/(90-85)*(0.000315-0.0003355)+0.0003355;
elseif ((T>=90) & (T<95))
   y=(T-90)/(95-90)*(0.0002994-0.000315)+0.000315;
elseif ((T>=95) & (T<100))
   y=(T-95)/(100-95)*(0.000281-0.0002994)+0.00020994;
elseif ((T>=100) & (T<120))
   y=(T-100)/(120-100)*(0.000235-0.000281)+0.000281;
elseif (T>=120)
   y=0;
end;
f=y;