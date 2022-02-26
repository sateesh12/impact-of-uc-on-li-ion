function bsfc = eff2bsfc(em, fuel_lhv, eff)
% bsfc = eff2bsfc(em, fuel_lhv, eff)--efficiency to break specific fuel consumption (g/kWh)

bsfc=1./(eff*fuel_lhv/1000/3600);