function newem = diffMap(em, em2)
% newem = diffMap(em, em2)
% This method returns a new engine map that has efficiencies that are the difference between the comparison
% map, em2, and the base map, em. i.e. newem = em-em2

[r,c]=size(em.map_spd);
if r>c & c==1
   spd1=em.map_spd';
else
   spd1=em.map_spd;
end

[r,c]=size(em2.map_spd);
if r>c & c==1
   spd2=em2.map_spd';
else
   spd2=em2.map_spd;
end

[r,c]=size(em.map_trq);
if r>c & c==1
   trq1=em.map_trq';
else
   trq1=em.map_trq;
end

[r,c]=size(em2.map_trq);
if r>c & c==1
   trq2=em2.map_trq';
else
   trq2=em2.map_trq;
end

[r,c]=size(em.max_trq);
if r>c & c==1
   mtrq1=em.max_trq';
else
   mtrq1=em.max_trq;
end

[r,c]=size(em2.max_trq);
if r>c & c==1
   mtrq2=em2.max_trq';
else
   mtrq2=em2.max_trq;
end

mtrqs=[mtrq1, mtrq2];
[fc_map_spd, index] = sort([spd1, spd2]);
for i=1:length(index)
   fc_max_trq(i) = mtrqs(index(i));
end
fc_map_trq = sort([trq1, trq2]);
clear mtrqs;

fc_fuel_lhv = em.fuel_lhv;
for i=1:length(fc_map_spd)
   for j=1:length(fc_map_trq)
      fc_eff_map(i,j)=interp(em,fc_map_spd(i),fc_map_trq(j))-interp(em2,fc_map_spd(i),fc_map_trq(j));
   end
end

newem = eng_map(fc_map_spd,... 
   fc_map_trq,... 
   eff2bsfc(em, fc_fuel_lhv, fc_eff_map),... 
   fc_fuel_lhv,... 
   fc_max_trq); 


