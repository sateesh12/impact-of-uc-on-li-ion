pwr_out_a=(mc_trq_out_a.*mc_spd_out_a).*(mc_trq_out_a<0);
pwr_out_r=(mc_trq_out_r.*mc_spd_out_r)./max(eps,(interp1(wh_fa_dl_brake_mph,wh_fa_dl_brake_frac,mpha))).*(mc_trq_out_r<0);
for i=1:length(pwr_out_r) if pwr_out_r(i)==0 pwr_out_r(i)=1; end; end;
regen_frac1=sum(pwr_out_a./pwr_out_r)/sum(pwr_out_r<0)

regen_frac2=sum(-wh_brake_loss_pwr./pwr_out_r)/sum(pwr_out_r<0)

