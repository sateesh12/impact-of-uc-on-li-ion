function em = eng_map(varargin)
%ENG_MAP An Engine Map class.
%   em = ENG_MAP(shaft_speed,... % [rad/s]
%                shaft_brake_trq,... % [Nm]
%                Brake_Specific_Fuel_Consumption_matrix ,... % [g/kWh] indexed vertically by speed, and horizontally by trq
%                fuel_LHV,... % [J/g], lower heating value of the fuel
%                max_trq); %[Nm], the maximum torque corresponding to the shaft_speed vector
% creates an eng_map object
%
% Constructor 2:
%   em = ENG_MAP('fuel_consumption',...% dummy flag to indicate fuel consumption will be given instead of BSFC
%                shaft_speed,... % [rad/s]
%                shaft_brake_trq,... % [Nm]
%                Fuel_Consumption_matrix ,... % [g/s] indexed vertically by speed, and horizontally by trq
%                fuel_LHV,... % [J/g], lower heating value of the fuel
%                max_trq); %[Nm], the maximum torque corresponding to the shaft_speed vector
%
% Constructor 3:
%   em = ENG_MAP('fc_file_name') % the fc_file_name is the name of an ADVISOR fc file
%
% Constructor 4:
%
%   em = ENG_MAP(em_object) % creates a new eng_map object from an existing one
%
% Constructor 5:
%   em = ENG_MAP('dummyFlagOne',...% dummy flag to indicate fuel consumption will be given instead of BSFC
%                'dummyFlagTwo',...
%                shaft_speed,... % [rad/s]
%                shaft_brake_trq,... % [Nm]
%                eff_matrix ,... % [--,decimal between 0 and 1] indexed vertically by speed, and horizontally by trq
%                fuel_LHV,... % [J/g], lower heating value of the fuel
%                max_trq); %[Nm], the maximum torque corresponding to the shaft_speed vector
%
% creates an eng_map object
% METHODS AVAILABLE FOR THIS CLASS:
% buildNewMap
% set
% get
% display
% plot
% interp
% saveToFile
% diffMap
% bsfc2eff
% eff2bsfc
% bsfc2fc
% fc2bsfc
% scaleTrq
% scaleSpd
% webHelp
%
% Note: type 'methods eng_map' for the most up-to-date listing of methods available for this class
if nargin == 0
   em.map_trq = [100 200 400 600 800 1000 1200 1400 1600 1800 2000]; % (Nm)
   em.map_spd = [1200 1400 1600 1800 2000 2100]*pi/30; % (rad/s)
   em.map_bsfc= [
      256 242	220	207	201.5	198.5	197	195.5	194.5	193.5 192.5
      290 261	220	207	200	195	192.5	190.5	189.5	189.5 189.5
      302 273	224	207	198	194.5	192	190.5	189.5	189.5 189.5
      326 288	228	209	200.5	196	193.5	191.5	191.5	191.5 191.5
      316 288	238	217	207.5	203	199.5	197.5	196.5	195.5 194.5
      312 290	244	222	210.5	204.5	202.5	199.5	198.5	198   197.5]; % (g/kW*hr)
   em.map_fc=em.map_bsfc; % dummy value--calculated below
   em.fuel_lhv = 43.0*1000; % (J/g) fuel lower heating value
   em.map_eff = em.map_bsfc; % dummy value--calculated below
   em.max_trq = [1959 1883 1825 1761 1585 1510]; % Nm
   em = class(em,'eng_map');
   
   em.map_fc=bsfc2fc(em, em.map_trq, em.map_spd, em.map_bsfc); % (g/s)
   em.map_eff = bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
   
elseif (nargin==1 & isa(varargin{1},'eng_map'))
   em = varargin{1};
   
elseif (nargin==1 & isa(varargin{1},'char')) % assume we have an fc_...file
   eval(varargin{1});
   em.map_trq = fc_map_trq; % (Nm)
   em.map_spd = fc_map_spd; % (rad/s)
   em.map_bsfc= 1; % dummy value--(g/kW*hr)
   em.map_fc=fc_fuel_map; % (g/s)
   em.fuel_lhv = fc_fuel_lhv; % (J/g) fuel lower heating value
   em.map_eff = 1; % dummy value--calculated below
   em.max_trq = fc_max_trq; % Nm
   em = class(em,'eng_map');
   
   em.map_bsfc=fc2bsfc(em, em.map_trq, em.map_spd, em.map_fc); % (g/kWh)
   em.map_eff = bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
   
elseif nargin==5
   map_spd=varargin{1};
   map_trq=varargin{2};
   bsfc=varargin{3};
   lhv=varargin{4};
   max_trq=varargin{5};
   
   em.map_trq = map_trq; % (Nm)
   em.map_spd = map_spd; % (rad/s)
   em.map_bsfc= bsfc; % (g/kWh)
   em.map_fc= em.map_bsfc; % dummy value; actual value calculated below
   em.fuel_lhv = lhv; % (J/g) fuel lower heating value
   em.map_eff = em.map_bsfc; % dummy value--actual value calculated below
   em.max_trq = max_trq; % Nm
   em = class(em,'eng_map');
   
   em.map_fc=bsfc2fc(em, em.map_trq, em.map_spd, em.map_bsfc); % (g/s)
   em.map_eff = bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
   
elseif nargin==6
   map_spd=varargin{2};
   map_trq=varargin{3};
   fc=varargin{4};
   lhv=varargin{5};
   max_trq=varargin{6};
   
   em.map_trq = map_trq; % (Nm)
   em.map_spd = map_spd; % (rad/s)
   em.map_bsfc=0; % dummy value--real value calculated below
   em.map_fc=fc; % (g/s)
   em.fuel_lhv = lhv; % (J/g) fuel lower heating value
   em.map_eff = em.map_fc; % dummy value--real value calculated below
   em.max_trq = max_trq; % Nm
   em = class(em,'eng_map'); 
   
   em.map_bsfc=fc2bsfc(em, em.map_trq, em.map_spd, em.map_fc); % (g/kWh)
   em.map_eff = bsfc2eff(em, em.map_bsfc, em.fuel_lhv); % =[kJ shaft work/kJ fuel required]
   
elseif nargin==7
   map_spd=varargin{3};
   map_trq=varargin{4};
   eff=varargin{5};
   lhv=varargin{6};
   max_trq=varargin{7};
   
   em.map_trq = map_trq; % (Nm)
   em.map_spd = map_spd; % (rad/s)
   em.map_bsfc=[]; % (g/kWh), dummy value--real value calculated below
   em.map_fc=[]; % (g/s), dummy value; actual value calculated below
   em.fuel_lhv = lhv; % (J/g) fuel lower heating value
   em.map_eff = eff; % decimal between 0 and 1
   em.max_trq = max_trq; % Nm
   em = class(em,'eng_map'); 
   
   em.map_bsfc= eff2bsfc(em, em.fuel_lhv, em.map_eff); % (g/kWh)
   em.map_fc = bsfc2fc(em, em.map_trq, em.map_spd, em.map_bsfc); % =[g/s]   
else
   display('Incorrect number of inputs to constructor')
end