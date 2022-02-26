function val = get(em,prop_name)
% val = get(em,'prop_name')
% GET Get asset properties from the specified object
% and return the value
%
% Possible Inputs for 'prop_name' (enclose in single quotes):
% shaftTorque (Nm)
% shaftSpeed (rad/s)
% BSFC (break specific fuel consumption, g/kW/h)
% fuelLHV (fuel lower heating value, J/g)
% efficiency (decimal 0<=eff<=1)
% FC (fuel consumption, g/s)
% maxTorque (max torque, Nm)

switch prop_name
case 'shaftTorque'
    val = em.map_trq;
case 'shaftSpeed'
    val = em.map_spd;
case 'BSFC'
    val = em.map_bsfc;
case 'fuelLHV'
    val = em.fuel_lhv;
case 'efficiency'
   val = em.map_eff;
case 'FC'
   val = em.map_fc;
case 'maxTorque'
   val = em.max_trq;
otherwise
    error([prop_name,' is not a valid asset property'])
end