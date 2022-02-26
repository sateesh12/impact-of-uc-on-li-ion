% chktrace.m
% Make sure that vehicle meets trace.  If not,
% set missed_trace=1 (true), and set first_miss_index=the lowest index at which
% a miss occurs.
%

mphtol=2;
timetol=2;	% in units of step #'s
missed_trace=0;
first_miss_index=1000000;

mphdiff=mpha-cyc_mph_r;

misses=find(abs(mphdiff)>mphtol);

% don't count misses where gear number has just changed

if ~exist('gear_ratio')
   % first, find all spots with new gears
   clear gearnum;
   for i=1:length(gear_ratio) %need to create variable gearnum
      if gear_ratio(i)==gb_ratio(1)
         gearnum(i)=1;
      elseif gear_ratio(i)==gb_ratio(2)
         gearnum(i)=2;
      elseif gear_ratio(i)==gb_ratio(3)
         gearnum(i)=3;
      elseif gear_ratio(i)==gb_ratio(4)
         gearnum(i)=4;
      elseif gear_ratio(i)==gb_ratio(5)
         gearnum(i)=5;
      end
   end
   gearnum=gearnum';
   %disp(['size of gearnum: ',num2str(size(gearnum))]);
   prevgearnum=[1;gearnum(1:length(gearnum)-1)];
   changed_gear=find(prevgearnum~=gearnum);
   misses=find((abs(mphdiff)>mphtol)&(prevgearnum~=gearnum));
else
   misses=find((abs(mphdiff)>mphtol));
end

misses_tmp=[];
for i=1:length(misses)
   if misses(i)>=begin_t(cyc)
      misses_tmp=[misses_tmp; misses(i)];
   end
end
misses=misses_tmp;
clear misses_tmp

for check=misses'
  for ck2=1:timetol-1
    miss(ck2)=~isempty(find(misses==check+ck2));
  end
  if all(miss)
    missed_trace=1;
    first_miss_index=min([first_miss_index;check]);
  end
%disp(['Checking index #',num2str(check)])
end


    
%Revision history
% 9/24/99: ss, if ~exist('gear_ratio') for prius
%11/05/99: tm, redefine misses to have points only after the 'begin_t' for the given cycles