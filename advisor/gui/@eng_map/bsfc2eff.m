function eff = bsfc2eff(em, bsfc, fuel_lhv)
% eff = bsfc2eff(em, bsfc, fuel_lhv)--break specific fuel consumption (g/kWh) to efficiency

eff=1./(bsfc*fuel_lhv/1000/3600);