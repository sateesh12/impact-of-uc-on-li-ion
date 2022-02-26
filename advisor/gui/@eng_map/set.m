function em = set(em, varargin)
% SET Set asset properties and return the updated object
% em = set(em, 'prop_name', val...)
%
% Possible Inputs for 'prop_name' (enclose in single quotes):
% shaftSpeed (rad/s)
% shaftTorque (Nm)
% BSFC (break-specific fuel consumption g/kW/h)
% fuelLHV (fuel lower heating value, J/g)
% maxTorque (Nm)
% FC (fuel consumption, g/s)
% efficiency (decimal (0<=eff<=1))

property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'shaftSpeed'
       em.map_spd = val;
       break;
    case 'shaftTorque'
       em.map_trq = val;
       break;
    case 'BSFC'
       em.map_bsfc = val;
       em.map_fc= bsfc2fc(em, em.map_trq, em.map_spd, em.map_bsfc); % g/s
       em.map_eff= bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
       break;
    case 'fuelLHV'
       em.fuel_lhv = val;
       break;
    case 'maxTorque'
       em.max_trq = val;
       break;
    case 'FC'
       em.map_fc=val;
       em.map_bsfc=fc2bsfc(em, em.map_trq, em.map_spd, em.map_fc);
       em.map_eff= bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
       break;
    case 'efficiency'
       em.map_eff=val;
       em.map_bsfc=eff2bsfc(em, em.fuel_lhv, em.map_eff);
       em.map_fc=bsfc2fc(em, em.map_trq, em.map_spd, em.map_bsfc);
       break;
    otherwise
        error('Engine Map properties: shaftSpeed [rad/s], shaftTorque [Nm], BSFC [g/kWh], fuelLHV [kJ/kg], maxTorque [Nm]')
    end
 end